-- 1. Информация по каждому сотруднику
SELECT 
    employee_id,
    first_name || ' ' || last_name AS full_name,
    title,
    reports_to AS manager_id,
    (SELECT first_name || ' ' || last_name || ', ' || title 
     FROM employee AS manager 
     WHERE manager.employee_id = emp.reports_to) AS manager_info
FROM employee AS emp;

-- 2. Список чеков с суммой больше среднего за 2023 год
WITH avg_2023 AS (
    SELECT AVG(total) AS avg_total
    FROM invoice
    WHERE invoice_date BETWEEN '2023-01-01' AND '2023-12-31'
)
SELECT 
    invoice_id,
    invoice_date,
    EXTRACT(YEAR FROM invoice_date) * 100 + EXTRACT(MONTH FROM invoice_date) AS monthkey,
    customer_id,
    total
FROM invoice
WHERE total > (SELECT avg_total FROM avg_2023);

-- 3. Дополнение запроса email-ом клиента
SELECT 
    invoice_id,
    invoice_date,
    EXTRACT(YEAR FROM invoice_date) * 100 + EXTRACT(MONTH FROM invoice_date) AS monthkey,
    customer_id,
    total,
    (SELECT email FROM customer WHERE customer_id = i.customer_id) AS email
FROM invoice i
WHERE total > (SELECT AVG(total) FROM invoice 
		WHERE invoice_date BETWEEN '2023-01-01' AND '2023-12-31');


-- 4. Исключение клиентов с email в домене gmail
SELECT 
    invoice_id,
    invoice_date,
    EXTRACT(YEAR FROM invoice_date) * 100 + EXTRACT(MONTH FROM invoice_date) AS monthkey,
    customer_id,
    total,
    (SELECT email FROM customer WHERE customer_id = i.customer_id) AS email
FROM invoice i
WHERE total > (SELECT AVG(total) FROM invoice WHERE invoice_date BETWEEN '2023-01-01' AND '2023-12-31')
AND (SELECT email FROM customer WHERE customer_id = i.customer_id) NOT LIKE '%@gmail.com';

-- 5. Процент от общей выручки 2024 года для каждого чека
SELECT 
    invoice_id,
    invoice_date,
    total,
    ROUND((total / (SELECT SUM(total) FROM invoice 
    	WHERE invoice_date BETWEEN '2024-01-01' AND '2024-12-31')) * 100, 2) AS percentage
FROM invoice
WHERE invoice_date BETWEEN '2024-01-01' AND '2024-12-31';

-- 6. Процент от общей выручки 2024 года для каждого клиента
SELECT 
    customer_id,
    (SELECT SUM(total) FROM invoice
    	WHERE customer_id = c.customer_id AND invoice_date BETWEEN '2024-01-01' AND '2024-12-31') AS customer_total,
    ROUND(( (SELECT SUM(total) FROM invoice 
    	WHERE customer_id = c.customer_id AND invoice_date BETWEEN '2024-01-01' AND '2024-12-31') 
            / (SELECT SUM(total) from invoice 
            	WHERE invoice_date BETWEEN '2024-01-01' AND '2024-12-31')) * 100, 2) AS percentage
FROM customer c
WHERE EXISTS (SELECT 1 FROM invoice WHERE customer_id = c.customer_id AND invoice_date BETWEEN '2024-01-01' AND '2024-12-31');
