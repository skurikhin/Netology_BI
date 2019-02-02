SELECT 'ФИО: Скурихин Сергей';
-- первый запрос
SELECT * FROM ratings LIMIT 10;
-- второй запрос
SELECT * FROM links
WHERE
    movieid between "100" and "1000"
    AND imdbid LIKE "%42"
    LIMIT 10;
-- третий запрос
SELECT * FROM links
JOIN ratings
    ON links=ratings
    WHERE imdbid = 5
LIMIT 10;
-- четвертый запрос
SELECT COUNT(*)
FROM links
    WHERE imdbid IS NULL;
