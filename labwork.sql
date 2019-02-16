
/* 
a) **Query #1**Вывести список названий департаментов и количество главных врачей в каждом из этих департаментов 
*/

    (
    SELECT 
    	Department.Name,
      	COUNT (DISTINCT Chief_doc_ig) as Chief_Doc_count
    FROM Department
      LEFT JOIN Employee
      ON Department.id = Employee.Department_id
     GROUP BY Department.Name
      );
/*
| name             | chief_doc_count |
| ---------------- | --------------- |
| Cardiology       | 2               |
| Gastroenterology | 1               |
| Hematology       | 1               |
| Neurology        | 2               |
| Oncology         | 1               |
| Therapy          | 2               |

*/

/*
b) **Query #2** Вывести список департаментов, в которых работают 3 и более сотрудников 
(id и название департамента, количество сотрудников)
*/
    (
    SELECT 
      	Department.id,
    	Department.Name,
      	COUNT (Chief_doc_ig)  as Chief_Doc_count
    FROM Department
    	LEFT JOIN Employee
    	ON Department.id = Employee.Department_id
      	GROUP BY Department.Name, Department.id
     	HAVING COUNT (Chief_doc_ig)>3
      );
/*
| id  | name       | chief_doc_count |
| --- | ---------- | --------------- |
| 3   | Cardiology | 4               |
| 1   | Therapy    | 6               |

*/

/*
c) **Query #3** Вывести список департаментов с максимальным количеством публикаций  
(id и название департамента, количество публикаций)
*/
    with dep_public as (
      SELECT Department.id as did, 
      Department.name as dname,  
      SUM (num_public) as Summary
    FROM Department
        LEFT JOIN Employee
        ON Department.id=Employee.department_id
        GROUP BY Department.name, Department.id
        ORDER BY Summary DESC
    )
    SELECT
        did,
        dname,
        Summary
    FROM dep_public
    where Summary In (SELECT MAX (Summary) FROM dep_public LIMIT 1);

/*
| did | dname      | summary |
| --- | ---------- | ------- |
| 3   | Cardiology | 43      |
| 5   | Hematology | 43      |
*/

/*
d) **Query #4** Вывести список сотрудников с минимальным количеством публикаций в своем департаменте 
(id и название департамента, имя сотрудника, количество публикаций)
*/
    with min_public as (
          SELECT Department.id as did, 
          Department.name as dname,  
          MIN (num_public) as min_public,
          Employee.Name as ename
        FROM Department
            LEFT JOIN Employee
            ON Department.id=Employee.department_id
            GROUP BY Department.name, Department.id,Employee.Name
            ORDER BY min_public DESC
        )
        SELECT
            did,
            dname,
            ename,
            min_public
        FROM min_public
        where min_public In (SELECT MIN (min_public) FROM min_public);

/*
| did | dname   | ename   | min_public |
| --- | ------- | ------- | ---------- |
| 1   | Therapy | Alexey  | 1          |
| 1   | Therapy | Klaudia | 1          |
*/


/*
e) **Query #5** Вывести список департаментов и среднее количество публикаций для тех департаментов, в которых работает более одного главного врача 
(id и название департамента, среднее количество публикаций)
*/

    with avg_public as (
          SELECT 
    	Department.id as did, 
    	Department.name as dname,  
    	AVG (num_public) as avg_public,
    	COUNT (DISTINCT Chief_doc_ig) as doc_count
     FROM Department
            LEFT JOIN Employee
            ON Department.id=Employee.department_id
            GROUP BY Department.Name, Department.id
            ORDER BY avg_public DESC
        )
        SELECT
            did,
            dname,
            avg_public
        FROM avg_public
        where doc_count >1;
/*
| did | dname      | avg_public          |
| --- | ---------- | ------------------- |
| 2   | Neurology  | 11.0000000000000000 |
| 3   | Cardiology | 10.7500000000000000 |
| 1   | Therapy    | 3.5000000000000000  |
*/
