<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
$('#linhaTesouraria').css('display','block');


function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarTesouraria!prepararPesquisa.action" namespace="/app/financeiro" />';
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

		reportAddress += '/index.jsp?REPORT=boletimCaixaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDHS@'+obterHotelSelecionado();
		params += ';P_DATA@'+$('#dataInicial').val();

		
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	 }else if (2 == idRel){

		reportAddress += '/index.jsp?REPORT=conciliacaoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDHS@'+obterHotelSelecionado();
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_CC@'+$('#banco').val();

		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (3 == idRel){
		reportAddress += '/index.jsp?REPORT=fluxoCaixaAnaliticoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		params += ';P_CC@'+($('#banco').val()==''?'ALL':$('#banco').val());

		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
		
	}else if (4 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=fluxoCaixaTipoForReport';
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
		reportAddress += '/index.jsp?REPORT=fluxoCaixaSinteticoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		params += ';P_CC@'+($('#banco').val()==''?'ALL':$('#banco').val());

		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (6 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=razaoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDHS@'+obterHotelSelecionado();
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		params += ';P_CC@'+($('#banco').val()==''?'ALL':$('#banco').val());
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (7 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}

		reportAddress += '/index.jsp?REPORT=balanceteFinanceiroAnaliticoPorDataReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		params += ';P_CT@'+($('#conta').val()==''?'ALL':$('#conta').val());
		params += ';P_CC@'+($('#banco').val()==''?'ALL':$('#banco').val());
		params += ';P_TIPO@'+$("input[name='tipoBalancete']:checked").val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	}
	
}

	function carregarPlanoContas(){
		
	url = '${sessionScope.URL_BASE}app/ajax/ajax!obterPlanoContas';
	preencherCombo('conta', url);        
	}


	function carregarBanco(){
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarContaCorrente';
		preencherCombo('banco', url);        
	}


	function cerregarPlanoContasBanco(){
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarContaCorrente';
		preencherComboCallback('banco', url, carregarPlanoContas);        
	
	
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
				            	$('#divLinhaPlanoConta').css('display','none');
				            	$('#divLinhaTipo').css('display','none');
				            	if (this.value == '2'){
				                	carregarBanco();
				                	$('#divLinhaBanco').css('display','block');
				                		                	
					            }else if (this.value == '3'){
					                	carregarBanco();
					                	$('#divLinhaBanco').css('display','block');
					                	$('#divDataFinal').css('display','block');


					            }else if (this.value == '4'){
				                	$('#divDataFinal').css('display','block');

						      }else if (this.value == '5'){
				                	carregarBanco();
				                	$('#divLinhaBanco').css('display','block');
				                	$('#divDataFinal').css('display','block');


				            }else if (this.value == '6'){
			                	carregarBanco();
			                	$('#divLinhaBanco').css('display','block');
			                	$('#divDataFinal').css('display','block');


			            }else if (this.value == '7'){
			            	
		                	
		                	$('#divLinhaBanco').css('display','block');
		                	$('#divDataFinal').css('display','block');
		                	$('#divLinhaPlanoConta').css('display','block');
		                	$('#divLinhaTipo').css('display','block');
							cerregarPlanoContasBanco();
		            }else if (this.value == '8'){
		            	
	                	
	                	$('#divLinhaBanco').css('display','block');
	                	$('#divDataFinal').css('display','block');
	                	$('#divLinhaPlanoConta').css('display','block');
	                	cerregarPlanoContasBanco();
	            }                          
		                           
			    }
			);
		}
	)
			
	
    
</script>



<s:form action="pesquisarContasPagar!prepararPesquisa.action" namespace="/app/financeiro" theme="simple">
<div class="divFiltroPaiTop">Relatório</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
            <s:if test="#session.USER_ADMIN eq 'TRUE'">
                <div class="divHoteis" id="divHoteis"   >
					<div class="divHoteisMenu" id="divHoteisMenu"> 
					 <img class="divHoteisMenuFiltro" title="Mostrar hotéis" src="imagens/menuHotelPrata.png" />
					</div>
					<div class="divHoteisCorpo" id="divHoteisCorpo">
				<s:iterator value="#session.USER_SESSION.usuarioEJB.redeHotelEJB.hoteis"
				var="hotel" status="idx">
				<s:if test="#session.HOTEL_SESSION.idHotel eq idHotel">
					<li style="color: blue;">
					
					<p style="color: blue;"><input id="idHotel" style="border: 0px;"
						name="idHotel" type="checkbox" class="chkHotel"
						value="<s:property value="idHotel" />" checked="checked" />
						<b><s:property value="#session.USER_SESSION.usuarioEJB.nick.equals(\"MANUTENCAO\")?redeHotelEJB.sigla+\" - \":\"\"" /></b>
						<s:property value="nomeFantasia" />
					</p>

					</li>
				</s:if> <s:else>
							
					<li>
					
					<p style="color: black;"><input id="idHotel" style="border: 0px;"
						name="idHotel" type="checkbox" class="chkHotel"
						value="<s:property value="idHotel" />" />
						<b><s:property value="#session.USER_SESSION.usuarioEJB.nick.equals(\"MANUTENCAO\")?redeHotelEJB.sigla+\" - \":\"\"" /></b>
						<s:property value="nomeFantasia" />
					</p>

					</li>
				</s:else> 

			</s:iterator>
            </div>
			</div>
		</s:if>
		
		
               <div class="divGrupo" style="<s:property value="#session.USER_ADMIN eq 'TRUE'?\"margin-left:25px;width:97%;\":\"\""/>height:300px;">
                <div class="divGrupoTitulo">Tipos de relatório</div>
                
                <div class="divLinhaCadastro" style="height:172px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" checked="checked"/>Boletim de Caixa<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="2" />Conciliação<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="3" />Fluxo Caixa Analítico<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="4" />Fluxo Caixa Fornecedor<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="5" />Fluxo Caixa Sintético<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="6" />Razão<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="7" />Balancete Financeiro Analitico<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="8" disabled="disabled"/>Balancete Financeiro Sintético<br/>
                    </div>
                </div>

                <div class="divLinhaCadastro" id="divPeriodo">
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Período:</p> 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.tesouraria"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" /> 
                   </div>       
                    <div class="divItemGrupo" id="divDataFinal" style="display:none" >
                          à 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.tesouraria"/>' type="text" name="dataFinal" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataFinal" size="8" maxlength="10" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro" id="divLinhaBanco" style="display:none;">
                    <div class="divItemGrupo" style="width:400px;" ><p style="width:80px;">C. corrente:</p> 
							<select name="banco" id="banco" style="width:250px;">
							</select>
                    </div>
                </div>
                
                 <div class="divLinhaCadastro" id="divLinhaPlanoConta" style="display:none;">
                    <div class="divItemGrupo" style="width:400px;" ><p style="width:80px;">Conta:</p> 
							<select name="conta" id="conta" style="width:250px;">
							</select>
                    </div>
                </div>
                
                 <div class="divLinhaCadastro" id="divLinhaTipo" style="display:none;">
                    <div class="divItemGrupo" style="width:400px;" ><p style="width:80px;">Tipo:</p> 
							<input type="radio" name="tipoBalancete" id="tipoBalancete" value="1" checked="checked"/>Por data &nbsp;&nbsp;&nbsp; 
							<input type="radio" name="tipoBalancete" id="tipoBalancete" value="2" />Por Conta<br/>
							
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