--
-- Get a sense of FactInternetSales data by
-- looking at a single customer.
--
SELECT *
FROM FactInternetSales FIS
WHERE FIS.CustomerKey = 19766
ORDER BY FIS.CurrencyKey, FIS.SalesOrderNumber



--
-- Use a CTE to group customer sales orders.
--
WITH CustomerSalesOrders AS
(
    SELECT FIS.CustomerKey
          ,FIS.SalesOrderNumber
          ,SUM(SalesAmount) AS SalesAmount
    FROM FactInternetSales FIS
    GROUP BY FIS.CustomerKey, FIS.SalesOrderNumber
)
SELECT *
FROM CustomerSalesOrders CSO
ORDER BY CSO.CustomerKey;



--
-- By using a CTE, we can work directly with the
-- named virtual table. Aggregate sales orders
-- by customer.
--
WITH CustomerSalesOrders AS
(
    SELECT FIS.CustomerKey
          ,FIS.SalesOrderNumber
          ,SUM(SalesAmount) AS SalesAmount
    FROM FactInternetSales FIS
    GROUP BY FIS.CustomerKey, FIS.SalesOrderNumber
)
SELECT CSO.CustomerKey
      ,COUNT(*) AS SalesOrderCount
      ,SUM(CSO.SalesAmount) AS SalesAmount
FROM CustomerSalesOrders CSO
GROUP BY CSO.CustomerKey
ORDER BY CSO.CustomerKey;



--
-- SQL supports defining multiple CTEs! This allows all
-- kinds of analytics goodness as we shall see.
/*
WITH <CTE name #1 /> AS
(
     <CTE query />
),
<CTE name #2 /> AS
(
     <CTE query />
),
<CTE name X /> AS
(
     <CTE query />
)
SELECT <CTE columns />
FROM <CTE name />;
*/



--
-- Rewrite the last query using multiple CTEs.
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
SELECT *
FROM CustomerSalesOrderHistory CSOH
ORDER BY CSOH.CustomerKey;



--
-- Implement the "FM analysis" using the mighty
-- NTILE window function. The easiest way to 
-- understand NTILE is to see it in action.
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
-- Let's say I was just interested in the 10-10 customers.
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
),
RFM AS
(
    SELECT CSOH.CustomerKey
          ,NTILE(10) OVER (ORDER BY CSOH.SalesOrderCount ASC) AS FrequencyScore
          ,NTILE(10) OVER (ORDER BY CSOH.SalesAmount ASC) AS MonetaryScore
    FROM CustomerSalesOrderHistory CSOH
)
SELECT *
FROM RFM FM
WHERE FM.FrequencyScore = 10 AND FM.MonetaryScore = 10
ORDER BY FM.CustomerKey