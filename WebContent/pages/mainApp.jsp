<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=windows-1252"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1252" />
<title>mainApp</title>
</head>

<frameset rows="100,*">
	<frame name="top" src="<s:url value="/pages/includes/cabecalho.jsp" />">
	<frame name="mainFrame" scrolling="no"
		src="<s:url value="/pages/principal.jsp" />">
</frameset>

</html>