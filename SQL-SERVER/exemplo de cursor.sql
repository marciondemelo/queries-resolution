-- UTILIZANDO CURSORES

/*
Hello world! Este � meu primeiro artigo no Linha de C�digo (se � que ser� aprovado). J
Antigamente, na utiliza��o dos arquivos textos e flat files, como o dBase, o acesso aos dados era realizado seq�encialmente. 
Caso o desenvolvedor necessitasse acessar v�rios registros de uma s� vez era necess�ria a utiliza��o de um la�o 
(comando While, por exemplo) para acessar os registros necess�rios.

Com o advento dos novos SGBD�s (em especial o SQL Server) isso n�o � mais necess�rio, pois com o modelo relacional de banco de dados,
 s�o acessados v�rios registros de uma s� vez atrav�s dos comandos SELECT, UPDATE e DELETE. O n�mero de registros retornados depende 
 do tamanho da tabela e da forma com que s�o buscados em conjunto com a cl�usula WHERE, que realiza uma filtragem nos dados selecionados.
Contudo, existem situa��es em que trazer os registros de uma s� vez n�o � conveniente ou poss�vel para realizar certos tipos de opera��es, 
onde � necess�rio obter resultado de cada linha uma a uma. Nestes casos os SGBD�s atuais fornecem um recurso bastante interessante, 
chamado cursor.
O cursor � uma instru��o SELECT  que ser� acessada linha a linha atrav�s de um la�o While e alguns comandos espec�ficos para cursores e 
� utilizado normalmente em procedimentos armazenados (stored procedures).
Ent�o vamos a pr�tica! Para este exemplo ser� utilizado o modelo abaixo, que cont�m uma tabela de clientes, vendas, produtos e itens da venda.

Neste modelo, a venda � gravada juntamente com os seus itens, mas seu estoque n�o � baixado enquanto a venda n�o � finalizada. Ser� criado 
um procedimento armazenado chamado finaliza_vendas, que alterar� o campo situa��o da venda (VenSit) de 0 (aberta) para 1 (finalizada) e 
neste momento ser�o baixados todos os produtos do estoque (tabela produtos, coluna prodqtdest) de acordo com o que foi inserido na tabela 
itens (campo ivqtd).

 

Primeiramente para iniciar a utiliza��o de um cursor � necess�rio definir a instru��o SELECT que ele acessar�. No nosso exemplo, buscar 
todos os itens da venda que deve ser finalizada (vari�vel @VenCod), conforme abaixo.
*/
-- Select utilizado para o cursor

SELECT ProdCod, IVQtd FROM Itens WHERE VenCod = @VenCod

 
/*
� recomendado que voc� execute o SELECT no Query Analyser para verificar se o resultado � o esperado. Ap�s isso, deve ser utilizado 
o comando DECLARE, que serve para declarar vari�veis e o cursor. A vari�vel @VenCod ser� um par�metro do procedimento, logo n�o 
necessita declara��o. Abaixo est� a declara��o do cursor.
*/
 

--Declarando cursor
DECLARE CurItens --Nome do cursor

CURSOR FOR

 

-- Select utilizado para o cursor

SELECT ProdCod, IVQtd FROM Itens WHERE VenCod = @VenCod

 
/*
Realizada a declara��o do cursor � necess�rio realizar a abertura dele buscando o primeiro registro. Para isto ser�o declaradas 
vari�veis que receber�o o c�digo do produto e a quantidade vendida, atrav�s do comando FETCH. O comando FETCH NEXT traz a pr�xima 
linha do SELECT, contudo o comando FETCH pode ser usado em conjunto com outras cl�usulas para outros comportamentos, como o 
FETCH PRIOR (Anterior), FETCH FIRST (Primeiro), FETCH LAST (�ltimo), entre outros.
*/
 

--Declarando vari�veis
DECLARE @ProdCod INTEGER, @IVQtd MONEY

 

--Abrindo cursor

OPEN CurItens

 

--Atribuindo valores do select nas vari�veis

FETCH NEXT FROM CurItens INTO @ProdCod, @IVQtd

 
/*
Este comando definiu os valores da primeira linha de retorno, contudo o cursor � utilizado para acessar v�rias linhas. Para isso 
ser� utilizado um la�o (WHILE) em conjunto com a vari�vel global do SQL Server @@FETCH_STATUS. Esta vari�vel retorna 0 (zero) caso o 
�ltimo comando de FETCH tenha sido executado com sucesso e tenha retornado dados e �1 caso n�o haja mais dados (EOF � fim de arquivo). 
Por fim utilizamos os comandos CLOSE , para fechar o cursor e DEALLOCATE, para elimin�-lo da mem�ria, pois caso o procedimento seja 
executado novamente, pode apresentar erro na declara��o do cursor, caso o cursor ainda exista. O la�o � descrito abaixo:
*/
 

