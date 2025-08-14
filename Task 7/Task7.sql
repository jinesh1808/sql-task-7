-- Create tables
CREATE TABLE customers (
    customerID INT PRIMARY KEY,
    name VARCHAR(30),
    email VARCHAR(50) UNIQUE
);

CREATE TABLE orders (
    orderID INT PRIMARY KEY,
    customerID INT,
    product VARCHAR(30),
    category VARCHAR(20),
    amount DECIMAL(10,2),
    FOREIGN KEY (customerID) REFERENCES customers(customerID)
);

CREATE TABLE payments (
    paymentID INT PRIMARY KEY,
    orderID INT,
    status VARCHAR(20),
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);


-- Customers
INSERT INTO customers VALUES
(1, 'Jinesh', 'jinesh@example.com'),
(2, 'Akansh', 'akansh@example.com'),
(3, 'Vishwesh', 'vishwesh@example.com');

-- Orders
INSERT INTO orders VALUES
(101, 1, 'Laptop', 'Electronics', 60000.00),
(102, 1, 'Mouse', 'Electronics', 1000.00),
(103, 2, 'Keyboard', 'Electronics', 1500.00),
(104, 3, 'Shoes', 'Footwear', 2500.00),
(105, 3, 'Shirt', 'Clothing', 1200.00);

-- Payments
INSERT INTO payments VALUES
(1001, 101, 'Paid'),
(1002, 102, 'Pending'),
(1003, 103, 'Paid'),
(1004, 104, 'Paid'),
(1005, 105, 'Pending');


-- View 1: Customer Orders Summary
CREATE VIEW customer_order_summary AS
SELECT c.name, COUNT(o.orderID) AS total_orders, SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customerID = o.customerID
GROUP BY c.name;

-- View 2: Paid Orders
CREATE VIEW paid_orders AS
SELECT o.orderID, c.name, o.product, o.amount
FROM orders o
JOIN customers c ON o.customerID = c.customerID
JOIN payments p ON o.orderID = p.orderID
WHERE p.status = 'Paid';

-- View 3: High Value Customers
CREATE VIEW high_value_customers AS
SELECT name, total_spent
FROM customer_order_summary
WHERE total_spent > 5000;


SELECT name, 
       (SELECT COUNT(*) FROM orders WHERE orders.customerID = customers.customerID) AS total_orders
FROM customers;

-- Correlated Subquery
SELECT name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customerID = c.customerID AND o.amount > 5000
);

-- Subquery with IN
SELECT name
FROM customers
WHERE customerID IN (
    SELECT customerID
    FROM orders
    WHERE category = 'Electronics'
);

-- Subquery in FROM Clause (Derived Table)
SELECT category, AVG(total_sales) AS avg_sales
FROM (
    SELECT category, SUM(amount) AS total_sales
    FROM orders
    GROUP BY category
) AS category_totals
GROUP BY category;

-- Nested Subquery
SELECT name
FROM customers
WHERE customerID IN (
    SELECT customerID
    FROM orders
    WHERE amount > (
        SELECT AVG(amount)
        FROM orders
    )
);

-- Using customer_order_summary
SELECT * FROM customer_order_summary;

-- Using paid_orders
SELECT * FROM paid_orders ORDER BY amount DESC;

-- Using high_value_customers
SELECT * FROM high_value_customers;

