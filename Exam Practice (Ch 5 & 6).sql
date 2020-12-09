-- 5-60 - Use the Pine Valley database to answer the following questions:
-- How many work centers does Pine Valley have? Where are they located?
SELECT COUNT(*) cnt
FROM WorkCenter_T

SELECT WorkCenterLocation
FROM WorkCenter_T

-- 5-61 - List the employees whose last names begin with an L.
SELECT *
FROM Employee_T
WHERE EmployeeName LIKE '% L%'

-- 5-62 - Which employees were hired during 2005?
SELECT *
FROM Employee_T
WHERE YEAR(EmployeeDateHired) = '2005'

-- 5-63 - List the customers who live in California or Washington. Order them by zip code, from high to low.
SELECT *
FROM Customer_T
WHERE CustomerState IN ('CA','WA')
ORDER BY CustomerPostalCode DESC

-- 5-64 - List the number of customers living at each state that is included in the Customer_T table.
SELECT CustomerState, COUNT(CustomerId) AS NumCustomers
FROM Customer_T
GROUP BY CustomerState

-- 5-65 - List all raw materials that are made of cherry and that have dimensions (thickness and width) of 12 by 12.
SELECT *
FROM RawMaterial_T
WHERE Thickness = '12' AND Width = '12' AND Material = 'Cherry'

-- 5-66 - List the MaterialID, MaterialName, Material, MaterialStandardPrice, and Thickness for all raw materials made of cherry, pine, or walnut. 
--		  Order the listing by Material, StandardPrice, and Thickness.
SELECT MaterialID, MaterialName, Material, MaterialStandardPrice, Thickness
FROM RawMaterial_T
WHERE Material IN ('Cherry','Pine','Walnut')
ORDER BY Material, MaterialStandardPrice, Thickness

-- 5-67 - Display the product line ID and the average standard price for all products in each product line.
SELECT ProductLineID, AVG(ProductStandardPrice) AS AvgProductLinePrice
FROM Product_T
GROUP BY ProductLineID

-- 5-68 - Modify query in 5-67 by considering only those products the standard price of which is greater than $200. 
--		  Include in the answer set only those product lines that have an average standard price of at least $500.
SELECT ProductLineID, AVG(ProductStandardPrice) AS AvgProductLinePrice
FROM Product_T
WHERE ProductStandardPrice > 200
GROUP BY ProductLineID
HAVING AVG(ProductStandardPrice) >= 500

-- 5-69 - For every product that has been ordered, display the product ID and the total quantity ordered (label this result TotalOrdered). 
--		  List the most popular product first and the least popular last.
SELECT ProductID, SUM(OrderedQuantity) AS TotalOrdered
FROM OrderLine_T
GROUP BY ProductID
ORDER BY TotalOrdered DESC

-- 5-70 - For each order, display the order ID, the number of separate products included in the order, and the total number of product units (for all products) ordered.
SELECT OrderID, COUNT(ProductID) AS CntSeparateProducts, SUM(OrderedQuantity) AS NumProductsOrdered
FROM OrderLine_T
GROUP BY OrderID

-- 5-71 - For each customer, list the CustomerID and total number of orders placed.
SELECT CustomerID, COUNT(OrderID) AS TotalOrdersPlaced
FROM Order_T
GROUP BY CustomerID

-- 5-73 - Display the product ID and the number of orders placed for each product. 
--		  Show the results in decreasing order by the number of times the product has been ordered and label this result column NumOrders.
SELECT ProductID, COUNT(OrderID) AS NumOrders
FROM OrderLine_T
GROUP BY ProductID
ORDER BY NumOrders DESC

-- 5-75 - For each customer, list the customer ID and the total number of orders placed in 2018.
SELECT CustomerID, COUNT(OrderID) AS TotalOrdersPlaced
FROM Order_T
WHERE YEAR(OrderDate) = 2018
GROUP BY CustomerID

