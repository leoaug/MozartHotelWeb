<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

$(function() {

	$.datepicker.setDefaults($.datepicker.regional['pt-BR']);
	
	$(".dp").datepicker({
		showOn: 'button',
		buttonImage: 'imagens/iconic/png/calendar-2x.png',
		buttonImageOnly: true,
		dateFormat: 'dd/mm/yy',
		numberOfMonths: [1,2]
		         		
	});
	
	
});

	function showDisponibilidade(){

		url = '<%=session.getAttribute("URL_BASE")%>app/crs/popup!prepararDisponibilidade.action';
		url += '?dataIn='+document.getElementById('reservaVO.bcDataEntrada').value+'&dataOut='+document.getElementById('reservaVO.bcDataSaida').value;
		showPopupGrande(url);
	}

    function init(){
        exibeNomeGrupo(document.getElementById('reservaVO.bcGrupo'));
    }
    
    function getEmpresa(elemento){
        url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarEmpresaReserva?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=empresaHotelVO.bcIdEmpresa';
        getDataLookup(elemento, url,'Empresa','TABLE');
    }

	function getBloqueio() {
		erro = '';

		if ($("#chkReservaBloqueio").is(":checked")) {
			if ($('#reservaVO.bcDataEntrada').val() == '')
				erro += '- Insira a data de entrada para localizar os bloqueios\n';
			if ($('#reservaVO.bcDataSaida').val() == '')
				erro += '- Insira a data de saída para localizar os bloqueios\n';
			if ($('#empresaHotelVO.bcNomeFantasia').val() == ''
					|| $('#empresaHotelVO.bcIdEmpresa').val() == '')
				erro += '- Selecione uma empresa para localizar os bloqueios\n';

			if (erro != '')
				alerta(erro);
			else {
				url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarBloqueioReserva?'
						+ 'OBJ_NAME=' + document.getElementById('reservaBloqueio').name
						+ '&OBJ_HIDDEN=reservaVO.bcIdReservaBloqueio'
						+ '&idEmpresa=' + document.getElementById('empresaHotelVO.bcIdEmpresa').value
						+ '&dataEntrada=' + document.getElementById('reservaVO.bcDataEntrada').value
						+ '&dataSaida=' + document.getElementById('reservaVO.bcDataSaida').value;
				getDataLookupBloqueio(document.getElementById('reservaBloqueio'), url, 'Bloqueio', 'TABLE');
			}
		}
	}
	function getCorporate(elemento) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarEmpresaReserva?OBJ_NAME='
				+ elemento.name
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=empresaHotelVO.bcIdCorporate';
		getDataLookup(elemento, url, 'Corporate', 'TABLE');
	}
	function getHospede(elemento) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarHospede?OBJ_NAME='
				+ elemento.name
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=idHospedeSelecionado';
		getDataLookup(elemento, url, 'Hospede', 'TABLE');
	}

	function abrirHospede(indice, qtdePax) {
		document.getElementById('qtdePax').value = qtdePax;
		document.getElementById('indiceResApto').value = indice;
		submitFormAjax('preparaHospedeReservaApartamento?indiceResApto='
				+ indice, true);
		showModal('#divHospedeModal', 200, 600);
	}

	function atualizarResAptoHospede() {
		submitFormAjax('atualizarTelaResApto?indiceResApto='
				+ document.getElementById('indiceResApto').value, true);
	}

	function consultarCorporate() {

		idEmpresa = document.getElementById('empresaHotelVO.bcIdEmpresa').value;
		submitFormAjax('consultarCorporate?idEmpresa=' + idEmpresa, true);
	}

	function adicionarHospede() {
		erro = '';
		if (document.getElementById('idHospedeSelecionado').value == '') {
			erro += 'Selecione um hospede para inserir.';
		}
		if (erro != '') {
			alerta(erro);
		} else {
			indiceResApto = document.getElementById('indiceResApto').value;
			document.getElementById('idResHospede').contentWindow.loading();
			submitFormAjax('adicionarHospedeReservaApartamento?indiceResApto='
					+ indiceResApto + '&idHospedeSelecionado='
					+ $('#idHospedeSelecionado').val() + '&qtdePaxMax='
					+ document.getElementById('qtdePax').value + '&principal='
					+ $('#hospedePrincipal').val(), true);
		}
	}

	function validarGravarReserva() {
		erro = '';

		if (document.getElementById('reservaVO.bcDataEntrada').value == '')
			erro += '- Insira a data de entrada\n';
		if (document.getElementById('reservaVO.bcDataSaida').value == '')
			erro += '- Insira a data de saida\n';
		if (document.getElementById('empresaHotelVO.bcNomeFantasia').value == ''
				|| document.getElementById('empresaHotelVO.bcIdEmpresa').value == '')
			erro += '- Selecione uma empresa\n';
		if (document.getElementById('reservaVO.bcContato').value == '')
			erro += '- Insira um contato\n';
		if (document.getElementById('reservaVO.bcTelefoneContato').value == '')
			erro += '- Insira um telefone de contato\n';

		if (erro != '')
			alerta(erro);
		else {
			submitFormAjax('validarGravacaoReserva', true);
		}

	}

	function cancelarReserva() {

		document.forms[0].action = '<s:url namespace="/app/bloqueio" action="pesquisar" method="prepararPesquisa" />';
		submitForm(document.forms[0]);
	}

	function salvarReserva() {
		dtEntrada = document.getElementById('reservaVO.bcDataEntrada').value;
		dtPrazoCancelamento = document.getElementById('reservaVO.bcDataConfirmaBloqueio').value;

		diferenca = pegaDiferencaDiasDatas(dtEntrada, dtPrazoCancelamento) ;

		if(diferenca==null || diferenca < 1){
			alerta('O prazo de Cancelamento deve ser inferior à data de Entrada!');
			return false;
		}
		
		submitForm(document.forms[0]);
	}

	function verificaDatasERecalculaTarifas() {

		if ($('#empresaHotelVO.bcIdEmpresa').val() == '') {
			alert('Selecione a empresa primeiro');
			return false;
		}

		campoDataEntrada = 'reservaVO.bcDataEntrada';
		campoDataSaida = 'reservaVO.bcDataSaida';
		if (document.getElementById(campoDataSaida).value != ''
				&& document.getElementById(campoDataEntrada).value != '') {
			if (pegaDiferencaDiasDatas(
					document.getElementById(campoDataSaida).value, document
							.getElementById(campoDataEntrada).value) <= 0) {
				document.getElementById(campoDataSaida).value = '';
				return false;
			}
		}

		if (document.getElementById(campoDataEntrada).value != ''
				&& document.getElementById(campoDataSaida).value != '') {
			loading();
			submitFormAjax('validaERecalculaTarifasBloqueio?dataEntrada='
					+ document.getElementById(campoDataEntrada).value
					+ '&dataSaida='
					+ document.getElementById(campoDataSaida).value, true);
		}
	}

	function exibeNomeGrupo(obj) {
		if (obj.readOnly) {
			if (obj.value == 'S')
				obj.value = 'N';
			else if (obj.value == 'N')
				obj.value = 'S';
		}
		if (obj.value == 'S') {
			document.getElementById('divNomeGrupo').style.display = 'block';
			document.getElementById('divLocalizador').style.display = 'block';
		} else {
			document.getElementById('divNomeGrupo').style.display = 'none';
			document.getElementById('divLocalizador').style.display = 'none';
		}
	}

	function exibeDivRoomList() {
		showModal('#divRoomListModal');
		document.getElementById('iRoomList').src = document
				.getElementById('iRoomList').src;
	}

	function atualizarResAptoRL() {
		submitFormAjax('removeRoomListTemorario', true);
		document.getElementById('idResAptoFrame').contentWindow.loading();
		document.getElementById('idResAptoFrame').contentWindow.atualizar();

	}

	function getHospedePadrao(elemento, hidden) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarHospedeRoomListPadrao?OBJ_NAME='
				+ elemento.name
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=' + hidden;
		getDataLookup(elemento, url, 'Hospede', 'TABLE');
	}

	function atualizarResAptoRoomListPadrao() {

		nome = $("#txtRoomList").val();
		idRoomList = $('#hiRoomListPadrao').val();
		killModal();
		loading();
		submitFormAjax('atualizarResAptoRoomListPadrao?hospedeNome=' + nome
				+ '&hospedeId=' + idRoomList, true);
		atualizarResAptoRL();
		killModal();

	}

	function inverterDespesas() {
		document.getElementById('diariaTotalIdIdentificaLancamento1').value = document
				.getElementById('diariaTotalIdIdentificaLancamento1').value == 'E' ? 'H'
				: 'E';
		document.getElementById('alimentosEBebidasIdIdentificaLancamento4').value = document
				.getElementById('alimentosEBebidasIdIdentificaLancamento4').value == 'E' ? 'H'
				: 'E';
		document
				.getElementById('telefoniaEComunicacoesIdIdentificaLancamento6').value = document
				.getElementById('telefoniaEComunicacoesIdIdentificaLancamento6').value == 'E' ? 'H'
				: 'E';
		document.getElementById('lavanderiaIdIdentificaLancamento8').value = document
				.getElementById('lavanderiaIdIdentificaLancamento8').value == 'E' ? 'H'
				: 'E';
		document.getElementById('receitaOutrasIdIdentificaLancamento21').value = document
				.getElementById('receitaOutrasIdIdentificaLancamento21').value == 'E' ? 'H'
				: 'E';

	}

	function alterarDiarias(indiceResApto) {
		document.getElementById('indiceResApto').value = indiceResApto;
		document.getElementById('iDiarias').src = document
				.getElementById('iDiarias').src;
		showModal('#divDiariasModal');
	}

	function mudarHotelCRS() {
		document.forms[0].action = '<s:url namespace="/app/bloqueio" action="manter" method="preparaManterCRS" />';
		submitForm(document.forms[0]);
	}

	function abrirCadastroHospede(pOrigem) {
		killModal();
		$('#origemHospede').val(pOrigem);

		showModal('#divCadastroHospedeModal');
		if ('2' == pOrigem) {
			$('#divParaTodos').css('display', 'block');
		}
	}

	function reabrirHospedeOuRoomList() {
		killModal();
		if ($('#origemHospede').val() == '1') {
			abrirHospede($("#indiceResApto").val(), $("#qtdePax").val());
		} else {
			exibeDivRoomList();
		}
	}

	function gravarNovoHospede() {

		if ($('#nomeHospedeNovo1').val() == '') {
			alerta("O campo 'Nome' é obrigatório.");
			return false;
		}

		if ($('#sobrenomeHospedeNovo1').val() == '') {
			alerta("O campo 'Sobrenome' é obrigatório.");
			return false;
		}

		qtdePax = document.getElementById('qtdePax').value;
		if (qtdePax == '') {
			qtdePax = document.getElementById('idResAptoFrame').contentWindow.document.forms[0].elements["reservaApartamentoVO.bcQtdePax"].value;
		}
		paraTodos = $("#paraTodos").val();
		url = 'gravarNovoHospede?idx=' + $("#indiceResApto").val()
				+ '&paraTodos=' + paraTodos + '&origem='
				+ $("#origemHospede").val() + '&qtdePaxMax=' + qtdePax
				+ '&nome=' + $("#nomeHospedeNovo1").val() + '&sobreNome='
				+ $('#sobrenomeHospedeNovo1').val() + '&cpf='
				+ $('#cpfHospedeNovo1').val() + '&passaporte='
				+ $('#passaporteHospedeNovo1').val() + '&dataNascimento='
				+ $('#dataNascimentoHospedeNovo1').val() + '&email='
				+ $('#emailHospedeNovo1').val() + '&sexo='
				+ $('#sexoHospede').val();
		killModal();
		loading();
		submitFormAjax(url, true);

	}

	function calcularTotalReserva() {
		loading();
		submitFormAjax('calcularTotalReserva?pai=reserva&calculaISS='
				+ document.getElementById('reservaVO.bcCalculaIss').value
				+ '&calculaTaxa='
				+ document.getElementById('reservaVO.bcCalculaTaxa').value
				+ '&calculaRoomTax='
				+ document.getElementById('reservaVO.bcCalculaRoomTax').value
				+ '&calculaSeguro='
				+ document.getElementById('reservaVO.bcCalculaSeguro').value,
				true);
	}

	function setValorReserva(valor) {
		document.getElementById('divValorReserva').innerHTML = valor;
		document.getElementById('idPagamentoReserva').contentWindow
				.setValor(valor);
	}

	function exibeBloqueio(obj) {
		if (obj.checked) {
			document.getElementById('divBloqueio').style.display = 'block';
		} else {
			document.getElementById('divBloqueio').style.display = 'none';
		}
	}
