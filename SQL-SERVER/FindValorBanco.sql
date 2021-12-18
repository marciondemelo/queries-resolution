DECLARE @CodTable INT, /*guarda id da tabela*/
		@NomeTable VARCHAR(max), /*nome da tabela*/
        @CodColuna INT, /*id da coluna*/
		@NomeColuna VARCHAR(max), /* nome da coluna*/
        @Pesq VARCHAR(max), /*vamos inserit o valor que estamos procurando*/
		@Contem BIT, /*definir se vamos retornar os campos que possuem o valor exato ou quaquer campo que contenha o valor da variavel @Pesq */
		@texto varchar(max) /*variavel utilizada para montar a query dinamica*/

SET @Pesq = '34' /*valor a ser procurado na base*/
SET @Contem = 0 /*definimos 0 para procurar colunas que retornem exatamente o palavra pesquisada e 1 quando uma coluna qualquer da base pussir a palavra.*/



CREATE TABLE #resultado
(
    NomeDaTabela VARCHAR(max),
    NomeDaColuna VARCHAR(max),
    Valor VARCHAR(max)
)

SELECT Tb.OBJECT_ID 'idTab', Tb.NAME 'NomeTab', CL.column_id 'idCol', Cl.NAME 'NomeCol',Tp.NAME 'NomeTipo',Tp.max_length,Tp.PRECISION,Tp.scale 
INTO #tableColumn FROM sys.columns Cl 
JOIN    sys.types Tp ON Cl.system_type_id = Tp.system_type_id 
JOIN    sys.tables Tb    ON Cl.OBJECT_ID = Tb.OBJECT_ID


IF(@Contem =1)
set @Pesq  = '''%'+@Pesq +'%'''
ELSE
set @Pesq  = ''''+@Pesq +''''

SET @CodTable = (SELECT  MIN(idTab) FROM #tableColumn )
SET @NomeTable = (SELECT DISTINCT NomeTab FROM #tableColumn WHERE idtab =@CodTable)  

WHILE(@CodTable IS NOT NULL)
BEGIN
SET @CodColuna = (SELECT MIN(idCol) FROM #tablecolumn WHERE idtab = @CodTable )
SET @NomeColuna = (SELECT DISTINCT NomeCol FROM #tablecolumn WHERE idtab = @CodTable AND idcol = @CodColuna)
PRINT @NomeTable 
        WHILE(@CodColuna IS NOT NULL)
        BEGIN 
            PRINT '   '+@NomeColuna
               EXECUTE ('if exists(select 0 from '+@NomeTable+' where '+@NomeColuna+' LIKE '+@Pesq+') '+
         'begin   '+ 
            'insert into #resultado 
            SELECT ''' + @NomeTable +''','''+ @NomeColuna+''','+@NomeColuna+' FROM '+@NomeTable+' WHERE '+@NomeColuna+' LIKE '+ @Pesq +'
         end')
            SET @CodColuna = (SELECT MIN(idCol) FROM #tablecolumn WHERE idtab = @CodTable AND idcol > @CodColuna)
            SET @NomeColuna = (SELECT DISTINCT NomeCol FROM #tablecolumn WHERE idtab = @CodTable AND idcol = @CodColuna)
        END

SET  @CodTable = (SELECT  MIN(idTab) FROM #tableColumn WHERE idtab >@CodTable)
SET @NomeTable = (SELECT DISTINCT NomeTab FROM #tableColumn WHERE idtab =@CodTable)  

END

SELECT DISTINCT NomeDaTabela ,
        NomeDaColuna ,
        Valor,
        'SELECT ' + NomeDaColuna +', * FROM ' + NomeDaTabela + ' WHERE ' + NomeDaColuna + ' LIKE ''' + Valor + ''''
        FROM #resultado


/*
DROP TABLE #tableColumn 
DROP TABLE #resultado
*/