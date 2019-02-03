SELECT 'ФИО: Скурихин Сергей';
-- первый запрос
SELECT * FROM ratings LIMIT 10;
-- второй запрос
SELECT * FROM links
WHERE
    movieid between 100 and 1000
    AND imdbid LIKE '%42'
    LIMIT 10;
-- СЛОЖНЫЕ ВЫБОРКИ
-- третий запрос
SELECT imdbId
FROM links
     JOIN ratings
     ON links.movieid = ratings.movieid
WHERE rating = 5
LIMIT 10;
-- четвертый запрос
SELECT COUNT(*)
FROM links
  WHERE imdbid IS NULL;
-- пятый запрос
SELECT
    userId,
    AVG(rating) as avg_rating
  FROM public.ratings
  GROUP BY userId, rating DESC
  HAVING AVG(rating) > 3.5
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
