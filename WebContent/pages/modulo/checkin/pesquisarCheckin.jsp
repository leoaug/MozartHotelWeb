<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script>
    function init(){
        
    }

    function submeterPagina(destino){
        
        vForm = document.forms[0];
        if ('NOVO' == destino){
            vForm.action = '<s:url action="manterFast!preparaManterFast.action" namespace="/app/checkin" />';
        }else if ('WALKIN' == destino){
            vForm.action = '<s:url action="manter!preparaManter.action" namespace="/app/checkin" />';        
        }else if ('COFAN' == destino){
            vForm.action = '<s:url action="manter!preparaManterCofan.action" namespace="/app/checkin" />';        
        }else if ('ALTERAR' == destino){
            vForm.action = '<s:url action="manter!preparaAlteracao.action" namespace="/app/checkin" />';        
        }
        submitForm(vForm);        
        
    }

	function imprimir(){
        vForm = document.forms[0];
		vForm.action = '<s:url action="relatorio!preparaRelatorio.action" namespace="/app/checkin" />';        
        submitForm(vForm);        
    }

	

    function imprimirMovimento(){
    	var idRel = $('#idCheckin').val();

        if ($('#idCheckin').val()==''){
            alerta("Selecione um check-in para imprimir.");
            return false;
        }

    	reportAddress = '<s:property value="#session.URL_REPORT"/>';
   		reportAddress += '/index.jsp?REPORT=detalheCheckinReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params +=  ';P_CHECKIN@'+$('#idCheckin').val();
   		reportAddress += '&PARAMS='+params;
   		showPopupGrande(reportAddress);

    }


    function imprimirVoucherSeguro(){

    	 vUrl = '<%=session.getAttribute("URL_BASE")%>pages/certificadoAlfa.jsp?currentSessionID='+$('#codCertificado').val();
         window.open(vUrl,"NumCertificado", ',status=yes,resizable=no,location=no,type=fullWindow,fullscreen,scrollbars=yes');
    }

    function imprimirFnrh(){


    	var idRel = $('#idCheckin').val();

        if ($('#idCheckin').val()==''){
            alerta("Selecione um check-in para imprimir.");
            return false;
        }

    	reportAddress = '<s:property value="#session.URL_REPORT"/>';
   		reportAddress += '/index.jsp?REPORT=fnrhReport';
   		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
   		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
   		params +=  ';P_CHECKIN@'+idRel;
		
   		reportAddress += '&PARAMS='+params;
   		showPopupGrande(reportAddress);
   }

    function imprimirFnrhReserva(){


    	var idRel = $('#idReserva').val();
    	var dataEntrada = $('.'+idRel+'Entrada').text();

        if ($('#idReserva').val()==''){
            alerta("Selecione uma reserva para imprimir.");
            return false;
        }

    	reportAddress = '<s:property value="#session.URL_REPORT"/>';
   		reportAddress += '/index.jsp?REPORT=fnrhReport';
   		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
   		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
   		params +=  ';P_RESERVA@'+idRel;
   		params +=  ';P_DATA1@'+dataEntrada;
   		params +=  ';P_DATA2@'+dataEntrada;
		
   		reportAddress += '&PARAMS='+params;
   		showPopupGrande(reportAddress);
   }
  
    function checkinFast(){

        submeterPagina('NOVO');
    }
    
    function alterarCheckin(){
        if ($('#idCheckin').val()==''){
            alerta("Selecione um check-in para alterar.");
            return false;
        }
        submeterPagina('ALTERAR');
    
    }
    
currentMenu = "checkin";
with(milonic=new menuname("reservaDia")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/checkinFast.png;text=Checkin FAST;url=javascript:checkinFast();");
	aI("image=imagens/btnImprimir.png;text=FNRH;url=javascript:imprimirFnrhReserva();");
	drawMenus(); 
}

with(milonic=new menuname("aptoExecutado")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar Checkin;url=javascript:alterarCheckin();");
	aI("image=imagens/btnImprimir.png;text=FNRH;url=javascript:imprimirFnrh();");
	aI("image=imagens/btnImprimir.png;text=Movimento geral;url=javascript:imprimirMovimento();");
	drawMenus(); 
	}

