SELECT [IdAgente] AS Agente,
	   FE.[DtCompetenciaFe] AS Competencia,
	 -- CC.DescClasseConsumoCc AS ClasseConsumo,
	 --  MT.DescModFornecimentoMt AS ModalidadeTarifaria,
	  ST.DescSubGrupoSgt AS SubGrupo,
	  DT.DescDetFornecimentoDet AS DetalheTarifario,
	 --   PT.DescPostoTarifarioPot AS PostoTarifario,
	 --  NI.DescNaturezaNm AS Natureza,
	 --  FE.TipoFe,
	sum(FE.VlrFornecimentoFe) as Valor

	  FROM [BDC].[dbo].[SM_FornecimentoEnergia] FE
	 JOIN [BDC].[dbo].[SM_MercadoFornecimento] MF ON FE.IdClasseConsumoCc = MF.IdClasseConsumoCc AND FE.IdModFornecimentoMt = MF.IdModFornecimentoMt
											AND FE.IdSubGrupoSgt = MF.IdSubGrupoSgt AND FE.IdDetFornecimentoDet = MF.IdDetFornecimentoDet
										AND FE.IdPostoTarifarioPot = MF.IdPostoTarifarioPot AND FE.IdNaturezaNm = MF.IdNaturezaNm
	  JOIN [BDC].[dbo].[SM_ClasseConsumo] CC ON MF.IdClasseConsumoCc = CC.IdClasseConsumoCc
	  JOIN [BDC].[dbo].[SM_DetalheTarifario] DT ON MF.IdDetFornecimentoDet = DT.IdDetFornecimentoDet
	  JOIN [BDC].[dbo].[SM_ModalidadeTarifaria] MT ON MF.IdModFornecimentoMt = MT.IdModFornecimentoMt
	  JOIN [BDC].[dbo].[SM_NaturezaInfoMercado] NI ON MF.IdNaturezaNm = NI.IdNaturezaNm
	  JOIN [BDC].[dbo].[SM_PostoTarifario] PT ON MF.IdPostoTarifarioPot = PT.IdPostoTarifarioPot
	  JOIN [BDC].[dbo].[SM_SubGrupoTarifario] ST ON MF.IdSubGrupoSgt = ST.IdSubGrupoSgt

 where FE.TipoFe IN ('A')
 and  DATEDIFF(month,FE.[DtCompetenciaFe],getdate())=3
 and  NI.IdNaturezaNm not in (6,9,10)
 and  DT.DescDetFornecimentoDet in ('Número de consumidores')
 and ST.DescSubGrupoSgt  in ('B1 - Residencial')
 
 group by  [IdAgente], DtCompetenciaFe, DescSubGrupoSgt, DescDetFornecimentoDet

