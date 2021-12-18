--select * from tEventoTipo where CodEventoTipoPai is null


With TpEventoCTE (cTpoEvntoX,vNvel,iTpoEvnto)AS 
(
	Select cTpoEvnto,CAST(1 AS int),cast(iTpoEvnto as varchar(max)) From tEventoTipo
	where CodEventoTipoPai is null
	union all
	Select  ET.cTpoEvnto,cast(ET.vNvel as int),cast(space((ET.vNvel)*5)+ET.iTpoEvnto as varchar(max)) From tEventoTipo ET
	inner join TpEventoCTE CTE on ET.CodEventoTipoPai = cTpoEvntoX
)

select * from TpEventoCTE
order by cTpoEvntoX

