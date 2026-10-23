USE olist_db;

-- Q2. Top 10 product categories by revenue, with share of total and running share
-- Revenue = SUM(price) of delivered orders; freight excluded (see DECISIONS).
-- Products with no category show as 'unknown'. Categories without an English
-- translation fall back to the Portuguese name.

WITH category_revenue AS (
  SELECT COALESCE(t.product_category_name_english,
                  p.product_category_name,
                  'unknown')              AS category,
         COUNT(DISTINCT oi.order_id)      AS orders,
         SUM(oi.price)                    AS revenue
  FROM order_items oi
  JOIN orders o   ON o.order_id = oi.order_id
  JOIN products p ON p.product_id = oi.product_id
  LEFT JOIN category_translation t
         ON t.product_category_name = p.product_category_name
  WHERE o.order_status = 'delivered'
  GROUP BY COALESCE(t.product_category_name_english,
                    p.product_category_name,
                    'unknown')
)
SELECT category,
       orders,
       ROUND(revenue, 2) AS revenue,
       ROUND(100 * revenue / SUM(revenue) OVER (), 1) AS pct_of_total,
       ROUND(100 * SUM(revenue) OVER (ORDER BY revenue DESC)
                 / SUM(revenue) OVER (), 1) AS cumulative_pct
FROM category_revenue
ORDER BY revenue DESC
LIMIT 10;

-- Sanity check: all categories together must equal the Q1 total (13221498.11)
WITH category_revenue AS (
  SELECT COALESCE(t.product_category_name_english,
                  p.product_category_name,
                  'unknown')              AS category,
         SUM(oi.price)                    AS revenue
  FROM order_items oi
  JOIN orders o   ON o.order_id = oi.order_id
  JOIN products p ON p.product_id = oi.product_id
  LEFT JOIN category_translation t
         ON t.product_category_name = p.product_category_name
  WHERE o.order_status = 'delivered'
  GROUP BY COALESCE(t.product_category_name_english,
                    p.product_category_name,
                    'unknown')
)
SELECT ROUND(SUM(revenue), 2) AS total_all_categories
FROM category_revenue;
