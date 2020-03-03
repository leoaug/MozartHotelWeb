<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
$('#linhaContasReceber').css('display','block');

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarContasReceber!prepararPesquisa.action" namespace="/app/financeiro" />';
	submitForm( vForm );
}			            
            
function gravar(){
    submitForm(document.forms[0]);
}

</script>


<s:form namespace="/app/financeiro" action="encerrarContasReceber!encerrar.action" theme="simple">

<div class="divFiltroPaiTop">Encerramento</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:140px;">
                <div class="divGrupoTitulo">Atenção</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Esta rotina só poderá ser executada uma única vez por dia;</p> 
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Verifique se todos os movimentos estão corretos;</p> 
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Confirme se todos os relatórios foram emitidos;</p> 
                    </div>
                </div>
              </div>

              <div class="divGrupo" style="height:200px;">
                <div class="divGrupoTitulo">Validações</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Data contas receber: </p>
                    	<s:if test="%{#session.CONTROLA_DATA_SESSION.contasReceber.compareTo(#session.CONTROLA_DATA_SESSION.faturamentoContasReceber) >= 0}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Data Contas a Receber é maior ou igual a do Faturamento.' >
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Data Contas a Receber é menor a do Faturamento." ></img>
                    	</s:else>
                    </div>
                </div>

               

              </div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    
                    <s:if test="%{#session.CONTROLA_DATA_SESSION.contasReceber.compareTo(#session.CONTROLA_DATA_SESSION.faturamentoContasReceber)==-1}">
	                    <duques:botao label="Encerrar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
                    </s:if>
              </div>
              
        </div>
</div>
</s:form>