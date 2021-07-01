CREATE TABLE game_sales (
	name TEXT,
	platform VARCHAR(10),
	year_released INT,
	genre TEXT,
	publisher TEXT,
	na_sales FLOAT,
	eu_sales FLOAT,
	jp_sales FLOAT,
	other_sales FLOAT,
	global_sales FLOAT,
	critic_score FLOAT,
	critic_count INT,
	user_score FLOAT,
	user_count INT,
	developer TEXT,
	rating TEXT
);


--Impoer our file all_games.csv into the all_games table
--Note: you may want to COPY FROM an absolute file path instead if you've saved all_sales.csv somewhere specific in your file system
COPY game_sales FROM 'all_sales.csv'
DELIMITER ','
CSV HEADER
NULL '';

--How many unique titles do we have in our dataset?
SELECT COUNT(DISTINCT(name)) FROM game_sales;


--How many different publishers do we have in our dataset?
SELECT COUNT(DISTINCT(publisher)) FROM game_sales;


--Get all titles of games published by Nintendo
SELECT name FROM game_sales
WHERE developer = "Nintendo";




--Get top 100 PS3 games released in 2011 as measured  by global sales
SELECT DISTINCT(name), global_sales FROM game_sales
WHERE year_released = 2011 AND platform = 'PS3'
ORDER BY global_sales DESC
LIMIT 100;


--Of those top 100 PS3  games, how many were published by Electronic Arts?
--Let's find this out with a nested query:

SELECT COUNT(*) FROM game_sales
WHERE name IN (
	SELECT name FROM game_sales
	WHERE year_released = 2011 AND platform = 'PS3'
	ORDER BY global_sales DESC
	LIMIT 100)	
AND publisher LIKE '%Electronic Arts%' OR publisher LIKE '%EA%';



--Find the top selling 100 games of 2016. (unique names)
--Of those games what percentage went to each platform?
--What percentage of those games had an Xbox version? What percentage had a PS4 version?

SELECT DISTINCT(name), publisher, global_sales, platform FROM game_sales
WHERE year_released = 2016
ORDER BY global_sales DESC
LIMIT 100;




--Get unique titles
SELECT * FROM game_sales
GROUP BY name
LIMIT 100;




--List all games, ordering them by descending global sales
--How much did each game sell worldwide?
--How many platforms were each of these games released on?
SELECT name, SUM(global_sales) s, COUNT(DISTINCT(platform)) FROM game_sales
GROUP BY name
ORDER BY s DESC;


--Find the subset of all entries with both a critic score and a user score
--Copy this subset to a CSV file for further data analysis

COPY (
	SELECT * FROM game_sales
	WHERE critic_score IS NOT NULL AND user_score IS NOT NULL
) TO '/tmp/games_with_scores.csv' DELIMITER ',' CSV HEADER;


