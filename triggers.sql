-- Mieszko Niewiarowski 300173

--DROP TRIGGER assign_referee_upon_creation;
--DROP TRIGGER compare_attendance_capacity;
--DROP TRIGGER correct_team_points_upon_game_deletion;

-- 1st trigger 
-- after insert trigger
-- When the main_referee is being inserted then assign referee to the random game 
-- When there are no game rows then do nothing
CREATE OR REPLACE TRIGGER assign_referee_upon_creation
AFTER INSERT ON main_referee
FOR EACH ROW
DECLARE 
    games_number pls_integer;
    game_counter pls_integer;
BEGIN
    SELECT COUNT (*)
    INTO games_number
    FROM game;
    IF (games_number > 0)
    THEN
        game_counter := DBMS_RANDOM.VALUE(1, games_number);
        UPDATE game
        SET main_referee_id = :NEW.id
        WHERE game_number = game_counter;
    END IF;
END;

-- Start test of trigger 1
-- Insert test records to the database to show trigger action
/
INSERT ALL 
INTO main_referee(id, first_name, last_name, age, license) 
VALUES (
    DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(15, 15)),
    'Jan',
    'Kowalski',
    DBMS_RANDOM.VALUE(40, 60), 
    'International license'
)
INTO main_referee(id, first_name, last_name, age, license) 
VALUES (
    DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(15, 15)),
    'Marcin',
    'Nowak',
    DBMS_RANDOM.VALUE(40, 60), 
    'Polish license'
)
SELECT 1 FROM DUAL;

-- Query the result of the insertion and its trigger action
/
SELECT game.game_number, main_referee.first_name, main_referee.last_name, main_referee.age, main_referee.license 
FROM game
INNER JOIN main_referee 
ON main_referee.id = game.main_referee_id
WHERE main_referee.last_name = 'Kowalski' 
OR main_referee.last_name = 'Nowak'; 


-- 2nd trigger
-- before update trigger for coach
-- before update of game check if the attendance during the game was smaller than the capacity of the sports_hall
-- throws exception if the attendance of the game is greater than the capacity
-- update is not performed and row is not affected
/
CREATE OR REPLACE TRIGGER compare_capacity_with_attendance
BEFORE UPDATE ON game
FOR EACH ROW
DECLARE
    hall_capacity pls_integer;
BEGIN
    SELECT capacity
    INTO hall_capacity
    FROM sports_hall
    WHERE name = :NEW.sports_hall_name;
    IF (:NEW.attendance > hall_capacity)
    THEN
        RAISE_APPLICATION_ERROR( -20001, 'Attendance during the game cannot be bigger than capacity of the sports hall!' );
    END IF;
END;

-- Get the details of the game and information about capacity before update
/
SELECT game.game_number, game.attendance, sports_hall.capacity, sports_hall.name
FROM game
INNER JOIN sports_hall ON sports_hall.name = game.sports_hall_name
WHERE game.game_number = 1;

-- Start test of trigger 2
-- Update 1st game in the database to show trigger action
-- Update game with attendance greater than capacity of the sports_hall
-- Expected output: raise the exception and do not update the attendance value
-- ORA-20001: Attendance during the game cannot be bigger than capacity of the sports hall!
-- exception in script output
/
UPDATE game
SET game.attendance = (SELECT capacity 
                       FROM sports_hall
                       WHERE game.sports_hall_name = sports_hall.name) + 1000
WHERE game.game_number = 1;

-- Query game 1 and sports hall data
-- Confirm that the attendance during the game is lower than capacity and value was not updated
/
SELECT game.game_number, game.attendance, sports_hall.capacity, sports_hall.name
FROM game
INNER JOIN sports_hall ON sports_hall.name = game.sports_hall_name
WHERE game.game_number = 1;

-- 3rd trigger
-- Delete trigger
-- while deleting coach rows employ temporary coach until new coach will be employed
/
CREATE OR REPLACE TRIGGER correct_team_points_upon_game_deletion
AFTER DELETE ON game
FOR EACH ROW
BEGIN    
    UPDATE team
    SET points = points - :OLD.host_score
    WHERE name = :OLD.host_team_name;
    
    UPDATE team
    SET points = points - :OLD.guest_score
    WHERE name = :OLD.guest_team_name;
END;

-- check values of points before  deleting the game
-- Expected output: 
-- Asseco Resovia Rzeszów: 46 points
-- Trefl Gdańsk: 50 points
/
SELECT name, points
FROM team
WHERE name = 'Asseco Resovia Rzeszów'
OR name = 'Trefl Gdańsk';

-- Test trigger 3
-- Delete the first game
-- While deleting the game, the points for teams should be updated
/
DELETE FROM game
WHERE game_number = 5;


-- Check whether the points scored by teams were updated
-- Expected output:
-- Asseco Resovia Rzeszów - 44 points (2 points subtracted)
-- Trefl Gdańsk - 49 points (1 point subtracted)
/
SELECT name, points
FROM team
WHERE name = 'Asseco Resovia Rzeszów'
OR name = 'Trefl Gdańsk';

