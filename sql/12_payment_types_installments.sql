USE olist_db;

-- Q9. Payment types and installments vs order value
-- Delivered orders only. Payment value includes freight, so totals are higher
-- than the item revenue in Q1. order_payments is never joined to order_items,
-- which would repeat payment rows and inflate sums.

-- Part A: payment type mix
-- An order paid with two types counts in both rows, so the orders column
-- adds up to more than the number of orders.
SELECT p.payment_type,
       COUNT(DISTINCT p.order_id)                          AS orders,
       ROUND(SUM(p.payment_value), 2)                      AS payment_value,
       ROUND(100 * SUM(p.payment_value)
             / SUM(SUM(p.payment_value)) OVER (), 1)       AS pct_of_payment_value,
       ROUND(SUM(p.payment_value)
             / COUNT(DISTINCT p.order_id), 2)              AS avg_payment_per_order
FROM order_payments p
JOIN orders o ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.payment_type
ORDER BY payment_value DESC;

-- Part B: credit card installments vs total order payment
-- Each order is totalled first (all its payment rows), then bucketed by the
-- highest installment count on its credit card payments.
WITH order_pay AS (
  SELECT p.order_id,
         SUM(p.payment_value) AS order_payment,
         MAX(CASE WHEN p.payment_type = 'credit_card'
                  THEN p.payment_installments END) AS cc_installments
  FROM order_payments p
  JOIN orders o ON o.order_id = p.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY p.order_id
)
SELECT CASE WHEN cc_installments <= 1  THEN '1 (pay in full)'
            WHEN cc_installments <= 3  THEN '2-3'
            WHEN cc_installments <= 6  THEN '4-6'
            WHEN cc_installments <= 10 THEN '7-10'
            ELSE '11+' END                                    AS installment_bucket,
       COUNT(*)                                               AS orders,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)       AS pct_of_card_orders,
       ROUND(AVG(order_payment), 2)                           AS avg_order_payment
FROM order_pay
WHERE cc_installments IS NOT NULL
GROUP BY installment_bucket
ORDER BY MIN(cc_installments);

-- Sanity check: total payments and the number of delivered orders with payments
-- The total should equal the sum of payment_value in Part A.
SELECT ROUND(SUM(p.payment_value), 2)  AS total_payment_value,
       COUNT(DISTINCT p.order_id)      AS delivered_orders_with_payment
FROM order_payments p
JOIN orders o ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';
