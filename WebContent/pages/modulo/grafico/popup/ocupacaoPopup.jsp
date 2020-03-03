<%@ page contentType="text/html;charset=iso-8859-1" import="com.mozart.model.vo.OcupDispVO"%>
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
    <base href="<%=base%>" />
    <jsp:include page="/pages/modulo/includes/headPage.jsp" />
<s:form namespace="/app/reserva" action="include!pesquisarOcupacaoDisponibilidade" theme="simple">

    
<script type="text/javascript">

    function init(){
        
    }
    
    function verificaPreenchidoESubmete() {
        erro = '';
        if (document.getElementById('reservaVO.bcDataEntrada').value=='')
            erro += '- Insira a data inicial.\n';
        if (document.getElementById('reservaVO.bcDataSaida').value=='')
            erro += '- Insira a data final.\n';
        if (erro=='') {
            document.forms[0].submit();
        }
        else
            alert(erro);
    }
    
</script>
    
    <input type="hidden" name="id" />

    <div class="divFiltroPaiTop">Ocupação
    </div>

    <div id="divFiltroPai" class="divFiltroPai" >
        <div id="divFiltro" class="divCadastro" style="overflow:auto;height:540px;width:940px;" >
            
        
            <!--Início dados da ocupacao -->
             <div class="divGrupo" style="width:720px; height:60px;">
                <div class="divGrupoTitulo" style="margin-top: 7px;" >Informe o período...</div>
                
                <div class="divLinhaCadastro" >
                    <div class="divItemGrupo" style="width:80%;" ><p>Período:</p>                                 
                                <s:textfield cssClass="dp" name="reservaVO.bcDataEntrada" onkeypress="mascara(this,data);" id="reservaVO.bcDataEntrada" size="8" maxlength="10" /> 
                                à
                                <s:textfield cssClass="dp" name="reservaVO.bcDataSaida" onkeypress="mascara(this,data);" id="reservaVO.bcDataSaida" size="8" maxlength="10" /> 
                    </div>
                </div>
              </div>
              <div class="divCadastroBotoes" style="width:120px; margin-top:20px; float:left;">
                    <duques:botao label="Pesquisar" imagem="imagens/pesquisar.png" onClick="verificaPreenchidoESubmete();" />
              </div>
              <s:radio list="#session.listaOcupacaoDisponibilidade" id="reservaVO.ocupacaoDisponibilidade" name="reservaVO.ocupacaoDisponibilidade" listKey="id" listValue="value" />
              <!--Fim dados da ocupacao-->
    <!--Início divDisponibilidade -->
    <!--div class="divOcupacao" id="divOcupacao"-->
        <s:set name="display" value="%{''}"/>                
        <s:iterator value="#session.listOcupDisp" var="ocupDispVO" status="row" >          
            <!--Inicio de cada dia-->            
            
            <!-- colocando a cor pra quando for ocupacao / disponibilidade-->
            <s:set name="gridCor" value="%{'yellow'}"/>
            <s:set name="gridCorLetra" value="%{'black'}"/>
            
            <s:set name="gridCorTotal" value="%{'yellow'}"/>            
            <s:set name="gridCorTotalLetra" value="%{'black'}"/>            
            <s:if test="%{reservaVO.ocupacaoDisponibilidade.longValue() == 1 }">         <!-- problema nessa comparação!! o valor vem setado O mas n consegue verificar! Shitttt!-->   
                <s:if test="%{valor.longValue() <= 33 }">
                    <s:set name="gridCor" value="%{'green'}"/>
                    <s:set name="gridCorLetra" value="%{'white'}"/>
                </s:if>
                <s:elseif test="%{valor.longValue() >= 66 }">
                    <s:set name="gridCor" value="%{'red'}"/>
                    <s:set name="gridCorLetra" value="%{'white'}"/>
                </s:elseif>
                <s:if test="%{percentDia.longValue() <= 33 }">
                    <s:set name="gridCorTotal" value="%{'green'}"/>
                    <s:set name="gridCorTotalLetra" value="%{'white'}"/>
                </s:if>
                <s:elseif test="%{percentDia.longValue() >= 66 }">
                    <s:set name="gridCorTotal" value="%{'red'}"/>
                    <s:set name="gridCorTotalLetra" value="%{'white'}"/>
                </s:elseif>
            </s:if>
            <s:else>
                <s:if test="%{valor.longValue() <= 33 }">
                    <s:set name="gridCor" value="%{'red'}"/>
                    <s:set name="gridCorLetra" value="%{'black'}"/>
                </s:if>
                <s:elseif test="%{valor.longValue() >= 66 }">
                    <s:set name="gridCor" value="%{'green'}"/>
                    <s:set name="gridCorLetra" value="%{'black'}"/>
                </s:elseif>
                <s:if test="%{percentDia.longValue() <= 33 }">
                    <s:set name="gridCorTotal" value="%{'red'}"/>
                    <s:set name="gridCorTotalLetra" value="%{'black'}"/>
                </s:if>
                <s:elseif test="%{percentDia.longValue() >= 66 }">
                    <s:set name="gridCorTotal" value="%{'green'}"/>
                    <s:set name="gridCorTotalLetra" value="%{'black'}"/>
                </s:elseif>
            </s:else>
            <!-- fim colocando a cor pra quando for ocupacao / disponibilidade-->
            
            <!-- montando as divs de ocupacao/disponibilidade-->
            <s:if test="%{#display == '' }">
                <s:set name="display" value="%{data}"/>                 
                <!--Abre div-->                
                <div class="divOcupacaoGrupo" style="width: 222px; height:190px;" >
                    <h1>Dia: <s:property value="data"/> </h1>                    
                    
            </s:if>
            <s:if test="%{#display != data }">
                <!--fecha div-->
                <s:set name="display" value="%{data}"/>                                                     
                </div> 
                <div class="divOcupacaoGrupo" style="width: 222px; height:190px;" > 
                    <h1>Dia: <s:property value="data"/> </h1>                                        
            </s:if>
            <s:if test="{#display == data }">            
                <!--valores-->
                    <div class="divOcupacaoGrupoLi">
                        <p><s:property value="fantasia"/>:</p>
                        <div class="divBarOcupacao" style="width: 152px;" >
                            <h1 style="width: <s:property value="valor"/>%; color: <s:property value="gridCorLetra" />; background-color: <s:property value="gridCor"/>;"><s:property value="valor"/></h1>
                        </div>
                    </div>
                    
                    <s:if test="%{ultimoDoDia.longValue() == 1}">
                        <div class="divOcupacaoGrupoLi">
                            <p>TOTAL:</p>
                            <div class="divBarOcupacao" style="width: 152px;" >
                                <h1 style="width: <s:property value="totDiaString"/>%; color: <s:property value="gridCorTotalLetra" />;  background-color: <s:property value="gridCorTotal"/>;"><s:property value="totDia"/></h1>
                            </div>
                        </div>
                        <div class="divOcupacaoGrupoLi">
                            <p>% DIÁRIO:</p>
                            <div class="divBarOcupacao" style="width: 152px;" >
                                <h1 style="width: <s:property value="percentDiaString"/>%; color: <s:property value="gridCorTotalLetra" />;  background-color: <s:property value="gridCorTotal"/>;"><s:property value="percentDia"/>%</h1>
                            </div>
                        </div>                        
                    </s:if>
            </s:if>
            <!-- fim montando as divs de ocupacao/disponibilidade-->
            
        </s:iterator>

    <!--Fim divDisponibilidade -->
        </div>  
              
        </div>
    </div>
</s:form>