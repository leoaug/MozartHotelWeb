<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
			window.opener.killModal();

            function cancelar(){
            	window.close();
            }

            function pesquisar(){
            	loading();
            	submitFormAjax('pesquisarDisponibilidadeOcupacao?dataIn='+$('#dataIn').val()+'&dataOut='+$('#dataOut').val()+'&bloqueio='+$('#comBloqueio').val()+'&tipo='+$('#ocupacaoDisponibilidade').val(),true);
            	killModal();
             }
            
            
</script>


<s:form namespace="/app/crs" action="popup!prepararDisponibilidade.action" theme="simple">

<div class="divFiltroPaiTop">Dispo/Ocupação </div>
<div class="divFiltroPai" style="width:97%" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:50px;">
                <div class="divGrupoTitulo">Filtro</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:310px;" ><p style="width:80px;">Período:</p>                                 
                                <s:textfield cssClass="dp" name="dataIn" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataIn" size="8" maxlength="10" /> 
                                à 
                                <s:textfield cssClass="dp" name="dataOut" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataOut" size="8" maxlength="10" />
                    </div>
                    <div class="divItemGrupo" style="width:150px;" ><p style="width:70px;">Bloqueio:</p>
                    	<s:select list="#session.LISTA_CONFIRMACAO" 
                    			  listKey="id"
								  listValue="value" cssStyle="width:50px;"
								  id="comBloqueio" 
								  name="comBloqueio"
								  value="comBloqueio" />                               
                    </div>
                    <div class="divItemGrupo" style="width:200px;" ><p style="width:50px;">Tipo:</p>
                    	<s:select list="listaDispoOcupacao" 
                    			  listKey="id"
								  listValue="value" cssStyle="width:110px;"
								  id="ocupacaoDisponibilidade" 
								  name="ocupacaoDisponibilidade"
								  value="ocupacaoDisponibilidade" />                               
                    </div>
                    
                    <div class="divItemGrupo" style="width:30px;" >
                   		<img  src="imagens/iconic/png/magnifying-glass-3x.png" title="Pesquisar"  onclick="pesquisar();" />
                    </div>
                    
                </div>


              </div>

              <div class="divGrupo" style="height:390px;">
                <div class="divGrupoTitulo">Resultado</div>
                <div id="divBodyDisp" style="width: 99%; height: 365px; overflow-y: auto; margin:0px; padding:0px;">




				</div>
              </div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
              </div>
              
        </div>
</div>
</s:form>