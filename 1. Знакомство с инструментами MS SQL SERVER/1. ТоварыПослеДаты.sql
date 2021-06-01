SELECT Наименование_товара
FROM     ЗАКАЗЫ
WHERE  (Дата_поставки > CONVERT(DATETIME, '2020-10-01 00:00:00', 102))