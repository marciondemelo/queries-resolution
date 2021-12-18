Declare @vTable TABLE(id INT, NAME VARCHAR(100))
INSERT INTO @vTable SELECT 1,'Shamas Qamar' UNION ALL
SELECT 2,'Atif' UNION ALL
SELECT 3,'Kashif' UNION ALL
SELECT 4,'Imran' 

SELECT * FROM @vTable

DECLARE @vParam VARCHAR(100)
-- To check the values with LIKE operator. These are comma separated.
SET @vParam = 'Sha,hif'

-- Used CROSS APPLY to accomplish the task...
SELECT * FROM @vTable 
CROSS APPLY (SELECT Linha FROM dbo.TFN_SplitText(@vParam,',')) b
WHERE NAME LIKE '%' + b.Linha + '%'

SELECT  * FROM  dbo.TFN_SplitText ('Sha,hif',',')