CREATE TABLE #proc (procedures VARCHAR(100) )

INSERT INTO #proc VALUES('SPR_BCP_OpcaoEstrategia_S')
INSERT INTO #proc VALUES('spr_BCP_Funcionarios_List')
INSERT INTO #proc VALUES('spr_BCP_SubProcessos_List6')
INSERT INTO #proc VALUES('spr_BCP_SubProcessos_List4')

INSERT INTO #proc VALUES('SPR_BCP_CategoriaImpacto_S')
INSERT INTO #proc VALUES('spr_BCP_CategoriaImpacto_U')
INSERT INTO #proc VALUES('spr_BCP_CategoriaRecurso_S')
INSERT INTO #proc VALUES('spr_BCP_EventoRuptura_S')
INSERT INTO #proc VALUES('spr_BCP_FaixaTempo_S')
INSERT INTO #proc VALUES('SPR_BCP_OpcaoEstrategia_S')
INSERT INTO #proc VALUES('SPR_BCP_PeriodoPico_S')
INSERT INTO #proc VALUES('SPR_BCP_Probabilidade_S')
INSERT INTO #proc VALUES('spr_BCP_TempoImpacto_S')
INSERT INTO #proc VALUES('SPR_BCP_TipoCusto_S')
INSERT INTO #proc VALUES('SPR_BCP_TipoEstrategia_S')
INSERT INTO #proc VALUES('spr_BCP_TipoRecurso_S')



SELECT ROW_NUMBER() OVER (ORDER BY PROCedures) AS numLine, PROCedures FROM #proc

SELECT IDENTITY(INT,1,1) AS numLine, PROCedures INTO #newTable FROM #proc
SELECT * FROM #newTable 


DROP TABLE #proc
DROP TABLE #newTable 