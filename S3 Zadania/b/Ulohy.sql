WITH daily_sales AS (SELECT sales_date, SUM(total_amount) as hodnota FROM flourmills_sales GROUP BY sales_date)
SELECT * FROM daily_sales WHERE hodnota > 3000000 ORDER BY hodnota DESC;
WITH category_sales AS (SELECT product_category, SUM(total_amount) as hodnota FROM flourmills_sales GROUP BY product_category)
SELECT * FROM category_sales ORDER BY hodnota DESC;
WITH product_sales AS (SELECT product_category, product_name, SUM(total_amount) AS total_product_sales FROM flourmills_sales GROUP BY product_category, product_name),
ranked_products AS (SELECT *, RANK() OVER (PARTITION BY product_category ORDER BY total_product_sales DESC) AS category_rank FROM product_sales)
SELECT * FROM ranked_products WHERE category_rank <= 3 ORDER BY product_category ASC, category_rank ASC;
WITH customer_revenue AS (SELECT customer_type, SUM(total_amount) AS revenue FROM flourmills_sales GROUP BY customer_type),
revenue_analysis AS (SELECT *, SUM(revenue) OVER () AS total_revenue, ROUND((revenue/SUM(revenue) OVER ()) * 100, 2) AS revenue_percentage FROM customer_revenue)
SELECT * FROM revenue_analysis ORDER BY revenue DESC;
WITH lastest_purchase AS (SELECT customer_id, product_name, sales_date, total_amount, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sales_date DESC) as rn FROM flourmills_sales)
SELECT * FROM lastest_purchase WHERE rn = 1 ORDER BY customer_id ASC;
WITH RECURSIVE date_bounds AS (SELECT MIN(sales_date) AS min_date, MAX(sales_date) AS max_date FROM flourmills_sales),
date_series AS (SELECT min_date AS datum, max_date FROM date_bounds UNION ALL SELECT (datum + INTERVAL '1 day')::DATE AS datum, max_date FROM date_series WHERE datum < max_date)
SELECT * FROM date_series ORDER BY datum DESC;
WITH RECURSIVE monthly_revenue AS (SELECT date_trunc('month', sales_date) AS month, SUM(total_amount) AS revenue FROM flourmills_sales GROUP BY date_trunc('month', sales_date)),
ordered_months AS (SELECT ROW_NUMBER() OVER (ORDER BY month ASC) AS rn, month, revenue FROM monthly_revenue),
cumulative_target AS (SELECT rn, month, revenue, revenue AS cumulative_revenue FROM ordered_months WHERE rn = 1 UNION ALL SELECT next_m.rn, next_m.month, next_m.revenue, curr_m.cumulative_revenue + next_m.revenue AS cumulative_revenue FROM cumulative_target curr_m JOIN ordered_months next_m ON next_m.rn = curr_m.rn + 1 WHERE curr_m.cumulative_revenue < 500000000)
SELECT * FROM cumulative_target ORDER BY rn ASC;