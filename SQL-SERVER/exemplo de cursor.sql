-- UTILIZANDO CURSORES

/*
Hello world! Este é meu primeiro artigo no Linha de Código (se é que será aprovado). J
Antigamente, na utilização dos arquivos textos e flat files, como o dBase, o acesso aos dados era realizado seqüencialmente. 
Caso o desenvolvedor necessitasse acessar vários registros de uma só vez era necessária a utilização de um laço 
(comando While, por exemplo) para acessar os registros necessários.

Com o advento dos novos SGBD’s (em especial o SQL Server) isso não é mais necessário, pois com o modelo relacional de banco de dados,
 são acessados vários registros de uma só vez através dos comandos SELECT, UPDATE e DELETE. O número de registros retornados depende 
 do tamanho da tabela e da forma com que são buscados em conjunto com a cláusula WHERE, que realiza uma filtragem nos dados selecionados.
Contudo, existem situações em que trazer os registros de uma só vez não é conveniente ou possível para realizar certos tipos de operações, 
onde é necessário obter resultado de cada linha uma a uma. Nestes casos os SGBD’s atuais fornecem um recurso bastante interessante, 
chamado cursor.
O cursor é uma instrução SELECT  que será acessada linha a linha através de um laço While e alguns comandos específicos para cursores e 
é utilizado normalmente em procedimentos armazenados (stored procedures).
Então vamos a prática! Para este exemplo será utilizado o modelo abaixo, que contém uma tabela de clientes, vendas, produtos e itens da venda.

Neste modelo, a venda é gravada juntamente com os seus itens, mas seu estoque não é baixado enquanto a venda não é finalizada. Será criado 
um procedimento armazenado chamado finaliza_vendas, que alterará o campo situação da venda (VenSit) de 0 (aberta) para 1 (finalizada) e 
neste momento serão baixados todos os produtos do estoque (tabela produtos, coluna prodqtdest) de acordo com o que foi inserido na tabela 
itens (campo ivqtd).

 

Primeiramente para iniciar a utilização de um cursor é necessário definir a instrução SELECT que ele acessará. No nosso exemplo, buscar 
todos os itens da venda que deve ser finalizada (variável @VenCod), conforme abaixo.
*/
-- Select utilizado para o cursor

SELECT ProdCod, IVQtd FROM Itens WHERE VenCod = @VenCod

 
/*
É recomendado que você execute o SELECT no Query Analyser para verificar se o resultado é o esperado. Após isso, deve ser utilizado 
o comando DECLARE, que serve para declarar variáveis e o cursor. A variável @VenCod será um parâmetro do procedimento, logo não 
necessita declaração. Abaixo está a declaração do cursor.
*/
 

--Declarando cursor
DECLARE CurItens --Nome do cursor

CURSOR FOR

 

-- Select utilizado para o cursor

SELECT ProdCod, IVQtd FROM Itens WHERE VenCod = @VenCod

 
/*
Realizada a declaração do cursor é necessário realizar a abertura dele buscando o primeiro registro. Para isto serão declaradas 
variáveis que receberão o código do produto e a quantidade vendida, através do comando FETCH. O comando FETCH NEXT traz a próxima 
linha do SELECT, contudo o comando FETCH pode ser usado em conjunto com outras cláusulas para outros comportamentos, como o 
FETCH PRIOR (Anterior), FETCH FIRST (Primeiro), FETCH LAST (Último), entre outros.
*/
 

--Declarando variáveis
DECLARE @ProdCod INTEGER, @IVQtd MONEY

 

--Abrindo cursor

OPEN CurItens

 

--Atribuindo valores do select nas variáveis

