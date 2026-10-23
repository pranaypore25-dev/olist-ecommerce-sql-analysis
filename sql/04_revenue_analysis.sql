USE olist_db;

-- Q1. Monthly revenue, orders and month-over-month (MoM) growth
-- Revenue = SUM(price) of delivered orders; freight excluded (see DECISIONS).

WITH monthly AS (
  SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS month,
         COUNT(DISTINCT o.order_id) AS orders,
         SUM(oi.price)              AS revenue
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01')
)
SELECT month,
       orders,
       ROUND(revenue, 2) AS revenue,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / NULLIF(LAG(revenue) OVER (ORDER BY month), 0), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;

-- Sanity check: monthly revenue should add up to the overall total
SELECT ROUND(SUM(oi.price), 2) AS total_delivered_revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';
