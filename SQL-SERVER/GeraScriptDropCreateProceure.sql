DECLARE @ScpDrop varchar(max)

SELECT @ScpDrop ='IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(troca) AND type in (N''P'', N''PC''))
DROP PROCEDURE [dbo].[troca]
go'


SELECT REPLACE(@ScpDrop,'troca',name) FROM sys.procedures P
JOIN syscomments c ON c.id = p.object_id

go

CREATE TABLE #CorProc
(
	Codigo int IDENTITY,
	ID DECIMAL(10),
	Script varchar(MAX)
)

DECLARE @id DECIMAL(10)
SELECT @id = MIN(id) FROM syscomments
WHILE(@id IS NOT NULL)
BEGIN

	IF(SELECT 0 FROM #CorProc WHERE ID =@id)IS NULL
	BEGIN
		INSERT INTO #CorProc
		        (  ID, Script )
		SELECT id,text FROM syscomments WHERE id = @id
		
	END
	ELSE
	BEGIN
		UPDATE #CorProc
		SET Script = Script '
		'+(SELECT id,text FROM syscomments WHERE id = @id
	END
	SELECT @id = MIN(id) FROM syscomments WHERE id > @id
END
