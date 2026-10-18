create Table retail_sales (
    invoice_no VARCHAR(20),
    stock_code VARCHAR(50),
    description text,
    quantity INT,
    invoice_date TIMESTAMP,
    unit_price DECIMAL,
    customer_id INT,
    country VARCHAR(100)
)