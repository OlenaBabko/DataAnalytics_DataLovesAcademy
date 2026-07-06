#В цьому ДЗ ми імітуємо ситуації на співбесіді, де ви пишете SQL запит без доступу до бази і зручного редактора просто в Google Docs.
#Власне, це завдання побудоване таким чином, що у вас немає бази, до якої можна зробити запити. Є опис таблиць і опис завдання. 
#Вам необхідно написати свої запити. Тут вам знадобляться функції роботи з датами. Найкраще їх пригадати з документації:
#https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.html


##1. Є таблиця sales зі стовпцями:
#- sale_id (ідентифікатор продажу)
#- product (назва товару)
#- amount (сума продажу)
#**Питання:**
#Порахуйте загальну суму продажів (amount) для кожного товару (product).
SELECT
    product,
    SUM(amount) AS total_sales
FROM sales
GROUP BY product;


#ВАРІАНТ 2:

WITH amount_cte as (
	SELECT
  		product,
  		SUM(amount) AS total_sales
    FROM sales
  	GROUP BY product
)
SELECT
	product,
	total_sales
FROM amount_cte
ORDER BY product DESC;



#2. ****Є таблиця orders зі стовпцями:
#- order_id (ідентифікатор замовлення)
#- customer_id (ідентифікатор клієнта)
#- amount (сума замовлення)
#**Питання:**
#Знайдіть клієнтів (customer_id), які зробили замовлень на суму понад 1000.
SELECT 
    customer_id,
    SUM(amount) AS total_amount
FROM orders
GROUP BY customer_id
HAVING SUM(amount) > 1000
ORDER BY total_amount DESC;



#3. Є таблиця transactions зі стовпцями:
#- transaction_id (ідентифікатор транзакції)
#- customer_id (ідентифікатор клієнта)
#- amount (сума транзакції)
#- status (статус: 'completed', 'failed')
#**Питання:**
#Порахуйте загальну суму успішних транзакцій (status = 'completed') для кожного клієнта, але покажіть тільки клієнтів, які здійснили транзакцій на суму понад 500.
SELECT 
    customer_id,
    SUM(amount) AS total_amount
FROM transactions
WHERE status = 'completed'
GROUP BY customer_id
HAVING SUM(amount) > 500
ORDER BY total_amount DESC;



#4. Є таблиця transactions зі стовпцями:
#- transaction_id (ідентифікатор транзакції)
#- transaction_date (дата транзакції)
#- amount (сума транзакції)
#**Питання:**
#Порахуйте загальну суму транзакцій за кожен місяць і відобразіть лише ті місяці, де загальна сума транзакцій перевищує 1000.
SELECT 
    strftime('%Y', transaction_date) AS year,
    strftime('%m', transaction_date) AS month,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY year, month
HAVING SUM(amount) > 1000
ORDER BY year, month;



#5. Є таблиця orders зі стовпцями:
#- order_id (ідентифікатор замовлення)
#- customer_id (ідентифікатор клієнта)
#- region (регіон клієнта)
#- amount (сума замовлення)
#- status (статус: 'completed', 'pending')
#**Питання:**
#Порахуйте загальну суму успішних замовлень (status = 'completed') для кожного регіону (region) і клієнта (customer_id). Виведіть лише ті пари регіон-клієнт, де загальна сума замовлень перевищує 2000.
SELECT
	region,
	customer_id,
	SUM(amount) as total_in_region
FROM orders
WHERE status ='completed' 
GROUP BY region, customer_id
HAVING SUM(amount) > 2000
ORDER BY total_in_region DESC;




#6. У вас є таблиця transactions зі стовпцями:
#- transaction_id (унікальний ідентифікатор транзакції)
#- customer_id (ідентифікатор клієнта)
#- amount (сума транзакції)
#- transaction_date (дата транзакції)
#- status (статус транзакції: 'completed', 'failed', 'pending')
#**Запитання:**
#Напишіть запит, щоб отримати список клієнтів, які здійснили успішні транзакції (status='completed') на суму понад 1000 за поточний місяць.
SELECT 
	customer_id,
	SUM(amount) AS total_trans
FROM transactions
WHERE status = 'completed'
	AND strftime('%Y-%m', transaction_date) = strftime('%Y-%m', 'now')
GROUP BY customer_id, 
HAVING SUM(amount) > 1000
ORDER BY total_trans DESC;




#7. Є таблиці:
#- customers: (customer_id, customer_name, region)
#- accounts: (account_id, customer_id, balance)
#**Запитання:**
#Напишіть SQL-запит, щоб отримати імена клієнтів та загальний баланс їхніх рахунків для клієнтів із регіону 'Kyiv'.
SELECT
	c.customer_name,
	SUM(a.balance) AS total_balance,
	c.region
FROM customers c
JOIN accounts a
	ON c.customer_id = a.customer_id
WHERE c.region =  'Kyiv'
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_name ASC;



#8. Є ****таблиця transactions:
#- transaction_id
#- customer_id
#- amount
#- transaction_date
#**Запитання:**
#Знайдіть клієнтів, які здійснили транзакції з сумою більшою, ніж середня сума всіх транзакцій.
SELECT
	customer_id,
	SUM(amount) AS total_cust_trans
FROM transactions
GROUP BY customer_id
HAVING SUM(amount) > (
	SELECT AVG(amount)
	FROM transactions
)
ORDER BY SUM(amount) DESC;



#9. Є таблиця transactions зі стовпцями:
#- transaction_id (унікальний ідентифікатор транзакції)
#- customer_id (ідентифікатор клієнта)
#- transaction_date (дата транзакції)
#**Питання:**
#Знайдіь пари клієнтів, які здійснили транзакції в один і той самий день (без дублювання пар).
SELECT
    t1.customer_id AS cust_1,
    t2.customer_id AS cust_2,
    t1.transaction_date
FROM transactions t1
JOIN transactions t2
    ON t1.transaction_date = t2.transaction_date
    AND t1.customer_id < t2.customer_id
ORDER BY t1.transaction_date, t1.customer_id, t2.customer_id;



#10. Є таблиця employees зі стовпцями:
#- employee_id (унікальний ідентифікатор співробітника)
# name (ім'я співробітника)
#- salary (зарплата співробітника)
#**Питання:**
#Напишіть SQL-запит, щоб знайти пари співробітників із однаковими зарплатами.
SELECT
	e1.name AS employee_1,
	e2.name AS employee_2,
	e1.salary
FROM employees e1
JOIN employees e2
	ON e1.salary = e2.salary
	AND e1.employee_id < e2.employee_id 
ORDER BY e1.salary, e1.name, e2.name;