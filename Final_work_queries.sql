/*
*Schema (PostgreSQL v10.0)*

В рамках проекта был взят учебный пример http://htsql.org/doc/tutorial.html и упрощен под мою задачу. Были созданы 4 таблицы:

1) Школа: id, Название школы и принадлженость к университету
2) Учебное направление (образовательный департамент): id, Название департемента, Соответсвующий id школы для каждого департамента.
3) Учебная программа: Id школы, Название программы, соответсвующий Id курса
4) Курсы: Id ответственного департамента, Название курса, Id курса, Кредит (пусть будет стоимость обучения)

Схема базы данных - на мой взгляд это "снежинка"
Таблицы связаны по Id. Foreign Key

*/

    CREATE TABLE school (
        school_id INT PRIMARY KEY,
        school_name   VARCHAR(40) NOT NULL UNIQUE,
        campus VARCHAR(40) NOT NULL
    );

    insert into school values
    ('11', 'Abbey College', 'Pepperdine'),
    ('12', 'College Du Leman', 'Manoa'),
    ('13', 'Montreux','Lewis'),
    ('14', 'Broward', 'Virginia'),
    ('15', 'Windermere', 'Princeton'),
    ('16', 'CATS College', 'Harvard');


    CREATE TABLE departments (
        dept_id INT,
        dept_name   VARCHAR(40) NOT NULL,
        school_id INT ,
        PRIMARY KEY (dept_id),
      	FOREIGN KEY (school_id) REFERENCES school (school_id)
    );

    insert into departments values
    ('1', 'Therapy', '11'),
    ('2', 'Neurology', '12'),
    ('3', 'Cardiology','13'),
    ('4', 'Gastroenterology', '14'),
    ('5', 'Hematology', '15'),
    ('6', 'Oncology', '16');

    ;

    CREATE TABLE programm (
        school_code INT,
        title VARCHAR(40) NOT NULL,
        programm_id  INT,
        course_id  INT,
        PRIMARY KEY (school_code, programm_id),
      	FOREIGN KEY (school_code)  REFERENCES school (school_id)
    );

    insert into programm values
    ('11', 'Medicine', '1', '111'),
    ('12', 'Social_Sciences', '2', '112'),
    ('13', 'Chemistry','3', '117'),
    ('14', 'Geosciences', '4', '114'),
    ('15', 'Informatics', '5', '114'),
    ('11', 'Political', '6', '116'),
    ('12', 'Anthropology', '7', '112'),
    ('12', 'Economics','8', '113'),
    ('13', 'Physics', '9', '113'),
    ('14', 'Technology', '10', '114'),
    ('13', 'Culture', '11', '115'),
    ('12', 'History', '12', '115'),
    ('12', 'Archaeology','13', '115'),
    ('12', 'Philosophy', '14', '112'),
    ('15', 'Musicology', '15', '115'),
    ('13', 'Nutrition','16', '118'),
    ('13', 'Health', '17', '118'),
    ('11', 'Gender', '18', '112'),
    ('11', 'Norwegian_language', '19', '115'),
    ('11', 'Pharmacy', '20', '111');

    CREATE TABLE course (
        dept_code INT ,
        course_name VARCHAR(40) NOT NULL,
        course_id  INT,
      	credit BIGINT,
        PRIMARY KEY (dept_code, course_id),
      	FOREIGN KEY (dept_code)  REFERENCES departments (dept_id)
    );

    insert into course values
    ('1', 'Medicine', '111', 5000),
    ('2', 'Sociology', '112', 6000),
    ('3', 'Math','113', 3000),
    ('4', 'Digital', '114', 4500),
    ('5', 'Culture', '115', 5500),
    ('6', 'Politology', '116', 8700);

---

/*
*Query #1*
Первым запросом считаем общую стоимость имеющихся у нас курсов
*/

    select SUM (course.credit)from course;

| sum   |
| ----- |
| 32700 |

---
/*
*Query #2*

Вторым запросом мы считаем кол-во образовательных программ в каждой из школ, делаем присоединение таблицы Программы к таблице Школ.

*/

    (
     SELECT
       school.school_name,
         COUNT (DISTINCT title) as Programm_count
     FROM school
       LEFT JOIN programm
       ON school.school_id = programm.school_code
      GROUP BY school.school_name
       );

