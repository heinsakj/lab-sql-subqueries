-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(i.inventory_id), f.title
FROM inventory i
JOIN film f
ON i.film_id = f.film_id
WHERE f.title = "Hunchback Impossible";

-- 2. List all films whose length is longer than the average of all the films.
SELECT AVG(length) FROM film;

SELECT film_id, title, length FROM film
WHERE length > (
 SELECT AVG(length)
 FROM film
 ORDER BY length DESC
 );
-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
-- Use subqueries

SELECT first_name, last_name FROM actor
WHERE actor_id IN (
SELECT actor_id FROM film_actor
WHERE film_id IN (
SELECT film_id
FROM film
WHERE title = "Alone Trip")
); 

SELECT film_id, actor_id
FROM film_actor;

SELECT first_name, last_name, actor_id
FROM actor;

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT title AS 'Family Movies' FROM film
WHERE film_id IN(
SELECT film_id FROM film_category
WHERE category_id IN (
SELECT category_id 
FROM category
WHERE name = 'Family'
)
);

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and 
-- foreign keys, that will help you get the relevant information.

	-- 1. Use subqueries
    SELECT first_name, last_name, email FROM customer
    WHERE address_id IN(
    SELECT address_id FROM address
    WHERE city_id IN(
    SELECT city_id FROM city
    WHERE country_id IN(
    SELECT country_id 
    FROM country
    WHERE country = 'Canada'
    )
    )
    );
    
    -- and 2. joins
    
    SELECT c.last_name, c.first_name, c.email
    FROM customer c
    JOIN address a
    ON c.address_id = a.address_id
    JOIN city ci
    ON a.city_id = ci.city_id
    JOIN country co
    ON ci.country_id = co.country_id
    WHERE country = 'Canada';


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that
--  has acted in the most number of films. First you will have to find the most prolific actor and then use 
-- that actor_id to find the different films that he/she starred.

	-- 1. who is the most prolific actor - the actor who has been in the most number of films, then list all those films
    -- 2. Use actor_id to find the most films
    SELECT title FROM film
    WHERE film_id IN (
    SELECT film_id FROM film_actor
    WHERE actor_id LIKE (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
    )
    );
    
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the 
-- most profitable customer ie the customer that has made the largest sum of payments

	-- Customer who has spent the most money. MAX sum. What films have they rented
    SELECT title FROM film
    WHERE film_id IN (
    SELECT film_id FROM inventory
    WHERE inventory_id IN (
    SELECT inventory_id FROM rental
    WHERE customer_id LIKE (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1)
    )
    );
    
    
-- 8. Customers who spent more than the average payments.

	-- Average payment a customer has made
SELECT first_name, last_name FROM customer
WHERE customer_id IN (
SELECT customer_id FROM payment 
WHERE amount IN (
SELECT AVG(amount)
FROM payment
GROUP BY customer_id
HAVING AVG(amount) > (
SELECT AVG(amount) AS average_payment
FROM payment
)
)
);


SELECT customer_id, first_name, last_name FROM customer 
WHERE customer_id IN (
SELECT customer_id FROM
(SELECT customer_id, ROUND(AVG(amount),2) AS average_payment 
FROM payment
GROUP BY customer_id
HAVING average_payment > 
(SELECT AVG(amount) AS averape_payment 
FROM payment)
) subs
);