-- 5-77 - For each customer who had more than two orders, list the CustomerID and the total number of orders placed.
SELECT CustomerID, COUNT(OrderID) AS TotalOrdersPlaced
FROM Order_T
GROUP BY CustomerID
HAVING COUNT(OrderID) > 2

-- 5-79 - List all sales territories (TerritoryID) that have more than one salesperson.
SELECT SalesTerritoryID, COUNT(SalespersonName) AS NumSalesPeople
FROM Salesperson_T
GROUP BY SalesTerritoryID
HAVING COUNT(SalespersonID) > 1

-- 5-80 - Which product is ordered most frequently?

-- Ordered most frequently = how many orders its been a part of, not how many are sold
SELECT ProductID, SUM(OrderedQuantity) AS TotalOrders
FROM OrderLine_T
GROUP BY ProductID

	-- Correct answer
	SELECT ProductID, COUNT(*) AS NumOrders
	FROM OrderLine_T
	GROUP BY ProductID
	ORDER by COUNT(*) DESC

-- 5-81 - For employees who live in TN or FL, list the age at which they were hired.
SELECT EmployeeName, DATEDIFF(YEAR,EmployeeBirthDate,EmployeeDateHired) AS AgeHired
FROM Employee_T
WHERE EmployeeState IN ('TN','FL')

-- 5-82 - Measured by average standard price, what is the least expensive product finish?
SELECT ProductFinish, AVG(ProductStandardPrice) AS AverageStandardPrice
FROM Product_T
GROUP BY ProductFinish
ORDER BY AVG(ProductStandardPrice)

-- 5-83 - Display the territory ID and the number of salespersons in the territory for all territories that have more than one salesperson. 
--		  Label the number of salespersons NumSalesPersons.
SELECT SalesTerritoryID, COUNT(SalespersonID) AS NumSalesPersons
FROM Salesperson_T
GROUP BY SalesTerritoryID
HAVING COUNT(SalespersonID) > 1

-- 5-84 - Display the SalesPersonID and a count of the number of orders for that salesperson for all salespersons except salespersons 3, 5, and 9. 
--		  Write this query with as few clauses or components as possible, using the capabilities of SQL as much as possible.
SELECT SalesPersonID, COUNT(OrderID) AS NumOrders
FROM Order_T
WHERE SalespersonID NOT IN (3,5,9)
GROUP BY SalesPersonID

-- 5.85 - Display the SalesPersonID, order date month, and total orders for orders in 2018
SELECT SalespersonID, month(OrderDate) AS Month, COUNT(OrderID) AS TotalOrders
FROM Order_t
WHERE OrderDate BETWEEN '01/01/2018' and '12/31/2018'
GROUP BY SalespersonID, month(OrderDate)
ORDER BY SalespersonID, month(OrderDate);

-- 5-86 - List MaterialName, Material, and Width for raw materials that are not cherry or oak and whose width is greater than 10 inches. 
SELECT MaterialName, Material, Width
FROM RawMaterial_T
WHERE Material NOT IN ('Cherry','Oak') AND Width > 10

-- 5-87 - List ProductID, ProductDescription, ProductFinish, and ProductStandardPrice for oak products with a ProductStandardPrice greater than $400 
--		  or cherry products with a StandardPrice less than $300. 
SELECT ProductID, ProductDescription, ProductFinish, ProductStandardPrice
FROM Product_T
WHERE (ProductStandardPrice > 400 AND ProductFinish = 'Oak') OR (ProductStandardPrice < 300 AND ProductFinish = 'Cherry')

-- 5-88 - For each order, list the order ID, customer ID, order date, and most recent date among all orders. 

-- Need to have the max order datae available in select
SELECT OrderID, CustomerID, OrderDate
FROM Order_T
ORDER BY OrderDate DESC

	-- Correct Answer
	SELECT OrderID, CustomerID, OrderDate, (SELECT MAX(OrderDate) AS MostRecent FROM ORDER_T) AS MostRecent
	FROM Order_T

