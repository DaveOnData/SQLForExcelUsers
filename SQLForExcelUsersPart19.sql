--
-- Base query to get the data we saw in Excel.
--
SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
      ,E.HireDate
      ,FRS.SalesOrderNumber
      ,CAST(FRS.OrderDate AS Date) AS OrderDate
      ,SUM(FRS.SalesAmount) AS SalesAmount
FROM FactResellerSales FRS 
    INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate
ORDER BY E.LastName, E.FirstName, FRS.SalesOrderNumber




--
-- Perform the date calculations and simulate what we saw in
-- the Excel table.
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
      ,SRD.HireDate
      ,SRD.SalesOrderNumber
      ,SRD.OrderDate
      ,SRD.SalesAmount
      ,CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 89 THEN 1 ELSE 0 END AS SaleMadeFirst90Days
      ,CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 89 THEN SRD.SalesAmount ELSE 0.0 END AS SalesAmountFirst90Days
FROM SalesRepData SRD
ORDER BY SRD.SalesRep, SRD.SalesOrderNumber;



--
-- Final version of the query that matches what we saw in the
-- Excel pivot table.
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
      ,SUM(CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 89 THEN 1 ELSE 0 END) AS TotalSalesMadeFirst90Days
      ,SUM(CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 89 THEN SRD.SalesAmount ELSE 0.0 END) AS TotalSalesAmountFirst90Days
	  ,SUM(SRD.SalesAmount) AS LifetimeSales
FROM SalesRepData SRD
GROUP BY SRD.SalesRep
ORDER BY SRD.SalesRep
