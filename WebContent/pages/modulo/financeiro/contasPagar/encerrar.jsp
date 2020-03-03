<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
$('#linhaContasPagar').css('display','block');

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarContasPagar!prepararPesquisa.action" namespace="/app/financeiro" />';
	submitForm( vForm );
}
            
function gravar(){
    submitForm(document.forms[0]);
}

</script>


<s:form namespace="/app/financeiro" action="encerrarContasPagar!encerrar.action" theme="simple">

<div class="divFiltroPaiTop">Contas a pagar</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:140px;">
                <div class="divGrupoTitulo">Aten��o</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Esta rotina s� poder� ser executada uma �nica vez por dia;</p> 
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Verifique se todos os movimentos est�o corretos;</p> 
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Confirme se todos os relat�rios foram emitidos;</p> 
                    </div>
                </div>
              </div>


     		 <div class="divGrupo" style="height:200px;">
                <div class="divGrupoTitulo">Valida��es</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Data contas pagar: </p>
                    	<s:if test="%{#session.CONTROLA_DATA_SESSION.estoque.compareTo(#session.CONTROLA_DATA_SESSION.contasPagar) <= 0}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Data Estoque � menor ou igual que o Contas a Pagar - Encerre primeiro o Estoque!' >
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Data Estoque � maior que o Contas a Pagar." ></img>
                    	</s:else>
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Class. Cont�bil: </p>
                    	<s:if test="%{possuiClassificacaoContabil}">
                    		<img src="imagens/msgSucesso.png" title="Classifica��o cont�bil cadastrada." ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='A Classifica��o Cont�bil n�o foi cadastrada.' >
                    	</s:else>
                    </div>
                </div>
             </div>
              

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    
                    <s:if test="%{#session.CONTROLA_DATA_SESSION.estoque.compareTo(#session.CONTROLA_DATA_SESSION.contasPagar)>0 && possuiClassificacaoContabil}">
	                    <duques:botao label="Encerrar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
                    </s:if>
              </div>
              
        </div>
</div>
</s:form>