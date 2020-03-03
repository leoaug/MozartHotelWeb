<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
$('#linhaMovimentoContabil').css('display','block');

function fecharPopupHotel(){

	killModal();
}

window.onload = function() {
	addPlaceHolder('contaContabilInicio');
	addPlaceHolder('contaContabilFim');
};

function addPlaceHolder(classe) {
	document.getElementById(classe).setAttribute("placeholder",
			"Ex.:Digitar o nome ou número ou conta");
}


function getPlanoContasInicial(elemento) {
	url = 'app/ajax/ajax!obterPlanoContasRelRazao?OBJ_NAME=' + elemento.id 
			+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=contaContabilInicial';
	getDataLookup(elemento, url, 'ContaContabilInicio', 'TABLE');
}

function getPlanoContasFinal(elemento) {
	url = 'app/ajax/ajax!obterPlanoContasRelRazao?OBJ_NAME=' + elemento.id 
			+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=contaContabilFinal';
	getDataLookup(elemento, url, 'contaContabilFim', 'TABLE');
}

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarMovimentoContabil!prepararPesquisa.action" namespace="/app/contabilidade" />';
	submitForm( vForm );
}


var reportAddress = '';

function imprimirBalanceteRede(){

	
	reportAddress += '/index.jsp?REPORT=balanceteRedeContabilidadeReport';
	params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
	params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
	params += ';P_DATA@'+$('#dataInicial').val();
	params += ';P_DATA_FIM@'+$('#dataFinal').val();
	reportAddress += '&PARAMS='+params;
	showPopupGrande(reportAddress);

	
}


