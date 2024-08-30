var ccComplete;
let oNewWindow;
let dataExcel = {
    Processos : [],
    Parametros : []
}
let mydata = new Array();
let agrupadoPorNumProces = new Array();
document['instanceId'] = 0;
var relatorio_03_cadastro = SuperWidget.extend({
    //método iniciado quando a widget é carregada
    init: function () {
        document['instanceId'] = this.instanceId;
        /* this.loadTable(); */
        var mySimpleCalendar = FLUIGC.calendar('.calendar');
    },

    //BIND de eventos
    bindings: {
        local: {
            'load-table': ['click_loadTable'],
            'exportar-processos': ['click_exportarProcessos']
        },
        global: {}
    },

    exportarProcessos: function (params) {
        dataExcel.Parametros = []
        getFiltros(this)

        let filename = 'Relatorio.xlsx';

        var ws = XLSX.utils.json_to_sheet(dataExcel.Processos);
        var ws2 = XLSX.utils.json_to_sheet(dataExcel.Parametros);

        var wb = XLSX.utils.book_new();

        XLSX.utils.book_append_sheet(wb, ws, "Processos");
        XLSX.utils.book_append_sheet(wb, ws2, "Parametros da consulta");

        XLSX.writeFile(wb, filename);
    },

    processInstanceId: function (documentId) {
        let datasetProcessAttachment = DatasetFactory.getDataset('processAttachment', new Array('processAttachmentPK.processInstanceId'), new Array(
            DatasetFactory.createConstraint('sqlLimit', '1', '1', ConstraintType.MUST),
            DatasetFactory.createConstraint('documentId', documentId, documentId, ConstraintType.MUST)
        ), null);
        if (datasetProcessAttachment.values.length > 0) return datasetProcessAttachment.values[0]["processAttachmentPK.processInstanceId"];
        else return 0
    },


    converterDataFormato: function (dataDDMMAAAA) {
        var partesData = dataDDMMAAAA.split('/');
        var dataFormatoAAAAMMDD = new Date(partesData[2], partesData[1] - 1, partesData[0]);
        var dataAAAAMMDD = dataFormatoAAAAMMDD.toISOString().slice(0, 10).replace(/-/g, '');
        return dataAAAAMMDD;
    },

    loadTable: function (htmlElement, event) {
        let constraints = [];
        let NUM_PROCES = String($(`[name='NUM_PROCES_${this.instanceId}']`).val()).trim();
        let status = String($(`[name='status_${this.instanceId}']`).val()).trim();
        let data_sol_INI = String($(`[name='data_sol_INI_${this.instanceId}']`).val()).trim();
        let data_sol_FIM = String($(`[name='data_sol_FIM_${this.instanceId}']`).val()).trim();
        let NOMESOLICITANTE = String($(`[name='NOMESOLICITANTE_${this.instanceId}']`).val()).trim();
        let EMPRESA = String($(`[name='EMPRESA_${this.instanceId}']`).val()).trim();
        let ZUNIDADE = String($(`[name='ZUNIDADE_${this.instanceId}']`).val()).trim();

        if (status != "") constraints.push(DatasetFactory.createConstraint('STATUS', status, status, ConstraintType.MUST));
        if (NUM_PROCES != "") constraints.push(DatasetFactory.createConstraint('NUM_PROCES', NUM_PROCES, NUM_PROCES, ConstraintType.MUST));
        if (NOMESOLICITANTE != "") constraints.push(DatasetFactory.createConstraint('NOMESOLICITANTE', NOMESOLICITANTE, NOMESOLICITANTE, ConstraintType.MUST, true));
        if (ZUNIDADE != "") constraints.push(DatasetFactory.createConstraint('ZUNIDADE', ZUNIDADE, ZUNIDADE, ConstraintType.MUST, true));
        if (EMPRESA != "") constraints.push(DatasetFactory.createConstraint('EMPRESA', EMPRESA, EMPRESA, ConstraintType.MUST, true));
        if (data_sol_INI != "" && data_sol_FIM != "") constraints.push(DatasetFactory.createConstraint('START_DATE', converterDataParaFormatoMySQL(data_sol_INI), converterDataParaFormatoMySQL(data_sol_FIM), ConstraintType.MUST));

        dadosOriginais = DatasetFactory.getDataset("dsWidgetRel03Cadastro", null, constraints, null);

        if (dadosOriginais.values.length > 0) {
            agrupadoPorNumProces = {};
            agrupadoPorNumProces = agruparObjeto(dadosOriginais, NUM_PROCES);
            console.log(agrupadoPorNumProces);

            let tpl = $('.template_datatable').html()
            let html = Mustache.render(tpl, agrupadoPorNumProces);
            $(`#mypanel_${this.instanceId}`).html(html);
        } else {
            console.log("Não foi encontrado nenhum item para esses filtros");
            $(`#mypanel_${this.instanceId}`).html("<b>Nenhum resultado encontrado para essa pesquisa</b>");
        }

    }
});