-- 5-89 - For each customer, list the customer ID, the number of orders from that customer, and the ratio of the number of orders from that customer
--		  to the total number of orders from all customers combined. (This ratio, of course, is the percentage of all orders placed by each customer.)
SELECT CustomerID, COUNT(OrderID) AS NumOrders, COUNT(OrderID)/TotalOrders AS Ratio
FROM Order_T, (SELECT COUNT(OrderID) AS TotalOrders FROM Order_T) AS TotalOrders_T
GROUP BY CustomerID, TotalOrders

	-- Correct Answer
	SELECT CustomerID, COUNT(OrderID) AS OrderCount, AllOrders, CAST(COUNT(OrderID) AS FLOAT)/AllOrders AS Ratio
	FROM  Order_T,(SELECT COUNT(OrderID) AS AllOrders FROM Order_T) AS t
	GROUP BY CustomerID, AllOrders

-- 5-90 - For products 1, 2, and 7, list in one row and three respective columns that product’s total unit sales; label the three columns Prod1, Prod2, and Prod7.

-- Need to make each table by itself
SELECT SUM(OrderedQuantity) AS TotalUnitSales
FROM OrderLine_T
WHERE ProductID IN (1,2,7)
GROUP BY ProductID

	-- Correct Answer
	SELECT Prod1, Prod2, Prod7
	FROM
	(SELECT SUM(OrderedQuantity) AS Prod1 FROM OrderLine_T WHERE ProductID = 1) AS p1,
	(SELECT SUM(OrderedQuantity) AS Prod2 FROM OrderLine_T WHERE ProductID = 2) AS p2,
	(SELECT SUM(OrderedQuantity) AS Prod7 FROM OrderLine_T WHERE ProductID = 7) AS p3;

-- 5-91 - List the average number of customers per state (including only the states that are included in the Customer_T table).
--		  Hint: A query can be used as a table specification in the FROM clause.

-- Can't group by customer state and have code work correctly
SELECT CustomerState, AVG(CntCustomers) AS AvgCustomers
FROM (SELECT CustomerState, COUNT(CustomerID) AS CntCustomers FROM Customer_T GROUP BY CustomerState) CustomerState_T
GROUP BY CustomerState

	-- Correct Answer
	SELECT AVG(StateCustCount) AS AvgStateCustCnt
	FROM (SELECT COUNT(CustomerID) AS StateCustCount FROM CUSTOMER_T GROUP BY CustomerState)AS T;

-- 6-45 - Write an SQL query that will find any customers who have not placed orders. 
SELECT Customer_T.CustomerID
FROM Customer_T LEFT JOIN Order_T ON Order_T.CustomerID = Customer_T.CustomerId
WHERE Order_T.CustomerID IS NULL

	-- Correct Answer/Different method
	SELECT CustomerID
	FROM Customer_T
	WHERE CustomerID NOT IN (SELECT CustomerID from Order_T)

-- 6-46 - Write an SQL query to list all product line names and, for each product line, the number of products and the average product price. 
--		  Make sure to include all product lines separately.
SELECT ProductLineName, COUNT(ProductID) AS CntProducts, AVG(ProductStandardPrice) AS AvgProductPrice
FROM ProductLine_T INNER JOIN Product_T ON ProductLine_T.ProductLineID = Product_T.ProductLineID
GROUP BY ProductLineName

-- 6-47 - Modify P&E 6-46 to include only those product lines the average price of which is higher than $200.
SELECT ProductLine_T.ProductLineID, COUNT(ProductID) AS CntProducts, AVG(ProductStandardPrice) AS AvgProductPrice
FROM ProductLine_T INNER JOIN Product_T ON ProductLine_T.ProductLineID = Product_T.ProductLineID
GROUP BY ProductLine_T.ProductLineID
HAVING AVG(ProductStandardPrice) > 200

