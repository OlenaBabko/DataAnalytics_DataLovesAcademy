# HW_SQL_4: Window Functions

### **1. Визначення попереднього замовлення для кожного клієнта**
#Для кожного клієнта (`customer_id`) знайдіть попереднє замовлення (`order_id`) на основі дати замовлення (`order_date`).
# Відобразіть: `customer_id`, `order_id`, `order_date`, `previous_order_id` (за допомогою `LAG`).
#**Підказка:** Тут треба використати LAG та PARTITION BY .
WITH order_lag_cte AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_id) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_id
    FROM orders
)
SELECT
    customer_id,
    order_id,
    order_date,
    previous_order_id
FROM order_lag_cte
ORDER BY customer_id, order_date;

#SOLUTION
SELECT
customer_id,
order_id,
order_date,
LAG(order_id) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_id
FROM orders;



### **2. Перше замовлення кожного клієнта**
#Для кожного клієнта (`customer_id`) знайдіть перше замовлення (`order_id`) на основі дати замовлення (`order_date`).
#Відобразіть: `customer_id`, `order_id`, `order_date`, `first_order_id`. **Підказка:** Тут треба використати `FIRST_VALUE` та `PARTITION BY` .
WITH order_lag_cte AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        FIRST_VALUE(order_id) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS first_order_id
    FROM orders
)
SELECT
    customer_id,
    order_id,
    order_date,
    first_order_id
FROM order_lag_cte
ORDER BY customer_id, order_date;

#SOLUTION
SELECT 
    customer_id, 
    order_id, 
    order_date,
    FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY order_date) AS first_order_id
FROM orders;


### **3. ТОП-3 найдорожчі замовлення у кожній категорії товарів**
#Знайдіть три найдорожчі товари (`unit_price`) у кожній категорії (`category_id`). Відобразіть: `category_id`, `category_name` - назва категорії, 
#`product_id`, `product_name`, `unit_price`, `product_rank` - тобто яке місце по дороговизні посідає цей товар з ТОП3 обраних. 
#**Підказка:** Тут треба використати `RANK` та `PARTITION BY` і ще зробити `JOIN` .
WITH product_rank_cte AS (
    SELECT
        category_id,
        product_id,
  		product_name,
        unit_price,
        RANK() OVER (
            PARTITION BY category_id
            ORDER BY unit_price DESC
        ) AS product_rank
    FROM products
)
SELECT
	prc.category_id,
	c.category_name,
	prc.product_id,
	prc.product_name,
	prc.unit_price,
	prc.product_rank
FROM product_rank_cte prc
  	JOIN categories c
  	ON prc.category_id = c.category_id
WHERE prc.product_rank <= 3
ORDER BY prc.category_id, prc.product_rank;

#SOLUTION
SELECT
	*
FROM
(SELECT 
    p.category_id,
 	c.category_name,
    product_id, 
    product_name, 
    unit_price,
    RANK() OVER (PARTITION BY p.category_id ORDER BY unit_price DESC) AS product_rank
FROM products p JOIN categories c on p.category_id = c.category_id
)
WHERE product_rank <= 3;




### **4. З яким проміжком часу користувачі роблять замовлення.**
#Покажіть різницю між датами поточного та попереднього замовлення для кожного клієнта. Відобразіть: `customer_id`, `order_id`, 
#`order_date`, `previous_order_date`, `diff_days` - різниця у днях між датами поточного і попереднього замовлень цього клієнта, **Підказка:** 
#Тут треба використати `LAG` та `PARTITION BY` . Аби обчислити різницю в днях для SQLLite використовуємо конструкцію `JULIANDAY(later_date) - JULIANDAY(earlier_date)`
WITH order_lag_cte AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_date
    FROM orders
)
SELECT
    customer_id,
    order_id,
    order_date,
    previous_order_date,
    JULIANDAY(order_date) - JULIANDAY(previous_order_date) AS diff_days
FROM order_lag_cte
ORDER BY customer_id, order_date;

#SOLUTION
select
	*,
  JULIANDAY(order_date) - JULIANDAY(previous_order_date) as diff_days
  FROM (
		SELECT 
		    customer_id, 
		    order_id, 
		    order_date,
		    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
		FROM orders
);




### **5. Середній інтервал в днях між датами замовлень клієнтів по регіонам.**
#Для кожного регіона (`region`) обчисліть середній інтервал (у днях) між послідовними замовленнями клієнтів (тобто обчислення в розрізі клієнта).
# Виведіть дані, округлені до двох знаків після коми. #**Очікувані результати:** `region` – регіон клієнта. `avg_diff_days` – середній інтервал у днях
# між замовленнями клієнтів у цьому регіоні. # Дайте відповіді на питання: В якому регіоні найчастіше клієнти роблять повторні замовлення, а в якому - найрідше?
# Чи є дані, які б допомогли вам зробити коректні висновки для цього аналізу? **Підказка:** Це завдання - ускладнення попереднього. Треба додати 1 зовнішній запит.
WITH order_lag_cte AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_date
    FROM orders
),
diff_days_cte AS (
    SELECT
        olc.customer_id,
        c.region,
        olc.previous_order_date,
        JULIANDAY(order_date) - JULIANDAY(previous_order_date) AS diff_days
    FROM order_lag_cte olc
    JOIN customers c 
        ON olc.customer_id = c.customer_id
    WHERE previous_order_date IS NOT NULL
)
SELECT
	region,
    ROUND(AVG(diff_days), 2) AS avg_diff_days
