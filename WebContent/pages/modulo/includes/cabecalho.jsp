<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="/pages/modulo/includes/cache.jsp"%>


<div class="divLogoMozart" style='cursor: pointer; background-image: url("data:image/png;base64,<%=session.getAttribute("IMG_LOGO_MOZART")%>") !important;'
	 onclick="window.location.href= '<%=session.getAttribute("URL_BASE")%><%=session.getAttribute("CRS_SESSION_NAME")!=null &&session.getAttribute("CRS_PROPRIA")==null ?"app/main!preparar.action":"app/main!preparar.action"%>'">
</div>

<script>

	function openDisponibilidade(){
		showPopupGrande('<%=session.getAttribute("URL_BASE")%>app/crs/popup!prepararDisponibilidade.action');
	}
	function openChartApartamento(){
		showPopupGrande('<%=session.getAttribute("URL_BASE")%>app/checkin/popupChart!prepararChart.action');
	}

	function openRelatorioControlaData(){
		reportAddress = '<s:property value="#session.URL_REPORT"/>';
		reportAddress += '/index.jsp?REPORT=controlaDataReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params +=  ';ADM@<s:property value="#session.USER_ADMIN == \"TRUE\"?\"S\":\"N\""/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		reportAddress += '&PARAMS='+params;
		win = window.open(reportAddress,"PopUp", ',status=yes,resizable=no,location=no,scrollbars=no,width='+980+',height='+640+', left=200, top=50');
	}

	 
	function novaReserva(idApartamento, dataEntrada, idTipoApartamento){
        vForm = document.forms[0];
        actionVal = '<s:url action="manter!preparaManterViaChart.action" namespace="/app/reserva"></s:url>';
		actionVal +='?dataEntradaChart='+dataEntrada;
		
		if (document.forms[0].elements["idApartamentoChart"] == null)
			actionVal +='&idApartamentoChart='+idApartamento;
		else {
			$("#idApartamentoChart").val(idApartamento);			
		}

		if (document.forms[0].elements["idTipoAptoCRS"] == null)
			actionVal +='&idTipoAptoCRS='+idTipoApartamento;
		else {
			$("#idTipoAptoCRS").val(idTipoApartamento);			
		}
		
		
    	vForm.action = actionVal;
		submitForm(vForm);			
	}
	
</script>

<%-- < %if (request.getServletPath().indexOf("main!preparar") > -1 || request.getServletPath().indexOf("/app/selecionar!") >=0 ){% > --%>
<%-- < %}% > --%>


<div class="divUserGroup">
<ul>
	<li><b><s:property value="#session.HOTEL_SESSION.nomeFantasia" /></b></li>
	<li>Seja bem vindo(a), <b><s:property
		value="#session.USER_SESSION.usuarioEJB.nick" /></b></li>
	<li>Controla data: <b><s:property
		value="#session.CONTROLA_DATA_SESSION.frontOffice" /></b></li>
	<li id="linhaFaturamento" style="display:none;">Faturamento: <b><s:property
		value="#session.CONTROLA_DATA_SESSION.faturamentoContasReceber" /></b></li>
	<li id="linhaContasReceber" style="display:none;">Contas a receber: <b><s:property
		value="#session.CONTROLA_DATA_SESSION.contasReceber" /></b></li>
	<li id="linhaContasPagar" style="display:none;">Contas a pagar: <b><s:property
		value="#session.CONTROLA_DATA_SESSION.contasPagar" /></b></li>
	<li id="linhaEstoque" style="display:none;">Estoque: <b><s:property
		value="#session.CONTROLA_DATA_SESSION.estoque" /></b></li>
	<li id="linhaRestaurante" style="display:none;">Restaurante: <b><s:property
		value="#session.PDV_SESSION.dataPv" /></b></li>
	<li id="linhaTesouraria" style="display:none;">Tesouraria: <b>
		<s:property value="@com.mozart.model.util.MozartUtil@format(#session.CONTROLA_DATA_SESSION.tesouraria, @com.mozart.model.util.MozartUtil@FMT_MES_ANO)" />
	</b></li>
	<li id="linhaMovimentoContabil" style="display:none;">Contábil: <b>
		<s:property value="@com.mozart.model.util.MozartUtil@format(#session.CONTROLA_DATA_SESSION.contabilidade, @com.mozart.model.util.MozartUtil@FMT_MES_ANO)" />
	</b></li>
		
</ul>
</div>

<s:if test="%{#session.IMG_FOTO_USUARIO != null && #session.IMG_FOTO_USUARIO != ''}">
	<div class="divFotoUsuario" style='background-image: url("data:image/png;base64,<%=session.getAttribute("IMG_FOTO_USUARIO")%>") !important;'>
	</div>                        	
</s:if>
<s:else>
	<div class="divFotoUsuario" style='background-image: url("imagens/iconic/png/person-6x.png") !important;'></div>
</s:else>



<div class="divLogoHotel"><img
	src="<s:property value="#session.HOTEL_SESSION.enderecoLogotipo"/>"
	title="<s:property value="#session.HOTEL_SESSION.nomeFantasia"/>" /></div>

<div class="divBotoesFixos"><img src="imagens/iconic/png/x-3x.png"
	onmouseover="this.src='imagens/iconic/png/xRed-3x.png'"
	onmouseout="this.src='imagens/iconic/png/x-3x.png'" title="Fechar"
	onclick="confirm('Deseja realmente sair?')?logoff():'';" />
<%

if (session.getAttribute("CRS_SESSION_NAME")==null || session.getAttribute("CRS_PROPRIA")!=null){
java.util.List<String> lista = (java.util.List<String>)session.getAttribute("listMensagem");
 if (lista !=null && lista.size() > 0){ %> <img class="imgBotao"
	src="<s:property value="#session.POSSUI_MENSAGEM_URGENTE == \"S\"?\"imagens/iconEmailUrgente.gif\":\"imagens/iconEmail.png\"" />" title="Você possui [<%=lista.size()%>] mensagem(ns) não lida(s)"
	onclick="window.location.href= '<%=session.getAttribute("URL_BASE")%>app/main!prepararMensagem.action'" />
<%}
 }%> 
</div>




