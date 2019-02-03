SELECT 'ФИО: Скурихин Сергей';
-- первый запрос SELECT, LIMIT
SELECT * FROM ratings LIMIT 10;
-- второй запрос WHERE, LIKE
SELECT * FROM links
WHERE
    movieid between 100 and 1000
    AND imdbid LIKE '%42'
    LIMIT 10;
-- СЛОЖНЫЕ ВЫБОРКИ
-- третий запрос JOIN
SELECT imdbId
FROM links
     JOIN ratings
     ON links.movieid = ratings.movieid
WHERE rating = 5
LIMIT 10;
-- четвертый запрос COUNT ()
SELECT COUNT(*)
FROM links
  WHERE imdbid IS NULL;
-- пятый запрос GROUP BY, HAVING
SELECT
    userId,
    AVG(rating) as avg_rating
  FROM public.ratings
  GROUP BY userId
  HAVING AVG(rating) > 3.5
  ORDER BY avg_rating DESC
LIMIT 10;
-- ИЕРАРХИЧЕСКИЕ ЗАПРОСЫ
-- шестой запрос
SELECT imdbId
 FROM links
 WHERE movieid IN (
   SELECT movieid
   FROM ratings
   GROUP BY movieid
   HAVING AVG(rating) > 3.5
    )
LIMIT 10; -- не знаю как сделать RANDOM
-- седьмой запрос Common Table Expressions
WITH users_table
AS (
    SELECT userid, AVG (rating) U
    FROM ratings
    GROUP BY userid
    HAVING COUNT (rating) > 10
)
SELECT
  AVG (U)
FROM users_table;
