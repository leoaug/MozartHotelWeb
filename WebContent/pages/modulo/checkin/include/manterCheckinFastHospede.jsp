<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>
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

<%if (request.getServletPath().toLowerCase().indexOf("pesquisa") < 0 ){%>
<script language="javascript" type="text/javascript">loading();</script>
<%}else{%>
<script language="javascript" type="text/javascript">loadingPesquisa();</script>
<%}%>

</head>
<script type="text/javascript">



$(document).ready(function () {

$('img.addHospede').click(function (e) {
                document.forms[0].indiceResApto.value = this.id;
		parent.abrirHospede(this);
	});

});

<s:if test="#request.msgPai != null">
        setTimeout("mensagemPai()",2000);
</s:if>

function mensagemPai(){
    parent.mensagemFromIFrame("<s:property value='#request.msgPai'/>");
}

<s:if test="#session.ID_RES_PAG_ANTEC != null">
	vForm = parent.document.forms[0];
	vForm.action = '<s:url action="transferenciaDespesa!preparar.action" namespace="/app/caixa" />';
    parent.atualizar();
</s:if>

<s:if test="#request.submetePai != null">
    parent.atualizar();    
</s:if>


function abrirReserva(idReserva){
    loading();
    document.forms[0].idReserva.value = idReserva;
    submitForm( document.forms[0] );
    
}


function obterApartamento(tipoApto){
        vForm = document.forms[0];
        vForm.idxCheckin.value = $("select[name='idTipoApartamento']").index(tipoApto);
        vForm.action = '<s:url action="include!obterApartamento.action" namespace="/app/checkin" />';
        submitForm( vForm );        
}


function popupHospede(idxResApto, seguro){
        vUrl = '<s:url action="popupHospede!prepararPopupHospede.action" namespace="/app/checkin" />';
        vUrl = '<%=base%>pages/modulo/checkin/popup/popupManager.jsp?TIPO=H';
        vUrl += '&idxCheckin='+idxResApto;
        vUrl += '&seguro='+seguro;
        showPopupMedio(vUrl);        
}


function popupComplemento(idxResApto){
        vUrl = '<s:url action="popupComplemento!prepararPopupComplemento.action" namespace="/app/checkin" />';
        vUrl = '<%=base%>pages/modulo/checkin/popup/popupManager.jsp?TIPO=C';
        vUrl += '&idxCheckin='+idxResApto;
        showPopupPadrao(vUrl,"500","500");        
}



function atualizar(){
    vForm = document.forms[0];
    vForm.action = '<s:url action="include!atualizarCheckinHospede.action" namespace="/app/checkin" />';
    submitForm(vForm);        
}

function atualizarHospede(){
    vForm = document.forms[0];
    vForm.action = '<s:url action="include!atualizarCheckinHospedePopUp.action" namespace="/app/checkin" />';
    submitForm(vForm);            
}

function mudarConfirmacao(objIndex){
        valor = $("select[name='confirmada']").size();
        for (var x = 0; x<$("select[name='confirmada']").size(); x++){
            novoValor = $("select[name='confirmada']").get(x).value == "S"?"N":"S";
            $("select[name='confirmada']").get(x).value =  novoValor ;
        }
}

function gravarCheckin(objIndex){
        loading();
        vForm = document.forms[0];
        vForm.idxCheckin.value = objIndex;
        vForm.action = '<s:url action="include!gravarCheckin.action" namespace="/app/checkin" />';
        submitForm(vForm);        
}

function verificarMaster(obj){

        valor = obj.value;
        if (valor == 'S'){
            valorOutros = 'N';
            $("select[name='master']").val(valorOutros);
            $(obj).val(valor);
        }
}

function validarPrincipal( obj ){
	valor = obj.value;
	if (valor == 'S'){
		id = $(obj).parent().attr("id");
		id = id.substring(id.indexOf('_')+1);
		$("div[id$=_"+id+"] select[name='hospedePrincipal']").val( valor == 'S'?'N':'S');
		$(obj).val(valor);
	}
}

</script>
<div style="display: none"><%=new java.util.Date()%></div>
<body style="margin: 0px;">

<div class="divGrupo"
	style="overflow: auto; margin-top: 0px; width: 965px; height: 98%; border: 0px;">
