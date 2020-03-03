<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>


<script type="text/javascript">
    var nomeHospede = '';

    function init(){
            
    }

	function imprimirCupomFiscal(){
        vForm = document.forms[0];
        vForm.action = '<s:url action="checkout!prepararCupomFiscal.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
	}

	function finalizaCupomFiscal(){
		aCupomFiscal = document.appletCupomFiscal;
		<s:if test="%{#session.HOTEL_SESSION.cupomfiscal == \"S\"}" >
			try{

				aCupomFiscal.IniciaFechamento("A","%","0");
				<s:iterator value="#session.movimentoPagamentoCupomList">
					aCupomFiscal.efetuaPagamento('<s:property value="tipoLancamentoEJB.descricaoLancamento"/>',
												 '<s:property value="valorLancamento<0?valorLancamento*-1:valorLancamento"/>');
				</s:iterator>

				<s:iterator value="#session.movimentoNotaHospedagem" var="mov">
				<s:if test="%{#mov.tipoLancamentoEJB.notaFiscal == \"S\" && valorLancamento < 0}">
					aCupomFiscal.efetuaPagamento('<s:property value="tipoLancamentoEJB.descricaoLancamento"/>',
												 '<s:property value="valorLancamento<0?valorLancamento*-1:valorLancamento"/>');
				</s:if>
				</s:iterator>


				aCupomFiscal.finalizaCupomFiscal();
				<s:set scope="session" name="movimentoPagamentoCupomList" value="%{null}" /> 
			}catch(err){
				alert(err.description);
				killModal();
				openCheckout();
			}	
		</s:if>

	}

	
	function abrirCupomFiscal(){
		
		aCupomFiscal = document.appletCupomFiscal;
		<s:if test="%{#session.HOTEL_SESSION.cupomfiscal == \"S\"}" >
			try{
				loading();
				
				var numCupom = aCupomFiscal.obterNumeroCupom(); 
				if (numCupom == '' || numCupom == null){
					//cancela a nota de hospedagem, erro no cupom fiscal
					vForm = document.forms[0];
			        vForm.action = '<s:url action="checkout!cancelarCupomFiscal.action" namespace="/app/contacorrente" />';
			        submitForm( vForm );
				}
				<s:iterator value="#session.movimentoNotaHospedagem" var="mov">
				<s:if test="%{#mov.tipoLancamentoEJB.notaFiscal == \"S\" && valorLancamento >= 0}">
					aCupomFiscal.vendeItem('<s:property value="tipoLancamentoEJB.grupoLancamento"/>','<s:property value="tipoLancamentoEJB.descricaoLancamento"/>','FF','I','1',2,'<s:property value="valorLancamento"/>','$','0');
				</s:if>
				</s:iterator>
				
				killModal();
				openCheckout();
				submitFormAjax('preencheCupomFiscal?numCupomFiscal='+numCupom,true);
				
			}catch(err){
				alert(err.description);
				killModal();
				openCheckout();
			}	

		</s:if>

	}

    
	function unificarTaxaCheckin(){
	
		vForm = document.forms[0];
        vForm.action = '<s:url action="checkout!unificarTaxas.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
		
	}
    
	function abrirNotaHospedagem(){
		//showModal('#divNotaHospedagem', '550', '850');
	}
	function abrirRPS(){
		reportAddress = '<s:property value="#session.URL_REPORT"/>';

		reportAddress += '/index.jsp?REPORT=';
		report='RPSReport';		
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';ID_NOTA@<s:property value="#request.idNota"/>';
		params += ';DATA_NOTA@<s:property value="#request.data"/>';

		reportAddress += report + '&PARAMS='+params;

		showPopupGrande(reportAddress);

	}
    
	function abrirNotaFiscal(){

		 var printWin = window.open("data:text/plain;charset=iso-8859-1, ","PopUp", ',status=yes,resizable=no,location=no,scrollbars=no,width=850,height=500, left=200, top=50');
	        printWin.document.open('text/plain', 'replace');
	        printWin.document.write($("div[id='divConteudoNotaFiscal']").text());
	        printWin.document.close();
	        printWin.print();
	        printWin.close();
	    
			showModal('#divNotaHospedagem');
	}


	
    function gravarMiniPDV(){


		vForm = document.forms[0];
		
        vForm.action = '<s:url action="checkout!gravarMiniPDV.action" namespace="/app/contacorrente" />';
        
        submitForm( vForm );

    	

    }

	function incluirMiniPDV(){
		vForm = document.forms[0];
	
	    if ($('#idPrato1').val() == ''){
            alerta ("O campo 'Item' é obrigatório");
            return false;
        }
        
	    if ($('#qtdePrato1').val() == ''){
            alerta ("O campo 'Qtde' é obrigatório");
            return false;
        }

        if ($('#numComanda1').val() == ''){
            alerta ("O campo 'Comanda' é obrigatório");
            return false;
        }

        vForm.idPontoVenda.value = $('#idPontoVenda1').val();
        vForm.idPrato.value = $('#idPrato1').val();
        vForm.qtdePrato.value = $('#qtdePrato1').val();
        vForm.numComanda.value = $('#numComanda1').val();

        vForm.action = '<s:url action="checkout!incluirMiniPDV.action" namespace="/app/contacorrente" />';
        
        submitForm( vForm );
    
		
	}


	function obterValorPrato( idPrato ){

		submitFormAjax('obterValorPrato?idPrato='+idPrato,true);
					
	}

	function excluirMiniPDV( idx ) {
        vForm = document.forms[0];
        if (confirm('Deseja realmente excluir esse lançamento?')){        
            $('#id').val(idx);
        	vForm.action = '<s:url action="checkout!excluirMiniPDV.action" namespace="/app/contacorrente" />';
        	submitForm( vForm );
        }
	}
    
    function cancelarMiniPDV(){
        vForm = document.forms[0];
        vForm.action = '<s:url action="checkout!cancelarMiniPDV.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
    }

    function pesquisarPrato(){

        url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarPrato?idPontoVenda='+$('#idPontoVenda1').val();
		preencherCombo('idPrato1', url);        

    }

    function openMiniPDV( idxCliente, nome ){
    	
        $('#idxCliente').val(idxCliente);
        $('#nomeClienteMiniPDV').html( nome );

        $('#idPrato1').val( $('#idPrato').val() );
        $('#idPontoVenda1').val( $('#idPontoVenda').val() );
        $('#numComanda1').val( $('#numComanda').val() );

        showModal('#divMiniPDV');
    }
    
    function liberarHospede( idx ){
        vForm = document.forms[0];
        var grupoBoby = $('div.divMovCheckoutBody')[idx];
        var itensBody = $(grupoBoby).sortable('toArray');
        if ( itensBody != null &&  itensBody.length > 0){
            alerta('Efetue os pagamentos antes de liberar');
            return false;
        }
                
        if (confirm('Deseja realmente liberar este hóspede?')){        
            $('#idxCliente').val(idx);
            vForm.action = '<s:url action="checkout!liberarHospede.action" namespace="/app/contacorrente" />';
            submitForm( vForm );
        }
    }    


    function liberarHospedePrincipal( idx ){
        $('#idxCliente').val(idx);
        showModal('#divHospedePrincipal');
    }

    function liberarHospedePrincipalPopup(){
    	if ($('#idNovoHospede').val() == '' || $('#idNovoHospede').val() == null){
			alerta("O campo 'Nome' é obrigatório.");
			return false;
        }
    	$('#idNovoRoomListPrincipal').val($('#idNovoHospede').val());
    	liberarHospede( $('#idxCliente').val() );
    }
    
    function liberarCheckin(){
        vForm = document.forms[0];
    
        if ($('input.chkValue').length > 0){
            alerta("Você deve realizar os pagamentos, antes de liberar o apartamento");
            return false;
        }        

        vForm.action = '<s:url action="checkout!liberarApartamento.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
    }

    function incluirMovimentoDevolucao( idxDevolucao ){
        vForm = document.forms[0];
        newValue = false;
        valor = "";
        total = $("div[id='divObj"+$('#idxCliente').val()+"'] input:checkbox").length;
         for (chk=0; chk < total; chk++){
            if ($("div[id='divObj"+$('#idxCliente').val()+"'] input:checkbox")[chk].checked){
                newValue = true;
                valor += ($("div[id='divObj"+$('#idxCliente').val()+"'] input:checkbox")[chk].value + ";");
                break;
            }
         }
        if (!newValue ){
            alerta("Selecione pelo menos um objetos para ser pago.");
            return false;
        }   
		
        var tipoLanc = $('#idTipoLancamento3'+idxDevolucao);
		tipoLancTexto = $('#idTipoLancamento3'+idxDevolucao+' option:selected').text();
        idTipoLanc = tipoLanc.val();
		
		idTipoDiaria = $('#idTipoDiaria3'+idxDevolucao).val();
		valorLanc = $('#valorLancamento3'+idxDevolucao).val();
		numDoc = $('#numDocumento3'+idxDevolucao).val();
        if (idTipoLanc == ''){
            alerta ("O campo 'Despesa' é obrigatório");
            return false;
        }
        if ($('#numDocumento3').val() == ''){

        }
        if (valorLanc == ''){
            alerta ("O campo 'Valor' é obrigatório");
            return false;
        }
        
        		
        if (tipoLancTexto.indexOf('DIARIA') == 0 ){

            if (idTipoDiaria == ''){
                alerta ("O campo 'Tipo diária' é obrigatório");
                return false;
            }
        }

        vForm.idTipoLancamento.value = idTipoLanc;
        vForm.numDocumento.value = numDoc;
        vForm.valorLancamento.value = valorLanc;
        vForm.idTipoDiaria.value = idTipoDiaria;
        vForm.idMovimentoObjeto.value= valor;
        vForm.action = '<s:url action="checkout!incluirMovimentoDevolucao.action" namespace="/app/contacorrente" />';
        killModal();
        submitForm( vForm );
    }
    function incluirDevolucao(){
        vForm = document.forms[0];
        newValue = false;
        valor = "";
        total = $("div[id='divObj"+$('#idxCliente').val()+"'] input:checkbox").length;
         for (chk=0; chk < total; chk++){
            if ($("div[id='divObj"+$('#idxCliente').val()+"'] input:checkbox")[chk].checked){
                newValue = true;
                valor += ($("div[id='divObj"+$('#idxCliente').val()+"'] input:checkbox")[chk].value + ";");
                break;
            }
         }
        if (!newValue ){
            alerta("Selecione pelo menos um objetos para ser devolvido.");
            return false;
        }   
        
        vForm.idMovimentoObjeto.value= valor;
        vForm.action = '<s:url action="checkout!devolverObjetos.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
    }
    
    function openDevolucao(idxCliente){
        vForm = document.forms[0];
        $('#idxCliente').val(idxCliente);
        showModal('#divDevolucao'+idxCliente);
    }

    function informarMotivo(){
        alerta('Você deve informar um motivo para o cancelamento da nota.');
        $('#divGrupoPagamento').css('display','none');
        $('#divGrupoCancelamento').css('display','block');
    }
    
    
    function desistirCancelamentoNota(){
        $('#divGrupoCancelamento').css('display','none');
        $('#divGrupoPagamento').css('display','block');
    }
    
    function gravarCancelamentoNota(){
    
        vForm = document.forms[0];
        
        if ( $('#motivoCancelamentoNota1').val() == '' ){
            alerta("O campo 'Motivo' é obrigatório.");
            return false;
        }    


		<s:if test="%{#session.notaHospedagem.tipoNotaFiscal == \"CF\"}">
			try{
				aCupomFiscal = document.appletCupomFiscal;
				aCupomFiscal.cancelaCupomFiscal();
			}catch(err){
				alert("Erro ao cancelar cupom:" + err.description);
				return false;	
			}
		</s:if>
        
        vForm.motivoCancelamentoNota.value = $('#motivoCancelamentoNota1').val();
        vForm.action = '<s:url action="checkout!cancelarNotaHospedagem.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
    
    }

    function imprimeNotaFiscal(){

    	submitFormAjax('obterProximaNotaFiscal',true);
        $('#divGrupoPagamento').css('display','none');
        $('#divGrupoNotaFiscal').css('display','block');
    }

    function gerarNotaFiscal(){

    	if ( $('#numNotaFiscal1').val() == '' ){
            alerta("O campo 'Nº nota' é obrigatório.");
            return false;
        }
    	if ( $('#serieNotaFiscal1').val() == '' ){
            alerta("O campo 'Série' é obrigatório.");
            return false;
        }
        vForm = document.forms[0];
        vForm.numNotaFiscal.value = $('#numNotaFiscal1').val();
        vForm.serieNotaFiscal.value = $('#serieNotaFiscal1').val();
        vForm.subSerieNotaFiscal.value = $('#subSerieNotaFiscal1').val();
        vForm.action = '<s:url action="checkout!prepararNotaFiscal.action" namespace="/app/contacorrente" />';
        submitForm( vForm );

    }
    
    function imprimeNotaHospedagem(){
    
        vForm = document.forms[0];
        vForm.action = '<s:url action="checkout!prepararNotaHospedagem.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
    }

    function gravarAlteracoes(){
    
        vForm = document.forms[0];
        vForm.action = '<s:url action="checkout!gravarSincronizacao.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
    }

    function refresh(){
        window.location.href= '<%=session.getAttribute("URL_BASE")%>pages/modulo/checkout/manterCheckout.jsp';
    }

    function gravarCheckout(){
    
        if ( $('#valorPagamento').val() != $('#valorAdicionado').val() ){
            alerta('Não pode restar diferença para realizar o Fechamento.');
            return false;
        }
    
        vForm = document.forms[0];
        vForm.action = '<s:url action="checkout!gravarCheckoutContaCorrente.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
    }

    function realizarCheckout(idxCliente){
        vForm = document.forms[0];
        if ( $('.movimentosParcial').get(idxCliente).value == ''){
            alerta('Selecione pelo menos um lancamento para realizar o pagamento.');
            return false;
        }

        $('#idxCliente').val(idxCliente);
        vForm.action = '<s:url action="checkout!prepararPopCheckout.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
    }

    function imprimirExtrato(idxCliente){
        vForm = document.forms[0];
        $('#idxCliente').val(idxCliente);
        vForm.action = '<s:url action="checkout!imprimirExtrato.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
    }

    function excluirPagamento(idxPagamento){
        if (confirm('Confirma a exclusão do pagamento?')){
            vForm = document.forms[0];
            $('#id').val(idxPagamento);
            vForm.action = '<s:url action="checkout!excluirPagamentoCheckout.action" namespace="/app/contacorrente" />';
            submitForm( vForm );
        }
    }


    function incluirPagamento(){

        
        if ($('#idTipoLancamento2').val() == ''){
            alerta ("O campo 'Forma PGTO' é obrigatório");
            return false;
        }
        if ($('#numDocumento2').val() == ''){

        }
        if ($('#valorLancamento2').val() == ''){
            alerta ("O campo 'Valor' é obrigatório");
            return false;
        }
        
        
        var pag = document.getElementById('idTipoLancamento2');
        var texto = pag.options[pag.selectedIndex].text;
        if (texto == 'VISA' || texto == 'AMEX' || texto == 'CREDICARD' || texto == 'DINERS' || texto == 'MASTERCARD'){
        
            if ($('#numCartao').val() == ''){
                //alerta ("O campo 'Num Cartão' é obrigatório");
                //return false;
            }
            
            if ($('#validadeCartao').val() == ''){
                //alerta ("O campo 'Validade' é obrigatório");
                //return false;
            }
            
            if ($('#codigoSegurancaCartao').val() == ''){
                //alerta ("O campo 'Código' é obrigatório");
                //return false;
            }

        }
        if (texto == 'VISA WEB' || texto == 'AMEX WEB' || texto == 'CREDICARD WEB' || texto == 'DINERS WEB' || texto == 'MASTERCARD WEB'){

        	if ($('#nomeClienteCartao').val() == ''){
                alerta ("O campo 'Nome do Cliente' é obrigatório");
                return false;
            }
        	if ($('#numCartao').val() == ''){
                alerta ("O campo 'Num Cartão' é obrigatório");
                return false;
            }
            
            if ($('#validadeCartao').val() == ''){
                alerta ("O campo 'Validade' é obrigatório");
                return false;
            }
            
            if ($('#codigoSegurancaCartao').val() == ''){
                alerta ("O campo 'Código' é obrigatório");
                return false;
            }

            if (confirm('Esta operação realizará uma transação on-line no cartão do cliente. Confirma?')){
		        vForm = document.forms[0];
		        vForm.idTipoLancamento.value = $('#idTipoLancamento2').val();
		        vForm.numDocumento.value = $('#numDocumento2').val();
		        vForm.valorLancamento.value = $('#valorLancamento2').val();
		        vForm.numCartao.value = $('#numCartao').val();
		        vForm.validadeCartao.value = $('#validadeCartao').val();
		        vForm.codigoSegurancaCartao.value = $('#codigoSegurancaCartao').val();
		        vForm.nomeClienteCartao.value = $('#nomeClienteCartao').val();
		        vForm.action = '<s:url action="checkout!adicionarPagamentoCheckout.action" namespace="/app/contacorrente" />';
		        submitForm( vForm );
            }

        }else{
	        vForm = document.forms[0];
	        vForm.idTipoLancamento.value = $('#idTipoLancamento2').val();
	        vForm.numDocumento.value = $('#numDocumento2').val();
	        vForm.valorLancamento.value = $('#valorLancamento2').val();
	        vForm.numCartao.value = $('#numCartao').val();
	        vForm.validadeCartao.value = $('#validadeCartao').val();
	        vForm.codigoSegurancaCartao.value = $('#codigoSegurancaCartao').val();
	        vForm.action = '<s:url action="checkout!adicionarPagamentoCheckout.action" namespace="/app/contacorrente" />';
	        submitForm( vForm );
        }
    }
    
    
    function openCheckout(){
        showModal('#divCheckout');
    }

    function openLancamento(idxCliente, nomeCliente){
        $('#nomeClienteTipoLancamento').text(nomeCliente);
        $('#idxCliente').val(idxCliente);
        showModal('#divLancamento');
    }

    function openObs(){
        showModal('#divObs');
    }

    function openExtrato(){
    	showModal('#divExtrato');
    }
    
    function openNotaHospedagem(){
        showModal('#divNotaHospedagem');

    }

    function incluirMovimento(){
        vForm = document.forms[0];
        
        if ($('#idTipoLancamento1').val() == ''){
            alerta ("O campo 'Despesa' é obrigatório");
            return false;
        }
        if ($('#numDocumento1').val() == ''){

        }
        if ($('#valorLancamento1').val() == ''){
            alerta("O campo 'Valor' é obrigatório");
            return false;
        }
        
        var tipoLanc = document.getElementById('idTipoLancamento1');
        if (tipoLanc.options[tipoLanc.selectedIndex].text.indexOf('DIARIA') == 0 ){
            if ($('#idTipoDiaria1').val() == ''){
                alerta("O campo 'Tipo diária' é obrigatório");
                return false;
            }
        }

        vForm.idTipoLancamento.value = $('#idTipoLancamento1').val();
        vForm.numDocumento.value = $('#numDocumento1').val();
        vForm.valorLancamento.value = $('#valorLancamento1').val();
        vForm.idTipoDiaria.value = $('#idTipoDiaria1').val();
        vForm.action = '<s:url action="checkout!incluirMovimento.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
    }


    function caixaGeral(){
            vForm = document.forms[0];
            vForm.action = '<s:url action="pesquisar!prepararLancamento.action" namespace="/app/contacorrente" />';

            submitForm( vForm );
    }
    
    function printExtrato( divBody ){
    
        var printWin = window.open("","PopUp", ',status=yes,resizable=no,location=no,scrollbars=no,width=850,height=500, left=200, top=50');
        printWin.document.open();
        printWin.document.write($("div[id='"+divBody+"']").html());
        printWin.document.close();
        printWin.print();
        printWin.close();

    }


    function gerarReciboPagamento(){
        showModal('#divReciboPagamento');
    } 

	function openSubstituirHospede(idxCliente, nome){

		vForm = document.forms[0];
        var grupoBoby = $('div.divMovCheckoutBody')[idxCliente];
        var itensBody = $(grupoBoby).sortable('toArray');
        if ( itensBody != null &&  itensBody.length > 0){
            alerta('Efetue os pagamentos antes de substituir');
            return false;
        }
        
	    $('#idxCliente').val(idxCliente);
        $('#nomeClienteSubstituirHospede').html( nome );
        showModal('#divSubstituirHospede');
	}

    
    function getHospedeLookup(elemento){
        url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarHospede?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idHospedeNovo';
        getDataLookup(elemento, url,'Hospedes','TABLE');
    }

    function substituirHospedeNovo(){

		

        if ($('#idxCliente').val() == ''){
            alerta ("O campo 'De' é obrigatório");
            return false;
        }

        
        if ($('#nomeHospedeNovo').val() == '' && $('#idHospedeNovo').val() == ''){
            alerta ("Você deve consultar ou criar um novo hóspede");
            return false;
        }

        if ($('#idHospedeNovo').val() == ''){

    	  	  if ($('input[name=nomeHospedeNovo]').val() == ''){
		            alerta ("O campo 'Nome' é obrigatório");
		            return false;
		      }
      	  	  if ($('input[name=sobrenomeHospedeNovo]').val() == ''){
		            alerta ("O campo 'Sobrenome' é obrigatório");
		            return false;
		      }
            
        }
        
        <s:if test="%{#session.checkinCorrente.calculaSeguro == \"S\"}">
        	if ($('#idHospedeNovo').val() == ''){
		        if ($('input[name=cpfHospedeNovo]').val() == '' && $('input[name=passaporteHospedeNovo]').val() == ''){
		            alerta ("O campo 'CPF' ou 'Passaporte' é obrigatório");
		            return false;
		        }
		        if ($('input[name=dataNascimentoHospedeNovo]').val() == ''){
		            alerta ("O campo 'Dt. Nasc.' é obrigatório");
		            return false;
		        }
		        
		        if ($('input[name=cpfHospedeNovo]').val() != ''){
		            if (!validarCPF($('input[name=cpfHospedeNovo]').val())){
		                alerta ("O campo 'CPF' é inválido");
		                return false;
		            }
		        }
		        
		        if ($('input[name=emailHospedeNovo]').val() == ''){
		            alerta ("O campo 'E-mail' é obrigatório");
		            return false;
		        }
		        
		        if ($('input[name=emailHospedeNovo]').val() != ''){
		            if (!validarEmail($('input[name=emailHospedeNovo]').val())){
		                alerta ("O campo 'E-mail' é inválido");
		                return false;
		            }
		        }
		        if ($('#sexoHospedeNovo').val() == ''){
		            alerta ("O campo 'Sexo' é obrigatório");
		            return false;
		        }
        	}
    	</s:if>


        if (confirm('Confirma a substituição do hóspede?')){
        	vForm = document.forms[0];
            $('input[name="idNovoHospedeSubstituicao.nomeHospede"]').val( $('input[name=nomeHospedeNovo]').val() );
		    $('input[name="idNovoHospedeSubstituicao.sobrenomeHospede"]').val( $('input[name=sobrenomeHospedeNovo]').val() );
		    $('input[name="idNovoHospedeSubstituicao.cpf"]').val( $('input[name=cpfHospedeNovo]').val() );
		    $('input[name="idNovoHospedeSubstituicao.passaporte"]').val( $('input[name=passaporteHospedeNovo]').val() );
		    $('input[name="idNovoHospedeSubstituicao.nascimento"]').val( $('input[name=dataNascimentoHospedeNovo]').val() );
		    $('input[name="idNovoHospedeSubstituicao.email"]').val( $('input[name=emailHospedeNovo]').val() );
		    $('input[name="idNovoHospedeSubstituicao.sexo"]').val( $('#sexoHospedeNovo').val() );

		    $('input[name="idNovoHospedeSubstituicao.idHospede"]').val( $('#idHospedeNovo').val() );
	        vForm.action = '<s:url action="checkout!substituirHospede.action" namespace="/app/caixa" />';
	        submitForm( vForm );
        }

    }
    
