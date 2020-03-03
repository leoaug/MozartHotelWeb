<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

                      
            
            function gravar(){
                submitForm(document.forms[0]);
            }


            function getCidadeOrigemLookup(elemento, idx){
                url = 'app/ajax/ajax!selecionarCidade?OBJ_NAME='+elemento.id+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idCidadeOrigem'+idx;
                getDataLookup(elemento, url,'divOrigem','TABLE');
            }

            function getCidadeDestinoLookup(elemento, idx){
                url = 'app/ajax/ajax!selecionarCidade?OBJ_NAME='+elemento.id+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idCidadeDestino'+idx;
                getDataLookup(elemento, url,'divDestino','TABLE');
            }

            function alterarCheckins(){

				var qtde = $("input:hidden[class='idCidadeOrigem'][value='']").length;
				if ( qtde  > 0){
					alerta("Cada campo 'Origem' � obrigat�rio.");
					return false;
				}

           		qtde = $("input:hidden[class='idCidadeDestino'][value='']").length;
				if ( qtde  > 0){
					alerta("Cada campo 'Destino' � obrigat�rio.");
					return false;
				}
					
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="encerrarAuditoria!gravarCheckin.action" namespace="/app/auditoria" />';
        		submitForm(vForm);

			}

            

</script>


<s:form namespace="/app/contacorrente" action="pesquisar!lancarContrato.action" theme="simple">

<div class="divFiltroPaiTop">Lan�amento de Contratos</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style='height:190px; '>
                <div class="divGrupoTitulo">Aten��o</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Esta rotina s� poder� ser executada uma �nica vez por dia;</p> 
                    </div>
                </div>
              </div>
	
              <div class="divGrupo" style="height:240px; ">
                <div class="divGrupoTitulo">Valida��es</div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Lan�amento dos Contratos: </p>
                    	<s:if test='%{(contratosLancados!=null) && (!contratosLancados.equals("0"))}'>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Contratos de servi�os j� foram lan�ados nesta data' >
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="N�o foram lan�ados contratos nesta data" ></img>
                    	</s:else>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Contratos Vencidos: </p>
                    	<s:if test='%{contratosVencidos!=null && !contratosVencidos.equals("")}'>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes contratos est�o vencidos: <s:property value="contratosVencidos"/>' >
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="N�o existem contratos vencidos" ></img>
                    	</s:else>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Contratos sem abertura de Conta Corrente: </p>
                    	<s:if test='%{contratosSemContaAberta!=null && !contratosSemContaAberta.equals("")}'>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes contratos n�o possuem conta corrente aberta: <s:property value="contratosSemContaAberta"/>' ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="N�o existem contratos sem conta corrente aberta" ></img>
                    	</s:else>
                    </div>
                </div>
              </div>

             <div class="divCadastroBotoes">
                    <s:if test='%{(contratosLancados==null || contratosLancados.equals("0")) && contratosSemContaAberta==null && contratosVencidos==null}'>
	                    <duques:botao label="Lan�ar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
                    </s:if>
              </div>
              
        </div>
</div>
</s:form>