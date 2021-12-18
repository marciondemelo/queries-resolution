SELECT IDENTITY(INT,1,1) Cod, name INTO ##bases FROM sys.databases where name in 
(
'DB_IBASEL_MAXIMA_HMG'
,'DB_LD_BS_'
,'DB_LD_BS_I'
,'DB_LD_SAFRA'
,'DB_LD_SAFRA_SQA'
,'DB_LD_Sincronizacao'
,'DBiBasel_BC'
,'DBiBasel_BrasilCap'
,'DBiBasel_BrasilCap_SQA'
,'DBiBasel_FOLLOW'
,'DBiBasel_SQA'
,'DBiBaselApresentacao'
,'DBiBaselBanif'
,'DBiBaselBC'
,'DBiBaselBS'
,'DBIBASELBS_MIGRACAO'
,'DBiBaselBS_Reports_Testes'
,'DBIBaselBS_Rodrigo'
,'DBiBaselBSLimpa'
,'DBIBASELBSPROD'
,'DBIBILD_SQA'
,'DBMaxima'
,'distribution_safra'
,'SA_KRI'
,'SA_LD_Integrado'
,'SA_LD_Integrado_BS_Prod'
,'SA_LD_Integrado_PAC'
,'SA_LD_Integrado_SQA'
,'SIACORP_LD_DB'
,'WSSVMMAXIMA'
,'SA_LD_Integrado2',
'SA_LD_Integrado2_Testes_Reports'
)






CREATE TABLE #script
(
    Cod INT IDENTITY(1,1),
    Script VARCHAR(MAX)
)

DECLARE @minBase INT, @nomeBase varchar(max), @Script VARCHAR(max)

SELECT @minBase = MIN(cod) FROM ##bases
WHILE @minBase IS NOT NULL
BEGIN


SET @nomeBase = (SELECT NAME FROM ##bases WHERE cod = @minBase)
SET @Script = 'Use '+@nomeBase
+
'
go
'
--' BACKUP LOG '+(SELECT NAME FROM ##bases WHERE cod = @minBase)+' WITH TRUNCATE_ONLY'
INSERT INTO #script VALUES(@Script)

SET @Script =
'DECLARE @NomeFile VARCHAR(100)
SET @NomeFile = (SELECT NAME FROM sys.database_files WHERE file_id = 2 )
DBCC SHRINKFILE(@NomeFile, 1)'
INSERT INTO #script VALUES(@Script)

SET @Script =
'BACKUP DATABASE ' + @nomeBase +' TO DISK = ''C:\Temp\' + @nomeBase +'.bak'''
INSERT INTO #script VALUES(@Script)

SET @Script ='
'
INSERT INTO #script VALUES(@Script)

SELECT @minBase = MIN(cod) FROM ##bases WHERE cod > @minBase
END


SELECT @minBase = MIN(cod) FROM #script
WHILE @minBase IS NOT NULL
BEGIN
SET @Script = (SELECT script FROM #script WHERE cod = @minBase)
--EXEC (@script)

SELECT @minBase = MIN(cod) FROM #script WHERE cod > @minBase
END

SELECT script FROM #script 

DROP TABLE ##bases
DROP TABLE #script