$(document).ready(
	function()
	{
            $("#idTipoLancamento1").change(
                    function()
                    {
                            if (this.options[this.selectedIndex].text.indexOf('DIARIA') == 0 ){
                                $('#divLinhaTipoDiaria').css("display","block");
                            
                            }else{
                                $('#divLinhaTipoDiaria').css("display","none");
                                $("#idTipoDiaria1").val("");
                            }
                            
                        
                    }
            );
            
            $(".idTipoLancamento3").change(
                    function(){
							idx = this.id.charAt(this.id.length -1);							
                            if (this.options[this.selectedIndex].text.indexOf('DIARIA') == 0 ){
                                $('#linhaTipoDiariaDevolucao'+idx).css("display","block");                            
                            }else{
                                $('#linhaTipoDiariaDevolucao'+idx).css("display","none");
                                $("#idTipoDiaria3"+idx).val("");
                            }
                    }
            );
            

            $("#idTipoLancamento2").change(
                    function(){
                            var texto = this.options[this.selectedIndex].text;
                            
                            if (texto == 'VISA WEB' || texto == 'AMEX WEB' || texto == 'CREDICARD WEB' || texto == 'DINERS WEB' || texto == 'MASTERCARD WEB'){
                                $('#divDadosCartao').css("display","block");
                            
                            }else{
                                $('#divDadosCartao').css("display","none");
                            }
                            $("#validadeCartao").val("");
                            $("#numCartao").val("");
                            $("#codigoSegurancaCartao").val("");
                            $("#nomeClienteCartao").val("");

                    }
            );

            
	}
)

</script>

<!--Div applet cupom fiscal-->
<div id="divApplet" style="position: absolute; margin-left: 850px;float:right;margin-top:30px;display:<s:property value="#session.HOTEL_SESSION.cupomfiscal == \"S\"?\"block\":\"none\" " />;">
<applet name="appletCupomFiscal" id="appletCupomFiscal" 
		code = 'com.mozart.applet.CupomFiscal' 
        archive = '<s:url value="/applet/sMozartHotelTelefonia.jar" />',
        width = '1', 
        height = '1'
        style="display:<s:property value="#session.HOTEL_SESSION.cupomfiscal == \"S\"?\"block\":\"none\" " />;" >
        <param name="TIPO_EXECUCAO" value="2"/>
</applet>
</div>
<!--Div applet cupom fiscal-->


<!--Div substituir hóspede-->
<div id="divSubstituirHospede" class="divCadastro" style="display: none; height: 350px; width: 600px;">

<div class="divGrupo" style="width: 98%; height: 220px">
<div class="divGrupoTitulo">Substituir hóspede</div>
<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 400pt; color: red">
<p style="width: 100px;">De:</p>
<label id="nomeClienteSubstituirHospede">Nome do Cliente</label></div>
</div>

<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 310pt;">
	<p style="width: 100px;">Para:</p>
	<input type="text" name="nomeHospedeNovoLookup" id="nomeHospedeNovoLookup" size="50" maxlength="50" onblur="getHospedeLookup(this)" /> 
	<input type="hidden" name="idHospedeNovo" id="idHospedeNovo" />
	<input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"  />
	</div>
</div>

<div class="divLinhaCadastro" style="border:0px; background-color:white;">
	<div class="divItemGrupo" style="color: blue">
		<label>ou criar um novo hóspede...</label>
	</div>
</div>

<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 200pt;">
<p style="width: 60px;">Nome:</p>
<input type="text" name="nomeHospedeNovo" id="nomeHospedeNovo" maxlength="50" size="30" onblur="toUpperCase(this)" /></div>
<div class="divItemGrupo" style="width: 200pt;">
<p style="width: 75px;">Sobrenome:</p>
<input type="text" name="sobrenomeHospedeNovo" id="sobrenomeHospedeNovo" maxlength="50" size="30" onblur="toUpperCase(this);" /></div>
</div>

<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 200pt;">
<p style="width: 60px;">CPF:</p>
<input type="text" name="cpfHospedeNovo" id="cpfHospedeNovo" maxlength="11" size="15" onkeypress="mascara(this, numeros)" onblur="validarCPF(this.value)" /></div>
<div class="divItemGrupo" style="width: 200pt;">
<p style="width: 75px;">Passaporte:</p>
<input type="text" name="passaporteHospedeNovo" id="passaporteHospedeNovo" maxlength="50" size="15"  /></div>
</div>

<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 200pt;">
<p style="width: 60px;">Dt. Nasc.:</p>
<input type="text" name="dataNascimentoHospedeNovo" id="dataNascimentoHospedeNovo" maxlength="10" size="15" onkeypress="mascara(this, data)" />
</div>
<div class="divItemGrupo" style="width: 200pt;">
<p style="width: 75px;">E-mail.:</p>
<input type="text" name="emailHospedeNovo" id="emailHospedeNovo" maxlength="200" size="30" /></div>

</div>