-- 6-48 - List the names and number of employees supervised (label this value HeadCount) for each supervisor who supervises more than two employees.
SELECT Supervisor_T.EmployeeName, COUNT(Employee_T.EmployeeName) AS HeadCount
FROM Employee_T INNER JOIN (SELECT * FROM Employee_T) Supervisor_T ON Employee_T.EmployeeSupervisor = Supervisor_T.EmployeeID
GROUP BY Supervisor_T.EmployeeName
HAVING COUNT(Employee_T.EmployeeName) > 2

	-- Alternate Way
	SELECT S.EmployeeName, COUNT(E.EmployeeID) AS HeadCount
	FROM Employee_T AS S, Employee_T AS E
	WHERE S.EmployeeID = E.EmployeeSupervisor
	GROUP BY S.EmployeeName
	HAVING COUNT(E.EmployeeID) > 2

-- 6-49 - List the name of each employee, his or her birth date, the name of his or her manager, and the manager’s birth date for those employees 
--		  who were born before their manager was born; label the manager’s data Manager and ManagerBirth. 
SELECT Employee_T.EmployeeName, Employee_T.EmployeeBirthDate, Manager_T.EmployeeName AS Manager, Manager_T.EmployeeBirthDate AS ManagerBirth
FROM Employee_T INNER JOIN (SELECT * FROM Employee_T) Manager_T ON Employee_T.EmployeeSupervisor = Manager_T.EmployeeID
WHERE Employee_T.EmployeeBirthDate < Manager_T.EmployeeBirthDate

	-- Alternate Way
	SELECT E1.EmployeeName, E1.EmployeeBirthdate, E2.EmployeeName AS Manager, E2.EmployeeBirthdate AS ManagerBirth
	FROM Employee_T AS E1, Employee_T AS E2
	WHERE E1.EmployeeSupervisor = E2.EmployeeID AND E1.EmployeeBirthdate < E2.EmployeeBirthdate

-- 6-50 - Write an SQL query to display the order number, customer number, order date, and items ordered for some particular customer. 
SELECT Order_T.OrderID, Order_T.CustomerID, OrderDate, OrderedQuantity
FROM Customer_T INNER JOIN Order_T ON Order_T.CustomerID = Customer_T.CustomerId INNER JOIN OrderLine_T ON Order_T.OrderID = OrderLine_T.OrderID
WHERE Order_T.CustomerID = 1

	-- Alternate Way
	SELECT Order_T.OrderID, CustomerID, OrderDate, OrderLine_T.ProductID, Product_T.ProductDescription, OrderLine_T.OrderedQuantity
	FROM Product_T INNER JOIN (Order_T INNER JOIN Orderline_T ON Order_T.OrderID = OrderLine_T.OrderID) ON Product_T.ProductID = OrderLine_T.ProductID
	WHERE CustomerID= 1;

-- 6-51 - Write an SQL query to display each item ordered for order number 1, its standard price, and the total price for each item ordered. 
SELECT OrderLine_T.ProductID, ProductStandardPrice, OrderedQuantity * ProductStandardPrice AS TotalPrice
FROM OrderLine_T INNER JOIN Product_T ON OrderLine_T.ProductID = Product_T.ProductID
WHERE OrderID = 1

-- 6-52 - Write an SQL query to display the total number of employees working at each work center (include ID and location for each work center).
SELECT WorksIn_T.WorkCenterID, WorkCenterLocation, COUNT(WorksIn_T.EmployeeID) AS NumEmployees
FROM Employee_T INNER JOIN WorksIn_T ON Employee_T.EmployeeID = WorksIn_T.EmployeeID
	INNER JOIN WorkCenter_T ON WorksIn_T.WorkCenterID = WorkCenter_T.WorkCenterID
GROUP BY WorksIn_T.WorkCenterID, WorkCenterLocation

	-- Alternate Way
	SELECT WorkCenter_T.WorkcenterID, COUNT(Employee_T.EmployeeID) AS [Nbr of Employees]
	FROM WorkCenter_T, Worksin_T, Employee_T
	WHERE WorkCenter_T.WorkcenterID = Worksin_T.WorkcenterID AND
	Worksin_T.EmployeeID = Employee_T.EmployeeID
	GROUP BY    WorkCenter_T.WorkcenterID

