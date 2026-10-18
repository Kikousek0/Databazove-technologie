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