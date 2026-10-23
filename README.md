# Olist E-commerce SQL Analysis

MySQL analysis of ~100K orders from a Brazilian online marketplace (2016-2018).

## Business problem
Leadership wants to understand growth, delivery performance and customer
loyalty. This project answers 10 business questions using SQL.

## Dataset
[Brazilian E-Commerce Public Dataset by Olist (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
9 tables: orders, order items, payments, reviews, customers, products, sellers,
geolocation and category translation.

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
MySQL 8 · CTEs · window functions · data quality checks

## Key findings
_Coming soon_

## Recommendations
### Q1. Monthly revenue and growth
![Monthly revenue and MoM growth](images/q1_monthly_revenue.png)

1. Delivered orders generated **R$13.22M** in revenue between Sep 2016 and Aug 2018.
2. Revenue peaked in **Nov 2017 at R$987,765** (+52.4% vs Oct 2017, Black Friday),
   with 7,289 orders, the most of any month.
3. **Jan-Aug 2018 revenue was R$7.22M, about 2.4x the same months of 2017**
   (R$2.99M), a rise of roughly 141%.
4. Growth levelled off in 2018: after January, monthly revenue stayed between
   R$830K and R$980K.

_Note: Sep-Dec 2016 has almost no data and Nov 2016 has no delivered orders, so
growth percentages for those early months (and Jan 2017) are not meaningful._