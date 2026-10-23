USE olist_db;

-- Q3. Average order value (AOV) by customer state
-- Order value = SUM(price) of an order's items (freight excluded), delivered orders only.
-- Each order is totalled first, then averaged per state, so multi-item orders
-- are not counted as several small orders.

WITH order_totals AS (
  SELECT o.order_id,
         o.customer_id,
         SUM(oi.price) AS order_value
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY o.order_id, o.customer_id
)
SELECT c.customer_state,
       COUNT(*)                       AS orders,
       ROUND(SUM(ot.order_value), 2)  AS revenue,
       ROUND(AVG(ot.order_value), 2)  AS avg_order_value
FROM order_totals ot
JOIN customers c ON c.customer_id = ot.customer_id
GROUP BY c.customer_state
ORDER BY avg_order_value DESC;

-- Sanity check: state revenue must add up to the Q1 total (13221498.11)
-- and gives the overall average order value
WITH order_totals AS (
  SELECT o.order_id,
         SUM(oi.price) AS order_value
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY o.order_id
)
SELECT ROUND(SUM(order_value), 2) AS total_revenue,
       COUNT(*)                   AS orders,
       ROUND(AVG(order_value), 2) AS overall_avg_order_value
FROM order_totals;
