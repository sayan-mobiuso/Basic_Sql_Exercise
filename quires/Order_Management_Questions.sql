-- 1. Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) as per the following criteria and sort them in descending order of category: a. If the category is 2050, increase the price by 2000 b. If the category is 2051, increase the price by 500 c. If the category is 2052, increase the price by 600. Hint: Use case statement. no permanent change in table required. (60 ROWS) [NOTE: PRODUCT TABLE]

	 SELECT  product_id,PRODUCT_CLASS_CODE, product_desc, product_price ,
	 CASE product_class_code WHEN 2500 THEN  product_price + 2000 
	 WHEN 2051 THEN product_price + 500 
	 WHEN 2052 THEN product_price + 600 
	 ELSE product_price END AS 
	 Updated_Price FROM 
	 PRODUCT  ORDER BY product_class_code DESC LIMIT 60


-- 2. Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) and Show inventory status of products as below as per their available quantity: a. For Electronics and Computer categories, if available quantity is <= 10, show 'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, show 'Enough stock' b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock' c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', >= 51 – 'Enough stock' For all categories, if available quantity is 0, show 'Out of stock'. Hint: Use case statement. (60 ROWS) [NOTE: TABLES TO BE USED – product, product_class]
	  SELECT pc.product_class_desc,p.product_id,p.product_desc,p.product_quantity_avail,
	  CASE 
		WHEN pc.product_class_desc IN ('Electronics', 'Computer') THEN 
		  CASE 
			WHEN p.product_quantity_avail <= 10 THEN 'Low stock' 
			WHEN p.product_quantity_avail BETWEEN 11 AND 30 THEN 'In stock' 
			ELSE 'Enough stock' 
		  END 
		WHEN pc.product_class_desc IN ('Stationery', 'Clothes') THEN 
		  CASE 
			WHEN p.product_quantity_avail <= 20 THEN 'Low stock' 
			WHEN p.product_quantity_avail BETWEEN 21 AND 80 THEN 'In stock' 
			ELSE 'Enough stock' 
		  END 
		ELSE 
		  CASE 
			WHEN p.product_quantity_avail <= 15 THEN 'Low stock' 
			WHEN p.product_quantity_avail BETWEEN 16 AND 50 THEN 'In stock' 
			ELSE 'Enough stock' 
		  END 
		END AS inventory_status
	FROM product p
	JOIN product_class pc ON p.product_class_id = pc.product_class_id;

        


-- 3. Write a query to Show the count of cities in all countries other than USA & MALAYSIA, with more than 1 city, in the descending order of CITIES. (2 rows) [NOTE: ADDRESS TABLE, Do not use Distinct]

	 SELECT country ,COUNT(city) AS all_cities FROM address
	 WHERE country NOT IN ('USA','MALAYSIA') 
	 GROUP BY country
	 HAVING  COUNT(city) > 1 
	 ORDER BY all_cities desc;





-- 4. Write a query to display the customer_id,customer full name ,city,pincode,and order details (order id, product class desc, product desc, subtotal(product_quantity * product_price)) for orders shipped to cities whose pin codes do not have any 0s in them. Sort the output on customer name and subtotal. (52 ROWS) [NOTE: TABLE TO BE USED - online_customer, address, order_header, order_items, product, product_class]

	 SELECT oc.CUSTOMER_ID,oc.CUSTOMER_FNAME ||' '||oc.CUSTOMER_LNAME AS Fullname,a.city,a.pincode,oi.order_id,pc.product_class_desc,p.product_desc,oi.product_quantity*p.product_price AS subtotal FROM online_customer oc 
		JOIN address a ON oc.address_id = a.address_id 
		JOIN order_header oh ON oc.customer_id = oh.customer_id 
		JOIN order_items oi ON oh.order_id = oi.order_id 
		JOIN product p ON oi.product_id = p.product_id 
		JOIN product_class pc ON p.product_class_code = pc.product_class_code
	 WHERE a.pincode NOT LIKE '%0%'AND oh.ORDER_STATUS = "Shipped" 
	 ORDER BY Fullname,subtotal desc;


