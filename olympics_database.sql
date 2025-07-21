-- Confirm data imported correctly
SELECT *
FROM athletes;

SELECT COUNT(*)
FROM athletes;

SELECT *
FROM countries;

SELECT COUNT(*)
FROM countries;

SELECT *
FROM olympics;

SELECT COUNT(*)
FROM olympics;

SELECT *
FROM results;

SELECT COUNT(*)
FROM results;

SELECT *
FROM sports;

SELECT COUNT(*)
FROM sports;

-- Range of years
SELECT MIN(year), MAX(year)
FROM olympics;

-- Top countries by medal count
SELECT countries.country, COUNT(results.medal) AS medal_count
FROM results
LEFT JOIN countries ON results.country_id = countries.country_id
GROUP BY countries.country
ORDER BY medal_count DESC
LIMIT 10;

-- Top countries by gold medal count
SELECT countries.country, COUNT(results.medal) AS gold_medal_count
FROM results
LEFT JOIN countries ON results.country_id = countries.country_id
WHERE results.medal = 'Gold'
GROUP BY countries.country
ORDER BY gold_medal_count DESC
LIMIT 10;

-- Top athletes by medal count
SELECT athletes.given_name, athletes.surname, COUNT(results.medal) AS medal_count
FROM results LEFT JOIN athletes
ON results.athlete_id = athletes.athlete_id
GROUP BY athletes.given_name, athletes.surname
ORDER BY medal_count DESC
LIMIT 10;

-- Top athletes by gold medal count
SELECT athletes.given_name, athletes.surname, COUNT(results.medal) AS gold_medal_count
FROM results
LEFT JOIN athletes ON results.athlete_id = athletes.athlete_id
WHERE results.medal = 'Gold'
GROUP BY athletes.given_name, athletes.surname
ORDER BY gold_medal_count DESC
LIMIT 10;

-- Larisa Latynina events and medals
SELECT athletes.given_name, athletes.surname, sports.sport, sports.event, results.medal
FROM results
LEFT JOIN athletes ON results.athlete_id = athletes.athlete_id
LEFT JOIN sports ON results.sport_id = sports.sport_id
WHERE athletes.given_name = 'Larisa'
AND athletes.surname = 'Latynina';

-- Michael Phelps events and medals
SELECT athletes.given_name, athletes.surname, sports.sport, sports.event, results.medal
FROM results
LEFT JOIN athletes ON results.athlete_id = athletes.athlete_id
LEFT JOIN sports ON results.sport_id = sports.sport_id
WHERE athletes.given_name = 'Michael'
AND athletes.surname = 'Phelps';

-- Michael Phelps medals by event
SELECT athletes.given_name, athletes.surname, sports.sport, sports.event, results.medal, COUNT(*) AS medal_count
FROM results
LEFT JOIN athletes ON results.athlete_id = athletes.athlete_id
LEFT JOIN sports ON results.sport_id = sports.sport_id
WHERE athletes.given_name = 'Michael'
AND athletes.surname = 'Phelps'
GROUP BY athletes.given_name, athletes.surname, sports.sport, sports.event, results.medal
ORDER BY medal_count DESC;

-- Michael Phelps running medal count by event partition by year
SELECT athletes.given_name, athletes.surname, olympics.city, olympics.year, sports.event, COUNT(results.medal) OVER (PARTITION BY olympics.year ORDER BY sports.event) AS running_medal_count
FROM results
LEFT JOIN athletes ON results.athlete_id = athletes.athlete_id
LEFT JOIN olympics ON results.olympics_id = olympics.olympics_id
LEFT JOIN sports ON results.sport_id = sports.sport_id
WHERE athletes.given_name = 'Michael'
AND athletes.surname = 'Phelps';

-- Usain Bolt athlete, country, olympics, sports, and results information
WITH cte_results AS (
SELECT athletes.given_name, athletes.surname, countries.country, olympics.city, olympics.year, sports.sport, sports.event, results.medal
FROM results
LEFT JOIN athletes ON results.athlete_id = athletes.athlete_id
LEFT JOIN countries ON results.country_id = countries.country_id
LEFT JOIN olympics ON results.olympics_id = olympics.olympics_id
LEFT JOIN sports ON results.sport_id = sports.sport_id
)
SELECT *
FROM cte_results
WHERE surname = 'Bolt';