</script>




<s:form namespace="/app/bloqueio" action="manter!salvarReserva" theme="simple">
	<input type="hidden" name="origemHospede" id="origemHospede"/>
	<s:hidden id="idTipoAptoCRS" name="idTipoAptoCRS" />
	<s:hidden id="idApartamentoChart" name="idApartamentoChart" />
	<s:hidden id="origemCrs" name="origemCrs" />
	<s:hidden id="isBloqueio" name="isBloqueio" />
	<s:hidden id="reservaVO.bcIdReservaBloqueio" name="reservaVO.bcIdReservaBloqueio"/>
    <s:hidden id="id" />
    <s:hidden id="empresaHotelVO.bcIdEmpresa" name="empresaHotelVO.bcIdEmpresa"/>
    <s:hidden id="empresaHotelVO.bcIdCorporate" name="empresaHotelVO.bcIdCorporate"/>
    <s:hidden id="empresaHotelVO.bcIdCidade" name="empresaHotelVO.bcIdCidade"/>
    <s:hidden id="reservaVO.bcIdEmpresa" name="reservaVO.bcIdEmpresa"/>
    <s:hidden id="reservaVO.bcIdCentralReservas" name="reservaVO.bcIdCentralReservas"/>
    
    
    <s:hidden id="qtdePax" name="qtdePax"/>    
    <s:hidden id="indiceResApto" name="indiceResApto"/>            
