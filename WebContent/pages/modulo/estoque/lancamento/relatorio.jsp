<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
$('#linhaEstoque').css('display','block');
console.log($('#linhaEstoque'));
// TODO: (ID) Este relatorio foi copiado de outro modulo. Ajustar.

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarLancamentoEstoque!prepararPesquisa.action" namespace="/app/estoque" />';
	submitForm(vForm);
}


var reportAddress = '';
var report = '';

function imprimir(){
	var idItem = '';
	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>' + '/index.jsp?';

	var formato=$("input[name='FORMATO']:checked").val();
	var detalhe=$("input[name='DETALHE']:checked").val();

	if ($('#dataInicial').val() == '' ){
		alerta("O campo 'Período' é obrigatório.");
		return false;	
	}

	idItem = $('#idItem').val(); 	

	params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
	params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
	params += ';P_DATA@'+$('#dataInicial').val();

	if (1 == idRel){
		report = 'estContabilReport';
	} else if (2 == idRel){
		report = 'estFichaEstoqueReport';
		params += ';IDITEM@' + ((idItem == '') ? 'ALL' : idItem);
	} else if (3 == idRel){
		report = (detalhe == 'A')? 'estInventarioAtivoAnaliticoReport'
				: 'estInventarioAtivoSinteticoReport';
	} else if (4 == idRel){
		report = (detalhe == 'A')? 'estInventarioDespesaAnaliticoReport'
				: 'estInventarioDespesaSinteticoReport';
	}		
		
	reportAddress += 'REPORT=' + report;
	reportAddress += '&FORMAT='+ formato;
	reportAddress += '&PARAMS='+ params;

	showPopupGrande(reportAddress);

}



$(document).ready(
		function(){
			    $(".radioTipo").click(
			            function() { 
			            	$('#divItem').css('display','none');
			            	$('#divLinhaFormatoReport').css('display','none');
				            $('#divDetalhe').css('display','none');
			            	$("input[name='FORMATO'][value='PDF']").attr('checked', true);
			            	$("#item").val(""); 
			            	$("#idItem").val(""); 
			                if (this.value == '1'){

			                }
			                if (this.value == '2'){
				            	$('#divItem').css('display','block');
			                }
			                if (this.value == '3'){
				            	$('#divDetalhe').css('display','block');

			                }
			                if (this.value == '4'){
				            	$('#divDetalhe').css('display','block');

			                }
			               
			            }
			    );
		        
		}
	);
	
	function getItem(elemento) {
	
		url = 'app/ajax/ajax!obterItensEstoqueMovimentoEstoque?OBJ_NAME=' 
				+ elemento.id
				+ '&OBJ_VALUE=' 
				+ elemento.value 
				+ '&OBJ_HIDDEN=idItem';
		getDataLookup(elemento, url, 'Item', 'TABLE');
	}

	function selecionarItemEstoque(
			elemento, elementoOculto, 
			valorTextual, idEntidade,
			unidadeEstoque, idFiscalIncidencia, idCentroCusto, direto) {
		
		window.MozartNS.GoogleSuggest.selecionar(elemento, valorTextual, 
				elementoOculto, idEntidade);
	}

	window.onload = function() {

		addPlaceHolder('item');
	};

	function addPlaceHolder(classe) {
		document.getElementById(classe).setAttribute("placeholder",
				"ex.: digite o nome do item");
	}
</script>



<s:form action="pesquisarLancamentoEstoque!prepararPesquisa.action" namespace="/app/estoque" theme="simple">
<div class="divFiltroPaiTop">Estoque - Relatório</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Por Empresas</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" checked="checked" />Contábil<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="2" />Ficha de estoque (Kardex)<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="3" />Inventario por conta do estoque<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="4" />Inventário por conta de despesa<br/>
                    </div>
                    
                </div>

                <div class="divLinhaCadastro" id="divPeriodo">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Período:</p> 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.estoque"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" /> 
                    </div>
                </div>
                <div class="divLinhaCadastro" id="divItem" style="display:none;">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:80px;">Item:</p> 
                        <s:textfield cssClass="item" name="item" id="item" size="40"
						maxlength="50" onblur="getItem(this);" />
						<s:hidden name="idItem" id="idItem" />
                    </div>
                </div>
                <div class="divLinhaCadastro" id="divLinhaFormatoReport" style="display:none;">
                
                    <div class="divItemGrupo" style="width:280px; " ><p style="width:80px;">Formato:</p> 
						<input class="radioFormato"  type="radio" name="FORMATO" id="FORMATO" value="PDF" checked="checked" />PDF 
						<input class="radioFormato"  type="radio" name="FORMATO" id="FORMATO" value="XLS" />EXCEL 
                   </div>       
                </div>
                <div class="divLinhaCadastro" id="divDetalhe" style="display:none;">
                
                    <div class="divItemGrupo" style="width:280px; " ><p style="width:80px;">Detalhamento:</p> 
						<input class="radioFormato"  type="radio" name="DETALHE" id="DETALHE" value="A" checked="checked" />Analítico 
						<input class="radioFormato"  type="radio" name="DETALHE" id="DETALHE" value="S" />Sintético 
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