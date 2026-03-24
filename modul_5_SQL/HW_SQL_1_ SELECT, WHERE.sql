## **Вибірка даних (`SELECT`)**
#1. Виведіть список усіх назв категорій товарів (таблиця `categories`).
SELECT category_name 
FROM categories;

#2. Отримайте імена та прізвища всіх працівників (таблиця `employees`).
SELECT first_name, last_name 
FROM employees;


#3. Покажіть усі поля про товари (таблиця `products`).
SELECT * 
FROM products;


#4. Виведіть назву компанії та місто всіх клієнтів (таблиця `customers`).
SELECT company_name, city 
FROM customers;


###
## 🔹 **Фільтрація результатів (`WHERE`)**

#1. Виведіть усі товари, що коштують понад 33 за одиницю.
SELECT *
FROM products
WHERE unit_price > 33;


#2. Знайдіть усіх клієнтів з країн `Germany` та `Spain`.
SELECT *
FROM customers
WHERE country = '`Germany' OR country = 'Spain';
#OR
SELECT * 
FROM customers 
WHERE country IN ('Germany', 'Spain');


#3. Покажіть товари, які не зняті з продажу (`discontinued = 0`) і мають залишок на складі понад 10.
SELECT product_name, units_in_stock 
FROM products 
WHERE discontinued = 0 AND units_in_stock > 10;


#4. Знайдіть працівників, **не з США**.
SELECT last_name, first_name, country
FROM employees
WHERE country != 'USA';


#5. Виведіть усіх клієнтів, у яких значення поля `region` **не задане** (`IS NULL`).
SELECT * FROM customers
WHERE region IS NULL;


#6. Знайдіть товари, ціна яких **між 20 і 50 включно**.
SELECT product_name, unit_price
FROM products
WHERE unit_price >= 20 AND unit_price <= 50;
#OR
SELECT product_name, unit_price 
FROM products 
WHERE unit_price BETWEEN 20 AND 50;


#7. Отримайте список клієнтів, **імена контактів яких починаються на "С"**.
SELECT *
FROM customers 
WHERE contact_name LIKE 'C%';