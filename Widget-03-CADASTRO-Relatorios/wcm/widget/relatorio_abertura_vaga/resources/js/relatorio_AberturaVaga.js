let ccComplete;
let oNewWindow;
let dataExcel = {
    Processos: [],
    Parametros: []
}
var myLoading1;

let mydata = new Array();
let agrupadoPorNumProces = new Array();

document['instanceId'] = 0;

var relatorio_AberturaVaga = SuperWidget.extend({
    //método iniciado quando a widget é carregada
    init: function () {
        document['instanceId'] = this.instanceId;
        /* this.loadTable(); */
        var mySimpleCalendar = FLUIGC.calendar('.calendar');
        myLoading1 = FLUIGC.loading(`#relatorio_AberturaVaga_${this.instanceId}`);
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
        myLoading1.show();
        let constraints = [];
        let limite = String($(`[name='limite_${this.instanceId}']`).val()).trim();
        let NUM_PROCES = String($(`[name='NUM_PROCES_${this.instanceId}']`).val()).trim();
        let status = String($(`[name='status_${this.instanceId}']`).val()).trim();
        let data_sol_INI = String($(`[name='data_sol_INI_${this.instanceId}']`).val()).trim();
        let data_sol_FIM = String($(`[name='data_sol_FIM_${this.instanceId}']`).val()).trim();
        let SOLICITANTE = String($(`[name='SOLICITANTE_${this.instanceId}']`).val()).trim();
        let UNIDADE = String($(`[name='UNIDADE_${this.instanceId}']`).val()).trim();

        // if (limite != "") constraints.push(DatasetFactory.createConstraint('sqlLimit', limite, limite, ConstraintType.MUST));
        if (status != "") constraints.push(DatasetFactory.createConstraint('STATUS', status, status, ConstraintType.MUST));
        if (NUM_PROCES != "") constraints.push(DatasetFactory.createConstraint('NUM_PROCES', NUM_PROCES, NUM_PROCES, ConstraintType.MUST));
        if (SOLICITANTE != "") constraints.push(DatasetFactory.createConstraint('SOLICITANTE', SOLICITANTE, SOLICITANTE, ConstraintType.MUST, true));
        if (UNIDADE != "") constraints.push(DatasetFactory.createConstraint('UNIDADE', UNIDADE, UNIDADE, ConstraintType.MUST, true));
        if (data_sol_INI != "" && data_sol_FIM != "") constraints.push(DatasetFactory.createConstraint('START_DATE', converterDataParaFormatoMySQL(data_sol_INI), converterDataParaFormatoMySQL(data_sol_FIM), ConstraintType.MUST));

        dadosOriginais = DatasetFactory.getDataset("dsWidgetRelAberturaVaga", null, constraints, null);
        if (dadosOriginais.values.length > 0) {
            agrupadoPorNumProces = {};
            agrupadoPorNumProces = agruparObjeto(dadosOriginais, NUM_PROCES);
            let tpl = $('.template_datatable').html()
            let html = Mustache.render(tpl, agrupadoPorNumProces);
            $(`#mypanel_${this.instanceId}`).html(html);
            myLoading1.hide();
        } else {
            console.log("Não foi encontrado nenhum item para esses filtros");
            $(`#mypanel_${this.instanceId}`).html("<b>Nenhum resultado encontrado para essa pesquisa</b>");
            myLoading1.hide();
        }

    }
});

