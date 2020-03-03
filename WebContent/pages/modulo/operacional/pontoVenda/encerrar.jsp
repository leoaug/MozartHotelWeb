<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                submitForm(document.forms[0]);
            }

</script>


<s:form namespace="/app/operacional" action="encerrarPontoVenda!encerrar.action" theme="simple">

<div class="divFiltroPaiTop">Ponto de Venda </div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:140px;">
                <div class="divGrupoTitulo">Atenção</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Esta rotina só poderá ser executada uma única vez por dia;</p> 
                    </div>
                </div>
              </div>

              <div class="divGrupo" style="height:80px;">
                <div class="divGrupoTitulo">Ponto de Venda</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;color:black;">Ponto de Venda: </p>
					<s:select list="pontoVendaList"
							  cssStyle="width:200px;"
							  listKey="id.idPontoVenda"
							  listValue="nomePontoVenda"
							  name="entidade.id.idPontoVenda"				
					 />
                    </div>
                </div>
                
                <s:if test="%{pontoVendaList.size() > 0}">
	                <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;color:black;">Status:</p>
                    		<img src="imagens/iconic/png/xRed-3x.png" title="Os pontos de vendas acima devem ser encerrados." ></img>
	                    </div>
	                </div>
                </s:if>
                <s:else>
	                <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;color:black;">Status:</p>
                    		<img src="imagens/msgSucesso.png" title="Os pontos de vendas foram encerrados." ></img>
	                    </div>
	                </div>
                </s:else>
                
                <s:if test="%{pontoVendaList.size() > 0 && quantidadeMovimentosAbertos > 0}">
	                <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;color:black;">Mesas:</p>
                    		<img src="imagens/iconic/png/xRed-3x.png" title="Mesas com lançamento em aberto. Fechar mesas para encerrar." ></img>
	                    </div>
	                </div>
                </s:if>
                <s:else>
	                <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;color:black;">Mesas:</p>
                    		<img src="imagens/msgSucesso.png" title="Os pontos de vendas podem ser encerrados." ></img>
	                    </div>
	                </div>
                </s:else>

              </div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    
                    <s:if test="%{pontoVendaList.size() > 0 && quantidadeMovimentosAbertos == 0}">
	                    <duques:botao label="Encerrar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
                    </s:if>
              </div>
              
        </div>
</div>
</s:form>

<script type="text/javascript">
$(function() {
    
    $(window).load( function () { 
    	
        <s:if test='%{#quantidadeMovimentosAbertos > 0}'>
          alert("Mesas com lançamento em aberto. Fechar contas");
		</s:if>

    } );
});
</script>