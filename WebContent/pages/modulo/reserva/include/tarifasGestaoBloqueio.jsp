<%@ page contentType="text/html;charset=iso-8859-1"%>
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
	<body style="margin:0px;" onload="inicializaTela();">
		<s:form namespace="/app/reserva"  theme="simple">
			<s:set name="bloqueio" value="#session.BLOQUEIO" />
			<div class="divGrupo" style="margin:0px; border: 0px; width:100%;">
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Cliente: <s:property value="#bloqueio.bcContato" /></p>
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Bloqueio: <s:property value="#bloqueio.bcIdReserva" /></p>
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Impostos em %: <s:property value="#bloqueio." /></p>
					</div>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Data Entrada: <s:property value="#bloqueio.bcDataEntrada" /></p>
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Dead-line: <s:property value="#bloqueio.bcDeadLine" /></p>
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Taxa Serviço em %: </p>
					</div>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Data Saída: <s:property value="#bloqueio.bcDataSaida" /></p>
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Usuário: </p>
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Room Tax - Vr. por dia: </p>
					</div>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Data Bloqueio: <s:property value="#bloqueio.bcDataReserva" /></p>
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Data Cancelamento: <s:property value="#bloqueio." /></p>
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 150px;">Seguro Vr. por dia p/ pax: </p>
					</div>
				</div>
			</div>
		</s:form>
	</body>
</html>