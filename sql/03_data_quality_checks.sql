@'
-- DECISIONS
-- Revenue = SUM(order_items.price) for orders with status 'delivered'. Freight excluded.
-- Repeat customers are counted with customer_unique_id, because customer_id
--   changes with every order.
-- Delivery analysis uses delivered orders that have a delivery date only.
-- Reviews are averaged per order, since some orders have more than one review.
-- Orders without items are excluded from revenue analysis.

USE olist_db;

-- 1. Order status distribution
SELECT order_status, COUNT(*) AS orders
FROM orders
GROUP BY order_status
ORDER BY orders DESC;

-- 2. Delivered orders with no delivery date
SELECT COUNT(*) AS delivered_missing_date
FROM orders
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NULL;

-- 3. Orders with more than one review
SELECT COUNT(*) AS orders_with_multiple_reviews
FROM (SELECT order_id FROM order_reviews GROUP BY order_id HAVING COUNT(*) > 1) t;

-- 4. Orders with no items
SELECT COUNT(*) AS orders_without_items
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
WHERE oi.order_id IS NULL;

-- 5. Date range of the data
SELECT MIN(order_purchase_timestamp) AS first_order,
       MAX(order_purchase_timestamp) AS last_order
FROM orders;

-- 6. customer_id vs customer_unique_id
SELECT COUNT(*) AS customer_ids,
       COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

-- 7. Delivered before purchase (impossible dates)
SELECT COUNT(*) AS bad_dates
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;

-- 8. Products with no category
SELECT COUNT(*) AS products_no_category
FROM products
WHERE product_category_name IS NULL;
'@ | Set-Content -Path sql\03_data_quality_checks.sql -Encoding ascii