<div class="divLinhaCadastro">
<div class="divItemGrupo">
<p style="width: 60px;">Sexo:</p>
<select id="sexoHospedeNovo" name="sexoHospedeNovo" style="width:100px;">
<option value="" selected="selected">Selecione</option>
<option value="F">Feminino</option>
<option value="M">Masculino</option>
</select>
</div>
</div>

</div>

<div class="divCadastroBotoes" style="width: 98%;">
	<duques:botao label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="killModal()" />
	<duques:botao label="Substituir hóspede" style="width:170px;" imagem="imagens/iconic/png/peopleReload-3x.png" onClick="substituirHospedeNovo()" />
</div>

</div>
<!--final substituir hóspede-->

<!--Div divHospedePrincipal-->
<div id="divHospedePrincipal" class="divCadastro"
	style="display: none; height: 220px; width: 600px;">

<div class="divGrupo" style="width: 98%; height: 150px">
<div class="divGrupoTitulo">Novo hóspede principal</div>
<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 350px;">
<p style="width: 80px;">Nome:</p>
<select name="idNovoHospede" id="idNovoHospede" style="width: 250px;">
</select></div>
</div>
</div>
<div class="divCadastroBotoes" style="width: 98%;"><duques:botao
	label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="killModal();" />
<duques:botao label="Liberar" imagem="imagens/iconic/png/arrow-thick-bottom-3x.png"
	onClick="liberarHospedePrincipalPopup()" /></div>
</div>
<!--final Div divHospedePrincipal-->


<!--Div obs-->
<div id="divObs" class="divCadastro"
	style="display: none; height: 220px; width: 600px;">

<div class="divGrupo" style="width: 98%; height: 150px">
<div class="divGrupoTitulo">Observações</div>
<div class="divLinhaCadastro"  style="height:50px;">
<div class="divItemGrupo" style="width: 100%;">
<p style="width: 100px;">Checkin:</p>
<s:property value="#session.checkinCorrente.observacao" /></div>
</div>
<div class="divLinhaCadastro" style="height:50px;">
<div class="divItemGrupo" style="width: 100%;">
<p style="width: 100px;">Reserva:</p>
<s:property value="#session.checkinCorrente.reservaEJB.observacao" /></div>
</div>
</div>

<div class="divCadastroBotoes" style="width: 98%;"><duques:botao
	label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="$.modal.close()" />
</div>
</div>
<!--final Div obs-->


<!--Div lancamento-->
<div id="divLancamento" class="divCadastro"
	style="display: none; height: 220px; width: 600px;">

<div class="divGrupo" style="width: 98%; height: 150px">
<div class="divGrupoTitulo">Lançamento de despesas</div>
<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 400pt; color: red">
<p style="width: 100px;">Cliente:</p>
<label id="nomeClienteTipoLancamento">Nome do Cliente</label></div>
</div>
<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 310pt;">
<p style="width: 100px;">Despesa:</p>
<s:select list="#session.tipoLancamentoList" cssStyle="width:180px"
	headerKey="" headerValue="Selecione" listKey="idTipoLancamento"
	listValue="descricaoLancamento" name="idTipoLancamento1"
	id="idTipoLancamento1" /></div>
</div>
<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 210pt;">
<p style="width: 100px;">Nº documento:</p>
<input name="numDocumento1" id="numDocumento1" type="text" size="15"
	onblur="toUpperCase(this)" maxlength="50" /></div>
</div>
<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 210pt;">
<p style="width: 100px;">Valor:</p>
<input name="valorLancamento1" id="valorLancamento1"
	onkeypress="mascara(this, moeda)" type="text" size="15" maxlength="10" />
</div>
</div>
<div class="divLinhaCadastro" id="divLinhaTipoDiaria"
	style="display: none">
<div class="divItemGrupo" style="width: 310pt;">
<p style="width: 100px;">Tipo diária:</p>
<s:select list="#session.tipoDiariaList" cssStyle="width:180px"
	listKey="idTipoDiaria" listValue="descricao" headerKey=""
	headerValue="Selecione" name="idTipoDiaria1" id="idTipoDiaria1" /></div>
</div>
</div>

<div class="divCadastroBotoes" style="width: 98%;"><duques:botao
	label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="$.modal.close()" />
<duques:botao label="Adicionar" style="width:120px;"
	imagem="imagens/iconic/png/plus-3x.png" onClick="incluirMovimento()" /></div>
</div>
<!--final Div lancamento-->



