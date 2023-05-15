-- Use “Sakila” database for the following questions
-- ===========================================================
-- Q1 Display all tables available in the database “sakila” 
  SHOW Tables FROM sakila

-- Q2 Display structure of table “actor”. (4 row) 
  DESCRIBE actor

-- Q3 Display the schema which was used to create table “actor” and view the complete schema using the viewer. (1 row) 
 SHOW CREATE TABLE actor;

-- Q4 Display the first and last names of all actors from the table actor. (200 rows) 
  SELECT * FROM actor

-- Q5 Which actors have the last name ‘Johansson’. (3 rows) 
 SELECT * FROM actor WHERE last_name = "Johansson"

-- Q6 Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. (200 rows) 
 SELECT UPPER(first_name),UPPER(last_name) FROM actor

-- Q7 You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information? (1 row) 
 SELECT * FROM actor WHERE first_name = 'joe'

-- Q8 Which last names are not repeated? (66 rows) 
 SELECT last_name FROM actor GROUP BY last_name HAVING COUNT(*) = 1

-- Q9 List the last names of actors, as well as how many actors have that last 
SELECT *,COUNT(*) FROM actor GROUP BY last_name

-- Q10 Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables “staff” and “address”. (2 rows)
 SELECT s.first_name, s.last_name, a.address FROM staff s JOIN address a ON s.address_id = a.address_id;
-- ================================================================================================================
-- Use “world” database for the following questions 

-- Q1 Display all columns and 10 rows from table “city”.(10 rows) 
SELECT * FROM city LIMIT 10;

-- Q2 Modify the above query to display from row # 16 to 20 with all columns. (5 rows)
  SELECT * FROM city  LIMIT 5 OFFSET  15;

-- Q3 How many rows are available in the table city. (1 row)-4079. 
  SELECT COUNT(*) FROM city;

-- Q4 Using city table find out which is the most populated city. 
-- ('Mumbai (Bombay)', '10500000') 
 select   name,population from city where population >= all ( select population from city)

 
-- Q5 Using city table find out the least populated city. 
-- ('Adamstown', '42') 
 select name,population from city where population <= all (select population from city)


-- Q6 Display name of all cities where population is between 670000 to 700000. (13 rows) 
 SELECT Name FROM city WHERE Population BETWEEN 670000 AND 700000;




-- Q7 Find out 10 most populated cities and display them in a decreasing order i.e. most populated city to appear first. 
 SELECT Name,Population FROM city  order by Population desc limit 10



-- Q8 Order the data by city name and get first 10 cities from city table. 
 SELECT Name  FROM city order by Name  asc limit 10


-- Q9 Display all the districts of USA where population is greater than 3000000, from city table. (6 rows) 
 SELECT District FROM city WHERE CountryCode = 'USA'AND Population > 3000000;

-- Q10 What is the value of name and population in the rows with ID =5, 23, 432 and 2021. Pl. write a single query to display the same. (4 rows). 
 SELECT Name,Population  FROM city WHERE ID IN (5, 23, 432);


-- SQL Practice – Part 2
-- ===================================================================
-- Use “Sakila” database for the following questions

-- Q1 Which actor has appeared in the most films? (‘107', 'GINA', 'DEGENERES', '42') 
   SELECT actor.first_name,COUNT(film_actor.actor_id) as film_count FROM film_actor JOIN actor ON  film_actor.actor_id = actor.actor_id group by actor.actor_id,actor.first_name
 order by  film_count desc limit 1

-- Q2 What is the average length of films by category? (16 rows) 
 SELECT category.name, AVG(film.length)  AS avarage_length FROM film JOIN  category ON  film.film_id = category.category_id group by category.category_id,category.name


-- Q3 Which film categories are long? (5 rows) 
  SELECT customer.last_name,SUM(payment.amount) AS total FROM  payment JOIN customer ON customer.customer_id = payment.customer_id group by customer.customer_id order by customer.last_name 

-- Q4 How many copies of the film “Hunchback Impossible” exist in the inventory system? (6) 
 SELECT COUNT(film.film_id) AS Stock FROM inventory JOIN film ON film.film_id = inventory.film_id WHERE film.title = "Hunchback Impossible"


-- Q5 Using the tables “payment” and “customer” and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name (599 rows) 
-- Use “world” database for the following questions 

  SELECT customer.last_name,SUM(payment.amount) AS total FROM  payment JOIN customer ON customer.customer_id = payment.customer_id group by customer.customer_id order by customer.last_name 

-- Q1 Write a query in SQL to display the code, name, continent and GNP for all the countries whose country name last second word is 'd’, using “country” table. (22 rows) 
  SELECT Code,Name,Continent,GNP FROM country WHERE Name LIKE '%d_'

-- Q2 Write a query in SQL to display the code, name, continent and GNP of the 2nd and 3rd highest GNP from “country” table. (Japan & Germany) 
SELECT Code,Name,Continent,GNP FROM country order by GNP desc limit 2 offset 1

-- Q1 Write a query to display Employee id and First Name of an employee whose dept_id = 100. (Use:Sub-query)(6 rows)
  SELECT EMPLOYEE_ID,FIRST_NAME FROM employees WHERE DEPARTMENT_ID = 100 

-- Q2. Write a query to display the dept_id, maximum salary, of all the departments whose maximum salary is greater than the average salary. (USE: SUB-QUERY) (11 rows) 
 SELECT DEPARTMENT_ID, MAX(Salary) AS max_salary FROM employees GROUP BY DEPARTMENT_ID HAVING MAX(Salary) > (SELECT AVG(Salary) FROM employees

-- Q3 Write a query to display department name and, department id of the employees whose salary is less than 35000. .(USE:SUB-QUERY)(11 rows) 
SELECT departments.DEPARTMENT_NAME,departments.DEPARTMENT_ID FROM departments INNER JOIN employees ON employees.DEPARTMENT_ID = departments.DEPARTMENT_ID WHERE employees.Salary < 35000