-- 6-53 - Write an SQL query that lists those work centers that employ at least one person who has the skill ‘QC1’. 
SELECT WorkCenterID, COUNT(EmployeeSkills_T.EmployeeID) AS NumSkilledEmployees
FROM EmployeeSkills_T INNER JOIN Skill_T ON EmployeeSkills_T.SkillID = Skill_T.SkillID
	INNER JOIN WorksIn_T ON EmployeeSkills_T.EmployeeID = WorksIn_T.EmployeeID
WHERE Skill_T.SkillID = 'QC1'
GROUP BY WorkCenterID

	-- Alternate Way
	SELECT WorkcenterID
	FROM WorkCenter_T
	WHERE WorkcenterID IN (SELECT WorkcenterID FROM Worksin_T, Employee_T, EmployeeSkills_T
	WHERE WorksIn_T.EmployeeID = Employee_T.EmployeeID AND Employee_T.EmployeeID = EmployeeSkills_T.EmployeeID AND EmployeeSkills_T.SkillID = 'QC1')

-- 6-54 - Write an SQL query to total the cost of order number 1. 
SELECT OrderID, SUM(OrderedQuantity * ProductStandardPrice) AS TotalPrice
FROM OrderLine_T INNER JOIN Product_T ON OrderLine_T.ProductID = Product_T.ProductID
WHERE OrderID = 1
GROUP BY OrderID

-- 6-55 - Write an SQL query that lists for each vendor (including vendor ID and vendor name) those materials that the vendor supplies 
--		  where the supply unit prices is at least four times the material standard price. 
SELECT Vendor_T.VendorID, VendorName, MaterialName
FROM Vendor_T INNER JOIN Supplies_T ON Vendor_T.VendorID = Supplies_T.VendorID
	INNER JOIN RawMaterial_T ON Supplies_T.MaterialID = RawMaterial_T.MaterialID
WHERE SupplyUnitPrice >= 4 * MaterialStandardPrice

-- 6-56 - Calculate the total raw material cost (label TotCost) for each product compared to its standard product price. 
--		  Display product ID, product description, standard price, and the total cost in the result. 
SELECT Product_T.ProductID, ProductDescription, ProductStandardPrice,SUM(MaterialStandardPrice * QuantityRequired) AS TotCost
FROM RawMaterial_T INNER JOIN Uses_T ON RawMaterial_T.MaterialID = Uses_T.MaterialID
	INNER JOIN Product_T ON Uses_T.ProductID = Product_T.ProductID
GROUP BY Product_T.ProductID, ProductDescription, ProductStandardPrice

-- 6-57 - For every order that has been received, display the order ID, the total dollar amount owed on that order 
--		  (you’ll have to calculate this total from attributes in one or more tables; label this result TotalDue), 
--		  and the amount received in payments on that order (assume that there is only one payment made on each order). 
--		  To make this query a little simpler, you don’t have to include those orders for which no payment has yet been received. 
--		  List the results in decreasing order of the difference between total due and amount paid.
SELECT Payment_T.OrderID, SUM(OrderedQuantity*ProductStandardPrice) AS TotalDue, PaymentAmount
FROM Payment_T, OrderLine_T, Product_T
WHERE Payment_T.OrderID = OrderLine_T.OrderID AND OrderLine_T.ProductID = Product_T.ProductID
GROUP BY Payment_T.OrderID, PaymentAmount
ORDER BY (SUM(OrderedQuantity*ProductStandardPrice) - PaymentAmount) DESC

-- 6-58 - Write an SQL query to list each customer who has bought computer desks and the number of units sold to each customer. 
SELECT Customer_T.CustomerID, CustomerName, SUM(OrderedQuantity) AS TotalDesksOrdered
FROM Order_T, OrderLine_T, Product_T, Customer_T
WHERE Order_T.OrderID = OrderLine_T.OrderID AND OrderLine_T.ProductID = Product_T.ProductID AND Order_T.CustomerID = Customer_T.CustomerId
	AND ProductDescription LIKE '%computer desk%'
GROUP BY Customer_T.CustomerID, CustomerName

