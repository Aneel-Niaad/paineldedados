 SELECT T.DataRef
		, T.Ano
		, T.Mes
		, T.IdAgente
		, T.Sigla
		, T.UF
		, T.Regiao
		, T.ClassifAgente
		, T.IdeTipRca
		, T.CodTipRca
		, T.DescRca
		,sum(iif(IdeRsl = 2, QtdRcaRcb, 0)) as CtaQtdRcaRcb        
		,sum(iif(IdeRsl = 2, [QtdRcaPcd],0)) as CtaQtdPcd        
		,sum(iif(IdeRsl = 2, [QtdRcaIpc],0)) as CtaQtdIpc        
		,avg(iif(IdeRsl = 2, [PrzMedSol],0)) as CtaPrzMedSol     
		,sum(iif(IdeRsl = 4, QtdRcaRcb, 0)) as OuvQtdRcaRcb        
		,sum(iif(IdeRsl = 4, [QtdRcaPcd],0)) as OuvQtdPcd        
		,sum(iif(IdeRsl = 4, [QtdRcaIpc],0)) as OuvQtdIpc        
		,avg(iif(IdeRsl = 4, [PrzMedSol],0)) as OuvPrzMedSol   
   FROM
	(select      
	   cast(iif(month(DatRefRca)>9, concat(year(DatRefRca),'-',month(DatRefRca),'-01'), concat(year(DatRefRca),'-0',month(DatRefRca),'-01')) as Date) as DataRef      
	   ,year(DatRefRca) as Ano     
	   ,month(DatRefRca) as Mes     
	   ,CASE
			when IdeAgt = 7085 then 4248 
			WHEN IdeAgt IN (28,370) THEN 370
			WHEN IdeAgt IN (69,70,71,72,73) THEN 69 -- AND Ano >= 2018 
			WHEN IdeAgt in (75,84,386,5216,5217) THEN 5216 -- AND Ano >= 2018 AND MES >= 7 
			WHEN IdeAgt IN (396, 397) THEN 396
			ELSE IdeAgt
		END AS IdAgente  
		,(case     
			when IdeAgt = 7085 then 'CERAL-DIS'     
			when IdeAgt in (75,84,386,5216,5217) then 'ESS'    
			when IdeAgt in (28,370) then 'Eletrobrás Distribuição Roraima'  
			WHEN IdeAgt in (69,70,71,72,73) THEN 'CPFL Santa Cruz'   
			WHEN IdeAgt IN (396, 397) THEN 'RGE'
			else SiglaAgente end) as Sigla     
		,(case     
			when IdeAgt in (75,84,386,5217) then 'SP'     
			when IdeAgt in (28,370) then 'RR'     
			else UF end) as UF      
		,(case     
			when IdeAgt in (75,84,386,5217) then 'SE'     
			when IdeAgt in (28,370) then 'N'     
			else Regiao end) as Regiao     
		,ClassifAgente        
		,R.[IdeTipRca]     
		,R.CodTipRca     
		,T.TipRca as DescRca   
		,IdeRsl
		,QtdRcaRcb
		,[QtdRcaPcd]
		,[QtdRcaIpc]
		,[PrzMedSol]  
		FROM [BDC].[dbo].[OUV_Resolucao382] as R    
		left join [SMA_SAS].[dbo].[SMA01_Dim_INFODIST] as D on (r.ideAgt = D.IdAgente)    left join [BDC].[dbo].[OUV_TipoReclamacaoResolucao382] as T on (r.CodTipRca = T.CodTipRca)    
		where year(DatRefRca) >= 2010  and not (r.IdeAgt = 5160 and year(DatRefRca)= 2010 and day(DatRefRca) = 7 and IdColaborador = 9852)    and IdAgente not in (373,395,150)  
		) T
   group by T.DataRef
		, T.Ano
		, T.Mes
		, T.IdAgente
		, T.Sigla
		, T.UF
		, T.Regiao
		, T.ClassifAgente
		, T.IdeTipRca
		, T.CodTipRca
		, T.DescRca


