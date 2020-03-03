<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
$('#linhaFaturamento').css('display','block');

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarFaturamento!prepararPesquisa.action" namespace="/app/financeiro" />';
	submitForm( vForm );
}

function exibirBoletoRemessa(){
	showModal('#divRemessaRetorno');
}
function gerarBoletoRemessa(metodo){
	url = '<%=session.getAttribute("URL_BASE")%>gerarBoleto?MT=';
	
	url += metodo;
	url += '&contaCorrente='+$('#banco').val();
	url += '&data='+$('#dataInicial').val();
	url += '&ids='+$('#dupBanco').val();
	
	showPopupGrande(url);
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

		reportAddress += '/index.jsp?REPORT=duplicataReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_ID@'+($('#duplicata').val()=='-1'?'ALL':$('#duplicata').val());
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	 }else if (2 == idRel){

		reportAddress += '/index.jsp?REPORT=duplicataInglesReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_ID@'+($('#duplicata').val()=='-1'?'ALL':$('#duplicata').val());

		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (3 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}

		exibirBoletoRemessa();

		
	}else if (4 == idRel){
		if ($('#banco').val() == ''){
			alerta("O campo 'Conta corrente' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=borderauxBancariaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDHS@'+obterHotelSelecionado();
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += '&CC='+$('#banco').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (5 == idRel){
		if ($('#dataInicial').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=faturamentoGroupReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDHS@'+obterHotelSelecionado();
		params += ';P_DATA@'+$('#dataInicial').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (6 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=etiquetaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (7 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}

		reportAddress += '/index.jsp?REPORT=faturamentoContabilGroupReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDHS@'+obterHotelSelecionado();
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	}else if (8 == idRel){


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
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarContaCorrente?carteira=N&boleto=S';
		preencherCombo('banco', url);        
	}

	function carregarDuplicataPorCC(idCC){
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarDuplicatas?idCC='+idCC+'&dataInicial='+$('#dataInicial').val();
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

				            	

				                if (this.value == '1' || this.value == '2'){
				                	carregarDuplicatas();	  
									$('#divLinhaDup').css('display','block');
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



<s:form action="pesquisarFaturamento!prepararPesquisa.action"
	namespace="/app/financeiro" theme="simple">
	<div class="divFiltroPaiTop">Faturamento</div>
	<div class="divFiltroPai">
		<div class="divCadastro" style="overflow: auto;">
			<s:if test="#session.USER_ADMIN eq 'TRUE'">
				<div class="divHoteis" id="divHoteis">
					<div class="divHoteisMenu" id="divHoteisMenu">
						<img class="divHoteisMenuFiltro" title="Mostrar hotéis"
							src="imagens/menuHotelPrata.png" />
					</div>
					<div class="divHoteisCorpo" id="divHoteisCorpo">
						<s:iterator
							value="#session.USER_SESSION.usuarioEJB.redeHotelEJB.hoteis"
							var="hotel" status="idx">
							<s:if test="#session.HOTEL_SESSION.idHotel eq idHotel">
								<li style="color: blue;">

									<p style="color: blue;">
										<input id="idHotel" style="border: 0px;" name="idHotel"
											type="checkbox" class="chkHotel"
											value="<s:property value="idHotel" />" checked="checked" />
										<b><s:property
												value="#session.USER_SESSION.usuarioEJB.nick.equals(\"MANUTENCAO\")?redeHotelEJB.sigla+\" - \":\"\"" /></b>
										<s:property value="nomeFantasia" />
									</p>

								</li>
							</s:if>
							<s:else>

								<li>

									<p style="color: black;">
										<input id="idHotel" style="border: 0px;" name="idHotel"
											type="checkbox" class="chkHotel"
											value="<s:property value="idHotel" />" /> <b><s:property
												value="#session.USER_SESSION.usuarioEJB.nick.equals(\"MANUTENCAO\")?redeHotelEJB.sigla+\" - \":\"\"" /></b>
										<s:property value="nomeFantasia" />
									</p>

								</li>
							</s:else>

						</s:iterator>
					</div>
				</div>
			</s:if>



			<div class="divGrupo"
				style="<s:property value="#session.USER_ADMIN eq 'TRUE'?\"margin-left:25px;width:97%;\":\"\""/>height:465px;">
				<div class="divGrupoTitulo">Tipos de relatório</div>

				<div class="divLinhaCadastro"
					style="height: 180px; border: 1px solid black;">

					<div class="divItemGrupo" style="width: 250px; color: blue;">
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO"
							value="1" />Duplicata<br /> <input class="radioTipo"
							type="radio" name="TIPO" id="TIPO" value="2" />Duplicata inglês<br />
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO"
							value="3" />Boleto / Remessa<br /> <input class="radioTipo"
							type="radio" name="TIPO" id="TIPO" value="4" />Borderaux
						Bancária<br /> <input class="radioTipo" type="radio" name="TIPO"
							id="TIPO" value="5" />Faturamento<br /> <input class="radioTipo"
							type="radio" name="TIPO" id="TIPO" value="6" />Etiqueta<br /> <input
							class="radioTipo" type="radio" name="TIPO" id="TIPO" value="7" />Contábil<br />
					</div>
					<div class="divItemGrupo" style="width: 250px; color: blue;">
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO"
							value="8" disabled="disabled" />Boleto pré impresso<br />

					</div>
				</div>

				<div class="divLinhaCadastro" id="divPeriodo">

					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 100px;">Período:</p>
						<input class="dp"
							value='<s:property value="#session.CONTROLA_DATA_SESSION.faturamentoContasReceber"/>'
							type="text" name="dataInicial" onblur="dataValida(this);"
							onkeypress="mascara(this,data);" id="dataInicial" size="8"
							maxlength="10" onchange="verificaRelatorio()" />
					</div>
					<div class="divItemGrupo" id="divDataFinal" style="display: none">

						à <input class="dp"
							value='<s:property value="#session.CONTROLA_DATA_SESSION.faturamentoContasReceber"/>'
							type="text" name="dataFinal" onblur="dataValida(this);"
							onkeypress="mascara(this,data);" id="dataFinal" size="8"
							maxlength="10" />

					</div>

				</div>

				<div class="divLinhaCadastro" id="divLinhaDup"
					style="display: none;">

					<div class="divItemGrupo" style="width: 400px;">
						<p style="width: 100px;">Duplicata:</p>
						<select name="duplicata" id="duplicata" style="width: 200px;">
						</select>
					</div>

				</div>
				<div class="divLinhaCadastro" id="divLinhaBanco"
					style="display: none;">

					<div class="divItemGrupo" style="width: 400px;">
						<p style="width: 100px;">Conta corrente:</p>
						<select name="banco" id="banco" style="width: 250px;"
							onchange="carregarDuplicataPorCC(this.value)">
						</select>
					</div>
				</div>

				<div class="divLinhaCadastro" id="divLinhaDupBanco"
					style="display: none; height: 110px;">

					<div class="divItemGrupo" style="width: 700px;">
						<p style="width: 100px;">Duplicatas:</p>
						<select name="dupBanco" id="dupBanco" style="width: 500px;"
							multiple="multiple" size="8">
						</select>
					</div>
				</div>


			</div>


			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao label="Imprimir" imagem="imagens/iconic/png/print-3x.png"
					onClick="imprimir()" />
			</div>





		</div>
		<div id="divRemessaRetorno" class="divRemessaRetorno"
			style="display: none; background-color: white; border: 1px solid rgb(0, 82, 255); position: absolute; width: 300px; height: 50px;">
			<div class="divCadastro">
				<div class="divCadastroBotoes">
				<img align="right" height="24px;" width="24px"
					src="imagens/iconic/png/xRed-3x.png" title="Cancelar" onclick="killModal();" />
				<duques:botao label="Remessa" imagem="imagens/iconic/png/print-3x.png"
					onClick="gerarBoletoRemessa('gerarArquivoRemessa')" />
				<duques:botao label="Boleto" imagem="imagens/iconic/png/print-3x.png"
					onClick="gerarBoletoRemessa('gerarBoletoFaturamento')" />
			</div>
			</div>
		</div>
	</div>

</s:form>