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
      <script type="text/javascript">
		function atualizar() {
			location.reload(true);
			parent.killModal();
			parent.atualizar();
			
		}
      </script>
    </head>
	<body style="margin:0px;" onload="inicializaTela();">
		<s:form namespace="/app/bloqueio"  theme="simple">
			<s:set name="bloqueio" value="#session.BLOQUEIO_GESTAO" />
		
			<s:if test="%{#bloqueio != null}">
			<div class="divGrupo" style="margin:0px; border: 0px; width:100%;">
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 24%;">
						<p style="width: 41%;">Dead-line: </p>
						<span style="width: 57%;"><s:property value="#bloqueio.bcDeadLine" /></span>
					</div>
					<div class="divItemGrupo" style="width: 24%;">
						<p style="width:  48%; ">Dt Bloqueio:</p>
						<span style="width: 50%;"><s:property value="#bloqueio.bcDataReserva" /></span>
					</div>
					<div class="divItemGrupo" style="width: 24%;">
						<p style="width:  60%;">Dt Cancel:</p>
						<span style="width: 38%;"><s:property value="#bloqueio.bcDataCancelamento" /></span>
					</div>
					<div class="divItemGrupo" style="width: 24%;">
						
					</div>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 24%;">
						<p style="width:  41%;">Impostos em %:</p>
						<span style="width: 57%;"><s:property value="#bloqueio.iss" /></span>
					</div>
					
					<div class="divItemGrupo" style="width: 24%;">
						<p style="width:  48%;">Taxa Serviço em %: </p>
						<span style="width: 50%;"><s:property value="#bloqueio.taxaServico" /></span>
					</div>
					<div class="divItemGrupo" style="width: 24%;">
						<p style="width:  60%;">Room Tax - Vr. por dia: </p>
						<span style="width: 38%;"><s:property value="#bloqueio.roomTax" /></span>
					</div>
					<div class="divItemGrupo" style="width: 24%;">
						<p style="width:  60%;">Seguro Vr. por dia p/ pax: </p>
						<span style="width: 38%;"><s:property value="#bloqueio.seguro" /></span>
					</div>
				</div>
			</div>
			</s:if>
		</s:form>
	</body>
</html>