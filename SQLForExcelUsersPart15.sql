--
-- Use a subset of 6 employees from the DimEmployee table.
--
SELECT E.EmployeeKey
      ,E.FirstName
      ,E.LastName
FROM DimEmployee E 
WHERE E.EmployeeKey = 271 OR
      E.EmployeeKey = 274 OR
      E.EmployeeKey = 275 OR
      E.EmployeeKey = 277 OR
      E.EmployeeKey = 282 OR
      E.EmployeeKey = 283



--
-- The SQL IN keyword is a shortcut for using a lot of
-- ORs in your WHERE clauses.
--
SELECT E.EmployeeKey
      ,E.FirstName
      ,E.LastName
FROM DimEmployee E 
WHERE E.EmployeeKey IN (271, 274, 275, 277, 282, 283)



--
-- Take a peek at the FactSalesQuota table.
--
SELECT SQ.EmployeeKey
      ,SQ.SalesAmountQuota
FROM FactSalesQuota SQ
ORDER BY SQ.EmployeeKey, SQ.SalesQuotaKey



--
-- The following isn't legit SQL, here to talk about concepts.
--
SELECT E.EmployeeKey
      ,E.FirstName
      ,E.LastName
      ,SQ.SalesAmountQuota
FROM DimEmployee E 
    LEFT OUTER JOIN FactSalesQuota SQ 
WHERE E.EmployeeKey IN (271, 274, 275, 277, 282, 283)



--
-- The following is a legit LEFT OUTER JOIN as it has
-- an ON clause (i.e., a JOIN condition) defined.
--
SELECT E.EmployeeKey
      ,E.FirstName
      ,E.LastName
      ,SQ.SalesAmountQuota
FROM DimEmployee E 
    LEFT OUTER JOIN FactSalesQuota SQ ON (E.EmployeeKey = SQ.EmployeeKey)
WHERE E.EmployeeKey IN (271, 274, 275, 277, 282, 283)
ORDER BY E.EmployeeKey



--
-- Beware the NULL of SQL! NULL denote the absence of value.
-- Use the IS NULL syntax to get employees that do not have
-- sales quotas.
--
SELECT E.EmployeeKey
      ,E.FirstName
      ,E.LastName
      ,SQ.SalesAmountQuota
FROM DimEmployee E 
    LEFT OUTER JOIN FactSalesQuota SQ ON (E.EmployeeKey = SQ.EmployeeKey)
WHERE E.EmployeeKey IN (271, 274, 275, 277, 282, 283) AND
      SQ.SalesAmountQuota IS NULL



--
-- Use the IS NOT NULL syntax to get employees that do have
-- sales quotas.
--
SELECT E.EmployeeKey
      ,E.FirstName
      ,E.LastName
      ,SQ.SalesAmountQuota
FROM DimEmployee E 
    LEFT OUTER JOIN FactSalesQuota SQ ON (E.EmployeeKey = SQ.EmployeeKey)
WHERE E.EmployeeKey IN (271, 274, 275, 277, 282, 283) AND
      SQ.SalesAmountQuota IS NOT NULL
ORDER BY E.EmployeeKey

