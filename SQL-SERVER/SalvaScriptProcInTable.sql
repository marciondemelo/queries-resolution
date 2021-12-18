DECLARE @Min INT, @ColId INT, @Procedure VARCHAR(max), @nome VARCHAR(500)

SELECT @Min = MIN(object_id) FROM sys.procedures

WHILE (@Min IS NOT NULL)
BEGIN
	SELECT @nome = name FROM sys.procedures WHERE object_id = @Min
	SELECT @ColId = MIN(colid) FROM syscomments WHERE id = @Min
	SELECT @Procedure = text FROM syscomments WHERE id = @Min AND colid = @ColId
	SELECT @ColId = MIN(colid) FROM syscomments WHERE id = @Min AND colid > @ColId
	
	WHILE(@ColId IS NOT NULL)
	BEGIN
		
		SET @Procedure = @Procedure + (SELECT  text FROM syscomments WHERE id = @Min AND colid = @ColId)
		
	SELECT @ColId = MIN(colid) FROM syscomments WHERE id = @Min AND colid > @ColId
	END
	SELECT @Procedure
	INSERT VERS_CONTROL.dbo.LOG_OBJETOS( EventTime ,EventType ,ServerName ,DatabaseName ,ObjectType ,ObjectName ,UserName ,CommandText ,XMLLogEvent)
	SELECT  GETDATE() EventTime ,
	        'CREATE_PROCEDURE' EventType ,
	        'SPSERVER244' ServerName ,
	        'ROCID000' DatabaseName ,
	        'PROCEDURE' ObjectType ,
	        @nome ObjectName ,
	        'sa' UserName ,
	        @Procedure CommandText ,
	        NULL XMLLogEvent 

	
SELECT @Min = MIN(object_id) FROM sys.procedures WHERE object_id > @Min
END

