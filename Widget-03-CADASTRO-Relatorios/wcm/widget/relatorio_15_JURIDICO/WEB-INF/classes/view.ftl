<script type="text/javascript" src="/webdesk/vcXMLRPC.js"></script>
<script src="/portal/resources/js/mustache/mustache-min.js"></script>

<div id="relatorio_15_juridico_${instanceId}" class="super-widget wcm-widget-class fluig-style-guide" data-params="relatorio_15_juridico.instance()">
	<!-- Filtros -->
	<div class="row">
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='NUM_PROCES_${instanceId}'>Solicitação</label>
				<input type='text' class='form-control' id='NUM_PROCES_${instanceId}' name='NUM_PROCES_${instanceId}' />
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-8">
			<label for=''>Data da solicitação</label>
		</div>
	</div>
	<div class="row">
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='data_sol_INI_${instanceId}'>De</label>
				<input type='text' class='form-control calendar' id='data_sol_INI_${instanceId}' name='data_sol_INI_${instanceId}' />
			</div>
		</div>
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='data_sol_FIM_${instanceId}'>Até</label>
				<input type='text' class='form-control calendar' id='data_sol_FIM_${instanceId}' name='data_sol_FIM_${instanceId}' />
			</div>
		</div>
	</div>

	<div class="row">
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='status_${instanceId}'>Status</label>
				<select class='form-control' id='status_${instanceId}' name='status_${instanceId}'>
					<option value="">Selecione uma opção</option>
					<option value="0">Aberta</option>
					<option value="2">Finalizada</option>
					<option value="1">Cancelada</option>
				</select>
			</div>
		</div>
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='NOMESOLICITANTE_${instanceId}'>Requisitante</label>
				<input type='text' class='form-control' id='NOMESOLICITANTE_${instanceId}' name='NOMESOLICITANTE_${instanceId}' />
			</div>
		</div>
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='ZATENDENTE_${instanceId}'>Atendente</label>
				<input type='text' class='form-control' id='ZATENDENTE_${instanceId}' name='ZATENDENTE_${instanceId}' />
			</div>
		</div>
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='CATEGORIA_${instanceId}'>Categoria</label>
				<input type='text' class='form-control' id='CATEGORIA_${instanceId}' name='CATEGORIA_${instanceId}' />
			</div>
		</div>
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='ZFONTE_${instanceId}'>Empresa</label>
				<input type='text' class='form-control' id='ZFONTE_${instanceId}' name='ZFONTE_${instanceId}' />
			</div>
		</div>
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='ZUNIDADE_${instanceId}'>Unidade</label>
				<input type='text' class='form-control' id='ZUNIDADE_${instanceId}' name='ZUNIDADE_${instanceId}' />
			</div>
		</div>
	</div>

	<!-- Botões -->
	<div class="row">
		<div class='col-md-4'>
			<div class='form-group'>
				<button class="btn btn-info" data-load-table> Carregar tabela </button>
			</div>
		</div>
		<div class='col-md-4'>
			<div class='form-group'>
				<button class="btn btn-success" data-exportar-processos> Exportar Resultados </button>
			</div>
		</div>
	</div>

	<!-- Tabela -->
	<div id="mypanel_${instanceId}"></div>
</div>

