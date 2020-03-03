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
					alerta("Cada campo 'Origem' é obrigatório.");
					return false;
				}

           		qtde = $("input:hidden[class='idCidadeDestino'][value='']").length;
				if ( qtde  > 0){
					alerta("Cada campo 'Destino' é obrigatório.");
					return false;
				}
					
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="encerrarAuditoria!gravarCheckin.action" namespace="/app/auditoria" />';
        		submitForm(vForm);

			}

            

</script>


<s:form namespace="/app/contacorrente" action="pesquisar!lancarContrato.action" theme="simple">

<div class="divFiltroPaiTop">Lançamento de Contratos</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style='height:190px; '>
                <div class="divGrupoTitulo">Atenção</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Esta rotina só poderá ser executada uma única vez por dia;</p> 
                    </div>
                </div>
              </div>
	
              <div class="divGrupo" style="height:240px; ">
                <div class="divGrupoTitulo">Validações</div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Lançamento dos Contratos: </p>
                    	<s:if test='%{(contratosLancados!=null) && (!contratosLancados.equals("0"))}'>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Contratos de serviços já foram lançados nesta data' >
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Não foram lançados contratos nesta data" ></img>
                    	</s:else>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Contratos Vencidos: </p>
                    	<s:if test='%{contratosVencidos!=null && !contratosVencidos.equals("")}'>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes contratos estão vencidos: <s:property value="contratosVencidos"/>' >
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Não existem contratos vencidos" ></img>
                    	</s:else>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Contratos sem abertura de Conta Corrente: </p>
                    	<s:if test='%{contratosSemContaAberta!=null && !contratosSemContaAberta.equals("")}'>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes contratos não possuem conta corrente aberta: <s:property value="contratosSemContaAberta"/>' ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Não existem contratos sem conta corrente aberta" ></img>
                    	</s:else>
                    </div>
                </div>
              </div>

             <div class="divCadastroBotoes">
                    <s:if test='%{(contratosLancados==null || contratosLancados.equals("0")) && contratosSemContaAberta==null && contratosVencidos==null}'>
	                    <duques:botao label="Lançar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
                    </s:if>
              </div>
              
        </div>
</div>
</s:form>