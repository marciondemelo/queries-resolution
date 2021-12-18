RESTORE FILELISTONLY
FROM DISK = 'c:\bkp_sa_ld_integrado_vm.bak'


RESTORE DATABASE testejunior
FROM DISK = 'c:\bkp_sa_ld_integrado_vm.bak'
WITH MOVE 'SA_LD_Integrado2' TO 'C:\Program Files\Microsoft SQL Server\MSSQL.2\MSSQL\Data\SA_LD_Integrado2.mdf',
MOVE 'SA_LD_Integrado2_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL.2\MSSQL\Data\SA_LD_Integrado2.ldf'