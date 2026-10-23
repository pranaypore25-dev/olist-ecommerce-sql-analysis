USE olist_db;

-- Q4. Average delivery time (in days) by customer state
-- Delivery time = DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)
-- Only delivered orders are included (order_status = 'delivered')
-- Results ordered from slowest to fastest average delivery time

WITH delivery_times AS (
  SELECT 
    o.order_id,
    o.customer_id,
    DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS delivery_days
  FROM orders o
  WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
)
SELECT 
  c.customer_state,
  COUNT(*) AS orders,
  ROUND(AVG(dt.delivery_days), 2) AS avg_delivery_days,
  ROUND(MIN(dt.delivery_days), 2) AS min_delivery_days,
  ROUND(MAX(dt.delivery_days), 2) AS max_delivery_days
FROM delivery_times dt
JOIN customers c ON c.customer_id = dt.customer_id
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;

-- Sanity check: verify total delivered orders matches previous queries
SELECT 
  COUNT(*) AS total_delivered_orders,
  ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS overall_avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;
