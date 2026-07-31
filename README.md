# Northwind SQL Business Analysis

## Overview

This project uses SQL to answer common business questions about a fictional company's sales, customers, employees, and shipping performance, using an expanded version of the classic Northwind sample database. The analysis covers revenue by category, top customers and employees, revenue trends over time, average order value by country, and shipping performance across carriers, with each query paired with a plain-language finding.

---

## Dataset

This project uses the Northwind sample database, a classic dataset modeling 
a small trading company's operations — customers, orders, products, 
suppliers, employees, and shipping.

- **Source:** [northwind-SQLite3](https://github.com/jpwhite3/northwind-SQLite3) 
  (SQLite version of the standard Northwind database)
- **Format:** SQLite (.sqlite/.db file)
- **Key tables:** Customers, Orders, "Order Details", Products, Categories, 
  Employees, Suppliers, Shippers

**Note:** this version of Northwind is expanded well beyond the original 
"classic" dataset — the `Order Details` table alone contains over 600,000 
rows (compared to roughly 2,000 in the standard Northwind database). As a 
result, revenue figures throughout this analysis are much larger than the 
small-business scale typically associated with Northwind. Findings in this 
project should be read as relative comparisons (e.g., which category leads, 
how close rankings are) rather than realistic real-world dollar amounts.

---

## Setup / Prerequisites
- Download the Northwind SQLite database from the source linked above
- Open it in DB Browser for SQLite (or any SQLite client)
- Run the .sql files in the `queries` folder against the database to reproduce results

---

## Tools Used
- **SQLite** — database engine used to store and query the Northwind dataset
- **DB Browser for SQLite** — GUI tool used to open the database, run queries, 
  and view results

---

## Business Questions & Findings

### 1. Which product categories generate the most revenue?

- Query: [Revenue by Category](queries/revenue_by_category.sql)

```sql
SELECT 
    c.CategoryName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM "Order Details" od
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY TotalRevenue DESC;
```

<p align="center">
  <img width="249" height="229" alt="image" src="https://github.com/user-attachments/assets/6d7f8b09-3d1a-40d1-a2af-3f28818398a1" />
</p>

- Finding: Beverages is the top revenue-generating category at roughly $92.2M, 
  followed by Confections ($66.3M) and Meat/Poultry ($64.9M). Revenue is fairly 
  evenly distributed across the remaining categories rather than concentrated 
  in one or two, suggesting the business isn't overly dependent on a single 
  product line.

### 2. Who are the top 10 customers by total spend?
- Query: [Top Customers by Total Spending](queries/top_customers_by_spend.sql)

```sql
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
```

<p align="center">
  <img width="487" height="289" alt="image" src="https://github.com/user-attachments/assets/68e80dce-9560-48c7-9402-2e9fa9f85712" />
</p>

- Finding: B's Beverages is the top customer by total spend at roughly $6.15M, 
  followed by Hungry Coyote Import Store ($5.7M) and Rancho grande ($5.56M). 
  Spend among the top 10 customers is fairly close together, with no single 
  customer dominating. Note: an earlier version of this query grouped by 
  CompanyName only, which merged two distinct customers who both display as 
  "IT" into one inflated total, grouping by CustomerID instead resolved this 
  and gives an accurate per-customer ranking.

### 3. Which employees have the highest sales performance?
- Query: [Employee Sales Performance](queries/employee_sales_performance.sql)

```sql
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS SalesAmount
FROM "Order Details" od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY SalesAmount DESC
LIMIT 10;
```

<p align="center">
  <img width="401" height="275" alt="image" src="https://github.com/user-attachments/assets/f2f878f1-2108-4cfb-b575-a1c5601659e6" />
</p>

- Finding: Margaret Peacock is the top-performing employee by sales at roughly $51.5M, followed closely by Steven Buchanan ($51.4M) and Janet Leverling ($50.4M). Unlike the customer and category rankings, employee sales performance is remarkably consistent across the team, with only about a $3.2M gap between the highest and lowest performer (Andrew Fuller, $48.3M). This suggests a fairly even distribution of sales responsibility rather than performance being driven by one or two standout employees.

### 4. Is revenue trending up or down year over year?
- Query: [Yearly Revenue Trend](queries/yearly_revenue_trend.sql)

```sql
SELECT 
    strftime('%Y', o.OrderDate) AS Year,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS SalesAmount
FROM "Order Details" od
JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY Year
ORDER BY Year ASC;
```

<p align="center">
  <img width="188" height="359" alt="image" src="https://github.com/user-attachments/assets/f24d1026-68f0-4c37-b4db-715c74e7a47a" />
</p>

- Finding: Revenue is fairly stable year over year rather than showing a clear upward or declining trend, holding consistently between about $38M and $41.4M from 2013 through 2022. 2012 ($18.8M) and 2023 ($33.0M) appear lower, but this is likely because the dataset only contains partial data for those first and last years rather than reflecting an actual dip in performance.

### 5. What's the average order value, and does it vary by country/region?
- Query: [Average Order Value by Region](queries/avg_order_value_by_region.sql)

```sql
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
```

<p align="center">
  <img width="265" height="604" alt="image" src="https://github.com/user-attachments/assets/b76ff3da-2f89-4293-a254-6347bbdafe85" />
</p>

- Finding: Average order value ranges from about $29,505 (Norway, the highest) down to $26,001 (Ireland, the lowest) across all countries, a spread of roughly $3,500. This is a fairly narrow range, suggesting order value doesn't vary dramatically by country. One country appears as NULL with an average of about $29,091; this comes from 2 customer records ("Val2" and "VALON") that have no country or address data on file, the same synthetic/placeholder records identified earlier in the customer spend analysis (question 2).

### 6. How does shipping time vary by shipper, and are there patterns in delays?
- Query: [Shipping Time by Shipper](queries/shipping_time_by_shipper.sql)

```sql
SELECT  
    s.CompanyName,
    AVG(julianday(o.ShippedDate) - julianday(o.OrderDate)) AS ShippingDays
FROM Orders o
JOIN Shippers s ON o.ShipVia = s.ShipperID
WHERE o.ShippedDate IS NOT NULL
GROUP BY s.CompanyName
ORDER BY ShippingDays ASC;
```

<p align="center">
  <img width="300" height="108" alt="image" src="https://github.com/user-attachments/assets/f21b53f1-e5fd-491a-8fe2-91752cc96d24" />
</p>

- Finding: Average shipping time is nearly identical across all three shippers, ranging narrowly from about 7.78 days (United Package) to 7.92 days (Speedy Express), a difference of less than a quarter of a day. This suggests no shipper is meaningfully faster or slower than the others, and shipping delays are unlikely to be tied to which company is used.

---

## Next Steps

With more time, this analysis could be extended by digging deeper into shipping delay patterns rather than just averages (for example, looking at the distribution of shipping times or flagging outlier orders), exploring whether certain product categories or countries are more prone to discounts, or examining how customer spend changes over time rather than just as a lifetime total. This SQL analysis also lays the groundwork for the next project in this portfolio series: the [Northwind Sales Performance Dashboard](https://github.com/RyanKennon/Northwind-Sales-Dashboard/tree/main), an interactive Power BI dashboard built on the same dataset.

---

---

➡️ **Next project:** [Northwind Sales Performance Dashboard](https://github.com/RyanKennon/Northwind-Sales-Dashboard)