function imprimirTotLote(){

	reportAddress += '/index.jsp?REPORT=totalizacaoLoteReport';
	params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
	params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
	params += ';P_DATA@'+$('#dataInicial').val();
	params += ';P_DATA_FIM@'+$('#dataFinal').val();
	reportAddress += '&PARAMS='+params;
	showPopupGrande(reportAddress);



	
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

function imprimir(){

	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
		if (idRel == "1"){
			 if ($('#dataInicial').val() == ''){
					alerta("O campo 'Período' é obrigatório.");
					return false;	
				}
				reportAddress += '/index.jsp?REPORT=balanceteRedeContabilidadeReport';
				params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
				params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
				params += ';P_DATA@'+$('#dataInicial').val();
				params += ';P_TIPO@'+$('#tipoRelatorio').val();
				params += ';P_CNPJ@'+$('#cnpj').val();
				reportAddress += '&PARAMS='+params;
				showPopupGrande(reportAddress);

		}else if (2 == idRel){

		 if ($('#dataInicial').val() == '' ){
				alerta("O campo 'Período' é obrigatório.");
				return false;	
			}

		 if ($('#contaContabilInicial').val() == '' || $('#contaContabilFinal').val() == ''  ){
				alerta("O campo 'Contas' é obrigatório.");
				return false;	
			}
		 
		 
		reportAddress += '/index.jsp?REPORT=razaoContabilidadeReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';IDHS@'+obterHotelSelecionado();
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		params += ';P_CNPJ@'+$('#cnpj').val();
		params += ';P_CCUSTO@'+$('#idCentroCusto').val();
		// TODO: (ID) Verificar parametro conta_corrente no relatório, pode ser necessário alterar (alterações ID_CONTA_CORRENTE)
		params += ';P_CONTA_CORRENTE@'+$('#contaCorrente').val();
		params += ';P_CONTA_INICIAL@'+$('#contaContabilInicial').val();
		params += ';P_CONTA_FINAL@'+$('#contaContabilFinal').val();
		params += ';PAGINA_INICIAL@'+$('#paginaInicial').val();
		
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (3 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=diarioReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params +=  ';IDHS@'+obterHotelSelecionado();
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		params += ';P_CNPJ@'+$('#cnpj').val();
		params += ';P_CCUSTO@'+$('#idCentroCusto').val();
		params += ';PAGINA_INICIAL@'+$('#paginaInicial').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
		return false;

	}else if (4 == idRel){
		
		reportAddress += '/index.jsp?REPORT=balancoPatrimonialRedeReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';		
		params += ';IDHS@'+obterHotelSelecionado(); 
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_CNPJ@'+$('#cnpj').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (5 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}

		reportAddress += '/index.jsp?REPORT=totalizacaoLoteReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';	
		params += ';P_CNPJ@'+$('#cnpj').val();	
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (6 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=ctBalancoPatrimonialAnualMesReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params +=  ';IDHS@'+obterHotelSelecionado();
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_CNPJ@'+$('#cnpj').val();
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}
	
}


	function verificaRelatorio(){
		var idRel = $("input[name='TIPO']:checked").val();

	}

	$(document).ready(
			function(){
				    $(".radioTipo").click(
				            function() { 
				            	$('#divDataFinal').css('display','block');
						$('#divCnpj').css('display','none');
				            	$('#divTipo').css('display','none');
				            	$('#divContaCorrente').css('display','none');
				            	$('#divCentroCusto').css('display','none');
				            	$('#divContaContabil').css('display','none');
				            	$('#divPagina').css('display','none');
				            	

				            	if(this.value == '1'){

				            		$('#divTipo').css('display','block');
				            		$('#divDataFinal').css('display','none');
				            		
				            	}else if(this.value == '2'){
				            		$('#divContaCorrente').css('display','block');
					            	$('#divCentroCusto').css('display','block');
					            	$('#divContaContabil').css('display','block');
					            	$('#divPagina').css('display','block');
								}else if (this.value == '3') {
									$('#divCentroCusto').css('display','block');
									$('#divPagina').css('display','block');
								}else if (this.value == '4') {
										$('#divDataFinal').css('display','none');
								}else if (this.value == '5') {
										$('#divDataFinal').css('display','block');
								}
								if(this.value<6){
									$('#divCnpj').css('display','block');
								
								}
								
								
				       }
			    );
		}
)
    
</script>

<s:form action="pesquisarContasPagar!prepararPesquisa.action" namespace="/app/financeiro" theme="simple">
<div class="divFiltroPaiTop">Movimento Contábil</div>
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
        
        
              <div class="divGrupo" style="<s:property value="#session.USER_ADMIN eq 'TRUE'?\"margin-left:25px;width:97%;\":\"\""/>height:200px;">
                <div class="divGrupoTitulo">Por Empresas</div>
                
                <div class="divLinhaCadastro" style="height:150px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="1" checked="checked"/>Balancete<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="2"/>Razão<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="3"/>Diário<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="4"/>Balanço Patrimonial<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="6"/>Balanço Patrimonial Anual por mês<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="5"/>Totalização de lote<br/>
						
                    </div>
                </div>

              </div>

			 <div class="divGrupo" style="height:200px;">
					<div class="divGrupoTitulo">Opções</div>
				
				<div class="divLinhaCadastro" id="divPeriodo">
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Período:</p> 
                          <input class="dp" value='<s:property value="@com.mozart.model.util.MozartUtil@primeiroDiaMes(#session.CONTROLA_DATA_SESSION.contabilidade)"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" onchange="verificaRelatorio()" /> 
                   </div>       
                    <div class="divItemGrupo" id="divDataFinal" style="display:none" >
                          à 
                          <input class="dp" value='<s:property value="@com.mozart.model.util.MozartUtil@ultimoDiaMes(#session.CONTROLA_DATA_SESSION.contabilidade)"/>' type="text" name="dataFinal" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataFinal" size="8" maxlength="10" />
                    </div>
                </div>
                
                 <div class="divLinhaCadastro" id="divTipo" >
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:80px;">Tipo:</p> 
                          <select style="width:150px" name="tipoRelatorio" id="tipoRelatorio">
                          <option value="A">Analítico</option>
                          <option value="S">Sintético</option>
                          </select> 
                   </div>       
                </div>
                
                <div class="divLinhaCadastro" id="divCentroCusto" style="display:none">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Centro Custo:</p> 
                          <s:select cssStyle="width:200px" id="idCentroCusto" name="centroCusto" list="centroCustoList" headerKey="ALL" headerValue="Todos" listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"/>
                   </div>       
                </div>
                
                <div class="divLinhaCadastro" id="divContaCorrente" style="display:none">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">C. Corrente:</p> 
                          <s:select cssStyle="width:200px" id="contaCorrente" name="contaCorrente" list="contaCorrenteList" headerKey="" headerValue="Selecione" listKey="contaCorrente"/>
                   </div>       
                </div>
                
                <div class="divLinhaCadastro" id="divContaContabil" style="display:none">
                    <div class="divItemGrupo" style="width:740px;" ><p style="width:80px;">Contas:</p> 
	                    	<s:textfield
								name="contaContabilInicio"
								id="contaContabilInicio" 
								onblur="getPlanoContasInicial(this)" 
								size="30" 
								cssStyle="width: 300px;"
								maxlength="30" />
							<s:hidden name="contaContabilInicial" id="contaContabilInicial" />
                          até
                          	<s:textfield
								name="contaContabilFim"
								id="contaContabilFim" 
								onblur="getPlanoContasFinal(this)" 
								size="30" 
								cssStyle="width: 300px;"
								maxlength="30" />
							<s:hidden name="contaContabilFinal" id="contaContabilFinal" />
                   </div>       
                </div>
                
                <div class="divLinhaCadastro" id="divCnpj" style='display:<s:property value="#session.USER_ADMIN==\"TRUE\"?\"block\":\"none\" "/>'>
                    <div class="divItemGrupo" style="width:500px;"  ><p style="width:80px;">Por CNPJ:</p>
                    	<select name="cnpj" id="cnpj" style="width:200px;">
                    	<option value="ALL">Todos</option>
                    	<s:iterator value="#session.USER_SESSION.usuarioEJB.redeHotelEJB.hoteis" var="obj" status="row" >
                    	  <option value="<s:property value="cgc.substring(0,8)" />"> <s:property value="cgc.substring(0,8)+\"-\"+nomeFantasia" /> </option>  
                        </s:iterator>
                        </select>
                   </div>       
                </div>
                 <div class="divLinhaCadastro" id="divPagina" style="display:none" >
                    <div class="divItemGrupo" style="width:500px;"  ><p style="width:80px;">Pág Inicial:</p>
                    	<select name="paginaInicial" id="paginaInicial" style="width:100px;">
	                    	<option value="1">1</option>
	                    	<option value="2" selected="selected">2</option>
	                    	<option value="3">3</option>
	                    	<option value="4">4</option>
	                    	<option value="5">5</option>
	                    	<option value="6">6</option>
	                    	<option value="7">7</option>
	                    	<option value="8">8</option>
	                    	<option value="9">9</option>
	                    	<option value="10">10</option>
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