USE olist_db;

-- Q8. Seller revenue concentration (the 80/20 question)
-- Revenue = SUM(price) of delivered orders, freight excluded (see DECISIONS).
-- Only sellers with at least one delivered item are counted.

-- Part A: summary of how concentrated revenue is
WITH seller_revenue AS (
  SELECT oi.seller_id,
         COUNT(DISTINCT oi.order_id) AS orders,
         SUM(oi.price)               AS revenue
  FROM order_items oi
  JOIN orders o ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY oi.seller_id
),
ranked AS (
  SELECT seller_id,
         orders,
         revenue,
         ROW_NUMBER() OVER (ORDER BY revenue DESC, seller_id) AS seller_rank,
         COUNT(*)     OVER ()                                 AS total_sellers,
         SUM(revenue) OVER ()                                 AS total_revenue,
         SUM(revenue) OVER (ORDER BY revenue DESC, seller_id) AS running_revenue
  FROM seller_revenue
)
SELECT MAX(total_sellers)                          AS sellers,
       ROUND(MAX(total_revenue), 2)                AS total_revenue,
       ROUND(100 * SUM(CASE WHEN seller_rank <= CEIL(0.10 * total_sellers)
                            THEN revenue END) / MAX(total_revenue), 1) AS top10pct_sellers_share_pct,
       MIN(CASE WHEN running_revenue >= 0.8 * total_revenue
                THEN seller_rank END)               AS sellers_needed_for_80pct,
       ROUND(100 * MIN(CASE WHEN running_revenue >= 0.8 * total_revenue
                            THEN seller_rank END) / MAX(total_sellers), 1) AS pct_of_sellers_for_80pct
FROM ranked;

-- Part B: the top 10 sellers with their share of revenue
WITH seller_revenue AS (
  SELECT oi.seller_id,
         COUNT(DISTINCT oi.order_id) AS orders,
         SUM(oi.price)               AS revenue
  FROM order_items oi
  JOIN orders o ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY oi.seller_id
),
ranked AS (
  SELECT seller_id,
         orders,
         revenue,
         ROW_NUMBER() OVER (ORDER BY revenue DESC, seller_id) AS seller_rank,
         SUM(revenue) OVER ()                                 AS total_revenue,
         SUM(revenue) OVER (ORDER BY revenue DESC, seller_id) AS running_revenue
  FROM seller_revenue
)
SELECT seller_rank,
       LEFT(seller_id, 8)                              AS seller,
       orders,
       ROUND(revenue, 2)                               AS revenue,
       ROUND(100 * revenue / total_revenue, 2)         AS pct_of_total,
       ROUND(100 * running_revenue / total_revenue, 1) AS cumulative_pct
FROM ranked
ORDER BY seller_rank
LIMIT 10;
