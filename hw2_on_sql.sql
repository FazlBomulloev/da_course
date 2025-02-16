-- Bomulloev Fazliddin

select *
from invoice  ;

-- Задание 1: Вернуть дату самой первой и самой последней покупки из таблицы invoice.
SELECT 
	MIN(invoice_date) AS first_purchase
	, MAX(invoice_date) AS last_purchase
FROM invoice;

-- Задание 2 2: Вернуть размер среднего чека для покупок из США.
SELECT 
	AVG(total) AS average_check
FROM invoice i
WHERE i.billing_country = 'USA';

-- Задание 3: Вернуть список городов, в которых имеется более одного клиента.
SELECT 
	city
FROM customer c 
GROUP BY c.city
HAVING COUNT(*) > 1;

-- Задание 4: Из таблицы customer вытащить список телефонных номеров, не содержащих скобок.
SELECT 
	phone
FROM customer
WHERE phone NOT LIKE '%(%' AND phone NOT LIKE '%)%';

-- Задание 5: Измените текст 'lorem ipsum' так, чтобы только первая буква первого слова была в верхнем регистре, а всё остальное в нижнем.
SELECT 
	INITCAP('lorem ipsum') AS formatted_text;

-- Задание 6: Из таблицы track вытащить список названий песен, которые содержат слово 'run'.
SELECT 
	name
FROM track
WHERE Lower(name) LIKE '%run%';

-- Задание 7: Вытащить список клиентов с почтовым ящиком в 'gmail'.
SELECT 
	first_name
	, last_name
	, email
FROM customer
WHERE email LIKE '%@gmail.com';

-- Задание 8: Найти произведение с самым длинным названием из таблицы track.
select *
FROM track t
ORDER BY LENGTH(name) DESC
LIMIT 1;

-- Задание 9: Посчитать общую сумму продаж за 2021 год, в разбивке по месяцам.
SELECT 
	EXTRACT(MONTH FROM invoice_date) AS month_id
	, SUM(total) AS sales_sum
FROM invoice
WHERE EXTRACT(YEAR FROM invoice_date) = 2021
GROUP BY month_id
ORDER BY month_id;

-- Задание 10: Добавить поле с названием месяца в запрос из задания 9.
SELECT 
	EXTRACT(MONTH FROM invoice_date) AS month_id
	, TO_CHAR(invoice_date, 'Month') AS month_name
	, SUM(total) AS sales_sum
FROM invoice
WHERE EXTRACT(YEAR FROM invoice_date) = 2021
GROUP BY month_id, month_name
ORDER BY month_id;

-- Задание 11: Вытащить список 3 самых возрастных сотрудников компании.
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,  -- объединение имени и фамилии
    birth_date,
    FLOOR(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birth_date)) AS age_now
FROM employee
ORDER BY age_now DESC
LIMIT 3;


-- Задание 12: Посчитать средний возраст сотрудников через 3 года и 4 месяца.
SELECT 
	AVG(FLOOR(DATE_PART('year', CURRENT_DATE) - DATE_PART('year', birth_date)) + 3 + (4 / 12)) AS avg_age_in_3_years_4_months
FROM employee;

-- Задание 13: Посчитать сумму продаж в разбивке по годам и странам, где сумма продажи больше 20. Результат отсортирован по году и сумме продажи.
SELECT 
	EXTRACT(YEAR FROM invoice_date) AS year
	, billing_country
	, SUM(total) AS sales_sum
FROM invoice
GROUP BY year, billing_country
HAVING SUM(total) > 20
ORDER BY year ASC, sales_sum DESC;


