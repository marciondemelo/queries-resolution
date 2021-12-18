DECLARE @Coluna VARCHAR(MAX), @Contem BIT

SET @Contem = 1
SET @Coluna = 'subprocess'

IF(@Contem =1)
set @Coluna = '%'+@Coluna+'%'

SELECT Tb.NAME 'Tabela',Cl.NAME 'Coluna',Tp.NAME 'Tipo',Tp.max_length,Tp.PRECISION,Tp.scale INTO #resultado FROM sys.columns Cl 
JOIN    sys.types Tp ON Cl.system_type_id = Tp.system_type_id
JOIN    sys.tables Tb    ON Cl.OBJECT_ID = Tb.OBJECT_ID
WHERE cl.NAME LIKE @Coluna


SELECT 
    Tabela ,
    Coluna ,
    Tipo ,
    max_length ,
    precision ,
    scale 
FROM #resultado 
ORDER BY 1,2

DROP TABLE #resultado
