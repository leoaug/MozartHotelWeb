<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
$('#linhaEstoque').css('display', 'block');

window.onload = function() {
	addPlaceHolder('planoContas');
};

function addPlaceHolder(classe) {
	document.getElementById(classe).setAttribute("placeholder",
			"Ex.:Digitar o nome ou número ou conta reduzida");
}

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarImobilizadoDepreciacao!prepararPesquisa.action" namespace="/app/contabilidade" />';
	submitForm(vForm);
}

function getPlanoContas(elemento) {
	url = 'app/ajax/ajax!obterPlanoContasDepreciacao?OBJ_NAME=' + elemento.id 
			+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idPlanoContas';
	getDataLookup(elemento, url, 'PlanoContas', 'TABLE');
}

var reportAddress = '';
function imprimir(){

	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
	var formato=$("input[name='FORMATO']:checked").val();
	if (1 == idRel){
		if ($('#controleAtivo').val() == ''){
			alerta("O campo ' No. Do Controle do Ativo' é obrigatório.");
			return false;	
		}
				
		reportAddress += '/index.jsp?REPORT=controleAtivoFixoReport';
		reportAddress += '&FORMAT='+ formato;
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		if ($('#controleAtivo').val() != ''){
			params += ';CAF@'+$('#controleAtivo').val();
		}
		
		if ($('#idPlanoContas').val() != ''){
			params += ';IDPC@'+$('#idPlanoContas').val();
		}

		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}
}


$(document).ready(
		function(){
			    	        
		}
	)
	
</script>



<s:form action="pesquisarRelatorioGeral!prepararPesquisa.action" namespace="/app/custo" theme="simple">
<s:hidden id="origemCrs" name="origemCrs" />
<div class="divFiltroPaiTop">Imobilizado - Depreciação</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:340px;">
                <div class="divGrupoTitulo">Tipos de relatório</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" checked="checked" />Controle de Ativo Fixo<br/>
                    </div>
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						
                    </div>
                </div>

				<div class="divLinhaCadastro" id="divDepartamento">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Conta Contábil:</p> 
                    	<s:textfield
							name="representacaoPlanoContas"
							id="planoContas" 
							onblur="getPlanoContas(this)" 
							size="50" 
							cssStyle="width: 350px;"
							maxlength="50" />
						<s:hidden name="idPlanoContas" id="idPlanoContas" />
                   </div>			
                </div>
                
                <div class="divLinhaCadastro" id="divDepartamento">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">No. Controle do Ativo:</p> 
                          <s:select cssStyle="width:100px;" 
								  list="listControleAtivo"
								  headerKey=""
								  headerValue="Selecione"
								  name="controleAtivo"
								  id="controleAtivo" />
                   </div>			
                </div>
                <div class="divLinhaCadastro" id="divLinhaFormatoReport">
                
                    <div class="divItemGrupo" style="width:280px; " ><p style="width:80px;">Formato:</p> 
						<input class="radioFormato"  type="radio" name="FORMATO" id="FORMATO" value="PDF" checked="checked" />PDF 
						<input class="radioFormato"  type="radio" name="FORMATO" id="FORMATO" value="XLS" />EXCEL 
                   </div>       
                </div>
                
              </div>


             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Imprimir" imagem="imagens/iconic/png/print-3x.png" onClick="imprimir()" />
              </div>
              
        </div>
</div>

</s:form>