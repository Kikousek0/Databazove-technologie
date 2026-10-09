WITH daily_sales AS (SELECT sales_date, SUM(total_amount) as hodnota FROM flourmills_sales GROUP BY sales_date)
SELECT * FROM daily_sales WHERE hodnota > 3000000 ORDER BY hodnota DESC;
WITH category_sales AS (SELECT product_category, SUM(total_amount) as hodnota FROM flourmills_sales GROUP BY product_category)
SELECT * FROM category_sales ORDER BY hodnota DESC;
WITH product_sales AS (SELECT product_category, product_name, SUM(total_amount) AS total_product_sales FROM flourmills_sales GROUP BY product_category, product_name),
ranked_products AS (SELECT *, RANK() OVER (PARTITION BY product_category ORDER BY total_product_sales DESC) AS category_rank FROM product_sales)
SELECT * FROM ranked_products WHERE category_rank <= 3 ORDER BY product_category ASC, category_rank ASC;