FROM diff_days_cte
GROUP BY region
ORDER BY avg_diff_days;
##В якому регіоні найчастіше клієнти роблять повторні замовлення? де avg_diff_days найменший, тобто в Northern Europe
##В якому - найрідше? де avg_diff_days найбільший, тобто в Central America.
##Але такі висновки дійсно некоректі, оскільки не враховують далеко не однакову кількість населення регіонів, і те,
##що кожен клієнт може мати різніінтервали між своїми замовленнями, а хтось зробив лише одне і тому сюди не потрапив.

#SOLUTION
SELECT region,
       round(AVG(JULIANDAY(order_date) - JULIANDAY(previous_order_date)), 2) AS avg_diff_days
FROM
  (SELECT customer_id,
          order_id,
          order_date,
          LAG(order_date) OVER (PARTITION BY customer_id
                                ORDER BY order_date) AS previous_order_date
   FROM orders) orders_custom
JOIN customers c ON orders_custom.customer_id = c.customer_id
WHERE previous_order_date IS NOT NULL
GROUP BY region
ORDER BY 2;




### **6. ТОП-3 співробітники за кількістю оброблених замовлень**
#Знайдіть трьох співробітників (`employee_id`) з найбільшою кількістю оброблених замовлень. Відобразіть: `employee_id`, `first_name`, `last_name`,
# `order_count` - кількість оброблених замовлень, `employee_rank` - місце співробітника в рейтингу (1-3)
WITH order_count_cte as (
	SELECT
  		employee_id,
  		COUNT(*) AS order_count
    FROM orders
  	GROUP BY employee_id
)
SELECT
	occ.employee_id,
    e.first_name,
    e.last_name,
    occ.order_count,
    RANK() OVER(ORDER BY occ.order_count DESC) AS employee_rank
FROM order_count_cte occ
JOIN employees e 
	ON occ.employee_id = e.employee_id
ORDER BY occ.order_count DESC
LIMIT 3;

##Якщо потрібні всі співробітники, які увійшли до ТОП-3 рангу (з урахуванням однакових значень) Тоді тільки через вкладений SELECT або другий CTE:
WITH order_count_cte as (
	SELECT
  		employee_id,
  		COUNT(*) AS order_count
    FROM orders
  	GROUP BY employee_id
),
rank_cte AS (
	SELECT
        occ.employee_id,
        e.first_name,
        e.last_name,
        occ.order_count,
        RANK() OVER(ORDER BY occ.order_count DESC) AS employee_rank
    FROM order_count_cte occ
    JOIN employees e 
        ON occ.employee_id = e.employee_id
)
SELECT *
FROM rank_cte
WHERE employee_rank <= 3;

#SOLUTION
SELECT 
    e.employee_id, 
    first_name, 
    last_name, 
    COUNT(order_id) AS order_count,
    RANK() OVER (ORDER BY COUNT(order_id) DESC) AS employee_rank
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, first_name, last_name
LIMIT 3;



### **7. ТОП-3 співробітники за кількістю оброблених замовлень у кожному регіоні**
#Для кожного регіону визначте трьох співробітників із найбільшою кількістю оброблених замовлень.
# Відобразіть: `region`, `employee_id`, `first_name` , `last_name` ,`order_count` - кількість оброблених замовлень, 
#`employee_rank` - місце співробітника в рейтингу (1-3)
WITH order_count_cte as (
	SELECT
  		employee_id,
  		COUNT(*) AS order_count
    FROM orders
  	GROUP BY employee_id
),
rank_cte AS (
	SELECT
        occ.employee_id,
        e.first_name,
        e.last_name,
  		e.region,
        occ.order_count,
        RANK() OVER(
          PARTITION BY region
          ORDER BY occ.order_count DESC) AS employee_rank
    FROM order_count_cte occ
    JOIN employees e 
        ON occ.employee_id = e.employee_id
)
SELECT *
FROM rank_cte
WHERE employee_rank <= 3;

#SOLUTION
 SELECT region,
       employee_id,
       first_name,
       last_name,
       order_count,
       employee_rank
FROM (
    SELECT 
        e.region,
        e.employee_id,
        e.first_name,
        e.last_name,
  	    COUNT(order_id) AS order_count,
        RANK() OVER (PARTITION BY e.region ORDER BY COUNT(o.order_id) DESC) AS employee_rank
    FROM orders o
    JOIN employees e ON o.employee_id = e.employee_id
	GROUP BY e.region, e.employee_id, first_name, last_name
) ranked_employees
WHERE employee_rank <= 3;

