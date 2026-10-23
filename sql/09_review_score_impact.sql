USE olist_db;

-- Q6. Impact of late deliveries on review scores
-- Late = delivered AFTER the estimated delivery date (date-level comparison)

DROP TEMPORARY TABLE IF EXISTS delivery_review;
CREATE TEMPORARY TABLE delivery_review AS
SELECT o.order_id,
       r.review_score,
       DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS days_late,
       CASE WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) > 0
            THEN 'Late' ELSE 'On-Time' END AS delivery_status
FROM orders o
JOIN order_reviews r ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_estimated_delivery_date IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
  AND r.review_score IS NOT NULL;

-- Average score and 1-5 star distribution by delivery status
SELECT delivery_status,
       COUNT(*) AS total_reviews,
       ROUND(AVG(review_score), 2) AS avg_review_score,
       SUM(review_score = 1) AS score_1,
       SUM(review_score = 2) AS score_2,
       SUM(review_score = 3) AS score_3,
       SUM(review_score = 4) AS score_4,
       SUM(review_score = 5) AS score_5
FROM delivery_review
GROUP BY delivery_status
ORDER BY avg_review_score DESC;

-- Average score by how many days late
SELECT CASE
         WHEN days_late <= 0 THEN 'On-Time'
         WHEN days_late BETWEEN 1 AND 3 THEN '1-3 Days Late'
         WHEN days_late BETWEEN 4 AND 7 THEN '4-7 Days Late'
         WHEN days_late BETWEEN 8 AND 14 THEN '8-14 Days Late'
         ELSE '15+ Days Late'
       END AS delay_bucket,
       COUNT(*) AS reviews,
       ROUND(AVG(review_score), 2) AS avg_score
FROM delivery_review
GROUP BY delay_bucket
ORDER BY MIN(days_late);
