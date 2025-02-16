/* Имя: Fazliddin Bomulloev
 Описание задачи: Написание запросов для работы с таблицей track в базе данных.
 Задача: Написать SQL запросы для извлечения различных данных из таблицы track.
*/


-- Задание 1: Вернуть из таблицы track поля name и genre_id.
SELECT 
	name, genre_id
FROM track;

/*Задание 2: Вернуть из таблицы track поля name, composer, unit_price, переименовав их на song, author и price соответственно.
 Расположить поля так, чтобы сначала следовало название произведения, затем его цена и в конце список авторов.
 */
 SELECT 
	name AS song, unit_price AS price, composer AS author
FROM track;

-- Задание  3: Вернуть из таблицы track название произведения и его длительность в минутах. Результат отсортирован по длительности произведения по убыванию.
SELECT 
	name, (milliseconds / 60000) AS duration_minutes
FROM track
ORDER BY duration_minutes DESC;

-- Задание 4: Вернуть из таблицы track поля name и genre_id, и только первые 15 строк.
SELECT 
	name, genre_id
FROM track
LIMIT 15;

-- Задание 5: Вернуть из таблицы track все поля и все строки начиная с 50-й строки.
SELECT *
FROM track 
offset 50

-- Задание  6: Вернуть из таблицы track названия всех произведений, чей объём больше 100 мегабайт.
-- Подсказка: 1mb = 1048576 bytes.
SELECT 
	name
FROM track
WHERE bytes > 104857600;

--Задание 7: Вернуть из таблицы track поля name и composer, где composer не равен "U2". Код должен вернуть записи с 10 по 20-й включительно.
SELECT 
	name, composer
FROM track
WHERE composer != 'U2'
LIMIT 10, 11;
