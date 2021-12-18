/*
exemplo de cursor

*/

drop TABLE #test

CREATE TABLE #test
(
	codfunc INT,
	nomefunc VARCHAR(50)
)

DECLARE @teste VARCHAR(200)

DECLARE perdas CURSOR READ_ONLY FOR       

select cFuncBdsco, ifuncbdsco from tdadofunclfuncrisco

OPEN perdas      
      
DECLARE @codFunc INT, @nomeFunc VARCHAR(50)

FETCH NEXT FROM perdas INTO @codFunc, @nomeFunc
      
 WHILE (@@fetch_status <> -1)      
 BEGIN      
  IF (@@fetch_status <> -2)      
  BEGIN      
      
      
INSERT INTO #test (codfunc,nomefunc)values (@codFunc,@nomeFunc)
  END      
          
      
  FETCH NEXT FROM perdas INTO @codFunc, @nomeFunc
 END      
      
 CLOSE perdas      
 DEALLOCATE perdas

SELECT * FROM #test