<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
$('#linhaMovimentoContabil').css('display','block');

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarMovimentoContabil!prepararPesquisa.action" namespace="/app/contabilidade" />';
	submitForm( vForm );
}
            
function gravar(){

	if ($('#data').val() == ''){
		alerta('O campo "Data da contabilidade" � obrigat�rio.');

		return false;
	}
	
    submitForm(document.forms[0]);
}

</script>


<s:form namespace="/app/contabilidade" action="encerrarMovimentoContabil!encerrar.action" theme="simple">

<div class="divFiltroPaiTop">Movimento Cont�bil</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:100px;">
                <div class="divGrupoTitulo">Aten��o</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:90%;" >
						<p style="width:100%;">- Voc� pode alterar a data da contabilidade a qualquer momento para qualquer per�odo;</p>                    
					</div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:90%;" >
						<p style="width:100%;">- Voc� pode lan�ar os movimentos anuais a qualquer momento, basta indicar no campo abaixo;</p> 
                    </div>
                </div>
              </div>


     		 <div class="divGrupo" style="height:100px;">
                <div class="divGrupoTitulo">Op��es</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:400px;" >
						<p style="width:250px;color:black;">Nova Data da contabilidade: </p>
						<s:textfield name="dataContabilidade" id="data" onkeypress="mascara(this,mesano)"  cssClass="dpFMT" maxlength="7" size="5" />
                    </div>
                </div>
				

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:400px;" >
						<p style="width:250px;color:black;">Lan�ar movimento anual: </p>
						<s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:60px"  
								  name="executarLancamentoAnual"
								  listKey="id"
								  listValue="value"/>

					</div>
                </div>

             </div>
              

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    
                    <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
              </div>
        </div>
</div>
</s:form>