USE olist_db;

-- Q10. RFM customer segmentation
-- Customers are identified by customer_unique_id. Delivered orders only.
-- Recency  = days between the customer's last order and the latest delivered
--            order in the data (the snapshot date).
-- Frequency = number of delivered orders (scored 1 / 3 / 5, because ~97% of
--            customers ordered once).
-- Monetary = SUM(item price), freight excluded (see DECISIONS).
-- NTILE ties are broken by customer_unique_id so results are repeatable.

-- Part A: customers and revenue by segment
WITH customer_orders AS (
  SELECT c.customer_unique_id,
         o.order_id,
         o.order_purchase_timestamp,
         SUM(oi.price) AS order_value
  FROM orders o
  JOIN customers c    ON c.customer_id = o.customer_id
  JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id, o.order_id, o.order_purchase_timestamp
),
rfm_base AS (
  SELECT customer_unique_id,
         DATEDIFF((SELECT MAX(order_purchase_timestamp) FROM customer_orders),
                  MAX(order_purchase_timestamp)) AS recency_days,
         COUNT(*)         AS frequency,
         SUM(order_value) AS monetary
  FROM customer_orders
  GROUP BY customer_unique_id
),
scored AS (
  SELECT customer_unique_id, recency_days, frequency, monetary,
         NTILE(5) OVER (ORDER BY recency_days DESC, customer_unique_id) AS r_score,
         CASE WHEN frequency = 1 THEN 1
              WHEN frequency = 2 THEN 3
              ELSE 5 END                                                AS f_score,
         NTILE(5) OVER (ORDER BY monetary, customer_unique_id)          AS m_score
  FROM rfm_base
),
segments AS (
  SELECT *,
         CASE WHEN f_score >= 3                  THEN '1 Repeat buyers'
              WHEN r_score >= 4 AND m_score >= 4 THEN '2 Recent big spenders'
              WHEN r_score >= 4                  THEN '3 Recent, lower spend'
              WHEN r_score <= 2 AND m_score >= 4 THEN '4 Lapsed big spenders'
              WHEN r_score <= 2                  THEN '5 Lapsed, lower spend'
              ELSE                                    '6 Mid recency' END AS segment
  FROM scored
)
SELECT segment,
       COUNT(*)                                              AS customers,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)      AS pct_of_customers,
       ROUND(SUM(monetary), 2)                               AS revenue,
       ROUND(100 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 1) AS pct_of_revenue,
       ROUND(AVG(monetary), 2)                               AS avg_spend,
       ROUND(AVG(recency_days))                              AS avg_days_since_last_order
FROM segments
GROUP BY segment
ORDER BY segment;

-- Part B: sanity check - segment customers must add up to this customer count,
-- and segment revenue must add up to this revenue (13221498.11 as in Q1).
SELECT COUNT(DISTINCT c.customer_unique_id) AS customers,
       ROUND(SUM(oi.price), 2)              AS revenue
FROM orders o
JOIN customers c    ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';
