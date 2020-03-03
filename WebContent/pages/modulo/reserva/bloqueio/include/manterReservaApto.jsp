<%@ page contentType="text/html;charset=iso-8859-1" import="com.mozart.model.vo.ReservaApartamentoVO"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>


<jsp:scriptlet>
        String  base = request.getRequestURL().toString().substring(0, request.getRequestURL().toString().indexOf(request.getContextPath())+request.getContextPath().length()+1);
        session.setAttribute("URL_BASE", base);
        response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
	response.setHeader("Cache-Control","no-store, no-cache, must-revalidate");
	response.addHeader("Cache-Control", "post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
</jsp:scriptlet>

<html>
    <head> 
    <base href="<%=base%>" />
      <jsp:include page="/pages/modulo/includes/headPage.jsp" />
    </head>
<script type="text/javascript">

$(function() {

	$.datepicker.setDefaults($.datepicker.regional['pt-BR']);
	
	$(".dp").datepicker({
		showOn: 'button',
		buttonImage: 'imagens/iconic/png/calendar-2x.png',
		buttonImageOnly: true,
		dateFormat: 'dd/mm/yy',
		numberOfMonths: [1,2]
		         		
	});
	
	
});

function abrirHospede(indice, qtdePax, corTipo){
    if (corTipo == 'Olive' || corTipo == 'Aqua')
       alerta('Não é possivel adicionar/remover hospede em apartamento com checkin.');
    else {
       document.forms[0].indiceResApto.value = indice;
       parent.abrirHospede(indice,qtdePax);
    }
}



function adicionarHospede(nomeHospede){
    document.forms[0].action = '<s:url namespace="/app/bloqueio" action="include" method="adicionarHospede" />';
    document.forms[0].nomeHospede.value = nomeHospede;
    submitForm(document.forms[0]);
}

function excluirHospede(idxResApto, idxHospede ){
    document.forms[0].action = '<s:url namespace="/app/bloqueio" action="include" method="excluirHospede" />';
    document.forms[0].indiceResApto.value = idxResApto;
    document.forms[0].indiceHospede.value = idxHospede;
    submitForm(document.forms[0]);
}

function excluirResApto(idxResApto, corTipo){    
    if (corTipo == 'Olive' || corTipo == 'Aqua')
        alerta('- Não é possivel excluir apartamento com checkin.');
    else if (corTipo == 'todosApt') {
        if (window.confirm('- Deseja excluir todos apartamentos sem checkin?')) {
            document.forms[0].action = '<s:url namespace="/app/bloqueio" action="include" method="excluirReservaApto" />';
            document.forms[0].indiceResApto.value = -1;
            submitForm(document.forms[0]);
        }            
    }
    else {
        document.forms[0].action = '<s:url namespace="/app/bloqueio" action="include" method="excluirReservaApto" />';
        document.forms[0].indiceResApto.value = idxResApto;
        submitForm(document.forms[0]);
    }
}

function validaECarregaApartamentos(indice){
    erro = '';    
    campoDataEntrada = '';
    campoDataSaida = '';
    campoIdTipoApartamento = '';
    
    if (indice=='' || indice == null) {
        campoDataEntrada = 'reservaApartamentoVO.bcDataEntrada';
        campoDataSaida = 'reservaApartamentoVO.bcDataSaida';
        campoIdTipoApartamento = 'reservaApartamentoVO.bcIdTipoApartamento';
        
        var idApartamentoChart = parent.document.forms[0].elements["idApartamentoChart"].value;	
        if (idApartamentoChart != '' && idApartamentoChart != null) {
        	var dtEnt = parent.document.forms[0].elements["reservaVO.bcDataEntrada"].value;
        	var dtSai = parent.document.forms[0].elements["reservaVO.bcDataSaida"].value;
	    	document.getElementById(campoDataEntrada).value = dtEnt;
        	document.getElementById(campoDataSaida).value = dtSai;        	
	    }
    }
    else {        
        campoDataEntrada = 'bcDataEntrada'+indice;
        campoDataSaida = 'bcDataSaida'+indice;
        campoIdTipoApartamento = 'bcIdTipoApartamento'+indice;
    }
        
    dataEntrada = document.getElementById(campoDataEntrada).value;
    if (dataEntrada=='')
        erro +='- Inserir a data de entrada.\n';
    dataSaida = document.getElementById(campoDataSaida).value;
    if (dataSaida=='')
        erro +='- Inserir a data de saida.\n';
    idTipoApartamento = document.getElementById(campoIdTipoApartamento).value;
    
    if (erro!='') {
        alerta('Para pesquisar os apartamentos é necessário:\n'+erro);
        return false;
    }
    else {        
    	loading();
        submitFormAjax('carregarApartamentos?dataEntrada='+dataEntrada+'&dataSaida='+dataSaida+'&idTipoApartamento='+idTipoApartamento+'&indiceResApto='+indice,true);
        killModal();
    }        
}

function calculaTotalDiariaManual(indice) {    
    
    valorDataEntrada = '';
    valorDataSaida = '';
    campoDataEntrada = '';
    campoDataSaida = '';
    campoTarifa = '';
    campoTotalTarifa = '';
    
    if (indice=='' || indice==null) {        
        campoDataEntrada = 'reservaApartamentoVO.bcDataEntrada';
        campoDataSaida = 'reservaApartamentoVO.bcDataSaida';    
        campoTarifa = 'reservaApartamentoVO.bcTarifa';
        campoTotalTarifa = 'reservaApartamentoVO.bcTotalTarifa';
    }
    else {        
        campoDataEntrada = 'bcDataEntrada'+indice;
        campoDataSaida = 'bcDataSaida'+indice;
        campoTarifa = 'bcTarifa'+indice;
        campoTotalTarifa = 'bcTotalTarifa'+indice;
    }  
    
    valorDataEntrada = document.getElementById(campoDataEntrada).value;                        
    valorDataSaida = document.getElementById(campoDataSaida).value;
    

    if (valorDataEntrada!='' && valorDataSaida!='') {
        dias = pegaDiferencaDiasDatas(valorDataSaida,valorDataEntrada);        
        valor = parseFloat( document.getElementById(campoTarifa).value.replace('.','').replace(',','.') );
        if (dias > 0)
            valor = valor * dias;        
        else         
            valor = 0;
        valor = arredondaFloat(valor);
        valorString = ''+valor;        
        document.getElementById(campoTotalTarifa).value = valorString.replace('.',',');
    }    
}



function verificaCalculoDiariaManual(indice) {        
    erro = '';    
    
    campoDataEntrada = '';
    campoDataSaida = '';
    campoTarifaManual = '';
    if (indice=='' || indice==null) {        
        campoDataEntrada = 'reservaApartamentoVO.bcDataEntrada';
        campoDataSaida = 'reservaApartamentoVO.bcDataSaida';
        campoTarifaManual = 'reservaApartamentoVO.bcTarifaManual';
    }
    else {        
        campoDataEntrada = 'bcDataEntrada'+indice;
        campoDataSaida = 'bcDataSaida'+indice;
        campoTarifaManual = 'bcTarifaManual'+indice;
    }        
    
    if (pegaDiferencaDiasDatas(document.getElementById(campoDataEntrada).value,parent.document.getElementById('reservaVO.bcDataEntrada').value) < 0) {
        erro += '- Data de entrada do apartamento não pode ser menor do que a data de entrada da reserva.\n';
        document.getElementById(campoDataEntrada).value = '';
    }            
    if (pegaDiferencaDiasDatas(document.getElementById(campoDataSaida).value,parent.document.getElementById('reservaVO.bcDataSaida').value) > 0) {
        erro += '- Data de saida do apartamento não pode ser maior do que a data de saida da reserva.\n';
        document.getElementById(campoDataSaida).value = '';
    }
    if (pegaDiferencaDiasDatas(document.getElementById(campoDataSaida).value,document.getElementById(campoDataEntrada).value) < 0) {
        erro += '- Data de saida do apartamento não pode ser menor do que a data de entrada.\n';
        document.getElementById(campoDataSaida).value = '';
    }
    
    if (erro!='')
        alerta(erro);
    
    if (document.getElementById(campoTarifaManual).value=='S' && erro == '')
        calculaTotalDiariaManual(indice);
    
    
}

function inicializaTela() {
    exibeEscondeTarifaManual('');
    habilitaDesabilitaDataManual('');
}

function exibeEscondeTarifaManual(indice) {
    
    divLabelValorDiario = 'divTarifaManualVRDIARIODESC'+indice;
    divLabelValorTotal = 'divTarifaManualVRTOTALDESC'+indice;
    divValorDiario = 'divTarifaManualVRDIARIO'+indice;
    divValorTotal = 'divTarifaManualVRTOTAL'+indice;
    campoTarifaManual = '';
    
    if (indice=='' || indice == null)
        campoTarifaManual = 'reservaApartamentoVO.bcTarifaManual';
    else
        campoTarifaManual = 'bcTarifaManual'+indice;
    
    
    tarifaManual = document.getElementById(campoTarifaManual).value;
    if (tarifaManual=='S') {
        document.getElementById(divValorDiario).style.display='block';
        document.getElementById(divValorTotal).style.display='block';        
        if (indice!='' && indice != null) {
            document.getElementById(divLabelValorDiario).style.display='block';  
            document.getElementById(divLabelValorTotal).style.display='block';        
        }
    }
    else {
        document.getElementById(divValorDiario).style.display='none';
        document.getElementById(divValorTotal).style.display='none';
        if (indice!='' && indice != null) {
            document.getElementById(divLabelValorDiario).style.display='none';  
            document.getElementById(divLabelValorTotal).style.display='none';        
        }
    }
}

function habilitaDesabilitaDataManual(indice) {
    campoDataManual = '';
    campoDataEntrada = '';
    campoDataSaida = '';
    campoDataInIco = 'dataInIco'+indice;
    campoDataOutIco = 'dataOutIco'+indice;
    if (indice == '' || indice == null) {
        campoDataManual = 'reservaApartamentoVO.bcDataManual';
        campoDataEntrada = 'reservaApartamentoVO.bcDataEntrada';
        campoDataSaida = 'reservaApartamentoVO.bcDataSaida';        
    }
    else {
        campoDataManual = 'bcDataManual'+indice;
        campoDataEntrada = 'bcDataEntrada'+indice;
        campoDataSaida = 'bcDataSaida'+indice;        
    }
    
    if (document.getElementById(campoDataManual).value=='S') {
        document.getElementById(campoDataEntrada).readOnly = 0;
        document.getElementById(campoDataSaida).readOnly = 0;
        document.getElementById(campoDataInIco).disabled = 0;
        document.getElementById(campoDataOutIco).disabled = 0;
    }
    else {
        document.getElementById(campoDataEntrada).readOnly = 1;
        document.getElementById(campoDataSaida).readOnly = 1;
        document.getElementById(campoDataInIco).disabled = 1;
        document.getElementById(campoDataOutIco).disabled = 1;
    }
}

function verificaResAptoDadosInseridos() {
    erro = '';
    if (parent.document.getElementById('empresaHotelVO.bcNomeFantasia').value=='')
        erro += '- Selecione a empresa.\n';
    if (parent.document.getElementById('empresaHotelVO.bcIdEmpresa').value=='')
        erro += '- Selecione a empresa.\n';
    if (document.getElementById('reservaApartamentoVO.bcDataEntrada').value=='')
        erro += '- Insira a data de entrada.\n';
    if (document.getElementById('reservaApartamentoVO.bcDataSaida').value=='')
        erro += '- Insira a data de saída.\n';
    if (document.getElementById('reservaApartamentoVO.bcIdTipoApartamento').value=='')
        erro += '- Selecione o tipo de apartamento.\n';
    if (document.getElementById('reservaApartamentoVO.bcQtdePax').value=='0')
        erro += '- Selecione o pax.\n';    
    if (document.getElementById('reservaApartamentoVO.bcQtdeApartamento').value=='')
        erro += '- Insira a quantidade de apartamento.\n';    
    if (erro == '') {

    	document.getElementById('reservaVO.bcCalculaIss').value = parent.document.getElementById('reservaVO.bcCalculaIss').value;
    	document.getElementById('reservaVO.bcCalculaTaxa').value = parent.document.getElementById('reservaVO.bcCalculaTaxa').value;
    	document.getElementById('reservaVO.bcCalculaRoomTax').value = parent.document.getElementById('reservaVO.bcCalculaRoomTax').value;
    	document.getElementById('reservaVO.bcCalculaSeguro').value = parent.document.getElementById('reservaVO.bcCalculaSeguro').value;
    	document.getElementById('idMoeda').value = parent.document.getElementById('idMoeda').value;
    	document.getElementById('isBloqueio').value = parent.document.getElementById('isBloqueio').value;
        submitFormAjax('verificaApartamentoJaEscolhido?idApartamento='+ document.getElementById('reservaApartamentoVO.bcIdApartamento').value+'&indiceResApto=-1&onSucess=document.getElementById("reservaVO.bcGrupo").value="'+parent.document.getElementById('reservaVO.bcGrupo').value+'";submitForm(document.forms[0])',true);
    }
            
    else 
        alerta(erro);                
}

function editarResApto(indice,corTipo) {            
    if (corTipo == 'Olive' || corTipo == 'Aqua')
        alerta('- Não é possivel editar apartamento com checkin.');
    else    
        submitFormAjax('editarReservaApartamentoInformacoes?indiceResApto='+indice,true);

}
function atualizarResApto(indice) {    
    
    erro = '';
    if (document.getElementById('bcDataEntrada'+indice).value=='')
        erro += '- Insira a data de entrada.\n';
    if (document.getElementById('bcDataSaida'+indice).value=='')
        erro += '- Insira a data de saida.\n';    
    if (document.getElementById('bcIdTipoApartamento'+indice).value=='0')
        erro += '- Selecione o tipo de apartamento.\n';
    if (document.getElementById('bcQtdePax'+indice).value=='')
        erro += '- Selecione a quantidade de pax.\n';
    if (document.getElementById('bcQtdeApartamento'+indice).value=='')
        erro += '- Insira a qtde de apartamento.\n';
    if (document.getElementById('bcTarifaManual'+indice).value=='S' && document.getElementById('bcTarifa'+indice).value=='')
        erro += '- Insira o valor da tarifa.\n';
    if (document.getElementById('bcQtdeCrianca'+indice).value=='')
        erro += '- Insira a qtde de crianças.\n';                                                                                                                                                                                                                                                                        
    
    if (erro=='') {            
        saIdApartamento = document.getElementById('bcIdApartamento'+indice).value;        
        submitFormAjax('verificaApartamentoJaEscolhido?idApartamento='+ saIdApartamento +'&indiceResApto='+indice+'&onSucess=atualizaResAptoChamadoViaAjax('+indice+')',true);        
    }
    else {
        alerta(erro);
    }
}

function atualizaResAptoChamadoViaAjax(indice) {
        saDataEntrada = document.getElementById('bcDataEntrada'+indice).value;
        saDataSaida = document.getElementById('bcDataSaida'+indice).value;
        saIdTipoApartamento = document.getElementById('bcIdTipoApartamento'+indice).value;
        saQtdePax = document.getElementById('bcQtdePax'+indice).value;
        saIdTipoDiaria = document.getElementById('bcIdTipoDiaria'+indice).value;
        saQtdeApartamento = document.getElementById('bcQtdeApartamento'+indice).value;
        saTarifa = document.getElementById('bcTarifa'+indice).value;
        saTotalTarifa = document.getElementById('bcTotalTarifa'+indice).value;
        saQtdeCrianca = document.getElementById('bcQtdeCrianca'+indice).value;
        saIdApartamento = document.getElementById('bcIdApartamento'+indice).value;
        saTarifaManual = document.getElementById('bcTarifaManual'+indice).value;
        saDataManual = document.getElementById('bcDataManual'+indice).value;
        document.getElementById('idMoeda').value = parent.document.getElementById('idMoeda').value;
                
        document.getElementById('divEditarResApto'+indice).style.display='none';
        document.getElementById('divCorrenteResApto'+indice).style.display='block';
        //Colocando o label de tarifa e total tarifa para exibir sempre
        document.getElementById('divTarifaManualVRDIARIODESC'+indice).style.display='block';
        document.getElementById('divTarifaManualVRTOTALDESC'+indice).style.display='block';
        submitFormAjax('atualizarReservaApartamentoInformacoes?idMoeda='+document.getElementById('idMoeda').value+'&calculaISS='+parent.document.getElementById('reservaVO.bcCalculaIss').value+'&calculaTaxa='+parent.document.getElementById('reservaVO.bcCalculaTaxa').value+'&calculaRoomTax='+parent.document.getElementById('reservaVO.bcCalculaRoomTax').value+'&calculaSeguro='+parent.document.getElementById('reservaVO.bcCalculaSeguro').value+'&indiceResApto='+indice+'&saDataEntrada='+saDataEntrada+'&saDataSaida='+saDataSaida+'&saIdTipoApartamento='+saIdTipoApartamento+'&saQtdePax='+saQtdePax+'&saIdTipoDiaria='+saIdTipoDiaria+'&saQtdeApartamento='+saQtdeApartamento+'&saTarifa='+saTarifa+'&saTotalTarifa='+saTotalTarifa+'&saQtdeCrianca='+saQtdeCrianca+'&saIdApartamento='+saIdApartamento+'&saTarifaManual='+saTarifaManual+'&saDataManual='+saDataManual,true); 
}

function alterarDiarias(indiceResApto,corTipo) {
    if (corTipo == 'Olive' || corTipo == 'Aqua')
        alerta('Não é possivel editar apartamento com checkin.');
    else    
        submitFormAjax('colocaReservaApartamentoDiariaNaSessao?indiceResApto='+indiceResApto,true);
}


function atualizar() {
	document.getElementById('reservaVO.bcCalculaIss').value = parent.document.getElementById('reservaVO.bcCalculaIss').value;
	document.getElementById('reservaVO.bcCalculaTaxa').value = parent.document.getElementById('reservaVO.bcCalculaTaxa').value;
	document.getElementById('reservaVO.bcCalculaRoomTax').value = parent.document.getElementById('reservaVO.bcCalculaRoomTax').value;
	document.getElementById('reservaVO.bcCalculaSeguro').value = parent.document.getElementById('reservaVO.bcCalculaSeguro').value;
	document.getElementById('idMoeda').value = parent.document.getElementById('idMoeda').value;
	
	document.forms[0].action = '<s:url value="app/bloqueio/include!prepararReservaApto.action"/>';
	document.forms[0].submit();
}

</script>

<body style="margin:0px;" onload="inicializaTela();">

    
          
<div class="divGrupo" style="overflow: auto; margin-top:0px;width:965px; height:98%; border:0px;">
<s:form namespace="/app/bloqueio" action="include!adicionarReservaApto" theme="simple">
                <input type="hidden" id="reservaVO.bcGrupo" name="reservaVO.bcGrupo"/>
                
                <input type="hidden" id="idMoeda" name="idMoeda"/>
                <input type="hidden" id="reservaVO.bcCalculaIss" name="reservaVO.bcCalculaIss"/>
                <input type="hidden" id="reservaVO.bcCalculaTaxa" name="reservaVO.bcCalculaTaxa"/>
                <input type="hidden" id="reservaVO.bcCalculaRoomTax" name="reservaVO.bcCalculaRoomTax"/>
                <input type="hidden" id="reservaVO.bcCalculaSeguro" name="reservaVO.bcCalculaSeguro"/>
                
                <s:hidden name="indiceResApto" id="indiceResApto"  />
                <s:hidden name="indiceHospede" />
                <s:hidden name="nomeHospede" />
                <s:hidden name="origemCRS" />
                <s:hidden name="isBloqueio" id="isBloqueio" />
                <div class="divLinhaCadastroPrincipal" style="width:99%; float:left; height: 40px;">
                    <div class="divItemGrupo" style="width:75pt;" ><p style="color:white;" >Data in:</p><br class="clear"/> 
                                <s:textfield cssClass="dp" name="reservaApartamentoVO.bcDataEntrada" onchange="verificaCalculoDiariaManual('');" onblur="dataValida(this);verificaCalculoDiariaManual('');" onkeypress="mascara(this,data);" id="reservaApartamentoVO.bcDataEntrada" size="8" maxlength="10" />
                    </div>
                    <div class="divItemGrupo" style="width:75pt;" ><p style="color:white;">Data out:</p><br class="clear"/> 
                                <s:textfield cssClass="dp" name="reservaApartamentoVO.bcDataSaida" onchange="verificaCalculoDiariaManual('');" onblur="dataValida(this)verificaCalculoDiariaManual('');" onkeypress="mascara(this,data);" id="reservaApartamentoVO.bcDataSaida" size="8" maxlength="10" />
                    </div>
                    <div class="divItemGrupo" style="width:35pt;" ><p style="width:35pt;color:white;">Tipo:</p> <br/>
                            <s:select list="listTipoApto" cssStyle="width:35pt;" id="reservaApartamentoVO.bcIdTipoApartamento" onchange="validaECarregaApartamentos('');" name="reservaApartamentoVO.bcIdTipoApartamento" listKey="bcIdTipoApartamento" listValue="bcFantasia"/>
                    </div>
                    <div class="divItemGrupo" style="width:45pt;" ><p style="width:55pt;color:white;">Pax:</p> <br/>
                           <s:select list="listTipoPax" cssStyle="width:45pt;" name="reservaApartamentoVO.bcQtdePax" id="reservaApartamentoVO.bcQtdePax" listKey="bcIdTipoPax" listValue="bcDescricao"/>
                    </div>
                    <div class="divItemGrupo" style="width:55pt;" ><p style="width:65pt;color:white;">Tipo da diária:</p> <br/>
                            <s:select list="listTipoDiaria" cssStyle="width:55pt;" name="reservaApartamentoVO.bcIdTipoDiaria" id="reservaApartamentoVO.bcIdTipoDiaria" listKey="bcIdTipoDiaria" listValue="bcDescricao"/>
                    </div>
                    <div class="divItemGrupo" style="width:25pt;" ><p style="width:25pt;color:white;">Qt.Ap:</p><br/>
                        <s:textfield name="reservaApartamentoVO.bcQtdeApartamento" id="reservaApartamentoVO.bcQtdeApartamento" cssStyle="width: 25px;" maxlength="2" />                         
                    </div>
                    <div id="divTarifaManualVRDIARIO" class="divItemGrupo" style="width:45pt;" ><p style="width:45pt;color:white;">Vr.Diário:</p><br/>
                        <s:textfield name="reservaApartamentoVO.bcTarifa" id="reservaApartamentoVO.bcTarifa" onblur="calculaTotalDiariaManual('');" onkeypress="mascara( this, moeda );" cssStyle="width: 45px;"  /> 
                    </div>
                    <div id="divTarifaManualVRTOTAL" class="divItemGrupo" style="width:45pt;" ><p style="width:45pt;color:white;">Vr.Total:</p><br/>
                        <s:textfield name="reservaApartamentoVO.bcTotalTarifa" id="reservaApartamentoVO.bcTotalTarifa" readonly="true" onkeypress="mascara( this, moeda );" cssStyle="width: 45px;"  /> 
                    </div>
                    <div class="divItemGrupo" style="width:35pt;" ><p style="width:30pt;color:white;">Cri:</p><br/>
                        <s:textfield name="reservaApartamentoVO.bcQtdeCrianca" id="reservaApartamentoVO.bcQtdeCrianca" size="2" maxlength="2" /> 
                    </div>
                    <div class="divItemGrupo" style="width:55pt;" ><p style="width:55pt;color:white;">Apto:</p><br/>                                                        
                            <select Style="width:55pt;"  name="reservaApartamentoVO.bcIdApartamento" id="reservaApartamentoVO.bcIdApartamento"> </select>                            
                    </div>
                    <div class="divItemGrupo" style="width:50pt;" ><p style="width:40pt;color:white;">Tar. Man.:</p><br/>
                            <select name="reservaApartamentoVO.bcTarifaManual" onchange="exibeEscondeTarifaManual('');" id="reservaApartamentoVO.bcTarifaManual" style="width:40pt;">                                
                                <option value="N">Não</option>
                                <option value="S">Sim</option>
                            </select>
                    </div>
                    <div class="divItemGrupo" style="width:50pt;" ><p style="width:50pt;color:white;">Dat. Man.:</p><br/>
                            <select name="reservaApartamentoVO.bcDataManual" id="reservaApartamentoVO.bcDataManual" onchange="habilitaDesabilitaDataManual('');" style="width:40pt;">                                
                                <option value="N">Não</option>
                                <option value="S">Sim</option>
                            </select>                            
                    </div>                    
                  
                   <div class="divItemGrupo" style="width:70pt;" >
                   		<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png" title="Adicionar reserva apartamento" style="margin:0px;" onclick="verificaResAptoDadosInseridos();"/>
                   		<img width="30px" height="30px" src="imagens/iconic/png/x-3x.png" title="Excluir todos apartamento"  onclick="excluirResApto('${row.index}','todosApt');"/>
                   		<s:if test="%{#session.TELA_RESERVA_RESERVA_APARTAMENTO.size() > 0}" >
                   			<img width="30px" height="30px" src="imagens/iconRoomList.png" id="iconaa5" title="Preencher o room list" onclick="parent.exibeDivRoomList();" >
                   		</s:if>
                  </div>
              
                   
                  <!--
                  <div class="divBotaoAcao" style="margin-top:5px;margin-right:5px;width:30px;height:30px;float:right;" onclick="verificaResAptoDadosInseridos();" onmousedown="this.className='divBotaoAcaoClick'" onmouseup="this.className='divBotaoAcaoOver'"  onmouseout="this.className='divBotaoAcao'" onmouseover="this.className='divBotaoAcaoOver'">
                    <img src="imagens/adicionar.gif" title="Adicionar reserva apartamento" style="margin:0px;"/>                      
                  </div>
                  <div class="divBotaoAcao" style="margin-top:5px;margin-right:5px;width:16px;height:30px;float:right;" >
                    <img style="float:right;width:15.5px;" title="Excluir todos apartamento" src="imagens/excluir.png" onclick="excluirResApto('${row.index}','todosApt');"/> 
                  </div>
                  -->
                </div>
                
                <s:iterator value="#session.TELA_RESERVA_RESERVA_APARTAMENTO" var="resAptoCorr" status="row" >

                    <div style="display:none;"> gamb  ${row.index} </div>
                    
                    <s:set name="display" value="%{'block'}" />                    
                    <s:if test='%{bcGrupoSimNao == null }%'>
                        <s:set name="display" value="%{'none'}" />
                    </s:if>
                    
                    <s:set name="gridCor" value="%{'rgb(255,165,165)'}" />
                    <s:if test='%{"S".equals(bcCheckout)}%'>
                        <s:set name="gridCor" value="%{'Olive'}" />
                    </s:if>
                    <s:elseif test='%{ "1".equals(bcQtdeCheckin.toString()) }'>
                        <s:set name="gridCor" value="%{'Aqua'}" />
                    </s:elseif>                                         
                    <s:elseif test='%{ "S".equals(bcNoShow) }'>
                        <s:set name="gridCor" value="%{'Yellow'}" />
                    </s:elseif>                                         
                                                            
                    <div class="divLinhaCadastro" id="divLinha${row.index}" style="background-color: <s:property value="#gridCor"  />;">                            
                            <div class="divItemGrupo" style="width:20pt;" ><img class="imgLinha" id="img${row.index}" title="Visualizar dados da reserva apartamento" src='${row.index eq indiceResApto ? "imagens/menos.png" : "imagens/mais.png"}' /></div>
                            <div class="divItemGrupo" style="width:20pt;" ><img id="${row.index}" title="Adicionar os hóspedes" src="imagens/hospede.png" onclick='abrirHospede(${row.index}, <s:property value="bcQtdePax"/>, "<s:property value="#gridCor"/>");' class="addHospede"/></div>
                            <div class="divItemGrupo" style="width:200pt;" id="divHospedePrincipal${row.index}" ><p style="width:100%;"><s:property  value="bcNomePrimeiroHospede" /></p></div>
                            <div class="divItemGrupo" style="width:100px;" ><p style="float:left; width:30px;">Apto:&nbsp;</p> <p style="float:left;width:65px;" id="divBcApartamentoTituloDesc${row.index}" > <s:property  value="bcApartamentoDesc" /> </p> </div>
                            <div class="divItemGrupo" style="width:115pt;" id="divBcPeriodoTituloDesc${row.index}" > <s:property  value="bcDataEntrada" /> - <s:property  value="bcDataSaida" /> </div>
                            <div class="divItemGrupo" style="width:30pt;float:right;" ><img title="Excluir reserva apartamento" src="imagens/iconic/png/x-3x.png" onclick="excluirResApto('${row.index}','<s:property value="#gridCor"/>');"/></div>                            
                            <div class="divItemGrupo" style="width:65pt;display:<s:property value="#display"  />; " >Loc: <s:property  value="bcIdReserva" /></div>
                    </div>
                    <div id="divLinhaCadastroPrincipalimg${row.index}"  style='display:${row.index eq indiceResApto ? "block" : "none"}'>
                        <div class="divLinhaCadastro" style="display:none;" >
                            <div class="divItemGrupo" style="background-color:white;" ><p style="width:120pt">Dados do apartamento:</p></div>
                        </div>
                        <div class="divLinhaCadastro" >
                            <div class="divItemGrupo" style="width:20pt;" ></div>
                            <div class="divItemGrupo" style="width:75pt;" ><p><b>Data in</b></p></div>
                            <div class="divItemGrupo" style="width:75pt;" ><p><b>Data out</b></p></div>
                            <div class="divItemGrupo" style="width:45pt;" ><p style="width:40pt;"><b>Tipo</b></p></div>
                            <div class="divItemGrupo" style="width:40pt;" ><p style="width:60pt;"><b>Pax</b></p></div>
                            <div class="divItemGrupo" style="width:65pt;" ><p style="width:60pt;"><b>Tipo diaria:</b></p></div>
                            <div class="divItemGrupo" style="width:25pt;" ><p style="width:30pt"><b>Qt.Ap.</b></p></div>
                            <div class="divItemGrupo" style="width:55pt;" id="divTarifaManualVRDIARIODESC${row.index}" ><p style="width:30pt"><b>Vr.Diário.</b></p></div>                            
                            <div class="divItemGrupo" style="width:45pt;" id="divTarifaManualVRTOTALDESC${row.index}" ><p style="width:30pt"><b>Vr.Total.</b></p></div>
                            <div class="divItemGrupo" style="width:20px;" ></div>
                            <div class="divItemGrupo" style="width:25pt;" ><p style="width:30pt"><b>Cri.</b></p></div>
                            <div class="divItemGrupo" style="width:45pt;" ><p style="width:40pt"><b>Apto</b></p></div>
                            <div class="divItemGrupo" style="width:40pt;" ><p style="width:40pt"><b>Tar.Man.</b></p></div>
                            <div class="divItemGrupo" style="width:40pt;"><p style="width:50pt"><b>Dat.Man.</b></p></div>
                        </div>
                        <div class="divLinhaCadastro" id="divCorrenteResApto${row.index}" style="display:block;" >
                            <div class="divItemGrupo" style="width:20pt;" onclick="editarResApto('${row.index}','<s:property value="#gridCor"  />');" ><img title="Editar" src="imagens/btnAlterar.png" /></div>
                            <div class="divItemGrupo" id="divBcDataEntrada${row.index}" style="width:75pt;" ><p><s:property  value="bcDataEntrada" /></p></div>
                            <div class="divItemGrupo" id="divBcDataSaida${row.index}" style="width:75pt;" ><p><s:property  value="bcDataSaida" /></p></div>
                            <div class="divItemGrupo" id="divBcTipoApartamentoDesc${row.index}" style="width:45pt;" ><p style="width:40pt;"><s:property  value="BcTipoApartamentoDesc" /></p></div>
                            <div class="divItemGrupo" id="divBcQtdePaxDesc${row.index}" style="width:40pt;" ><p style="width:60pt;"><s:property  value="bcQtdePaxDesc" /></p></div>
                            <div class="divItemGrupo" id="divBcTipoDiariaDesc${row.index}" style="width:65pt;" ><p style="width:60pt;"><s:property  value="BcTipoDiariaDesc" /></p></div>
                            <div class="divItemGrupo" id="divBcQtdeApartamento${row.index}" style="width:25pt;" ><p style="width:30pt"><s:property  value="bcQtdeApartamento" /></p></div>
                            <div class="divItemGrupo" id="divBcTarifa${row.index}" style="width:55pt;" ><p style="width:30pt"><s:property  value="bcTarifa" /></p></div>
                            <div class="divItemGrupo" id="divBcTotalTarifa${row.index}" style="width:45pt;" ><p style="width:30pt"><s:property  value="bcTotalTarifa" /></p></div>
                            
                            <s:if test="%{#corTipo == 'Olive' || #corTipo == 'Aqua}">
                            	<div class="divItemGrupo" style="width:20px;" >&nbsp;</div>
                            </s:if>
                            <s:else>
								<div class="divItemGrupo" style="width:20px;" ><img title="Alterar diárias" src="imagens/btnAlterar.png" onclick="alterarDiarias('${row.index}','<s:property value="#gridCor"  />');" /></div>                            
                            </s:else>
                            
                            <div class="divItemGrupo" id="divBcQtdeCrianca${row.index}" style="width:25pt;" ><p style="width:30pt"><s:property  value="bcQtdeCrianca" /></p></div>
                            <div class="divItemGrupo" id="divBcApartamentoDesc${row.index}" style="width:45pt;" ><p style="width:40pt"><s:property  value="bcApartamentoDesc" /></p></div>
                            <div class="divItemGrupo" id="divBcTarifaManualDesc${row.index}" style="width:40pt;" ><p style="width:40pt"><s:property  value="bcTarifaManualDesc" /></p></div>
                            <div class="divItemGrupo" id="divBcDataManualDesc${row.index}" style="width:40pt;"><p style="width:50pt"><s:property  value="bcDataManualDesc" /></p></div>
                        </div> 
                        <div class="divLinhaCadastro" id="divEditarResApto${row.index}" style="display:none;" >                            
                            <div class="divItemGrupo" style="width:20pt;" onclick="atualizarResApto('${row.index}');" ><img title="Atualizar" src="imagens/iconic/png/check-4x.png" /></div>
                            <div class="divItemGrupo" style="width:75pt;" ><p>
                            	<input class="dp" type="text" style="width:65px;" onchange="verificaCalculoDiariaManual('${row.index}');" onblur="verificaCalculoDiariaManual('${row.index}');" id="bcDataEntrada${row.index}" name="bcDataEntrada${row.index}" onkeypress="mascara(this,data);"/>
                                </p>
                            </div>
                            <div class="divItemGrupo" style="width:75pt;" ><p>
                            <input class="dp" type="text" style="width:65px;" onchange="verificaCalculoDiariaManual('${row.index}');" onblur="verificaCalculoDiariaManual('${row.index}');" id="bcDataSaida${row.index}" name="bcDataSaida${row.index}" onkeypress="mascara(this,data);"/> 
                                </p>
                            </div>
                            <div class="divItemGrupo" style="width:45pt;" ><p style="width:40pt;"><select style="width:55px;" onchange="validaECarregaApartamentos('${row.index}');" id="bcIdTipoApartamento${row.index}" ></select> </p></div>
                            <div class="divItemGrupo" style="width:40pt;" ><p style="width:60pt;"><select style="width:65px;" id="bcQtdePax${row.index}" ></select> </p></div>
                            <div class="divItemGrupo" style="width:65pt;" ><p style="width:60pt;"><select style="width:70px;" id="bcIdTipoDiaria${row.index}" ></select></p></div>
                            <div class="divItemGrupo" style="width:25pt;" ><p style="width:30pt"><input style="width:20px;" type="text" id="bcQtdeApartamento${row.index}"/></p></div>
                            <div class="divItemGrupo" style="width:55pt;" id="divTarifaManualVRDIARIO${row.index}" ><p style="width:30pt"><input style="width:45px;" type="text" id="bcTarifa${row.index}" onblur="calculaTotalDiariaManual('${row.index}');" onkeypress="mascara( this, moeda );"/></p></div>
                            <div class="divItemGrupo" style="width:45pt;" id="divTarifaManualVRTOTAL${row.index}" ><p style="width:30pt"><input style="width:45px;" type="text" id="bcTotalTarifa${row.index}" readonly="readonly" onkeypress="mascara(this,moeda);" /></p></div>
                            <div class="divItemGrupo" style="width:20px;" ><img title="Alterar diárias" src="imagens/btnAlterar.png" onclick="alterarDiarias('${row.index}','<s:property value="#gridCor"  />');" /></div>
                            <div class="divItemGrupo" style="width:25pt;" ><p style="width:30pt"><input style="width:20px;" type="text" id="bcQtdeCrianca${row.index}"/></p></div>
                            <div class="divItemGrupo" style="width:45pt;" ><p style="width:40pt"><select style="width:65px;" id="bcIdApartamento${row.index}"></select> </p></div>
                            <div class="divItemGrupo" style="width:40pt;" ><p style="width:40pt"><select style="width:50px;" onchange="exibeEscondeTarifaManual('${row.index}');" id="bcTarifaManual${row.index}"><option value="N">Não</option><option value="S">Sim</option></select></p></div>
                            <div class="divItemGrupo" style="width:40pt;"><p style="width:50pt"><select style="width:50px;" onchange="habilitaDesabilitaDataManual('${row.index}');" id="bcDataManual${row.index}"><option value="N">Não</option><option value="S">Sim</option></select> </p></div>                            
                        </div>
                        <div class="divLinhaCadastro" >
                            <div class="divItemGrupo" style="background-color:white; width:70px;" ><p style="width:60px;">Hospedes:</p> </div>
                            <div class="divItemGrupo" style="background-color:white; width:85%;" >
                            	<p style="width:100%;" id="divHospede${row.index}" ><s:property value="bcNomesHospedes"/></p>
                            </div>
                        </div>                        
                        
                    </div>
                </s:iterator> 
</s:form>                
</div>

</body>
               

<script type="text/javascript">eval("<%=(String)request.getSession().getAttribute("SESSAO_JAVASCRIPT_RESERVAAPTO")%>");</script>
<%request.getSession().setAttribute("SESSAO_JAVASCRIPT_RESERVAAPTO",null);%>

<script  type="text/javascript">

var tipoAptoCRS = parent.document.forms[0].elements["idTipoAptoCRS"].value;
if (tipoAptoCRS != ''){
	document.forms[0].elements["reservaApartamentoVO.bcIdTipoApartamento"].value = tipoAptoCRS;
	validaECarregaApartamentos('');	
}

var idApartamentoChart = parent.document.forms[0].elements["idApartamentoChart"].value;
document.forms[0].elements["reservaApartamentoVO.bcIdApartamento"].value = idApartamentoChart;

</script>



</html>