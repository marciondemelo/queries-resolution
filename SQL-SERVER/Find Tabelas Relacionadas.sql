DECLARE @Foreinkeys VARCHAR(250), @TabelaAlimenta VARCHAR(250), @TabelaConsome VARCHAR(250)

SELECT @Foreinkeys = NULL
,@TabelaAlimenta = 'TCPOOCOR'
,@TabelaConsome = NULL
---
SELECT fk.name Foreinkeys, ob.name TabelasRealcionadas, obref.name tabela FROM SYS.foreign_keys FK
JOIN sys.objects obref ON FK.referenced_object_id = obref.object_id
JOIN sys.objects ob ON FK.parent_object_id = ob.object_id
WHERE 
    (@Foreinkeys IS NULL OR fk.name = @Foreinkeys)
AND (@TabelaAlimenta IS NULL OR obref.name = @TabelaAlimenta)
AND (@TabelaConsome IS NULL OR ob.name = @TabelaConsome)

