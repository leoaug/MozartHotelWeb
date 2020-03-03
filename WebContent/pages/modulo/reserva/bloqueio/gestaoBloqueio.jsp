<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">

window.onload = function() {

	addPlaceHolder('.empresa');
	
};

function addPlaceHolder(classe) {

	$(classe).attr("placeholder","ex.: digite o Nome da empresa ou o número do bloqueio");
		
}
	function getBloqueio() {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarBloqueio?'
				+ 'OBJ_NAME='
				+ document.getElementById('reservaBloqueioVO.bloqueio').name
				+ '&OBJ_HIDDEN=reservaVO.bcIdReservaBloqueio' + '&OBJ_VALUE='
				+ document.getElementById('reservaBloqueioVO.bloqueio').value;
		getDataLookup(document.getElementById('reservaBloqueioVO.bloqueio'),
				url, 'Bloqueio', 'TABLE');
	}

	function consultarTarifasEApartamentos() {
		idBloqueio = document.getElementById('idBloqueio').value;
		dataIniBloq = document.getElementById('dataIniBloq').value;
		dataFimBloq = document.getElementById('dataFimBloq').value;
		bcDataEntrada = document.getElementById('bcDataEntrada').value;
		bcDataSaida = document.getElementById('bcDataSaida').value;

		dtIni = cDate(dataIniBloq,'date');
		dtFim = cDate(dataFimBloq,'date');
		
		pDtIni = cDate(bcDataEntrada,'date');
		pDtFim = cDate(bcDataSaida,'date');


		 var periodoInvalido = false;
		mensagem ="";
		if((pDtIni < dtIni) | (pDtIni > dtFim)){
			periodoInvalido = true;
			mensagem = "O período informado deve estar no intervalo do bloqueio";
		}
		
		if((pDtFim < dtIni) | (pDtFim > dtFim)){
			periodoInvalido = true;
			mensagem = "O período informado deve estar no intervalo do bloqueio";
		}
		if(pDtIni>pDtFim){
			periodoInvalido = true;
			mensagem = "A data inicial deve ser menor que a final";
		}
		
		if(pegaDiferencaDiasDatas(bcDataSaida,bcDataEntrada) > 45){
			periodoInvalido = true;
			mensagem = "O intevalo máximo deve ser de 45 dias ";
		}

		
		if(idBloqueio==null | idBloqueio==''){
			alerta("O campo 'Empresa' é obrigatório");
			return false;
		}
		if(periodoInvalido){
			alerta(mensagem);
			return false;
		}		
		loading();

		submitFormAjax(
				'consultarTarifasEApartamentos?idBloqueio=' + idBloqueio, true);
	}
	function cancelarGestao() {

		document.forms[0].action = '<s:url namespace="/app/bloqueio" action="pesquisar" method="prepararPesquisa" />';
		submitForm(document.forms[0]);
	}
	function salvar() {

		document.forms[0].action = '<s:url namespace="/app/bloqueio" action="pesquisar" method="salvarGestao" />';
		submitForm(document.forms[0]);
	}
	function getEmpresa(elemento){
        url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarBloqueioGestaoEmpresa?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=bcIdEmpresa'+'&OBJ_HIDDEN_ID=idBloqueio';
        getDataLookup(elemento, url,'Empresa','TABLE');
        
    }
    function carregarGestao(){
		
		killModal();
    }
   	function atualizar() {
   	   	iFrameTarifas = document.getElementById('idGestaoBloqueioTarifas');
   	   	iFrameQtd = document.getElementById('idGestaoBloqueioQtde');
   	 	dtEntrada = $('#bcDataEntrada');
		dtSaida = $('#bcDataSaida');

   	   	if(iFrameTarifas != null){
   	   		iFrameTarifas.contentWindow.atualizar();
   	   		//iFrameTarifas.setAttribute("src", "app/bloqueio/include!prepararTarifasGestaoBloqueio.action?bcDataEntrada="+dtEntrada.val()+ "&bcDataSaida="+dtSaida.val());
		}
   	   	if(iFrameQtd != null){
   	   		iFrameQtd.contentWindow.atualizar();
   	   		iFrameQtd.setAttribute("src", "app/bloqueio/include!prepararQtdeGestaoBloqueio.action?bcDataEntrada="+dtEntrada.val()+ "&bcDataSaida="+dtSaida.val());
		}
	}
   	$(function() {

   		$.datepicker.setDefaults($.datepicker.regional['pt-BR']);
   		
   		$("#bcDataEntrada").datepicker({
   			showOn: 'button',
   			buttonImage: 'imagens/iconic/png/calendar-2x.png',
   			buttonImageOnly: true,
   			dateFormat: 'dd/mm/yy',
   			numberOfMonths: 1,
	   		changeMonth: true,
	   		changeYear: true,
	   		onClose: function( selectedDate ) {
	   			$( "#bcDataSaida" ).datepicker( "option", "minDate", selectedDate );
	   			$( "#bcDataSaida" ).datepicker( "option", "maxDate", selectedDate + 15 );
	   		}
   		});
   		$("#bcDataSaida").datepicker({
   			showOn: 'button',
   			buttonImage: 'imagens/iconic/png/calendar-2x.png',
   			buttonImageOnly: true,
   			dateFormat: 'dd/mm/yy',
   			numberOfMonths: 1,
	   		changeMonth: true,
	   		changeYear: true
   		});

   		$(".dp").click(function() {
   	        $(this).datepicker().datepicker( "show" );
   	    });
   		
   		
   	});

   	function setValorPeriodo(pDataIn, pDataOut){
		dtEntrada = $('#bcDataEntrada');
		dtSaida = $('#bcDataSaida');
		dataIniBloq = $('#dataIniBloq');
		dataFimBloq = $('#dataFimBloq');

		var dateInAux= cDate(pDataIn,'date');
		
		dateInAux.setDate(dateInAux.getDate() + 15);
		
		dtEntrada.val(pDataIn);
		dataIniBloq.val(pDataIn);
		dtSaida.val(pDataOut);
		dataFimBloq.val(pDataOut);
		
   	}
