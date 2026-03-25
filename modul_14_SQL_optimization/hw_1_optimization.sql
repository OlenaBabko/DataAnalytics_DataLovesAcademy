#EXPLAIN ANALYZE

# 1. Виберіть інформацію про співробітників, які почали працювати після 2000

SELECT MAX(hire_date)
FROM employees;			# => "2000-01-28"

# 1.A. отримати всі стовпці для цих співробітників
#EXPLAIN ANALYZE
	SELECT *
	FROM employees
	WHERE hire_date >= "2000-01-01";

# 1.B. лише стовпці emp_no та hire_date
#EXPLAIN ANALYZE
	SELECT emp_no, hire_date
	FROM employees
	WHERE hire_date >= "2000-01-01";





# 2. Виведіть emp_no співробітників із іменем "Mary".
# 2.A: Виконайте запит без індексів на стовпці first_name.
#EXPLAIN 
SELECT emp_no
FROM employees
WHERE first_name = "Mary";

# 2.B: Тепер додайте індекс до стовпця first_name та знову виконайте запит.
CREATE INDEX name_index ON employees(first_name);
#EXPLAIN 
SELECT emp_no
FROM employees
WHERE first_name = "Mary";





# 3. Об'єднайте список співробітників, прийнятих на роботу у січні 1999 року,
# із тими, хто був прийнятий у січні 2000 року.
# 3.A: Використовуйте оператор UNION для об'єднання результатів.
SELECT emp_no, hire_date
FROM employees
WHERE hire_date >= "1999-01-01" AND hire_date < "1999-02-01"
UNION
SELECT emp_no, hire_date
FROM employees
WHERE hire_date >= "2000-01-01" AND hire_date < "2000-02-01";

# 3.B: Тепер використовуйте оператор UNION ALL.
	SELECT emp_no, hire_date
	FROM employees
	WHERE hire_date >= "1999-01-01" AND hire_date < "1999-02-01"
	UNION ALL
	SELECT emp_no, hire_date
	FROM employees
	WHERE hire_date >= "2000-01-01" AND hire_date < "2000-02-01";






# 4. Завдання: Знайдіть всіх співробітників, які також є менеджерами.
# 4.A: Використовуйте підзапит для вибору emp_no з таблиці dept_manager і
# потім фільтруйте співробітників (таблиця employees )  на основі вибраних emp_no.
EXPLAIN  ANALYZE
SELECT emp_no
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM dept_manager
);



# 4.B: Замість підзапиту використовуйте операцію JOIN між таблицями employees та dept_manager.
# Підсумок: Порівняйте продуктивність обох методів і розумійте навантаження від підзапитів.
#EXPLAIN  ANALYZE
SELECT e.emp_no
FROM employees AS e
JOIN dept_manager AS dm
ON e.emp_no = dm.emp_no;






# 5. Суть завдання в тому, аби порівняти складність з точки зору оптимізатора простого 
# джойна і непростого, але який вертає менше даних. Будемо отримувати зарплати співробітників.
# 5.A: Використовуйте простий JOIN між таблицями employees та salaries аби приєднати всі зарплати до всіх співробітників.
#EXPLAIN  ANALYZE
SELECT e.emp_no, s.salary, s.from_date
FROM employees AS e
JOIN salaries AS s
ON e.emp_no = s.emp_no;


# 5.B: А тепер давайте напишемо JOIN, враховуючи лише останній запис про зарплату для кожного співробітника (наприклад,
# використовуючи GROUP BY за emp_no та сортуючи за from_date у спадаючому порядку).
WITH last_salary_cte AS (
	SELECT emp_no,  MAX(from_date) AS last_date
	FROM salaries
	GROUP BY emp_no
)
SELECT e.emp_no, s.salary, s.from_date
FROM employees AS e
JOIN salaries AS s
ON e.emp_no = s.emp_no
JOIN last_salary_cte AS lsc
ON s.emp_no = lsc.emp_no AND s.from_date = lsc.last_date;


# інший варіант:
SELECT e.emp_no,
       s.salary,
       s.from_date
FROM employees e
JOIN salaries s
    ON e.emp_no = s.emp_no
JOIN (
    SELECT emp_no, MAX(from_date) AS max_from_date
    FROM salaries
    GROUP BY emp_no
) last_salary
    ON s.emp_no = last_salary.emp_no
   AND s.from_date = last_salary.max_from_date;

