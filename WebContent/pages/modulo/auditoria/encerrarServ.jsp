<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarAuditoria!prepararPesquisa.action" namespace="/app/auditoria" />';
        		submitForm(vForm);
            }
            
            
            
            function gravar(){
                submitForm(document.forms[0]);
            }

</script>


<s:form namespace="/app/auditoria" action="encerrarAuditoria!encerrarServ.action" theme="simple">

<s:hidden name="entidade.idMovimentoApartamento" />
<s:hidden name="restaurante" />
<div class="divFiltroPaiTop">Fechamento dia</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style='height:190px; <s:property value="checkinList.size() > 0?\"width:400px;\" :\";\" " />'>
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
                    		<img src="imagens/msgSucesso.png" title='Existem lançados contratos nesta data' ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Não há Contratos de serviços lançados nesta data ' >
                    	</s:else>
                    </div>
                </div>
          
              </div>
             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
	                    <s:if test='%{(contratosLancados!=null) && (!contratosLancados.equals("0"))}'>
		                    <duques:botao label="Encerrar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
	                    </s:if>
              </div>
              
        </div>
</div>
</s:form>