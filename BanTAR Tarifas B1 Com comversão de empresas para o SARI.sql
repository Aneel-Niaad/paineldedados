/****** Script do comando SelectTopNRows de SSMS  ******/

if OBJECT_id('tempdb..#vige') is not null drop table #vige;
SELECT t1.* into #vige
  FROM [SGT_DEV].[BanTAR].[tblEventos] t1 
  inner join
  (select t3.empresa,t3.ano,max(t3.evento) as evento FROM [SGT_DEV].[BanTAR].[tblEventos] t3 where t3.tipoevento not in ('Interno','Outros','interno') and dateadd(day,1,t3.TarIni)< getdate()
	group by t3.empresa,t3.ano) as t2 on t1.empresa=t2.empresa and t1.ano=t2.ano and t1.evento=t2.evento

	

	if OBJECT_id('tempdb..#Estados') is not null drop table #Estados
create table #Estados (EstadoExt varchar(50),UF varchar(2) )
insert into #Estados values ('Acre',	'AC'),('Alagoas','AL'),('Amapa','AP'),('Amazonas','AM'),('Bahia','BA'),('Ceara','CE'),('Distrito Federal','DF'),
('Espirito Santo','ES'),('Goias','GO'),('Maranhao','MA'),('Mato Grosso','MT'),('Mato Grosso do Sul','MS'),('Minas Gerais','MG'),('Para','PA'),
('Paraiba','PB'),('Parana','PR'),('Pernambuco','PE'),('Piaui', 'PI'),('Rio de Janeiro', 'RJ'), ('Rio Grande do Norte','RN'),('Rio Grande do Sul','RS'),
('Rondonia','RO'),('Roraima','RR'), ('Santa Catarina','SC'),('Sao Paulo','SP'),('Sergipe','SE'),('Tocantins','TO')




SELECT case when ec.id_sreag >200 then 'Permissionária' else 'Concessionária' end as Concessao,
		[SIGLA] as Distribuidora, ec.uf,ec.Regiao as [Região],
		case 
			when t1.[idagente]=1000040 then 5216
			when t1.[idagente]=1000041 then 69
			when t1.[idagente]=1000042 then 396
			else t1.[idagente]
		end as idagente,
		ec.[id_sreag] as idsreag ,t1.[EVENTO], case when vm2.Empresa is null then 'Não Vigente' else 'Vigente' end as Vigecia,
		vig.REH,
		sum([TE]) as TE, sum([TUSD]) as TUSD,  sum([tusd])+sum([te]) as tarifaFinal,
		est.EstadoExt, vig.NumAto as REHNum, year(vig.DataAto) as REHAno,  vig.tarini as [Data Início de vigência], vig.TarFim as [Data Final de agência]
      

      
   
  FROM [SGT_DEV].[BanTAR].[vTarifaTraduzida]
  pivot(sum([Nao se aplica]) for [NomTipoTarifa] in ([TUSD], [TE])) t1
  inner join (select * from [SGT_DEV].[BanTAR].[tblEventos] where tipoevento not in ('Interno','Outros','interno') and dateadd(day,1,TarIni)< getdate()) vig on t1.AnoRef=vig.ano and t1.EVENTO=vig.evento and t1.idagente=vig.Empresa
  left join (select vm.Empresa, max(vm.TarIni) as TarIni from #vige vM group by vm.Empresa) as vm2 on vm2.empresa=t1.idagente and vm2.tarini=vig.TarIni
  left join [SGT_DEV].[PwrBI].[EmpresasCodigo] ec on ec.codigosamp=t1.idagente
  left join #Estados est on est.UF=ec.uf
  where NomModalidadeTarifaria in ('Energia convencional','Convencional') and [NomSubgrupo]='B1'
and [NomSubClasse]='Residencial' and [NomBaseTarifa]='Base Financeira' 

group by ec.id_sreag,[SIGLA],ec.uf,t1.[idagente],[AnoRef] ,t1.[EVENTO] ,[DtIni] , vm2.empresa,vig.REH,vig.tarini, vig.NumAto, year(vig.DataAto), vig.tarini, vig.TarFim, est.EstadoExt,ec.Regiao
