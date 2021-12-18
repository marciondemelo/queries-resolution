INSERT INTO OPENROWSET('Microsoft.Jet.OLEDB.4.0', 
'Excel 8.0;Database=C:\teste.xls;', 
'SELECT CodControlObjective FROM [Sheet1$]') 
SELECT CodControlObjective FROM dbo.CL_ControlObjective
GO