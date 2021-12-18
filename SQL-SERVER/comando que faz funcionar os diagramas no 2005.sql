/*-/////xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx////
comando utilizado para mudar a compatibilidade do sql 2005 para sql 200
O resultado deste comando faz com que possa utilizar diagramas de uma base
2005 que é resultado de um restore de uma base 2000
sucesso
obs.: esse procedimento é feito atraves das propriedades da base mudando a opção
de compatibilidade porem inesplicavelmente quando não funciona mudando as ópções
funciona executando comando a baixo
/////xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx////-*/

EXEC sp_dbcmptlevel 'roci_producao', '90';
go 
ALTER AUTHORIZATION ON DATABASE::roci_producao TO "mnmelo"
go 
use roci_producao
go 
EXECUTE AS USER = N'dbo' REVERT 
go