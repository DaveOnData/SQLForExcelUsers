--
-- The "FM" analysis query from Part 11 of the series.
--
WITH CustomerSalesOrders AS
(
    SELECT FIS.CustomerKey
          ,FIS.SalesOrderNumber
          ,SUM(SalesAmount) AS SalesAmount
    FROM FactInternetSales FIS
    GROUP BY FIS.CustomerKey, FIS.SalesOrderNumber
),
CustomerSalesOrderHistory AS
(
    SELECT CSO.CustomerKey
          ,COUNT(*) AS SalesOrderCount
          ,SUM(CSO.SalesAmount) AS SalesAmount
    FROM CustomerSalesOrders CSO
    GROUP BY CSO.CustomerKey
)
SELECT CSOH.CustomerKey
      ,NTILE(10) OVER (ORDER BY CSOH.SalesOrderCount ASC) AS FrequencyScore
      ,NTILE(10) OVER (ORDER BY CSOH.SalesAmount ASC) AS MonetaryScore
FROM CustomerSalesOrderHistory CSOH
ORDER BY CSOH.CustomerKey;



--
-- Enhance the query by using the MAX aggregate function
-- to pull the most recent sales date for each sales order.
--
WITH CustomerSalesOrders AS
(
    SELECT FIS.CustomerKey
          ,FIS.SalesOrderNumber
          ,SUM(SalesAmount) AS SalesAmount
          ,MAX(OrderDate) AS OrderDate
    FROM FactInternetSales FIS
    GROUP BY FIS.CustomerKey, FIS.SalesOrderNumber
),
CustomerSalesOrderHistory AS
(
    SELECT CSO.CustomerKey
          ,COUNT(*) AS SalesOrderCount
          ,SUM(CSO.SalesAmount) AS SalesAmount
    FROM CustomerSalesOrders CSO
    GROUP BY CSO.CustomerKey
)
SELECT CSOH.CustomerKey
      ,NTILE(10) OVER (ORDER BY CSOH.SalesOrderCount ASC) AS FrequencyScore
      ,NTILE(10) OVER (ORDER BY CSOH.SalesAmount ASC) AS MonetaryScore
FROM CustomerSalesOrderHistory CSOH
ORDER BY CSOH.CustomerKey;



--
-- Further enhance the query by again using the MAX aggregate
-- function to find the most recent sales order for each 
-- customer.
-- 
WITH CustomerSalesOrders AS
(
    SELECT FIS.CustomerKey
          ,FIS.SalesOrderNumber
          ,SUM(SalesAmount) AS SalesAmount
          ,MAX(OrderDate) AS OrderDate
    FROM FactInternetSales FIS
    GROUP BY FIS.CustomerKey, FIS.SalesOrderNumber
),
CustomerSalesOrderHistory AS
(
    SELECT CSO.CustomerKey
          ,COUNT(*) AS SalesOrderCount
          ,SUM(CSO.SalesAmount) AS SalesAmount
          ,MAX(CSO.OrderDate) AS MostRecentOrderDate
    FROM CustomerSalesOrders CSO
    GROUP BY CSO.CustomerKey
)
SELECT CSOH.CustomerKey
      ,NTILE(10) OVER (ORDER BY CSOH.SalesOrderCount ASC) AS FrequencyScore
      ,NTILE(10) OVER (ORDER BY CSOH.SalesAmount ASC) AS MonetaryScore
FROM CustomerSalesOrderHistory CSOH
ORDER BY CSOH.CustomerKey;



--
-- The mighty SQL DATEDIFF function in action across
-- days, months, years
--
SELECT DATEDIFF(DAY, '2018-01-01 00:00:00', '2020-01-01 00:00:00') AS DiffInDays
      ,DATEDIFF(MONTH, '2018-01-01 00:00:00', '2020-01-01 00:00:00') AS DiffInMonths
	  ,DATEDIFF(YEAR, '2018-01-01 00:00:00', '2020-01-01 00:00:00') AS DiffInYears



--
-- Like chocolate and peanut butter, DATEDIFF is better together
-- with CURRENT_TIMESTAMP.
--
SELECT CURRENT_TIMESTAMP AS CurrentDateTime
      ,DATEDIFF(DAY, '2018-01-01 00:00:00', CURRENT_TIMESTAMP) AS DiffInDays
      ,DATEDIFF(MONTH, '2018-01-01 00:00:00', CURRENT_TIMESTAMP) AS DiffInMonths
	  ,DATEDIFF(YEAR, '2018-01-01 00:00:00', CURRENT_TIMESTAMP) AS DiffInYears



