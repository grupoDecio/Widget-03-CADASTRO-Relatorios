let ccComplete;
let oNewWindow;
let dataExcel = new Array();
let mydata = new Array();
let agrupadoPorNumProces = new Array();
document['instanceId'] = 0;
var relatorio_03_CADASTRO = SuperWidget.extend({
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
        filename = 'Relatorio.xlsx';
        var ws = XLSX.utils.json_to_sheet(dataExcel.values);
        var wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Processos");
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
        dataExcel = new Array();
        let constraints = [];
        let limite = String($(`[name='limite_${this.instanceId}']`).val()).trim();
        let NUM_PROCES = String($(`[name='NUM_PROCES_${this.instanceId}']`).val()).trim();
        let status = String($(`[name='status_${this.instanceId}']`).val()).trim();
        let data_sol_INI = String($(`[name='data_sol_INI_${this.instanceId}']`).val()).trim();
        let data_sol_FIM = String($(`[name='data_sol_FIM_${this.instanceId}']`).val()).trim();
        let NOMESOLICITANTE = String($(`[name='nomeSolicitante_${this.instanceId}']`).val()).trim();
        let CATEGORIA = String($(`[name='CATEGORIA_${this.instanceId}']`).val()).trim();
        let ZUNIDADE = String($(`[name='ZUNIDADE_${this.instanceId}']`).val()).trim();

        // if (limite != "") constraints.push(DatasetFactory.createConstraint('sqlLimit', limite, limite, ConstraintType.MUST));
        if (status != "") constraints.push(DatasetFactory.createConstraint('STATUS', status, status, ConstraintType.MUST));
        if (NUM_PROCES != "") constraints.push(DatasetFactory.createConstraint('NUM_PROCES', NUM_PROCES, NUM_PROCES, ConstraintType.MUST));
        if (NOMESOLICITANTE != "") constraints.push(DatasetFactory.createConstraint('nomeSolicitante', NOMESOLICITANTE, NOMESOLICITANTE, ConstraintType.MUST, true));
        if (CATEGORIA != "") constraints.push(DatasetFactory.createConstraint('CATEGORIA', CATEGORIA, CATEGORIA, ConstraintType.MUST, true));
        if (ZUNIDADE != "") constraints.push(DatasetFactory.createConstraint('ZUNIDADE', ZUNIDADE, ZUNIDADE, ConstraintType.MUST, true));
        if (data_sol_INI != "" && data_sol_FIM != "") constraints.push(DatasetFactory.createConstraint('START_DATE', converterDataParaFormatoMySQL(data_sol_INI), converterDataParaFormatoMySQL(data_sol_FIM), ConstraintType.MUST));

        dadosOriginais = DatasetFactory.getDataset("dsWidgetRel03Cadastro", null, constraints, null);

        if (dadosOriginais.values.length > 0) {
            agrupadoPorNumProces = {};
            dataExcel = trataRetorno(dadosOriginais, dadosOriginais.columns);
            console.log(dataExcel)

            let tpl = $('.template_datatable').html()
            let html = Mustache.render(tpl, dataExcel);
            $(`#mypanel_${this.instanceId}`).html(html);
        } else {
            console.log("Não foi encontrado nenhum item para esses filtros");
            $(`#mypanel_${this.instanceId}`).html("<b>Nenhum resultado encontrado para essa pesquisa</b>");
        }

    }
});

function trataRetorno(objeto, colunas) {
    let novoObjeto = {};
    let novoObjetoSaida = { values: [] };

    let ordemDesejada = colunas;
    let novoObjetoOrdenado = {};

    colunas.push("CORSTATUS")
    colunas.push("Avaliado")
    colunas.push("NUM_SUB_PROCES_LINK")

    objeto.values.forEach(item => {
        novoObjeto = item;
        novoObjeto.CORSTATUS = mudaCorStatus(item.STATUS);
        novoObjeto.Avaliado = mudaAvaliacao(item.Avaliado);
        novoObjeto.radioTipoProblema = mudaTipoProblema(item.radioTipoProblema);
        novoObjeto.NUM_SUB_PROCES_LINK = montaLinkSubProcesso(item.NUM_SUB_PROCES);

        ordemDesejada.forEach((campo) => {
            if (novoObjeto.hasOwnProperty(campo)) {
                novoObjetoOrdenado[campo] = novoObjeto[campo];
            }
        });

        novoObjetoSaida.values.push(novoObjetoOrdenado);
        novoObjeto = {};
        novoObjetoOrdenado = {};
    });
    console.log(colunas)
    console.log(novoObjetoSaida)
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

function mudaTipoProblema(params) {
    switch (params) {
        case "Pedido divergente": return "Pedido divergente";
        case "V&iacute;nculo": return "Cadastro x vínculo ou Fator de conversão";
        case "Vinculo": return "Cadastro x vínculo ou Fator de conversão";
        case "cadastro_item": return "Cadastro de item novo";
        case "cadastro_Fornecedor": return "Cadastro de novo fornecedor";
        case "nf_semPedido": return "NF sem pedido";
        default: return params;
    }
}

function montaLinkSubProcesso(listaSubProcessos) {
    let links = "";
    String(listaSubProcessos).split(",").forEach((item) => {
        let soNumero = String(item).replace(/[^\d.]+/g, "");
        links += `[<a href="/portal/p/1/pageworkflowview?app_ecm_workflowview_detailsProcessInstanceID=${String(soNumero).trim()}">${String(item).trim()}</a>] `
    });

    if (links != "") return links;
    else return false;
}

function converterDataParaFormatoMySQL(data) {
    var partesData = data.split('/');
    var dataFormatoMySQL = partesData[2] + '-' + partesData[1] + '-' + partesData[0];
    return dataFormatoMySQL;
}
