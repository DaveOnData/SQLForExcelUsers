--
-- SQL query from Part 5
--
SELECT FCC.WageType
      ,FCC.Shift
      ,FCC.LevelOneOperators
      ,FCC.LevelTwoOperators
      ,FCC.Calls
      ,FCC.Date
      ,FCC.LevelOneOperators + FCC.LevelTwoOperators AS AllOperators
FROM FactCallCenter FCC



--
-- Add the new AvgCallsPerOperator feature to the
-- SELECT list
--
SELECT FCC.WageType
      ,FCC.Shift
      ,FCC.LevelOneOperators
      ,FCC.LevelTwoOperators
      ,FCC.Calls
      ,FCC.Date
      ,FCC.LevelOneOperators + FCC.LevelTwoOperators AS AllOperators
      ,FCC.Calls / (FCC.LevelOneOperators + FCC.LevelTwoOperators) AS AvgCallsPerOperator
FROM FactCallCenter FCC



--
-- To get SQL to perform the calculation as desired,
-- CAST one of the integer values to a decimal.
--
SELECT FCC.WageType
      ,FCC.Shift
      ,FCC.LevelOneOperators
      ,FCC.LevelTwoOperators
      ,FCC.Calls
      ,FCC.Date
      ,FCC.LevelOneOperators + FCC.LevelTwoOperators AS AllOperators
      ,CAST(FCC.Calls AS DECIMAL(6,2)) / (FCC.LevelOneOperators + FCC.LevelTwoOperators) AS AvgCallsPerOperator
FROM FactCallCenter FCC

