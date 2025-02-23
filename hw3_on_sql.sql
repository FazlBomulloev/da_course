-- Bomulloev Fazliddin


-- Создание схемы store
CREATE SCHEMA store;
SET search_path TO store;

-- Создание таблицы customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(260),
    address TEXT
);

-- Заполнение таблицы customers данными из chinook.customer
INSERT INTO customers (customer_name, email, address)
SELECT 
    first_name || ' ' || last_name AS customer_name,
    email,
    country || ' ' || COALESCE(state, '') || ' ' || city || ' ' || address AS address
FROM public.customer;

-- Создание таблицы products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC NOT NULL
);

-- Заполнение таблицы products
INSERT INTO products (product_name, price) VALUES
('Ноутбук Lenovo Thinkpad', 12000),
('Мышь для компьютера, беспроводная', 90),
('Подставка для ноутбука', 300),
('Шнур электрический для ПК', 160);

-- Создание таблицы sales
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT DEFAULT 1 NOT NULL
);

-- Заполнение таблицы sales
INSERT INTO sales (customer_id, product_id, quantity) VALUES
(3, 4, 1),
(56, 2, 3),
(11, 2, 1),
(31, 2, 1),
(24, 2, 3),
(27, 2, 1),
(37, 3, 2),
(35, 1, 2),
(21, 1, 2),
(31, 2, 2),
(15, 1, 1),
(29, 2, 1),
(12, 2, 1);

-- Добавление колонки discount и обновление значений
ALTER TABLE sales ADD COLUMN discount NUMERIC DEFAULT 0;
UPDATE sales SET discount = 0.2 WHERE product_id = 1;

-- Создание представления v_usa_customers
CREATE VIEW v_usa_customers AS
SELECT * FROM customers WHERE address LIKE 'United States%';
