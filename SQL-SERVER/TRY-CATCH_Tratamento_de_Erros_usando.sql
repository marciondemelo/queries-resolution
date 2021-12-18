/*xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Dica #63 - Tratamento de Erros usando TRY-CATCH
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*/

/*Todos n�s estamos acostumados com tratamento de exce��es em muitas linguagens de programa��o, como o C#.NET e o Visual Basic.NET. 

Agora chegou a hora da linguagem T-SQL dar suporte a esta caracter�stica.

Em vers�es anteriores do SQL Server, us�vamos a vari�vel global @@error para checar as exce��es. Agora o tratamento de exce��es � 
feito atrav�s dos blocos TRY e CATCH eliminando a necessidade de se usar �IF @@error�. 

O TRY � o bloco que cont�m o c�digo que poss�velmente ir� falhar e o CATCH cont�m o c�digo que deve ser executado caso o bloco TRY gere erro.

Um requisito para usar a estrutura de tratamento de exce��o no SQL Server 2005 � habilitar o rolling back autom�tico 
das transa��es com SET XACT_ABORT ON, sen�o o roll back ser� s� do comando que causou o erro e n�o da transa��o.

Quando uma transa��o falha, ela entra em um estado conhecido como doomed. A transa��o continua aberta, mas n�o pode ser comitada. 
Voc� deve manualmente dar um roll back na transa��o que falhou no bloco CATCH usando ROLLBACK TRANSACTION. Essa deve ser uma das 
primeiras declara��es no bloco CATCH para liberar recursos da transa��o assim que poss�vel.

Se for necess�rio usar a vari�vel @@error, voc� deve coloca-la na primeira declara��o do bloco CATCH. Se quiser guardar um log 
dos erros, ter� que armazenar a vari�vel @@error como vari�vel local e fazer o log ap�s declarar ROLLBACK. Se fizer isso antes do ROLLBACK, 
causar� roll back das inser��es no log tamb�m.

Caso precise criar sua pr�pria exce��o em um bloco TRY, use a declara��o RAISERROR.WITH TRAN_ABORT, que permite fazer uma refer�ncia a 
uma mensagem personalizada armazenada na view sys.messages. Essa mensagem � retornada como um erro de Servidor para a aplica��o ou para 
o bloco TRY...CATCH 

Sintaxe:*/

BEGIN TRY  
   { sql_statement | statement_block } 
END TRY 
BEGIN CATCH  
   { sql_statement | statement_block } 
END CATCH 

/*Fun��es de Erros

Existem tamb�m algumas fun��es auxiliares para retornar*/

ERROR_LINE()-- retorna o n�mero da linha que provocou o erro.
ERROR_MESSAGE() --returna a mensagem da aplica��o.
ERROR_NUMBER()-- retorna o n�mero do erro.
ERROR_PROCEDURE() --retorna o nome da stored procedure ou trigger onde ocorreu o erro. Esta fun��o retorna NULL se o erro n�o 
					--ocorre dentro da stored procedure or trigger.
ERROR_SEVERITY() --retorna n�mero do erro considerado s�rio.
ERROR_STATE() --retorna o estado.

/*
Passo-a-passo para criar corretamente uma estrutura de tratamento de exce��es com TRY...CATCH:

Set XACT_ABORT ON 
Criar um bloco TRY ao redor do c�digo que possivelmente causar� um erro.
Criar um bloco CATCH imediatamente ap�s o bloco TRY.
Se quiser capturar os erros em uma vari�vel para futuras an�lises, use a nossa velha conhecida @@error, mas sempre na primeira 
linha do bloco CATCH.ROLLBACK

Exemplo 1 � Criando os blocos TRY...CATCH
*/
Set XACT_ABORT ON 
-- Bloco TRY
Begin TRY
Begin TRAN
Comandos INSERT, UPDATE ou DELETE
      COMMIT TRAN
END TRY

-- Bloco CATCH
BEGIN CATCH  
DECLARE @err int 
      SET @err = @@error  
      ROLLBACK TRAN 
END CATCH

Exemplo 2 � Uso das fun��es de Erros

BEGIN TRY
    -- Gera um erro de divis�o por ZERO.
    SELECT 1/0;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
      SELECT ERROR_LINE() AS ErrorLine;
      SELECT ERROR_NUMBER()AS Errornumber
      SELECT ERROR_PROCEDURE()AS ERRORPROCEDURE
      SELECT ERROR_SEVERITY()AS ERRORSEVERITY
      SELECT ERROR_STATE()AS ERRORSTATE
END CATCH;
GO

Exemplo 3 � Guardando o erro em uma tabela para futuras an�lises

-- Cria-se 2 tabelas, uma de dados e uma de log de erros
CREATE TABLE dbo.tblDados (ColA int PRIMARY KEY, ColB int) 
CREATE TABLE dbo.LogErros (ColA int, ColB int, erro int,  
 date datetime)
GO 

-- Cria uma Procedure para adicionar dados na tabela com tratamento de Erros
-- Repare a fun��o da vari�vel @erro: Ela guarda os erros da vari�vel global
-- @@error e o erro � inserido na tabela LogErros junto com os dados e a data

CREATE PROCEDURE dbo.AdDados @a int, @b int AS 
SET XACT_ABORT ON 
BEGIN TRY 
 BEGIN TRAN 
    INSERT INTO dbo.tblDados VALUES (@a, @b) 

