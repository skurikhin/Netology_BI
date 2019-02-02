SELECT 'ФИО: Скурихин Сергей';
-- первый запрос
SELECT * 
    FROM ratings 
    LIMIT 10;
-- второй запрос
SELECT * 
FROM links
WHERE
    movieid between 100 and 1000
    AND imdbid LIKE '%42'
LIMIT 10;
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
SELECT userId,
       AVG(rating) as avg_rating 
    FROM public.ratings
    GROUP BY userId
    HAVING AVG(rating) > 3.5
    ORDER BY avg_rating DESC
LIMIT 10;
