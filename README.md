# Olist E-commerce SQL Analysis

MySQL analysis of ~100K orders from a Brazilian online marketplace (2016-2018).

## Business problem
Leadership wants to understand growth, delivery performance and customer
loyalty. This project answers 10 business questions using SQL.

## Dataset
[Brazilian E-Commerce Public Dataset by Olist (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

9 source files: orders, order items, payments, reviews, customers, products,
sellers, geolocation and category translation (geolocation is not used here).

## Business questions
1. What is the monthly revenue and order trend, with month-over-month growth?
2. Which product categories generate the most revenue?
3. What is the average order value by customer state?
4. Which states have the slowest delivery times?
5. What percentage of orders arrive late?
6. How much do late deliveries lower review scores?
7. What is the repeat-customer rate?
8. How concentrated is revenue among sellers (the 80/20 question)?
9. How do payment types and installments relate to order value?
10. Who are the best customers (RFM segmentation)?

## Tools
MySQL 8, CTEs, window functions, data quality checks

## Key findings
### Q3. Average order value by customer state
![Average order value by state](images/q3_avg_order_value_by_state.png)

1. The overall average order value across all delivered orders is **R$137.04**,
   based on 96,478 orders generating R$13.22M in revenue.
2. **Paraíba (PB)** has the highest average order value at **R$217.77** (517 orders),
   followed by Alagoas (AL) at R$198.63 and Rondônia (RO) at R$187.99.
3. The largest markets — **São Paulo (SP), Minas Gerais (MG), and Rio de Janeiro (RJ)**
   — have below-average order values (roughly R$130–143), suggesting customers in
   these states buy more frequently but in smaller baskets.
4. Several northern states (AP, AC, RR) show inflated averages due to very small
   sample sizes (fewer than 100 orders each); these should be interpreted cautiously.

_AOV = SUM(item price) per delivered order, averaged by customer state.
Freight excluded. Small-sample states flagged._

### Q1. Monthly revenue and growth
![Monthly revenue and MoM growth](images/q1_monthly_revenue.png)

1. Delivered orders generated **R$13.22M** in revenue between Sep 2016 and Aug 2018.
2. Revenue peaked in **Nov 2017 at R$987,765** (+52.4% vs Oct 2017, Black Friday),
   with 7,289 orders, the most of any month.
3. **Jan-Aug 2018 revenue was R$7.22M, about 2.4x the same months of 2017**
   (R$2.99M), a rise of roughly 141%.
4. Growth levelled off in 2018: after January, monthly revenue stayed between
   R$826K and R$978K.

_Note: Sep-Dec 2016 has almost no data and Nov 2016 has no delivered orders, so
growth percentages for those early months (and Jan 2017) are not meaningful._

### Q2. Top product categories by revenue
![Top 10 product categories by revenue](images/q2_top_categories.png)

1. **health_beauty** is the top category with R$1.23M (9.3% of revenue), followed
   by **watches_gifts** (R$1.17M, 8.8%) and **bed_bath_table** (R$1.02M, 7.7%).
2. The top 10 categories generate **62.4%** of delivered revenue (R$8.25M of
   R$13.22M). The top 3 alone bring in 25.9%.
3. Order volume and revenue rank differently: bed_bath_table has the most orders
   (9,272) but ranks third, while watches_gifts ranks second with only 5,495
   orders because its revenue per order is about R$212, against about R$110 for
   bed_bath_table.

_Revenue = item price of delivered orders, freight excluded._

## Recommendations
_Coming soon_
