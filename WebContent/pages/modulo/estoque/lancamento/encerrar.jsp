<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

$('#linhaEstoque').css('display','block');

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="main!preparar.action" namespace="/app/main" />';
	submitForm( vForm );
}
            
function gravar(){
    submitForm(document.forms[0]);
}

</script>


<s:form namespace="/app/estoque" action="encerrarEstoque!encerrar.action" theme="simple">

<div class="divFiltroPaiTop">Encerramento</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:140px;">
                <div class="divGrupoTitulo">Aten��o</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Esta rotina s� poder� ser executada uma �nica vez por m�s;</p> 
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Verifique se todos os movimentos est�o corretos;</p> 
                    </div>
                </div>
               
              </div>
             

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Encerrar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
              </div>
        </div>
</div>
</s:form>