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


<s:form namespace="/app/caixa" action="diariaAutomatica!lancar.action" theme="simple">

<div class="divFiltroPaiTop">Lançamento </div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:100px;">
                <div class="divGrupoTitulo">Atenção</div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Esta rotina só poderá ser executada uma única vez por dia;</p> 
                    </div>
                </div>
              </div>

              <div class="divGrupo" style="height:200px;">
                <div class="divGrupoTitulo">Validações</div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Lançamento das diárias: </p>
                    	<s:if test='%{diariaAutomaticaJaEfetuada =="0"}'>
                    		<img src="imagens/msgSucesso.png" title="As diárias automáticas ainda não foram lançadas hoje." ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='As diárias automáticas já foram lançadas hoje.' ></img>
                    	</s:else>
                    </div>
                </div>

                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Checkins vencidos: </p>
                    	<s:if test="%{checkinVencidos !=null && checkinVencidos !=''}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes apartamentos estão com checkins vencidos: <s:property value="checkinVencidos"/>' >
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Não existem checkins vencidos" ></img>
                    	</s:else>
                    </div>
                </div>


              </div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    
                    <s:if test='%{diariaAutomaticaJaEfetuada =="0" && checkinVencidos == null}'>
	                    <duques:botao label="Lançar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
                    </s:if>
              </div>
              
        </div>
</div>
</s:form>