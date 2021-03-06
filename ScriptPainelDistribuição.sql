/**************************
 Indicadores IASC - Anual
***************************/
SELECT
	i1.[Ano]
	,agt.Sigla_SMA
	,i1.[OrdemIASC] as Rnk
	,(
		select
			count(i4.IdAgente)
		FROM
			[SMA_SAS].[dbo].[IASC_EXCEL] as i4
		where
			i4.Ano=i1.Ano and i4.Classificacao=i1.Classificacao and i4.IdAgente>'16'
	) as RnkGeral
    ,i1.[IdAgente]
    ,i1.[I_SATISF] as NotaIASC
	,(
		select
			i2.[I_SATISF] 
		FROM
			[SMA_SAS].[dbo].[IASC_EXCEL] as i2 
		where
			i2.Ano=i1.Ano-1 and i2.IdAgente=i1.IdAgente
	) as NotaIASCAnterior
	,(
		select
			(i1.[I_SATISF]-i3.[I_SATISF])/i3.[I_SATISF]*100 
		FROM
			[SMA_SAS].[dbo].[IASC_EXCEL] as i3 
		where
			i3.Ano=i1.Ano-1 and i3.IdAgente=i1.IdAgente
	) as Variacao
FROM
	[SMA_SAS].[dbo].[IASC_EXCEL] as i1
	left join [SMA_SAS].[dbo].[SMA01_IdAgente] agt on agt.IdAgente_SMA=i1.IdAgente
where
	Ano='2019'
	--and agt.IdAgente_SMA='5707'
order by
	agt.Sigla_SMA

/**************************
 Indicadores SGO - 12 meses
***************************/
declare @dataInicial as datetime,
        @dataFinal as datetime,
		@UCs as int

    SET @dataInicial = CAST(getdate()-366 as date) ;
    SET @dataFinal = CAST(getdate()-1 as date);


/**************************
 Indicadores OUVIDORIA - 12 meses
***************************/
select
	rs.IdeAgt
	,agt.Sigla_SMA
	,(
		SUM (rs.QtdRcaRcb)/
		(
			SELECT 
				top 1 samp.NumeroConsumidores
			FROM
				[SMA_SAS].[dbo].[SGO_SAMP_NUMCONS_MENSAL] as samp
			WHERE
				samp.IdAgente=rs.IdeAgt
				and (samp.NumeroConsumidores)>=1
			order by samp.Ano desc,samp.Mes desc
		) * 10000
	) AS QRT
	,(Rank() over(partition by rs.idersl order by SUM (rs.QtdRcaRcb) desc)) as Rnk
	,SUM (rs.QtdRcaRcb) as QTD
	,SUM (rs.QtdRcaPcd) as Procedentes
from 
	BDC.DBO.ouv_resolucao382 as rs
	left join [SMA_SAS].[dbo].[SMA01_IdAgente] agt on agt.IdAgente_SMA=rs.ideagt
where
	rs.IdeRsl='4'			
	and rs.DatRefRca between @dataInicial and @dataFinal
group by
	rs.IdeAgt,agt.Sigla_SMA,rs.idersl
order by Rnk



/**************************
 Indicadores CTA - 12 meses
***************************/
select
	rs.IdeAgt
	,agt.Sigla_SMA
	,(
		SUM (rs.QtdRcaRcb)/
		(
			SELECT 
				top 1 samp.NumeroConsumidores
			FROM
				[SMA_SAS].[dbo].[SGO_SAMP_NUMCONS_MENSAL] as samp
			WHERE
				samp.IdAgente=rs.IdeAgt
				and (samp.NumeroConsumidores)>=1
			order by samp.Ano desc,samp.Mes desc
		) * 10000
	) AS QRT
	,(Rank() over(partition by rs.idersl order by SUM (rs.QtdRcaRcb) desc)) as Rnk
	,SUM (rs.QtdRcaRcb) as QTD
	,SUM (rs.QtdRcaPcd) as Procedentes
from 
	BDC.DBO.ouv_resolucao382 as rs
	left join [SMA_SAS].[dbo].[SMA01_IdAgente] agt on agt.IdAgente_SMA=rs.ideagt
where
	rs.IdeRsl='2'			
	and rs.DatRefRca between @dataInicial and @dataFinal
group by
	rs.IdeAgt,agt.Sigla_SMA,rs.idersl
order by Rnk


/**************************
 Indicadores SGO - 12 meses
***************************/
select
	sa.IdAgente,sa.Sigla
	,(
			select
				top 1 samp.NumeroConsumidores
			FROM
				[SMA_SAS].[dbo].[SGO_SAMP_NUMCONS_MENSAL] as samp
			WHERE
				samp.IdAgente=sa.IdAgente
				and (samp.NumeroConsumidores)>=1
			order by samp.Ano desc,samp.Mes desc
	) QtdUCs
	,(
		count(sa.Numero_da_Solicitacao)/
		(
			SELECT 
				top 1 samp.NumeroConsumidores
			FROM
				[SMA_SAS].[dbo].[SGO_SAMP_NUMCONS_MENSAL] as samp
			WHERE
				samp.IdAgente=sa.IdAgente
				and (samp.NumeroConsumidores)>=1
			order by samp.Ano desc,samp.Mes desc
		) * 10000
	) AS QRT
	,(Rank() over(partition by sa.Categoria order by count(sa.Numero_da_Solicitacao) desc)) as Rnk
	,avg(sa.Prazo) as PrazoResposta
	,count(sa.Numero_da_Solicitacao) as QTD
from
	SMA_SAS.dbo.SMA_Analytics as sa
where
	sa.Categoria='Reclamações'
	and cast(sa.Data_Criacao as date) between @dataInicial and @dataFinal
group by
	sa.IdAgente,sa.Sigla,sa.Categoria
order by Rnk


