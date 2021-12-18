create table #Vendas
(
	codVenda int identity(1,1),
	produto varchar(20),
	tipoProd int,
	valor decimal(10,2)
)
go
--lapis
insert into #vendas values('lapis',1,0.9)
insert into #vendas values('lapis',1,0.9)
insert into #vendas values('lapis',1,1.5)
insert into #vendas values('lapis',1,0.7)
insert into #vendas values('lapis',1,0.7)
insert into #vendas values('lapis',1,1)

-- caderno
insert into #vendas values('Caderno',1,9)
insert into #vendas values('Caderno',1,5.8)
insert into #vendas values('Caderno',1,8.8)

--borracha
insert into #vendas values('borracha',1,0.55)
insert into #vendas values('borracha',1,0.55)
insert into #vendas values('borracha',1,70)
insert into #vendas values('borracha',1,0.55)

--caneta
insert into #vendas values('caneta',1,1.5)
insert into #vendas values('caneta',1,2)
insert into #vendas values('caneta',1,4.30)

--tenis
insert into #vendas values('tenis',2,60)
insert into #vendas values('tenis',2,100)
insert into #vendas values('tenis',2,100)
insert into #vendas values('tenis',2,60)

--Blusa
insert into #vendas values('Blusa',2,70)
insert into #vendas values('Blusa',2,90)
insert into #vendas values('Blusa',2,85)

-- calcula qtd, valor total e media, de modo geral ou por produto
select produto , valor from #Vendas
where valor >= 2
order by tipoprod
compute count(produto)
,sum(valor)
,avg(valor) 
,MAX(valor) 
,MIN(valor) 
,STDEV(valor) 
,STDEVP(valor) 
,VAR(valor) 
,VARP(valor) 
-- este by a baixo define se vai ser feito agrupando por produto sem ele 
-- os calculos são feitos de modo geral
by tipoprod;

GO


/* delete tabela de exemplo*/
--   DROP TABLE #VENDAS

/*
AVG
 Média dos valores na expressão numérica
 
COUNT
 Número de linhas selecionadas
 
MAX
 Valor mais alto na expressão
 
MIN
 Valor mais baixo na expressão
 
STDEV
 Desvio padrão estatístico para todos os valores da expressão
 
STDEVP
 Desvio padrão estatístico para a população de todos os valores da expressão
 
SUM
 Total dos valores na expressão numérica
 
VAR
 Variação estatística para todos os valores da expressão
 
VARP
 Variação estatística para a população de todos os valores da expressão
 
*/