with(milonic=new menuname("aptoHistorico")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnImprimir.png;text=Movimento geral;url=javascript:imprimirMovimento();");
	drawMenus(); 
	}


with(milonic=new menuname("hospExecutado")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/certificado.png;text=Certificado Seguro;url=javascript:imprimirVoucherSeguro();");
	drawMenus(); 
}

</script>
<script>
currentMenu = "reservaDia"; 
</script>
<%
        String titulo = "Relatório";
        String campoAlteracao = "idReserva";
        String requestvalue = request.getParameter("filtro.filtroTipoPesquisa");
        
        if ("1".equals( requestvalue)){
            titulo = "Reserva do dia";
%>
<script>
currentMenu = "reservaDia"; 
</script>

<%
        }else if ("2".equals( requestvalue)){
            titulo = "Hóspede do dia";
        }else if ("3".equals( requestvalue)){
            titulo = "Apartamento executado";
            campoAlteracao = "idCheckin";
%>
<script>
currentMenu = "aptoExecutado"; 
</script>
<%
        }else if ("4".equals( requestvalue)){
            titulo = "Hóspede executado";
            campoAlteracao = "codCertificado";
%>
<script>
	<s:if test="%{#session.HOTEL_SESSION.empresaSeguradoraEJB != null}">
		currentMenu = "hospExecutado";
		<%campoAlteracao = "codCertificado";%>
	</s:if>
	<s:else>
		currentMenu = "aptoExecutado";
		<%campoAlteracao = "idCheckin";%>
	</s:else>
	 
</script>
<%            
        }else if ("5".equals( requestvalue)){
            titulo = "Pré checkin";
        
        }else if ("6".equals( requestvalue)){
            titulo = "Histórico";
            campoAlteracao = "idCheckin";
            %>
            <script>
           		currentMenu = "aptoHistorico";
           		
            </script>
			<%            
        }
    %>

