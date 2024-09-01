<script type="text/javascript" src="/webdesk/vcXMLRPC.js"></script>
<script src="/portal/resources/js/mustache/mustache-min.js"></script>

<div id="relatorio_AberturaVaga_${instanceId}" class="super-widget wcm-widget-class fluig-style-guide" data-params="relatorio_AberturaVaga.instance()">
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
				<label for='SOLICITANTE_${instanceId}'>Requisitante</label>
				<input type='text' class='form-control' id='SOLICITANTE_${instanceId}' name='SOLICITANTE_${instanceId}' />
			</div>
		</div>
		<div class='col-md-4'>
			<div class='form-group'>
				<label for='UNIDADE_${instanceId}'>Unidade</label>
				<input type='text' class='form-control' id='UNIDADE_${instanceId}' name='UNIDADE_${instanceId}' />
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
									<b>Unidade:</b> {{unidade}}
								</div>	
								<div class="col-md-2">
									<b>Requisitante:</b> {{solicitante}}
								</div>	
								<div class="col-md-2">
									<b>Localização:</b> {{NOM_ESTADO_ATUAL}}
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

							{{#NOM_ESTADO_233}}  
							<div class="row NOM_ESTADO_23">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_233}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_233}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_233}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_233}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_233}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_233}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_233}}
							

							{{#NOM_ESTADO_214}}  
							<div class="row NOM_ESTADO_21">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_214}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_214}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_214}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_214}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_214}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_214}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_214}}
							
							{{#NOM_ESTADO_6}}  
							<div class="row }">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_6}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_6}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_6}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_6}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_6}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_6}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_6}}

							{{#NOM_ESTADO_60}}  
							<div class="row NOM_ESTADO_60">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_60}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_60}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_60}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_60}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_60}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_60}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_60}}
							
							{{#NOM_ESTADO_12}}  
							<div class="row NOM_ESTADO_12">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_12}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_12}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_12}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_12}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_12}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_12}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_12}}
														
							{{#NOM_ESTADO_17}}  
							<div class="row NOM_ESTADO_17">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_17}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_17}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_17}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_17}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_17}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_17}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_17}}

							{{#NOM_ESTADO_14}}  
							<div class="row NOM_ESTADO_14">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_14}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_14}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_14}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_14}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_14}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_14}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_14}}

							{{#NOM_ESTADO_148}}  
							<div class="row NOM_ESTADO_14">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_148}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_148}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_148}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_148}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_148}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_148}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_148}}

							{{#NOM_ESTADO_150}}  
							<div class="row NOM_ESTADO_15">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_150}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_150}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_150}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_150}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_150}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_150}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_150}}

							{{#NOM_ESTADO_152}}  
							<div class="row NOM_ESTADO_15">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_152}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_152}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_152}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_152}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_152}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_152}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_152}}
							
							{{#NOM_ESTADO_19}}  
							<div class="row NOM_ESTADO_19">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_19}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_19}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_19}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_19}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_19}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_19}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_19}}

							
							{{#NOM_ESTADO_47}}  
							<div class="row NOM_ESTADO_47">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_47}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_47}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_47}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_47}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_47}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_47}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_47}}

							{{#NOM_ESTADO_107}}  
							<div class="row NOM_ESTADO_10">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_107}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_107}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_107}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_107}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_107}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_107}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_107}}

							{{#NOM_ESTADO_124}}  
							<div class="row NOM_ESTADO_12">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_124}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_124}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_124}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_124}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_124}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_124}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_124}}

							{{#NOM_ESTADO_117}}  
							<div class="row NOM_ESTADO_11">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_117}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_117}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_117}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_117}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_117}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_117}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_117}}

							{{#NOM_ESTADO_236}}  
							<div class="row NOM_ESTADO_23">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_236}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_236}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_236}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_236}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_236}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_236}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_236}}

							{{#NOM_ESTADO_238}}  
							<div class="row NOM_ESTADO_23">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_238}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_238}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_238}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_238}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_238}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_238}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_238}}

							{{#NOM_ESTADO_111}}  
							<div class="row NOM_ESTADO_11">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_111}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_111}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_111}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_111}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_111}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_111}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_111}}

							{{#NOM_ESTADO_222}}  
							<div class="row NOM_ESTADO_22">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_222}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_222}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_222}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_222}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_222}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_222}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_222}}

							{{#NOM_ESTADO_86}}  
							<div class="row NOM_ESTADO_86">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_86}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_86}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_86}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_86}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_86}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_86}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_86}}

							{{#NOM_ESTADO_66}}  
							<div class="row NOM_ESTADO_66">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_66}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_66}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_66}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_66}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_66}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_66}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_66}}

							{{#NOM_ESTADO_49}}  
							<div class="row NOM_ESTADO_49">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_49}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_49}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_49}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_49}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_49}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_49}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_49}}

							{{#NOM_ESTADO_70}}  
							<div class="row NOM_ESTADO_70">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_70}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_70}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_70}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_70}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_70}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_70}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_70}}

							{{#NOM_ESTADO_72}}  
							<div class="row NOM_ESTADO_72">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_72}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_72}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_72}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_72}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_72}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_72}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_72}}

							{{#NOM_ESTADO_76}}  
							<div class="row NOM_ESTADO_76">  
								<div class="col-md-4">
									<b>Atividade:</b> {{NOM_ESTADO_76}}
								</div>	
								<div class="col-md-4">
									<b>Responsável:</b> {{FULL_NAME_76}}
								</div>	
								<div class="col-md-4">
									<b>SLA:</b> {{PRAZO_76}}
								</div>	
							</div>
							<div class="row">
								<div class="col-md-4">
									<b>Conclusão:</b> {{MOV_END_TIME_76}}
								</div>	
								<div class="col-md-4">
									<b>Tempo total:</b> {{TEMPO_GASTO_76}}
								</div>		
								<div class="col-md-4">
									<b>Tempo expediente:</b> {{TEMPO_ATIVIDADE_EXPEDIENTE_76}}
								</div>
							</div>  
							<hr style="padding: 1px; margin: 1px;">
							{{/NOM_ESTADO_76}}

						</div>
						<a class="card-link" style="text-decoration: underline;" href="/portal/p/1/pageworkflowview?app_ecm_workflowview_detailsProcessInstanceID={{NUM_PROCES}}" target="_black">Visualizar detalhes solicitação</a>
					</div>
				</div>
			</div> 
		</div>
	{{/values}}
</script>