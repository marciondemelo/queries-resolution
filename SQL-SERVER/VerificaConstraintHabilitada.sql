declare @Table varchar(200), @Constraint varchar(300)
select @Table = null, 
@Constraint = null

select 
     [Table]     = Tabela.name, 
     [Constraint] = Const.name, 
     [Enabled]   = case when ((ConstInfo.Status & 0x4000)) = 0 then 1 else 0 end
from sys.sysconstraints ConstInfo
     inner join sys.sysobjects Const on  Const.id = ConstInfo.constid -- and o.xtype='F'
     inner join sys.sysobjects Tabela on Tabela.id = Const.parent_obj
where (@table is null or tabela.name like '%'+@table+'%')
	and (@Constraint is null or Const.name like '%'+@Constraint+'%')