function getFiltros(that) {
    const campos = [
        { id: 'codProcesso', campo: 'Código do Processo' },
        { id: `data_sol_INI_${that.instanceId}`, campo: 'Data Inicial' },
        { id: `data_sol_FIM_${that.instanceId}`, campo: 'Data Final' },
        { id: `status_${that.instanceId}`, campo: 'Status' },
        { id: `NOMESOLICITANTE_${that.instanceId}`, campo: 'Requisitante' },
        { id: `ZATENDENTE_${that.instanceId}`, campo: 'Atendente' },
        { id: `CATEGORIA_${that.instanceId}`, campo: 'Categoria' },
        { id: `ZFONTE_${that.instanceId}`, campo: 'Empresa' },
        { id: `ZUNIDADE_${that.instanceId}`, campo: 'Unidade' }
    ]

    campos.forEach(e => {
        if(e.id != 'codProcesso' && e.id != `status_${that.instanceId}`){
            if($(`#${e.id}`).val().trim() != ''){
                dataExcel.Parametros.push(
                    {
                        'Campo' : `${e.campo}`,
                        'Valor' : $(`#${e.id}`).val()
                    }
                )
            }
        }
        else if(e.id == `status_${that.instanceId}`){
            let status;
            switch($(`#${e.id}`).val()){
                case '0':
                    status = 'Aberta'
                    break;
                case '2':
                    status = 'Finalizada'
                    break;
                case '1':
                    status = 'Cancelada'
                    break;
                default:
                    status = 'Todos'
                    break;
            }

            dataExcel.Parametros.push(
                {
                    'Campo' : `${e.campo}`,
                    'Valor' : status
                }
            )
        }
        else{
            dataExcel.Parametros.push(
                {
                    'Campo' : `${e.campo}`,
                    'Valor' : '03-CADASTRO - 03-CADASTRO'
                }
            )
        }
    })
}

function agruparObjeto(objeto, NUM_PROCES) {
    let novoObjeto = {};
    let novoObjetoSaida = { values: [] };

    let solicitacoes = []
    let detalhesSolicitacao = [];

    objeto.values.forEach(item => {
        const numProces = item.NUM_PROCES;
        const numSeqEstado = item.NUM_SEQ_ESTADO;

        const nomEstadoKey = `NOM_ESTADO_${numSeqEstado}`;
        const prazoKey = `PRAZO_${numSeqEstado}`;
        const fullName = `FULL_NAME_${numSeqEstado}`;
        const tempoAtividade = `TEMPO_ATIVIDADE_${numSeqEstado}`;
        const conclusao = `MOV_END_TIME_${numSeqEstado}`;
        const tempoGasto = `TEMPO_GASTO_${numSeqEstado}`;

        /** Colunas agrupadas */
        novoObjeto[nomEstadoKey] = item.NOM_ESTADO;
        novoObjeto[prazoKey] = item.PRAZO;
        novoObjeto[fullName] = item.FULL_NAME;
        novoObjeto[tempoAtividade] = item.TEMPO_ATIVIDADE;
        novoObjeto[conclusao] = item.MOV_END_TIME;
        novoObjeto[tempoGasto] = converterSegundos(item.TEMPO_ATIVIDADE);
        novoObjeto.tempoGastoProcesso = converterSegundos(item.TOTAL_EXECUCAO);
        novoObjeto.CORSTATUS = mudaCorStatus(item.STATUS);
        novoObjeto.NOM_ESTADO_ATUAL = item.NOM_ESTADO;

        /** Coluna padrão */
        novoObjeto.NUM_PROCES = numProces;
        novoObjeto.DES_STATUS = item.DES_STATUS;
        novoObjeto.zUnidade = item.zUnidade;
        novoObjeto.zFonte = item.zFonte;
        novoObjeto.nomeSolicitante = item.nomeSolicitante;
        novoObjeto.categoria = item.categoria;
        novoObjeto.assunto = item.assunto;
        novoObjeto.START_DATE = item.START_DATE;
        novoObjeto.END_DATE = item.END_DATE;
        novoObjeto.TOTAL_EXECUCAO = item.TOTAL_EXECUCAO;
        novoObjeto.zSLA = item.zSLA;
        novoObjeto.ATIVIDADE_ATUAL = item.ATIVIDADE_ATUAL;
        novoObjeto.CD_MATRICULA = item.CD_MATRICULA;
        novoObjeto.FULL_NAME = item.FULL_NAME;
        novoObjeto.MOV_INI_TIME = item.MOV_INI_TIME;
        novoObjeto.MOV_END_TIME = item.MOV_END_TIME;
        novoObjeto.DEADLINE = item.DEADLINE;
        novoObjeto.TEMPO_ATIVIDADE = item.TEMPO_ATIVIDADE;
        novoObjeto.NUM_SEQ_ESTADO = item.NUM_SEQ_ESTADO;
        novoObjeto.NR_DOCUMENTO_CARD = item.NR_DOCUMENTO_CARD;
        novoObjeto.STATUS = item.STATUS;
        novoObjeto.COD_MATR_REQUISIT = item.COD_MATR_REQUISIT;
        novoObjeto.COD_DEF_PROCES = item.COD_DEF_PROCES;
        novoObjeto.NR_DOCUMENTO = item.NR_DOCUMENTO;
        novoObjeto.zAtendente = item.zAtendente;
        novoObjeto.Avaliado = mudaAvaliacao(item.Avaliado);

        detalhesSolicitacao.push(
            {
                Solicitação : novoObjeto.NUM_PROCES,
                [`${novoObjeto.NOM_ESTADO_ATUAL} - Responsável`] : novoObjeto[fullName],
                [`${novoObjeto.NOM_ESTADO_ATUAL} - Conclusão`] : novoObjeto[conclusao],
                [`${novoObjeto.NOM_ESTADO_ATUAL} - SLA`] : item.PRAZO,
                [`${novoObjeto.NOM_ESTADO_ATUAL} - Tempo`] : novoObjeto[`TEMPO_GASTO_${numSeqEstado}`]
            }
        )

        if (item.ATIVIDADE_ATUAL == "true") {
            novoObjetoSaida.values.push(novoObjeto);
            solicitacoes.push(
                {
                    Solicitação : novoObjeto.NUM_PROCES,
                    Status : novoObjeto.DES_STATUS,
                    Unidade : novoObjeto.zUnidade,
                    Empresa : novoObjeto.zFonte,
                    Requisitante : novoObjeto.nomeSolicitante,
                    Localizacao : novoObjeto.NOM_ESTADO_ATUAL,
                    Categoria : novoObjeto.categoria,
                    Assunto : novoObjeto.assunto,
                    Inicio : novoObjeto.START_DATE,
                    Fim : novoObjeto.END_DATE, 
                    Tempo_em_execução : novoObjeto.TOTAL_EXECUCAO,
                    SLA : novoObjeto.zSLA
                }
            )
            novoObjeto = {};
            ultimoObj = item.NUM_PROCES;
        }
    });

    dataExcel.Processos = solicitacoes.map(proc => {
        const detalhesDoProcesso = detalhesSolicitacao.filter(det => det.Solicitação === proc.Solicitação);
        return { ...proc, ...Object.assign({}, ...detalhesDoProcesso) };
    })

    return novoObjetoSaida;
}


