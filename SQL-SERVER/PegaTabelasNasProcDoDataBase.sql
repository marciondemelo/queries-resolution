
SELECT TEXT,name FROM syscomments a
INNER JOIN sysobjects b ON a.id = b.id
WHERE xtype = 'P' AND TEXT LIKE '%tProjeto%'