<s:form namespace="/app/checkin" action="include!prepararCheckinHospede"
	theme="simple">
	<s:hidden name="idReserva" />
	<s:hidden name="idxCheckin" />

	<% int x = 0; java.util.List<Object> listaApto = null;%>
	<s:iterator value="#session.listaCheckin" status="row"
		var="checkinCorr">

		<%
                                listaApto = (java.util.List<Object>) ((java.util.List<Object>)session.getAttribute("listaApartamentos")).get(x);
                                request.setAttribute("listaApto",listaApto);
                            %>

		<div class="divLinhaCadastro" id='divLinha_<s:property value="reservaApartamentoEJB.idReservaApartamento"/>'
			style="margin-bottom:0px; padding-bottom:0px; border-bottom:0px; height: 35px; background-color: rgb(255, 165, 165);">
		<div class="divItemGrupo" style="width: 20px;"><img id="img0"
			title="Complemento dos Hóspedes" src='imagens/btnAlterar.png'
			onclick="popupComplemento('${row.index}')" /></div>
		<div class="divItemGrupo" style="width: 20px;"><img
			id="${row.index}" title="Adicionar os hóspedes"
			src="imagens/hospede.png" onclick="popupHospede('${row.index}','<s:property value="#checkinCorr.reservaApartamentoEJB.reservaEJB.calculaSeguro" />')" /></div>
		<div class="divItemGrupo" style="width: 50px;">
		<p style="width: 100%;">Tipo:</p>
		<s:select list="#session.listaTipoApto" cssStyle="width:50px;"
			listKey="idTipoApartamento" listValue="fantasia" value="reservaApartamentoEJB.idTipoApartamento"
			name="idTipoApartamento" onchange="obterApartamento(this)" /></div>
		<div class="divItemGrupo" style="width: 90px;">
		<p style="width: 100%;">Apto:</p>
		
		<s:select list="#request.listaApto" cssStyle="width:85px;"
			listKey="idApartamento" name="idApartamento" headerKey="-1" value="reservaApartamentoEJB.apartamentoEJB.idApartamento"
			headerValue="Selecione" />

		</div>
		<div class="divItemGrupo" style="width: 50px;">
		<p style="width: 100%;">Pax:</p>
		<s:property value="reservaApartamentoEJB.qtdePax" /></div>

		<div class="divItemGrupo" style="width: 50px;">
		<p style="width: 100%;">Tarifa:</p>
		<s:property value="reservaApartamentoEJB.tarifa" /></div>

		<div class="divItemGrupo" style="width: 50px;">
		<p style="width: 100%;">Master:</p>
		<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
			listValue="value" cssStyle="width:50px;" name="master" value="reservaApartamentoEJB.master"
			onchange="verificarMaster(this)" /></div>
		<div class="divItemGrupo" style="width: 80px;"><s:if
			test="#row.first == true">
			<p
				style="width: 100%; color: blue; text-decoration: underline; cursor: pointer;"
				onclick="mudarConfirmacao('${row.index}')">Confirmar:</p>
		</s:if> <s:else>
			<p style="width: 100%;">Confirmar:</p>
		</s:else> <s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
			listValue="value" cssStyle="width:50px;" name="confirmada"
			value="reservaApartamentoEJB.confirmada" /></div>

		<div class="divItemGrupo" style="width: 300px;">
		<p style="width: 100%;">Hóspede:</p>
		<s:property value="reservaApartamentoEJB.hospedePrincipal" /></div>
		
		<div class="divItemGrupo" style="width: 60px;" id='div_<s:property value="reservaApartamentoEJB.idReservaApartamento"/>'>
		<p style="width: 100%;">Principal:</p>
			<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
			listValue="value" cssStyle="width:50px;" name="hospedePrincipal" value="%{'S'}" onchange="validarPrincipal(this)"/>
		</div>
		
		
		<div class="divItemGrupo" style="width: 60px;">
		<p style="width: 100%;">Chegou:</p>
			<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
			listValue="value" cssStyle="width:50px;" name="hospedeChegou" value="%{'S'}"/>
		</div>
		</div>
		<s:iterator value="#checkinCorr.reservaApartamentoEJB.roomListEJBList" status="rowList">
			<s:if test="%{principal != \"S\"}">
				<div class="divLinhaCadastro" id='divLinha<%=x%>_<s:property value="checkinCorr.reservaApartamentoEJB..idReservaApartamento"/>' style="margin-bottom:0px; padding-bottom:0px; border-bottom:0px; height: 18px; background-color: rgb(255, 165, 165);">
					<div class="divItemGrupo" style="width: 417px;">&nbsp;</div>
					<div class="divItemGrupo" style="width: 300px;">
						<s:property value="hospede.nomeHospede"/>&nbsp;<s:property value="hospede.sobrenomeHospede"/>
					</div>
					
					<div class="divItemGrupo" style="width: 60px;" id='div<%=x%>_<s:property value="#checkinCorr.reservaApartamentoEJB.idReservaApartamento"/>'>
						<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
							listValue="value" cssStyle="width:50px;" name="hospedePrincipal" value="%{'N'}" onchange="validarPrincipal(this)"/>
					</div>
					<div class="divItemGrupo" style="width: 60px;">
						<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
							listValue="value" cssStyle="width:50px;" name="hospedeChegou" value="chegou"/>
					</div>
					
				</div>
			</s:if>
		</s:iterator>
		<div class="divLinhaCadastro" style="margin-bottom:0px; padding-bottom:0px; border-bottom:0px; height: 1px; background-color: white;">&nbsp;</div>
		
		<%x++;%>
	</s:iterator>


</s:form></div>

</body>

</html>
<duques:showMessage imagem="" />