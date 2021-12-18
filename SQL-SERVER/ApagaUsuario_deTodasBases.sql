declare @min int, @script varchar(max), @usuario varchar(50)

select @usuario = 'BRQ\mnmelo'

select @min = MIN(database_id) from sys.databases

while(@min is not null)
begin

select @script = 'USE ' + name + '

IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'''+ @usuario +''')
DROP USER ['+ @usuario +']'
from sys.databases where database_id = @min

execute( @script)
select @min = MIN(database_id) from sys.databases where database_id > @min
end

IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = @usuario )
	execute ('DROP USER ['+ @usuario +']')


