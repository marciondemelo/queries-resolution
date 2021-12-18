DECLARE @Servidor sysname, @ProductName nvarchar(256), @UsuarioSQL sysname, @SenhaSQL sysname

SELECT	@Servidor	= 'SPSERVER244',
		@ProductName= 'SQL Server',
		--//OS PARAMETROS ABAIXO SÓ SERÃO NECESSÁRIO PARA A SEGUNDA PROCEDURE
		--//ONDE É DEFINIDO UM USUARIO ESPECIFICO PARA A CONEXAO LLINKED SERVER
		@UsuarioSQL	= 'sa',
		@SenhaSQL	= 'sa'

--//CRIA UM LINKED SERVER PARA O SERVIDOR SQL CONFIGURADO COM O USUARIO CORRENTE
EXEC master.dbo.sp_addlinkedserver 
	@server		= @Servidor 
	,@srvproduct	= @ProductName
	
--//ADICIONA USUARIO E SENHA PARA UM LIKED SERVER CRIADO.
/*
EXEC master.dbo.sp_addlinkedsrvlogin 
	@rmtsrvname	= @Servidor
	,@useself	= 'True'
	,@locallogin =NULL
	,@rmtuser	= NULL--@UsuarioSQL
	,@rmtpassword= NULL--@SenhaSQL
*/

SELECT * FROM sys.servers

--// RETORNA O NOME DAS BASES DO SERVIDOR CONECTADO
EXECUTE('select name from '+@Servidor+'.master.sys.databases')

