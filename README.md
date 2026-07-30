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
- Query: `queries/top_customers.sql`
- Finding: 

### 3. Which employees have the highest sales performance?
- Query: `queries/employee_sales_performance.sql`
- Finding: 

### 4. Is revenue trending up or down month over month?
- Query: `queries/monthly_revenue_trend.sql`
- Finding: 

### 5. What's the average order value, and does it vary by country/region?
- Query: `queries/avg_order_value_by_region.sql`
- Finding: 

### 6. How does shipping time vary by shipper, and are there patterns in delays?
- Query: `queries/shipping_time_by_shipper.sql`
- Finding:
