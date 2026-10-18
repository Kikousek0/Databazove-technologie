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
    -----
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
WITH unique_invoices AS (
    SELECT 
        customer_id,
        invoice_no,
        MIN(invoice_date) AS invoice_date
    FROM 
        retail_sales
    WHERE 
        customer_id IS NOT NULL
    GROUP BY 
        customer_id, 
        invoice_no
),
invoice_with_leads AS (
    SELECT 
        customer_id,
        invoice_no,
        invoice_date,
        LEAD(invoice_date) OVER (
            PARTITION BY customer_id 
            ORDER BY invoice_date, invoice_no
        ) AS next_invoice_date
    FROM 
        unique_invoices
)
SELECT 
    customer_id,
    invoice_no,
    invoice_date,
    next_invoice_date,
    (next_invoice_date - invoice_date) AS days_to_next_invoice
FROM 
    invoice_with_leads
WHERE 
    next_invoice_date IS NOT NULL
ORDER BY 
    days_to_next_invoice DESC;
    ----
WITH product_price_history AS (
    SELECT
    stock_code,
    invoice_no,
    invoice_date,
    unit_price AS current_price,
    LAG(unit_price) OVER (
        PARTITION BY stock_code
        ORDER BY invoice_date
    ) AS previous_price
    FROM
    retail_sales
)
SELECT *, (current_price - previous_price) AS price_difference FROM product_price_history WHERE previous_price IS NOT NULL AND current_price != previous_price ORDER BY invoice_date ASC;