-- 6-59 - Write an SQL query to list each customer who bought at least one product that belongs to product line Basic in March 2018. List each customer only once. 
SELECT DISTINCT Order_T.CustomerID, CustomerName
FROM Order_T, OrderLine_T, Product_T, ProductLine_T, Customer_T
WHERE Order_T.OrderID = OrderLine_T.OrderID AND OrderLine_T.ProductID = Product_T.ProductID 
	AND Product_T.ProductLineID = ProductLine_T.ProductLineID AND Order_T.CustomerID = Customer_T.CustomerId
	AND ProductLineName = 'Basic' AND YEAR(OrderDate) = '2018' AND MONTH(OrderDate) = '03' 

-- 6-60 - Modify Problem and Exercise 6-59 so that you include the number of products in product line Basic that the customer ordered in March 2018. 
SELECT DISTINCT Customer_T.CustomerID, CustomerName, COUNT(OrderLine_T.ProductID) AS NumOrdered
FROM Order_T, OrderLine_T, Product_T, ProductLine_T, Customer_T
WHERE Order_T.OrderID = OrderLine_T.OrderID AND OrderLine_T.ProductID = Product_T.ProductID AND Product_T.ProductLineID = ProductLine_T.ProductLineID
	AND Customer_T.CustomerId = Order_T.CustomerID
	AND ProductLineName = 'Basic' AND YEAR(OrderDate) = '2018' AND MONTH(OrderDate) = '03'
GROUP BY Customer_T.CustomerID, CustomerName

-- 6-61 - Modify Problem and Exercise 6-60 so that the list includes the number of products each customer bought in each product line in March 2018.
SELECT DISTINCT C.CustomerID, C.CustomerName, COUNT(P.ProductID) AS NumOrdered
FROM Customer_T C, Order_T O, OrderLine_T OL, Product_T P, ProductLine_T PL
WHERE C.CustomerID = O.CustomerID AND O.OrderID = OL.OrderID AND OL.ProductID = P.ProductID AND P.ProductLineID = PL.ProductLineID 
		AND PL.ProductLineName = 'Basic' AND MONTH(OrderDate) = 3 and YEAR(OrderDate) = 2018
GROUP BY C.CustomerID, C.CustomerName, PL.ProductLineID, PL.ProductLineName

-- 6-62 - List, in alphabetical order, the names of all employees (managers) who are now managing people with skill ID BS12; 
--		  list each manager’s name only once, even if that manager manages several people with this skill.
SELECT DISTINCT Manager.EmployeeName
FROM Employee_T AS Manager, Employee_T AS Employee, EmployeeSkills_T AS EmployeeSkills
WHERE SkillID = 'BS12' AND EmployeeSkills.EmployeeID = Employee.EmployeeID AND Employee.EmployeeSupervisor = Manager.EmployeeID
ORDER BY 1

-- 6-63 - Display the salesperson name, product finish, and total quantity sold (label as TotSales) for each finish by each salesperson. 
SELECT SalespersonName, ProductFinish, SUM(OrderedQuantity) AS TotSales
FROM Salesperson_T, Order_T, OrderLine_T, Product_T
WHERE Salesperson_T.SalespersonID = Order_T.SalesPersonID AND Order_T.OrderID = OrderLine_T.OrderID AND OrderLine_T.ProductID = Product_T.ProductID
GROUP BY SalespersonName, ProductFinish

-- 6-64 - Write a query to list the number of products produced in each work center (label as TotalProducts). 
--		  If a work center does not produce any products, display the result with a total of 0. 

-- Right table has all the elements
SELECT WorkCenter_T.WorkCenterID, COUNT(ProductID) AS TotalProducts
FROM Producedin_T RIGHT OUTER JOIN WorkCenter_T ON Producedin_T.WorkCenterID = WorkCenter_T.WorkCenterID
GROUP BY WorkCenter_T.WorkCenterID