<div class="divFiltroPaiTop">Cadastro de Bloqueio</div>
<div id="divFiltroPai" class="divFiltroPai"  >
        <div id="divFiltro" class="divCadastro"  style="height:235%">
        
<!--Div cadastro de Hospede-->    
 
	<div id="divCadastroHospedeModal" class="divCadastro" style="display: none; height: 300px; width: 600px;">

	<div class="divGrupo" style="width: 98%; height: 200px">
	<div class="divGrupoTitulo">Dados do hóspede</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 60px;">Nome:</p>
		<input type="text" name="nomeHospedeNovo1" id="nomeHospedeNovo1" maxlength="50" size="30" onblur="toUpperCase(this);" /></div>
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 75px;">Sobrenome:</p>
	<input type="text" name="sobrenomeHospedeNovo1" id="sobrenomeHospedeNovo1" maxlength="50" size="30" onblur="toUpperCase(this);" /></div>
	</div>
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 60px;">CPF:</p>
	<input type="text" name="cpfHospedeNovo1" id="cpfHospedeNovo1" maxlength="11" size="15" onkeypress="mascara(this, numeros)" /></div>
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 75px;">Passaporte:</p>
		<input type="text" name="passaporteHospedeNovo1" id="passaporteHospedeNovo1" maxlength="50" size="15"  /></div>
	</div>
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 60px;">Dt. Nasc.:</p>
	<input type="text" name="dataNascimentoHospedeNovo1" id="dataNascimentoHospedeNovo1" maxlength="10" size="15"
		onkeypress="mascara(this, data)" /></div>
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 75px;">E-mail.:</p>
	<input type="text" name="emailHospedeNovo1" id="emailHospedeNovo1" maxlength="60" size="30" /></div>

	</div>
	<div class="divLinhaCadastro">
	
			<div class="divItemGrupo" style="width: 200pt;">
			<p style="width: 60px;">Sexo:</p>
				<SELECT name="sexoHospede" id="sexoHospede">	
					<option value="M" selected="selected">Masculino</option>
					<option value="F">Feminino</option>
				</SELECT>
			</div>
			<div class="divItemGrupo" style="width: 200pt;display:none;" id="divParaTodos">
			<p style="width: 75px;">Para todos?:</p>
				<SELECT name="paraTodos" id="paraTodos">	
					<option value="S">Sim</option>
					<option value="N" selected="selected">Não</option>
				</SELECT>
			</div>
	
	</div>
	</div>

	<div class="divCadastroBotoes" style="width: 98%;">
		<duques:botao label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="reabrirHospedeOuRoomList();" />
		<duques:botao label="Salvar" imagem="imagens/iconic/png/check-4x.png" onClick="gravarNovoHospede();" /></div>
	</div>
	<!--final-->
