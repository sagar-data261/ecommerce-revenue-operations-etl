CREATE DATABASE	ecommerce_sales_database;
USE ecommerce_sales_database;


-- 1. What is the total realized net revenue across all orders, and how much potential gross revenue was lost due to promotional discounts?

SELECT round(SUM(total_price),2) as 'Net Revenue', 
round(SUM(discounted_price),2) as 'Discounted Revenue', 
round((round(SUM(total_price),2) - round(SUM(discounted_price),2)),2) as 'Revenue Lost'
FROM ecommerce_sales_data;

-- 2. Which product categories generate the highest total revenue, and how does the Average Order Value (AOV) differ across them?

SELECT product_category, round(SUM(revenue),2) as Total_Revenue, round(avg(revenue),2) as 'Average Revenue'
FROM ecommerce_sales_data
GROUP BY product_category
ORDER BY Total_Revenue DESC;

-- 3. How is revenue distributed across the four geographical regions, and which region has the highest average revenue per order?

SELECT region, round(SUM(revenue),2) as 'Total Revenue', round(avg(revenue),2) as Average_Revenue
FROM ecommerce_sales_data
GROUP BY region
ORDER BY Average_Revenue DESC;

-- 4. Does offering higher discount percentages result in significantly higher order quantities, or does it primarily erode profit margins?

WITH sales_data AS (
SELECT discount, revenue, quantity,
CASE 
	WHEN discount< .1 THEN 'low'
	WHEN discount< .2 THEN 'moderate'
	WHEN discount< .3 THEN 'high'
	ELSE 'very high'
END AS discount_category
FROM ecommerce_sales_data
)

SELECT discount_category, 
round(avg(quantity),2) AS avg_puchased_unit,
round(sum(revenue),2) AS net_revenue,
count(*) AS transaction_count
FROM sales_data
GROUP BY discount_category
ORDER BY avg_puchased_unit DESC;

-- 5. Which product category receives the deepest discounts, and is there any noticeable impact on customer satisfaction ratings?

SELECT product_category, 
round(avg(discount)*100,2) as avg_discount, 
round(avg(customer_rating),2) as avg_customer_rating,
max(discount*100) as max_discount
FROM ecommerce_sales_data
GROUP BY product_category
ORDER BY avg_discount;

-- 6. What percentage of total orders exceed an acceptable delivery threshold of 7 days, and which region experiences the highest transit delays?

-- which region experiences the highest transit delays
SELECT region, sum(delivery_days > 7) as delayed_delivery
FROM ecommerce_sales_data
GROUP BY region
ORDER BY delayed_delivery DESC;

--  What percentage of total orders exceed an acceptable delivery threshold of 7 days
SELECT 
    ROUND(SUM(delivery_days > 7) * 100.0 / COUNT(order_id), 2) AS `late_delivery(%)`,
    SUM(delivery_days > 7) AS late_orders,
    COUNT(order_id) AS total_orders
FROM ecommerce_sales_data;

-- 7. Is there a measurable drop in customer ratings when delivery times increase from short (1–3 days) to extended (8–11 days)?

SELECT round(avg(customer_rating),2) AS avg_ratings, count(*) AS total_orders,
CASE
	WHEN delivery_days <= 3 THEN 'short'
    WHEN delivery_days <= 7 THEN 'moderate'
    ELSE 'extended'
    END AS delivery_tier
FROM ecommerce_sales_data
GROUP BY delivery_tier
ORDER BY avg_ratings DESC;

-- 8. Does the choice of payment method (Card, COD, Wallet) lead to differences in delivery duration or order fulfillment speed?

SELECT payment_method, round(avg(delivery_days),2) as avg_delivery_days
FROM ecommerce_sales_data
GROUP BY payment_method
ORDER BY avg_delivery_days;

-- 9. What proportion of unique customers account for the top tier of cumulative spend, and how frequent are repeat buyers?

-- What proportion of unique customers account for the top tier of cumulative spend
WITH customer_spending AS (
    SELECT 
        customer_id,
        SUM(revenue) AS total_spend
    FROM ecommerce_sales_data
    GROUP BY customer_id
),
tiered_customers AS (
    SELECT 
        customer_id,
        total_spend,
        NTILE(5) OVER (ORDER BY total_spend DESC) AS customer_tier
    FROM customer_spending
)
SELECT 
    customer_tier,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_spend), 2) AS tier_revenue,
    ROUND(SUM(total_spend) * 100.0 / (SELECT SUM(revenue) FROM ecommerce_sales_data), 2) AS pct_of_total_revenue
FROM tiered_customers
GROUP BY customer_tier
ORDER BY customer_tier;

-- how frequent are repeat buyers
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(order_id) AS order_count
    FROM ecommerce_sales_data
    GROUP BY customer_id
),
classified_customers AS (
    SELECT 
        customer_id,
        order_count,
        CASE 
            WHEN order_count = 1 THEN 'One-time (1 order)'
            WHEN order_count BETWEEN 2 AND 5 THEN 'Regular (2-5 orders)'
            ELSE 'Frequent (6+ orders)'
        END AS buyer_type
    FROM customer_orders
)
SELECT 
    buyer_type,
    COUNT(customer_id) AS customer_count,
    ROUND(COUNT(customer_id) * 100.0 / (SELECT COUNT(DISTINCT customer_id) FROM ecommerce_sales_data), 2) AS customer_pct,
    SUM(order_count) AS total_orders_placed
FROM classified_customers
GROUP BY buyer_type
ORDER BY customer_count DESC;

-- 10. How do total order volume and average ticket size compare across the different payment methods?

SELECT payment_method, 
round(count(order_id),2) as total_orders, 
round(avg(revenue),2) as average_ticket_size, 
round(sum(revenue),2) as total_revenue
FROM  ecommerce_sales_data
GROUP BY payment_method
ORDER BY total_orders;
