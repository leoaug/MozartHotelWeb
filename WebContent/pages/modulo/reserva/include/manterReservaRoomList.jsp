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
    <title>manterReservaRoomList</title>
    <jsp:include page="/pages/modulo/includes/headPage.jsp" />
  </head>
  <body>
  <s:form namespace="/app/reserva" action="include!prepararRoomList" theme="simple">        
  
<script type="text/javascript">
    function getHospede(elemento,hidden){        
         url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarHospedeRoomList?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN='+hidden;
         getDataLookup(elemento, url,'Hospede','TABLE');
    }
    
    function atualizarResAptoRoomList(hospedeNome,hospedeId,indiceResApto,indiceRoomList) {        
        submitFormAjax('atualizarReservaApartamentoRoomList?hospedeNome='+hospedeNome+'&hospedeId='+hospedeId+'&indiceResApto='+indiceResApto+'&indiceRoomList='+indiceRoomList,true);
    }
        
    function desabilitaCampos() {
        //Tive q fazer isso pq a zorra n habilita dentro do iframe, até desabilita, mas habilitar n!! ai fode td! poha!
        var todosInputs = document.getElementsByTagName('input');            
        for (i=0; i< todosInputs.length; i++) {
            if (todosInputs[i].getAttribute('enabled')=='false')
                todosInputs[i].disabled=1;
        }        
    }


    function alterarApartamento( obj ){
    	
    	var indice = $("select[name='idAptoResApto']").index(obj);
    	var idApto = obj.value;
        submitFormAjax('atualizaReservaApartamentoApto?indice='+indice+'&idApto='+idApto,true);

    } 
    
    
    function validaECarregaApartamentos(indice){
        erro = '';    
        campoDataEntrada = '';
        campoDataSaida = '';
        campoIdTipoApartamento = '';
        
        campoDataEntrada = 'bcDataEntrada'+indice;
        campoDataSaida = 'bcDataSaida'+indice;
        campoIdTipoApartamento = 'bcIdTipoApartamento'+indice;
            
        dataEntrada = document.getElementById(campoDataEntrada).value;
        dataSaida = document.getElementById(campoDataSaida).value;
        idTipoApartamento = document.getElementById(campoIdTipoApartamento).value;
        submitFormAjax('carregarApartamentos?dataEntrada='+dataEntrada+'&dataSaida='+dataSaida+'&idTipoApartamento='+idTipoApartamento+'&indiceResApto='+indice,true);
        
        idSelecionado = '#bcIdAptoSelecionado'+indice; 
        campoIdApartamento = '#bcIdApartamento'+indice;
        
        if ($(idSelecionado).val() != ''){
        	$(campoIdApartamento).val($(idSelecionado).val());
        }
    }

    
</script>
  
    <div style="height: 310px; margin-top:3px;">        
        <s:iterator value="#session.TELA_RESERVA_RESERVA_APARTAMENTO" var="resAptoCorr" status="row" >
        
             <input type="hidden" id="bcDataEntrada${row.index}" value="<s:property  value="bcDataEntrada" />" />
             <input type="hidden" id="bcDataSaida${row.index}"  value="<s:property  value="bcDataSaida" />"/>
             <input type="hidden" id="bcIdTipoApartamento${row.index}"  value="<s:property  value="bcIdTipoApartamento" />"/>
             <input type="hidden" id="bcIdAptoSelecionado${row.index}"  value="<s:property  value="bcIdApartamento" />"/>
        
          
            <s:set name="gridCor" value="%{'rgb(255,165,165)'}" />
            <s:set name="display" value="%{''}" />            
            <s:if test='%{"S".equals(bcCheckout)}%'>
                <s:set name="gridCor" value="%{'Olive'}" />
            </s:if>
            <s:elseif test='%{ "1".equals(bcQtdeCheckin.toString()) }'>
                <s:set name="gridCor" value="%{'Aqua'}" />
                <s:set name="display" value="%{'disabled=\"disabled\"'}" />                                
            </s:elseif>                                         
            <s:elseif test='%{ "S".equals(bcNoShow) }'>
                <s:set name="display" value="%{'Yellow'}" />
            </s:elseif>                                                     
            <div class="divLinhaCadastro fontePadrao" id="divLinha${row.index}" style="WIDTH: 99%; background-color: <s:property value="#gridCor"  />;">                            
                    <div class="divItemGrupo" style="width:60px; align:center;" ><s:property  value="BcTipoApartamentoDesc" /></div>
                    <div class="divItemGrupo" style="width:60px;"><s:property  value="bcQtdePaxDesc" /></div>
                    
                    <div class="divItemGrupo" style="width:60px;float:left;" >
                    		<select style="width:53px;" id="bcIdApartamento${row.index}" name="idAptoResApto" onchange="alterarApartamento(this);" class="selectApto"></select> 
	                </div>
	                    
                    <s:iterator value="listRoomList" var="roomListCorr" status="rowRoomList" >
                        <div class="divItemGrupo" style="width:100px;float:left;">
                        	<s:if test="%{#display==''}">
	                            <input type="text"  onkeypress="toUpperCase(this)"  style="width: 85px;" onblur="getHospede(this,'hiRoomList-${row.index}/${rowRoomList.index}')" id="txtRoomList-${row.index}/${rowRoomList.index}" name="txtRoomList-${row.index}/${rowRoomList.index}" value="<s:property value="bcNomeHospede"/>" />
								<input type="text"  readonly="readonly" style="width: 1px; border:0px; background-color: <s:property value="#gridCor"  />;"  />
	                            <input type="hidden" id="hiRoomList-${row.index}/${rowRoomList.index}" value="<s:property value="bcIdRoomList"/>" /> 
                        	</s:if>
                        	<s:else>
	                            <input type="text"  <s:property value="#display" />  onkeypress="toUpperCase(this)" style="width: 85px;" onblur="getHospede(this,'hiRoomList-${row.index}/${rowRoomList.index}')" id="txtRoomList-${row.index}/${rowRoomList.index}" name="txtRoomList-${row.index}/${rowRoomList.index}" value="<s:property value="bcNomeHospede"/>" />
	                            <input type="hidden" id="hiRoomList-${row.index}/${rowRoomList.index}" value="<s:property value="bcIdRoomList"/>" /> 
                        	</s:else>                                                 
                        </div>
                    </s:iterator>
            </div>
            <script>
        		validaECarregaApartamentos('${row.index}');
        	</script>
            
        </s:iterator>
        <script> desabilitaCampos(); </script>
    </div>
  </s:form>
  </body>
</html>