<!--final-->
        
        
<!--Div lookup de Hospede-->    
            <div id="divHospedeModal"  class="divCadastro" style="display:none;height:200px;width:650px;">       
             <div class="divGrupo" style="width:98%; height:130px">
                <div class="divGrupoTitulo">Dados do hóspedes</div>
              
                    <div class="divLinhaCadastro">
                       <div class="divItemGrupo" style="width:350px;" >
                       	<p style="width:80px;">Nome</p>                                                            
                           <s:textfield  onkeypress="toUpperCase(this)"  onblur="getHospede(this)" id="nomeHospede" name="nomeHospede" size="40" maxlength="40" />
                           <input type="hidden" id="idHospedeSelecionado"/>
                       </div>
                                
                        <div class="divItemGrupo" style="width:200px;" >
                        	<p  style="width:80px;">Principal?</p>                                                            
                            <s:select cssClass="width:60px;" 
                            		  list="#session.LISTA_CONFIRMACAO" 
                            		  listKey="id" 
                            		  listValue="value"
                            		  name="hospedePrincipal"
                            		  id="hospedePrincipal"/>
                        </div>
                        <div class="divItemGrupo" style="width:65px;" >
                            <img  src="imagens/iconic/png/plus-3x.png" title="Incluir hóspede selecionado" style="margin:0px;" onclick="adicionarHospede();"/>  
                            <img  src="imagens/hospede.png" title="Incluir novo hóspede" style="margin:0px;" onclick="abrirCadastroHospede('1');"/>
                        </div>
                                
                    </div>
                    <iframe width="100%" height="70px;" id="idResHospede" frameborder="0" marginheight="0" marginwidth="0" src="<s:url value="app/bloqueio/include!prepararHospede.action"/>?time=<%=new java.util.Date()%>"  ></iframe> 
             </div>          
            
             <div class="divCadastroBotoes" style="width:98%;">
                  <duques:botao label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="atualizarResAptoRL(); $.modal.close()" />
                  <!--<duques:botao label="Adicionar"  style="width:120px;" imagem="imagens/iconic/png/check-2x.png" onClick="adicionarHospede($('#nomeHospede').val());" />-->
             </div>               
            </div>
