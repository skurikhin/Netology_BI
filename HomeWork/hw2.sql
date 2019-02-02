SELECT 'ФИО: Скурихин Сергей';
-- первый запрос
SELECT * FROM ratings LIMIT 10;
-- второй запрос
SELECT * FROM links
WHERE
    r1.movieid between "100" and "1000"
    AND r2.imdbld LIKE "%42"
    LIMIT 10;
-- третий запрос
SELECT * FROM links
JOIN ratings
    ON links=ratings
    WHERE imdbld = 5
