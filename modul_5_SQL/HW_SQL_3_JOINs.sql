#1. Виведіть список усіх замовлень з ID замовлення, іменем та прізвищем працівника, який його обробив.
SELECT o.order_id, e.last_name, e.first_name
FROM orders o left join employees e 
on o.employee_id = e.employee_id; 



#2. Виведіть замовлення разом з датою, ID замовлення і назвою компанії клієнта. Відфільруйте лише замовлення зроблені в жовтні. Відсортуйте за зростанням дати.

#??? замовлення= order_details ? order_id -> product_id, quantity
SELECT o.order_id, o.order_date, c.company_name
FROM orders o
	LEFT JOIN customers c
	ON o.customer_id = c.customer_id
WHERE strftime('%m', o.order_date) = '10'
ORDER BY o.order_date ASC;



#3. Виведіть назви товарів разом з назвою постачальника та його регіоном, але лише для тих постачальників, які знаходяться в регіонах "North America" або "Western Europe". Відсортуйте результат за назвою постачальника у зростаючому порядку.
SELECT p.product_name, s.company_name, s.region
FROM products p 
	LEFT JOIN suppliers s
	ON p.supplier_id = s.supplier_id
WHERE s.region IN ('North America', 'Western Europe')
ORDER BY s.company_name ASC;



#4. Виведіть список товарів, які коли-небудь були замовлені в магазині, та для кожного товару виведіть:
#- назву товару
#- кількість замовлень, у яких цей товар зустрічається (`n_orders`)
#- загальну кількість одиниць цього товару в усіх замовленнях (`sum_quantity`)
#Відсортуйте результат за кількістю замовлень у зростаючому порядку.
SELECT od.product_id, p.product_name,
	COUNT(DISTINCT od.order_id) as 'n_orders',
	SUM(od.quantity) as 'sum_quantity'
FROM order_details od 
	LEFT JOIN products p
	ON od.product_id = p.product_id
GROUP BY od.product_id
ORDER BY n_orders ASC;



#5. Виведіть кількість замовлень для кожного клієнта, виведіть назву клієнта, кількість замовлень та відфільтруйте лише тих клієнтів, в кого замовлень більше 7.
SELECT o.customer_id, c.company_name,
	COUNT(DISTINCT o.order_id) as n_orders
FROM orders o 
	LEFT JOIN  customers c 
    ON o.customer_id = c.customer_id
GROUP BY o.customer_id
HAVING n_orders > 7
ORDER BY n_orders ASC;



#6. Виведіть імена та прізвища працівників, які працюють у територіях, назва яких **починається** з "Santa". Використовуйте таблиці `employees`, `employee_territories` та `territories`. Якщо ви не знате, де взяти якесь з полів - зверніться до схеми бази даних.
SELECT 
    e.first_name,
    e.last_name,
    t.territory_description
FROM employees e
LEFT JOIN employee_territories et 
    ON e.employee_id = et.employee_id
LEFT JOIN territories t
    ON et.territory_id = t.territory_id
WHERE t.territory_description LIKE 'Santa%'
ORDER BY e.last_name;



#7. Виведіть товари з ціною понад 20 за одиницю разом із ціною на одиницю і назвою постачальника.
SELECT p.product_name, p.unit_price, 
    s.company_name AS supplier
FROM products p
JOIN suppliers s
    ON p.supplier_id = s.supplier_id
WHERE p.unit_price > 20
ORDER BY p.product_name;



#8. Виведіть категорії, в яких є більше ніж 5 товарів, і вкажіть кількість цих товарів.
SELECT c.category_name,
	COUNT(DISTINCT p.product_id) AS quantity_in_category
FROM products p
	JOIN categories c
	ON 	p.category_id = c.category_id
GROUP BY p.category_id, c.category_name
HAVING COUNT(DISTINCT p.product_id) > 5
ORDER BY quantity_in_category ASC;


#9. Виведіть імена, прізвища та дату найму працівників, які були найняті у 2013 році, а також імена та прізвища їхніх керівників
SELECT e.last_name, e.first_name, e.hire_date,
	man.last_name AS manager_last_name,
    man.first_name AS manager_first_name
FROM employees e
	JOIN employees man
	ON e.reports_to = man.employee_id
WHERE strftime('%Y', e.hire_date) = '2013'
ORDER BY e.last_name ASC; 










