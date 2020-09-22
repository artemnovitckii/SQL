-- Question 1

--Artem Novtickii
--207428057
--anov099


-- Question 2
select productID 'Product ID', ProductName 'Product Name', 
SupplierID 'Supplier ID', CategoryID 'Category ID', QuantityPerUnit 'Quantity Per Unit',
UnitPrice 'Unit Price', UnitsInStock 'Units In Stock', UnitsOnOrder 'Units On Order',
ReorderLevel 'Reorder Level', Discontinued 'Discontinued'
from Product;


--Question 3
select ProductName, UnitPrice, UnitsInStock
from Product
order by UnitPrice desc;


--Question 4
select Phone
from Shipper
where lower(CompanyName) = 'united package';


--Question 5
select *
from Customer
where fax is not null;


--Question 6
select *
from [Order]
where orderDate < '1996-08-01' and orderDate > '1996-06-30';


--Question 7
select DISTINCT Country
from Customer;


--Question 8 
select count(*) 'Numbers of Order'
from [Order];


--Question 9
select ProductName
from Product
where ProductName like '_____';

select ProductName
from Product
where length(productname) = 5;


--Question 10
select ProductName, UnitsInStock
from Product
order by UnitsInStock desc
limit 10; 


--Question 11
SELECT upper(LastName) || ', ' || FirstName as 'Name',
Address || ', ' || City || ' ' || PostalCode || ', ' || Country as 'Address'
FROM Employee;


--Question 12
SELECT orderID, ProductID, '$' || UnitPrice as 'UnitPrice', Quantity, (Discount * 100) || '%' as 
'Discount',
'$' || ((UnitPrice * Quantity) - (UnitPrice * Quantity * Discount))  as 'Subtotal'
from OrderDetail
where OrderID = 10250;


--Question 13
select ProductName, CategoryID, UnitPrice, Discontinued
from Product
where ProductName like 'C%' and CategoryID in (1,2) and UnitPrice > 20 and Discontinued = false;


--Question 14
INSERT INTO Shipper(CompanyName, Phone)
VALUES('Trustworthy Delivery','(503) 555-1122'),
('Amazing Pace', '(503) 555-3421'),('Artem Novitckii Limited','(503) 207428057');


--Question 15
select LastName,FirstName,cast(round((strftime('%Y', 'now') + strftime('%j', 'now') / 365.2422) - (strftime('%Y', BirthDate) + strftime('%j', BirthDate) / 365.2422)) as INT) 'Age'
from Employee;


--Question 16
update Employee
set 
LastName = 'Fuller',
TitleOfCourtesy = 'Mrs.'
where lower(FirstName) = 'nancy';


--Question 17
UPDATE Employee
SET
Address = (select Address from Employee where lower(FirstName) = 'andrew' and lower(LastName) = 'fuller'),
City = (select City from Employee where lower(FirstName) = 'andrew' and lower(LastName) = 'fuller'),
Region = (select Region from Employee where lower(FirstName) = 'andrew' and lower(LastName) = 'fuller'),
PostalCode = (select PostalCode from Employee where lower(FirstName) = 'andrew' and lower(LastName) = 'fuller'),
HomePhone = (select HomePhone from Employee where lower(FirstName) = 'andrew' and lower(LastName) = 'fuller')
where lower(FirstName) = 'nancy' and lower(lastname) = 'fuller';


--Question 18
CREATE TABLE ProductHistory (
ProductID INTEGER NOT NULL,
EntryDate DATE NOT NULL,
UnitPrice REAL,
UnitsInStock INTEGER,
UnitsOnOrder INTEGER,
ReorderLevel INTEGER,
Discontinued INTEGER NOT NULL,
PRIMARY KEY (ProductID,EntryDate),
FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);


--Question 19
insert into ProductHistory(ProductID,EntryDate,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel, Discontinued)
select ProductID, (datetime('now','localtime')),UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel, Discontinued
from Product;


--Question 20
select HireDate 'Day of Week',count(HireDate) as 'Hired'
from (
select  CASE 
when strftime('%w',HireDate) = '0' then 'Sunday'
when strftime('%w',HireDate) = '1' then 'Monday'
when strftime('%w',HireDate) = '2' then 'Tuesday'
when strftime('%w',HireDate) = '3' then 'Wednesday'
when strftime('%w',HireDate) = '4' then 'Thursday'
when strftime('%w',HireDate) = '5' then 'Friday'
when strftime('%w',HireDate) = '6' then 'Saturday'
END HireDate
from Employee) 
GROUP by HireDate;


--Question 21
select e.LastName,e.FirstName,'$'||sum(((UnitPrice * Quantity) - (UnitPrice * Quantity * Discount))) as 'Total'
from [order] as o
inner join OrderDetail as od
on o.orderID = od.OrderID
inner join Employee as e
on  e.EmployeeID = o.EmployeeID
group by e.FirstName
order by sum(((UnitPrice * Quantity) - (UnitPrice * Quantity * Discount))) desc
LIMIt 1;


--Question 22
select e.FirstName as 'Employee', ifnull(m.FirstName, 'No manager') as 'Manager'
FROM Employee as e
left JOIN Employee as m
on e.ReportsTo = m.EmployeeID;


--Question 23
select c.CompanyName 'Company', '$'||round(sum(p.UnitPrice * od.Quantity),2) 'Recommended',
'$'||round(sum((od.UnitPrice * Quantity) - (od.UnitPrice * Quantity * Discount)),2) 'Ordered',
'$'||round(sum(p.UnitPrice * od.Quantity) - sum((od.UnitPrice * Quantity) - (od.UnitPrice * Quantity * Discount)),2) 'Discount',
round(((sum(p.UnitPrice * od.Quantity) - sum((od.UnitPrice * Quantity) - (od.UnitPrice * Quantity * Discount))) / sum(p.UnitPrice * od.Quantity)) * 100,2) ||'%' 'Percentage'
from [Order] as o
inner join OrderDetail as od
on o.OrderID = od.OrderID
inner join Customer as c
on o.CustomerID = c.CustomerID
inner join Product as p
on od.ProductID = p.ProductID
group by o.CustomerID
order by round(((sum(p.UnitPrice * od.Quantity) - sum((od.UnitPrice * Quantity) - (od.UnitPrice * Quantity * Discount))) / sum(p.UnitPrice * od.Quantity)) * 100,2) desc;


--Question 24
select big.ShipCountry,big.CompanyName as 'Shipper'
from(select rs.ShipCountry,rs.CompanyName,max(rs.fresum)
from (
select s.CompanyName,o.ShipCountry, sum(freight) [fresum]
from [order] o, Shipper s 
where shipvia=ShipperID
group by o.ShipCountry,ShipVia)
rs
group by rs.ShipCountry
order by rs.CompanyName) as big;


