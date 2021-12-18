
IF EXISTS(SELECT * from tempdb..sysobjects WHERE name = '##tabela')
    DROP TABLE ##tabela
    
CREATE TABLE ##tabela
(
    nometable	VARCHAR(1000)
    ,qtdline	INT
    ,qtdlineProd INT  NULL
)

GO
   
sp_msforeachtable '
    insert ##tabela select ''?'', count(*), null from ?'

go
sp_msforeachtable '
    IF exists (select 0 from ##tabela where nometable = ''?'')
    begin
        declare @count int
        select @count = count(*) from ibasel_integrado_safra_SA.?
        
        update ##tabela 
        set qtdlineprod = @count
        where nometable = ''?''
    end
    '

SELECT * FROM ##tabela
WHERE qtdline > 0 AND qtdlineProd > 0 AND qtdline <> qtdlineProd 
ORDER BY nometable
GO

--SELECT * FROM ##tabela WHERE qtdlineProd >qtdline AND qtdline <> 0

GO
--DROP TABLE #tabela

-- delete ##tabela