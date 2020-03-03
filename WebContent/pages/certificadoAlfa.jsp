<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=windows-1252"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1252" />
<title>CertificadoAlfa</title>
</head>
<body>
<s:form action="pesquisarApolice" namespace="/certificado/alfa"
	theme="simple">

	<s:hidden name="apolice.currentSessionID" />

</s:form>

<script>
        document.forms[0].elements['apolice.currentSessionID'].value = '<%=request.getParameter("currentSessionID")%>';
        document.forms[0].submit();
  </script>

</body>
</html>