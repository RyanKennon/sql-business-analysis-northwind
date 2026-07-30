SELECT 
    c.CustomerID,
    c.CompanyName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSpent
FROM "Order Details" od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalSpent DESC
LIMIT 10;
