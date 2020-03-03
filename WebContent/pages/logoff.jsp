<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:scriptlet>
		request.getSession(true).setAttribute("EXPIROU","TRUE");
        String  base = request.getRequestURL().toString().substring(0, request.getRequestURL().toString().indexOf(request.getContextPath())+request.getContextPath().length()+1);
        request.getSession().setAttribute("URL_BASE",base);
        String BROWSER_TYPE = (String)session.getAttribute("BROWSER_TYPE");
</jsp:scriptlet>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
   <script>
        window.location.href = '<%=session.getAttribute("URL_BASE")%>login!logout.action';       
   </script>
</head>
</html>