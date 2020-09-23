--
-- Our first attempt at a SQL window of data.
--
SELECT FCC.FactCallCenterID
      ,FCC.DateKey
      ,FCC.WageType
      ,FCC.Shift
	  ,ROW_NUMBER() OVER (PARTITION BY FCC.DateKey) AS RowNum
FROM FactCallCenter FCC



--
-- Our first successful attempt at a SQL window
-- of data!
--
SELECT FCC.FactCallCenterID
      ,FCC.DateKey
      ,FCC.WageType
      ,FCC.Shift
      ,ROW_NUMBER() OVER (PARTITION BY FCC.DateKey ORDER BY FCC.Shift ASC) AS RowNum
FROM FactCallCenter FCC
ORDER BY FCC.DateKey, FCC.Shift



--
-- Which shift was busiest in terms of the highest
-- number of calls?
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
-- Which days were busiest in terms of calls, bit windowed
-- by WageType and Shift?
--
SELECT FCC.FactCallCenterID
      ,FCC.DateKey
      ,FCC.WageType
      ,FCC.Shift
      ,FCC.Calls
      ,ROW_NUMBER() OVER (PARTITION BY FCC.WageType, FCC.Shift ORDER BY FCC.Calls DESC) AS RowNum
FROM FactCallCenter FCC
ORDER BY FCC.WageType, FCC.Shift ASC

