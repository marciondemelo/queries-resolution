select 
	tb.name,
	'public '+
	case
		when tb.name like '%varchar%' then 'string'
		when tb.name like 'text' then 'string'
		when tb.name like '%int%' then 'int'
		when tb.name like '%datetime%' then 'DateTime'
		when tb.name like '%bit%' then 'bool'
	else tp.name end+ 
	' '+ cl.name +
	' { get; set; }'
from sys.tables tb
join sys.columns cl on tb.object_id = cl.object_id
join sys.types tp on cl.system_type_id = tp.system_type_id

select
	inf.TABLE_NAME,
	'public '+
	case
		when inf.DATA_TYPE like '%varchar%' then 'string'
		when inf.DATA_TYPE like 'text' then 'string'
		when inf.DATA_TYPE like '%int%' then 'int'
		when inf.DATA_TYPE like 'bit' then 'bool'
		when inf.DATA_TYPE like '%datetime%' then 'DateTime'
	else inf.DATA_TYPE end+ 
	' '+ inf.COLUMN_NAME + 
	' { get; set; }'
from INFORMATION_SCHEMA.COLUMNS inf