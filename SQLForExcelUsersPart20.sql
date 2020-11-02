--
-- Query from Part 19 of the series.
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
FROM SalesRepData SRD
GROUP BY SRD.SalesRep
ORDER BY SRD.SalesRep;



--
-- The following is an equivalent form of the query above.
--
SELECT SRD.SalesRep
      ,SUM(CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 89 THEN 1 ELSE 0 END) AS TotalSalesMadeFirst90Days
      ,SUM(CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 89 THEN SRD.SalesAmount ELSE 0.0 END) AS TotalSalesAmountFirst90Days
FROM (SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
            ,E.HireDate
            ,FRS.SalesOrderNumber
            ,CAST(FRS.OrderDate AS Date) AS OrderDate
            ,SUM(FRS.SalesAmount) AS SalesAmount
      FROM FactResellerSales FRS 
        INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
      GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate) SRD
GROUP BY SRD.SalesRep
ORDER BY SRD.SalesRep;



--
-- This is also another equivalent form of the original query.
--
SELECT SRD.SalesRep
      ,SUM(CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 89 THEN 1 ELSE 0 END) AS TotalSalesMadeFirst90Days
      ,SUM(CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 89 THEN SRD.SalesAmount ELSE 0.0 END) AS TotalSalesAmountFirst90Days
FROM (SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
            ,E.HireDate
            ,FRS.SalesOrderNumber
            ,CAST(FRS.OrderDate AS Date) AS OrderDate
            ,SUM(FRS.SalesAmount) AS SalesAmount
      FROM FactResellerSales FRS 
        INNER JOIN (SELECT *
                    FROM DimEmployee) E ON (FRS.EmployeeKey = E.EmployeeKey)
      GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate) SRD
GROUP BY SRD.SalesRep
ORDER BY SRD.SalesRep;



--
-- Question under analysis - Does sales in the first 90 days of
-- employment correlate with better perfomance for the sales rep
-- at the 1 year mark?
--
-- Build the SQL using subqueries rather than CTEs.
--
SELECT SRD365.SalesRep
      ,COUNT(SRD365.SalesOrderNumber) AS TotalSalesMadeFirst365Days
      ,SUM(SRD365.SalesAmount) AS TotalSalesAmountFirst365Days
FROM (SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
            ,FRS.SalesOrderNumber
            ,CAST(FRS.OrderDate AS Date) AS OrderDate
            ,SUM(FRS.SalesAmount) AS SalesAmount
            ,CASE WHEN DATEDIFF(DAY, E.HireDate, FRS.OrderDate) <= 364 THEN 1 ELSE 0 END AS SaleMadeFirst365Days
     FROM FactResellerSales FRS 
         INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
     GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate) SRD365
WHERE SRD365.SaleMadeFirst365Days = 1
GROUP BY SRD365.SalesRep
ORDER BY SRD365.SalesRep;



--
-- We can't assume that every rep made sales in the first 90 days.
-- structure the existing query so that we can LEFT OUTER JOIN
-- data for the first 90 days.
--
SELECT SRD365.SalesRep
      ,SRD365.TotalSalesMadeFirst365Days
      ,SRD365.TotalSalesAmountFirst365Days
FROM (SELECT SRD365.SalesRep
            ,COUNT(SRD365.SalesOrderNumber) AS TotalSalesMadeFirst365Days
            ,SUM(SRD365.SalesAmount) AS TotalSalesAmountFirst365Days
      FROM (SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
                  ,FRS.SalesOrderNumber
                  ,CAST(FRS.OrderDate AS Date) AS OrderDate
                  ,SUM(FRS.SalesAmount) AS SalesAmount
                  ,CASE WHEN DATEDIFF(DAY, E.HireDate, FRS.OrderDate) <= 364 THEN 1 ELSE 0 END AS SaleMadeFirst365Days
            FROM FactResellerSales FRS 
                INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
            GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate) SRD365
      WHERE SRD365.SaleMadeFirst365Days = 1
      GROUP BY SRD365.SalesRep) SRD365
ORDER BY SRD365.SalesRep;



--
-- Final version using subqueries.
--
SELECT SRD365.SalesRep
      ,SRD90.TotalSalesMadeFirst90Days
      ,SRD90.TotalSalesAmountFirst90Days
      ,SRD365.TotalSalesMadeFirst365Days
      ,SRD365.TotalSalesAmountFirst365Days
