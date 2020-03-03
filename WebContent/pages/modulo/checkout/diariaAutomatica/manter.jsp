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

<div class="divFiltroPaiTop">Lan�amento </div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:100px;">
                <div class="divGrupoTitulo">Aten��o</div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Esta rotina s� poder� ser executada uma �nica vez por dia;</p> 
                    </div>
                </div>
              </div>

              <div class="divGrupo" style="height:200px;">
                <div class="divGrupoTitulo">Valida��es</div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Lan�amento das di�rias: </p>
                    	<s:if test='%{diariaAutomaticaJaEfetuada =="0"}'>
                    		<img src="imagens/msgSucesso.png" title="As di�rias autom�ticas ainda n�o foram lan�adas hoje." ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/iconic/png/xRed-3x.png" title='As di�rias autom�ticas j� foram lan�adas hoje.' ></img>
                    	</s:else>
                    </div>
                </div>

                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Checkins vencidos: </p>
                    	<s:if test="%{checkinVencidos !=null && checkinVencidos !=''}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes apartamentos est�o com checkins vencidos: <s:property value="checkinVencidos"/>' >
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="N�o existem checkins vencidos" ></img>
                    	</s:else>
                    </div>
                </div>


              </div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    
                    <s:if test='%{diariaAutomaticaJaEfetuada =="0" && checkinVencidos == null}'>
	                    <duques:botao label="Lan�ar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
                    </s:if>
              </div>
              
        </div>
</div>
</s:form>