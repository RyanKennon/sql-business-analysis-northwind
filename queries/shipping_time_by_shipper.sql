SELECT  
	s.CompanyName,
    AVG(julianday(o.ShippedDate) - julianday(o.OrderDate)) AS ShippingDays
FROM Orders o
JOIN Shippers s ON o.ShipVia = s.ShipperID
WHERE o.ShippedDate IS NOT NULL
GROUP BY s.CompanyName
ORDER BY ShippingDays ASC;