--Iniciando la�o
WHILE @@FETCH_STATUS = 0

BEGIN

 

--Pr�xima linha do cursor

    FETCH NEXT FROM CurItens INTO @ProdCod, @IVQtd

END

 

--Fechando e desalocando cursor

CLOSE CurItens

DEALLOCATE CurItens

 
/*
De posse do c�digo do produto e da quantidade em estoque podemos baixar o estoque na tabela de produtos com o cuidado de n�o deixarmos 
os estoque negativo, o que poderia ser feito atrav�s de uma restri��o de dom�nio (check) na tabela de estoque, entretanto neste exemplo 
utilizaremos uma verifica��o com um SELECT na tabela de estoque. Caso o estoque n�o fique negativo, o comando para baixar o estoque � 
realizado, caso contr�rio ser� levantado um erro com o comando RAISERROR.
*/
 

--Iniciando la�o
WHILE @@FETCH_STATUS = 0

BEGIN

    IF (SELECT ProdQtdEst - @IVQtd FROM Produtos WHERE ProdCod = @ProdCod) >= 0

    UPDATE Produtos

    SET ProdQtdEst = ProdQtdEst - @IVQtd

    WHERE ProdCod = @ProdCod

    ELSE

    RAISERROR(�Estoque insuficiente!�, 15, 1)

--Pr�xima linha do cursor

    FETCH NEXT FROM CurItens INTO @ProdCod, @IVQtd

END

--Fechando e desalocando cursor

CLOSE CurItens

DEALLOCATE CurItens

 
/*
Para finalizar, caso tudo tenha ocorrido com sucesso, devemos finalizar a venda propriamente dita, mudando o campo VenSit de 0 para 1. 
Uma pr�tica muit�ssimo recomendada � trabalhar com transa��o, pois caso um item d� problemas os demais que j� teriam sido baixados 
devem ser retornados. Desta forma o procedimento completo ficaria como descrito abaixo:
*/
 

--Procedimento para finaliza��o de uma venda
CREATE PROCEDURE finaliza_venda (@VenCod INTEGER) AS

 

--Declarando cursor
DECLARE CurItens --Nome do cursor
CURSOR FOR

-- Select utilizado para o cursor
SELECT ProdCod, IVQtd FROM Itens WHERE VenCod = @VenCod

--Declarando vari�veis
DECLARE @ProdCod INTEGER, @IVQtd MONEY

--Iniciando transa��o
BEGIN TRANSACTION

 

--Abrindo cursor
OPEN CurItens
--Atribuindo valores do select nas vari�veis
FETCH NEXT FROM CurItens INTO @ProdCod, @IVQtd

--Iniciando la�o
WHILE @@FETCH_STATUS = 0
BEGIN

    IF (SELECT ProdQtdEst - @IVQtd FROM Produtos WHERE ProdCod = @ProdCod) >= 0
        UPDATE Produtos
        SET ProdQtdEst = ProdQtdEst - @IVQtd
        WHERE ProdCod = @ProdCod
    ELSE
    BEGIN

    --Desfazendo o que foi realizado anteriormente
        ROLLBACK TRANSACTION
    --Levantando erro
        RAISERROR(�Estoque insuficiente!�, 15, 1)
    --Fechando e desalocando cursor aqui tamb�m, pois o return sair� do procedimento
        CLOSE CurItens
        DEALLOCATE CurItens
    --Saindo do procedimento
        RETURN

    END
 
--Pr�xima linha do cursor
    FETCH NEXT FROM CurItens INTO @ProdCod, @IVQtd
END

--Fechando e desalocando cursor
CLOSE CurItens
DEALLOCATE CurItens

--Caso tudo tenha ocorrido OK, alterando a situa��o da venda
UPDATE Vendas
SET VenSit = 1
WHERE VenCod = @VenCod

--Confirmando transa��o
COMMIT TRANSACTION
 
/*
Bom pessoal, por hora � isso. Espero que o artigo seja aceito e que eu posso escrever mais por aqui. Um grande abra�o!
*/