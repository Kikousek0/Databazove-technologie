create DATABASE superstore;
create TABLE customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(50)
);
create TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(100)
);
create TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    sales DECIMAL,
    quantity int,
    discount DECIMAL,
    profit DECIMAL,
    FOREIGN KEY (customer_id)
    REFERENCES customer(customer_id),
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)

);

select * from orders;
select * from products;
select * from customer;