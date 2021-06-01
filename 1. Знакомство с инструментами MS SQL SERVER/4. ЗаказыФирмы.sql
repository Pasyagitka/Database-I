SELECT Дата_поставки, Заказчик, Номер_заказа
FROM     ЗАКАЗЫ
WHERE  (Заказчик = N'KORADO')
ORDER BY Дата_поставки DESC