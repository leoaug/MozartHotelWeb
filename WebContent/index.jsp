<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<title>Web Login</title>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1252" />

</head>
<body>

<s:form action="/login!prepararLogin.action" theme="simple" id="login_form"
	cssClass="login_form">
<input type="hidden"
	name="BROWSER_TYPE" value="" />
</s:form>
</body>
<script type="text/javascript">
<%if ("true".equalsIgnoreCase( request.getParameter("logout") )){%>
        window.parent.close();
<%}else{%>

        if (document.all){
            document.forms[0].BROWSER_TYPE.value="ie";
        }else{
            document.forms[0].BROWSER_TYPE.value="ie";
        }    
        document.forms[0].submit();
<%}%>
</script>
</html>

