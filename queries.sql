--Check results of data population into tables 
--Uncomment to see the result
--SELECT * FROM game;
--SELECT * FROM player;
--SELECT * FROM team;
--SELECT * FROM coach;
--SELECT * FROM training;
--SELECT * FROM sports_hall;
--SELECT * FROM main_referee;



--1.Get the order during the season
SELECT name, points, matches_won, matches_lost
FROM team
ORDER BY points DESC;

--2. Query using logic operation AND in WHERE clause
-- Get teams who win at least 13 games(half number of the games) and which did not score more than 60 points
SELECT name, points, matches_won, matches_lost
FROM team
WHERE matches_won > 12
AND points <= 60
ORDER BY points ASC;

--3. Query using aggregate functions(AVG, SUM)
--Retrieve information about average attendance in sports halls during the season,
--sum of scores gained by host teams and guest teams
SELECT sports_hall_name, AVG(attendance), SUM(host_score), SUM(guest_score)
FROM game
GROUP BY sports_hall_name;

--4. Query using Group By and Having clause
--Get the age of the youngest and oldest player for each team, which average age is greater than 28
SELECT team_name, MIN(age) AS YOUNGEST_PLAYER_AGE, MAX(age) AS OLDEST_PLAYER_AGE
FROM player
GROUP BY team_name
HAVING AVG(AGE) > 28;

--5. Query using nested subquery
--Get all coaches of teams whose team won a game for 3 points as a guest team in the first round of the season
SELECT first_name, last_name, age, role, team_name
FROM coach
WHERE team_name IN (SELECT guest_team_name
                    FROM game 
                    WHERE guest_score = 3
                    AND game_number <= 13);
                    
--6. Query using correlated nested subquery
--Get information about the players from teas which lost more than 10 games 
SELECT first_name, last_name, shirt_number, age
FROM player
WHERE EXISTS (SELECT name
              FROM team
              WHERE team.name = player.team_name
              AND matches_lost >= 10);



--7. Query using join
--Select all sports hall names and their capacities for games after 01.01.2021. Get also names of teams playing in this particular game.
SELECT sports_hall.name, game.host_team_name, game.guest_team_name, sports_hall.capacity, game."Date"
FROM sports_hall
INNER JOIN game ON game.sports_hall_name = sports_hall.name
WHERE game."Date" > '2021-01-01';

