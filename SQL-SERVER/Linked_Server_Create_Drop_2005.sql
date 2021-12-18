DECLARE @Servidor VARCHAR(100),
		@Instancia VARCHAR(100),
		@Connection VARCHAR(max),
        @caminho VARCHAR(MAX)
SET @caminho = 'C:\db1.mdb'
SET @Servidor = 'eitapoxa'
SET @Instancia = 'sql2005'
SET @Connection = 'Driver={Microsoft Access Driver (*.mdb)};Dbq=' + @caminho +';Uid=Admin;Pwd=;'
--SET @Connection = 'DRIVER={SQL Server};SERVER=' + @Servidor + '\' + @Instancia + ';UID=sa;PWD=siacorpsa;'

-- cria o link a outro servidor
EXEC sp_addlinkedserver
@server = @Servidor, -- nome com que o servidor sera conhecido no servidor 
 @datasrc  = 'msaccess'
,@srvproduct = ''
,@provider = 'Microsoft.Jet.OLEDB.4.0'
,@provstr = @Connection

SELECT * FROM eitapoxa.db1.dbo.testes

-- lista o servidor linkado
select * from sys.servers where name= @Servidor

-- selecciona dados no servidor linkado
--select * from megatron.[SA_LD_Integrado].dbo.processos

-- elimina o link ao servidor linkado
/*

DECLARE @Servidor VARCHAR(100)
SET @Servidor = 'eitapoxa'
exec sp_dropserver @Servidor

*/


/*
Fonte de dados remota OLE DB.  Provedor OLE DB  product_name  provider_name  data_source  local  provider_string  catálogo  
SQL Server 
 Microsoft SQL Server Native Client OLE DB Provider 
 SQL Server 1 (padrão)
  
  
  
  
  
 
SQL Server 
 Microsoft Microsoft SQL Server Native Client OLE DB Provider
  
 SQLNCLI 
 Nome de rede do SQL Server (para instância padrão)
  
  
 Nome do banco de dados (opcional)
 
SQL Server 
 Microsoft Microsoft SQL Server Native Client OLE DB Provider
  
 SQLNCLI 
 servername\instancename (para instância específica)
  
  
 Nome do banco de dados (opcional)
 
Oracle
 Microsoft OLE DB Provider for Oracle
 Qualquer2
 MSDAORA 
 Alias de SQL*Net para banco de dados de Oracle
  
  
  
 
Oracle, versão 8 e posterior
 Provedor Oracle para OLE DB
 Qualquer
 OraOLEDB.Oracle 
 Alias para o banco de dados de Oracle
  
  
  
 
Access/Jet
 Microsoft OLE DB Provider for Jet
 Qualquer
 Microsoft.Jet.OLEDB.4.0 
 Caminho completo de arquivo de banco de dados de Jet
  
  
  
 
Fonte de dados ODBC
 Microsoft OLE DB Provider for ODBC
 Qualquer
 MSDASQL 
 DSN do sistema da fonte de dados ODBC
  
  
  
 
Fonte de dados ODBC
 Microsoft OLE DB Provider for ODBC
 Qualquer
 MSDASQL 
  
  
 Cadeia de conexão ODBC
  
 
Sistema de arquivos
 Microsoft OLE DB Provider for Indexing Service
 Qualquer
 MSIDXS 
 Nome do catálogo do Indexing Service
  
  
  
 
Planilha do MicrosoftExcel
 MicrosoftOLE DB Provider for Jet
 Qualquer
 Microsoft.Jet.OLEDB.4.0 
 Caminho completo do arquivo de Excel
  
 Excel 5.0
  
 
Banco de dados IBM DB2 
 MicrosoftOLE DB Provider for DB2
 Qualquer
 DB2OLEDB 
  
  
 Consulte a documentação do Microsoft OLE DB Provider for DB2.
 Nome de catálogo do banco de dados DB2
 

*/