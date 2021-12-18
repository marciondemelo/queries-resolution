IF NOT EXISTS(Select * from Tempdb..SysObjects Where Xtype='U' AND name = '##TablesUsadas')
BEGIN
    create table ##TablesUsadas
    (
        Nome VARCHAR(500),
        Modulo VARCHAR(10)
    )
END
go
sp_msforeachtable 
'
if((select count(*) from ?)>0) 
begin 
    if not exists(select * from ##TablesUsadas where nome = replace(''?'',''[dbo].'','''') and modulo = ''LD'')
    insert into ##TablesUsadas values (replace(''?'',''[dbo].'',''''), ''LD'')
end 
'
SELECT * FROM ##TablesUsadas 
/*
    DROP TABLE ##TablesUsadas 
*/

