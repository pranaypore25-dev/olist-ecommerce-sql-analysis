USE olist_db;

-- Q5. Percentage of late deliveries
-- Late = delivered AFTER estimated delivery date
-- Only delivered orders with valid estimated dates are included

WITH delivery_analysis AS (
  SELECT 
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS days_late,
    CASE 
      WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late'
      ELSE 'On-Time'
    END AS delivery_status
  FROM orders o
  WHERE o.order_status = 'delivered'
    AND o.order_estimated_delivery_date IS NOT NULL
    AND o.order_delivered_customer_date IS NOT NULL
)
SELECT 
  COUNT(*) AS total_orders,
  SUM(CASE WHEN delivery_status = 'Late' THEN 1 ELSE 0 END) AS late_orders,
  ROUND(SUM(CASE WHEN delivery_status = 'Late' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_late,
  ROUND(AVG(CASE WHEN delivery_status = 'Late' THEN days_late END), 2) AS avg_days_late,
  MAX(days_late) AS max_days_late
FROM delivery_analysis;

-- Breakdown by customer state
SELECT 
  c.customer_state,
  COUNT(*) AS orders,
  SUM(CASE WHEN da.delivery_status = 'Late' THEN 1 ELSE 0 END) AS late_orders,
  ROUND(SUM(CASE WHEN da.delivery_status = 'Late' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_late
FROM delivery_analysis da
JOIN customers c ON c.customer_id = da.customer_id
GROUP BY c.customer_state
ORDER BY pct_late DESC;

-- Breakdown by product category
SELECT 
  p.product_category_name,
  COUNT(*) AS orders,
  SUM(CASE WHEN da.delivery_status = 'Late' THEN 1 ELSE 0 END) AS late_orders,
  ROUND(SUM(CASE WHEN da.delivery_status = 'Late' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_late
FROM delivery_analysis da
JOIN order_items oi ON oi.order_id = da.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY pct_late DESC;
