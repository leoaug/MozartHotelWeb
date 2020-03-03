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
<script type="text/javascript">
    function excluirHospede(indice) {                
        loading();
        document.forms[0].action = '<s:url action="include!excluirHospedeReservaApartamento.action" namespace="/app/reserva" />';        
        document.forms[0].indiceHospede.value = indice;
        document.forms[0].submit();        
        //submitFormAjax('excluirHospedeReservaApartamento?indiceHospede='+indice,true);
    }

    function atualizar(){
        	//loading();
        	document.forms[0].action = '<s:url action="include!prepararHospede.action" namespace="/app/reserva" />';        
            document.forms[0].submit();        
     }
</script>
</head>
<body>
<s:form namespace="/app/reserva" action="include!prepararHospede"
	theme="simple">
	<s:hidden id="indiceHospede" name="indiceHospede" />
	
		<s:iterator value="#session.TELA_RESERVA_ROOM_LIST_ATUAL" var="roomCorr" status="row">
			<div class="divLinhaCadastro"  style="width:620px">
				<div class="divItemGrupo" style="width: 350px;"><p style="width:100%;font-family: verdana;font-size: 8pt;"><s:property value="bcNomeHospede" /></p></div>
				<div class="divItemGrupo" style="width: 200px;"><p style="width:100%;font-family: verdana;font-size: 8pt;"><s:property value='bcPrincipal=="S"?"Sim":"Não"' /></p></div>
				<div class="divItemGrupo" style="width: 35px; text-align: center;">
					<img width="24px" height="24px" src="imagens/iconic/png/x-3x.png" title="Excluir hóspede" onclick="excluirHospede('${row.index}')" />
				</div>
			</div>
		</s:iterator>

</s:form>
</body>
</html>
