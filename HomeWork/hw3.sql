SELECT 'ФИО: Скурихин Сергей';

-- Оконные функции.

SELECT userId, movieId, rating,
	(rating - MIN(rating) OVER (PARTITION BY userId))/(MAX(rating) 
	OVER (PARTITION BY userId) - MIN(rating) 
	OVER (PARTITION BY userId)) as normed_rating,
  	AVG(rating) OVER (PARTITION BY userId) as avg_rating
FROM (
    	SELECT DISTINCT userId, movieId, rating
    	FROM ratings
    	WHERE userId <>1 LIMIT 1000
) as sample
LIMIT 30;

-- ETL

psql -c '
  CREATE TABLE IF NOT EXISTS keywords2 (
    Id bigint,
    Tags text
  );'

psql -c "\\copy  keywords2 FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER"

SELECT  COUNT(*) FROM keywords2;

-- Трансформ

WITH top_rated as (
 	SELECT movieId, AVG(rating) as avg_rating
    	FROM ratings
  	GROUP BY movieId 
 	HAVING COUNT(userid) > 50 
 	ORDER BY avg_rating DESC, movieid ASC
)
 SELECT top_rated.movieid, avg_rating, tags
 	FROM top_rated
 	JOIN keywords
 	ON top_rated.movieid=keywords.movieid
 LIMIT 150;

-- Load

 WITH top_rated as (
 SELECT movieId, AVG(rating) as avg_rating
 	FROM ratings
	GROUP BY movieId 
 	HAVING COUNT(userid) > 50 
 	ORDER BY avg_rating DESC, movieid ASC
)
 SELECT top_rated.movieid, avg_rating, tags
 	INTO top_rated_tags
 	FROM top_rated
 	JOIN keywords
 	ON top_rated.movieid=keywords.movieid
 LIMIT 150; -- result (SELECT 150)

 -- выгружаем в файл
 \copy (SELECT * FROM top_rated_tags) TO 'top_rated_tags.csv' WITH CSV HEADER DELIMITER AS E'\t'; -- результат (COPY 150) -- А ГДЕ ИСКАТЬ ЭТОТ ФАЙЛ?
