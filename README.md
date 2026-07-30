# sql-business-analysis-northwind

## Dataset

This project uses the Northwind sample database, a classic dataset modeling 
a small trading company's operations — customers, orders, products, 
suppliers, employees, and shipping.

- **Source:** [northwind-SQLite3](https://github.com/jpwhite3/northwind-SQLite3) 
  (SQLite version of the standard Northwind database)
- **Format:** SQLite (.sqlite/.db file)
- **Key tables:** Customers, Orders, OrderDetails, Products, Categories, 
  Employees, Suppliers, Shippers

  ---

## Tools Used
- **SQLite** — database engine used to store and query the Northwind dataset
- **DB Browser for SQLite** — GUI tool used to open the database, run queries, 
  and view results

  ---

## Business Questions & Findings

### 1. Which product categories generate the most revenue?

- Query: [queries/revenue_by_category.sql](queries/revenue_by_category.sql)

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
- Query: [queries/top_customers_by_spend.sql](queries/top_customers_by_spend.sql)

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
- Query: `queries/employee_sales_performance.sql`

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

### 4. Is revenue trending up or down month over month?
- Query: `queries/monthly_revenue_trend.sql`
- Finding: 

### 5. What's the average order value, and does it vary by country/region?
- Query: `queries/avg_order_value_by_region.sql`
- Finding: 

### 6. How does shipping time vary by shipper, and are there patterns in delays?
- Query: `queries/shipping_time_by_shipper.sql`
- Finding:
