
DECLARE @Iniciodata VARCHAR(10), @Fimdata VARCHAR(10), @nomProc VARCHAR(30)
SET @Iniciodata = '30/07/2009'
SET @Fimdata = '30/07/2009'
SET @nomProc = 'plano'

SELECT * FROM sys.objects
WHERE  (
		CONVERT(varchar, modify_date, 103) 
		BETWEEN 
			CONVERT(varchar,@Iniciodata ,103) 
			AND 
			CONVERT(varchar,@Fimdata ,103)
		) 

/*---------------------------------------------
DESCOMENTE O TIPO DE OBJETO DE DESEJA RETORNAR
---------------------------------------------*/

--AND TYPE ='FN'	--SQL_SCALAR_FUNCTION
--AND TYPE ='IF'    --SQL_INLINE_TABLE_VALUED_FUNCTION
--AND TYPE ='UQ'	--UNIQUE_CONSTRAINT
--AND TYPE ='SQ'	--SERVICE_QUEUE
--AND TYPE ='F' 	--FOREIGN_KEY_CONSTRAINT
--AND TYPE ='U' 	--USER_TABLE
--AND TYPE ='D' 	--DEFAULT_CONSTRAINT
--AND TYPE ='PK'	--PRIMARY_KEY_CONSTRAINT
--AND TYPE ='V' 	--VIEW
--AND TYPE ='S' 	--SYSTEM_TABLE
--AND TYPE ='IT'	--INTERNAL_TABLE
--AND TYPE ='P' 	--SQL_STORED_PROCEDURE
--AND TYPE ='TF'	--SQL_TABLE_VALUED_FUNCTION
	
/*nome da procedure*/
AND NAME LIKE '%'+@nomProc+'%'

ORDER BY MODIFY_date 