function getFiltros(that) {
    const campos = [
        { id: 'codProcesso', campo: 'Código do Processo' },
        { id: `data_sol_INI_${that.instanceId}`, campo: 'Data Inicial' },
        { id: `data_sol_FIM_${that.instanceId}`, campo: 'Data Final' },
        { id: `status_${that.instanceId}`, campo: 'Status' },
        { id: `SOLICITANTE_${that.instanceId}`, campo: 'Requisitante' },
        { id: `UNIDADE_${that.instanceId}`, campo: 'Unidade' }
    ]

    campos.forEach(e => {
        if (e.id != 'codProcesso' && e.id != `status_${that.instanceId}`) {
            if ($(`#${e.id}`).val().trim() != '') {
                dataExcel.Parametros.push(
                    {
                        'Campo': `${e.campo}`,
                        'Valor': $(`#${e.id}`).val()
                    }
                )
            }
        }
        else if (e.id == `status_${that.instanceId}`) {
            let status;
            switch ($(`#${e.id}`).val()) {
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
                    'Campo': `${e.campo}`,
                    'Valor': status
                }
            )
        }
        else {
            dataExcel.Parametros.push(
                {
                    'Campo': `${e.campo}`,
                    'Valor': 'abertura_vaga - Requisição de Pessoal/Admissão'
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
    for (let x = 0; x < objeto.values.length; x++) {
        const numProces = objeto.values[x].NUM_PROCES;
        const numSeqEstado = parseInt(objeto.values[x].NUM_SEQ_ESTADO, 10);

        const nomEstadoKey = `NOM_ESTADO_${numSeqEstado}`;
        const prazoKey = `PRAZO_${numSeqEstado}`;
        const fullName = `FULL_NAME_${numSeqEstado}`;
        const tempoAtividade = `TEMPO_ATIVIDADE_${numSeqEstado}`;
        const conclusao = `MOV_END_TIME_${numSeqEstado}`;
        const tempoGasto = `TEMPO_GASTO_${numSeqEstado}`;
        const tempoGasto_HM = `TEMPO_GASTO_${numSeqEstado}`;
        const tempoGastoExpediente = `TEMPO_ATIVIDADE_EXPEDIENTE_${numSeqEstado}`;
        const tempoGastoExpediente_HM = `TEMPO_ATIVIDADE_EXPEDIENTE_${numSeqEstado}`;

        /** Colunas agrupadas */
        novoObjeto[nomEstadoKey] = objeto.values[x].NOM_ESTADO;
        novoObjeto[prazoKey] = objeto.values[x].PRAZO;
        novoObjeto[fullName] = objeto.values[x].FULL_NAME;
        novoObjeto[tempoAtividade] = objeto.values[x].TEMPO_ATIVIDADE;
        novoObjeto[conclusao] = objeto.values[x].MOV_END_TIME;
        novoObjeto[tempoGasto] = convertSecondsToHoursAndMinutes(objeto.values[x].TEMPO_ATIVIDADE);
        novoObjeto[tempoGastoExpediente] = convertSecondsToHoursAndMinutes(objeto.values[x].TEMPO_ATIVIDADE_EXPEDIENTE);
        novoObjeto.tempoGastoProcesso = convertSecondsToHoursAndMinutes(objeto.values[x].TOTAL_EXECUCAO);
        novoObjeto[tempoGasto_HM] = convertSecondsToHoursAndMinutes(objeto.values[x].TEMPO_ATIVIDADE);
        novoObjeto[tempoGastoExpediente_HM] = convertSecondsToHoursAndMinutes(objeto.values[x].TEMPO_ATIVIDADE_EXPEDIENTE);

        novoObjeto.CORSTATUS = mudaCorStatus(objeto.values[x].STATUS);
        novoObjeto.NOM_ESTADO_ATUAL = objeto.values[x].NOM_ESTADO;

        // if ([233, 214, 6, 148, 150, 152, 107, 124, 117, 236, 238, 111, 222].includes(numSeqEstado)) {
        //     console.log(tempoGastoExpediente)
        //     console.log(novoObjeto[tempoGastoExpediente])
        // }

        /** Coluna padrão */
        novoObjeto.NUM_PROCES = numProces;
        novoObjeto.DES_STATUS = objeto.values[x].DES_STATUS;
        novoObjeto.unidade = objeto.values[x].unidade;
        novoObjeto.solicitante = objeto.values[x].solicitante;
        novoObjeto.assunto = objeto.values[x].assunto;
        novoObjeto.START_DATE = objeto.values[x].START_DATE;
        novoObjeto.END_DATE = objeto.values[x].END_DATE;
        novoObjeto.TOTAL_EXECUCAO = objeto.values[x].TOTAL_EXECUCAO;
        novoObjeto.ATIVIDADE_ATUAL = objeto.values[x].ATIVIDADE_ATUAL;
        novoObjeto.CD_MATRICULA = objeto.values[x].CD_MATRICULA;
        novoObjeto.FULL_NAME = objeto.values[x].FULL_NAME;
        novoObjeto.MOV_INI_TIME = objeto.values[x].MOV_INI_TIME;
        novoObjeto.MOV_END_TIME = objeto.values[x].MOV_END_TIME;
        novoObjeto.DEADLINE = objeto.values[x].DEADLINE;
        novoObjeto.TEMPO_ATIVIDADE = objeto.values[x].TEMPO_ATIVIDADE;
        novoObjeto.NUM_SEQ_ESTADO = objeto.values[x].NUM_SEQ_ESTADO;
        novoObjeto.NR_DOCUMENTO_CARD = objeto.values[x].NR_DOCUMENTO_CARD;
        novoObjeto.STATUS = objeto.values[x].STATUS;
        novoObjeto.COD_MATR_REQUISIT = objeto.values[x].COD_MATR_REQUISIT;
        novoObjeto.COD_DEF_PROCES = objeto.values[x].COD_DEF_PROCES;
        novoObjeto.NR_DOCUMENTO = objeto.values[x].NR_DOCUMENTO;

        if (`${numSeqEstado}` == 5) {
            detalhesSolicitacao.push(
                {
                    Solicitação: novoObjeto.NUM_PROCES,
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Responsável`]: novoObjeto[fullName],
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Conclusão`]: novoObjeto[conclusao],
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Tempo`]: 0,
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Tempo Expediente`]: 0
                }
            )

        } else if (["17", "12", "14"].includes(numSeqEstado)) {
            const validaInfos = objeto.values.filter(obj => obj.NUM_SEQ_ESTADO == '6' && obj.NUM_PROCES == numProces)
            const lastMov = validaInfos[0]
            detalhesSolicitacao.push(
                {
                    Solicitação: novoObjeto.NUM_PROCES,
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Responsável`]: novoObjeto[fullName],
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Conclusão`]: novoObjeto[conclusao],
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Tempo`]: novoObjeto[tempoGasto_HM],
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Tempo Expediente`]: novoObjeto[tempoGastoExpediente_HM]
                }
            )
        }
        else {
            detalhesSolicitacao.push(
                {
                    Solicitação: novoObjeto.NUM_PROCES,
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Responsável`]: novoObjeto[fullName],
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Conclusão`]: novoObjeto[conclusao],
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Tempo`]: novoObjeto[tempoGasto_HM],
                    [`${novoObjeto.NOM_ESTADO_ATUAL} - Tempo Expediente`]: novoObjeto[tempoGastoExpediente_HM]
                }
            )
        }
        if (objeto.values[x].ATIVIDADE_ATUAL == "true") {
            novoObjetoSaida.values.push(novoObjeto);
            solicitacoes.push(
                {
                    Solicitação: novoObjeto.NUM_PROCES,
                    Status: novoObjeto.DES_STATUS,
                    Unidade: novoObjeto.unidade,
                    Requisitante: novoObjeto.solicitante,
                    Localizacao: novoObjeto.NOM_ESTADO_ATUAL,
                    Assunto: novoObjeto.assunto,
                    Inicio: novoObjeto.START_DATE,
                    Fim: novoObjeto.END_DATE,
                    Tempo_em_execução: novoObjeto.tempoGasto,
                    Tempo_em_expediente: novoObjeto.tempoGastoProcesso
                }
            )
            novoObjeto = {};
            ultimoObj = objeto.values[x].NUM_PROCES;
        }
    }

    dataExcel.Processos = solicitacoes.map(proc => {
        const detalhesDoProcesso = detalhesSolicitacao.filter(det => det.Solicitação === proc.Solicitação);
        return { ...proc, ...Object.assign({}, ...detalhesDoProcesso) };
    })

    return novoObjetoSaida;
}

function stringParaData(dataHoraString) {
    const [data, hora] = dataHoraString.split(' ');
    const [dia, mes, ano] = data.split('/').map(Number);
    const [horas, minutos, segundos] = hora.split(':').map(Number);
    return new Date(ano, mes - 1, dia, horas, minutos, segundos);
}

function calcularIntervaloEmSegundos(dataHoraInicio, dataHoraFim) {
    // Função para converter a string no formato "dd/MM/yyyy HH:mm:ss" em um objeto Date

    const inicio = stringParaData(dataHoraInicio);
    const fim = stringParaData(dataHoraFim);

    // Calcular a diferença em milissegundos
    const diferencaEmMilissegundos = fim - inicio;

    // Converter milissegundos para segundos
    const diferencaEmSegundos = diferencaEmMilissegundos / 1000;

    return diferencaEmSegundos;
}

function maiorData(dataHora1, dataHora2, dataHora3) {
    const data1 = stringParaData(dataHora1);
    const data2 = stringParaData(dataHora2);
    const data3 = stringParaData(dataHora3);

    let maiorData = data1;
    if (data2 > maiorData) {
        maiorData = data2;
    }
    if (data3 > maiorData) {
        maiorData = data3;
    }

    return maiorData;
}


function converterSegundos(segundos) {
    const umAnoEmSegundos = 365 * 86400;
    const umMesEmSegundos = 30 * 86400;
    const umDiaEmSegundos = 86400;
    const umaHoraEmSegundos = 3600;
    const umMinutoEmSegundos = 60;

    const anos = Math.floor(segundos / umAnoEmSegundos);
    segundos %= umAnoEmSegundos;

    const meses = Math.floor(segundos / umMesEmSegundos);
    segundos %= umMesEmSegundos;

    const dias = Math.floor(segundos / umDiaEmSegundos);
    segundos %= umDiaEmSegundos;

    const horas = Math.floor(segundos / umaHoraEmSegundos);
    segundos %= umaHoraEmSegundos;

    const minutos = Math.floor(segundos / umMinutoEmSegundos);
    segundos %= umMinutoEmSegundos;

    const segundosRestantes = segundos;

    const textoAnos = anos === 1 ? 'ano' : 'anos';
    const textoMeses = meses === 1 ? 'mês' : 'meses';
    const textoDias = dias === 1 ? 'dia' : 'dias';
    const textoHoras = horas === 1 ? 'hora' : 'horas';
    const textoMinutos = minutos === 1 ? 'minuto' : 'minutos';
    const textoSegundos = segundosRestantes === 1 ? 'segundo' : 'segundos';

    let resultado = '';
    if (anos > 0) resultado += `${anos} ${textoAnos}, `;
    if (meses > 0) resultado += `${meses} ${textoMeses}, `;
    if (dias > 0) resultado += `${dias} ${textoDias}, `;
    if (horas > 0) resultado += `${horas} ${textoHoras}, `;
    if (minutos > 0) resultado += `${minutos} ${textoMinutos}, `;
    resultado += `${segundosRestantes} ${textoSegundos}`;

    // Remover a vírgula extra se houver
    resultado = resultado.replace(/,\s*$/, '');

    return resultado;
}

function convertSecondsToHoursAndMinutes(seconds) {
    const totalMinutes = Math.floor(seconds / 60);
    const hours = Math.floor(totalMinutes / 60);
    const minutes = totalMinutes % 60;
    return `${hours}:${minutes.toString().padStart(2, '0')}`;
}

function mudaCorStatus(params) {
    switch (params) {
        case "0" || 0: return "text-success";
        case "1" || 1: return "text-warning";
        case "2" || 2: return "text-danger";
        default: return params;
    }
}

function mudaAvalicao(params) {
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
