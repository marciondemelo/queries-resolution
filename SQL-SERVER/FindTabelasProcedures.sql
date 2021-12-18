DECLARE @ProcNome VARCHAR(max), @TableNome VARCHAR(max), @TipoProc VARCHAR(max)

SELECT	@TableNome = 'tOcorrencia',
		@ProcNome = NULL,
		@TipoProc = 'I' /*S,I ou U*/


SELECT  P.name NomeProc, TB.name NomeTable, grupo.QtdColuna  FROM sys.procedures P
JOIN syscomments C ON C.id = P.object_id
JOIN sys.tables TB ON C.text LIKE '%'+ TB.name +'%'
JOIN (	SELECT DISTINCT tab.object_id, TAB.name, COUNT(column_id) QtdColuna 
		FROM sys.columns Cl JOIN SYS.tables TAB ON TAB.object_id = Cl.object_id 
		GROUP BY tab.object_id, tab.name
	) grupo ON TB.object_id = grupo.object_id
	
WHERE	(@TableNome IS NULL OR TB.name = @TableNome )
AND		(@ProcNome IS NULL OR P.name LIKE '%' + @ProcNome + '%')
AND		(@TipoProc IS NULL OR P.name LIKE '%' + '[_]'+ @TipoProc)
GROUP BY P.name, TB.name, grupo.QtdColuna 
ORDER BY P.name

 