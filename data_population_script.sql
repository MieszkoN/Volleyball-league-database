--Define additional variables
DECLARE
    host_sports_hall varchar(255);
    host_score number;
    away_score number;
    type array_14 is varray(14) of varchar2(255);
    halls_names array_14 := array_14('Hala OSiR II', 'Hala Podpromie', 'Hala MOSiR', 'Hala widowiskowo-sportowa RCS', 'Hala widowiskowo-sportowa „Spodek”','Hala Widowiskowo-Sportowa Azoty', 'Hala Urania', 'Hala Widowiskowo-Sportowa w Jastrzębiu-Zdroju', 'Będzin Arena', 'Hala Energia im. Edwarda Najgebauera', 'Hala Nysa', 'Suwałki Arena', 'Ergo Arena', 'Hala Torwar Warszawa');
    teams_names array_14 := array_14('Aluron CMC Warta Zawiercie', 'Asseco Resovia Rzeszów', 'Cerrad Enea Czarni Radom', 'Cuprum Lubin', 'GKS Katowice', 'Grupa Azoty ZAKSA Kędzierzyn-Koźle', 'Indykpol AZS Olsztyn', 'Jastrzębski Węgiel', 'MKS Będzin', 'PGE Skra Bełchatów', 'Stal Nysa', 'Ślepsk Malow Suwałki', 'Trefl Gdańsk', 'VERVA Warszawa ORLEN Paliwa');
    type array_7 is varray(7) of varchar(255);
    main_referees_ids array_7 := array_7();
    positions array_14 := array_14('Setter', 'Setter', 'Middle Blocker', 'Middle Blocker', 'Middle Blocker', 'Middle Blocker', 'Outside Hitter', 'Outside Hitter', 'Outside Hitter', 'Outside Hitter', 'Opposite Hitter', 'Opposite Hitter', 'Libero', 'Libero');
    type array_196 is varray(196) of varchar(255);
    players_ids array_196 := array_196();
    --define host teams for the 1 half of the season, for the second I will perform necessary swaps
    host_teams array_196 := array_196(
        'Stal Nysa', 'MKS Będzin', 'Cuprum Lubin', 'Aluron CMC Warta Zawiercie', 'Asseco Resovia Rzeszów', 'Cerrad Enea Czarni Radom', 'Ślepsk Malow Suwałki',
        'Cerrad Enea Czarni Radom', 'Jastrzębski Węgiel', 'PGE Skra Bełchatów', 'Cuprum Lubin', 'Grupa Azoty ZAKSA Kędzierzyn-Koźle', 'GKS Katowice', 'Indykpol AZS Olsztyn',
        'VERVA Warszawa ORLEN Paliwa', 'PGE Skra Bełchatów', 'MKS Będzin', 'Trefl Gdańsk', 'Indykpol AZS Olsztyn', 'GKS Katowice', 'Ślepsk Malow Suwałki',
        'Stal Nysa','Asseco Resovia Rzeszów','Aluron CMC Warta Zawiercie','Cuprum Lubin','MKS Będzin','Grupa Azoty ZAKSA Kędzierzyn-Koźle','VERVA Warszawa ORLEN Paliwa',
        'PGE Skra Bełchatów','Jastrzębski Węgiel','Trefl Gdańsk','Indykpol AZS Olsztyn','GKS Katowice','Aluron CMC Warta Zawiercie','Cerrad Enea Czarni Radom',
        'Stal Nysa','Aluron CMC Warta Zawiercie','Cuprum Lubin','MKS Będzin','Grupa Azoty ZAKSA Kędzierzyn-Koźle','VERVA Warszawa ORLEN Paliwa','PGE Skra Bełchatów',
        'Jastrzębski Węgiel','Trefl Gdańsk','Indykpol AZS Olsztyn','Grupa Azoty ZAKSA Kędzierzyn-Koźle','MKS Będzin','Cerrad Enea Czarni Radom','Asseco Resovia Rzeszów',
        'Aluron CMC Warta Zawiercie','Cuprum Lubin','MKS Będzin','Ślepsk Malow Suwałki','VERVA Warszawa ORLEN Paliwa','PGE Skra Bełchatów','Jastrzębski Węgiel',
        'Trefl Gdańsk','Indykpol AZS Olsztyn','GKS Katowice','Ślepsk Malow Suwałki','Cerrad Enea Czarni Radom','MKS Będzin','Aluron CMC Warta Zawiercie',
        'Stal Nysa','MKS Będzin','Grupa Azoty ZAKSA Kędzierzyn-Koźle','VERVA Warszawa ORLEN Paliwa','PGE Skra Bełchatów','Jastrzębski Węgiel','Trefl Gdańsk',
        'Indykpol AZS Olsztyn','GKS Katowice','Ślepsk Malow Suwałki','PGE Skra Bełchatów','Asseco Resovia Rzeszów','Aluron CMC Warta Zawiercie','MKS Będzin',
        'Stal Nysa','Cuprum Lubin','VERVA Warszawa ORLEN Paliwa','PGE Skra Bełchatów','Jastrzębski Węgiel','Trefl Gdańsk','Indykpol AZS Olsztyn',
        'Stal Nysa','Cerrad Enea Czarni Radom','Asseco Resovia Rzeszów','Aluron CMC Warta Zawiercie','Jastrzębski Węgiel','MKS Będzin','VERVA Warszawa ORLEN Paliwa'
    );
    --define guest teams for the 1 half of the season, for the second I will perform necessary swaps
    away_teams array_196 := array_196(
        'Grupa Azoty ZAKSA Kędzierzyn-Koźle','VERVA Warszawa ORLEN Paliwa','PGE Skra Bełchatów','Jastrzębski Węgiel','Trefl Gdańsk','Indykpol AZS Olsztyn','GKS Katowice', 
        'Trefl Gdańsk','Asseco Resovia Rzeszów','Aluron CMC Warta Zawiercie','VERVA Warszawa ORLEN Paliwa','MKS Będzin','Stal Nysa','Ślepsk Malow Suwałki', 
        'Stal Nysa','Grupa Azoty ZAKSA Kędzierzyn-Koźle','Jastrzębski Węgiel','Cuprum Lubin','Aluron CMC Warta Zawiercie','Asseco Resovia Rzeszów','Cerrad Enea Czarni Radom', 
        'Cerrad Enea Czarni Radom','Ślepsk Malow Suwałki','GKS Katowice','Indykpol AZS Olsztyn','Trefl Gdańsk','Jastrzębski Węgiel','PGE Skra Bełchatów', 
        'Stal Nysa','VERVA Warszawa ORLEN Paliwa','Grupa Azoty ZAKSA Kędzierzyn-Koźle','MKS Będzin','Cuprum Lubin','Ślepsk Malow Suwałki','Asseco Resovia Rzeszów', 
        'Asseco Resovia Rzeszów','Cerrad Enea Czarni Radom','Ślepsk Malow Suwałki','GKS Katowice','Indykpol AZS Olsztyn','Trefl Gdańsk','Jastrzębski Węgiel', 
        'Stal Nysa','PGE Skra Bełchatów','VERVA Warszawa ORLEN Paliwa','GKS Katowice','Ślepsk Malow Suwałki','Cuprum Lubin','Aluron CMC Warta Zawiercie', 
        'Stal Nysa','Asseco Resovia Rzeszów','Cerrad Enea Czarni Radom','Grupa Azoty ZAKSA Kędzierzyn-Koźle','GKS Katowice','Indykpol AZS Olsztyn','Trefl Gdańsk', 
        'Stal Nysa','Jastrzębski Węgiel','PGE Skra Bełchatów','VERVA Warszawa ORLEN Paliwa','Grupa Azoty ZAKSA Kędzierzyn-Koźle','Asseco Resovia Rzeszów','Cuprum Lubin', 
        'Cuprum Lubin','Aluron CMC Warta Zawiercie','Asseco Resovia Rzeszów','Cerrad Enea Czarni Radom','Ślepsk Malow Suwałki','GKS Katowice','Indykpol AZS Olsztyn', 
        'Stal Nysa','Trefl Gdańsk','Jastrzębski Węgiel','Cerrad Enea Czarni Radom','VERVA Warszawa ORLEN Paliwa','Grupa Azoty ZAKSA Kędzierzyn-Koźle','Cuprum Lubin', 
        'MKS Będzin','Grupa Azoty ZAKSA Kędzierzyn-Koźle','Aluron CMC Warta Zawiercie','Asseco Resovia Rzeszów','Cerrad Enea Czarni Radom','Ślepsk Malow Suwałki','GKS Katowice',        
        'Ślepsk Malow Suwałki','GKS Katowice','Indykpol AZS Olsztyn','Trefl Gdańsk','Cuprum Lubin','PGE Skra Bełchatów','Grupa Azoty ZAKSA Kędzierzyn-Koźle'
    );
    --define results of the games
    results array_196 := array_196(
        '0:3','1:3','1:3','2:3','3:2','3:2','0:3',
        '0:3','3:0','1:3','2:3','3:0','3:2','0:3',
        '3:2','1:3','1:3','3:1','0:3','2:3','3:2',
        '2:3','1:3','3:0','0:3','2:3','3:1','3:1',
        '3:0','2:3','0:3','3:0','2:3','3:1','2:3',
        '2:3','3:0','0:3','0:3','3:1','1:3','0:3',
        '3:0','1:3','3:2','3:0','0:3','3:1','3:0',
        '1:3','3:1','1:3','0:3','3:1','3:0','3:0',
        '3:0','3:1','0:3','1:3','0:3','1:3','3:0',
        '1:3','1:3','2:3','0:3','3:0','3:0','3:1',
        '3:1','3:2','1:3','3:0','2:3','1:3','3:1',
        '2:3','1:3','0:3','2:3','3:1','3:0','3:1',
        '1:3','0:3','3:1','0:3','3:0','0:3','1:3',
        '3:0','3:0','0:3','1:3','3:0','3:1','3:1',
        '1:3','3:1','0:3','0:3','3:1','1:3','2:3',
        '2:3','3:2','3:1','2:3','3:0','3:0','0:3',
        '3:1','3:1','3:1','0:3','3:0','1:3','3:1',
        '3:0','2:3','3:0','0:3','2:3','0:3','3:0',
        '3:1','2:3','3:1','3:1','0:3','3:2','3:2',
        '3:1','1:3','3:0','1:3','3:0','3:0','0:3',
        '2:3','3:1','3:0','3:1','0:3','0:3','1:3',
        '0:3','3:2','3:1','3:2','3:0','3:0','3:1',
        '3:2','3:2','0:3','1:3','1:3','2:3','3:0',
        '3:1','3:1','3:0','1:3','1:3','0:3','3:0',
        '0:3','2:3','0:3','3:0','0:3','3:1','3:1',
        '3:1','2:3','3:1','3:1','0:3','3:0','3:0'
    );
    type array_56 is varray(56) of varchar(255);
    coach_ids array_56 := array_56();
    type array_4 is varray(4) of varchar(50);
    --defines roles for coaches which can be in the team
    roles_names array_4 := array_4('Main coach', 'Assistant', 'Statistician', 'Physical preparation coach');
    type array_numbers is varray(14) of number;
    --define points scored by each team
    points array_numbers := array_numbers(43, 46, 24, 30, 33, 70, 34, 56, 7, 48, 24, 36, 50, 45);
    --define wins array of each team
    wins array_numbers := array_numbers(15, 17, 8, 10, 11, 23, 11, 20, 2, 15, 5, 12, 17, 16);
    --define array of losses for the each team
    losses array_numbers := array_numbers(11, 9, 18, 16, 15, 3, 15, 6, 24, 11, 21, 14, 9, 10);
