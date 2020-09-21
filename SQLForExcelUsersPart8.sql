--
-- Simulate the first Excel pivot table, 
-- we've seen this before.
--
SELECT FCC.Shift
      ,FCC.WageType
      ,SUM(FCC.LevelOneOperators) AS TotalLevelOneOperators
      ,MIN(FCC.LevelOneOperators) AS MinLevelOneOperators
      ,MAX(FCC.LevelOneOperators) AS MaxLevelOneOperators
FROM FactCallCenter FCC
GROUP BY FCC.Shift, FCC.WageType



--
-- Improved query. REMEMBER - SQL makes no
-- assurances regarding to sort order. If
-- you want your data sorted, use ORDER BY!
--
SELECT FCC.Shift
      ,FCC.WageType
      ,SUM(FCC.LevelOneOperators) AS TotalLevelOneOperators
      ,MIN(FCC.LevelOneOperators) AS MinLevelOneOperators
      ,MAX(FCC.LevelOneOperators) AS MaxLevelOneOperators
FROM FactCallCenter FCC
GROUP BY FCC.Shift, FCC.WageType
ORDER BY FCC.Shift, FCC.WageType



--
-- While there are a number of SQL aggregate functions,
-- the following 5 are used very commonly in practice.
--
SELECT FCC.Shift
      ,FCC.WageType
      ,COUNT(FCC.FactCallCenterID) AS RecordCount
      ,SUM(FCC.LevelOneOperators) AS TotalLevelOneOperators
      ,MIN(FCC.LevelOneOperators) AS MinLevelOneOperators
      ,MAX(FCC.LevelOneOperators) AS MaxLevelOneOperators
      ,AVG(CAST(FCC.LevelOneOperators AS DECIMAL(4,2))) AS AvgLevelOneOperators
FROM FactCallCenter FCC
GROUP BY FCC.Shift, FCC.WageType
ORDER BY FCC.Shift, FCC.WageType


