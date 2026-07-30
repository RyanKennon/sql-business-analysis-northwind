SELECT 
    strftime('%Y', o.OrderDate) AS Year,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS SalesAmount
FROM "Order Details" od
JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY Year
ORDER BY Year ASC;