<!--final-->
            <!--Inicio reserva apartamento diaria-->
              <div id="divDiariasModal" class="divCadastro" style="height:550px; width:650px;  display:none;">
              	<div class="divGrupo" style="height:450px">
	                <div class="divGrupoTitulo">Diárias</div>
	                <div class="divLinhaCadastro" style="width: 99%;margin-bottom: 3px; padding-left: 1px; background-color: rgb(66, 198, 255);color: White;" >                            
	                    <div class="divItemGrupo" style="width: 110px;"><p style="width:100px;color:white;">Dia</p></div>
	                    <div class="divItemGrupo" style="width: 110px;"><p style="width:100px;color:white;">Valor</p></div>
		            </div>
	                <iframe width="630px" height="400px;" id="iDiarias" scrolling="yes" frameborder="0" marginheight="0" marginwidth="0" src="<s:url value="app/bloqueio/include!prepararDiarias.action"/>?time=<%=new java.util.Date()%>"  ></iframe>
	            </div>                    
                <div class="divCadastroBotoes" >                
                    <duques:botao label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="killModal();atualizarResAptoRL();" />
                </div>
              </div>
              <!--Fim reserva apartamento diaria-->                        


              <!--Inicio room list-->
              <div id="divRoomListModal" class="divCadastro" style="height:520px; width:900px;  display:none;">
                  <div class="divGrupo" style="height:430px">
		               <div class="divGrupoTitulo">Room List</div>
		               
		                 <div class="divLinhaCadastro" style="top:22px; position:absolute;width:99%; text-align:right; border: 0px; margin-bottom:2px; margin-left:2px; background-color: transparent;">
			               <ul style="width: 55%; margin: 0px; list-style: none; font-size: 8pt; padding-right:2px; text-align:right; float:right;">
								<li style="font-size: 8pt; float:left; padding-right:5px;"><img src="imagens/imgLegAmarelo.png" width="10px" height="10px" />&nbsp;No show</li>
								<li style="font-size: 8pt; float:left; padding-right:5px;"><img src="imagens/imgLegVermelho.png" width="10px" height="10px" />&nbsp;Reserva não confirmada</li>
								<li style="font-size: 8pt; float:left; padding-right:5px;"><img src="imagens/imgLegAzulClaro.png" width="10px" height="10px" />&nbsp;Reserva com check-in</li>
								<li style="font-size: 8pt; float:left; padding-right:5px;"><img src="imagens/imgLegOlive.png" width="10px" height="10px" />&nbsp;Reserva com check-out</li>
						   </ul>
						 </div>
						
		                <div class="divLinhaCadastro" style="width: 99%;margin-bottom: 3px; padding-left: 1px; background-color: rgb(66, 198, 255);color: White;" >                            
		                    <div class="divItemGrupo" style="width: 99%;">
		                    	<p style="width:100px;color:white;">Hóspede único:</p>                    
		                    	<input type="text" size="20" onkeypress="toUpperCase(this)" onblur="getHospedePadrao(this,'hiRoomListPadrao');" id="txtRoomList" name="txtRoomList" value="" />
		                    	<input type="text" size="1" name="nome1" style="border:0px; width:1px; background-color: rgb(66, 198, 255)" />
		                    	<input type="hidden" name="hiRoomListPadrao" id="hiRoomListPadrao"/>
		                    	<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png" title="Adicionar hóspede" style="margin:0px;" onclick='atualizarResAptoRoomListPadrao();'/>
		                    	<img  src="imagens/hospede.png" title="Incluir novo hóspede" style="margin:0px;" onclick="abrirCadastroHospede('2');"/>
		                    </div>
		                </div>
		                <div class="divLinhaCadastro" style="width: 99%;margin-bottom: 3px;padding-left: 1px;	background-color: rgb(66, 198, 255);color: White;">                            
		                    <div class="divItemGrupo" style="width:60px; " ><p style="color:white;">Tipo Ap.</p></div>
		                    <div class="divItemGrupo" style="width:60px; " ><p style="color:white;">Pax.</p></div>
							<div class="divItemGrupo" style="width:60px; " ><p style="color:white;">Apart.</p></div>
							
		                    <div class="divItemGrupo" style="width:95px;text-align:center; "><p style="color:white;"> Hóspede 1</p> </div>                    
		                    <div class="divItemGrupo" style="width:95px;text-align:center; "><p style="color:white;"> Hóspede 2</p></div>                    
		                    <div class="divItemGrupo" style="width:95px;text-align:center; "><p style="color:white;"> Hóspede 3</p></div>
		                    <div class="divItemGrupo" style="width:95px;text-align:center; "><p style="color:white;"> Hóspede 4</p></div>
		                    <div class="divItemGrupo" style="width:95px;text-align:center; "><p style="color:white;"> Hóspede 5</p></div>
		                    <div class="divItemGrupo" style="width:95px;text-align:center; "><p style="color:white;"> Hóspede 6</p></div>
		                    <div class="divItemGrupo" style="width:95px;text-align:center;" ><p style="color:white;"> Hóspede 7</p></div>
		                </div>
		                <iframe width="100%" height="315px;" id="iRoomList" scrolling="yes" frameborder="0" marginheight="0" marginwidth="0" src="<s:url value="app/bloqueio/include!prepararRoomList.action"/>?time=<%=new java.util.Date()%>"  ></iframe>
					</div> 

		            <div class="divCadastroBotoes" >                
	                    <duques:botao label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="killModal();atualizarResAptoRL();" />
	                </div>

              </div>
              <!--Fim room list-->                        
            
        
            <!--Início dados da reserva -->
             <div class="divGrupo" style="width:99%; height:140px">
                <div class="divGrupoTitulo">Dados do Bloqueio</div>

				<s:if test="%{origemCrs}">
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:310pt;" ><p>Hotel:</p>
                    	<s:select list="#session.CRS_SESSION_NAME.hoteisAtivos"
                        			  name="idHotelCRS"
                        			  listKey="idHotel"
                        			  listValue="nomeFantasia"
                        			  cssStyle="width:170px;" onchange="mudarHotelCRS()"/>
                    </div>
                </div>                                                
				</s:if>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:310pt;" ><p>Empresa:</p>                         
                        <s:textfield onblur="getEmpresa(this); getBloqueio();" id="empresaHotelVO.bcNomeFantasia" name="empresaHotelVO.bcNomeFantasia" size="50" maxlength="50" />
                    </div>
                    <div class="divItemGrupo" style="width:130pt;" ><p style="width:60pt;">Confirmada:</p>                     
                        <s:select id="reservaVO.bcConfirma" name="reservaVO.bcConfirma" list="#session.ListaSimNao" cssStyle="width:60pt" listKey="id" listValue="value" />
                    </div>
                    <s:if test="%{!isBloqueio}">
					<div id="divGrupoReserva" class="divItemGrupo" style="width:128pt;" ><p style="width:55pt;">Grupo:</p>                         
                        <s:select id="reservaVO.bcGrupo" name="reservaVO.bcGrupo" onchange="exibeNomeGrupo(this);" list="#session.ListaSimNao" cssStyle="width:60pt" listKey="id" listValue="value" />
                    </div>
					</s:if>
					<s:else>
					<div id="divGrupoReserva" class="divItemGrupo" style="width:128pt;" >
                        <s:hidden id="reservaVO.bcGrupo" value="S" />
                    </div>
					</s:else>
                    <div class="divItemGrupo" style="width:140pt;" ><p style="width:65pt;">Forma reserva:</p>                         
                        <s:select id="reservaVO.bcFormaReserva" name="reservaVO.bcFormaReserva" list="#session.ListaFormaReserva" cssStyle="width:60pt;" listKey="id" listValue="value" />                        
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:310pt;" ><p>Corporate:</p>                         
                        <s:textfield onblur="getCorporate(this)" name="empresaHotelVO.bcCorporate" id="empresaHotelVO.bcCorporate" size="50" maxlength="50"/>
                    </div>
                    <div class="divItemGrupo" style="width:130pt;" ><p style="width:60pt;">Moeda:</p>
						<s:select id="idMoeda" name="idMoeda" list="#session.moedaList" cssStyle="width:60pt" listKey="idMoeda" />                    	                         
                    </div>
                    <div class="divItemGrupo" style="width:128pt;" ><p style="width:55pt;">Tipo mídia:</p> 
                        <s:select id="reservaVO.bcIdReservaMida" name="reservaVO.bcIdReservaMida" list="#session.ListaTipoMidia" cssStyle="width:60pt" listKey="id" listValue="value" />
                    </div>
                    <div class="divItemGrupo" style="width:140pt;" ><p style="width:65pt;">Permuta:</p> 
                        <s:select id="reservaVO.bcPermuta" name="reservaVO.bcPermuta" list="#session.ListaSimNao" cssStyle="width:60pt" listKey="id" listValue="value" />                        
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:310pt;" ><p>Período:</p>                                 
                                <s:textfield cssClass="dp" name="reservaVO.bcDataEntrada" onblur="dataValida(this); getBloqueio();" onchange="verificaDatasERecalculaTarifas();" onkeypress="mascara(this,data);" id="reservaVO.bcDataEntrada" size="8" maxlength="10" /> 
                                à 
                                <s:textfield cssClass="dp" name="reservaVO.bcDataSaida" onblur="dataValida(this);" onchange="verificaDatasERecalculaTarifas();" onkeypress="mascara(this,data);" id="reservaVO.bcDataSaida" size="8" maxlength="10" />
                                <img src="imagens/iconic/png/imgChartReserva-4x.png" title="Disponibilidade/ocupação" onclick="showDisponibilidade()" />                                
                    </div>
                    <div class="divItemGrupo" style="width:258pt;" ><p style="width:119pt;">Prazo cancelamento:</p>                                 
                                <s:textfield cssClass="dp" name="reservaVO.bcDataConfirmaBloqueio" id="reservaVO.bcDataConfirmaBloqueio" onkeypress="mascara(this,data)" onblur="dataValida(this)" size="8" maxlength="10"/>
                    </div>
                    <div class="divItemGrupo" style="width:138pt;" ><p style="width:66pt;">Deadline:</p>                                 
                                <s:textfield name="reservaVO.bcDeadLine" id="reservaVO.bcDeadLine" onkeypress="mascara(this,numero)"  size="1" maxlength="3"/>
                    </div> 
                </div>
                <div class="divLinhaCadastro">
                    <s:if test="%{!isBloqueio}">
				  	<div class="divLinhaCadastro">
				  		<div class="divItemGrupo" style="width:110pt;" ><p style="width:90pt;">Reserva de Bloqueio:</p>                         
							<s:checkbox name="reservaBloqueio" onclick="exibeBloqueio(this); getBloqueio();" id="chkReservaBloqueio" />
						</div>
						<div class="divItemGrupo" style="width:310pt; display: none;" id="divBloqueio" ><p style="width:57pt;">Bloqueio:</p>                         
							<s:textfield id="reservaBloqueio" name="reservaBloqueio" size="50" maxlength="50" disabled="true"/>
						</div>
					</div>
					</s:if>
                </div>
              </div>
              <!--Fim dados da reserva -->
              <!--Inicio dados apartamento-->
              <div id="divReservaApartamento" class="divGrupo" style="width:99%; height:265px;">
                <div class="divGrupoTitulo" style="float:left;">Dados do apartamento</div>
                    <div id="divLegenda" class="divLinhaCadastro" style="margin:0;padding:0; float:right; width:500px; border: 0px; background-color: transparent;">
			               <ul style="width: 100%; margin: 0px; list-style: none; font-size: 8pt; padding:0px;">
								<li style="font-size: 8pt; float:left; padding-right:5px;"><img src="imagens/imgLegAmarelo.png" width="10px" height="10px" />&nbsp;No show</li>
								<li style="font-size: 8pt; float:left; padding-right:5px;"><img src="imagens/imgLegVermelho.png" width="10px" height="10px" />&nbsp;Reserva não confirmada</li>
								<li style="font-size: 8pt; float:left; padding-right:5px;"><img src="imagens/imgLegAzulClaro.png" width="10px" height="10px" />&nbsp;Reserva com check-in</li>
								<li style="font-size: 8pt; float:left; padding-right:5px;"><img src="imagens/imgLegOlive.png" width="10px" height="10px" />&nbsp;Reserva com check-out</li>
						   </ul>
					</div>
                
                <iframe width="100%" height="220" id="idResAptoFrame" scrolling="no" frameborder="0" marginheight="0" marginwidth="0" src="<s:url value="app/bloqueio/include!prepararReservaApto.action"/>?time=<%=new java.util.Date()%>"  ></iframe> 
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo"  style="width:320pt; float:left;" ><p>Garante No-Show:</p> 
                        <s:select id="reservaVO.bcGaranteNoShow" name="reservaVO.bcGaranteNoShow" list="#session.ListaSimNao" cssStyle="width:60pt" listKey="id" listValue="value" />
                    </div>                    
                    <div class="divItemGrupo" style="width:180pt; float:right;" ><p style="width:90pt;">Fidelidade:</p> 
                        <s:select id="reservaVO.bcFidelidade" name="reservaVO.bcFidelidade" list="#session.ListaSimNao" cssStyle="width:60pt" listKey="id" listValue="value" />                        
                    </div>
                    <div class="divItemGrupo" style="clear:both; margin-left: 220px; margin-top: -20px;"  id="divNomeGrupo" ><p>Nome Grupo:</p> 
                        <s:textfield id="reservaVO.bcNomeGrupo" name="reservaVO.bcNomeGrupo"  cssStyle="width: 200px;" />                        
                    </div>
                </div>
              </div>
              <!--Fim dados apartamento-->
              
              <!--Inicio total reserva-->
              <div class="divGrupo" style="width:99%; height:50px">
                <div class="divGrupoTitulo">Total bloqueio</div>
                <div class="divLinhaCadastro">                    
                        <div class="divItemGrupo" style="width:130pt;" ><p>Taxa de serviço:</p> 
                            <div id="divValorTaxaServico" >0,00</div>
                        </div>
                        
                        <div class="divItemGrupo" style="width:120pt;" ><p style="width:60pt;">Room Tax:</p> 
                            <div id="divValorRoomTax">0,00</div>
                        </div>
    
                        <div class="divItemGrupo" style="width:100pt;" ><p style="width:30pt;">ISS:</p> 
                            <div id="divValorISS">0,00</div>
                        </div>
                        
                        <div class="divItemGrupo" style="width:250pt;" ><p >Valor Reserva:</p> 
                            <div id="divValorReserva">0,00</div>
                        </div>                                   
                </div>    
              </div>
              <!--Fim total reserva-->
              
              <!--Inicio dados pagamento-->
              <div class="divGrupo" style="width:99%; height:270px">
                <div class="divGrupoTitulo">Dados do pagamento</div>
                <iframe width="100%" height="230px;" id="idPagamentoReserva" scrolling="no" frameborder="0" marginheight="0" marginwidth="0" src="<s:url value="app/bloqueio/include!prepararReservaPagamento.action"/>?time=<%=new java.util.Date()%>"  ></iframe>  
              </div>
              <!--Fim dados pagamento-->                        
              
            <!--Início outras informações -->
             <div class="divGrupo" style="width:99%; height:110px">
                <div class="divGrupoTitulo">Outras informações</div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:320pt;" ><p>Contato:</p> 
                        <s:textfield id="reservaVO.bcContato" name="reservaVO.bcContato" size="50" maxlength="30" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:130pt;" ><p style="width:80pt;">Taxa de serviço:</p> 
                        <s:select id="reservaVO.bcCalculaTaxa" name="reservaVO.bcCalculaTaxa" list="#session.ListaSimNao" cssStyle="width:40pt" listKey="id" listValue="value" onchange="calcularTotalReserva()" />
                    </div>

                    <div class="divItemGrupo" style="width:130pt;" ><p style="width:80pt;">Room tax:</p> 
                        <s:select id="reservaVO.bcCalculaRoomTax" name="reservaVO.bcCalculaRoomTax" list="#session.ListaSimNao" cssStyle="width:40pt" listKey="id" listValue="value" onchange="calcularTotalReserva()"/>
                    </div>

                    <div class="divItemGrupo" style="width:130pt;" ><p style="width:50pt;">ISS:</p> 
                        <s:select id="reservaVO.bcCalculaIss" name="reservaVO.bcCalculaIss" list="#session.ListaSimNao" cssStyle="width:40pt" listKey="id" listValue="value" onchange="calcularTotalReserva()"/>
                    </div>
                    
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:170pt;" ><p>Telefone:</p> 
                            <s:textfield id="reservaVO.bcTelefoneContato" name="reservaVO.bcTelefoneContato" size="15" maxlength="20" onkeypress="mascara(this,telefone)" />                            
                    </div>
                    <div class="divItemGrupo" style="width:150pt;" ><p  style="width:30pt;">Fax:</p> 
                            <s:textfield id="reservaVO.bcFaxContato" name="reservaVO.bcFaxContato" size="15" maxlength="14" onkeypress="mascara(this,telefone)" />
                    </div>
                    <div class="divItemGrupo" style="width:200px;" ><p style="width:80pt;">Tipo de Pensão:</p> 
                        <s:select id="reservaVO.bcTipoPensao" name="reservaVO.bcTipoPensao" list="#session.ListaTipoPensao" cssStyle="width:90px" listKey="id" listValue="value" />
                    </div>
                    <s:if test='%{#session.HOTEL_SESSION.seguro > 0.0}'>
	                    <div class="divItemGrupo" style="width:115px;" ><p style="width:50px;">Seguro:</p> 
	                        <s:select id="reservaVO.bcCalculaSeguro" name="reservaVO.bcCalculaSeguro" list="#session.ListaSimNao" cssStyle="width:60px" listKey="id" listValue="value" />
	                    </div>
					</s:if>
					<s:else>
						<s:hidden name="reservaVO.bcCalculaSeguro" id="reservaVO.bcCalculaSeguro" value="N" />
					</s:else>
                    
                    <div class="divItemGrupo" style="width:140pt;" ><p style="width:75pt;">Bebida alcoólica:</p> 
                        <s:select id="reservaVO.bcFlgAlcoolica" name="reservaVO.bcFlgAlcoolica" list="#session.ListaSimNao" cssStyle="width:40pt" listKey="id" listValue="value" />
                    </div>
                    
                </div>
                
                
                 <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:320pt;" ><p>Cidade:</p>                             
                            <s:textfield disabled="true" id="empresaHotelVO.bcCidade" name="empresaHotelVO.bcCidade" size="50" maxlength="50" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:260pt;" ><p  style="width:80pt;">E-mail:</p>                                                     
                            <s:textfield id="reservaVO.bcEmailContato" name="reservaVO.bcEmailContato" size="35" maxlength="50" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:130pt;" ><p style="width:50pt;">Comissão:</p> 
                            <s:textfield id="reservaVO.bcComissao" name="reservaVO.bcComissao" cssStyle="width:45px;" maxlength="50" onkeypress="mascara(this,moeda)" />
                    </div>
                </div>
                
              </div>
        <!--Fim outras informações -->

        <!--Início despesas -->
             <div class="divGrupo" style="width:99%; height:190px;">
               <div class="divGrupoTitulo">Despesas</div>
               
                <div class="divLinhaCadastroPrincipal" style="height:25px;">
                    <div class="divItemGrupo" style="width:200pt;" ><p style="color:white;">Descrição:</p></div>
                    <div class="divItemGrupo" style="width:130pt;" ><p style="color:white;">Quem paga:</p> <img title="Inverter despesas" src="imagens/iconic/png/loop-circular-3x.png" onclick="inverterDespesas();" /> </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:200pt;" ><p style="width:99%;">DIARIA - TOTAL</p></div>
                    <div class="divItemGrupo" style="width:150pt;" >
                        <s:select id="diariaTotalIdIdentificaLancamento1" name="diariaTotalIdIdentificaLancamento1" list="#session.ListaEmpresaHospede" cssStyle="width:80pt" listKey="id" listValue="value" />
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:200pt;" ><p style="width:99%;">ALIMENTOS E BEBIDAS</p></div>
                    <div class="divItemGrupo" style="width:150pt;" >                        
                        <s:select id="alimentosEBebidasIdIdentificaLancamento4" name="alimentosEBebidasIdIdentificaLancamento4" list="#session.ListaEmpresaHospede" cssStyle="width:80pt" listKey="id" listValue="value" />
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:200pt;" ><p style="width:99%;">TELEFONIA E COMUNICACOES</p></div>
                    <div class="divItemGrupo" style="width:150pt;" >                        
                        <s:select id="telefoniaEComunicacoesIdIdentificaLancamento6" name="telefoniaEComunicacoesIdIdentificaLancamento6" list="#session.ListaEmpresaHospede" cssStyle="width:80pt" listKey="id" listValue="value" />
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:200pt;" ><p style="width:99%;">LAVANDERIA</p></div>
                    <div class="divItemGrupo" style="width:150pt;" >                        
                        <s:select id="lavanderiaIdIdentificaLancamento8" name="lavanderiaIdIdentificaLancamento8" list="#session.ListaEmpresaHospede" cssStyle="width:80pt" listKey="id" listValue="value" />                        
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:200pt;" ><p style="width:99%;">RECEITA - OUTRAS</p></div>
                    <div class="divItemGrupo" style="width:150pt;" >                        
                        <s:select id="receitaOutrasIdIdentificaLancamento21" name="receitaOutrasIdIdentificaLancamento21" list="#session.ListaEmpresaHospede" cssStyle="width:80pt" listKey="id" listValue="value" />                                                
                    </div>
                </div>
                
                
                
              </div>
        <!--Fim despesas -->
         <!--Início obj -->
             <div class="divGrupo" style="width:99%; height:140px;">
               <div class="divGrupoTitulo">Observações</div>
                <div class="divLinhaCadastro" style="height:50px;">
                    <div class="divItemGrupo" style="width:100%;height:50px;" >
                    	<p style="width: 80px;">Obs.</p>
                    	<s:textarea name="reservaVO.bcObservacao" cols="80" rows="2" onkeypress="toUpperCase(this)" onblur="toUpperCase(this)"></s:textarea>
                    </div>
                </div>
                <div class="divLinhaCadastro" style="height:50px;">
                    <div class="divItemGrupo" style="width:100%;height:50px;" >
                    	<p style="width: 80px;">Obs. voucher</p>
                    	<s:textarea name="reservaVO.bcObservacaoVoucher" cols="80" rows="2" onkeypress="toUpperCase(this)" onblur="toUpperCase(this)"></s:textarea>
                    </div>
                </div>
                
              </div>
        <!--Fim obs -->
              
              <div class="divCadastroBotoes">
                    <div style="float:left" id="divLocalizador">
                    Localizador <font color="red" size="2"><b> <s:property value="reservaVO.bcIdReserva" /></b></font>
                        <s:hidden name="reservaVO.bcIdReserva" id="reservaVO.bcIdReserva"/>
                    </div>
                    
                    <div style="float:left" id="divVoucher">
                    	<div class="divItemGrupo" >
                    	<p style="width:200px">Imprimir voucher após gravação?</p>
                    	<select name="imprimirVoucher" id="imprimirVoucher">
                    		<option value="S" >Sim</option>
                    		<option value="N" selected="selected" >Não</option>
                    	</select> 
                        
						</div>
                    </div>
                    
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelarReserva();" />
                    <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="validarGravarReserva();" />
              </div>
        </div>
</div>
    <script type="text/javascript">init();</script>    
</s:form>