<script type="text/template" class="template_datatable">
	{{#values}}
		<div class="row">'
			<div class="col-md-12">
				<div class="card">
					<div class="card-body">
						<h3 class="card-title">Solicitação {{NUM_PROCES}}</h3>
						<h6 class="card-subtitle mb-2 text-muted">Status: <span class="{{CORSTATUS}}">{{DES_STATUS}}</span></h6>
						<div class="card-text">

							<!-- Dados do movimento -->
							<div class="row">  
								<div class="col-md-2">
									<b>Unidade:</b> {{zUnidade}}
								</div>	
								<div class="col-md-2">
									<b>Empresa:</b> {{zFonte}}
								</div>	
								<div class="col-md-2">
									<b>Requisitante:</b> {{nomeSolicitante}}
								</div>	
								<div class="col-md-2">
									<b>Localização:</b> {{NOM_ESTADO_ATUAL}}
								</div>	
								<div class="col-md-2">
									<b>Categoria:</b> {{categoria}}
								</div>	
								<div class="col-md-12">
									<b>Assunto:</b> {{assunto}}
								</div>	
								<div class="col-md-2">
									<b>Início:</b> {{START_DATE}}
								</div>	
								<div class="col-md-2">
									<b>Fim:</b> {{END_DATE}}
								</div>	
								<div class="col-md-3">
									<b>Tempo em execução:</b> {{tempoGastoProcesso}}
								</div>	
								<div class="col-md-2">
									<b>SLA:</b> {{zSLA}}
								</div>	
								<div class="col-md-2">
									<b>Avaliado:</b> {{Avaliado}}
								</div>	
							</div>  

							<!-- Individual atividades -->
							<div class="row">
								<div class="col-md-12">
									<h4>Execução das atividades</h4>
								</div>
							</div>
							{{#NOM_ESTADO_3}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_3}}
								</div>	
								<div class="col-md-3">
									<b>Responsável:</b> {{FULL_NAME_3}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_3}}
								</div>	
								<div class="col-md-2">
									<b>SLA:</b> {{PRAZO_3}}
								</div>	
								<div class="col-md-2">
									<b>Tempo:</b> {{TEMPO_GASTO_3}}
								</div>	
							</div>  
							{{/NOM_ESTADO_3}}
							
							{{#NOM_ESTADO_4}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_4}}
								</div>	
								<div class="col-md-3">
									<b>Responsável:</b> {{FULL_NAME_4}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_4}}
								</div>	
								<div class="col-md-2">
									<b>SLA:</b> {{PRAZO_4}}
								</div>	
								<div class="col-md-2">
									<b>Tempo:</b> {{TEMPO_GASTO_4}}
								</div>		
							</div>  
							{{/NOM_ESTADO_4}}
							
							{{#NOM_ESTADO_8}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_8}}
								</div>	
								<div class="col-md-3">
									<b>Responsável:</b> {{FULL_NAME_8}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_8}}
								</div>	
								<div class="col-md-2">
									<b>SLA:</b> {{PRAZO_8}}
								</div>	
								<div class="col-md-2">
									<b>Tempo:</b> {{TEMPO_GASTO_8}}
								</div>		
							</div>  
							{{/NOM_ESTADO_8}}
							
							{{#NOM_ESTADO_63}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_63}}
								</div>	
								<div class="col-md-3">
									<b>Responsável:</b> {{FULL_NAME_63}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_63}}
								</div>	
								<div class="col-md-2">
									<b>SLA:</b> {{PRAZO_63}}
								</div>	
								<div class="col-md-2">
									<b>Tempo:</b> {{TEMPO_GASTO_63}}
								</div>		
							</div>  
							{{/NOM_ESTADO_63}}
							
							{{#NOM_ESTADO_65}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_65}}
								</div>	
								<div class="col-md-3">
									<b>Responsável:</b> {{FULL_NAME_65}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_65}}
								</div>	
								<div class="col-md-2">
									<b>SLA:</b> {{PRAZO_65}}
								</div>	
								<div class="col-md-2">
									<b>Tempo:</b> {{TEMPO_GASTO_65}}
								</div>		
							</div>  
							{{/NOM_ESTADO_65}}
							
							{{#NOM_ESTADO_72}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_72}}
								</div>	
								<div class="col-md-3">
									<b>Responsável:</b> {{FULL_NAME_72}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_72}}
								</div>	
								<div class="col-md-2">
									<b>SLA:</b> {{PRAZO_72}}
								</div>	
								<div class="col-md-2">
									<b>Tempo:</b> {{TEMPO_GASTO_72}}
								</div>		
							</div>  
							{{/NOM_ESTADO_72}}
							
							<!-- Atividades sem responsável ou prazo -->
							{{#NOM_ESTADO_111}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_111}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_111}}
								</div>		
							</div>  
							{{/NOM_ESTADO_111}}
							
							{{#NOM_ESTADO_113}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_133}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_133}}
								</div>		
							</div>  
							{{/NOM_ESTADO_113}}
							
							{{#NOM_ESTADO_17}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_17}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_17}}
								</div>	
							</div>  
							{{/NOM_ESTADO_17}}
							
							{{#NOM_ESTADO_108}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_108}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_108}}
								</div>		
							</div>  
							{{/NOM_ESTADO_108}}
							
							{{#NOM_ESTADO_106}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_106}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_106}}
								</div>		
							</div>  
							{{/NOM_ESTADO_106}}

						</div>
						<a class="card-link" style="text-decoration: underline;" href="/portal/p/1/pageworkflowview?app_ecm_workflowview_detailsProcessInstanceID={{NUM_PROCES}}" target="_black">Visualizar detalhes solicitação</a>
					</div>
				</div>
			</div> 
		</div>
	{{/values}}
</script>