--
-- Enhance query to calculate, by customer, the elapsed days
-- since the most recent sales order date.
--
WITH CustomerSalesOrders AS
(
    SELECT FIS.CustomerKey
          ,FIS.SalesOrderNumber
          ,SUM(SalesAmount) AS SalesAmount
          ,MAX(OrderDate) AS OrderDate
    FROM FactInternetSales FIS
    GROUP BY FIS.CustomerKey, FIS.SalesOrderNumber
),
CustomerSalesOrderHistory AS
(
    SELECT CSO.CustomerKey
          ,COUNT(*) AS SalesOrderCount
          ,SUM(CSO.SalesAmount) AS SalesAmount
          ,DATEDIFF(DAY, MAX(CSO.OrderDate), CURRENT_TIMESTAMP) AS ElapsedDaysToMostRecentOrder
    FROM CustomerSalesOrders CSO
    GROUP BY CSO.CustomerKey
)
SELECT CSOH.CustomerKey
      ,NTILE(10) OVER (ORDER BY CSOH.SalesOrderCount ASC) AS FrequencyScore
      ,NTILE(10) OVER (ORDER BY CSOH.SalesAmount ASC) AS MonetaryScore
FROM CustomerSalesOrderHistory CSOH
ORDER BY CSOH.CustomerKey;



--
-- Modify the outer query to calcualte the (R)ecency score
-- for each customer.
--
WITH CustomerSalesOrders AS
(
    SELECT FIS.CustomerKey
          ,FIS.SalesOrderNumber
          ,SUM(SalesAmount) AS SalesAmount
          ,MAX(OrderDate) AS OrderDate
    FROM FactInternetSales FIS
    GROUP BY FIS.CustomerKey, FIS.SalesOrderNumber
),
CustomerSalesOrderHistory AS
(
    SELECT CSO.CustomerKey
          ,COUNT(*) AS SalesOrderCount
          ,SUM(CSO.SalesAmount) AS SalesAmount
          ,DATEDIFF(DAY, MAX(CSO.OrderDate), CURRENT_TIMESTAMP) AS ElapsedDaysToMostRecentOrder
    FROM CustomerSalesOrders CSO
    GROUP BY CSO.CustomerKey
)
SELECT CSOH.CustomerKey
      ,NTILE(10) OVER (ORDER BY CSOH.ElapsedDaysToMostRecentOrder DESC) AS RecencyScore
      ,NTILE(10) OVER (ORDER BY CSOH.SalesOrderCount ASC) AS FrequencyScore
      ,NTILE(10) OVER (ORDER BY CSOH.SalesAmount ASC) AS MonetaryScore
FROM CustomerSalesOrderHistory CSOH
ORDER BY CSOH.CustomerKey;



--
-- Last version of the query, get only the 10-10-10 custoemers.
--
WITH CustomerSalesOrders AS
(
    SELECT FIS.CustomerKey
          ,FIS.SalesOrderNumber
          ,SUM(SalesAmount) AS SalesAmount
          ,MAX(OrderDate) AS OrderDate
    FROM FactInternetSales FIS
    GROUP BY FIS.CustomerKey, FIS.SalesOrderNumber
),
CustomerSalesOrderHistory AS
(
    SELECT CSO.CustomerKey
          ,COUNT(*) AS SalesOrderCount
          ,SUM(CSO.SalesAmount) AS SalesAmount
          ,DATEDIFF(DAY, MAX(CSO.OrderDate), CURRENT_TIMESTAMP) AS ElapsedDaysToMostRecentOrder
    FROM CustomerSalesOrders CSO
    GROUP BY CSO.CustomerKey
),
RFMAnalysis AS
(
    SELECT CSOH.CustomerKey
          ,NTILE(10) OVER (ORDER BY CSOH.ElapsedDaysToMostRecentOrder DESC) AS RecencyScore
          ,NTILE(10) OVER (ORDER BY CSOH.SalesOrderCount ASC) AS FrequencyScore
          ,NTILE(10) OVER (ORDER BY CSOH.SalesAmount ASC) AS MonetaryScore
    FROM CustomerSalesOrderHistory CSOH
)
SELECT RFM.CustomerKey
      ,RFM.RecencyScore
      ,RFM.FrequencyScore
      ,RFM.MonetaryScore
FROM RFMAnalysis RFM
WHERE RFM.RecencyScore >= 8 AND
      RFM.FrequencyScore >= 8 AND
      RFM.MonetaryScore >= 8
ORDER BY RFM.CustomerKey ASC;