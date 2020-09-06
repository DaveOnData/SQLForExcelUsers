--
-- Logically, the first thing processed in SQL is the FROM
--
FROM FactCallCenter



--
-- It is common to use an "alias" for tables in SQL
--
FROM FactCallCenter FCC



--
-- Next, SQL considers filters. We're not there yet.
-- Just SELECT all the columns in the table using the
-- "*" wildcard.
--
SELECT *
FROM FactCallCenter FCC



--
-- It is commonly considered bad practice to use the
-- "*" wildcard. Better is to explicitly list the 
-- columns you want.
--
SELECT FCC.WageType
      ,FCC.Shift
      ,FCC.LevelOneOperators
      ,FCC.LevelTwoOperators
      ,FCC.Calls
      ,FCC.Date
FROM FactCallCenter FCC



--
-- Full query.
--
SELECT FCC.WageType
      ,FCC.Shift
      ,FCC.LevelOneOperators
      ,FCC.LevelTwoOperators
      ,FCC.Calls
      ,FCC.Date
FROM FactCallCenter FCC
WHERE (FCC.Shift = 'PM1' OR FCC.Shift = 'PM2') AND
      (FCC.LevelTwoOperators <= 10)
