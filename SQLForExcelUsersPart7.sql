--
-- A very simple use of the mighty GROUP BY.
-- What are the unique values of the Shift 
-- column?
--
SELECT FCC.Shift
FROM FactCallCenter FCC
GROUP BY FCC.Shift





























--
-- In SQL results are not sorted by default.
-- Sometimes resutls are sorted, but you shouldn't
-- count on it. Always explicitly sort by using
-- ORDER BY.
--
SELECT FCC.Shift
FROM FactCallCenter FCC
GROUP BY FCC.Shift
ORDER BY FCC.Shift ASC



--
-- In SQL, aggregate functions operate like the 
-- summarization functions in Excel pivot tables.
-- Use some aggregate function awesomeness to
-- mimic the pivot table we saw in Excel.
--
SELECT FCC.Shift
      ,SUM(FCC.LevelOneOperators)
      ,MIN(FCC.LevelOneOperators)
      ,MAX(FCC.LevelOneOperators)
FROM FactCallCenter FCC
GROUP BY FCC.Shift
ORDER BY FCC.Shift ASC



--
-- As we've seen before, SQL doesn't provide column
-- names. Use aliases.
--
SELECT FCC.Shift
      ,SUM(FCC.LevelOneOperators) AS TotalLevelOneOperators
      ,MIN(FCC.LevelOneOperators) AS MinLevelOneOperators
      ,MAX(FCC.LevelOneOperators) AS MaxLevelOneOperators
FROM FactCallCenter FCC
GROUP BY FCC.Shift
ORDER BY FCC.Shift ASC

