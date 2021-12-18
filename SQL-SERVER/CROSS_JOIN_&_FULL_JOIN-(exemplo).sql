/* criação da tabela #produto */
create table #produto
(
cod_produto int primary key,
descr_produto varchar (20)
)

/* criação da tabela #venda.*/
go
create table #venda
( 
id_venda int identity primary key,
cod_produto int ,
qtde int,
vlr_unit dec(9,2)
)

/* populando a tabela #produto */
go
insert into #produto values (101001,'Livro-1')
insert into #produto values (101002,'Livro-2')
insert into #produto values (101003,'Livro-3')
insert into #produto values (101004,'Livro-4')
insert into #produto values (101005,'Livro-5')

/* populando a tabela #venda */
go
insert into #venda (cod_produto,qtde,vlr_unit)  values (101001,2,14.00)
insert into #venda (cod_produto,qtde,vlr_unit)  values
(101002,1,20.50)
insert into #venda (cod_produto,qtde,vlr_unit)  values
(101003,4,12.00)
insert into #venda (cod_produto,qtde,vlr_unit)  values (101030,6,
8.00)
insert into #venda (cod_produto,qtde,vlr_unit)  values
(101031,1,44.00)


/*o outer no join não afeta em nada no resultado nas bases mais novas, mas ele não pode ser usado no cross join*/

go
select produtos_vendidos_com_cadastro = p.cod_produto 
from #produto p 
inner join 
    #venda v 
on p.cod_produto = v.cod_produto 




select produtos_vendidos_sem_cadastro = v.cod_produto
from #produto p 
right outer join 
      #venda v 
on v.cod_produto = p.cod_produto 
where p.cod_produto IS NULL 



select produtos_com_cadastro_sem_venda = p.cod_produto
from #produto p
left outer join
      #venda v
on v.cod_produto = p.cod_produto
where v.cod_produto IS NULL



select produto        = case when p.cod_produto    is     null
                                          then v.cod_produto
                                          else p.cod_produto
                                 end, 
          descricao    = case when p.descr_produto is NOT null 
                                          then p.descr_produto 
                                          else 'sem cadastro' 
                                 end, 
          observacao = case when p.cod_produto    is NOT null  and v.cod_produto    is NOT null
then 'venda com cadastro' 
                                          when p.cod_produto    is NOT null  and v.cod_produto    is  null 
                                         then 'produto com cadastro sem venda' 
                                         else 'produto sem cadastro com venda'
                                 end
from #produto p 
full outer join 
     #venda v 
on p.cod_produto = v.cod_produto 




select *
from #produto p 
full outer join 
     #venda v 
on p.cod_produto = v.cod_produto 

go
/* criação da tabela #uf */ 
create table #uf ( sigla char(2)) 
go
insert into #uf values ('SP') 
insert into #uf values ('RJ')
go

/* select com o #produto Cartesiano entre a tabela #produto e #uf */ 
select * 
from #produto 
cross join #uf 

go
drop table #produto
drop table #venda
drop table #uf