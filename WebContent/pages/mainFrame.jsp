<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<jsp:scriptlet>
        String  base = request.getRequestURL().toString().substring(0, request.getRequestURL().toString().indexOf(request.getContextPath())+request.getContextPath().length()+1);
        String BROWSER_TYPE = (String)session.getAttribute("BROWSER_TYPE");
        if (BROWSER_TYPE==null || BROWSER_TYPE == ""){
        	BROWSER_TYPE = "ie";
        	session.setAttribute("BROWSER_TYPE","ie");
        	session.setAttribute("EXPIROU","TRUE");
        }
</jsp:scriptlet>
<html>
<head>
   <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" /> 
   <meta http-equiv="content-language" content="pt-br" /> 
   <meta http-equiv="content-type" content="text/html;charset=iso-8859-1" /> 
   <meta name="robots" content="index, follow" /> 
   <meta http-equiv="pragma" content="no-cache" /> 
   <meta http-equiv="Cache-Control" content="no-cache, no-store" /> 
   <meta http-equiv="Pragma" content="no-cache, no-store" /> 
   <meta http-equiv="expires" content="Mon, 06 Jan 1990 00:00:01 GMT" /> 
   <link rel="SHORTCUT ICON" href="imagens/favicon.ico"  type="image/x-icon" />
   <meta name="description" content="Mozart WEB - para você que sonhava em hospedar o melhor em tecnologia" />

<script type="text/javascript">
            function fecharSessao(){
                  document.getElementById("idMain").src = '<s:url action="login!logout.action" namespace="/" />';
                  self.close();
            }
      </script>
</head>

<base href="<%=base%>" />
<title>Web Login</title>
   <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" /> 
   <meta http-equiv="content-language" content="pt-br" /> 
   <meta http-equiv="content-type" content="text/html;charset=iso-8859-1" /> 
   <meta name="robots" content="index, follow" /> 
   <meta http-equiv="pragma" content="no-cache" /> 
   <meta http-equiv="Cache-Control" content="no-cache, no-store" /> 
   <meta http-equiv="Pragma" content="no-cache, no-store" /> 
   <meta http-equiv="expires" content="Mon, 06 Jan 1990 00:00:01 GMT" /> 
   <link rel="SHORTCUT ICON" href="imagens/favicon.ico"  type="image/x-icon" />
   <meta content="width=device-width, initial-scale=1" name="viewport" />
   <meta name="description" content="Mozart WEB - para você que sonhava em hospedar o melhor em tecnologia" />


<link href="css/geral.css" rel="stylesheet" type="text/css" media="all" />
<link href="css/<%=session.getAttribute("BROWSER_TYPE")%>/mozartHotel.css"
	rel="stylesheet" type="text/css" media="all" />
<link href="css/<%=session.getAttribute("BROWSER_TYPE")%>/sitemesh.css"
	rel="stylesheet" type="text/css" media="all" />
<link href="css/<%=session.getAttribute("BROWSER_TYPE")%>/grid.css"
	rel="stylesheet" type="text/css" media="all" />

<link href="css/modal.css" rel="stylesheet" type="text/css" media="all" />

<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" media="all" />

<link href="css/fontawesome.css" rel="stylesheet" type="text/css" media="all" />

<script src='js/jquery.min.js' type='text/javascript'></script>
<script src='js/popper.min.js' type='text/javascript'></script>
<script src='js/bootstrap.min.js' type='text/javascript'></script>

<script src='js/jquery-1.4.2.js' type='text/javascript'
	language='JavaScript1.2'></script>
		
<script src='js/jquery-modal-1.3.js' type='text/javascript'
	language='JavaScript1.2'></script>
	
<script src='js/geral.js' type='text/javascript'
	language='JavaScript1.2'></script>

<script src='js/<%=session.getAttribute("BROWSER_TYPE")%>/mozart.js'
	type='text/javascript' language='JavaScript1.2'></script>
	
<script type='text/javascript'
	language='JavaScript1.2'>

	function autenticar(){
		submitForm(document.forms[0]);
	}

	$(document).ready(function(){ 

		$("body, input, textarea").keypress(function(e) {
			  	code = e.keyCode ? e.keyCode : e.which;
			    tecla_shift = e.shiftKey?e.shiftKey:((code == 16)?true:false);
			    if(((code >= 65 && code <= 90) && !tecla_shift) || ((code >= 97 && code <= 122) && tecla_shift)) {
			        showModal('#divCapsLock');
			        return false;
			    }else {
					killModal();
			    }

	  		    if(code.toString() == '13') { 
	      			  autenticar();
			    } 
		});
		
		$(window).load( function () { 
						
			if ($.browser.msie && parseInt($.browser.version) <= 6){
				showModal('#divIE6');
			}
					   
        } );
		

		
		});
		
</script>

<body class="bodyClique" id="bodyBemVindo">
<duques:showMessage imagem="" />
<s:form action="/login!logar.action" theme="simple" id="login_form"
	cssClass="login_form">
	 
	<div id="divCapsLock" class="divMsgSucesso" style='display:none; position:absolute; top:0px; left:0px;'>
    <h1>Mensagem:</h1>
    <img src="imagens/iconic/png/check-2x.png" />
    <label>Desative o Caps Lock para autenticação </label>
    <br clear="all"/>
    <input type="button" value="Fechar" onclick="killModal();" />
    </div>

	<div id="divIE6" class="divMsgSucesso" style='display:none; position:absolute; top:0px; left:0px;'>
    <h1>Mensagem:</h1>
    <img src="imagens/iconic/png/check-2x.png" />
    <label>Esta versão do Internet Explorer não é permitida, atualize-a ou utilize o Firefox ou Chrome.</label>
    <br clear="all"/>
    </div>

	<div class="divBemVindo">
		<div class="divBemVindoLeft">
			<h2>Login</h2>
			<div class="input-group form-group loginText">
				<div class="input-group-prepend">
					<span class="input-group-text"><img src="imagens/iconic/png/person-2x.png" ></img></span>
				</div>
				<s:textfield cssClass="form-control" cssStyle="text-transform: uppercase;" onblur="this.value = this.value.toUpperCase();" name="login" />
			</div>
			<div class="input-group form-group loginText">
				<div class="input-group-prepend">
					<span class="input-group-text"><img src="imagens/iconic/png/key-2x.png" ></img></span>
				</div>
				<s:password cssClass="form-control" id="senha" name="senha" />
			</div>
			<div class="form-group">
				<button type="button" onclick="autenticar();" class="btn btn-primary">Login</button>
			</div>
		</div>
		<div class="divBemVindoRight">
			 <img src="data:image/gif;base64,${imgBase}" />
		</div>
	</div>
</s:form>


</body>
</html>

<s:if test="%{#session.FORA_HORA == \"TRUE\"}">
<%session.removeAttribute("FORA_HORA");%>
<script>
	alerta("Você não está no horário definido pelo gerente.");
</script>
</s:if>