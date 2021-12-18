
CREATE TABLE #temp 
(
	Nivel INT,
	CodRecurso INT
)

DECLARE @nivel INT, @CodRec INT

SELECT @nivel = 1, @CodRec = 1100

INSERT INTO #temp
        ( Nivel, CodRecurso )
VALUES  ( 1, -- Nivel - int
          @CodRec  -- CodRecurso - int
          )

WHILE ((SELECT DISTINCT 0 FROM dbo.TSecRecurso WHERE CodRecursoPai IN (SELECT CodRecurso from #temp WHERE Nivel = @nivel)) = 0)
BEGIN


INSERT INTO #temp( Nivel, CodRecurso )
SELECT @nivel + 1, CodRecurso FROM dbo.TSecRecurso WHERE CodRecursoPai IN (SELECT CodRecurso from #temp WHERE Nivel = @nivel)

SELECT @nivel = @nivel + 1

PRINT 'passou'
END



DELETE TSecPrivilegio where CodRecurso in (SELECT CodRecurso FROM #temp )
DELETE tsecrecurso where CodRecurso in (SELECT CodRecurso FROM #temp )

DROP TABLE #temp



