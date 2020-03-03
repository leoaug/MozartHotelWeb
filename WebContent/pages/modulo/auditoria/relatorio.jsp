<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarAuditoria!prepararPesquisa.action" namespace="/app/auditoria" />';
	submitForm(vForm);
}


var reportAddress = '';
function imprimir(){

	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
	var formato=$("input[name='FORMATO']:checked").val();
	 if (1 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=saldosContasAnaliticoReport';
		reportAddress += '&FORMAT='+ formato;
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	 }else if (2 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=saldosContasSinteticoReport';
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
		reportAddress += '/index.jsp?REPORT=rdsReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	}else if (4 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=rdrReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (5 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=notaHospedagemReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (6 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=AptoTransferidoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (7 == idRel){
		reportAddress += '/index.jsp?REPORT=cartaCobrancaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';NUM_APARTAMENTO@'+$('#numApartamento').val();
		params += ';P_DATA@'+$('#dataInicial').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	}else if (8 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=potencialDiariaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	}else if (10 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		if ($('#tipoNota').val() == ''){
			alerta("O campo 'Tipo nota' é obrigatório.");
			return false;	
		}
		if ($('#nota').val() == ''){
			alerta("O campo 'Nota' é obrigatório.");
			return false;	
		}

		reportAddress += '/index.jsp?REPORT=';
		report='';		
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';ID_NOTA@'+$('#nota').val();

		if($('#tipoNota').val()  == 'H'){
			report = 'notaHospedagemReport';
			params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
			params += ';P_DATA@'+$('#dataInicial').val();
			params += ';P_DATA_FIM@'+$('#dataFinal').val();
		}else if($('#tipoNota').val()  == 'F'){
			report = 'RPSReport';
			params += ';DATA_NOTA@'+$('#dataInicial').val();

		}
		reportAddress += report + '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (11 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=recebimentosCartaoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (15 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=notasEmitidasReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (14 == idRel){
	
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		
		
		reportAddress += '/index.jsp?REPORT=comprovanteAjusteReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';IDS@'+($('#idAjuste').val()!=null?','+$('#idAjuste').val()+',':'');
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (16 == idRel){
		reportAddress += '/index.jsp?REPORT=fnrhVazioReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}
	
}


	function carregarNotas(tipoNota){

		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}

		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarNotas?tipoNota='+tipoNota+'&dataInicial='+$('#dataInicial').val()+'&dataFinal='+$('#dataFinal').val();
		preencherCombo('nota', url);        
		
	}

	function carregarApartamento(){
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarApartamento';
		preencherCombo('numApartamento', url);        
	}

	function carregarAjuste(){
		
		preencherComboBoxJS('idAjuste', 'Carregando..., |');
		loading();
		submitFormAjax('pesquisarAjuste?idCombo=idAjuste&dataInicial='+$('#dataInicial').val(),true);
	}
	
	function verificaRelatorio(){
		var idRel = $("input[name='TIPO']:checked").val();
		 if (14 == idRel){
			carregarAjuste();
		 
		 }
	
	}

	$(document).ready(
			function(){
				    $(".radioTipo").click(
				            function() { 
				            	$('#divLinhaNota').css('display','none');
				            	$('#divLinhaAjuste').css('display','none');
				            	$('#divDataFinal').css('display','block');	
				            	$('#divLinhaApto').css('display','none');
			                	$('#divLinhaFormatoReport').css('display','none');
				                if (this.value == '10'){
				                	carregarNotas('');	  
									$('#divLinhaNota').css('display','block');
				                }else if (this.value == '7'){
				                	carregarApartamento();
				                	$('#divLinhaApto').css('display','block');
				                		                	
					            }else if (this.value == '14'){
				                	
				                	$('#divLinhaAjuste').css('display','block');
				                	$('#divDataFinal').css('display','none');	
				                	carregarAjuste();                	
					            }else if (this.value == '1'){
				                	
				                	$('#divLinhaFormatoReport').css('display','block');
					            }
				            }
				    );
			        
			}
		)
    
</script>



<s:form action="pesquisarAuditoria!pesquisar.action" namespace="/app/auditoria" theme="simple">
<div class="divFiltroPaiTop">Relatório</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Tipos de relatório</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="2" checked="checked" />Saldos das contas sintéticos<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="1" />Saldos das contas análitico<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="3" />RDS<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="4" />Diário de receita<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="15" />Notas emitidas<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="6" />Apartamento transferidos<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="7" />Carta cobrança<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="12" disabled="disabled"/>Discrepância de telefonia<br/>
                    </div>
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="13" disabled="disabled"/>RDS Sintético<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="11" />Recebimentos de cartão<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="14" />Comprovante de ajustes<br/>
						<!-- input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="9" disabled="disabled"/>Reimpressão de nota fiscal<br/ -->
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="8" />Potencial de diárias<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="10" />Nota de hospedagem ou RPS <br>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="16" />Modelo FNRH<br/>
                    </div>
                </div>

                <div class="divLinhaCadastro" id="divPeriodo">
                
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Período:</p> 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" onchange="verificaRelatorio()" /> 
                          
                   </div>       
                    <div class="divItemGrupo" id="divDataFinal" >
                          à 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataFinal" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataFinal" size="8" maxlength="10" />
                    </div>
                
                </div>
                <div class="divLinhaCadastro" id="divLinhaFormatoReport" style="display:none;">
                
                    <div class="divItemGrupo" style="width:280px; " ><p style="width:80px;">Formato:</p> 
						<input class="radioFormato"  type="radio" name="FORMATO" id="FORMATO" value="PDF" checked="checked" />PDF 
						<input class="radioFormato"  type="radio" name="FORMATO" id="FORMATO" value="XLS" />EXCEL 
                   </div>       
                </div>
                
                <div class="divLinhaCadastro" id="divLinhaNota" style="display:none;">
                
                    <div class="divItemGrupo" style="width:200px;" ><p style="width:80px;">Tipo nota:</p> 
							<select name="tipoNota" id="tipoNota" onchange="carregarNotas(this.value)" style="width:100px;">
								<option value="">Selecione</option>
								<option value="F">RPS</option>
								<option value="H">Nota Hospedagem</option>
							</select>
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:50px;">Nota:</p> 
							<select name="nota" id="nota" style="width:150px;">
							</select>
                    </div>
                
                </div>
				<div class="divLinhaCadastro" id="divLinhaApto" style="display:none;">
                
                    <div class="divItemGrupo" style="width:200px;" ><p style="width:80px;">Apto:</p> 
							<select name="numApartamento" id="numApartamento" style="width:100px;">
							</select>
                    </div>
                </div>
                
                
                <div class="divLinhaCadastro" id="divLinhaAjuste" style="display:none; height:110px;">
                
                    <div class="divItemGrupo" style="width:600px; " > 
							<select name="idAjuste" id="idAjuste" style="width:500px;" multiple="multiple" size="8">
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