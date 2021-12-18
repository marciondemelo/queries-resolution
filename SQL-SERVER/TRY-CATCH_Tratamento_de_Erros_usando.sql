/*xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Dica #63 - Tratamento de Erros usando TRY-CATCH
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*/

/*Todos nós estamos acostumados com tratamento de exceções em muitas linguagens de programação, como o C#.NET e o Visual Basic.NET. 

Agora chegou a hora da linguagem T-SQL dar suporte a esta característica.

Em versões anteriores do SQL Server, usávamos a variável global @@error para checar as exceções. Agora o tratamento de exceções é 
feito através dos blocos TRY e CATCH eliminando a necessidade de se usar “IF @@error”. 

O TRY é o bloco que contém o código que possívelmente irá falhar e o CATCH contém o código que deve ser executado caso o bloco TRY gere erro.

Um requisito para usar a estrutura de tratamento de exceção no SQL Server 2005 é habilitar o rolling back automático 
das transações com SET XACT_ABORT ON, senão o roll back será só do comando que causou o erro e não da transação.

Quando uma transação falha, ela entra em um estado conhecido como doomed. A transação continua aberta, mas não pode ser comitada. 
Você deve manualmente dar um roll back na transação que falhou no bloco CATCH usando ROLLBACK TRANSACTION. Essa deve ser uma das 
primeiras declarações no bloco CATCH para liberar recursos da transação assim que possível.

Se for necessário usar a variável @@error, você deve coloca-la na primeira declaração do bloco CATCH. Se quiser guardar um log 
dos erros, terá que armazenar a variável @@error como variável local e fazer o log após declarar ROLLBACK. Se fizer isso antes do ROLLBACK, 
causará roll back das inserções no log também.

Caso precise criar sua própria exceção em um bloco TRY, use a declaração RAISERROR.WITH TRAN_ABORT, que permite fazer uma referência a 
uma mensagem personalizada armazenada na view sys.messages. Essa mensagem é retornada como um erro de Servidor para a aplicação ou para 
o bloco TRY...CATCH 

Sintaxe:*/

BEGIN TRY  
   { sql_statement | statement_block } 
END TRY 
BEGIN CATCH  
   { sql_statement | statement_block } 
END CATCH 

/*Funções de Erros

Existem também algumas funções auxiliares para retornar*/

ERROR_LINE()-- retorna o número da linha que provocou o erro.
ERROR_MESSAGE() --returna a mensagem da aplicação.
ERROR_NUMBER()-- retorna o número do erro.
ERROR_PROCEDURE() --retorna o nome da stored procedure ou trigger onde ocorreu o erro. Esta função retorna NULL se o erro não 
					--ocorre dentro da stored procedure or trigger.
ERROR_SEVERITY() --retorna número do erro considerado sério.
ERROR_STATE() --retorna o estado.

/*
Passo-a-passo para criar corretamente uma estrutura de tratamento de exceções com TRY...CATCH:

Set XACT_ABORT ON 
Criar um bloco TRY ao redor do código que possivelmente causará um erro.
Criar um bloco CATCH imediatamente após o bloco TRY.
Se quiser capturar os erros em uma variável para futuras análises, use a nossa velha conhecida @@error, mas sempre na primeira 
linha do bloco CATCH.ROLLBACK

Exemplo 1 – Criando os blocos TRY...CATCH
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

Exemplo 2 – Uso das funções de Erros

BEGIN TRY
    -- Gera um erro de divisão por ZERO.
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

Exemplo 3 – Guardando o erro em uma tabela para futuras análises

-- Cria-se 2 tabelas, uma de dados e uma de log de erros
CREATE TABLE dbo.tblDados (ColA int PRIMARY KEY, ColB int) 
CREATE TABLE dbo.LogErros (ColA int, ColB int, erro int,  
 date datetime)
GO 

-- Cria uma Procedure para adicionar dados na tabela com tratamento de Erros
-- Repare a função da variável @erro: Ela guarda os erros da variável global
-- @@error e o erro é inserido na tabela LogErros junto com os dados e a data

CREATE PROCEDURE dbo.AdDados @a int, @b int AS 
SET XACT_ABORT ON 
BEGIN TRY 
 BEGIN TRAN 
    INSERT INTO dbo.tblDados VALUES (@a, @b) 

