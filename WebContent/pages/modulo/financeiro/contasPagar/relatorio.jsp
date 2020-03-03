<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
$('#linhaContasPagar').css('display','block');


function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarContasPagar!prepararPesquisa.action" namespace="/app/financeiro" />';
	submitForm( vForm );
}


var reportAddress = '';
function imprimir(){

	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
		if (idRel == "1"){
			 if ($('#dataInicial').val() == '' ){
					alerta("O campo 'Período' é obrigatório.");
					return false;	
				}
				reportAddress += '/index.jsp?REPORT=cpContabilReport';
				params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
				params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
				params += ';P_DATA@'+$('#dataInicial').val();
				reportAddress += '&PARAMS='+params;
				showPopupGrande(reportAddress);

		}else if (2 == idRel){
		 
			reportAddress += '/index.jsp?REPORT=cpChequesEmitidosReport';
			params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
			params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
			params += ';P_DATA@'+$('#dataInicial').val();
			reportAddress += '&PARAMS='+params;
			showPopupGrande(reportAddress);	

		}else if (3 == idRel){

		
	}else if (4 == idRel){
		
		reportAddress += '/index.jsp?REPORT=cpFluxoCaixaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';		
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
		
	}else if (5 == idRel){

		reportAddress += '/index.jsp?REPORT=cpClassContabilReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
		
	}else if (6 == idRel){
		reportAddress += '/index.jsp?REPORT=cpBancoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
		
	}else if (7 == idRel){

		reportAddress += '/index.jsp?REPORT=cpDataVencimentoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
		

	}else if (8 == idRel){

		reportAddress += '/index.jsp?REPORT=cpFluxoCaixaGrupoFornecedorReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
		

	}else if (9 == idRel){
	
	 	reportAddress += '/index.jsp?REPORT=cpCopiaChequeReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		params += ';P_BANCO@'+($('#banco').val()==''?'ALL':$('#banco').val());
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	}else if (10 == idRel){
	
	 	reportAddress += '/index.jsp?REPORT=cpClassContabilReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		params += ';P_BANCO@'+($('#banco').val()==''?'ALL':$('#banco').val());
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	
	}
	
}


	function carregarBanco(){
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarBanco';
		preencherCombo('banco', url);        
	}


	function verificaRelatorio(){
		var idRel = $("input[name='TIPO']:checked").val();

	}
	

	$(document).ready(
			function(){
				    $(".radioTipo").click(
				            function() { 
				            	$('#divDataFinal').css('display','none');
				            	$('#divLinhaBanco').css('display','none');


				            	if(this.value == '4'){

				            		$('#divDataFinal').css('display','block');
				            		
				            	}else if(this.value == '7'){
					            	
				            		$('#divDataFinal').css('display','block');
					            	
								}else if (this.value == '8') {
									
									$('#divDataFinal').css('display','block');
									
								}else if (this.value == '9') {
									
									carregarBanco();
					            	$('#divLinhaBanco').css('display','block');
				                	$('#divDataFinal').css('display','block');
										
								}
								
				       }
			    );
		}
)
    
</script>

<s:form action="pesquisarContasPagar!prepararPesquisa.action" namespace="/app/financeiro" theme="simple">
<div class="divFiltroPaiTop">Contas a pagar</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Tipos de relatório</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" />Contábil<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="2"/>Cheques emitidos<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="3" disabled="disabled"/>Imprimir cheques<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="4"/>Fluxo caixa<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="5"/>Classificação Contábil<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="6"/>Banco<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="7"/>Vencimento<br/>
                    </div>
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="8"/>Valores por grupo de fornecedor<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="9"/>Cópia de cheque/Internet<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="10"/>Pgto P/Class. Contábil<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="11" disabled="disabled"/>Ficha financeira<br/>
                    </div>
                </div>

                <div class="divLinhaCadastro" id="divPeriodo">
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Período:</p> 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.contasPagar"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" onchange="verificaRelatorio()" /> 
                   </div>       
                    <div class="divItemGrupo" id="divDataFinal" style="display:none" >
                          à 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.contasPagar"/>' type="text" name="dataFinal" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataFinal" size="8" maxlength="10" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro" id="divLinhaBanco" style="display:none;">
                    <div class="divItemGrupo" style="width:400px;" ><p style="width:80px;">Banco:</p> 
							<select name="banco" id="banco" style="width:250px;">
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