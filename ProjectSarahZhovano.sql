USE Sales_sarah


--Q1
SELECT Top 5
    p.name,  
	SUM(sod.linetotal) as OrderDeTotal
FROM sales.SalesOrderDetail sod	inner join [production].[Product] p on sod.ProductID = p.ProductID
GROUP BY p.name
ORDER BY SUM(sod.OrderQty) desc


--Q2
SELECT AVG(sod.UnitPrice) as AvgUnitPrice ,pc.Name 
FROM  Sales.SalesOrderDetail sod 
    inner join [Production].[Product] p on sod.productID = p.ProductID
	inner join [production].[ProductSubcategory] psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
	inner join [production].[ProductCategory] pc on pc.ProductCategoryID = psc.ProductCategoryID
WHERE pc.Name in ('Bikes' , 'Components')
GROUP BY pc.Name


--Q3
SELECT p.Name ,
		SUM(sod.OrderQty) as SumOrderQty
FROM Sales.SalesOrderDetail sod 
     inner join [Production].[Product] p on sod.productID = p.ProductID
	inner join [production].[ProductSubcategory] psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
	inner join [production].[ProductCategory] pc on pc.ProductCategoryID = psc.ProductCategoryID
WHERE pc.Name not in ('Clothing','Components')
GROUP BY p.name


--Q4
SELECT  TOP 3 st.Name
FROM sales.SalesTerritory st 
	 inner join sales.SalesOrderHeader soh on st.TerritoryID = soh.TerritoryID
GROUP BY st.name
ORDER BY SUM(soh.TotalDue) DESC


--Q5
SELECT sc.CustomerID, p.FirstName+' '+p.LastName as FullName
FROM Person.Person p 
     inner join Sales.Customer sc on  p.BusinessEntityID = sc.PersonID
	 left join Sales.SalesOrderHeader soh on sc.CustomerID = soh.CustomerID
GROUP BY sc.CustomerID, p.FirstName+' '+p.LastName
HAVING COUNT(soh.SalesOrderID) = 0


--Q6
DELETE sales.SalesTerritory
FROM sales.SalesTerritory st
WHERE NOT EXISTS ( 
                    SELECT *
                    FROM sales.SalesPerson sp
                    WHERE sp.TerritoryID = st.TerritoryID
                    )

--Q7
INSERT INTO [Sales].[SalesTerritory]
           ([Name]
           ,[TerritoryID]
           ,[CountryRegionCode]
           ,[Group]
           ,[SalesYTD]
           ,[SalesLastYear]
           ,[CostYTD]
           ,[CostLastYear]
           ,[rowguid]
           ,[ModifiedDate])
    select  
            [Name]
           ,[TerritoryID]
           ,[CountryRegionCode]
           ,[Group]
           ,[SalesYTD]
           ,[SalesLastYear]
           ,[CostYTD]
           ,[CostLastYear]
           ,[rowguid]
           ,[ModifiedDate]
    FROM [AdventureWorks2022].[Sales].[SalesTerritory] 
    WHERE NOT EXISTS ( 
                    SELECT *
                    FROM sales.SalesPerson sp
                    WHERE sp.TerritoryID = SalesTerritory.TerritoryID
                    )


--Q8
 SELECT p.FirstName+' '+p.LastName as FullName
 FROM Person.Person p 
      inner join Sales.Customer sc on  p.BusinessEntityID = sc.PersonID
	  inner join Sales.SalesOrderHeader soh on sc.CustomerID = soh.CustomerID
GROUP BY p.FirstName+' '+p.LastName
HAVING COUNT(soh.SalesOrderID) > 20
	

--Q9
SELECT hd.GroupName, COUNT(hd.DepartmentID) as CountDepartment
FROM HumanResources.Department hd	
GROUP BY hd.GroupName
HAVING COUNT(hd.DepartmentID) > 2


--Q10
SELECT P.FirstName+ ' '+ P.LastName AS FullName, hd.Name AS DepartmentName, hs.Name AS ShiftName
FROM Person.Person p
	 inner join HumanResources.Employee e  on p.BusinessEntityID = e.BusinessEntityID
	 inner join HumanResources.EmployeeDepartmentHistory hedh on e.BusinessEntityID = hedh.BusinessEntityID
     inner join HumanResources.Department hd on hedh.DepartmentID = hd.DepartmentID 
	 inner join HumanResources.Shift hs on hedh.shiftID = hs.ShiftID
WHERE YEAR(e.HireDate) > 2010	
	 and hd.GroupName in ('Quality Assurance', 'Manufacturing')


