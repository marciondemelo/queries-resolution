/*
Removendo registros duplicados no SQL Server 
Finalidade: Remover registros de banco de dados duplicados
Tipo: script
Linguagem: SQL
Conhecimento: B�sico.

Muitos j� devem ter se deparado com o cl�ssico problema de registros duplicados no banco. Isso porque o banco foi mal modelado ou porque os pr�prios dados favoreceram essa situa��o. Muitas vezes, limpra os registros duplicados do banco pode ser uma tarefa complicada dependendo da tabela e dos valores (imagem valores exatamente iguais em todas as colunas por exemplo, qual excluir?). J� vi por ai algor�tmos mirabolantes, como um cursor que varre toda a tabela, copia linha por linha para uma outra tabela tempor�ria verificando se os dados j� n�o est�o la! E outros que nem vou citar. Bem, o SQL Server permite fazer isso muito facilmente. Podemos "rankear" os registros, geram um valor para cada linha duplicada, ai � s� agrupar os valores e ver quem foi rankeado maior que 1 (um), ou seja, foi encontrado mais de uma linha. Para isso vamos usar DENSE_RANK() OVER(PARTITION BY <colunas>). Isso vai agrupar os registros (ou tuplas para os mais puristas) e geram um valor que vai rankear registros iguais, quer dizer, que tem valor id�nticos nas colunas informadas.
Para exemplificar vamos cricar uma tabela simples com tr�s colunas: id, nome e rg, onde id ser� unique, mas nome e rg poder�o e ser�o duplicados:
*/

CREATE TABLE TesteDuplicado
(	id int NOT NULL,	
    nome varchar(50)  NOT NULL,	
    rg  varchar(12) NOT NULL,    
CONSTRAINT [PK_TesteDuplicado] PRIMARY KEY CLUSTERED     (		id ASC    )
)
--Agora vamos inserir algumas linhas. Repare que os registros com id 2,3, e 6 est�o duplicados:


INSERT INTO TesteDuplicado VALUES (1,'Fulano de Tal','23.456.789-0')
INSERT INTO TesteDuplicado VALUES (2,'Fulano de Tal','23.456.789-0')
INSERT INTO TesteDuplicado VALUES (3,'Fulano de Tal','23.456.789-0')
INSERT INTO TesteDuplicado VALUES (4,'Cicrano','23.456.789-0')
INSERT INTO TesteDuplicado VALUES (5,'Cicrano','23.456.789-X')
INSERT INTO TesteDuplicado VALUES (6,'Cicrano','23.456.789-X')
INSERT INTO TesteDuplicado VALUES (7,'Cicrano','23.456.789-1')
--Execute um SELECT e veja se est� tudo l�.

--Agora vamos ao nosso bloco de script que ir� ober os duplicados:

-- o ponto e virgula no come�o, serve para garantir que o comando funcionar� nas vers�es 2005 e 2000
;WITH Lista(id, nome, rg, ranking)AS
(
    SELECT	
        id, 
        nome, 
        rg,
        ranking = DENSE_RANK() OVER(PARTITION BY nome, rg ORDER BY id, NEWID() ASC)
    FROM [TesteDuplicado] WITH (NOLOCK)
)
SELECT * FROM ListaWHERE ranking > 1

/*Conseguiram entender?
Vamos l�: na primeira linha repare que ela come�a com um ponto-e-v�rgula (;), isso para manter compatibilidade com o SQL Server 2000 e 2005. Em seguida, � declarado o resultset que iremos usar, com id, nome, rg e ranking.
As linhas 2, 3, 4 e 5 s�o simples declara��o do SELECT.
Na linha 6 declaramos o valor de ranking. Ele ser� obtido atrav�s da fun��o DENSE_RANK(), que ser� obtido rankeando os valores das colunas nome e rg, ordenado por id e NEWID() para gerar um novo valor qualquer apenas para diferenciar as linhas duplicadas
Ap�s isso, as linhas 9 e 10 mostram os registros que tem ranking maior que 1 (um), ou seja, que est�o duplicados.
Se remover a cl�usula WHERE, trar� todos os registros rankeados.
Executando o script, o resultado ser�:

id nome             rg            ranking 
9  Cicrano          23.456.789-X    2 
2  Fulano de Tal    23.456.789-0    2 
3  Fulano de Tal    23.456.789-0    3 

F�cil n�o �? Agora basta substituir o SELECT final por um DELETE e pronto. 
Voc� pode adaptar esse script para qualquer tabela, bastando incluir no OVER do seu ranking as colunas que ter�o os valores duplicados
*/