-- 6-65 - The production manager at PVFC is concerned about support for purchased parts in products owned by customers. 
--		  A simple analysis he wants done is to determine for each customer how many vendors are in the same state as that customer. 
--		  Develop a list of all the PVFC customers by name with the number of vendors in the same state as that customer. (Label this computed result NumVendors.) 
SELECT CustomerName, CustomerState, COUNT(VendorID) AS NumVendors
FROM Customer_T INNER JOIN Vendor_T ON Customer_T.CustomerState = Vendor_T.VendorState
GROUP BY CustomerName, CustomerState

-- 6-66 - Display Orders where the payment ID is null
SELECT Order_T.OrderID
FROM Order_T LEFT OUTER JOIN Payment_T ON Order_T.OrderID = Payment_T.OrderID
WHERE Payment_T.PaymentID IS NULL

-- 6-67 - Display states where there's no salespeople
SELECT DISTINCT CustomerState
FROM Customer_T LEFT OUTER JOIN Salesperson_T ON CustomerState = SalespersonState
WHERE Salesperson_T.SalespersonState IS NULL
ORDER BY Customer_T.CustomerState

-- 6-70 - Display the EmployeeID and EmployeeName for those employees who do not possess the skill Router. Display the results in order by EmployeeName. 
SELECT EmployeeID, EmployeeName FROM  Employee_T
WHERE EmployeeID NOT IN (SELECT ES.EmployeeID FROM EmployeeSkills_T ES, Skill_T S WHERE SkillDescription= 'Router' AND ES.SkillID = S.SkillID)
ORDER BY EmployeeName

-- 6-74 - Show the customer ID and name for all the customers who have ordered both products with IDs 3 and 4 on the same order.
SELECT Order_T.CustomerID, CustomerName
FROM Order_T INNER JOIN 
(
SELECT OrderID
FROM OrderLine_T
WHERE ProductID IN (3,4)
GROUP BY OrderID
HAVING SUM(ProductID) >= 7
) Product3_4_T ON Order_T.OrderID = Product3_4_T.OrderID
INNER JOIN Customer_T ON Order_T.CustomerID = Customer_T.CustomerId

	-- Alternate Way
	SELECT C.CustomerID, CustomerName
	FROM  Customer_T C, Order_T O1, OrderLine_T OL1
	WHERE C.CustomerID = O1.CustomerID AND O1.OrderID = OL1.OrderID AND OL1.ProductID = 3 AND O1.OrderID IN(SELECT OrderID FROM OrderLine_T OL2 WHERE OL2.ProductID = 4)

-- 6-75 - Display the customer names of all customers who have ordered (on the same or different orders) both products with IDs 3 and 4. 
SELECT Product3_4_T.CustomerID, CustomerName
FROM Customer_T INNER JOIN 
(
SELECT CustomerID
FROM OrderLine_T INNER JOIN Order_T ON OrderLine_T.OrderID = Order_T.OrderID
WHERE ProductID IN (3,4)
GROUP BY CustomerID
HAVING SUM(ProductID) >= 7 AND COUNT(DISTINCT ProductID) = 2
) Product3_4_T ON Product3_4_T.CustomerID = Customer_T.CustomerId

	-- Alternate Way
	SELECT C1.CustomerID, C1.CustomerName FROM Customer_T C1
	WHERE (C1.CustomerID IN 
	(SELECT C.CustomerID FROM Customer_T C,Order_T O1, OrderLine_T OL1 WHERE C.CustomerID = O1.CustomerID AND O1.OrderID = OL1.OrderID AND OL1.ProductID =4))
	AND(C1.CustomerID IN
	(SELECT C.CustomerID FROM Customer_T C,Order_T O1, OrderLine_T OL1 WHERE C.CustomerID = O1.CustomerID AND O1.OrderID = OL1.OrderID AND OL1.ProductID =3))

