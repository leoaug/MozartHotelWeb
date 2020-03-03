<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=windows-1252" import="com.mozart.model.vo.ReservaApartamentoVO" %>
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
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
    <jsp:include page="/pages/modulo/includes/headPage.jsp" />
  </head>
  <body>
  <s:form namespace="/app/reserva" action="include!prepararRoomList" theme="simple">        
  
<script type="text/javascript">
    
    function atualizaValor(obj, indiceResAptoDiaria) {        
        var idResApto = parent.document.getElementById('indiceResApto').value;
        submitFormAjax('atualizarReservaApartamentoDiaria?valor='+obj.value+'&indiceResAptoDiaria='+indiceResAptoDiaria+'&idResApto='+idResApto,true);
    }
                
</script>
  
    <div style="height: 400px; margin-top:3px;">
        <s:iterator value="#session.TELA_RESERVA_RESERVA_APARTAMENTO_DIARIA_CORRENTE" var="resAptoCorr" status="row" >                        
            <div class="divLinhaCadastro fontePadrao" id="divLinha${row.index}" style="background-color: rgb(255,165,165);">                            
                    <div class="divItemGrupo" style="width:110px;" ><s:property  value="bcData" /></div>
                    <div class="divItemGrupo" style="width:110px;" > 
                    	<input type="text" size="10" maxlength="8" id="txtDiaria-${row.index}" name="txtDiaria-${row.index}" value="<s:property value="bcTarifa"/>" onblur="atualizaValor(this,'${row.index}');" onkeypress="mascara( this, moeda );" />
                    	<input type="text" size="1" maxlength="" style="width:1px; border:0px; background-color: rgb(255,165,165);" />
                    </div>                    
            </div>
        </s:iterator>        
    </div>
  </s:form>
  </body>
</html>