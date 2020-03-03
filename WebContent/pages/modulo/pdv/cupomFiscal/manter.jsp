<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
	submitForm(vForm);
}


var reportAddress = '';
function imprimir(){
	
	var idTipo = $("input[name='TIPO']:checked").val();
	
	if (idTipo == "1"){
		ReducaoZ('','');
	}

	
}


</script>



<form>
<s:hidden id="origemCrs" name="origemCrs" />
<div class="divFiltroPaiTop">Configuração - CF</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:280px;">
                <div class="divGrupoTitulo">Comandos</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" checked="checked" />Redução Z<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="2" />Leitura X<br/>
                    </div>
                    
                </div>

              </div>


             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Executar" imagem="imagens/iconic/png/print-3x.png" onClick="imprimir()" />
              </div>
              
        </div>
</div>

</form>