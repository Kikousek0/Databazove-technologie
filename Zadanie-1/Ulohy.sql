SELECT o.order_id, cu.customer_name, o.sales FROM orders o JOIN customer cu ON o.customer_id = cu.customer_id WHERE sales > 500 ORDER BY sales DESC;
SELECT o.order_id, cu.customer_name, pr.category, o.sales FROM orders o JOIN customer cu ON o.customer_id = cu.customer_id JOIN products pr on o.product_id = pr.product_id;
SELECT cu.region, SUM(o.sales) as hodnota_predaja FROM customer cu JOIN orders o on cu.customer_id = o.customer_id GROUP BY cu.region;
SELECT pr.product_name, SUM(o.sales) as hodnota_predaja FROM products pr LEFT JOIN orders o on pr.product_id = o.product_id GROUP BY pr.product_name;
SELECT cu.customer_name, o.order_id, o.sales FROM customer cu FULL JOIN orders o on cu.customer_id = o.customer_id;