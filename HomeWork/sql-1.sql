CREATE TABLE
films (
    title VARCHAR (25), 
    id SERIAL,
    country VARCHAR (25),
    box_office BIGINT,
    release_year TIMESTAMP
);

INSERT INTO films
    VALUES 
    ('Начало',1,'США', 825532764, '2003-7-8'::timestamp),
    ('Побег из Шоушенка',2,'США', 59841469, '1994-9-10'::timestamp);
    ('Список Шиндлера',3,'США', 321265768, '1993-11-30'::timestamp),
    ('1+1',4,'Франция', 426588510, '2011-9-23'::timestamp),
    ('Бойцовский клуб',5,'США-Германия', 100853753, '1999-9-10'::timestamp);

CREATE TABLE
persons (
    id INT, -- соответствует person_id в табличке persons2content
    fio VARCHAR (50)
);

INSERT INTO persons
    VALUES 
    (12,'Дэвид Финчер'),
    (13,'Тим Роббинс'),
    (14,'Стивен Сбилберг'),
    (15,'Омар Си'),
    (16,'Брэд Питт');

SELECT * FROM persons;


CREATE TABLE
persons2content (
    person_id INT, -- id персоны
    film_id INT, -- id контента
    person_type VARCHAR (50) -- тип персоны (актёр, режиссёр и т.д.)

);

INSERT INTO persons2content
    VALUES 
    (12,1,'режисёр'),
    (13,2,'актёр'),
    (14,3,'режисёр'),
    (15,4,'актёр'),
    (16,5,'актёр');