| school_name      | programm_count |
| ---------------- | -------------- |
| Abbey College    | 5              |
| Broward          | 2              |
| CATS College     | 0              |
| College Du Leman | 6              |
| Montreux         | 5              |
| Windermere       | 2              |

---
/*
*Query #3*
Данным запросом мы считаем кол-во программ в университете, дполнительно выводим название школы соотв. Университету. 
Условием выборки показываем данные где кол-во программ более 2-х.

*/

    SELECT
         school.campus,
       school.school_name,
         COUNT (title)  as Programm_count
     FROM school
       LEFT JOIN programm
     ON school.school_id = programm.school_code
       GROUP BY school.school_name, school.campus
       HAVING COUNT (title)>2
       ;

| campus     | school_name      | programm_count |
| ---------- | ---------------- | -------------- |
| Lewis      | Montreux         | 5              |
| Manoa      | College Du Leman | 6              |
| Pepperdine | Abbey College    | 5              |

---
/*
*Query #4*

В базе данных нам необходимо найти Название школы, университет и образовательный департемент 
где есть учебные программы связанные с Норвегией. Дополнительно к таблице Школа присоединяем данные из таблиц Программы и Департамент.

*/

    SELECT
        school.school_name,
        school.campus,
        departments.dept_name
    FROM school
       LEFT JOIN programm
       ON school.school_id = programm.school_code
       LEFT JOIN departments
       ON school.school_id = departments.school_id
    WHERE
        title like '%Norw%'
    ;

| school_name   | campus     | dept_name |
| ------------- | ---------- | --------- |
| Abbey College | Pepperdine | Therapy   |

---
/*
*Query #5*
Считаем общее кол-во Школ, Программ, Департементов имеющихся в нашей базе.

*/

    SELECT
        COUNT (DISTINCT school.school_id) as schools,
        COUNT (DISTINCT programm.programm_id) as programms,
        COUNT (DISTINCT departments.dept_id) as departments
    FROM school
       LEFT JOIN programm
       ON school.school_id = programm.school_code
       LEFT JOIN departments
       ON school.school_id = departments.school_id
    ;

| schools | programms | departments |
| ------- | --------- | ----------- |
| 6       | 20        | 6           |

---
/*
*Query #6*
Проверяем есть ли у нас в базе, в таблице Программы, курсы по которым нет названия Курса и не присвоен соотв. Департамент


*/

    SELECT *
    FROM programm
       LEFT JOIN course
       ON programm.course_id = course.course_id
    WHERE course.course_id IS NULL
      ;

| school_code | title     | programm_id | course_id | dept_code | course_name | course_id | credit |
| ----------- | --------- | ----------- | --------- | --------- | ----------- | --------- | ------ |
| 13          | Chemistry | 3           | 117       |           |             |           |        |
| 13          | Nutrition | 16          | 118       |           |             |           |        |
| 13          | Health    | 17          | 118       |           |             |           |        |

---
/*
*Query #7*
Выводим данные по образовтельным программам. 
Проверяем что все данные в базе имеют данные. Видим что в нашей базе по департементу Oncology  нет данных. 

*/

    SELECT
        school.school_name,
        school.campus,
        departments.dept_name,
        programm.title
    FROM school
       right JOIN programm
       ON school.school_id = programm.school_code
       right JOIN departments
       ON school.school_id = departments.school_id
    ;

| school_name      | campus     | dept_name        | title              |
| ---------------- | ---------- | ---------------- | ------------------ |
| Abbey College    | Pepperdine | Therapy          | Pharmacy           |
| Abbey College    | Pepperdine | Therapy          | Norwegian_language |
| Abbey College    | Pepperdine | Therapy          | Gender             |
| Abbey College    | Pepperdine | Therapy          | Political          |
| Abbey College    | Pepperdine | Therapy          | Medicine           |
| College Du Leman | Manoa      | Neurology        | Philosophy         |
| College Du Leman | Manoa      | Neurology        | Archaeology        |
| College Du Leman | Manoa      | Neurology        | History            |
| College Du Leman | Manoa      | Neurology        | Economics          |
| College Du Leman | Manoa      | Neurology        | Anthropology       |
| College Du Leman | Manoa      | Neurology        | Social_Sciences    |
| Montreux         | Lewis      | Cardiology       | Health             |
| Montreux         | Lewis      | Cardiology       | Nutrition          |
| Montreux         | Lewis      | Cardiology       | Culture            |
| Montreux         | Lewis      | Cardiology       | Physics            |
| Montreux         | Lewis      | Cardiology       | Chemistry          |
| Broward          | Virginia   | Gastroenterology | Technology         |
| Broward          | Virginia   | Gastroenterology | Geosciences        |
| Windermere       | Princeton  | Hematology       | Musicology         |
| Windermere       | Princeton  | Hematology       | Informatics        |
|                  |            | Oncology         |                    |

