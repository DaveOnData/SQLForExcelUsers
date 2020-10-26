--
-- The query that produces the data for Part 18 of the series.
--
SELECT FRS.SalesOrderNumber
      ,SUM(FRS.SalesAmount) AS SalesAmount
FROM FactResellerSales FRS 
GROUP BY FRS.SalesOrderNumber
ORDER BY FRS.SalesOrderNumber




--
-- The following code snippet is not legit SQL!
--
WITH SalesOrders AS
(
    SELECT FRS.SalesOrderNumber
          ,SUM(FRS.SalesAmount) AS SalesAmount
    FROM FactResellerSales FRS 
    GROUP BY FRS.SalesOrderNumber
)



--
-- The SQL equivalent of Excel's IF function is the 
-- mighty CASE WHEN. Write code to simulate what we
-- saw in Excel.
--
WITH SalesOrders AS
(
    SELECT FRS.SalesOrderNumber
          ,SUM(FRS.SalesAmount) AS SalesAmount
    FROM FactResellerSales FRS 
    GROUP BY FRS.SalesOrderNumber
)
SELECT SO.SalesOrderNumber
      ,SO.SalesAmount
      ,CASE
        WHEN SO.SalesAmount > 8400 THEN 'Large'
        ELSE 'Small'
       END AS OrderSize
FROM SalesOrders SO
ORDER BY SO.SalesOrderNumber;



--
-- Handling multiple conditions with the mighty 
-- CASE WHEN.
--
WITH SalesOrders AS
(
    SELECT FRS.SalesOrderNumber
          ,SUM(FRS.SalesAmount) AS SalesAmount
    FROM FactResellerSales FRS 
    GROUP BY FRS.SalesOrderNumber
)
SELECT SO.SalesOrderNumber
      ,SO.SalesAmount
      ,CASE
        WHEN SO.SalesAmount < 1545 THEN 'Small'
        WHEN SO.SalesAmount < 8400 THEN 'Medium'
        WHEN SO.SalesAmount < 34234 THEN 'Large'
        ELSE 'Extra Large'
       END AS OrderSize
FROM SalesOrders SO
ORDER BY SO.SalesOrderNumber;



--
-- A totally contrived example to illustrate embedding a
-- CASE WHEN inside another CASE WHEN.
--
WITH SalesOrders AS
(
    SELECT FRS.SalesOrderNumber
          ,SUM(FRS.SalesAmount) AS SalesAmount
    FROM FactResellerSales FRS 
    GROUP BY FRS.SalesOrderNumber
)
SELECT SO.SalesOrderNumber
      ,SO.SalesAmount
      ,CASE
        WHEN SO.SalesAmount < 1545 THEN
            CASE
                WHEN RIGHT(SO.SalesOrderNumber, 1) % 2 = 0 THEN 'Small Even'
                ELSE 'Small Odd'
            END                                        
        WHEN SO.SalesAmount < 8400 THEN 'Medium'
        WHEN SO.SalesAmount < 34234 THEN 'Large'
        ELSE 'Extra Large'
       END AS OrderSize
FROM SalesOrders SO
ORDER BY SO.SalesOrderNumber;