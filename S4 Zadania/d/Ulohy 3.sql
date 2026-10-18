WITH new_orders AS (
    SELECT cu.customer_name, o.order_id, o.order_date,
    ROW_NUMBER() OVER (
        PARTITION BY cu.customer_id
        ORDER BY o.order_date DESC
    ) AS row_num
    FROM customer cu JOIN orders o ON cu.customer_id = o.customer_id 
)
SELECT * FROM new_orders WHERE row_num <= 2 ORDER BY customer_name ASC, row_num ASC;
----
WITH customer_region_profit AS (
    SELECT cu.region, cu.customer_name, SUM(o.profit) AS total_profit
    FROM customer cu JOIN orders o ON cu.customer_id = o.customer_id
    GROUP BY cu.region, cu.customer_id, cu.customer_name
)
SELECT *,
    RANK() OVER (
        PARTITION BY region 
        ORDER BY total_profit DESC
    ) AS profit_rank,
    DENSE_RANK() OVER (
        PARTITION BY region 
        ORDER BY total_profit DESC
    ) AS profit_dense_rank
FROM customer_region_profit ORDER BY region ASC, profit_rank ASC;
-----
WITH customer_total_sales AS (
    SELECT cu.customer_id, cu.customer_name,
    SUM(o.sales) as total_sales
    FROM customer cu JOIN orders o ON cu.customer_id = o.customer_id
    GROUP BY cu.customer_id
)
SELECT customer_name, total_sales,
ntile(4) OVER(
    ORDER BY total_sales DESC
) AS quartile
FROM customer_total_sales;
-----
WITH monthly_total_sales AS (
    SELECT date_trunc('month', order_date) AS month,
    SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY date_trunc('month', order_date)
)
SELECT month, monthly_sales, 
LAG(monthly_sales, 1) OVER (
    ORDER BY month
) AS prev_month_sales,
LEAD(monthly_sales, 1) OVER (
    ORDER BY month
) AS next_month_sales
FROM monthly_total_sales ORDER BY month ASC;