<s:form action="checkout.action" theme="simple" namespace="/app/caixa">
	<input type="hidden" name="id" id="id" />
	<input type="hidden" name="classe" id="classe" />



	<s:hidden name="idxCliente" id="idxCliente" />
	<s:hidden name="idTipoLancamento" id="idTipoLancamento" />
	<s:hidden name="numDocumento" id="numDocumento" />
	<s:hidden name="valorLancamento" id="valorLancamento" />
	<s:hidden name="idTipoDiaria" id="idTipoDiaria" />

	<s:hidden name="valorPagamento" id="valorPagamento" />
	<s:hidden name="valorAdicionado" id="valorAdicionado" />
	<s:hidden name="motivoCancelamentoNota" id="motivoCancelamentoNota" />
	<s:hidden name="idMovimentoObjeto" id="idMovimentoObjeto" />

	<s:hidden name="numCartao" />
	<s:hidden name="validadeCartao" />
	<s:hidden name="codigoSegurancaCartao" />
	<s:hidden name="nomeClienteCartao" />


	<!-- INICIO Da notafiscal -->
	<s:hidden name="numNotaFiscal" id="numNotaFiscal" />
	<s:hidden name="serieNotaFiscal" id="serieNotaFiscal" />
	<s:hidden name="subSerieNotaFiscal" id="subSerieNotaFiscal" />
	<!-- liberar hospede principal -->
	<s:hidden name="idNovoRoomListPrincipal" id="idNovoRoomListPrincipal" />
	<!-- substituicao de hospedes -->
	<s:hidden name="idNovoHospedeSubstituicao.idHospede"  />
	<s:hidden name="idNovoHospedeSubstituicao.nomeHospede"  />
	<s:hidden name="idNovoHospedeSubstituicao.sobrenomeHospede"  />
	<s:hidden name="idNovoHospedeSubstituicao.cpf"  />
	<s:hidden name="idNovoHospedeSubstituicao.passaporte"  />
	<s:hidden name="idNovoHospedeSubstituicao.nascimento"  />
	<s:hidden name="idNovoHospedeSubstituicao.email"  />
	<s:hidden name="idNovoHospedeSubstituicao.sexo"  />



	<!-- INICIO DO MINI PDV -->

	<s:hidden name="idPontoVenda" id="idPontoVenda" />
	<s:hidden name="numComanda" id="numComanda" />
	<s:hidden name="idPrato" id="idxCliente" />

	<s:hidden name="qtdePrato" id="qtdePrato" />
	<s:hidden name="valorPrato" id="valorPrato" />

	<div id="divMiniPDV" class="divCadastro"
		style="display: none; height: 450px; width: 800px;">

	<div class="divGrupo" id="divMiniPDV"
		style="width: 790px; height: 350px">
	<div class="divGrupoTitulo">Mini-PDV</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 300px;">
	<p style="width: 100px;">Cliente:</p>
	<div id="nomeClienteMiniPDV" style="color: red;"></div>
	</div>
	</div>
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 300px;">
	<p style="width: 100px;">Ponto de venda:</p>
	<s:select list="#session.listaPDV" cssStyle="width:180px" headerKey=""
		headerValue="Selecione" listKey="id.idPontoVenda"
		listValue="nomePontoVenda" name="idPontoVenda1" id="idPontoVenda1"
		onchange="pesquisarPrato()" /></div>

	<div class="divItemGrupo" style="width: 200px;">
	<p style="width: 70px;">Comanda:</p>
	<s:textfield name="numComanda1" maxLength="10" size="10"
		id="numComanda1" /></div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 300px;">
	<p style="width: 100px;">Item:</p>

	<select name="idPrato1" id="idPrato1" style="width: 180px"
		onchange="obterValorPrato(this.value)">
		<option value="">Selecione</option>
		<s:iterator value="#session.pratoPDVList" status="row">
			<option value='<s:property value="pratoEJB.id.idPrato" />'><s:property
				value="pratoEJB.nomePrato" /></option>
		</s:iterator>
	</select></div>

	<div class="divItemGrupo" style="width: 150px;">
	<p style="width: 70px;">Valor:</p>
	<input type="text" name="valor1" id="valor1" size="7" maxLength="10"
		onkeypress="mascara(this, moeda)" readonly="readonly" /></div>

	<div class="divItemGrupo" style="width: 130px;">
	<p style="width: 60px;">Qtde:</p>
	<input type="text" name="qtdePrato1" id="qtdePrato1" size="4"
		maxLength="5" onkeypress="mascara(this, moeda)" /></div>

	<div class="divItemGrupo" style="width: 140px;">
	<p style="width: 60px;">Total:</p>
	<input type="text" name="valorPrato1" id="valorPrato1" size="7"
		maxLength="10" onkeypress="mascara(this, moeda)" /></div>

	<div class="divItemGrupo" style="width: 30px; text-align: center;">
	<img width="24px" height="24px" src="imagens/iconic/png/plus-3x.png"
		title="Incluir" onclick="incluirMiniPDV()" /></div>

	</div>

	<div style="width: 99%; height: 200px; overflow-y: auto;"><s:iterator
		value="#session.movimentoMiniPDVList" status="row">
		<div class="divLinhaCadastro" style="background_color: white;">
		<div class="divItemGrupo" style="width: 300px;">
		<p style="width: 100%;"><s:property value="pratoEJB.nomePrato" /></p>
		</div>
		<div class="divItemGrupo" style="width: 150px;">
		<p style="width: 100%; text-align: right;"><s:property
			value="valorTotal" /></p>
		</div>
		<div class="divItemGrupo" style="width: 130px;">
		<p style="width: 100%; text-align: right;"><s:property
			value="quantidade" /></p>
		</div>

		<div class="divItemGrupo" style="width: 140px;">
		<p style="width: 100%; text-align: right;"><s:property
			value="valorTotal" /></p>
		</div>
		<div class="divItemGrupo" style="width: 30px; text-align: center;">
		<img width="24px" height="24px" src="imagens/iconic/png/x-3x.png"
			title="Excluir" onclick="excluirMiniPDV('${row.index}')" /></div>
		</div>

	</s:iterator></div>


	</div>

	<div class="divCadastroBotoes" style="width: 97%;"><duques:botao
		label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
		onClick="cancelarMiniPDV()" /> <duques:botao label="Salvar"
		imagem="imagens/iconic/png/plus-3x.png" onClick="gravarMiniPDV()" /></div>
	</div>

	<!-- FIM DO MINI PDV -->
	<input type="hidden" id="taxaCheckout" name="taxaCheckout" value='<s:property value="#session.HOTEL_SESSION.taxaCheckout" />' />
	
	<input type="hidden" id="taxaCheckin" name="taxaCheckin" value='<s:property value="#session.checkinCorrente.calculaTaxa" />' />
	<input type="hidden" id="issCheckin" name="issCheckin" value='<s:property value="#session.checkinCorrente.calculaIss" />' />
	
	<input type="hidden" id="issHotel" name="issHotel" value='<s:property value="#session.HOTEL_SESSION.iss.doubleValue().toString()" />' />
	<input type="hidden" id="taxaHotel" name="taxaHotel" value='<s:property value="#session.HOTEL_SESSION.taxaServico.doubleValue().toString()" />' />
	
	<div class="divFiltroPaiTop" style="width: 220px;">Lançar / Fechar</div>
	<div class="divFiltroPai">

	<div class="divCadastro" style="overflow: auto;">
	<div class="divGrupo" style="height: 440px;">
	<div class="divGrupoTitulo">Movimento</div>
	<div class="divLinhaCadastro">
		<div class="divItemGrupo">
		<p style="width: 100px;">Conta:</p>
		<b><font color="red"><s:property
			value="#session.checkinCorrente.apartamentoEJB.numApartamento" /> </font></b>
		</div>
	</div>
	<!-- Inicio do div da empresa e hóspede -->
	<div class="divLinhaCadastro" style="height:370px; overflow-x:auto;" >
	<div style="height:100%; width: <s:property value="#session.checkinCorrente.roomListEJBList.size()>3?150:100"/>%;" >
	<s:hidden cssClass="movimentos" name="movimentos" id="movimentos" /> 
	<s:hidden cssClass="movimentosParcial" name="movimentosParcial" id="movimentosParcial" />

	<div class="divMovCheckout">
	<s:if test="%{#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.credito == \"S\"}">
		<h1 style="background-color: #0C3">
			<img width="16px" height="16px" src='imagens/btnComCredito.png' title='Com crédito' />
			<s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia.length()>15?#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia.substring(0,15)+\"...\":#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia" />
		</h1>
	</s:if>
	<s:elseif test="%{#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.credito == \"N\"}">
		<h1 style="background-color: #F00">
			<img width="16px" height="16px" src='imagens/btnSemCredito.png' title='Sem crédito'/>
			<s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia.length()>15?#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia.substring(0,15)+\"...\":#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia" />
		</h1>
	</s:elseif>

		
		
	<div class="divMovCheckoutBody"
		id='<s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.empresaEJB.idEmpresa" />'>

	<s:iterator
		value="#session.checkinCorrente.movimentoApartamentoEJBList" var="mov">

		<s:if
			test='%{quemPaga == "E" && checkout=="N" && (movTmp == null || movTmp == "S")}'>
			<!--//colocar na empresa -->
			<s:set name="valorLista" value='%{#mov.valorLancamento.doubleValue()}' />

			<div
				id='<s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.empresaEJB.idEmpresa" />;<s:property value="#mov.idMovimentoApartamento"/>;<s:property value="%{#valorLista.toString()}"/>;<s:property value="#mov.tipoLancamentoEJB.iss"/>;<s:property value="#mov.tipoLancamentoEJB.taxaServico"/>;'
				class="divMovCheckoutBodyItem" style="font-size: 8pt">

			<p style="top: 0px; margin: 0px; padding: 0px; float: left;"><input
				type="checkbox" class="chkValue" /> <s:property
				value="#mov.dataLancamento.toString().substring(8,10)" />/<s:property
				value="#mov.dataLancamento.toString().substring(5,7)" /> <s:property
				value="#mov.tipoLancamentoEJB.descricaoLancamento.length()>=5?#mov.tipoLancamentoEJB.descricaoLancamento.substring(0,5):#mov.tipoLancamentoEJB.descricaoLancamento" />
			</p>
			<s:if test='%{#mov.tipoLancamentoEJB.debitoCredito =="C"}'>
				<p style="top: 0px; margin: 0px; padding: 0px; float: right;"><s:property
					value="valorLancamento" /></p>
			</s:if> <s:else>
				<p style="top: 0px; margin: 0px; padding: 0px; float: right;"><s:property
					value="valorLancamento" /></p>
			</s:else></div>

		</s:if>
	</s:iterator></div>

	<div class="divMovCheckoutFoot">
	<ul>
		<li style="text-align: left;"><input type="checkbox"
			class="chkTodos"
			id="chk<s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.empresaEJB.idEmpresa" />" />Selecionar
		todos</li>
		<li
			id='<s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.empresaEJB.idEmpresa" />Total'
			style="color: blue">
		<p style="width: 90px;">Despesa total:</p>
		<label>0</label></li>
		<li
			id='<s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.empresaEJB.idEmpresa" />Parcial'
			style="color: red">
		<p style="width: 90px;">Pgto parcial:</p>
		<label>0,00</label></li>
		<li style="text-align: center; height: 55px;"><img
			src="imagens/iconic/png/plus-3x.png" title="Incluir lançamento"
			onclick="openLancamento('0', '<s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia"/>')" />
		<img src="imagens/iconic/png/print-3x.png" title="Extrato parcial"
			onclick="imprimirExtrato('0');" /> <img
			src="imagens/iconic/png/imgContas-4x.png" title="Realizar pagamento"
			onclick="realizarCheckout('0');" /> <s:if
			test='%{#session.HOTEL_SESSION.miniPdv == "S"}'>
			<img src="imagens/btnPDV.png" title="Mini PDV"
				onclick="openMiniPDV('0', '<s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia"/>');" />
		</s:if></li>
	</ul>
	</div>
	</div>


	<s:if
		test='%{#request.abrirPopupLancamento == "true" && idxCliente == 0}'>
		<script>
                                nomeHospede = '<s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia"/>';
                            </script>
	</s:if> <s:set name="idxRoomList" value="%{-1}" /> 
			<s:set name="idxDevolucao" value="%{0}" />
		<s:iterator
		value="#session.checkinCorrente.roomListEJBList" var="room"
		status="row">
		<s:if
			test='%{chegou == "S" && (dataSaida == null || dataSaida == "")}'>

			<s:set name="idxRoomList" value="%{#idxRoomList+1}" />

			<s:hidden cssClass="movimentos" name="movimentos" id="movimentos" />
			<s:hidden cssClass="movimentosParcial" name="movimentosParcial"
				id="movimentosParcial" />




			<!-- INICIO DEVOLUCAO-->
			<s:set name="possuiDevolucao" value="%{'false'}" />
			<s:if test="%{!movimentoObjetoEJBList.isEmpty()}">
				<s:iterator value="movimentoObjetoEJBList" var="obj1">
					<s:if test="%{#obj1.idMovimentoApartamento == null}">
						<s:set name="possuiDevolucao" value="%{'true'}" />
					</s:if>
				</s:iterator>				
			</s:if>
			<!-- ----------------------------------------------------------- -->
				<div id="divDevolucao${idxRoomList + 1}" class="divCadastro"
					style="display: none; height: 350px; width: 800px;">

				<div class="divGrupo" id="divObj${idxRoomList + 1}"
					style="width: 380px; height: 250px">
				<div class="divGrupoTitulo">Objetos</div>
				<div class="divLinhaCadastro">
				<div class="divItemGrupo" style="width: 200pt; color: red">
				<p style="width: 100px;">Cliente:</p>
				<s:property value="hospede.nomeHospede" /> <s:property
					value="hospede.sobrenomeHospede" /></div>
				</div>
				<s:set name="totalObj" value="%{0}" /> <s:iterator
					value="movimentoObjetoEJBList" var="obj">

					<s:if test="%{#obj.idMovimentoApartamento == null}">						
						<div class="divLinhaCadastro" style="background-color: white;">
						<div class="divItemGrupo" style="width: 150pt;"><input
							id="chkObj${idxRoomList + 1};<s:property value="#obj.idMovimentoObjeto" />;<s:property value="#obj.objetoEJB.valor" />"
							type="checkbox" class="chkObj"
							style="background-color: white; border: 0px;"
							value='<s:property value="%{#obj.idMovimentoObjeto}" />' /> <s:property
							value="#obj.data" />-<s:property value="#obj.objetoEJB.fantasia" />
						</div>
						<div class="divItemGrupo" style="width: 60pt; text-align: right">
						<s:property value="#obj.objetoEJB.valor" /></div>
						</div>
						<s:set name="totalObj" value="%{#totalObj + #obj.objetoEJB.valor}" />
					</s:if>
				</s:iterator>
				<div class="divLinhaCadastro">
				<div class="divItemGrupo" style="width: 150pt;"><input
					id="chk${idxRoomList + 1}" type="checkbox" class="chkObjTodos"
					style="background-color: white; border: 0px;" /> Todos/Total:</div>
				<div class="divItemGrupo"
					style="width: 60pt; color: green; text-align: right; font-weight: bold;">
				<s:property value="%{#totalObj}" /></div>
				</div>

				</div>


				<div class="divGrupo" style="width: 400px; height: 250px">
				<div class="divGrupoTitulo">Lançamento de objeto</div>
				<div class="divLinhaCadastro">
				<div class="divItemGrupo" style="width: 310pt;">
				<p style="width: 100px;">Despesa:</p>
				<select id="idTipoLancamento3${idxDevolucao}" class="idTipoLancamento3" style="width: 180px">
					<option value="">Selecione</option>
					<s:iterator value="#session.tipoLancamentoList" status="row">
						<option value='<s:property value="idTipoLancamento" />'><s:property
							value="descricaoLancamento" /></option>
					</s:iterator>
				</select>	
					
				</div>
				</div>
				<div class="divLinhaCadastro">
				<div class="divItemGrupo" style="width: 210pt;">
				<p style="width: 100px;">Nº documento:</p>
				<input id="numDocumento3${idxDevolucao}" type="text" size="15"
					maxlength="50" /></div>
				</div>
				<div class="divLinhaCadastro">
				<div class="divItemGrupo" style="width: 210pt;">
				<p style="width: 100px;">Valor:</p>
				<input id="valorLancamento3${idxDevolucao}"
					onkeypress="mascara(this, moeda)" type="text" size="15"
					maxlength="10" /></div>
				</div>
				<div class="divLinhaCadastro" id="linhaTipoDiariaDevolucao${idxDevolucao}">
				<div class="divItemGrupo" style="width: 310pt;">
				<p style="width: 100px;">Tipo diária:</p>				
				<select id="idTipoDiaria3${idxDevolucao}" style="width: 180px">
					<option value="">Selecione</option>
					<s:iterator value="#session.tipoDiariaList" status="row">
						<option value='<s:property value="idTipoDiaria" />'><s:property
							value="descricao" /></option>
					</s:iterator>
				</select>	
					
					
					
					</div>
				</div>
				</div>

				<div class="divCadastroBotoes" style="width: 97%;"><duques:botao
					label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="$.modal.close()" /> <duques:botao label="Cobrar"
					style="width:120px;" imagem="imagens/iconic/png/check-2x.png"
					onClick="incluirMovimentoDevolucao('${idxDevolucao}')" /> <duques:botao
					label="Devolução" style="width:120px;"
					imagem="imagens/iconic/png/loop-circular-3x.png" onClick="incluirDevolucao()" /></div>
				</div>
				<s:set name="idxDevolucao" value="%{#idxDevolucao + 1}" />
				<s:if test="%{#possuiDevolucao}">
			</s:if>



			<!-- FIM DEVOLUCAO-->
			<div class="divMovCheckout">
			<h1><s:if test="%{principal == \"S\"}">
				<img width="16px" height="16px" title="Principal"
					src="imagens/iconHospedePrincipal.png" />
			</s:if> <s:property
				value='(hospede.nomeHospede+" "+hospede.sobrenomeHospede).length() > 15 ? (hospede.nomeHospede+" "+hospede.sobrenomeHospede).substring(0,15)+"...":(hospede.nomeHospede+" "+hospede.sobrenomeHospede)' /></h1>
			<div class="divMovCheckoutBody"
				id='<s:property value="idRoomList" />'><s:iterator
				value="movimentoApartamentoEJBList" var="mov">
				<s:if
					test='%{quemPaga == "H" && checkout=="N" && (movTmp == null || movTmp == "S")}'>


					<s:set name="valorLista" value='%{#mov.valorLancamento.doubleValue()}' />

					<div
						id='<s:property value="idRoomList" />;<s:property value="idMovimentoApartamento"/>;<s:property value="%{#valorLista.toString()}"/>;<s:property value="#mov.tipoLancamentoEJB.iss"/>;<s:property value="#mov.tipoLancamentoEJB.taxaServico"/>'
						
						class="divMovCheckoutBodyItem" style="font-size: 8pt">

					<p style="top: 0px; margin: 0px; padding: 0px; float: left;"><input
						type="checkbox" class="chkValue" /> <s:property
						value="dataLancamento.toString().substring(8,10)" />/<s:property
						value="dataLancamento.toString().substring(5,7)" /> <s:property
						value="tipoLancamentoEJB.descricaoLancamento.length()>=5?tipoLancamentoEJB.descricaoLancamento.substring(0,5):tipoLancamentoEJB.descricaoLancamento" />
					</p>
					<s:if test="%{#valorLista < 0}">
						<p style="top: 0px; margin: 0px; padding: 0px; float: right;"><s:property
							value="valorLancamento" /></p>
					</s:if> <s:else>
						<p style="top: 0px; margin: 0px; padding: 0px; float: right;"><s:property
							value="valorLancamento" /></p>
					</s:else></div>
				</s:if>
			</s:iterator></div>

			<div class="divMovCheckoutFoot">
			<ul>
				<li style="text-align: left;"><input type="checkbox"
					class="chkTodos" id="chk<s:property value="idRoomList" />" />Selecionar
				todos</li>
				<li id='<s:property value="idRoomList" />Total' style="color: blue">
				<p style="width: 90px;">Despesa total:</p>
				<label>0</label></li>
				<li id='<s:property value="idRoomList" />Parcial' style="color: red">
				<p style="width: 90px;">Pgto parcial:</p>
				<label>0,00</label></li>
				<li style="text-align: center; height: 55px;">
				<s:if test='%{#possuiDevolucao == "false"}'>
					<img src="imagens/btnInformacaoCinza.png"
						title="Nenhum objeto pendente" style="cursor: auto" />
				</s:if>
				<s:else>
					<s:set name="possuiObjeto" value="%{'true'}" />
					<img src="imagens/btnInformacao.png" title="Objetos pendentes"
						onclick="openDevolucao('${idxRoomList + 1}');" />
				</s:else> 
				<img src="imagens/iconic/png/plus-3x.png" title="Incluir lançamento"
					onclick="openLancamento('${idxRoomList + 1}', '<s:property value="hospede.nomeHospede" /> <s:property value="hospede.sobrenomeHospede" />')" />
				<img src="imagens/iconic/png/print-3x.png" title="Extrato parcial"
					onclick="imprimirExtrato('${idxRoomList + 1}');" /> <img
					src="imagens/iconic/png/imgContas-4x.png" title="Realizar pagamento"
					onclick="realizarCheckout('${idxRoomList + 1}');" /> 
				<s:if test="%{principal == \"S\"}">
					<img src="imagens/iconic/png/arrow-thick-bottom-3x.png" title="Liberar hóspede"
						onclick="liberarHospedePrincipal('${idxRoomList + 1}');" />
				</s:if> 
				<s:else>
					<img src="imagens/iconic/png/arrow-thick-bottom-3x.png" title="Liberar hóspede"
						onclick="liberarHospede('${idxRoomList + 1}');" />

					<script language="javaScript" type="text/javascript">
						var comboHospede = document.getElementById('idNovoHospede');
						comboHospede.options.length = comboHospede.options.length + 1;
						comboHospede.options[comboHospede.options.length-1] = new Option('${hospede.nomeHospede} ${hospede.sobrenomeHospede}', '<s:property value="idRoomList" />');
					</script>
				</s:else> 
				<s:if test='%{#session.HOTEL_SESSION.miniPdv == "S"}'>
					<img src="imagens/btnPDV.png" title="Mini PDV"
						onclick="openMiniPDV('${idxRoomList + 1}', '<s:property value="hospede.nomeHospede" /> <s:property value="hospede.sobrenomeHospede" />');" />
				</s:if>
					<img src="imagens/iconic/png/peopleReload-3x.png" title="Substituir hóspede"
					onclick="openSubstituirHospede('${idxRoomList + 1}', '<s:property value="hospede.nomeHospede" /> <s:property value="hospede.sobrenomeHospede" />')" />
					
				</li>
			</ul>
			</div>
			</div>


			<s:if
				test='%{(#request.abrirPopupLancamento == "true" || #request.abrirPopupMiniPDV == "true")  && idxCliente == #idxRoomList+1}'>
				<script>
                                nomeHospede = '<s:property value="hospede.nomeHospede" /> <s:property value="hospede.sobrenomeHospede" />';
                            </script>
			</s:if>
		</s:if>
	</s:iterator>
	</div>
	</div>
	</div>
	<!-- FINAL DO GRUPO-->


	<div class="divCadastroBotoes"><duques:botao label="Voltar"
		imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="caixaGeral()" /> <duques:botao
		label="Gravar" imagem="imagens/iconic/png/check-4x.png"
		onClick="gravarAlteracoes()" /> <duques:botao label="Liberar"
		imagem="imagens/iconic/png/lock-unlocked-4x.png" onClick="liberarCheckin()" /> 
		
		<duques:botao label="Unificar ISS/Taxa" style="display:none;width:160px;"
		imagem="imagens/btnUnificar.png" onClick="unificarTaxaCheckin()" />
		
		<s:if
		test='%{#possuiObjeto == "true" || #session.checkinCorrente.observacao!=null || #session.checkinCorrente.reservaEJB.observacao != null}'>
		<s:if
			test='%{#session.checkinCorrente.observacao!=null || #session.checkinCorrente.reservaEJB.observacao != null}'>
			<img src="imagens/btnInfo.png" title="Possui objetos ou observações"
				onclick="openObs();" />
		</s:if>
		<s:else>
			<img src="imagens/btnInfo.png" title="Possui objetos ou observações"
				style="cursor: auto;" />
		</s:else>
	</s:if></div>



	</div>
	<!-- Inicio recibo pagamento-->

	<div id="divReciboPagamento"
		style="display: none; background-color: white; border: 1px solid rgb(0, 82, 255); overflow: auto; width: 880px; height: 550px;">

	<div
		style="float: left; text-align: left; height: 25px; color: white; font-family: verdana; background-color: rgb(0, 173, 255); width: 800px; font-size: 14px; font-weight: bold;">
	<img src="imagens/iconMozart.png" />Recibo de pagamento</div>
	<div
		style="float: left; width: 60px; height: 25px; font-family: verdana; background-color: rgb(0, 173, 255);">
	<img height="24px;" width="24px" src="imagens/iconic/png/print-3x.png"
		title="Imprimir" onclick="printExtrato('divConteudoRecibo1')" /> <img
		height="24px;" width="24px" src="imagens/iconic/png/xRed-3x.png" title="Fechar"
		onclick="killModal();" /></div>
	<div id="divConteudoRecibo1" style="width: 840px; height: 99%;">
	<div
		style="margin: 3px; float: left; font-size: 14px; width: 840px; height: 170px; border: 0px solid black; text-align: left;">
	<table width="800" border="0px">
		<tr>
			<td rowspan="5" width="30px"><img
				src="<s:property value="#session.HOTEL_SESSION.enderecoLogotipo"/>"
				title="<s:property value="#session.HOTEL_SESSION.nomeFantasia"/>" /></td>
			<td colspan="4" align="center"><s:property
				value="#session.HOTEL_SESSION.nomeFantasia" /></td>
		</tr>
		<tr>
			<td colspan="3"><s:property value="#session.HOTEL_SESSION.cgc" /></td>
			<td><a style="width: 60px;">Toll-free: </a><s:property
				value="#session.HOTEL_SESSION.tollFree" /></td>
		</tr>
		<tr>
			<td colspan="3"><s:property
				value="#session.HOTEL_SESSION.nomeFantasia" /></td>
			<td><a style="width: 60px;">Telefone: </a><s:property
				value="#session.HOTEL_SESSION.telefone" /></td>
		</tr>
		<tr>
			<td colspan="3"><s:property
				value="#session.HOTEL_SESSION.endereco" />, <s:property
				value="#session.HOTEL_SESSION.cep" />, <s:property
				value="#session.HOTEL_SESSION.bairro" /></td>
			<td><a style="width: 60px;">Fax: </a><s:property
				value="#session.HOTEL_SESSION.fax" /></td>
		</tr>
		<tr>
			<td colspan="3"><s:property value="#session.HOTEL_SESSION.site" /></td>
			<td><a style="width: 60px;">E-mail: </a><s:property
				value="#session.HOTEL_SESSION.email" /></td>
		</tr>
	</table>

	</div>

	<div
		style="float: left; font-size: 14px; width: 570px; height: 120px; border: 2px solid black; text-align: left;">
	<s:property value="#session.HOTEL_SESSION.notaTermo" /></div>
	<div
		style="margin-left: 5px; float: left; font-size: 14px; width: 250px; height: 120px; border: 2px solid black; text-align: left;">
	<h1 style="font-size: 16px; text-align: center;">Recibo de
	pagamento</h1>

	<div class="divLinhaCadastro"
		style="width: 95%; border: 0px; text-align: center; font-weight: bold">Serie
	A</div>
	<div class="divLinhaCadastro"
		style="width: 95%; border: 0px; text-align: center">Número:<b><s:property
		value="#request.notaHospedagem.numNota" />/1</b></div>
	<div class="divLinhaCadastro"
		style="width: 95%; border: 0px; text-align: center">Folha: 01</div>
	</div>

	<div
		style="margin: 3px; float: left; font-size: 14px; width: 840px; height: 70px; border: 0px solid black; text-align: left;">


	<table width="830px" border="0px">
		<tr>
			<td width="110px">Nome do Hospede<br />
			(Guest Name)</td>
			<td width="230px"><s:if test="%{idxCliente == 0}">
				<s:property
					value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia" />
			</s:if> <s:else>
				<s:property
					value="#session.checkinCorrente.roomListEJBList.get(idxCliente-1).hospede.nomeHospede" />&nbsp;<s:property
					value="#session.checkinCorrente.roomListEJBList.get(idxCliente-1).hospede.sobrenomeHospede" />
			</s:else></td>
			<td width="110px">Data da Emissao<br />
			(Emission Date)</td>
			<td width="120px"><s:set var="dataCorrente"
				value="%{new java.sql.Timestamp(new java.util.Date().getTime())}" />
			<s:property value="#dataCorrente" /></td>
		</tr>
		<tr>
			<td>Apto (Room)</td>
			<td colspan="3"><s:property
				value="#session.checkinCorrente.apartamentoEJB" /></td>
		</tr>
	</table>
	</div>

	<div
		style="margin-top: 5px; margin-bottom: 3px; float: left; font-size: 14px; width: 840px; text-align: left; border-bottom: 1px solid;">
	<div style="float: left; width: 150px; font-weight: bold;">Data(Date)</div>
	<div style="float: left; width: 150px; font-weight: bold;">Documento(Document)</div>
	<div style="float: left; width: 200px; font-weight: bold;">Descrição(Description)</div>
	<div
		style="float: left; width: 120px; text-align: right; font-weight: bold;">Valor(Amount)</div>
	<div
		style="float: left; width: 80px; text-align: center; font-weight: bold;">&nbsp;</div>
	</div>
	<s:set name="totalGrupo" value="%{0.0}" /> <s:set name="totalGeral"
		value="%{0.0}" /> <s:iterator
		value="#request.movimentoReciboPagamento" var="mov">
		<s:if test='%{#movAnterior != null }'>
			<s:if
				test="%{#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.idIdentificaLancamento != #mov.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.idIdentificaLancamento}">
				<div
					style="float: left; font-size: 14px; width: 840px; text-align: left; border-bottom: 1px solid black; height: 30px;">
				<div style="float: left; width: 500px; text-align: right;">
				Total grupo <s:property
					value="#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.descricaoLancamento" />:
				</div>
				<div style="float: left; width: 120px; text-align: right;"><s:property
					value="%{#totalGrupo}" /></div>
				</div>
				<br />
				<s:set name="totalGrupo" value="%{0.0}" />
			</s:if>
		</s:if>
		<div
			style="float: left; font-size: 14px; width: 840px; text-align: left; height: 30px;">
		<div style="float: left; width: 150px;"><s:property
			value="new java.util.Date(#mov.dataLancamento.getTime())" />&nbsp;<s:property
			value="#mov.horaLancamento.toString().substring(10, #mov.horaLancamento.toString().length()-2)" /></div>
		<div style="float: left; width: 150px;"><s:property
			value="#mov.numDocumento" />&nbsp;</div>
		<div style="float: left; width: 200px;"><s:property
			value="#mov.tipoLancamentoEJB.descricaoLancamento" />&nbsp;</div>
		<div style="float: left; width: 120px; text-align: right;"><s:property
			value="#mov.valorLancamento" />&nbsp;</div>
		<div style="float: left; width: 80px; text-align: center;"><s:property
			value="#mov.tipoLancamentoEJB.debitoCredito" />&nbsp;</div>

		<s:set name="totalGeral" value='%{#totalGeral + #mov.valorLancamento}' />
		<s:set name="totalGrupo" value='%{#totalGrupo + #mov.valorLancamento}' />
		</div>
		<s:set name="movAnterior" value="%{#mov}" />

	</s:iterator>
	<div
		style="float: left; font-size: 14px; width: 840px; text-align: left; border-bottom: 1px solid black; height: 30px;">
	<div style="float: left; width: 500px; text-align: right;">Total
	grupo <s:property
		value="#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.descricaoLancamento" />:
	</div>
	<div style="float: left; width: 120px; text-align: right;"><font><s:property
		value="%{#totalGrupo}" /></font></div>
	</div>


	<div
		style="margin-top: 10px; float: left; font-size: 14px; width: 840px; height: 170px; text-align: left; border: 2px solid black;">

	<div class="divLinhaCadastro"
		style="width: 100%; margin: 0px; border-bottom: 1px solid black; height: 90px;">
	<table width="830px" border="0px">
		<tr>
			<td width="130px">Assinatura (Signature):</td>
			<td width="150px">&nbsp;</td>
			<td width="210px">Forma PGTO:<br />
			<table width="100%" border="0">
				<s:iterator value="#session.movimentoPagamentoList">
					<tr>
						<td width="80px;"><font size="2"><s:property
							value="tipoLancamentoEJB.descricaoLancamento" /> </font></td>
						<td align="right"><s:property value="valorLancamento" /></td>
					</tr>
				</s:iterator>
			</table>
			</td>
			<td width="60px">Total:</td>
			<td width="120px" align="left"><font><s:property
				value="%{#totalGeral}" /></font></td>
		</tr>

	</table>
	</div>
	<div class="divLinhaCadastro"
		style="width: 100%; margin: 0px; border-bottom: 0px solid black; height: 70px;">
	<table width="830px" border="0px">
		<tr>
			<td width="90px">Responsável:</td>
			<td width="250px"><s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.nomeHospede" />&nbsp;<s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.sobrenomeHospede" /></td>
			<td width="60px">CPF:</td>
			<td width="200px"><s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.cpf" /></td>
		</tr>
		<tr>
			<td width="90px">Endereço:</td>
			<td width="250px"><s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.endereco" />,
			<s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.bairro" />,
			<s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.cep" /></td>
			<td width="60px">Cidade/Uf:</td>
			<td width="200px"><s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.cidadeEJB.cidade" />-<s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.cidadeEJB.estado.uf" />
			</td>
		</tr>

	</table>
	</div>


	</div>



	</div>

	<!-- Final recibo de pagamento--> <!-- Inicio notahospedagem-->

	<div id="divNotaHospedagem"
		style="display: none; background-color: white; border: 1px solid rgb(0, 82, 255); overflow: auto; width: 880px; height: 550px;">

	<div
		style="float: left; text-align: left; height: 25px; color: white; font-family: verdana; background-color: rgb(0, 173, 255); width: 800px; font-size: 14px; font-weight: bold;">
	<img src="imagens/iconMozart.png" />Nota de hospedagem</div>
	<div
		style="float: left; width: 60px; height: 25px; font-family: verdana; background-color: rgb(0, 173, 255);">
	<img height="24px;" width="24px" src="imagens/iconic/png/print-3x.png"
		title="Imprimir" onclick="printExtrato('divConteudoNota1')" /> <img
		height="24px;" width="24px" src="imagens/iconic/png/xRed-3x.png" title="Fechar"
		onclick="killModal();openCheckout();" /></div>
	<div id="divConteudoNota1" style="width: 840px; height: 99%;">
	<div
		style="margin: 3px; float: left; font-size: 14px; width: 840px; height: 170px; border: 0px solid black; text-align: left;">
	<table width="800" border="0px">
		<tr>
			<td rowspan="5" width="30px"><img
				src="<s:property value="#session.HOTEL_SESSION.enderecoLogotipo"/>"
				title="<s:property value="#session.HOTEL_SESSION.nomeFantasia"/>" /></td>
			<td colspan="4" align="center"><s:property
				value="#session.HOTEL_SESSION.nomeFantasia" /></td>
		</tr>
		<tr>
			<td colspan="3"><s:property value="#session.HOTEL_SESSION.cgc" /></td>
			<td><a style="width: 60px;">Toll-free: </a><s:property
				value="#session.HOTEL_SESSION.tollFree" /></td>
		</tr>
		<tr>
			<td colspan="3"><s:property
				value="#session.HOTEL_SESSION.nomeFantasia" /></td>
			<td><a style="width: 60px;">Telefone: </a><s:property
				value="#session.HOTEL_SESSION.telefone" /></td>
		</tr>
		<tr>
			<td colspan="3"><s:property
				value="#session.HOTEL_SESSION.endereco" />, <s:property
				value="#session.HOTEL_SESSION.cep" />, <s:property
				value="#session.HOTEL_SESSION.bairro" /></td>
			<td><a style="width: 60px;">Fax: </a><s:property
				value="#session.HOTEL_SESSION.fax" /></td>
		</tr>
		<tr>
			<td colspan="3"><s:property value="#session.HOTEL_SESSION.site" /></td>
			<td><a style="width: 60px;">E-mail: </a><s:property
				value="#session.HOTEL_SESSION.email" /></td>
		</tr>
	</table>

	</div>

	<div
		style="float: left; font-size: 14px; width: 570px; height: 120px; border: 2px solid black; text-align: left;">
	<s:property value="#session.HOTEL_SESSION.notaTermo" /></div>
	<div
		style="margin-left: 5px; float: left; font-size: 14px; width: 250px; height: 120px; border: 2px solid black; text-align: left;">
	<h1 style="font-size: 16px; text-align: center;">Nota de
	hospedagem</h1>

	<div class="divLinhaCadastro"
		style="width: 95%; border: 0px; text-align: center; font-weight: bold">Serie
	A</div>
	<div class="divLinhaCadastro"
		style="width: 95%; border: 0px; text-align: center">Número:<b><s:property
		value="#session.notaHospedagem.numNota" />/1</b></div>
	<div class="divLinhaCadastro"
		style="width: 95%; border: 0px; text-align: center">Folha: 01</div>
	</div>

	<div
		style="margin: 3px; float: left; font-size: 14px; width: 840px; height: 100px; border: 0px solid black; text-align: left;">


	<table width="830px" border="0px">
		<tr>
			<td width="110px">Nome do Hóspede<br />
			(Guest Name)</td>
			<td width="230px">

			<s:if test="%{idxCliente == 0}">
				<s:property
					value="#session.checkinCorrente.roomListPrincipal.hospede.nomeHospede" />&nbsp;<s:property
					value="#session.checkinCorrente.roomListPrincipal.hospede.sobrenomeHospede" />
			</s:if>
			<s:else>
				<s:property
					value="#session.checkinCorrente.roomListEJBList.get(idxCliente-1).hospede.nomeHospede" />&nbsp;<s:property
					value="#session.checkinCorrente.roomListEJBList.get(idxCliente-1).hospede.sobrenomeHospede" />
			</s:else>

