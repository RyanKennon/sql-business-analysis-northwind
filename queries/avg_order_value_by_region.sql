SELECT 
    c.Country,
	AVG(order_totals.TotalRevenue) AS AvgOrderValue
FROM (
    SELECT 
        od.OrderID,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
    FROM "Order Details" od
    GROUP BY od.OrderID
) AS order_totals
JOIN Orders o ON order_totals.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.Country
ORDER BY AvgOrderValue DESC;
