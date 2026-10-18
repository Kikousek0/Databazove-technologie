SELECT 
    customer_id,
    invoice_no,
    invoice_date,
    quantity,
    unit_price,
    (quantity * unit_price) AS revenue,
    SUM(quantity * unit_price) OVER (
        PARTITION BY customer_id 
        ORDER BY invoice_date 
        RANGE BETWEEN INTERVAL '14 days' PRECEDING AND CURRENT ROW
    ) AS revenue_last_14_days
FROM 
    retail_sales
WHERE 
    customer_id IS NOT NULL
ORDER BY 
    customer_id, 
    invoice_date;
SELECT 
    stock_code,
    country,
    invoice_date,
    quantity,
    ROUND(
        AVG(quantity) OVER (
            PARTITION BY stock_code, country 
            ORDER BY invoice_date 
            RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW
        ), 
        2
    ) AS avg_quantity_7_days
FROM 
    retail_sales
WHERE 
    quantity > 1
ORDER BY 
    stock_code,
    country,
    invoice_date;