BEGIN
--clear tables data
DELETE FROM training;
DELETE FROM game;
DELETE FROM main_referee;
DELETE FROM coach;
DELETE FROM player;
DELETE FROM team;
DELETE FROM sports_hall;

main_referees_ids.extend(7);
-- Populate main referee with data
FOR i IN 1..7
LOOP
    main_referees_ids(i) := DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(15, 15)); 
    INSERT INTO main_referee(id, first_name, last_name, age, license) 
    VALUES (
        main_referees_ids(i),
        DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(3, 20)),
        DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(3, 20)),
        DBMS_RANDOM.VALUE(40, 60), 
        DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(1, 15))
    );
END LOOP;

-- Populate sports hall with data
FOR i IN 1..14
LOOP
    INSERT INTO sports_hall(name, city, street, capacity) 
    VALUES (
        halls_names(i),
        DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(3, 40)),
        DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(3, 25)),
        DBMS_RANDOM.VALUE(10000, 15000)
    );
END LOOP;

-- Populate team with data
FOR i IN 1..14
LOOP
    INSERT INTO team(name, website, points, main_sponsor, sports_hall_name, matches_won, matches_lost) 
    VALUES (
        teams_names(i),
        DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(50, 255)),
        points(i),
        DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(10, 100)),
        halls_names(i),
        wins(i),
        losses(i)
    );