</td>

			<td width="110px">Reserva<br />
				(Reserve)</td>
			<td width="120px" style="color:blue;"> 
				<s:property value="#session.checkinCorrente.reservaEJB.idReserva" />
			</td>

			<td width="110px">Check-in</td>
			<td width="120px"> 

			<s:if test="%{idxCliente == 0}">
				<s:property value="#session.checkinCorrente.roomListPrincipal.dataEntrada" />&nbsp;
			</s:if>
			<s:else>
				<s:property value="#session.checkinCorrente.roomListEJBList.get(idxCliente-1).dataEntrada" />&nbsp;
			</s:else>


			</td>


			<td width="110px">Data da Emissão<br />
			(Emission Date)</td>
			<td width="120px"> <%=com.mozart.model.util.MozartUtil.format(new java.util.Date(), "dd/MM/yyyy HH:mm:ss")%>
	
<s:set var="dataCorrente"
				value="%{new java.sql.Timestamp(new java.util.Date().getTime())}" />
</td>
		</tr>
		<tr>
			<td>Conta</td>
			<td colspan="3"><s:property
				value="#session.checkinCorrente.apartamentoEJB" /></td>


			<td width="110px">Check-out</td>
			<td width="120px" colspan="3"> 

				<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice" />&nbsp; 

			</td>


		</tr>
	</table>
	</div>

	<div
		style="margin-top: 5px; margin-bottom: 3px; float: left; font-size: 14px; width: 840px; text-align: left; border-bottom: 1px solid;">
	<div style="float: left; width: 150px; font-weight: bold;">Data(Date)</div>
	<div style="float: left; width: 150px; font-weight: bold;">Documento(Document)</div>
	<div style="float: left; width: 200px; font-weight: bold;">Descrição
	(Description)</div>
	<div
		style="float: left; width: 120px; text-align: right; font-weight: bold;">Valor(Amount)</div>
	<div
		style="float: left; width: 80px; text-align: center; font-weight: bold;">&nbsp;</div>
	</div>
	<s:set name="totalGrupo" value="%{0.0}" /> <s:set name="totalGeral"
		value="%{0.0}" /> <s:iterator
		value="#session.movimentoNotaHospedagem" var="mov">
		<s:if test='%{#movAnterior != null }'>
			<s:if
				test="%{#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.idIdentificaLancamento != #mov.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.idIdentificaLancamento}">
				<div
					style="float: left; font-size: 14px; width: 840px; text-align: left; border-bottom: 1px solid black; height: 30px;">
				<div style="float: left; width: 500px; text-align: right;">
				Total grupo <s:property
					value="#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.descricaoLancamento" />:
				</div>
				<div style="float: left; width: 120px; text-align: right;"><font><s:property
					value="%{#totalGrupo}" /></font></div>
				</div>
				<br />
				<s:set name="totalGrupo" value="%{0.0}" />
			</s:if>
		</s:if>
		<div
			style="float: left; font-size: 14px; width: 840px; text-align: left; height: 30px;">
		<div style="float: left; width: 150px;"><s:property
			value="new java.util.Date(#mov.dataLancamento.getTime())" />&nbsp;<s:property
			value="#mov.horaLancamento.toString().substring(10, #mov.horaLancamento.toString().length()-2)" /></div>
		<div style="float: left; width: 150px;"><s:property
			value="#mov.numDocumento" />&nbsp;</div>
		<div style="float: left; width: 200px;"><s:property
			value="#mov.tipoLancamentoEJB.descricaoLancamento" />&nbsp;</div>
		<div style="float: left; width: 120px; text-align: right;">&nbsp;<s:property
			value="#mov.valorLancamento" /></div>
		<div style="float: left; width: 80px; text-align: center;">&nbsp;<s:property
			value="#mov.tipoLancamentoEJB.debitoCredito" /></div>

		<s:set name="totalGeral" value='%{#totalGeral + #mov.valorLancamento}' />
		<s:set name="totalGrupo" value='%{#totalGrupo + #mov.valorLancamento}' />
		</div>
		<s:set name="movAnterior" value="%{#mov}" />

	</s:iterator>
	<div
		style="float: left; font-size: 14px; width: 840px; text-align: left; border-bottom: 1px solid black; height: 30px;">
	<div style="float: left; width: 500px; text-align: right;">Total
	grupo <s:property
		value="#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.descricaoLancamento" />:
	</div>
	<div style="float: left; width: 120px; text-align: right;"><font><s:property
		value="%{#totalGrupo}" /></font></div>
	</div>


	<div
		style="margin-top: 10px; float: left; font-size: 14px; width: 840px; height: 170px; text-align: left; border: 2px solid black;">

	<div class="divLinhaCadastro"
		style="width: 100%; margin: 0px; border-bottom: 1px solid black; height: 90px;">
	<table width="830px" border="0px">
		<tr>
			<td width="130px">Assinatura (Signature):</td>
			<td width="150px">&nbsp;</td>
			<td width="210px">Forma PGTO:<br />
			<table width="100%" border="0">
				<s:iterator value="#session.movimentoPagamentoList">
					<tr>
						<td width="80px;"><font size="2"><s:property
							value="tipoLancamentoEJB.descricaoLancamento" /> </font></td>
						<td align="right"><s:property value="valorLancamento<0?valorLancamento*-1:valorLancamento" /></td>
					</tr>
				</s:iterator>
			</table>
			</td>
			<td width="60px">Total:</td>
			<td width="120px" align="left"><font color="blue"><s:property
				value="%{#totalGeral<0?#totalGeral*-1:#totalGeral}" /></font></td>
		</tr>

	</table>
	</div>
	<div class="divLinhaCadastro"
		style="width: 100%; margin: 0px; border-bottom: 0px solid black; height: 70px;">
	<table width="830px" border="0px">


			<s:if test="%{idxCliente == 0}">


		<tr>
			<td width="90px">Responsável:</td>
			<td width="250px"><s:property
				value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia" /></td>
			<td width="60px">CNPJ:</td>
			<td width="200px"><s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.empresaEJB.cgc" /></td>
		</tr>
		<tr>
			<td width="90px">Endereço:</td>
			<td width="250px"><s:property
				value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.enderecoCobranca" />,
			<s:property
				value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.bairro" />,
			<s:property
				value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.cep" /></td>
			<td width="60px">Cidade/Uf:</td>
			<td width="200px"><s:property
				value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.cidade.cidade" />-<s:property
				value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.cidade.estado.uf" />
			</td>
		</tr>


		</s:if> <s:else>

		<tr>
			<td width="90px">Responsável:</td>
			<td width="250px"><s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.nomeHospede" />&nbsp;<s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.sobrenomeHospede" /></td>
			<td width="60px">CPF:</td>
			<td width="200px"><s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.cpf" /></td>
		</tr>
		<tr>
			<td width="90px">Endereço:</td>
			<td width="250px"><s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.endereco" />,
			<s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.bairro" />,
			<s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.cep" /></td>
			<td width="60px">Cidade/Uf:</td>
			<td width="200px"><s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.cidadeEJB.cidade" />-<s:property
				value="#session.checkinCorrente.roomListPrincipal.hospede.cidadeEJB.estado.uf" />
			</td>
		</tr>



	</s:else>



		

	</table>
	</div>


	</div>



	</div>

	<!-- Final notahospedagem--> <!-- Inicio nota fiscal-->

	<div id="divNotaFiscal"
		style="display: none; background-color: white; border: 1px solid rgb(0, 82, 255); overflow: auto; width: 880px; height: 550px;">

	<div
		style="float: left; text-align: left; height: 25px; color: white; font-family: verdana; background-color: rgb(0, 173, 255); width: 800px; font-size: 14px; font-weight: bold;">
	<img src="imagens/iconMozart.png" />Nota Fiscal</div>
	<div
		style="float: left; width: 60px; height: 25px; font-family: verdana; background-color: rgb(0, 173, 255);">
	<img height="24px;" width="24px" src="imagens/iconic/png/print-3x.png"
		title="Imprimir" onclick="printExtrato('divConteudoNotaFiscal')" /> <img
		height="24px;" width="24px" src="imagens/iconic/png/xRed-3x.png" title="Fechar"
		onclick="killModal();abrirNotaHospedagem();" /></div>
	<div id="divConteudoNotaFiscal" style="width: 840px; height: 99%;"><s:property value="#request.conteudoNotaFiscal"/></div>

	<!-- Final nota fiscal--></div>

	</div>
