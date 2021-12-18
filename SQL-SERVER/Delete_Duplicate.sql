/*---- exemplo com CTE (WITH)*/

--cria table de exemplo
CREATE TABLE #TesteDuplicado
(	id int NOT NULL PRIMARY KEY ,	
    nome varchar(50)  NOT NULL,	
    rg  varchar(12) NOT NULL 
)

--inserir registro de exemplo
INSERT INTO #TesteDuplicado VALUES (1,'Fulano de Tal','23.456.789-0')
INSERT INTO #TesteDuplicado VALUES (2,'Fulano de Tal','23.456.789-0')
INSERT INTO #TesteDuplicado VALUES (3,'Fulano de Tal','23.456.789-0')
INSERT INTO #TesteDuplicado VALUES (4,'Cicrano','23.456.789-0')
INSERT INTO #TesteDuplicado VALUES (5,'Cicrano','23.456.789-X')
INSERT INTO #TesteDuplicado VALUES (6,'Cicrano','23.456.789-X')
INSERT INTO #TesteDuplicado VALUES (7,'Cicrano','23.456.789-1')


--aplica o CTE para identificar e apagar os registros.
-- o ponto e virgula no começo é para deixar o script de acordo co o sql200 também.
;WITH Lista(id, nome, rg, ranking)AS
(SELECT	
    id, 
    nome, 
    rg,
    ranking = DENSE_RANK() OVER(PARTITION BY nome, rg ORDER BY id, NEWID() ASC)
FROM [#TesteDuplicado] WITH (NOLOCK)
)

SELECT * FROM Lista WHERE ranking > 1

------------------------------------------------------------------------------

/*---- exemplo sem CTE (WITH)*/
--delete linhas duplicadas

delete from a
from
(select id, nome, rg
       ,ROW_NUMBER() over (partition by nome, rg
                           order by nome, rg
                           ) RowNumber 
from #TesteDuplicado) a
where a.RowNumber > 1


DROP TABLE #TesteDuplicado