</script>


<s:form namespace="/app/bloqueio"
	action="manterMapa!pesquisarMapa.action" theme="simple">
	<s:hidden id="origemCrs" name="origemCrs" />
	<s:hidden id="idReservaBloqueio"
		name="idReservaBloqueio" />
	<s:hidden id="idBloqueio"
		name="idBloqueio" />
	<s:hidden id="bcIdEmpresa"
		name="bcIdEmpresa" />
	
		<s:set name="bloqueio" value="#session.BLOQUEIO" />

	<div class="divFiltroPaiTop">Gestão do bloqueio</div>
	<div class="divFiltroPai">

		<div class="divCadastro" style="height: 610px;">

			<div class="divGrupo" style="height: 125px;">
				<div class="divGrupoTitulo">Dados do bloqueio</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 535px;">
						<p style="width: 70px;">Empresa:</p>
							<s:textfield cssClass="empresa" onblur="getEmpresa(this);"
								id="bcNomeFantasia"
								name="bcNomeFantasia" size="80" maxlength="50" />
					</div>
					<div class="divItemGrupo" style="width: 310px;">
							<p style="width: 80px;">Período:</p>
								<s:textfield cssClass="dp" name="bcDataEntrada" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="bcDataEntrada" size="8" maxlength="10" /> 
                                à 
                                <s:textfield cssClass="dp" name="bcDataSaida" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="bcDataSaida" size="8" maxlength="10" />
								<s:hidden name="dataIniBloq" id="dataIniBloq" /> 
                                <s:hidden name="dataFimBloq" id="dataFimBloq" />
					</div>
					<div class="divItemGrupo" style="width: 80px; height:20px">
						
						<img src="imagens/pesquisar.png"
							onClick="consultarTarifasEApartamentos();" />
						
					</div>
				</div>

				<iframe width="100%" height="75px" id="idGestaoBloqueioCabecalho" 
					scrolling="no" frameborder="0" marginheight="0" marginwidth="0"
					src="<s:url value="app/bloqueio/include!prepararCabecalhoGestaoBloqueio.action"/>">
				</iframe>
			</div>
			<br />
			<div class="divGrupo" style="height: 435px;">
				<div class="divGrupoTitulo">Resultado</div>
				<div id="divMovimento"
					style="width: 99%; height: 95%; overflow-y: auto; margin: 0px; padding: 0px; background-color: white;">
					
						<iframe width="100%" style="overflow-x: auto;"  height="180px" id="idGestaoBloqueioTarifas"
							 frameborder="0" marginheight="0" marginwidth="0"
							src="<s:url value="app/bloqueio/include!prepararTarifasGestaoBloqueio.action"/>">
						</iframe>
						<iframe width="100%" style="overflow-x: auto;"  height="220px" id="idGestaoBloqueioQtde"
							frameborder="0" marginheight="0" marginwidth="0"
							src="<s:url value="app/bloqueio/include!prepararQtdeGestaoBloqueio.action"/>">
						</iframe>
				</div>
			</div>
		</div>
	</div>
	<div class="divCadastroBotoes">
		<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
			onClick="cancelarGestao();" />
		<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
			onClick="salvar();" />
	</div>
</s:form>