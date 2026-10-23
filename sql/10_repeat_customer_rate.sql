USE olist_db;

-- Q7. Repeat customer rate and analysis
-- Identifies customers with >1 delivered order and compares them to one-time buyers

WITH customer_orders AS (
  SELECT 
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date,
    DATEDIFF(MAX(order_purchase_timestamp), MIN(order_purchase_timestamp)) AS days_between_first_last
  FROM orders
  WHERE order_status = 'delivered'
  GROUP BY customer_id
),
customer_classification AS (
  SELECT 
    *,
    CASE WHEN total_orders > 1 THEN 'Repeat' ELSE 'One-Time' END AS customer_type
  FROM customer_orders
)
SELECT 
  customer_type,
  COUNT(*) AS customer_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_customers,
  ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,
  ROUND(SUM(total_orders) * 100.0 / SUM(SUM(total_orders)) OVER(), 2) AS pct_total_orders
FROM customer_classification
GROUP BY customer_type
ORDER BY customer_type;

-- Bonus: Repeat customer retention by month of first purchase
SELECT 
  DATE_FORMAT(first_order_date, '%Y-%m') AS first_purchase_month,
  COUNT(*) AS new_customers,
  SUM(CASE WHEN customer_type = 'Repeat' THEN 1 ELSE 0 END) AS became_repeaters,
  ROUND(SUM(CASE WHEN customer_type = 'Repeat' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS repeat_rate_pct
FROM customer_classification
WHERE first_order_date >= '2017-01-01'  -- Exclude sparse early data
GROUP BY DATE_FORMAT(first_order_date, '%Y-%m')
ORDER BY first_purchase_month;

-- Bonus: Average time between first and second order for repeaters
SELECT 
  ROUND(AVG(days_between_first_last), 2) AS avg_days_between_orders,
  ROUND(MEDIAN(days_between_first_last), 2) AS median_days_between_orders,
  COUNT(*) AS repeat_customers
FROM customer_classification
WHERE customer_type = 'Repeat' AND days_between_first_last > 0;
