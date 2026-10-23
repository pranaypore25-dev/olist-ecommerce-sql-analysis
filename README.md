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

### Q3. Average order value by customer state
![Average order value by state](images/q3_avg_order_value_by_state.png)

1. The overall average order value across all delivered orders is **R$137.04**,
   based on 96,478 orders generating R$13.22M in revenue.
2. **Para?ba (PB)** has the highest average order value at **R$217.77** (517 orders),
   followed by Alagoas (AL) at R$198.63 and Rond?nia (RO) at R$187.99.
3. The largest markets ? **S?o Paulo (SP), Minas Gerais (MG), and Rio de Janeiro (RJ)**
   ? have below-average order values (roughly R$130?143), suggesting customers in
   these states buy more frequently but in smaller baskets.
4. Several northern states (AP, AC, RR) show inflated averages due to very small
   sample sizes (fewer than 100 orders each); these should be interpreted cautiously.

_AOV = SUM(item price) per delivered order, averaged by customer state.
Freight excluded. Small-sample states flagged._

### Q4. Average delivery time by customer state
![Average delivery time by state](images/q4_avg_delivery_time_by_state.png)

1. The national average delivery time is **12.50 days** across 96,470 delivered orders.
2. **S?o Paulo (SP)** is the fastest state at **8.70 days** average, handling 42% of all
   delivered orders (40,494). Paran? (PR) and Minas Gerais (MG) follow at ~12 days.
3. Remote northern states face significantly longer waits: **Roraima (RR)** averages
   **29.34 days**, Amap? (AP) 27.18 days, and Amazonas (AM) 26.36 days ? roughly
   3x slower than S?o Paulo.
4. Extreme outliers exist: several states show maximum delivery times of 170?196 days,
   suggesting stuck or lost packages that inflate averages. Northern states also have
   small sample sizes (<150 orders), so their rankings should be interpreted cautiously.

_Delivery time = DATEDIFF(order_delivered_customer_date, order_purchase_timestamp).
Only delivered orders with non-NULL delivery dates included._

### Q5. Percentage of late deliveries
![Late delivery percentage](images/q5_pct_late_deliveries.png)

1. Only **6.77%** of delivered orders arrive late (6,534 out of 96,470), but when
   deliveries are late, customers wait an average of **10.62 extra days**.
2. **Alagoas (AL)** has the highest late rate at **21.41%**, followed by Maranh?o
   (MA) at 17.43% ? both Northeast states with underdeveloped logistics. In contrast,
   S?o Paulo (SP) maintains just **4.49%** late rate despite handling 42% of all orders.
3. By category, **furniture and mattresses** show the highest late rates (13.51%),
   while high-volume categories like health/beauty (7.51%) and bed/bath/table (7.43%)
   perform near the national average, indicating mature logistics for core product lines.
4. Remote northern states (AM, RO, AP) paradoxically have the *lowest* late rates
   (2.76?2.99%) despite longest delivery times (Q4), suggesting their delays are
   predictable and baked into estimates rather than unexpected failures.

_Late = order_delivered_customer_date > order_estimated_delivery_date.
Only delivered orders with valid estimated dates included._

## Recommendations
_Coming soon_
