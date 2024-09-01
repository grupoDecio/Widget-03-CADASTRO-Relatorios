<script type="text/javascript" src="/webdesk/vcXMLRPC.js"></script>
<script src="/portal/resources/js/mustache/mustache-min.js"></script>

<div id="relatorio_03_cadastro_${instanceId}" class="super-widget wcm-widget-class fluig-style-guide" data-params="relatorio_03_cadastro.instance()">
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
		<div class='col-md-4 col-sm-8'>
			<div class='form-group'>
				<label for='data_sol_INI_${instanceId}'>De</label>
				<input type='text' class='form-control calendar' id='data_sol_INI_${instanceId}' name='data_sol_INI_${instanceId}' />
			</div>
		</div>
		<div class='col-md-4 col-sm-8'>
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
		<div class='col-md-4' hidden>
			<div class='form-group'>
				<label for='CATEGORIA_${instanceId}'>Categoria</label>
				<input type='text' class='form-control' id='CATEGORIA_${instanceId}' name='CATEGORIA_${instanceId}' />
			</div>
		</div>
	</div>
  <div class="row">
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='ZUNIDADE_${instanceId}'>Unidade</label>
				<input type='text' class='form-control' id='ZUNIDADE_${instanceId}' name='ZUNIDADE_${instanceId}' />
			</div>
		</div>
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='EMPRESA_${instanceId}'>Empresa</label>
				<input type='text' class='form-control' id='EMPRESA_${instanceId}' name='EMPRESA_${instanceId}' />
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
						<h3 class="card-title">Solicitação <a class="card-link" style="text-decoration: underline;" href="/portal/p/1/pageworkflowview?app_ecm_workflowview_detailsProcessInstanceID={{NUM_PROCES}}" target="_black">{{NUM_PROCES}}</a></h3>
						<h6 class="card-subtitle mb-2 text-muted">Status: <span class="{{CORSTATUS}}">{{DES_STATUS}}</span></h6>
						<div class="card-text">

							<!-- Dados do movimento -->
							<div class="row">  
								<div class="col-md-4">
									<b>Unidade:</b> {{zUnidade}}
								</div>	
								<div class="col-md-4">
									<b>Segmento:</b> {{zSegmento}}
								</div>	
								<div class="col-md-4">
									<b>Empresa:</b> {{empresa}}
								</div>	
							</div>	
							<div class="row">
								<div class="col-md-4">
									<b>Requisitante:</b> {{nomeSolicitante}}
								</div>	
								<div class="col-md-4">
									<b>Atendente:</b> {{zAtendente}}
								</div>	
								<div class="col-md-4">
									<b>Localização:</b> {{NOM_ESTADO_ATUAL}}
								</div>	
							</div>	
              <div class="row">
								<div class="col-md-4">
									<b>Destinação:</b> {{sl_destinacao_vinc}}
								</div>	
								<div class="col-md-4">
									<b>Categoria:</b> {{ztxt_categoria}}
								</div>	
								<div class="col-md-4">
									<b>Tipo da Solicitação:</b> {{ztxt_subCategoria}}
								</div>	
              </div>
							<div class="row">
								<div class="col-md-4">
									<b>Início:</b> {{START_DATE}}
								</div>	
								<div class="col-md-4">
									<b>Fim:</b> {{END_DATE}}
								</div>	
								<div class="col-md-4">
									<b>Base:</b> {{rb_base}}
								</div>	
							</div>

							<!-- Individual atividades -->
							<div class="row">
								<div class="col-md-12">
									<h4>Execução das atividades</h4>
								</div>
							</div>

							{{#NOM_ESTADO_10}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_10}}
								</div>	
								<div class="col-md-3">
									<b>Responsável:</b> {{FULL_NAME_10}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_10}}
								</div>	
								<div class="col-md-2">
									<b>Tempo:</b> {{TEMPO_GASTO_10}}
								</div>	
							</div>  
							{{/NOM_ESTADO_10}}

							{{#NOM_ESTADO_45}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_45}}
								</div>	
								<div class="col-md-3">
									<b>Responsável:</b> {{FULL_NAME_45}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_45}}
								</div>	
								<div class="col-md-2">
									<b>Tempo:</b> {{TEMPO_GASTO_45}}
								</div>	
							</div>  
							{{/NOM_ESTADO_45}}

							{{#NOM_ESTADO_36}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_36}}
								</div>	
								<div class="col-md-3">
									<b>Responsável:</b> {{FULL_NAME_36}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_36}}
								</div>	
								<div class="col-md-2">
									<b>Tempo:</b> {{TEMPO_GASTO_36}}
								</div>	
							</div>  
							{{/NOM_ESTADO_36}}

							{{#NOM_ESTADO_39}}  
							<div class="row">  
								<div class="col-md-2">
									<b>Atividade:</b> {{NOM_ESTADO_39}}
								</div>	
								<div class="col-md-3">
									<b>Responsável:</b> {{FULL_NAME_39}}
								</div>	
								<div class="col-md-2">
									<b>Conclusão:</b> {{MOV_END_TIME_39}}
								</div>	
								<div class="col-md-2">
									<b>Tempo:</b> {{TEMPO_GASTO_39}}
								</div>	
							</div>  
							{{/NOM_ESTADO_39}}

						</div>
						<a class="card-link" style="text-decoration: underline;" href="/portal/p/1/pageworkflowview?app_ecm_workflowview_detailsProcessInstanceID={{NUM_PROCES}}" target="_black">Visualizar detalhes solicitação</a>
					</div>
				</div>
			</div> 
		</div>
	{{/values}}
</script>
