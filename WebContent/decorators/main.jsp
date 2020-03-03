<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html; charset=iso-8859-1" %>
<%@taglib prefix="decorator"
	uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>

<jsp:scriptlet>
    String  base = request.getRequestURL().toString().substring(0, request.getRequestURL().toString().indexOf(request.getContextPath())+request.getContextPath().length()+1);
    String url_report = base.substring(0, base.indexOf(request.getContextPath()));
    
    
    session.setAttribute("URL_BASE", base);
    session.setAttribute("URL_REPORT", url_report+"/MozartHotelReportsWeb");
    session.setAttribute("LOGO_MOZART", base+"imagens/Mozart_topo.png");
    response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
	response.setHeader("Cache-Control","no-store, no-cache, must-revalidate");
	response.addHeader("Cache-Control", "post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
</jsp:scriptlet>
<jsp:include page="/pages/modulo/includes/cache.jsp" >
	<jsp:param name="data" value="<%=new java.util.Date().getTime()%>" />
</jsp:include>




<!--decorator main.jsp-->
<html lang="br">

<script type="text/javascript">
    function cancelar(){
        cancelarOperacao('<%=session.getAttribute("URL_BASE")%>');
    }  
    
    function logoff(){
        <%if (request.getServletPath().toLowerCase().indexOf("pesquisa") < 0 ){%>
            loading();
        <%}else{%>
            loadingPesquisa();
        <%}%>
        window.location.href = '<%=session.getAttribute("URL_BASE")%>login!logout.action';
        return false;    
    }

</script>

<head>
<base href="<%=base%>" />
<title><decorator:title default="Web Login" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" /> 
   <meta http-equiv="content-language" content="pt-br" /> 
   <meta http-equiv="content-type" content="text/html;charset=iso-8859-1" /> 
   <meta name="robots" content="index, follow" /> 
   <meta http-equiv="pragma" content="no-cache" /> 
   <meta http-equiv="Cache-Control" content="no-cache, no-store" /> 
   <meta http-equiv="Pragma" content="no-cache, no-store" /> 
   <meta http-equiv="expires" content="Mon, 06 Jan 1990 00:00:01 GMT" /> 
   <meta name="description" content="Mozart WEB - para você que sonhava em hospedar o melhor em tecnologia" />

<%if (request.getServletPath().indexOf("main!preparar") > -1 || request.getServletPath().indexOf("/app/selecionar!") >=0 ){%>
<!-- <meta http-equiv="refresh" content="90" /> -->
<%}%>
<jsp:include page="/pages/modulo/includes/headPage.jsp">
	<jsp:param name="data" value="<%=new java.util.Date().getTime()%>" />
</jsp:include>

<%if (request.getServletPath().toLowerCase().indexOf("main!preparar") < 0 ){%>
<script language="javascript" type="text/javascript">
loading(); 
</script>
<%}else{%>
<script language="javascript" type="text/javascript">loadingPesquisa();</script>
<%}%>
<script  language="javascript" type="text/javascript">

function noPage(){
	return false;
}

$(function() {

	killModal();
	$("input").keypress(function(e) {
		  code = e.keyCode ? e.keyCode : e.which; 
		  if (code.toString() == '13') { 
			  killModal();
      		  return false;
		  } 
	});

	
	$.datepicker.setDefaults($.datepicker.regional['pt-BR']);
	 
	$(".dp").datepicker({
		showOn: 'button',
		/*buttonImage: 'imagens/calendario/calendar1.gif',*/
		buttonImage: 'imagens/iconic/png/calendar-2x.png',
		buttonImageOnly: true,
		dateFormat: 'dd/mm/yy',
		numberOfMonths: 2
			     			
	});
	$(".dpFMT").datepicker({
		showOn: 'button',
		/*buttonImage: 'imagens/calendario/calendar1.gif',*/
		buttonImage: 'imagens/iconic/png/calendar-2x.png',
		buttonImageOnly: true,
		dateFormat: 'mm/yy',
		numberOfMonths: 2
		         		
	});

	$("div.divRecebeDrag").resizable({
		maxWidth: 500,
		minWidth: 120
	});

});
</script>

</head>

<body class="bodyClique" id="bodyClique">
<div style="display: none"><%=new java.util.Date()%></div>

<div class="divGeral">
<%
    /*Este código, evita o desalinhamento dos popups, estava dando problama com o sitemesh, 
      todos os popups do sistema devem ter na sua url seja jsp ou action, o nome popup em algum lugar*/
    if(request.getServletPath().toLowerCase().indexOf("popup")==-1){%>
<div class="divCabecalho">
<jsp:include
	page="/pages/modulo/includes/cabecalho.jsp">
	<jsp:param name="data" value="<%=new java.util.Date().getTime()%>" />
</jsp:include>
</div>
<%}%>

<div style="display: none"><%=new java.util.Date()%></div>
<!--div corpo-->
<div id="divCentral" class="divCentral"><duques:showMessage
	imagem="imagens/iconic/png/check-3x.png" /> <decorator:body /></div>

<!-- Verificar a necessidade de um div rodape-->

</div>
</body>

<s:if test="%{#session.USER_SESSION.usuarioEJB.nivel.intValue() == 0}">
<script>
currentMenu = 'SOMENTE_LEITURA'
</script>
</s:if>


</html>