<s:form action="pesquisar!pesquisar.action" namespace="/app/checkin" theme="simple">
	<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1}" var="isHotel" />
	<input type="hidden" id="codCertificado" name="codCertificado" ></input>
	<input type="hidden" id="idCheckin" name="idCheckin" ></input>
	<input type="hidden" id="idReserva" name="idReserva" ></input>
	<div class="divFiltroPaiTop">Pesquisa de Checkin</div>
	<div id="divFiltroPai" class="divFiltroPai">
	<div id="divFiltro" class="divFiltro"><duques:filtro
		tableName="CHECKIN_WEB" titulo="" /></div>
	</div>
	<div id="divMeio" class="divMeio">
	<div id="divOutros" class="divOutros" style="width: 460px; ">
	
	<ul style="width: 100px; height:100%; float: left; padding: 0px; margin: 0px; list-style: none; font-size: 8pt; border-right: 1px solid black;">
		<li style="font-size: 8pt;"><input type="radio"
			<%=(request.getParameter("filtro.filtroTipoPesquisa")==null || "1".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":"")%>
			name="filtro.filtroTipoPesquisa" value="1" />Reserva dia</li>
		
		
		<li style="font-size: 8pt;"><input type="radio"
			<%="2".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
			name="filtro.filtroTipoPesquisa" value="2" />Hóspede dia</li>
	</ul>
	<ul style="width: 220px; height:100%;float: left; padding: 0px; margin: 0px; list-style: none; font-size: 8pt; border-right: 1px solid black;">

		<li style="float: left; font-size: 8pt;"><input type="radio"
			<%="3".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
			name="filtro.filtroTipoPesquisa" value="3" />Apto executado</li>
	
	
		<li style="float: left; font-size: 8pt;"><input type="radio"
			<%="5".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
			name="filtro.filtroTipoPesquisa" value="5" />Pré checkin</li>
	
		
		<li style="float: left; font-size: 8pt;"><input type="radio"
			<%="4".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
			name="filtro.filtroTipoPesquisa" value="4" />Hóspede executado</li>

		<li style="float: left; font-size: 8pt;"><input type="radio"
			<%="6".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
			name="filtro.filtroTipoPesquisa" value="6" />Histórico</li>

	</ul>
	
	<ul
		style="width: 110px; float: left; padding: 0px; margin: 0px; list-style: none; font-size: 8pt;  ">
		<li style="font-size: 8pt;"><img src="imagens/imgLegAmarelo.png"
			width="10px" height="10px" />&nbsp;No show</li>
		<li style="font-size: 8pt;"><img src="imagens/imgLegVermelho.png"
			width="10px" height="10px" />&nbsp;Não confirmada</li>
		<li style="font-size: 8pt;"><img src="imagens/imgLegVerde.png"
			width="10px" height="10px" />&nbsp;Hóspede VIP</li>
	</ul>

	</div>

	<div id="divBotao" class="divBotao"><duques:botao
		label="Pesquisar"
		imagem="imagens/iconic/png/magnifying-glass-3x.png"
		onClick="submitForm(document.forms[0]);" />
		
		<s:if test="isHotel"><duques:botao
		label="Relatório"
		imagem="imagens/iconic/png/print-3x.png"
		onClick="imprimir();" /></s:if>
		
		<duques:botao label="Cofan"
		style="width:100px" imagem="imagens/btnCofan.png"
		onClick="submeterPagina('COFAN');" /> <duques:botao label="Walkin"
		style="width:100px" imagem="imagens/walkin.png"
		onClick="submeterPagina('WALKIN');" /> <duques:botao label="Checkin"
		style="width:100px" imagem="imagens/checkinFast.png"
		onClick="submeterPagina('NOVO');" /></div>
	</div>


	<duques:grid colecao="listaPesquisa" titulo="<%=titulo%>"
		condicao="noShow;eq;Sim;corAmarelo#confirmada;eq;N;corVermelho#tipoHospede;eq;VIP;corVerde#"
		current="obj" idAlteracao="<%=campoAlteracao%>" 
		idAlteracaoValue="<%=campoAlteracao%>"
		urlRetorno="pages/modulo/checkin/pesquisarCheckin.jsp">
		
		<duques:column labelProperty="Apto" propertyValue="numApartamento" style="width:100px;" />
		<duques:column labelProperty="Hóspede" propertyValue="nomeHospede" style="width:350px;" />
		<duques:column labelProperty="Empresa" propertyValue="nomeFantasia" style="width:350px;" />
		<duques:column labelProperty="Dt Entrada" propertyValue="dataEntrada" classe="${obj.idReserva}Entrada" style="width:120px;" format="dd/MM/yyyy" grouped="true" />
		<duques:column labelProperty="Dt Saída" propertyValue="dataSaida" style="width:120px;" format="dd/MM/yyyy" />
		<duques:column labelProperty="Pensão" propertyValue="tipoPensao" style="width:150px;" grouped="true" />
		<duques:column labelProperty="Qtde apto" propertyValue="qtdeApto" style="width:100px;" math="sum" />
		<duques:column labelProperty="Qtde pax" propertyValue="qtdePax" style="width:100px;" math="sum" />
		<duques:column labelProperty="Qtde adu" propertyValue="qtdeAdultos" style="width:100px;" math="sum" />
		<duques:column labelProperty="Qtde cri" propertyValue="qtdeCriancas" style="width:100px;" math="sum" />
		<duques:column labelProperty="Qtde adic" propertyValue="adicional" style="width:100px;" math="sum" />
		<duques:column labelProperty="Qtde café" propertyValue="qtdeCafe" style="width:100px;" math="sum" />
		<duques:column labelProperty="Nome grupo" propertyValue="nomeGrupo" style="width:200px;" />
		<duques:column labelProperty="Checkin" propertyValue="idCheckin" style="width:100px;" />
		<duques:column labelProperty="Reserva" propertyValue="idReserva" style="width:100px;" />
		<duques:column labelProperty="Confirmada" propertyValue="confirmada" style="width:100px;" />
		<duques:column labelProperty="Observação" propertyValue="observacao" style="width:750px;" />
	</duques:grid>

</s:form>