<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

$('#linhaMovimentoContabil').css('display', 'block');

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarImobilizadoDepreciacao!prepararPesquisa.action" namespace="/app/contabilidade" />';
	submitForm( vForm );
}
            
function gravar(){
    submitForm(document.forms[0]);
}

</script>


<s:form namespace="/app/contabilidade" action="encerrarImobilizadoDepreciacao!encerrar.action" theme="simple">

<div class="divFiltroPaiTop">Lançamento</div>
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
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Lançamento de depreciação: </p>
                    	<s:if test="%{possuiDepreciacao}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Depreciação já foram lançadas' >
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Depreciação ainda não foram lançadas" ></img>
                    	</s:else>
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Controle do Ativo Fixo: </p>
                    	<s:if test="%{validaCheckinAtivoFixo !=null && validaCheckinAtivoFixo !=''}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='As seguintes contas estão sem o número do controle do ativo fixo. Cadastre: <s:property value="validaCheckinAtivoFixo"/>' >
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Todos os lançamentos estão com o número do controle do ativo fixo" ></img>
                    	</s:else>
                    </div>
                </div>
             </div>
              

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    
                    <s:if test="%{(validaCheckinAtivoFixo ==null || validaCheckinAtivoFixo =='') && !possuiDepreciacao}">
	                    <duques:botao label="Encerrar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
                    </s:if>
              </div>
              
        </div>
</div>
</s:form>