-- 5. Write a Query to display product id,product description,totalquantity(sum(product quantity) for an item which has been bought maximum no. of times (Quantity Wise) along with product id 201. (USE SUB-QUERY) (1 ROW) [NOTE: ORDER_ITEMS TABLE, PRODUCT TABLE]
  SELECT p.product_id,p.product_desc,SUM(oi.product_quantity) AS total_quantity FROM product p 
  JOIN order_items oi ON p.product_id = oi.product_id 
  WHERE oi.product_id = "201";
    

-- 6. Write a query to display the customer_id,customer name, email and order details (order id, product desc,product qty, subtotal(product_quantity * product_price)) for all customers even if they have not ordered any item.(225 ROWS) [NOTE: TABLE TO BE USED - online_customer, order_header, order_items, product]

  SELECT oc.customer_id,oc.CUSTOMER_FNAME ||' '|| oc.CUSTOMER_LNAME AS Fullname,oc.CUSTOMER_EMAIL,oi.order_id,p.product_desc,oi.product_quantity,oi.product_quantity*p.product_price AS subtotal FROM 
  online_customer oc  
  LEFT JOIN  order_header oh ON oc.customer_id = oh.customer_id 
  LEFT JOIN order_items oi ON oh.order_id = oi.order_id 
  LEFT JOIN product p  ON oi.product_id = p.product_id;



-- 7. Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box). (1 ROW) [NOTE: CARTON TABLE]
	 SELECT c.carton_id,(c.len*c.width*c.height) AS carton_vol FROM carton c 
	 WHERE c.len * c.width *c.height >(SELECT SUM(p.len*p.width*p.height*oi.product_quantity)FROM product p 
	 JOIN order_items oi ON p.product_id = oi.product_id WHERE OI.order_id = 10006) 
	 ORDER BY carton_vol LIMIT 1;


-- 8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) products per shipped order. (11 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]

	 SELECT oc.customer_id,oc.CUSTOMER_FNAME ||' '|| oc.CUSTOMER_LNAME AS Fullname ,oh.order_id,SUM(oi.product_quantity) AS total_qty FROM online_customer oc
	 JOIN order_header oh ON oc.customer_id = oh.customer_id 
	 JOIN order_items oi ON oh.order_id = oi.order_id WHERE  oh.order_status = 'Shipped' 
	 GROUP BY oc.customer_id, Fullname, oh.order_id 
	 HAVING  total_qty > 10 
	 ORDER BY oc.customer_id,oi.order_id ;





-- 9. Write a query to display the order_id, customer id and customer full name of customers along with (product_quantity) as total quantity of products shipped for order ids > 10060. (6 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items]

    SELECT oc.customer_id,oc.CUSTOMER_FNAME ||' '|| oc.CUSTOMER_LNAME AS Fullname ,oh.order_id,SUM(oi.product_quantity) AS total_qty FROM online_customer oc
	JOIN order_header oh ON oc.customer_id = oh.customer_id 
	JOIN order_items oi ON oh.order_id = oi.order_id WHERE  oh.order_status = 'Shipped' 
	GROUP BY oc.customer_id, Fullname, oh.order_id 
	HAVING  oi.order_id > 10060 
	ORDER BY total_qty desc


-- 10. Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) and show which class of products have been shipped highest(Quantity) to countries outside India other than USA? Also show the total value of those items. (1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]

SELECT a.country,pc.product_class_desc,SUM(oi.product_quantity) AS total_qty,SUM(oi.product_quantity*p.product_price) AS total_value FROM product_class pc
 
 JOIN product p ON pc.product_class_code = p.product_class_code
 JOIN order_items oi ON p.product_id = oi.product_id
 JOIN online_customer oc ON oh.customer_id = oc.customer_id
 JOIN order_header oh ON oi.order_id = oh.order_id
 JOIN address a ON oc.address_id = a.address_id

 WHERE a.country NOT IN ('USA','India') AND oh.ORDER_STATUS = 'Shipped'

 GROUP BY pc.product_class_code
 ORDER BY total_qty desc limit 1