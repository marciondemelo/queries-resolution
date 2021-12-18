/*
PRESSIONE F5 PARA CRIAR E POPULAR A TABELA 
DEPOIS VÁ ATÉ O FINAL DA QUERY E DESCOMENTE
O UPDATE PARA FAZER O TESTE.
*/

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
go
SELECT * INTO #VendasErr FROM #Vendas
go
UPDATE #VendasErr 
SET valor = 1
GO

SELECT * FROM #VendasErr 

/*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   EXEMPLO DE UPDATE  COM SELECT
descomente o update a baixo para fazer o teste.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/

--UPDATE #VendasErr 
--SET VALOR= b.valor
--FROM #VendasErr a INNER JOIN #Vendas b ON a.tipoProd = b.tipoProd AND a.produto = b.produto AND a.codVenda = b.codVenda















