<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
			$('#linhaFaturamento').css('display','block');
			function cancelar(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="pesquisarFaturamento!prepararPesquisa.action" namespace="/app/financeiro" />';
				submitForm( vForm );
			}
			            
            
            function gravar(){
                submitForm(document.forms[0]);
            }

</script>


<s:form namespace="/app/financeiro" action="manterFaturamento!encerrar.action" theme="simple">

<div class="divFiltroPaiTop">Encerramento</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:140px;">
                <div class="divGrupoTitulo">Atenção</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Esta rotina só poderá ser executada uma única vez por dia;</p> 
                    </div>
                </div>
              </div>

              <div class="divGrupo" style="height:200px;">
                <div class="divGrupoTitulo">Validações</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Data faturamento: </p>
                    	<s:if test="%{bDataFaturamento}">
                    		<img src="imagens/msgSucesso.png" title="O faturamento ainda não foi encerrado." ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='O faturamento JÁ FOI ENCERRADO HOJE.' >
                    	</s:else>
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Duplicatas a faturar: </p>
                    	<s:if test="%{bDuplicataAFaturar}">
                    		<img src="imagens/msgSucesso.png" title="Não existem duplicatas a faturar." ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Existem duplicatas a faturar.' ></img>
                    		
                    	</s:else>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Classificação contábil:</p>
                    	<s:if test='%{bClassificacaoContabil}'>
                    		<img src="imagens/msgSucesso.png" title="Cadastro de classificação contábil ok." ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/iconic/png/xRed-3x.png" title="Não possui classificação contábil cadastrada." ></img>
                    	</s:else>
                    </div>
                </div>

              </div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    
                    <s:if test="%{bDataFaturamento && bDuplicataAFaturar && bClassificacaoContabil}">
	                    <duques:botao label="Encerrar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
                    </s:if>
              </div>
              
        </div>
</div>
</s:form>