</s:form>




<!-- inicio div extrato-->

<s:if test='%{#request.abrirPopupExtrato == "true"}'>
	<s:set name="totalGeral" value="%{0.0}" />
	<s:set name="totalGrupo" value="%{0.0}" />
	<s:set name="totalCredito" value="%{0.0}" />

	<s:set name="valorISS" value="%{0.0}" />
	<s:set name="valorTaxa" value="%{0.0}" />
	<s:set name="valorRoomtax" value="%{0.0}" />
	<s:set name="valorSeguro" value="%{0.0}" />

	<s:if test='%{idxCliente == "0"}'>
		<div id="divExtrato"
			style="display: none; background-color: white; border: 1px solid rgb(0, 82, 255); position: absolute; overflow: auto; width: 800px; height: 450px;">
		<div
			style="float: left; text-align: left; height: 25px; color: white; font-family: verdana; background-color: rgb(0, 173, 255); width: 730px; font-size: 14px; font-weight: bold;">
		<img src="imagens/iconMozart.png" />Extrato Parcial</div>
		<div
			style="float: left; width: 70px; height: 25px; font-family: verdana; background-color: rgb(0, 173, 255);">
		<img height="24px;" width="24px" src="imagens/iconic/png/print-3x.png"
			title="Imprimir" onclick="printExtrato('divConteudoExtrato1')" /> <img
			height="24px;" width="24px" src="imagens/iconic/png/xRed-3x.png" title="Fechar"
			onclick="killModal();" /></div>
		<div id="divConteudoExtrato1"
			style="background-color: white; overflow: auto; width: 800px; height: 410px;">
		<div style="width: 780px; height: 120px; background-color: white">
		<div class="divLogoHotel"
			style="position: static; float: left; width: 100px; background-color: white">
		<img
			src="<s:property value="#session.HOTEL_SESSION.enderecoLogotipo"/>"
			title="<s:property value="#session.HOTEL_SESSION.nomeFantasia"/>" />
		</div>
		<div
			style="float: left; font-size: 22px; width: 600px; text-align: center; background-color: white">
		<s:property value="#session.HOTEL_SESSION.nomeFantasia" /><br />
		Extrato Parcial - Empresa<br />
		<font size="2"><s:property
			value="#session.CONTROLA_DATA_SESSION.frontOffice" /></font></div>
		</div>
		<br />
		<div
			style="float: left; font-size: 14px; width: 740px; text-align: left">
		Conta: <font color="red"><s:property
			value="#session.checkinCorrente.apartamentoEJB.numApartamento" /> </font>&nbsp;&nbsp;&nbsp;Nome:
		<s:property
			value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia" /></div>
		<br />
		<div
			style="float: left; font-size: 14px; width: 740px; text-align: left">
		<div style="float: left; width: 80px;">Data</div>
		<div style="float: left; width: 150px;">Documento</div>
		<div style="float: left; width: 200px;">Descrição</div>
		<div style="float: left; width: 80px;">Hora</div>
		<div style="float: left; width: 80px; text-align: right;">Valor</div>
		<div style="float: left; width: 80px; text-align: center;">Sinal</div>
		</div>
		<s:iterator
			value="#session.checkinCorrente.movimentoApartamentoEJBList"
			var="mov">
			<s:if test='%{quemPaga == "E" && #mov.movTmp == "S"}'>
				<s:if test='%{#movAnterior != null }'>
					<s:if
						test="%{#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.idIdentificaLancamento != #mov.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.idIdentificaLancamento}">
						<div
							style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
						<div style="float: left; width: 590px; text-align: right;">
						Total grupo <s:property
							value="#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.descricaoLancamento" />:
						<s:property value="%{#totalGrupo}" /></div>
						</div>
						<br />
						<s:set name="totalGrupo" value="%{0.0}" />
					</s:if>
				</s:if>
				<div
					style="float: left; font-size: 14px; width: 740px; text-align: left">
				<div style="float: left; width: 80px;"><s:property
					value="new java.util.Date(#mov.dataLancamento.getTime())" />&nbsp;</div>
				<div style="float: left; width: 150px;"><s:property
					value="#mov.numDocumento" />&nbsp;</div>
				<div style="float: left; width: 200px;"><s:property
					value="#mov.tipoLancamentoEJB.descricaoLancamento" />&nbsp;</div>
				<div style="float: left; width: 80px;"><s:property
					value="#mov.horaLancamento.toString().substring(10, #mov.horaLancamento.toString().length()-2)" />&nbsp;</div>
				<div style="float: left; width: 80px; text-align: right;"><s:property
					value="#mov.valorLancamento" /></div>
				<div style="float: left; width: 80px; text-align: center;"><s:property
					value="#mov.tipoLancamentoEJB.debitoCredito" /></div>

				<s:set name="totalGeral"
					value='%{#totalGeral + #mov.valorLancamento}' /> <s:set
					name="totalGrupo" value='%{#totalGrupo + #mov.valorLancamento}' />


				<s:if
					test='%{#session.HOTEL_SESSION.taxaCheckout == "S" && #session.HOTEL_SESSION.iss.doubleValue() > 0.0 && #session.checkinCorrente.calculaIss == "S" && #mov.tipoLancamentoEJB.iss == "S"}'>
					<s:set name="valorISS" value="%{#valorISS + #mov.valorLancamento}" />
				</s:if> <s:if
					test='%{#session.HOTEL_SESSION.taxaCheckout == "S" && #session.checkinCorrente.calculaTaxa == "S" && #mov.tipoLancamentoEJB.taxaServico == "S"}'>
					<s:set name="valorTaxa"
						value="%{#valorTaxa + #mov.valorLancamento}" />
				</s:if> <s:if
					test='%{#session.checkinCorrente.calculaRoomtax == "S" && #mov.tipoLancamentoEJB.roomtax == "S"}'>
					<s:set name="valorRoomtax"
						value="%{#valorRoomtax + #mov.valorLancamento}" />
				</s:if></div>
				<s:set name="movAnterior" value="%{#mov}" />
			</s:if>
		</s:iterator>
		<div
			style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
		<div style="float: left; width: 590px; text-align: right;">
		Total grupo <s:property
			value="#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.descricaoLancamento" />:

		<s:property value="%{#totalGrupo}" /></div>
		</div>
		<br />
		<s:set name="totalGeralComImposto" value="%{#totalGeral}" /> <s:if
			test='%{#session.HOTEL_SESSION.taxaCheckout == "S" && #session.HOTEL_SESSION.iss.doubleValue() > 0.0}'>
			<div
				style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
			<div style="float: left; width: 590px; text-align: right;">ISS
			<s:property value="%{#session.HOTEL_SESSION.iss.doubleValue()}" />
			%: <font color="blue"><s:property
				value="%{#valorISS * (#session.HOTEL_SESSION.iss.doubleValue()/100)}" />
			</font></div>
			</div>
			<s:set name="totalGeralComImposto"
				value="%{#totalGeralComImposto + (#valorISS * (#session.HOTEL_SESSION.iss.doubleValue()/100))}" />
		</s:if> <s:if test='%{#session.HOTEL_SESSION.taxaCheckout == "S"}'>
			<div
				style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
			<div style="float: left; width: 590px; text-align: right;">Taxa
			de serviço <s:property
				value="%{#session.HOTEL_SESSION.taxaServico.doubleValue()}" /> %: <font
				color="blue"><s:property
				value="%{#valorTaxa * #session.HOTEL_SESSION.taxaServico.doubleValue()/100}" /></font></div>
			</div>
			<s:set name="totalGeralComImposto"
				value="%{#totalGeralComImposto + (#valorTaxa * (#session.HOTEL_SESSION.taxaServico.doubleValue()/100))}" />
		</s:if> <s:if
			test='%{#session.checkinCorrente.calculaRoomtax == "VER COMO VAI FICAR"}'>
			<div
				style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
			<div style="float: left; width: 590px; text-align: right;">Taxa
			Roomtax <s:property
				value="%{#session.HOTEL_SESSION.roomtax.doubleValue()}" /> %: <font
				color="blue"><s:property
				value="%{#valorRoomtax * #session.HOTEL_SESSION.roomtax.doubleValue()/100}" /></font></div>
			</div>
			<s:set name="totalGeralComImposto"
				value="%{#totalGeralComImposto + (#valorRoomtax * (#session.HOTEL_SESSION.roomtax/100))}" />

		</s:if> <s:if
			test='%{#session.checkinCorrente.calculaSeguro == "VER COMOM VAI COBRAR O SEGURO"}'>
			<div
				style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
			<div style="float: left; width: 590px; text-align: right;">Seguro:
			<font color="blue"><s:property
				value="%{#session.HOTEL_SESSION.seguro}" /></font></div>
			</div>
			<s:set name="totalGeralComImposto"
				value="%{#totalGeralComImposto + #session.HOTEL_SESSION.seguro}" />
		</s:if>


		<div
			style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
		<div style="float: left; width: 590px; text-align: right;">Total
		geral: <font color="blue"><s:property
			value="%{#totalGeralComImposto.doubleValue() - #totalCredito.doubleValue()}" /></font></div>
		</div>

		</div>
		</div>
	</s:if>
	<!-- fim div extrato empresa-->
	<s:else>
		<s:iterator value="#session.checkinCorrente.roomListEJBList"
			var="room" status="row">
			<s:if test="%{idxCliente == #row.index + 1}">
				<div id="divExtrato"
					style="display: none; background-color: white; border: 1px solid rgb(0, 82, 255); position: absolute; overflow: auto; width: 800px; height: 450px;">
				<div
					style="float: left; text-align: left; height: 25px; color: white; font-family: verdana; background-color: rgb(0, 173, 255); width: 730px; font-size: 14px; font-weight: bold;">
				<img src="imagens/iconMozart.png" />Extrato Parcial</div>
				<div
					style="float: left; width: 70px; height: 25px; font-family: verdana; background-color: rgb(0, 173, 255);">
				<img height="24px;" width="24px" src="imagens/iconic/png/print-3x.png"
					title="Imprimir" onclick="printExtrato('divConteudoExtrato2')" /> <img
					height="24px;" width="24px" src="imagens/iconic/png/xRed-3x.png"
					title="Fechar" onclick="killModal();" /></div>
				<div id="divConteudoExtrato2"
					style="background-color: white; overflow: auto; width: 800px; height: 410px;">
				<div style="width: 780px; height: 120px; background-color: white">
				<div class="divLogoHotel"
					style="position: static; float: left; width: 100px; background-color: white">
				<img
					src="<s:property value="#session.HOTEL_SESSION.enderecoLogotipo"/>"
					title="<s:property value="#session.HOTEL_SESSION.nomeFantasia"/>" />
				</div>
				<div
					style="float: left; font-size: 22px; width: 600px; text-align: center; background-color: white">
				<s:property value="#session.HOTEL_SESSION.nomeFantasia" /><br />
				Extrato Parcial - Hóspede<br />
				<font size="2"><s:property
					value="#session.CONTROLA_DATA_SESSION.frontOffice" /></font></div>
				</div>
				<br />
				<div
					style="float: left; font-size: 14px; width: 740px; text-align: left;">
				Conta: <font color="red"><s:property
					value="#session.checkinCorrente.apartamentoEJB.numApartamento" />
				</font>&nbsp;&nbsp;&nbsp;Nome: <s:property value="hospede.nomeHospede" />&nbsp;<s:property
					value="hospede.sobrenomeHospede" /></div>
				<br />
				<div
					style="float: left; font-size: 14px; width: 740px; text-align: left">
				<div style="float: left; width: 80px;">Data</div>
				<div style="float: left; width: 150px;">Documento</div>
				<div style="float: left; width: 200px;">Descrição</div>
				<div style="float: left; width: 80px;">Hora</div>
				<div style="float: left; width: 80px; text-align: right;">Valor</div>
				<div style="float: left; width: 80px; text-align: center;">Sinal</div>
				</div>
				<s:set name="totalGeral" value="%{0.0}" /> <s:set name="totalGrupo"
					value="%{0.0}" /> <s:iterator value="movimentoApartamentoEJBList"
					var="mov">

					<s:if test='%{quemPaga == "H" && #mov.movTmp == "S"}'>
						<s:if test="%{#movAnterior != null}">
							<s:if
								test="%{#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.idIdentificaLancamento != #mov.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.idIdentificaLancamento}">
								<div
									style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
								<div style="float: left; width: 590px; text-align: right;">
								Total grupo <s:property
									value="#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.descricaoLancamento" />:
								<font><s:property value="%{#totalGrupo}" /></font></div>
								</div>
								<br />
								<s:set name="totalGrupo" value="%{0.0}" />
							</s:if>
						</s:if>
						<div
							style="float: left; font-size: 14px; width: 740px; text-align: left">
						<div style="float: left; width: 80px;"><s:property
							value="new java.util.Date(#mov.dataLancamento.getTime())" />&nbsp;</div>
						<div style="float: left; width: 150px;"><s:property
							value="#mov.numDocumento" />&nbsp;</div>
						<div style="float: left; width: 200px;"><s:property
							value="#mov.tipoLancamentoEJB.descricaoLancamento" />&nbsp;</div>
						<div style="float: left; width: 80px;"><s:property
							value="#mov.horaLancamento.toString().substring(10, #mov.horaLancamento.toString().length()-2)" />&nbsp;</div>

						<div style="float: left; width: 80px; text-align: right;"><s:property
							value="#mov.valorLancamento" /></div>



						<div style="float: left; width: 80px; text-align: center;"><s:property
							value="#mov.tipoLancamentoEJB.debitoCredito" /></div>
						<s:set name="totalGeral"
							value='%{#totalGeral + #mov.valorLancamento}' /> <s:set
							name="totalGrupo" value='%{#totalGrupo + #mov.valorLancamento}' />
						<s:if
							test='%{#session.HOTEL_SESSION.taxaCheckout == "S" && #session.HOTEL_SESSION.iss.doubleValue() > 0.0 && #session.checkinCorrente.calculaIss == "S" && #mov.tipoLancamentoEJB.iss == "S"}'>
							<s:set name="valorISS"
								value="%{#valorISS + #mov.valorLancamento}" />
						</s:if> <s:if
							test='%{#session.HOTEL_SESSION.taxaCheckout == "S" && #session.checkinCorrente.calculaTaxa == "S" && #mov.tipoLancamentoEJB.taxaServico == "S"}'>
							<s:set name="valorTaxa"
								value="%{#valorTaxa + #mov.valorLancamento}" />
						</s:if> <s:if
							test='%{#session.checkinCorrente.calculaRoomtax == "S" && #mov.tipoLancamentoEJB.roomtax == "S"}'>
							<s:set name="valorRoomtax"
								value="%{#valorRoomtax + #mov.valorLancamento}" />
						</s:if></div>
						<s:set name="movAnterior" value="%{#mov}" />
					</s:if>
				</s:iterator>
				<div
					style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
				<div style="float: left; width: 590px; text-align: right;">
				Total grupo <s:property
					value="#movAnterior.tipoLancamentoEJB.identificaLancamento.identificaLancamentoPaiEJB.descricaoLancamento" />:

				<font><s:property value="%{#totalGrupo}" /></font></div>
				</div>
				<br />
				<s:set name="totalGeralComImposto" value="%{#totalGeral}" /> <s:if
					test='%{#session.HOTEL_SESSION.taxaCheckout == "S" && #session.HOTEL_SESSION.iss.doubleValue() > 0.0}'>
					<div
						style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
					<div style="float: left; width: 590px; text-align: right;">ISS
					<s:property value="%{#session.HOTEL_SESSION.iss.doubleValue()}" />
					%: <font color="blue"><s:property
						value="%{#valorISS * #session.HOTEL_SESSION.iss.doubleValue()/100}" /></font></div>
					</div>
					<s:set name="totalGeralComImposto"
						value="%{#totalGeralComImposto + (#valorISS * (#session.HOTEL_SESSION.iss.doubleValue()/100))}" />
				</s:if> <s:if test='%{#session.HOTEL_SESSION.taxaCheckout== "S"}'>
					<div
						style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
					<div style="float: left; width: 590px; text-align: right;">Taxa
					de serviço <s:property
						value="%{#session.HOTEL_SESSION.taxaServico.doubleValue()}" /> %:
					<font color="blue"><s:property
						value="%{#valorTaxa * #session.HOTEL_SESSION.taxaServico.doubleValue()/100}" /></font></div>
					</div>
					<s:set name="totalGeralComImposto"
						value="%{#totalGeralComImposto + (#valorTaxa * (#session.HOTEL_SESSION.taxaServico.doubleValue()/100))}" />
				</s:if> <s:if
					test='%{#session.checkinCorrente.calculaRoomtax == "VER COMPO VAI FICAR"}'>
					<div
						style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
					<div style="float: left; width: 590px; text-align: right;">Taxa
					Roomtax <s:property value="%{#session.HOTEL_SESSION.roomtax}" />
					%: <font color="blue"><s:property
						value="%{#valorRoomtax * #session.HOTEL_SESSION.roomtax/100}" /></font></div>
					</div>
					<s:set name="totalGeralComImposto"
						value="%{#totalGeralComImposto + (#valorRoomtax * (#session.HOTEL_SESSION.roomtax/100))}" />

				</s:if> <s:if
					test='%{#session.checkinCorrente.calculaSeguro == "VER COMOM VAI COBRAR O SEGURO"}'>
					<div
						style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
					<div style="float: left; width: 590px; text-align: right;">Seguro:
					<font color="blue"><s:property
						value="%{#session.HOTEL_SESSION.seguro}" /></font></div>
					</div>
					<s:set name="totalGeralComImposto"
						value="%{#totalGeralComImposto + #session.HOTEL_SESSION.seguro}" />
				</s:if>


				<div
					style="float: left; font-size: 14px; width: 740px; text-align: left; border-bottom: 1px solid black;">
				<div style="float: left; width: 590px; text-align: right;">Total
				geral: <font color="blue"><s:property
					value="%{#totalGeralComImposto.doubleValue()- #totalCredito.doubleValue()}" /></font></div>
				</div>

				</div>
				</div>
			</s:if>
		</s:iterator>
	</s:else>
	<!-- fim div extrato empresa-->


