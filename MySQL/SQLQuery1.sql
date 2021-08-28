 ----------------------------------------Quiz 1-3
/* Using AdventureWorks2008R2, write a query to return the sales territories
 which have never had an order worth less than $4. Use TotalDue of
 SalesOrderHeader to determine an order value.

 Include the territory id, territory name and the lowest order value
 of the territory in the returned data.
 Sort the returned data by the territory id. */




USE AdventureWorks2008R2;

SELECT	s.TerritoryID, Name,MIN (TotalDue) AS [Min TotalDue]
FROM Sales.SalesOrderHeader s
INNER JOIN Sales.SalesTerritory t
ON s.TerritoryID = t.TerritoryID
GROUP BY s.TerritoryID,Name
HAVING MIN (TotalDue) >4
ORDER BY s.TerritoryID;



/* Using AdventureWorks2008R2, write a query to create a report containing
 the highest order value and the highest sold product quantity
 of an order for all orders of each customer.

 Include the customer id, the highest order value and the highest
 sold product quantity of an order for all orders of each customer
 columns in the returned data. Sort the report by the
 customer id in desc. */


 SELECT CustomerID, TotalDue, OrderQty
 FROM (SELECT CustomerID, s.SalesOrderID,TotalDue, OrderQty,
 DENSE_RANK() OVER( Partition BY CustomerID order by TotalDue, OrderQty desc) as toprank
 FROM
 Sales.SalesOrderHeader s
 INNER JOIN Sales.SalesOrderDetail o
 ON s.SalesOrderID = o.SalesOrderID
 GROUP BY CustomerID,s.SalesOrderID,TotalDue,OrderQty)
 tmp
 Where toprank =1
 ORDER BY CustomerID,SalesOrderID



