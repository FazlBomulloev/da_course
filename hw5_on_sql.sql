-- Задача №1: Количество клиентов у каждого сотрудника и их процент от общего числа клиентов
WITH customer_count AS (
    SELECT support_rep_id, COUNT(*) AS num_customers
    FROM customer
    GROUP BY support_rep_id
),
total_customers AS (
    SELECT COUNT(*) AS total FROM customer
)
SELECT e.employee_id, 
       e.first_name || ' ' || e.last_name AS full_name, 
       c.num_customers, 
       ROUND(100.0 * c.num_customers / t.total, 2) AS percent_of_total
FROM employee e
LEFT JOIN customer_count c ON e.employee_id = c.support_rep_id
CROSS JOIN total_customers t;

-- Задача №2: Альбомы, треки из которых не продавались
SELECT a.title AS album_title, ar.name AS artist_name
FROM album a
JOIN artist ar ON a.artist_id = ar.artist_id
WHERE a.album_id NOT IN (
    SELECT DISTINCT t.album_id
    FROM track t
    JOIN invoice_line il ON t.track_id = il.track_id
);

-- Задача №3: Список сотрудников без подчинённых
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS full_name
FROM employee e
WHERE e.employee_id NOT IN (
    SELECT  employee.reports_to  FROM employee WHERE employee.reports_to IS NOT NULL
);

-- Задача №4: Треки, проданные в США и Канаде
SELECT  t.track_id, t.name AS track_name
FROM track t
JOIN invoice_line il ON t.track_id = il.track_id
JOIN invoice i ON il.invoice_id = i.invoice_id
WHERE i.billing_country = 'USA'
INTERSECT
SELECT  t.track_id, t.name AS track_name
FROM track t
JOIN invoice_line il ON t.track_id = il.track_id
JOIN invoice i ON il.invoice_id = i.invoice_id
WHERE i.billing_country = 'Canada';

-- Задача №5: Треки, проданные в Канаде, но не в США
SELECT  t.track_id, t.name AS track_name
FROM track t
JOIN invoice_line il ON t.track_id = il.track_id
JOIN invoice i ON il.invoice_id = i.invoice_id
WHERE i.billing_country = 'Canada'
EXCEPT
SELECT  t.track_id, t.name AS track_name
FROM track t
JOIN invoice_line il ON t.track_id = il.track_id
JOIN invoice i ON il.invoice_id = i.invoice_id
WHERE i.billing_country = 'USA';
