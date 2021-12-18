/*
Merge com SQL Server 2008 
 
Publicado em: 23/01/2008 
 
Uma das grandes novidades do SQL Server 2008 é a facilidade para mesclar dados utilizando o conceito de MERGE. 
Esta operação permite recuperar dados de uma origem e realizar diversas ações baseadas nos resultados de JOIN 
(junção) entre a origem e o destino. O MERGE aumenta consideravelmente o desempenho na utilização de INSERT, 
UPDATE e DELETE em casos específicos. 
 
A criação de uma condição MERGE é relativamente simples, no melhor caso são apenas quatro passos para sua composição. 

1.MERGE: Especifica os dados de destino da operação definida na clausula WHEN;
2.USING: Especificam os dados de origem que serão comparados com os dados de destino, definido na clausula MERGE;
3.ON: Encontra os dados em evidência, interligando as condições de origem e destino;
4.WHEN: Aumenta a granularidade do filtro, incrementando a clausula ON.
Com alguns exemplos na prática, este recurso fica mais simples de ser entendido e implementando. 

Imagine o seguinte cenário: Em uma rede de lojas, foram criadas tabelas com nomes diferentes, mas com a mesma 
estrutura. Cada tabela armazena os produtos que tem em sua loja (a tabela tblLoja1 armazena os produtos da Loja 1, 
e a tabela tblLoja2 armazena os produtos da Loja 2). Em um determinado momento, o dono da rede de lojas solicita que seja 
feita uma centralização dos dados, para a criação de uma aplicação Web. 

Com base neste cenário, criamos e populamos as duas tabelas de produtos das lojas. 

*/


CREATE TABLE #tbILoja1
(
lojCodigo int
,proCodigo int
,proDescricao varchar(10)
)

CREATE TABLE #tbILoja2
(
lojCodigo int
,proCodigo int
,proDescricao varchar(10)
)

CREATE TABLE #tbILojas
(
lojCodigo int
,proCodigo int
,proDescricao varchar(10)
)
go
	/*popula tabela 1*/
		
		DECLARE @cont1 int
		set @cont1 = 1

		WHILE (@cont1 < = 20)
		begin
			insert into #tbIloja1
			values(1, @cont1, 'Loja 1')
			set @cont1 = @cont1 + 1
		end
		
	/*fim popula tabela 1*/
go	
/*xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*/
	
	/*popula tabela 2*/

		DECLARE @cont2 int, @cod int
		set @cont2 = 1
		set @cod = 1
		WHILE (@cont2 < = 20)
		begin
		
			if(@cont2 <= 20 and @cont2 >= 15)
				insert into #tbILoja2 values(1, @cont2, 'Loja 2')
			else
				insert into #tbILoja2 values(2, @cont2, 'Loja 2')
			set @cont2 = @cont2 + 1
		end
		
	/*fim popula tabela 1*/
	
/*

Depois de criar e inserir alguns registros em cada uma das duas tabelas separadas das Lojas, 
vamos criar a tabela tblLojas. Repare que a estrutura das 3 tabelas são iguais, isso não é uma regra,
 é só para simplificar o exemplo. Poderiam ser diferentes, sem problema algum. 

Finalmente chegamos ao ponto onde utilizaremos o MERGE para colocar todas as informações na tabela 
tblLojas, baseada nas tabelas tblLoja1 e tblLoja2. 

No primeiro exemplo de MERGE, utilizaremos a tabela tblLojas como sendo o destino dos dados e a tabela 
tblLojas1 como sendo a origem. Faremos a ligação das duas tabelas nos baseando na coluna proCodigo [terceira linha]. 
Quando a clausula ON for satisfatório (verdadeira), o processamento executará o bloco definido em MATCHED, 
para resultados cuja clausula ON seja negativa, o SQL Server 2008 executará o bloco NOT MATCHED. 


*/

go
/*MERGE DE DADOS*/

	MERGE #tbILojas des
	USING #tbILoja1 ori
	on ori.proCodigo = des.proCodigo
	WHEN NOT MATCHED THEN
		INSERT values(ori.lojCodigo,ori.proCodigo,ori.proDescricao)
	WHEN MATCHED THEN
		UPDATE SET des.lojCodigo = ori.lojCodigo;
		
/*FIM MERGE 1*/
go
/*
Neste momento, como a tabela tblLojas ainda está vazia, somente o bloco NOT MATCHED (que insere os valores) será executado. 

Consultando a tabela tblLojas, os dados estão idênticos à tabela tblLoja1.
*/

/*MERGE DE DADOS*/

	MERGE #tbILojas des
	USING #tbILoja2 ori
	on ori.proCodigo = des.proCodigo and ori.lojCodigo = des.lojCodigo
	WHEN MATCHED THEN
		UPDATE SET des.proDescricao = 'AmbasLojas'
	WHEN NOT MATCHED THEN
		INSERT VALUES(ori.lojCodigo,ori.proCodigo,ori.proDescricao);
		
/*FIM MERGE 1*/
/*
Agora, para executar o MERGE da tabela tblLoja2 com a tabela tblLojas, criamos o segundo exemplo de código que é muito parecido 
com o primeiro, a não ser pela tabela utilizada como origem dos dados e pelos processamentos que serão executados com base no 
resultado da clausula ON. 

Agora, depois de executar esse código que, quando encontra proCodigo que existe na tabela tblLojas e também existem na tabela 
tblLoja2, atualiza a proDescricao para 'AmbasLojas', consultar a tabela tblLojas, conseguimos ver com clareza que alguns dados 
foram inseridos e outros dados atualizados. 

*/
go

SELECT * FROM #tbILojas

/*

Na hora que populamos as tabelas das lojas, os produtos de código 15 a 20 se repetiram propositalmente, para forçar esta 
igualdade de dados, e como está no exemplo, atualizar a tabela destino. 

Concluímos que utilizar o MERGE é mais rápido e simples do que escrever código para fazer uma junção de dados de duas tabelas. 
Esta nova funcionalidade deve ser utilizada sempre que possível. Ela é muito mais performática do que criar um procedimento 
fazendo as verificações manualmente.

*/
go

drop table #tbILojas
drop table #tbILoja1
drop table #tbILoja2