</s:if>
<!-- fim div extrato-->


<!-- Início do checkout-->

<div id="divCheckout"
	style="display: none; background-color: white; border: 1px solid rgb(0, 82, 255); position: absolute; width: 780px; height: 550px;">
<div
	style="float: left; text-align: left; height: 25px; color: white; width: 650px; font-size: 14px; font-weight: bold; font-family: verdana; background-color: rgb(0, 173, 255);">
<img src="imagens/iconMozart.png" />Fechar</div>
<div
	style="float: left; width: 130px; height: 25px; font-family: verdana; background-color: rgb(0, 173, 255);">

<s:if test="%{#session.notaHospedagem == null}">
	<img align="right" height="24px;" width="24px"
		src="imagens/iconic/png/xRed-3x.png" title="Cancelar" onclick="killModal();" />
</s:if> <s:else>
	<img align="right" height="24px;" width="24px"
		src="imagens/iconic/png/xRed-3x.png" title="Fechar" onclick="informarMotivo();" />
</s:else> 
<s:if test="%{valorPagamento.compareTo(valorAdicionado) == 0 && #session.movimentoPagamentoList.size() > 0}">

		<img align="right" height="24px;" width="24px"
			src="imagens/iconic/png/check-4x.png" title="Confirmar"
			onclick="gravarCheckout();" />	


	<s:if test="%{#session.HOTEL_SESSION.notaHosp == \"S\"}">
	<img align="right" height="24px;" width="24px"
		src="imagens/iconic/png/print-3x.png" title="Nota hospedagem"
		onclick="killModal();imprimeNotaHospedagem();" />
	</s:if>

	<s:if test="%{#session.HOTEL_SESSION.notaFiscal == \"S\"}">
		<img align="right" height="24px;" width="24px"
			src="imagens/iconic/png/print-3x.png" title="Nota Fiscal"
			onclick="imprimeNotaFiscal();" />
	</s:if>
	
	<s:if test="%{#session.HOTEL_SESSION.cupomfiscal == \"S\" && #session.notaHospedagem == null}">
		<img align="right" height="24px;" width="24px"
		src="imagens/iconic/png/print-3x.png" title="Cupom Fiscal"
		onclick="imprimirCupomFiscal()"
		 />
	</s:if>
	<s:elseif test="%{#session.HOTEL_SESSION.cupomfiscal == \"S\" && #session.notaHospedagem.tipoNotaFiscal == \"CF\"}">
		<img align="right" height="24px;" width="24px"
		src="imagens/btnImprimirCinza.png" title="Cupom Fiscal"
		style="cursor: auto;"/>
	</s:elseif>
	
	
</s:if> <s:else>
	<img align="right" height="24px;" width="24px"
		src="imagens/btnGravarCinza.png" title="Confirmar"
		style="cursor: auto;" />
	
	<img align="right" height="24px;" width="24px"
		src="imagens/btnImprimirCinza.png" title="Nota hospedagem"
		style="cursor: auto;" />

	<s:if test="%{#session.HOTEL_SESSION.notaFiscal == \"S\"}">
		<img align="right" height="24px;" width="24px"
		src="imagens/btnImprimirCinza.png" title="Nota Fiscal"
		style="cursor: auto;"
		 />
	</s:if>

	<s:if test="%{#session.HOTEL_SESSION.cupomfiscal == \"S\"}">
		<img align="right" height="24px;" width="24px"
		src="imagens/btnImprimirCinza.png" title="Cupom Fiscal"
		style="cursor: auto;"
		 />
	</s:if>