FROM (SELECT SRD365.SalesRep
            ,COUNT(SRD365.SalesOrderNumber) AS TotalSalesMadeFirst365Days
            ,SUM(SRD365.SalesAmount) AS TotalSalesAmountFirst365Days
      FROM (SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
                  ,FRS.SalesOrderNumber
                  ,CAST(FRS.OrderDate AS Date) AS OrderDate
                  ,SUM(FRS.SalesAmount) AS SalesAmount
                  ,CASE WHEN DATEDIFF(DAY, E.HireDate, FRS.OrderDate) <= 364 THEN 1 ELSE 0 END AS SaleMadeFirst365Days
            FROM FactResellerSales FRS 
                INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
            GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate) SRD365
      WHERE SRD365.SaleMadeFirst365Days = 1
      GROUP BY SRD365.SalesRep) SRD365
    LEFT OUTER JOIN (SELECT SRD.SalesRep
                           ,COUNT(SRD.SalesOrderNumber) AS TotalSalesMadeFirst90Days
                           ,SUM(SRD.SalesAmount) AS TotalSalesAmountFirst90Days
                     FROM (SELECT CONCAT(E.LastName, ', ', E.FirstName) AS SalesRep 
                                 ,FRS.SalesOrderNumber
                                 ,CAST(FRS.OrderDate AS Date) AS OrderDate
                                 ,SUM(FRS.SalesAmount) AS SalesAmount
                                 ,CASE WHEN DATEDIFF(DAY, E.HireDate, FRS.OrderDate) <= 89 THEN 1 ELSE 0 END AS SaleMadeFirst90Days
                           FROM FactResellerSales FRS 
                            INNER JOIN DimEmployee E ON (FRS.EmployeeKey = E.EmployeeKey)
                           GROUP BY E.FirstName, E.LastName, E.HireDate, FRS.SalesOrderNumber, FRS.OrderDate) SRD
                     WHERE SRD.SaleMadeFirst90Days = 1
                     GROUP BY SRD.SalesRep) SRD90 ON (SRD365.SalesRep = SRD90.SalesRep)
ORDER BY SRD365.SalesRep; 



--
-- CTE version of the query immediately above
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
SalesRepPerformance AS
(
    SELECT SRD.SalesRep
          ,CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 89 THEN 1 ELSE 0 END AS SalesMadeFirst90Days
          ,CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 89 THEN SRD.SalesAmount ELSE 0.0 END AS SalesAmountFirst90Days
          ,CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 364 THEN 1 ELSE 0 END AS SalesMadeFirst365Days
          ,CASE WHEN DATEDIFF(DAY, SRD.HireDate, SRD.OrderDate) <= 364 THEN SRD.SalesAmount ELSE 0.0 END AS SalesAmountFirst365Days
    FROM SalesRepData SRD
),
RepPerformance365Days AS
(
    SELECT SRP.SalesRep
          ,SUM(SRP.SalesMadeFirst365Days) AS TotalSalesMadeFirst365Days
          ,SUM(SRP.SalesAmountFirst365Days) AS TotalSalesAmountFirst365Days
    FROM SalesRepPerformance SRP
    WHERE SRP.SalesMadeFirst365Days = 1
    GROUP BY SRP.SalesRep
 
),
RepPerformance90Days AS
(
    SELECT SRP.SalesRep
          ,SUM(SRP.SalesMadeFirst90Days) AS TotalSalesMadeFirst90Days
          ,SUM(SRP.SalesAmountFirst90Days) AS TotalSalesAmountFirst90Days
    FROM SalesRepPerformance SRP
    WHERE SRP.SalesMadeFirst90Days = 1
    GROUP BY SRP.SalesRep
 
)
SELECT RP365.SalesRep
      ,COALESCE(RP90.TotalSalesMadeFirst90Days, 0.0) AS TotalSalesMadeFirst90Days
      ,COALESCE(RP90.TotalSalesAmountFirst90Days, 0.0) AS TotalSalesAmountFirst90Days
      ,RP365.TotalSalesMadeFirst365Days
      ,RP365.TotalSalesAmountFirst365Days
FROM RepPerformance365Days RP365
    LEFT OUTER JOIN RepPerformance90Days RP90 ON (RP365.SalesRep = RP90.SalesRep)
ORDER BY RP365.SalesRep