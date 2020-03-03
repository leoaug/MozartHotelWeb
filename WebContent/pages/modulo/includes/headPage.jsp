<%@ include file="/pages/modulo/includes/cache.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-language" content="pt-br" />
<meta http-equiv="content-type" content="text/html;charset=iso-8859-1" />
<meta name="robots" content="index, follow" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="Cache-Control" content="no-cache, no-store" />
<meta http-equiv="Pragma" content="no-cache, no-store" />
<meta http-equiv="expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
<meta name="description"
	content="Mozart WEB - para você que sonhava em hospedar o melhor em tecnologia" />

<link href="css/geral.css" rel="stylesheet" type="text/css" media="all" />
<link href="css/crs.css" rel="stylesheet" type="text/css" media="all" />
<link href="css/tree.css" rel="stylesheet" type="text/css" media="all" />
<link href="css/modal.css" rel="stylesheet" type="text/css" media="all" />
<link href="css/markitup.css" rel="stylesheet" type="text/css"
	media="all" />
<link href="css/start/jquery-ui-1.8.1.custom.css" rel="stylesheet"
	type="text/css" media="all" />

<link href="css/tabela_fix/defaultTheme.css" rel="stylesheet"
	type="text/css" media="all" />
<link href="css/tabela_fix/myTheme.css" rel="stylesheet" type="text/css"
	media="all" />

<link href="css/datepicker.css" rel="stylesheet" type="text/css"
	media="all" />

<link
	href="css/<%=session.getAttribute("BROWSER_TYPE")%>/mozartHotel.css"
	rel="stylesheet" type="text/css" media="all" />
<link href="css/<%=session.getAttribute("BROWSER_TYPE")%>/sitemesh.css"
	rel="stylesheet" type="text/css" media="all" />
<link href="css/<%=session.getAttribute("BROWSER_TYPE")%>/grid.css"
	rel="stylesheet" type="text/css" media="all" />

<link href="css/wysiwyg.css" rel="stylesheet" type="text/css"
	media="all" />

<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" media="all" />

<script src='js/jquery.min.js' type='text/javascript'></script>
<script src='js/popper.min.js' type='text/javascript'></script>
<script src='js/bootstrap.min.js' type='text/javascript'></script>
<script src='js/jquery-1.5.2.js' type='text/javascript'></script>
<script src='js/jquery-maskedinput.js' type='text/javascript'></script>
<script src='js/mozart-ns.js' type='text/javascript'></script>
<script src='js/geral.js' type='text/javascript'></script>
<script src='js/interface.js' type='text/javascript'></script>
<script src='js/jquery-updateWithJSON.min.js' type='text/javascript'></script>
<script src='js/jquery-checktree.js' type='text/javascript'></script>
<script src='js/jquery-modal-1.3.js' type='text/javascript'></script>
<script src='js/jquery-ui-core.js' type='text/javascript'></script>
<script src='js/jquery-ui-widget.js' type='text/javascript'></script>
<script src='js/jquery-ui-mouse.js' type='text/javascript'></script>
<script src='js/jquery-ui-position.js' type='text/javascript'></script>
<script src='js/jquery-ui-drag.js' type='text/javascript'></script>
<script src='js/jquery-ui-drop.js' type='text/javascript'></script>
<script src='js/jquery-ui-sortable.js' type='text/javascript'></script>
<script src='js/jquery-ui-datepicker.js' type='text/javascript'></script>
<script src='js/jquery-ui-datepicker-pt-BR.js' type='text/javascript'></script>
<script src='js/jquery-ui.resizable.js' type='text/javascript'></script>
<script src='js/datepicker.js' type='text/javascript'></script>
<script src='js/eye.js' type='text/javascript'></script>
<script src='js/jquery-markitup.js' type='text/javascript'></script>
<script src='js/jquery-markitup-set.js' type='text/javascript'></script>
<script src='js/ie/mozart.js' type='text/javascript'></script>

<%
	if (request.getServletPath().indexOf("main!preparar") == -1
			&& request.getServletPath().indexOf("/app/selecionar!") == -1) {
		%>
<script src="js/menu/rclick_src.js" type="text/javascript"></script>
<!-- <script src="js/menu/rclick_mmenudom.js" type="text/javascript"></script> -->
<script src="js/menu/rclick_data.js" type="text/javascript"></script>

<%
	}

	/*Este código, evita o desalinhamento dos popups, estava dando problama com o sitemesh, 
	  todos os popups do sistema devem ter na sua url seja jsp ou action, o nome popup em algum lugar
	  request.getServletPath().toLowerCase().indexOf("app/crs/popup") == -1
	  request.getServletPath().toLowerCase().indexOf("app/checkin/popupChart") == -1*/
	if (request.getServletPath().toLowerCase().indexOf("include/") == -1
		&& request.getServletPath().toLowerCase().indexOf("app/crs/popup") == -1
		&& request.getServletPath().toLowerCase().indexOf("app/checkin/popupChart") == -1) {
%>
<script type="text/javascript" src="js/menu/milonic_src.js"></script>
<script type="text/javascript" src="js/menu/mmenudom.js"></script>
<!-- <script type="text/javascript" src="js/menu/menu_data.js"></script>-->
<jsp:include page="/pages/modulo/includes/menu_data.jsp">
	<jsp:param name="data" value="<%=new java.util.Date().getTime()%>" />
</jsp:include>
<%
	}
%>
<script src="js/contextmenu.js" type="text/javascript"></script>

<script src="js/ajax.js" type="text/javascript"></script>

<script src="js/jquery-wysiwyg.js" type="text/javascript"></script>

<script src="js/jquery-fixedheadertable.js" type="text/javascript"></script>