</s:else></div>
<div id="divPagamento"
	style="background-color: white; overflow: auto; width: 780px; height: 410px;">

<br />

<div class="divGrupo" style="width: 770px; height: 50px;">
<div class="divGrupoTitulo">Cliente</div>
<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 210px;">
<p style="width: 80px;">Conta:</p>
<font color="red"><s:property
	value="#session.checkinCorrente.apartamentoEJB.numApartamento" /> </font></div>
<div class="divItemGrupo" style="width: 460px;">
<p style="width: 100px;">Nome:</p>
<s:if test="%{idxCliente == 0}">
	<label id="nomeClienteChk"><s:property
		value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.nomeFantasia" /></label>
</s:if> <s:else>
	<label id="nomeClienteChk"><s:property
		value="#session.checkinCorrente.roomListEJBList.get(idxCliente-1).hospede.nomeHospede" />&nbsp;<s:property
		value="#session.checkinCorrente.roomListEJBList.get(idxCliente-1).hospede.sobrenomeHospede" /></label>
</s:else></div>
</div>
</div>

<div class="divGrupo" id="divGrupoNotaFiscal"
	style="width: 770px; height: 100px; display: none">
<div class="divGrupoTitulo">Nota fiscal</div>
<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 100%;">
<p style="width: 110px;">Nº Nota:</p>
<input style="color: red;" type="text" id="numNotaFiscal1"
	name="numNotaFiscal1" maxlength="15" size="15"
	onkeypress="valida(this, numeros)" /></div>
</div>
<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 100%;">
<p style="width: 110px;">Série:</p>
<input style="color: blue;" type="text" id="serieNotaFiscal1"
	name="serieNotaFiscal1" maxlength="2" size="5" value="A"
	onblur="toUpperCase(this)" /></div>
</div>
<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 100%;">
<p style="width: 110px;">Sub Série:</p>
<input type="text" id="subSerieNotaFiscal1" name="subSerieNotaFiscal1"
	maxlength="3" size="5" onblur="toUpperCase(this)" /></div>
</div>

<div class="divCadastroBotoes" style="width: 98%;"><duques:botao
	label="Imprimir" style="width:120px;" imagem="imagens/iconic/png/print-3x.png"
	onClick="gerarNotaFiscal()" /></div>


</div>


<div class="divGrupo" id="divGrupoCancelamento"
	style="width: 770px; height: 80px; display: none">
<div class="divGrupoTitulo">Cancelamento Nota</div>
<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 100%;">
<p style="width: 110px;">Motivo:</p>
<input type="text" id="motivoCancelamentoNota1"
	name="motivoCancelamentoNota1" maxlength="50" size="30"
	value="Erro na impressão" /> <img align="right" height="24px;"
	width="24px" src="imagens/iconic/png/arrow-thick-left-3x.png" title="Cancelar"
	onclick="desistirCancelamentoNota();" />&nbsp; <img align="right"
	height="24px;" width="24px" src="imagens/iconic/png/check-4x.png" title="Gravar"
	onclick="gravarCancelamentoNota();" />&nbsp;</div>
</div>

</div>

<div class="divGrupo" id="divGrupoPagamento"
	style="width: 770px; height: 250px; display: block">
<div class="divGrupoTitulo">Pagamentos</div>

<div class="divGrupoBody" style="width: 770px;">

<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 210px;">
<p style="width: 110px;">Valor Pagamento:</p>
<font color="blue"><s:property value="valorPagamento" /></font></div>
<div class="divItemGrupo" style="width: 200pt;">
<p style="width: 80px;">Valor Pago:</p>
<font color="black"><s:property value="valorAdicionado" /></font></div>
<div class="divItemGrupo" style="width: 130pt;">
<p style="width: 80px;">Diferença:</p>
<s:if test="%{valorPagamento - valorAdicionado < 0}">
	<font color="red"><s:property
		value="valorPagamento - valorAdicionado" /></font>
</s:if> <s:else>
	<font color="green"><s:property
		value="valorPagamento - valorAdicionado" /></font>
</s:else></div>

</div>


<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 220px;">
<p style="width: 80px;">Forma PGTO:</p>
<s:select list="#session.tipoPagamentoList" cssStyle="width:120px;"
	headerKey="" headerValue="Selecione" listKey="idTipoLancamento"
	listValue="descricaoLancamento" id="idTipoLancamento2"
	name="idTipoLancamento2" /></div>
<div class="divItemGrupo" style="width: 200pt;">
<p style="width: 100px;">Nº documento:</p>
<input name="numDocumento2" id="numDocumento2" type="text" size="15"
	maxlength="50" /></div>
<div class="divItemGrupo" style="width: 130pt;">
<p style="width: 60px;">Valor:</p>
<input name="valorLancamento2" id="valorLancamento2"
	onkeypress="mascara(this, moeda)" type="text" size="10" maxlength="10" />

</div>
<div class="divItemGrupo" style="width: 30px; text-align: center;">
<img width="24px" height="24px" src="imagens/iconic/png/plus-3x.png"
	title="Incluir pagamento" onclick="incluirPagamento()" /></div>

</div>

<div class="divLinhaCadastro" id="divDadosCartao" style="display: none;">

<div class="divItemGrupo" style="width: 220px;">
	<p style="width: 70px;">Cliente:</p>
	<input style="text-transform:none;" id="nomeClienteCartao" type="text" size="20" maxlength="60"  />
</div>
<div class="divItemGrupo" style="width: 220px;">
	<p style="width: 70px;">Num cartão:</p>
	<input id="numCartao" type="text" size="15" maxlength="50" onkeypress="mascara(this, numeros)" />
</div>
<div class="divItemGrupo" style="width: 120pt;">
<p style="width: 70px;">Validade:</p>
<input id="validadeCartao" type="text" size="5"
	maxlength="5" onkeypress="mascara(this, data)" /></div>
<div class="divItemGrupo" style="width: 100pt;">
<p style="width: 60px;">Código:</p>
<input id="codigoSegurancaCartao"
	onkeypress="mascara(this, numeros)" type="text" size="5" maxlength="4" />

</div>

</div>

<s:iterator value="#session.movimentoPagamentoList" status="row">
	<div class="divLinhaCadastro" style="background-color: white;">
	<div class="divItemGrupo" style="width: 220px; text-align: right;">
	<s:property value="tipoLancamentoEJB.descricaoLancamento" /></div>
	<div class="divItemGrupo" style="width: 155pt; text-align: right;">
	<s:property value="numDocumento" /></div>
	<div class="divItemGrupo" style="width: 175pt; text-align: right;">
	<s:property value="valorLancamento" /></div>
	<div class="divItemGrupo" style="width: 30px; text-align: center;">
	<img width="24px" height="24px" src="imagens/iconic/png/x-3x.png"
		title="Excluir pagamento"
		onclick="excluirPagamento('<s:property value="#row.index" />')" /></div>
	</div>
</s:iterator></div>

</div>

</div>
</div>
<!-- Final checkout-->


<script type="text/javascript"> 
        
        
        
        
        
        $(function() {
            
               $(window).load( function () { 
                   <s:if test='%{#request.abrirPopupExtrato == "true"}'>
                       openExtrato();
                   </s:if>
                   
                   <s:if test='%{#request.abrirPopupLancamento == "true"}'>
                       openLancamento('<s:property value="idxCliente" />', nomeHospede);
                   </s:if>
                   <s:if test='%{#request.abrirPopupCheckout == "true"}'>
                       openCheckout();
                   </s:if>
                   
                   <s:if test='%{#request.abrirPopupNotaHospedagem == "true"}'>
                       abrirNotaHospedagem();
                   </s:if>
                   <s:if test='%{#request.abrirRPS == true}'>
                       abrirRPS();
                   </s:if>

                   <s:if test='%{#request.abrirPopupDevolucao == "true"}'>
	                    openDevolucao('<s:property value="idxCliente"/>');
	    	         </s:if>
	                <s:if test='%{#request.abrirPopupMiniPDV == "true"}'>
		               openMiniPDV('<s:property value="idxCliente"/>' , nomeHospede);
		           </s:if>
	                <s:if test='%{#request.abrirPopupReciboPagamento == "true"}'>
		               gerarReciboPagamento();
		           </s:if>
		           <s:if test='%{#request.abrirPopupNotaFiscal == "true"}'>
	                 abrirNotaFiscal();
         		    </s:if>
  		           <s:if test='%{#request.abrirCupomFiscal == "true"}'>
	                 abrirCupomFiscal();
	       		    </s:if>
		           <s:if test='%{#request.finalizarCupomFiscal == "true"}'>
	                 finalizaCupomFiscal();
    	   		    </s:if>
	             
					$('#idPontoVenda1').css('disabled','<s:property value="#request.PDVReadonly" />');
         
               } );
                    

	        
		$("div.divMovCheckoutBody").sortable({
			connectWith: '.divMovCheckoutBody',
                        

                        stop: function(ev,ui){
                            calcularValores();
                          
                        } 
                        
                        
		}).disableSelection();
                calcularValores();
                $(".chkValue").click(calcularValores);

                $(".chkTodos").click(
                        function() { 
                            idDivBody = this.id.substring(3);
                            newValue = this.checked;
                            $("div[id='"+idDivBody+"'] input:checkbox").attr('checked',newValue);
                            //total = $("div[id='"+idDivBody+"'] input:checkbox").length;
                            //for (chk=0; chk < total; chk++){
                            //  $("div[id='"+idDivBody+"'] input:checkbox")[chk].checked = newValue;
                            // }
                            calcularValores();

                        }
                );
                
                $(".chkObjTodos").click(
                        function() { 
                            idDivBody = this.id.substring(3);
                            newValue = this.checked;
                            $("div[id='divObj"+idDivBody+"'] input:checkbox").attr('checked',newValue);
                             calcularValoresObjetos( idDivBody );
                        }
                );
                
                $(".chkObj").click(
                        function() { 
                            idx = this.id.substring(6).split(";")[0];
                            calcularValoresObjetos( idx );
                        }
                );

                $("#qtdePrato1").keyup(
                        function() {
                            total = 0.0;
                            unitario = parseFloat(  $('#valor1').val().replace(".","").replace(",",".") ); 
							qtde = parseFloat(  $('#qtdePrato1').val().replace(".","").replace(",",".") );
                            total = unitario * qtde;
                            $( '#valorPrato1').val(arredondaFloat(total).toString().replace(".",","));
                        }


                );
                
	});
        
        function calcularValoresObjetos( idx ){
        
                 total = $("div[id='divObj"+idx+"'] input:checkbox").length;
                 valor = 0.0;
                 for (chk=0; chk < total-1; chk++){
                    objCheck = $("div[id='divObj"+idx+"'] input:checkbox")[chk];
                    if (objCheck.checked){
                        id = objCheck.id.split(";");
				
                        val = id[2];
                        if (val.indexOf(".") > 0 && val.substring(val.indexOf(".")+1).length == 3  && val.substring(val.indexOf(".")+1).charAt(2)=='5' ){
    						val = val.substring(0, val.indexOf(".")+3 );	
    					}
			  
			  val = parseFloat( val );
                       valor += Math.round(val * 100)/100;
                    }
                 }
                 strValor = valor.toString().replace(".",",");
                 $("#valorLancamento3").val (arredondaFloat(valor).toString().replace(".",","));
                            
        }

        
        function calcularValores(){

				var issHotel = $('#issHotel').val();
				var taxaHotel = $('#taxaHotel').val();
				var taxaCheckout = $('#taxaCheckout').val();

				var taxaCheckin  = $('#taxaCheckin').val();
				var issCheckin  = $('#issCheckin').val();
				
                for (var x = 0;x < $('div.divMovCheckoutBody').length; x++){
                                grupo = $('div.divMovCheckoutBody')[x];
                                itens = $(grupo).sortable('toArray');
                                total = 0;
                                parcial = 0;
                                mov = "";
                                movParcial = "";
                                valorBrutoIssTotal = 0.0;
                                valorBrutoTaxaTotal = 0.0;
                                valorBrutoIssParcial = 0.0;
                                valorBrutoTaxaParcial = 0.0;
                                for (var y =0;y<itens.length;y++){
                                    curr = itens[y];
                                    splitValue = curr.split(";");
                                    val = splitValue[2];
                                    val = parseFloat( val );
                                    //iss	
									if (splitValue[3] == 'S'){
										valorBrutoIssTotal += val;
									}
									//taxa	
									if (splitValue[4] == 'S'){
										valorBrutoTaxaTotal += val;
									}
                                   total += Math.round(val  * 100)/100; 

                                    mov += splitValue[1]+";";
                                    if ($("div[id='"+curr+"'] input:checked").length ==1 ){
                                        movParcial += splitValue[1]+";";
                                        parcial += Math.round(parseFloat( val ) * 100)/100;
                                        //iss	
    									if (splitValue[3] == 'S'){
    										valorBrutoIssParcial += val;
    									}
    									//taxa	
    									if (splitValue[4] == 'S'){
    										valorBrutoTaxaParcial += val;
    									}                                             
                                    }

                                }
								
								if (taxaCheckout == "S" && issCheckin == "S" && issHotel > 0.0){
									total += Math.round((valorBrutoIssTotal * issHotel / 100) *100)/100;
									parcial += Math.round((valorBrutoIssParcial * issHotel / 100)*100)/100;
								}
								
								if (taxaCheckout == "S" && taxaCheckin == "S" && taxaHotel > 0.0){
									total += Math.round((valorBrutoTaxaTotal * taxaHotel / 100) *100)/100;
									parcial += Math.round((valorBrutoTaxaParcial * taxaHotel / 100) * 100) /100;
								}
								
                                fmt = Math.round(total * 100)/100;
                                $( '#'+ $(grupo).attr('id') +'Total label' ).text("R$ " + arredondaFloat(fmt).toString().replace(".",","));
                                fmt = Math.round(parcial * 100)/100;
                                $( '#'+ $(grupo).attr('id') +'Parcial label' ).text("R$ " + arredondaFloat(fmt).toString().replace(".",","));
                                $('.movimentos').get(x).value = mov;
                                $('.movimentosParcial').get(x).value = movParcial;
                          }
        }
                
</script>