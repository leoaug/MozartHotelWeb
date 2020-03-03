<%@ page contentType="text/html;charset=iso-8859-1" %>
<%@taglib prefix="s" uri="/struts-tags" %>
<jsp:scriptlet>
String  base = request.getRequestURL().toString().substring(0, request.getRequestURL().toString().indexOf(request.getContextPath())+request.getContextPath().length()+1);
session.setAttribute("URL_BASE", base);
response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
response.setHeader("Cache-Control","no-store, no-cache, must-revalidate");
response.addHeader("Cache-Control", "post-check=0, pre-check=0");
response.setHeader("Pragma", "no-cache");
</jsp:scriptlet>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<base href="<%=base%>" />
<jsp:include page="/pages/modulo/includes/headPage.jsp" />

	<script type="text/javascript">

		function lerArquivo(valor){
			vForm = document.forms[0];
			vForm.arquivoTelefonia.value = valor;
			vForm.submit();
		}
	
		<s:if test="podeFechar == \"sim\"">
			parent.killModal();
		</s:if>
		<s:if test="erroGravacao == \"sim\"">
			parent.erroLancamentoTelefonia();
		</s:if>
	</script>

</head>
<body>
<s:form action="lerTelefonia!gravarArquivo.action" namespace="/app" theme="simple">
	<s:hidden name="arquivoTelefonia" id="arquivoTelefonia" />
</s:form>
</body>
</html>