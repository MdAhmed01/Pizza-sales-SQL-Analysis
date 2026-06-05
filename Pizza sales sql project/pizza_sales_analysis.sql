
-- Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders;
----------------------------------------------------------------------------
-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * p.price), 0) AS total_revenue
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;
  ----------------------------------------------------------------------------  
-- Identify the highest-priced pizza.
SELECT 
    pt.name,p.price AS expensive_pizza
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;
----------------------------------------------------------------------------
-- Identify the most common pizza size ordered.
SELECT 
    COUNT(od.order_details_id) AS order_count, p.size
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY order_count DESC
LIMIT 1;
----------------------------------------------------------------------------
-- List the top 5 most ordered pizza types along with their quantities. 
SELECT 
    pt.name, SUM(od.quantity) as quantities
FROM 
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY quantities DESC
LIMIT 5;
---------------------------------------------------------------------------------------

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, SUM(od.quantity) AS quantity
FROM 
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category;
--------------------------------------------------------------------------------------- 
-- Determine the distribution of orders by hour of the day.

SELECT 
    COUNT(order_id) AS order_count,
    HOUR(order_time) AS hour_of_day
FROM
    orders
GROUP BY hour_of_day;
---------------------------------------------------------------------------------------

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;
---------------------------------------------------------------------------------------

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(total_pizza))
FROM 
    (SELECT 
        SUM(od.quantity) AS total_pizza, o.order_date
    FROM
        order_details od
    JOIN orders o ON od.order_id = o.order_id
    GROUP BY o.order_date) AS pizza_quantity;
---------------------------------------------------------------------------------------
  
-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    SUM(p.price * od.quantity) AS total_piz_sales, pt.name
FROM 
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_piz_sales DESC
LIMIT 3;
---------------------------------------------------------------------------------------
-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category,
    ROUND(SUM(od.quantity * p.price)) / (SELECT 
            ROUND(SUM(od.quantity * p.price), 0) AS total_revenue
        FROM
            order_details od
                JOIN
            pizzas p ON od.pizza_id = p.pizza_id) * 100 AS percent_con
FROM 
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category;
---------------------------------------------------------------------------------------
-- Analyze the cumulative revenue generated over time.
select 
	order_date,
    sum(total_revenue) over(order by order_date) as cum_rev 
from 
	(select o.order_date, 
    ROUND(SUM(od.quantity * p.price), 0) AS total_revenue 
from 
	orders o 
		join 
	order_details od on o.order_id=od.order_id 
		join 
	pizzas p on od.pizza_id=p.pizza_id 
group by o.order_date) as sales;
-----------------------------------------------------------------------------------------
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.