---
/*
*Query #8*
Считаем среднее значение имеющихся программ в разрезе каждой школы. 

*/

    with tmp_table
    AS (
    	SELECT school_code, COUNT(title) as count_prog
    	FROM programm
    	GROUP BY school_code
    )
    SELECT
    	  school_name,
        AVG (count_prog) as avg_prog
      FROM school
        LEFT JOIN tmp_table
        ON school.school_id = tmp_table.school_code
        GROUP BY school_code, school_id
    ;

| school_name      | avg_prog           |
| ---------------- | ------------------ |
| Montreux         | 5.0000000000000000 |
| Windermere       | 2.0000000000000000 |
| CATS College     |                    |
| Abbey College    | 5.0000000000000000 |
| College Du Leman | 6.0000000000000000 |
| Broward          | 2.0000000000000000 |

---
/*
*Query #9*
Эксперементальный запрос, которым можно вывести информацию которая будет легко читаться:
Например: 5 учебных программ имеется на курсе Культорология
в  запросе группировку делаем по названию курса, сортировка от большего к меньшему по кол-ву программ 

*/

    SELECT
    	'For  ',
        count(title) as "No.of Programm",
    	'Programm(s)',
        '   in  ',
    	course_name
    FROM programm
       LEFT JOIN departments
       ON programm.school_code = departments.school_id
        LEFT JOIN course
       ON programm.course_id = course.course_id
    GROUP BY course_name
    ORDER BY count(title) DESC
    ;

| ?column? | No.of Programm | ?column?    | ?column? | course_name |
| -------- | -------------- | ----------- | -------- | ----------- |
| For      | 5              | Programm(s) |    in    | Culture     |
| For      | 4              | Programm(s) |    in    | Sociology   |
| For      | 3              | Programm(s) |    in    | Digital     |
| For      | 3              | Programm(s) |    in    |             |
| For      | 2              | Programm(s) |    in    | Medicine    |
| For      | 2              | Programm(s) |    in    | Math        |
| For      | 1              | Programm(s) |    in    | Politology  |

---
/*
*Query #10*
Суть запроса я понял, видимо что-то в синтаксиме не разобрался, в моем представлении Credin_rank должен выаодиться от 1 до 6 в моем случае.
У меня не так.

*/

    SELECT
      course_name, course_id, credit,
     ROW_NUMBER() OVER (PARTITION BY course_id ORDER BY credit DESC) as credit_rank
    FROM (
        SELECT DISTINCT
            course_name, course_id, credit
        FROM course
    ) as sample
    ORDER BY
        course_id,
        credit DESC,
        credit_rank
    ;

| course_name | course_id | credit | credit_rank |
| ----------- | --------- | ------ | ----------- |
| Medicine    | 111       | 5000   | 1           |
| Sociology   | 112       | 6000   | 1           |
| Math        | 113       | 3000   | 1           |
| Digital     | 114       | 4500   | 1           |
| Culture     | 115       | 5500   | 1           |
| Politology  | 116       | 8700   | 1           |

---
/*
*Query #11*

Выводим 2 максимальных курса по стоимости 

*/

    SELECT
      course_name,
      course_id,
      MAX (credit) as max_credit
    FROM course
    GROUP BY
    	course_name,
      	course_id
    ORDER BY  MAX (credit) DESC
    LIMIT 2;

| course_name | course_id | max_credit |
| ----------- | --------- | ---------- |
| Politology  | 116       | 8700       |
| Sociology   | 112       | 6000       |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/4w9td1n2ydbRtKapN1dHiM/0)