FETCH NEXT FROM CurItens INTO @ProdCod, @IVQtd

 
/*
Este comando definiu os valores da primeira linha de retorno, contudo o cursor é utilizado para acessar várias linhas. Para isso 
será utilizado um laço (WHILE) em conjunto com a variável global do SQL Server @@FETCH_STATUS. Esta variável retorna 0 (zero) caso o 
último comando de FETCH tenha sido executado com sucesso e tenha retornado dados e –1 caso não haja mais dados (EOF – fim de arquivo). 
Por fim utilizamos os comandos CLOSE , para fechar o cursor e DEALLOCATE, para eliminá-lo da memória, pois caso o procedimento seja 
executado novamente, pode apresentar erro na declaração do cursor, caso o cursor ainda exista. O laço é descrito abaixo:
*/
 

--Iniciando laço
WHILE @@FETCH_STATUS = 0

BEGIN

 

--Próxima linha do cursor

    FETCH NEXT FROM CurItens INTO @ProdCod, @IVQtd

END

 

--Fechando e desalocando cursor

CLOSE CurItens

DEALLOCATE CurItens

 
/*
De posse do código do produto e da quantidade em estoque podemos baixar o estoque na tabela de produtos com o cuidado de não deixarmos 
os estoque negativo, o que poderia ser feito através de uma restrição de domínio (check) na tabela de estoque, entretanto neste exemplo 
utilizaremos uma verificação com um SELECT na tabela de estoque. Caso o estoque não fique negativo, o comando para baixar o estoque é 
realizado, caso contrário será levantado um erro com o comando RAISERROR.
*/
 

--Iniciando laço
WHILE @@FETCH_STATUS = 0

BEGIN

    IF (SELECT ProdQtdEst - @IVQtd FROM Produtos WHERE ProdCod = @ProdCod) >= 0

    UPDATE Produtos

    SET ProdQtdEst = ProdQtdEst - @IVQtd

    WHERE ProdCod = @ProdCod

    ELSE

    RAISERROR(‘Estoque insuficiente!’, 15, 1)

--Próxima linha do cursor

    FETCH NEXT FROM CurItens INTO @ProdCod, @IVQtd

END

--Fechando e desalocando cursor

CLOSE CurItens

DEALLOCATE CurItens

 
/*
Para finalizar, caso tudo tenha ocorrido com sucesso, devemos finalizar a venda propriamente dita, mudando o campo VenSit de 0 para 1. 
Uma prática muitíssimo recomendada é trabalhar com transação, pois caso um item dê problemas os demais que já teriam sido baixados 
devem ser retornados. Desta forma o procedimento completo ficaria como descrito abaixo:
*/
 

--Procedimento para finalização de uma venda
CREATE PROCEDURE finaliza_venda (@VenCod INTEGER) AS

 

--Declarando cursor
DECLARE CurItens --Nome do cursor
CURSOR FOR

-- Select utilizado para o cursor
SELECT ProdCod, IVQtd FROM Itens WHERE VenCod = @VenCod

--Declarando variáveis
DECLARE @ProdCod INTEGER, @IVQtd MONEY

--Iniciando transação
BEGIN TRANSACTION

 

--Abrindo cursor
OPEN CurItens
--Atribuindo valores do select nas variáveis
FETCH NEXT FROM CurItens INTO @ProdCod, @IVQtd

--Iniciando laço
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
        RAISERROR(‘Estoque insuficiente!’, 15, 1)
    --Fechando e desalocando cursor aqui também, pois o return sairá do procedimento
        CLOSE CurItens
        DEALLOCATE CurItens
    --Saindo do procedimento
        RETURN

    END
 
--Próxima linha do cursor
    FETCH NEXT FROM CurItens INTO @ProdCod, @IVQtd
END

--Fechando e desalocando cursor
CLOSE CurItens
DEALLOCATE CurItens

--Caso tudo tenha ocorrido OK, alterando a situação da venda
UPDATE Vendas
SET VenSit = 1
WHERE VenCod = @VenCod

--Confirmando transação
COMMIT TRANSACTION
 
/*
Bom pessoal, por hora é isso. Espero que o artigo seja aceito e que eu posso escrever mais por aqui. Um grande abraço!
*/