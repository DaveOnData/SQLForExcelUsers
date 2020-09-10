--
-- The query from the end of Part 4.
--
SELECT FCC.WageType
      ,FCC.Shift
      ,FCC.LevelOneOperators
      ,FCC.LevelTwoOperators
      ,FCC.Calls
      ,FCC.Date
FROM FactCallCenter FCC



--
-- It's easy to perform some "feature engineering" 
-- in the SELECT list.
--
SELECT FCC.WageType
      ,FCC.Shift
      ,FCC.LevelOneOperators
      ,FCC.LevelTwoOperators
      ,FCC.Calls
      ,FCC.Date
      ,FCC.LevelOneOperators + FCC.LevelTwoOperators
FROM FactCallCenter FCC



--
-- Derived columns do not come with names by default.
-- It is good coding practice to use an alias.
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
-- Quite possibly the dumbest feature engineering
-- of all time.
--
SELECT FCC.WageType
      ,FCC.Shift
      ,FCC.LevelOneOperators
      ,FCC.LevelTwoOperators
      ,FCC.Calls
      ,FCC.Date
      ,FCC.LevelOneOperators + FCC.LevelTwoOperators AS AllOperators
      ,AllOperators - 42 AS AllOperators2
FROM FactCallCenter FCC



--
-- You can't explicilty reference a derived column
-- in a SELECT list given that SELECTs are performed
-- last in SQL.
--
SELECT FCC.WageType
      ,FCC.Shift
      ,FCC.LevelOneOperators
      ,FCC.LevelTwoOperators
      ,FCC.Calls
      ,FCC.Date
      ,FCC.LevelOneOperators + FCC.LevelTwoOperators AS AllOperators
      ,(FCC.LevelOneOperators + FCC.LevelTwoOperators) - 42 AS AllOperators2
FROM FactCallCenter FCC