END LOOP;

players_ids.extend(196);
-- Populate player with data
FOR i IN 1..196
LOOP
    players_ids(i) := CONCAT(DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(12, 12)),TO_CHAR(i));
    INSERT INTO player(id, first_name, last_name, shirt_number, position, age, team_name) 
    VALUES (
        players_ids(i),
        DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(3, 20)),
        DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(3, 20)),
        MOD(i,14)+1,
        positions(MOD(i,14)+1),
        DBMS_RANDOM.VALUE(18, 40),
        teams_names(CEIL(i/14))
    );
END LOOP;

coach_ids.extend(56);
-- Populate player with data
FOR i IN 1..56
LOOP
    coach_ids(i) := CONCAT(DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(12, 12)),TO_CHAR(i));
    INSERT INTO coach(id, first_name, last_name, age, role, team_name) 
    VALUES (
        coach_ids(i),
        DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(3, 20)),
        DBMS_RANDOM.STRING('A', DBMS_RANDOM.VALUE(3, 20)),
        DBMS_RANDOM.VALUE(30, 60),
        roles_names(MOD(i,4)+1),
        teams_names(CEIL(i/4))
    );
END LOOP;


host_teams.extend(91);
away_teams.extend(91);
-- Populate game with data
FOR i IN 1..182
LOOP
    --Assign host team sports hall basing on the value of the given host_team
    CASE host_teams(i)
        WHEN teams_names(1) THEN host_sports_hall := halls_names(1); 
        WHEN teams_names(2) THEN host_sports_hall := halls_names(2);
        WHEN teams_names(3) THEN host_sports_hall := halls_names(3); 
        WHEN teams_names(4) THEN host_sports_hall := halls_names(4);
        WHEN teams_names(5) THEN host_sports_hall := halls_names(5); 
        WHEN teams_names(6) THEN host_sports_hall := halls_names(6);
        WHEN teams_names(7) THEN host_sports_hall := halls_names(7); 
        WHEN teams_names(8) THEN host_sports_hall := halls_names(8);
        WHEN teams_names(9) THEN host_sports_hall := halls_names(9); 
        WHEN teams_names(10) THEN host_sports_hall := halls_names(10);
        WHEN teams_names(11) THEN host_sports_hall := halls_names(11); 
        WHEN teams_names(12) THEN host_sports_hall := halls_names(12);
        WHEN teams_names(13) THEN host_sports_hall := halls_names(13); 
        ELSE host_sports_hall := halls_names(14);
    END CASE;
    
    --Create second round of games - revenges host_team becomes away_team
    --We need to have 2 type of games team1 vs team2 and team2 vs team1
    IF i < 92 THEN
        host_teams(i+91) := away_teams(i);
        away_teams(i+91) := host_teams(i);
    END IF;
    
    --Calculate score of the team basing on the result of the match
    -- 3 points for winning 3:0, 3:1 for host team and 0 points for away team
    -- 0 points for losing 0:3, 1:3 for host team and 3 points for away team
    -- 2 points for winning 3:2 for the host team and 1 point for away team
    -- 1 point for losing 2:3 for the host team and 2 points for away team
    IF SUBSTR(results(i),1,1) = '2' THEN
        host_score := 1;
        away_score := 2;
    ELSIF SUBSTR(results(i),3,3) = '2' THEN
        host_score := 2;
        away_score := 1;
    ELSIF SUBSTR(results(i),1,1) = '3' THEN
        host_score := 3;
        away_score := 0;
    ELSE
        host_score := 0;
        away_score := 3;
    END IF;
    INSERT INTO game(game_number, "Date", attendance, host_score, guest_score, result, host_team_name, guest_team_name, main_referee_id, sports_hall_name) 
    VALUES (
        i,
        To_date(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2020-10-01','J') ,TO_CHAR(DATE '2021-05-31','J'))), 'J'),
        DBMS_RANDOM.VALUE(1000, 9999),
        host_score,
        away_score,
        results(i),
        host_teams(i),
        away_teams(i),
        main_referees_ids(MOD(i,7)+1),
        host_sports_hall
    );
END LOOP;

--Insert values into training table
FOR i IN 1..196
LOOP
    FOR j IN 1..4
    LOOP
        INSERT INTO training(coach_id, player_id) 
        VALUES (
            coach_ids(j),
            players_ids(i)
        );
    END LOOP;
END LOOP;
END;
