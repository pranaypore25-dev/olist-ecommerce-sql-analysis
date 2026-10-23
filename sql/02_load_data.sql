@'
-- Update the file paths to match your local data folder before running.
-- If you see "Delimiter \r" warnings, switch that table to '\r\n' line endings.
USE olist_db;

LOAD DATA LOCAL INFILE 'C:/Projects/data/product_category_name_translation.csv'
INTO TABLE category_translation
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Projects/data/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Projects/data/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, customer_id, order_status, @purchase, @approved, @carrier, @delivered, @estimated)
SET order_purchase_timestamp      = NULLIF(@purchase, ''),
    order_approved_at             = NULLIF(@approved, ''),
    order_delivered_carrier_date  = NULLIF(@carrier, ''),
    order_delivered_customer_date = NULLIF(@delivered, ''),
    order_estimated_delivery_date = NULLIF(@estimated, '');

LOAD DATA LOCAL INFILE 'C:/Projects/data/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Projects/data/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Projects/data/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Projects/data/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(product_id, @cat, @namelen, @desclen, @photos, @weight, @len, @height, @width)
SET product_category_name      = NULLIF(@cat, ''),
    product_name_length        = NULLIF(@namelen, ''),
    product_description_length = NULLIF(@desclen, ''),
    product_photos_qty         = NULLIF(@photos, ''),
    product_weight_g           = NULLIF(@weight, ''),
    product_length_cm          = NULLIF(@len, ''),
    product_height_cm          = NULLIF(@height, ''),
    product_width_cm           = NULLIF(@width, '');

LOAD DATA LOCAL INFILE 'C:/Projects/data/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
'@ | Set-Content -Path sql\02_load_data.sql -Encoding ascii