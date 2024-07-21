--  The Taste of The World Cafe debuted a new menu at the start of the year. You have been asked to dig into the
--  customer data to see which items are doing well/not well, and what the top customers seem to like the best

-- Objectives:
-- 1. Explore the menu_items table to get an idea of what's on the new menu
-- 2. Explore the order_details table to get an idea of the data that's been collected 
-- 3. Use both tables to understand how customers are reacting to the new menu 

-- OBJECTIVE 1: Explore the menu_items table

-- Find the number of items on the menu
SELECT COUNT(*) from menu_items

-- What are the least and most expensive items on the menu
SELECT MIN(price), MAX(price) FROM menu_items

-- How many dishes are in each category?
SELECT category, count(*) as num_dishes
from menu_items
GROUP by category

-- What is the average dish price within each category?
SELECT category, AVG(price) as average_price
from menu_items
GROUP by category

-- OBJECTIVE 2: Explore the orders table

-- How many orders were made within the total date range?
SELECT count(DISTINCT order_id)
from order_details

-- Which orders had the most number of items?
SELECT order_id, count(item_id) as num_items
from order_details
GROUP by order_id
order by num_items DESC

-- How many orders had more than 12 items?
SELECT count(*)
from (SELECT order_id, count(item_id) as num_items
      from order_details
      GROUP by order_id
      HAVING num_items > 12)
      
-- OBJECTIVE 3: Analyze customer behavior

-- What were the least and most ordered items, and what categories were they in?
SELECT item_name, category, count(*) as num_purchases
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
group by item_name, category
order by num_purchases DESC
-- Answer: The least ordered item is Chicken Taco in category Mexican and the most ordered
--         item is Hamburger in category American

-- What were the top 5 orders that spent the most amount of money?
SELECT order_id, SUM(price) as total_spend
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
group BY order_id
order by total_spend desc
LIMIT 5

-- View the details of the top spend orders. What insights can you gather from that?
SELECT category, count(item_id) as num_items
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
where order_id in (440, 2075, 1957, 330, 2675)
group by category
-- Answer: The top orders ordered a lot of Italian food compare to other categories. We should
--         keep these expensive Italian dishes on the menu since customers seem to order these 
--         a lot, especially the highest spend customers. We could also trim the menu on certain 
--         items that's the least popular like Chicken Taco