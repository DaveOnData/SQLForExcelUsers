--
-- Transform a string literay explicitly into various SQL
-- data/time-related types.
--
SELECT CAST('2020-02-05 13:34:44' AS DATETIME)

SELECT CAST('2020-02-05 13:34:44' AS DATE)

SELECT CAST('2020-02-05 13:34:44' AS TIME(0))



--
-- In SQL, data types matter. A lot.
--
SELECT CAST('2020-02-05' AS DATETIME)



--
-- The SQL CURRENT_TIMESTAMP function is analogous to 
-- Excel's NOW function. Notice how SQL handles the data.
--
SELECT CURRENT_TIMESTAMP AS CurrentDateAndTime
      ,CAST(CURRENT_TIMESTAMP AS DATE) AS CurrentDate
	  ,CAST(CURRENT_TIMESTAMP AS TIME) AS CurrentTime



--
-- By default, T-SQL TIMEs go down to 100
-- nanoseconds! Here's how to control how
-- small of TIME you would like.
SELECT CURRENT_TIMESTAMP AS CurrentDateAndTime
      ,CAST(CURRENT_TIMESTAMP AS DATE) AS CurrentDate
	  ,CAST(CURRENT_TIMESTAMP AS TIME(0)) AS CurrentTimeSecond
	  ,CAST(CURRENT_TIMESTAMP AS TIME(3)) AS CurrentTimeMilliseconds
	  ,CAST(CURRENT_TIMESTAMP AS TIME(7)) AS CurrentTimeFullAccuracy
