CREATE DATABASE retail_sales;
---tabulka---
CREATE Table orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    region VARCHAR(20) NOT NULL,
    category VARCHAR(50) NOT NULL,
    ship_mode VARCHAR(30) NOT NULL,
    sales DECIMAL NOT NULL,
    profit DECIMAL NOT NULL
);
ALTER DATABASE retail_sales SET datestyle TO 'ISO, MDY';
---Ulohy---
CREATE OR REPLACE PROCEDURE get_customer_sales(p_customer_id VARCHAR) LANGUAGE plpgsql AS $$ DECLARE v_total_sales NUMERIC;
BEGIN SELECT COALESCE(SUM(sales), 0) INTO v_total_sales FROM orders WHERE customer_id = p_customer_id;
RAISE NOTICE 'Zákazník: %, Celkový predaj: %', p_customer_id, v_total_sales;
END; $$;
CALL get_customer_sales('C001');
CREATE OR REPLACE PROCEDURE apply_regional_discount(region_name VARCHAR, discount_rate NUMERIC) LANGUAGE plpgsql AS $$
BEGIN UPDATE orders SET sales = sales * (1-discount_rate) WHERE region = region_name;
RAISE NOTICE 'Aplikovaná zľava % pre región %.', discount_rate, region_name;
END; $$;
call apply_regional_discount('West', 0.10);
SELECT order_id, region, sales 
FROM orders 
WHERE region = 'West';
CREATE OR REPLACE PROCEDURE get_sales_between(start_date DATE, end_date DATE) LANGUAGE plpgsql AS $$ DECLARE v_total_sales NUMERIC;
BEGIN SELECT COALESCE(SUM(sales),0) into v_total_sales FROM orders WHERE order_date BETWEEN start_date AND end_date;
RAISE NOTICE 'Obdobie od: %, do: %, Celkový predaj: %', start_date, end_date, v_total_sales;
END; $$;
CALL get_sales_between('2024-01-01', '2024-03-31');