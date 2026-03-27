##  **Сортування (`ORDER BY`)**

#1. Виведіть список товарів, відсортованих за зростанням ціни.
SELECT product_name, unit_price
FROM products
ORDER BY unit_price ASC;



#2. Виведіть працівників у алфавітному порядку за прізвищем (таблиця `employees`).
SELECT last_name, first_name
FROM employees
ORDER BY last_name ASC;



## 🔹 **Обмеження результатів (`LIMIT`)**
#1. Виведіть **5 найдорожчих товарів**.
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 5;



#2. Покажіть **3 перших клієнтів** зі списку клієнтів, відсортованого за назвою компанії.
SELECT 	company_name
FROM customers
ORDER BY company_name ASC
LIMIT 3;



## 🔹 **Вставка, оновлення та видалення**
#1. Додайте нову категорію до таблиці `categories` , але не таку, як була в лекції.
INSERT INTO categories (category_id, category_name, description)
VALUES (100, 'Waffles', 'crispy waffles 5 different flavors');
SELECT * FROM categories;



#2. Змініть опис цієї категорії з id=1 на `Soft drinks and juices`.
UPDATE categories
SET description = 'Soft drinks and juices'
WHERE category_id = 1;
SELECT * FROM categories;



#3. Видаліть категорії з id 3 та 4 з бази.
SELECT *
FROM categories
WHERE category_id IN ('3', '4');

DELETE
FROM categories
WHERE category_id IN ('3', '4');
SELECT * FROM categories;



#4. Підвищте ціни на 10% для всіх товарів поставників з supplier_id 3, 4, 7.
UPDATE products
SET unit_price = unit_price * 1.1
WHERE supplier_id IN ('3', '4', '7');
SELECT * FROM products;



#5. Видаліть усі товари, **у яких кількість на складі = 0** (попередньо перевірте їх `SELECT`ом).
SELECT *
FROM products
WHERE units_in_stock = 0;

DELETE
FROM products
WHERE units_in_stock = 0;
SELECT * FROM products;