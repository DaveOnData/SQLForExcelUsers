--
-- Hypothetical scenario is that the AdventureWorks sales manager would like to see the largest sale ever made 
-- for each of the AdventureWorks sales reps. Yes, you could use the mighty ROW_NUMBER for this instead!
--
-- To make it more interesting, not only does the sales manager want to know the largest sale of each sales rep, 
-- but also what percentage of the rep’s total lifetime sales does the largest sale represent.
--


--
-- Query prototype
--
SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
      ,E.HireDate
      ,FRS.SalesOrderNumber
      ,CAST(FRS.OrderDate AS Date) AS OrderDate
      ,SUM(FRS.SalesAmount) AS SalesAmount
FROM FactResellerSales FRS 
	INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate;



-- First attempt - a single sales rep
--
WITH SalesRepData AS
(
    SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
        ,E.HireDate
        ,FRS.SalesOrderNumber
        ,CAST(FRS.OrderDate AS Date) AS OrderDate
        ,SUM(FRS.SalesAmount) AS SalesAmount
    FROM FactResellerSales FRS 
        INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
    GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate
)
SELECT SRD.SalesRep
      ,MAX(SRD.SalesAmount) AS LargestSalesAmount
      ,SUM(SRD.SalesAmount) AS TotalLifetimeSales
      ,MAX(SRD.SalesAmount) / SUM(SRD.SalesAmount) AS LargestPctOfTotal
FROM SalesRepData SRD
WHERE SRD.SalesRep = 'Alberts, Amy'
GROUP BY SRD.SalesRep;



--
-- Add in some more sales reps. Tedious, but doable.
--
WITH SalesRepData AS
(
    SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
        ,E.HireDate
        ,FRS.SalesOrderNumber
        ,CAST(FRS.OrderDate AS Date) AS OrderDate
        ,SUM(FRS.SalesAmount) AS SalesAmount
    FROM FactResellerSales FRS 
        INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
    GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate
)
SELECT SRD.SalesRep
      ,MAX(SRD.SalesAmount) AS LargestSalesAmount
      ,SUM(SRD.SalesAmount) AS TotalLifetimeSales
      ,MAX(SRD.SalesAmount) / SUM(SRD.SalesAmount) AS LargestPctOfTotal
FROM SalesRepData SRD
WHERE SRD.SalesRep IN ('Alberts, Amy', 'Campbell, David', 'Vargas, Garrett')
GROUP BY SRD.SalesRep;



--
-- It would be a lot easier if we could just perform the CTE for each unique
-- sales rep. Start with another prototype query.
--
WITH SalesRepData AS
(
    SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
        ,E.HireDate
        ,FRS.SalesOrderNumber
        ,CAST(FRS.OrderDate AS Date) AS OrderDate
        ,SUM(FRS.SalesAmount) AS SalesAmount
    FROM FactResellerSales FRS 
        INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
    GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate
),
DistinctSalesRep AS
(
    SELECT DISTINCT SRD.SalesRep
    FROM SalesRepData SRD
)
SELECT DSR.SalesRep
FROM DistinctSalesRep DSR
ORDER BY DSR.SalesRep;



--
-- Correlated subqueries allows an inner query to take a dependency on an
-- outer query. Conceptually, this means that the inner query is executed
-- once for every row in the outer query.
-- 
WITH SalesRepData AS
(
    SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
        ,E.HireDate
        ,FRS.SalesOrderNumber
        ,CAST(FRS.OrderDate AS Date) AS OrderDate
        ,SUM(FRS.SalesAmount) AS SalesAmount
    FROM FactResellerSales FRS 
        INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
    GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate
),
DistinctSalesRep AS
(
    SELECT DISTINCT SRD.SalesRep
    FROM SalesRepData SRD
)
SELECT DSR.SalesRep
      ,(SELECT MAX(SRD.SalesAmount)
        FROM SalesRepData SRD
        WHERE SRD.SalesRep = DSR.SalesRep
        GROUP BY SRD.SalesRep) AS LargestSalesAmount
FROM DistinctSalesRep DSR
ORDER BY DSR.SalesRep;



--
-- To finish things off, man this is ugly!
--
WITH SalesRepData AS
(
    SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
        ,E.HireDate
        ,FRS.SalesOrderNumber
        ,CAST(FRS.OrderDate AS Date) AS OrderDate
        ,SUM(FRS.SalesAmount) AS SalesAmount
    FROM FactResellerSales FRS 
        INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
    GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate
),
DistinctSalesRep AS
(
    SELECT DISTINCT SRD.SalesRep
    FROM SalesRepData SRD
)
SELECT DSR.SalesRep
      ,(SELECT MAX(SRD.SalesAmount)
        FROM SalesRepData SRD
        WHERE SRD.SalesRep = DSR.SalesRep
        GROUP BY SRD.SalesRep) AS LargestSalesAmount
      ,(SELECT SUM(SRD.SalesAmount)
        FROM SalesRepData SRD
        WHERE SRD.SalesRep = DSR.SalesRep
        GROUP BY SRD.SalesRep) AS TotalLifetimeSales
      ,(SELECT MAX(SRD.SalesAmount) / SUM(SRD.SalesAmount)
        FROM SalesRepData SRD
        WHERE SRD.SalesRep = DSR.SalesRep
        GROUP BY SRD.SalesRep) AS LargestPctOfTotal
FROM DistinctSalesRep DSR
ORDER BY DSR.SalesRep;



--
-- CTEs to the rescue!
--
WITH SalesRepData AS
(
    SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
        ,E.HireDate
        ,FRS.SalesOrderNumber
        ,CAST(FRS.OrderDate AS Date) AS OrderDate
        ,SUM(FRS.SalesAmount) AS SalesAmount
    FROM FactResellerSales FRS 
        INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
    GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate
),
IndividualSalesRepData AS
(
    SELECT SRD.SalesRep
          ,MAX(SRD.SalesAmount) AS LargestSalesAmount
          ,SUM(SRD.SalesAmount) AS TotalLifetimeSales
          ,MAX(SRD.SalesAmount) / SUM(SRD.SalesAmount) AS LargestPctOfTotal
    FROM SalesRepData SRD
    GROUP BY SRD.SalesRep
)
SELECT ISRD.SalesRep
      ,ISRD.LargestSalesAmount
      ,ISRD.TotalLifetimeSales
      ,ISRD.LargestPctOfTotal
FROM IndividualSalesRepData ISRD
ORDER BY ISRD.SalesRep;
