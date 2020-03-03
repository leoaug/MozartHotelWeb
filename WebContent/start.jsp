<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.mozart.web.util.MozartConstantesWeb"%>
<%@ taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!--
< jsp : useBean id="samplePagadorSoapProxyid" scope="session"
	class="br.com.pagador.www.webservice.pagador.PagadorSoapProxy" />
--><jsp:scriptlet>
        request.getSession(true);
        String  base = request.getRequestURL().toString().substring(0, request.getRequestURL().toString().indexOf(request.getContextPath())+request.getContextPath().length()+1);
        if (request.getParameter("indet") != null || request.getAttribute("indet") != null){
            request.setAttribute(MozartConstantesWeb.MENSAGEM_ERRO,"A sua sessão expirou.");
        }
        String BROWSER_TYPE = request.getParameter("BROWSER_TYPE");
        if (BROWSER_TYPE == null || BROWSER_TYPE.trim().length() == 0){
            session.setAttribute("BROWSER_TYPE", "ie");
        }else{
            session.setAttribute("BROWSER_TYPE", BROWSER_TYPE);
        }
        session.setAttribute("URL_BASE", base);
</jsp:scriptlet>

<html>
<head>
<title>Web Login</title>
   <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" /> 
   <meta http-equiv="content-language" content="pt-br" /> 
   <meta http-equiv="content-type" content="text/html;charset=iso-8859-1" /> 
   <!-- <meta http-equiv="refresh" content="160" /> --> 
   <meta name="robots" content="index, follow" /> 
   <meta http-equiv="pragma" content="no-cache" /> 
   <meta http-equiv="Cache-Control" content="no-cache, no-store" /> 
   <meta http-equiv="Pragma" content="no-cache, no-store" /> 
   <meta http-equiv="expires" content="Mon, 06 Jan 1990 00:00:01 GMT" /> 
   <link rel="SHORTCUT ICON" href="imagens/favicon.ico"  type="image/x-icon" />
   <meta name="description" content="Mozart WEB - para você que sonhava em hospedar o melhor em tecnologia" />

<link href="css/<%=session.getAttribute("BROWSER_TYPE")%>/mozartHotel.css"
	rel="stylesheet" type="text/css" media="all" />
<link href="css/${sessionScope.BROWSER_TYPE}/sitemesh.css"
	rel="stylesheet" type="text/css" media="all" />
<link href="css/${sessionScope.BROWSER_TYPE}/grid.css" rel="stylesheet"
	type="text/css" media="all" />
<script src='js/divScroll.js' type='text/javascript'
	language='JavaScript1.2'></script>
<script src='js/jquery-1.4.2.js' type='text/javascript'
	language='JavaScript1.2'></script>
<script src='js/interface.js' type='text/javascript'
	language='JavaScript1.2'></script>

<script language="javaScript" type="text/javascript">
        function start(){
            window.open("<%=base%>pages/mainFrame.jsp","marcio", ',status=yes,resizable=no,location=no,type=fullWindow,fullscreen,scrollbars=yes');
            window.location.href= 'http://www.mozart.com.br';
        }

    </script>
<base href="<%=base%>" />
</head>
<body class="bodyClique" id="bodyBemVindo">

<div class="divBemVindo" id="divBemVindo">
<h1>Seja bem vindo ao Portal Mozart.</h1>
<ul>
	<li>É necessário o desbloqueio de pop-ups, configure seu browser.</li>
	<li>Para uma melhor visualização, configure a resolução da sua
	tela para <b>1024 x 768</b>.</li>
	<li>Para acessar o Portal Mozart clique <a
		href="javascript:start()">aqui</a>.</li>
	<!-- < %

String merchantId_1idTemp = "{20B2A695-058E-0888-9334-4A39D550505D}";
String orderId_2idTemp = "2";
String customerName_3idTemp = "Marcio";
String amount_4idTemp = "1,00";
String paymentMethod_5idTemp = "18";
String holder_6idTemp = "TESTE";
String cardNumber_7idTemp = "345678901234564";
String expiration_8idTemp = "08/01";
String securityCode_9idTemp = "1234";
String numberPayments_10idTemp = "1";
String typePayment_11idTemp = "0";


br.com.pagador.www.webservice.pagador.PagadorReturn authorize13mtemp = null;
if ("sim".equalsIgnoreCase(request.getParameter("testws"))){
    authorize13mtemp = samplePagadorSoapProxyid.authorize(merchantId_1idTemp,orderId_2idTemp,customerName_3idTemp,
    amount_4idTemp,paymentMethod_5idTemp,holder_6idTemp,cardNumber_7idTemp,expiration_8idTemp,securityCode_9idTemp,numberPayments_10idTemp,typePayment_11idTemp);
}
    if(authorize13mtemp != null){
%>
	<li>Return: < %=authorize13mtemp.getReturnCode()%></li>
	<li>Valor: < %=authorize13mtemp.getAmount()%></li>
	<li>authorisationNumber: < %=authorize13mtemp.getAuthorisationNumber()%></li>
	<li>Message: < %=authorize13mtemp.getMessage()%></li>
	<li>transactionId: < %=authorize13mtemp.getTransactionId()%></li>
	<li>Return code: < %=authorize13mtemp.getReturnCode()%></li>

	< %}else{%>

	<li>.< %//request.getParameter("testws")%></li>

	< %}%>

-->
</ul>
</div>


<duques:showMessage imagem="" />
</body>
</html>