-- 6-76 - Write an SQL query that lists the vendor ID, vendor name, material ID, material name, and supply unit prices for all those materials 
--		  that are provided by more than one vendor
SELECT Vendor_T.VendorID, VendorName, MultipleVendor_T.MaterialID, MaterialName, SupplyUnitPrice
FROM RawMaterial_T INNER JOIN 
(
SELECT MaterialID
FROM Supplies_T
GROUP BY MaterialID
HAVING COUNT(VendorID) > 1
) MultipleVendor_T ON RawMaterial_T.MaterialID = MultipleVendor_T.MaterialID
	INNER JOIN Supplies_T ON Supplies_T.MaterialID = RawMaterial_T.MaterialID
	INNER JOIN Vendor_T ON Supplies_T.VendorID = Vendor_T.VendorID

	-- Alternate Way
	SELECT v.VendorID, v.VendorName, rm.MaterialID, rm.MaterialName, s.SupplyUnitPrice
	FROM Vendor_T v, Supplies_T s, Rawmaterial_T rm
	WHERE v.VendorID = s.VendorID AND s.MaterialID = rm.MaterialID AND s.MaterialID IN 
	(SELECT MaterialID FROM Supplies_T s2 WHERE s2.MaterialID = rm.MaterialID GROUP BY s2.MaterialID 
	HAVING COUNT(s2.VendorID)>1)
	ORDER BY rm.MaterialID

-- 6-78 - List the IDs and names of all products that cost less than the average product price in their product line. 
SELECT ProductID, ProductDescription
FROM Product_T INNER JOIN
(
SELECT ProductLineID, AVG(ProductStandardPrice) AS AvgProductPrice
FROM Product_T
GROUP BY ProductLineID
) AvgProductLine_T ON Product_T.ProductLineID = AvgProductLine_T.ProductLineID
WHERE ProductStandardPrice < AvgProductPrice

-- 6-79 - List the IDs and names of those sales territories that have at least 50 percent more customers as the average number of customers per territory. 
SELECT T.TerritoryID, T.TerritoryName, COUNT(D.CustomerID) AS cnt
FROM Territory_T T, DoesBusinessIn_T D
WHERE T.TerritoryID = D.TerritoryID
GROUP BY T.TerritoryID, T.TerritoryName
HAVING COUNT(D.CustomerID) >= 1.5 * (SELECT AVG(CustCount) FROM (SELECT COUNT(D1.CustomerID) AS CustCount FROM DoesBusinessIn_T D1 GROUP BY D1.TerritoryID) AS t)

-- 6-80 - Write an SQL query to list the order number, product ID, and ordered quantity for all ordered products for which the ordered quantity is 
--		  greater than the average ordered quantity for that product.
SELECT OrderID, ProductOrdered_T.ProductID, OrderedQuantity, AvgProductOrdered
FROM OrderLine_T INNER JOIN
(
SELECT ProductID, AVG(OrderedQuantity) AS AvgProductOrdered
FROM OrderLine_T
GROUP BY ProductID
) ProductOrdered_T ON OrderLine_T.ProductID = ProductOrdered_T.ProductID
WHERE OrderedQuantity > AvgProductOrdered
ORDER BY OrderLine_T.OrderID

-- 6-81 - Write an SQL query to list the salesperson who has sold the most computer desks.
SELECT TOP(1) SalesPersonID, SUM(OrderedQuantity) AS TotalSales
FROM Order_T, OrderLine_T, Product_T
WHERE Order_T.OrderID = OrderLine_T.OrderID AND OrderLine_T.ProductID = Product_T.ProductID
	AND ProductDescription LIKE '%computer desk%'
GROUP BY SalesPersonID
ORDER BY TotalSales DESC

-- 6-82 - Display in product ID order the product ID and total amount ordered of that product by the customer who has bought the most of that product; 
--		  use a derived table in a FROM clause to answer this query.
SELECT ProductID, MAX(TotalOrdered) AS MaxOrdered
FROM 
(SELECT CustomerID, ProductID, SUM(OrderedQuantity) AS TotalOrdered
FROM Order_T INNER JOIN OrderLine_T ON Order_T.OrderID = OrderLine_T.OrderID
GROUP BY CustomerID, ProductID) Ordered_T
GROUP BY ProductID
ORDER BY ProductID