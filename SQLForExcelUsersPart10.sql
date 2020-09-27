--
-- Query from Part 9. Answers the question, "For 
-- each DataKey, which shift had the highest 
-- number of calls?"
--
SELECT FCC.FactCallCenterID
      ,FCC.DateKey
      ,FCC.WageType
      ,FCC.Shift
      ,FCC.Calls
      ,ROW_NUMBER() OVER (PARTITION BY FCC.DateKey ORDER BY FCC.Calls DESC) AS RowNum
FROM FactCallCenter FCC
ORDER BY FCC.DateKey ASC



--
-- To answer the question, we really just need the
-- the rows where RowNum = 1. 
--
SELECT FCC.FactCallCenterID
      ,FCC.DateKey
      ,FCC.WageType
      ,FCC.Shift
      ,FCC.Calls
      ,ROW_NUMBER() OVER (PARTITION BY FCC.DateKey ORDER BY FCC.Calls DESC) AS RowNum
FROM FactCallCenter FCC
WHERE RowNum = 1
ORDER BY FCC.DateKey ASC



--
-- SQL template for CTEs
/*
WITH <CTE name /> AS
(
     <CTE query here />
)
SELECT <CTE columns />
FROM <CTE name />;
*/



--
-- The combination of CTEs and window functions
-- are like chocolate and peanut butter - better
-- together!
--
-- Check out the magic of ROW_NUMBER in a CTE...
--
WITH DailyShiftsByCalls AS
(
    SELECT FCC.FactCallCenterID
          ,FCC.DateKey
          ,FCC.WageType
          ,FCC.Shift
          ,FCC.Calls
          ,ROW_NUMBER() OVER (PARTITION BY FCC.DateKey ORDER BY FCC.Calls DESC) AS RowNum
    FROM FactCallCenter FCC
)
SELECT DSBC.FactCallCenterID
      ,DSBC.DateKey
      ,DSBC.WageType
      ,DSBC.Shift
      ,DSBC.Calls
FROM DailyShiftsByCalls DSBC
WHERE DSBC.RowNum = 1
ORDER BY DSBC.DateKey



--
-- Using the combination of CTEs and ROW_NUMBER you
-- can easily answer questions like:
--
-- What is the largest value of X in each window?
-- What is the oldest value of X in each window?
-- What is the smallest value of X in each window?
-- What is the newest value of X for each window?
--
WITH DailyShiftsByCalls AS
(
    SELECT FCC.FactCallCenterID
          ,FCC.DateKey
          ,FCC.WageType
          ,FCC.Shift
          ,FCC.Calls
          ,ROW_NUMBER() OVER (PARTITION BY FCC.DateKey ORDER BY FCC.Calls ASC) AS MinRowNum
          ,ROW_NUMBER() OVER (PARTITION BY FCC.DateKey ORDER BY FCC.Calls DESC) AS MaxRowNum
    FROM FactCallCenter FCC
)
SELECT DSBC.FactCallCenterID
      ,DSBC.DateKey
      ,DSBC.WageType
      ,DSBC.Shift
      ,DSBC.Calls
	  ,DSBC.MinRowNum
	  ,DSBC.MaxRowNum
FROM DailyShiftsByCalls DSBC
ORDER BY DSBC.DateKey