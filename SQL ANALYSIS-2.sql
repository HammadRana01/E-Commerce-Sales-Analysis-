CREATE TABLE orders( 
Order_ID VARCHAR(10),	
Order_Date DATE,
CustomerName VARCHAR(20),
State VARCHAR(20),	
City VARCHAR(20)
);

CREATE TABLE order_details(
Order_ID VARCHAR(10),	
Amount	INT,
Profit INT,
Quantity INT,
Category VARCHAR(15),
Sub_Category VARCHAR(20)
);

CREATE TABLE sales_targets(
Month_of_Order_Date VARCHAR(10),
Category VARCHAR(15),
Target INT
);

SELECT * FROM orders;
SELECT * FROM order_details;












