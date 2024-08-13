/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, SUM(m.price) AS Total_sales
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id

-- 2. How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT order_date) AS Time_visited
FROM sales
GROUP BY customer_id

-- 3. What was the first item from the menu purchased by each customer?
SELECT DISTINCT s.customer_id, m.product_name
FROM sales s
JOIN menu m ON s.product_id = m.product_id
WHERE s.order_date IN (
    SELECT MIN(s.order_date) AS first_date
    FROM sales s
    GROUP BY s.customer_id
)


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT m.product_name, COUNT(m.product_name) AS purchase_count
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1 


-- 5. Which item was the most popular for each customer?
WITH customer_purchases AS (
    SELECT s.customer_id, m.product_name, COUNT(*) AS product_count
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
),
max_purchases AS (
    SELECT customer_id, MAX(product_count) AS max_count
    FROM customer_purchases
    GROUP BY customer_id
)
SELECT cp.customer_id, cp.product_name, cp.product_count
FROM customer_purchases cp
JOIN max_purchases mp ON cp.customer_id = mp.customer_id AND cp.product_count = mp.max_count;


-- 6. Which item was purchased first by the customer after they became a member?
SELECT s.customer_id, s.order_date AS first_order, me.product_name
FROM sales s
JOIN members m ON s.customer_id = m.customer_id
JOIN menu me ON s.product_id = me.product_id
WHERE 
    s.order_date >= m.join_date
    AND s.order_date = (
        SELECT MIN(s2.order_date)
        FROM sales s2
        WHERE s2.customer_id = s.customer_id
        AND s2.order_date >= m.join_date
    );


-- 7. Which item was purchased just before the customer became a member?
SELECT s.customer_id, s.order_date AS first_order, me.product_name
FROM sales s
JOIN members m ON s.customer_id = m.customer_id
JOIN menu me ON s.product_id = me.product_id
WHERE 
    s.order_date < m.join_date
    AND s.order_date = (
        SELECT Max(s2.order_date)
        FROM sales s2
        WHERE s2.customer_id = s.customer_id
        AND s2.order_date < m.join_date
    );
