create view high_value_customers as SELECT cu.customer_id, cu.customer_name, SUM(o.sales) as total_sales FROM customer cu JOIN orders o on cu.customer_id = o.customer_id GROUP BY cu.customer_id HAVING SUM(o.sales) > 2000;
SELECT * FROM high_value_customers;
create view regional_monthly_sales as SELECT cu.region, date_trunc('month', order_date) as mesiac, SUM(o.sales)as monthly_sales FROM customer cu JOIN orders o on cu.customer_id = o.customer_id GROUP BY date_trunc('month', order_date), cu.region ORDER BY cu.region DESC;
SELECT * FROM regional_monthly_sales;