function converterSegundos(segundos) {
    const umDiaEmSegundos = 86400;
    const umaHoraEmSegundos = 3600;
    const umMinutoEmSegundos = 60;

    const dias = Math.floor(segundos / umDiaEmSegundos);
    segundos %= umDiaEmSegundos;

    const horas = Math.floor(segundos / umaHoraEmSegundos);
    segundos %= umaHoraEmSegundos;

    const minutos = Math.floor(segundos / umMinutoEmSegundos);
    segundos %= umMinutoEmSegundos;

    const segundosRestantes = segundos;

    const textoDias = dias === 1 ? 'dia' : 'dias';
    const textoHoras = horas === 1 ? 'hora' : 'horas';
    const textoMinutos = minutos === 1 ? 'minuto' : 'minutos';
    const textoSegundos = segundosRestantes === 1 ? 'segundo' : 'segundos';

    let resultado = '';
    if (dias > 0) resultado += `${dias} ${textoDias}, `;
    if (horas > 0) resultado += `${horas} ${textoHoras}, `;
    if (minutos > 0) resultado += `${minutos} ${textoMinutos}, `;
    if (segundosRestantes > 0) resultado += `${segundosRestantes} ${textoSegundos}`;

    // Remover a vírgula extra se houver
    resultado = resultado.replace(/,\s*$/, '');

    return resultado;
}

function mudaCorStatus(params) {
    switch (params) {
        case "0" || 0: return "text-success";
        case "1" || 1: return "text-warning";
        case "2" || 2: return "text-danger";
        default: return params;
    }
}

function preencheEmpresa(empresa1, empresa2) {
    empresa1 = String(empresa1).trim();
    empresa2 = String(empresa2).trim();

    if (empresa1 && empresa2) {
      console.log(empresa1 + " " + empresa2);
      return empresa1 + ' / ' + empresa2;
    } else if (empresa1) {
      console.log(empresa1);
      return empresa1;
    } else if (empresa2) {
      console.log(empresa2);
      return empresa2;
    } else {
      return '';
    }
}


function mudaAvaliacao(params) {
    switch (params) {
        case "Muito_satisfeito": return "Muito satisfeito";
        case "Satisfeito": return "Satisfeito";
        case "Indiferente": return "Indiferente";
        case "Insatisfeito": return "Insatisfeito";
        case "Muito_insatisfeito": return "Muito insatisfeito";
        default: return params;
    }
}


function converterDataParaFormatoMySQL(data) {
    var partesData = data.split('/');
    var dataFormatoMySQL = partesData[2] + '-' + partesData[1] + '-' + partesData[0];
    return dataFormatoMySQL;
}
