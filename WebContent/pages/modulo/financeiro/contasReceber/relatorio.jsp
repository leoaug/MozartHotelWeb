<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
$('#linhaContasReceber').css('display','block');

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarContasReceber!prepararPesquisa.action" namespace="/app/financeiro" />';
	submitForm( vForm );
}

function obterHotelSelecionado(){
	var qtde = $("input:checkbox[class='chkHotel'][checked='true']").length;
	var valor = '';
	for (x=0;x<qtde;x++){
			objChk = $("input:checkbox[class='chkHotel'][checked='true']").get(x);
			valor += objChk.value+',';
	}
	return valor==''?',<s:property value="#session.HOTEL_SESSION.idHotel"/>,':','+valor;
}


var reportAddress = '';
function imprimir(){

	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
	 if (1 == idRel){

		reportAddress += '/index.jsp?REPORT=contabilReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	 }else if (2 == idRel){

		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=fluxoCaixaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
		
	}else if (3 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}


		return false;

	}else if (4 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=tituloEmAbertoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (5 == idRel){


		
	}else if (6 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=bancoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (7 == idRel){


	}else if (8 == idRel){


	}else if (9 == idRel){


	}
	
}


	function carregarDuplicatas(){

		if ($('#dataInicial').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}

		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarDuplicatas?dataInicial='+$('#dataInicial').val();
		preencherCombo('duplicata', url);        
	}

	function carregarBanco(){
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarBanco';
		preencherCombo('banco', url);        
	}

	function carregarDuplicataPorBanco(idBanco){
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarDuplicatas?idBanco='+idBanco;
		preencherCombo('dupBanco', url);        
	}

	function verificaRelatorio(){
		var idRel = $("input[name='TIPO']:checked").val();
		 if (1 == idRel || 2 == idRel){
			 carregarDuplicatas();
		 
		 }	
	}

	$(document).ready(
			function(){
				    $(".radioTipo").click(
				            function() { 
				            	$('#divDataFinal').css('display','none');
				            	$('#divLinhaDup').css('display','none');
				            	$('#divLinhaBanco').css('display','none');	
				            	$('#divLinhaDupBanco').css('display','none');

				                if (this.value == '2'){
				                	$('#divDataFinal').css('display','block');
				                }else if (this.value == '3' || this.value == '4' ){
				                	carregarBanco();
				                	$('#divLinhaBanco').css('display','block');
				                	if (this.value == '3')
				                		$('#divLinhaDupBanco').css('display','block');
				                		                	
					            }else if (this.value == '7'||this.value == '6'){
					            	$('#divDataFinal').css('display','block');
					            }
				            }
				    );
			        
			}
		)
    
</script>



<s:form action="pesquisarContasReceber!prepararPesquisa.action" namespace="/app/financeiro" theme="simple">
<div class="divFiltroPaiTop">Contas Receber</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Tipos de relatório</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1"/>Contábil<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="2"/>Fluxo de caixa<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="3"  disabled="disabled"/>Carta cliente<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="4" />Títulos em aberto<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="5" disabled="disabled"/>Títulos descontados<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="6" />Banco<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="7" disabled="disabled"/>Vencimento<br/>
                    </div>
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="8" disabled="disabled"/>Duplicatas descontadas por lote<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="9" disabled="disabled"/>Reimpressão de boleto<br/>
						
                    </div>
                </div>

                <div class="divLinhaCadastro" id="divPeriodo">
                
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Período:</p> 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.faturamentoContasReceber"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" onchange="verificaRelatorio()" /> 
                   </div>       
                    <div class="divItemGrupo" id="divDataFinal" style="display:none" >
                          
                          à 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.faturamentoContasReceber"/>' type="text" name="dataFinal" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataFinal" size="8" maxlength="10" />
                    
                    </div>
                
                </div>
                
                <div class="divLinhaCadastro" id="divLinhaDup" style="display:none;">
                
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Duplicata:</p> 
							<select name="duplicata" id="duplicata" style="width:200px;">
							</select>
                    </div>
                
                </div>
				<div class="divLinhaCadastro" id="divLinhaBanco" style="display:none;">
                
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Banco:</p> 
							<select name="banco" id="banco" style="width:100px;" onchange="carregarDuplicataPorBanco(this.value)">
							</select>
                    </div>
                </div>

				<div class="divLinhaCadastro" id="divLinhaDupBanco" style="display:none;height:110px;">
                
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Duplicatas:</p> 
							<select name="dupBanco" id="dupBanco" style="width:500px;" multiple="multiple" size="8" >
							</select>
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