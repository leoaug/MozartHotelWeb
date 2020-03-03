<%@ page contentType="text/html;charset=UTF-8"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript" charset="UTF-8">

	function getPontoVendaSelecionado(elemento){
		loading();
		submitFormAjax('getPontoVendaSelecionado?'
					+ '&OBJ_VALUE=' + elemento.value,true);
 	}


	function atualizarDataRestaurante(data){
		$('#linhaRestaurante').css('display','none');

		if( data != null && data != 'null' && data != ''){
			$('#linhaRestaurante').css('display','block');
			$('#linhaRestaurante').html('Restaurante: <b>'+data+'</b>');
			$('#dataRest').val(data);
		} 
	}
	
	function getApartamento(elemento, idHidden, div) {
		url = 'app/ajax/ajax!pesquisarApartamentoHospede?OBJ_NAME='
				+ elemento.id + '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN='
				+ idHidden;
		getDataLookup(elemento, url, div, 'TABLE');
	}

	function selecionarApartamento(elemento, elementoOculto, valorTextual,
			idEntidade, idCheckin) {
		window.MozartNS.GoogleSuggest.selecionar(elemento, valorTextual,
				elementoOculto, idEntidade);
		$('#idCheckin').val(idCheckin);
	}

	function getMesa(elemento) {
		if ($("#pontoVenda").val() == '') {
			alerta('Ponto de Venda deve ser Selecionado.');
			return false;
		}

		url = 'app/ajax/ajax!pesquisarMesa?OBJ_NAME=' + elemento.id
				+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idMesa'
				+ '&OBJ_PONTO_VENDA=' + $("#pontoVenda").val();
		getDataLookupMesa(elemento, url, 'Mesa', 'TABLE');
	}
	
	function getDataLookupMesa(obj, url, div, tipoObj){
	    objType = tipoObj;
	    if (obj.value.length >= 1 ){
	        criarDiv(div);
	        obj.disabled=true;
	        conjuntoObj = div;
	        currSpan = 'span'+div;
	        retrieveURL(url);

	        var position = $(obj).offset();
	        //alert( $(obj).attr('height') );
	        //$(newDiv).css(position);
	        newDiv.css('top',position.top + obj.offsetHeight);
	        newDiv.css('left',position.left);
	        obj.disabled=false;
	        //newDiv.style.visibility='';
	        //newDiv.style.top=getTopPos(obj);
	        //newDiv.style.left=getLeftPos(obj);
	        //obj.parentNode.insertBefore(newDiv, obj.nextSibling);
	    }

	}

	function selecionarMesa(elemento, elementoOculto, valorTextual, idEntidade) {
		window.MozartNS.GoogleSuggest.selecionar(elemento, valorTextual,
				elementoOculto, idEntidade);

		idLancamentoFrame.pesquisarMovimentacao();
	}

	

	function habilitarMesa() {
		if ($("#pontoVenda").val() != '') {
			$("#mesa").attr("readOnly", false);
			$("#mesa").css('background-color', 'white');
		} else {
			$("#mesa").attr("readOnly", true);
			$("#mesa").css('background-color', 'silver');
		}
	}

	
	function habilitarFormaPagamento() {

		window.frames['idPgtoFrame'].habilitarFormaPagamento();
		
	}

	function desabilitarFormaPagamento() {
		window.frames['idPgtoFrame'].desabilitarFormaPagamento();
	}

	function bloquearCamposAposInclusao() {
		$("#pontoVenda").attr('disabled', 'disabled');
		$("#pontoVenda").css('background-color', 'silver');

		$("#tipoRefeicao").attr('disabled', 'disabled');
		$("#tipoRefeicao").css('background-color', 'silver');

		$("#apartamentoHospede").attr("readOnly", true);
		$("#apartamentoHospede").css('background-color', 'silver');

		$("#mesa").attr("readOnly", true);
		$("#mesa").css('background-color', 'silver');

		

		$("#numComanda").attr("readOnly", true);
		$("#numComanda").css('background-color', 'silver');
	}

	function desbloquearCamposAposRemocao() {
		$("#pontoVenda").attr('disabled', false);
		$("#pontoVenda").css('background-color', 'white');

		$("#tipoRefeicao").attr('disabled', false);
		$("#tipoRefeicao").css('background-color', 'white');

		$("#apartamentoHospede").attr("readOnly", false);
		$("#apartamentoHospede").css('background-color', 'white');


		$("#numPessoas").attr("readOnly", false);
		$("#numPessoas").css('background-color', 'white');

		$("#numComanda").attr("readOnly", false);
		$("#numComanda").css('background-color', 'white');
	}

	function validarParent() {
		
		
		if ($('#dataHotel').val() != $('#dataRest').val()) {
			alerta("A data do Ponto de Venda está diferente do Hotel ou do Restaurante");
			return false;
		}
		
		if ($('#pontoVenda').val() == '') {
			alerta("O campo 'Ponto de Venda' é obrigatório");
			return false;
		}

		if ($('#mesa').val() == '') {
			alerta("O campo 'Mesa' é obrigatório");
			return false;
		}		

		return true;
	}

	function getValorSaldo(){
		saldo = $("#valorSaldo").text();
		if(saldo != null && saldo != ''){
			return toFloat(saldo);
		}
		return 0.00;
	}

	function voltar() {

		vForm = document.forms[0];
		vForm.action = '<s:url action="movimentacaoPontoVenda!prepararMovimentacao.action" namespace="/app/pdv" />';
		submitForm(vForm);
	}

	$(function() {
		$(".chkTodos").click(
				function() {
					newValue = this.checked;
					$('#idLancamentoFrame').contents().find('.chk').attr(
							'checked', newValue);
					idLancamentoFrame.calcularValorParcial();
					atualizaSaldoValores();
				});
	});
	
	$(function() {
		$(".percTaxaServico").blur(
				function() {
					value= this.value;
					$('#idLancamentoFrame').contents().find('#percTaxaServico').val(value);
					idLancamentoFrame.calcularValorParcial();
					atualizaSaldoValores();
				});
	});

	function atualizaSaldoValores(){
		atualizarValores($('#valorPago').text());
	}

	function getIdMovimentosSelecionados(){

		camposMarcados = new Array();
		$('#idLancamentoFrame').contents().find('.chk:checked').each(function(){
		    camposMarcados.push($(this).val());
		});	

		return camposMarcados;
	}

	function carregarIdMovimentosPagamento(item, index){
		$("#idMovimentosPagamento").val( item ) ;
		
		var input = document.createElement("input");

		input.setAttribute("type", "hidden");

		input.setAttribute("name", "idMovimentosPagamento");
		input.setAttribute("id", "idMovimentosPagamento"+index);

		input.setAttribute("value", item);

		document.forms[0].appendChild(input);
	}

	function imprimirCupomFiscal(){
        vForm = document.forms[0];
        vForm.action = '<s:url action="manterMovimentacaoPontoVenda!prepararCupomFiscal.action" namespace="/app/pdv" />';
        submitForm( vForm );
	}
	
	function verificaCpfCnpj ( valor ) {
		 
	    // Garante que o valor é uma string
	    valor = valor.toString();
	    
	    // Remove caracteres inválidos do valor
	    valor = valor.replace(/[^0-9]/g, '');
	 
	    // Verifica CPF
	    if ( valor.length === 11 ) {
	        return validarCPF(valor);
	    } 
	    
	    // Verifica CNPJ
	    else if ( valor.length === 14 ) {
	        return validarCNPJ(valor);
	    } 
	    
	    // Não retorna nada
	    else {
	        return false;
	    }
	    
	}

	function gravar(){
		if(validarParent()){
			
			if($('#idPgtoFrame').contents().find('#divLinha').length <= 0){
				alerta("A forma de pagamento deve ser adicionada.");
				return false;
			}
			if(getValorSaldo() != 0.0){
				alerta("O Saldo precisa ser zerado para fechar a conta.");
				return false;
			}
			
			showModal("#divCpfCnpj"); 
		}
	}
	
	function finaliza(){
		
		var cpfCnpj = $("#cpfCnpj").val();
		if(cpfCnpj != null && cpfCnpj != ''){
			if(isNaN(cpfCnpj)){
				alerta("Favor digitar apenas numeros no CPF/CNPJ");
				return false;
			}
			if(!verificaCpfCnpj(cpfCnpj)){
				alerta("CPF/CNPJ inválido.");
				return false;
			}
		}
		
		$("#cpfCnpjHidden").val(cpfCnpj);
		$("#cpfCnpjHidden").val = cpfCnpj;
		
        vForm = document.forms[0];
  
        var idMovimentos = getIdMovimentosSelecionados();
    	idMovimentos.forEach(carregarIdMovimentosPagamento);
      
        desbloquearCamposAposRemocao();
        submitForm( vForm );
	}
	
	function finalizaCupomFiscal(){
		aCupomFiscal = document.appletCupomNaoFiscal;
		<s:if test="%{#session.HOTEL_SESSION.cupomfiscal == \"S\"}" >
			try{
				//IniciaFechamento(String acrescimoDesconto,String tipoAcrescimoDesconto,String valorAcrescimoDesconto);
				aCupomFiscal.IniciaFechamento("A","%",'<s:property value="#request.pTaxaServico" />');

				efetuaPagamentos();
				var message = "";
				var taxas = "";
				
				aCupomFiscal.finalizaCupomFiscal();

				<s:set scope="session" name="movimentoPagamentoCupomList" value="%{null}" /> 
			}catch(err){
				alert(err.description);
				killModal();
			}	
		</s:if>

	}

	function abrirCupomFiscal(){
		aCupomFiscal = document.appletCupomNaoFiscal;
		<s:if test="%{#session.HOTEL_SESSION.cupomfiscal == \"S\"}" >
			try{
				loading();
				
				aCupomFiscal.detectaImpressoras('<s:property value="#session.notaFiscalSession.nomeImpressora"/>');
				/*String razaoSocial, String cnpjEmpresa,
				String inscricaoEstadual, String endereco, String numero,
				String complemento, String bairro, String cidade, String uf,
				String cep, String descricaoDocumento*/
				aCupomFiscal.imprimirTexto(aCupomFiscal.imprimeCabecalho('<s:property value="#session.notaFiscalSession.dadosGerais.razaoSocial"/>',
						'<s:property value="#session.notaFiscalSession.dadosGerais.cnpj"/>','<s:property value="#session.notaFiscalSession.dadosGerais.inscricaoEstadual"/>',
						'<s:property value="#session.notaFiscalSession.dadosGerais.endereco"/>','<s:property value="#session.notaFiscalSession.dadosGerais.numero"/>',
						'<s:property value="#session.notaFiscalSession.dadosGerais.complemento"/>','<s:property value="#session.notaFiscalSession.dadosGerais.bairro"/>',
						'<s:property value="#session.notaFiscalSession.dadosGerais.cidade"/>','<s:property value="#session.notaFiscalSession.dadosGerais.uf"/>',
						'<s:property value="#session.notaFiscalSession.dadosGerais.cep"/>','<s:property value="#session.notaFiscalSession.dadosGerais.descricaoNfce"/>'));

				<s:iterator value="#session.notaFiscalSession.dadosItens" var="mov">
				
					/*String codigo, String descricao,
					  String quantidade, String valorUnidade, String valorTotal
					*/
					aCupomFiscal.imprimirTexto(aCupomFiscal.imprimeItens('<s:property value="codigo"/>', '<s:property value="descricao"/>', '<s:property value="quantidade"/>', '<s:property value="valorUnidade"/>', '<s:property value="valorTotal"/>'));
		
				</s:iterator>
				
				/*String qtdItens, String valorProdutos,
				  String valorTaxa, String valorTotal
				*/
				aCupomFiscal.imprimirTexto(aCupomFiscal.fechaItens('<s:property value="#session.notaFiscalSession.dadosResumoItensNota.quantidade"/>', 
																   '<s:property value="#session.notaFiscalSession.dadosResumoItensNota.valorProduto"/>', 
																   '<s:property value="#session.notaFiscalSession.dadosResumoItensNota.taxa"/>', 
																   '<s:property value="#session.notaFiscalSession.dadosResumoItensNota.valorTotal"/>'));
				
				<s:iterator value="#session.notaFiscalSession.dadosFormaPagamento" var="mov">
				
					/*  String descricaoLancamento,
						String valorTotal, String descricaoContingencia, String numeroNota,
						String serie, String dataEmissao, String descricaoViaConsumidor,
						String descricaoConsulteChave, String chaveAcesso,
						String descricaoProt, String aidf, String aidfData
					*/
					aCupomFiscal.imprimirTexto(aCupomFiscal.fechaPagamento('<s:property value="descricao"/>', '<s:property value="valorTotal"/>'));
		
				</s:iterator>
				
				/*
					String descricaoContingencia, String numeroNota,
					String serie, String dataEmissao, String descricaoViaConsumidor,
					String descricaoConsulteChave, String chaveAcesso,
					String descricaoProt, String aidf, String aidfData,
					String descricaoCons, String cpfCnpj
				*/
				aCupomFiscal.imprimirTexto(aCupomFiscal.fechaConta('<s:property value="#session.notaFiscalSession.dadosGerais.contingencia"/>', 
						'<s:property value="#session.notaFiscalSession.dadosGerais.numNota"/>', 
						'<s:property value="#session.notaFiscalSession.dadosGerais.serie"/>','<s:property value="#session.notaFiscalSession.dadosGerais.dataEmissao"/>',
						'<s:property value="#session.notaFiscalSession.dadosGerais.descricaoViaConsumidor"/>','<s:property value="#session.notaFiscalSession.dadosGerais.descricaoConsulte"/>',
						'<s:property value="#session.notaFiscalSession.chaveNota"/>','<s:property value="#session.notaFiscalSession.dadosGerais.decricaoProtocolo"/>',
						'<s:property value="#session.notaFiscalSession.aidf"/>','<s:property value="#session.notaFiscalSession.dadosGerais.aidfData"/>',
						'<s:property value="#session.notaFiscalSession.dadosGerais.descricaoConsumidor"/>','<s:property value="#session.notaFiscalSession.cpfCnpjConsumidor"/>'));
				
				/*String urlQrCode */
				aCupomFiscal.imprimirQrCode('<s:property value="#session.notaFiscalSession.urlQrCode"/>');
				
				
				/*String discriminacao, String orgao1,
					String orgao2, String descricaoMozart, String descricaoPdv,
					String pdv*/
				aCupomFiscal.imprimirTexto(aCupomFiscal.descricaoFinal('<s:property value="#session.notaFiscalSession.dadosGerais.discriminacao"/>', 
						'<s:property value="#session.notaFiscalSession.dadosGerais.orgao1"/>', '<s:property value="#session.notaFiscalSession.dadosGerais.orgao2"/>',
						'<s:property value="#session.notaFiscalSession.dadosGerais.descricaoCodMozart"/>','<s:property value="#session.notaFiscalSession.dadosGerais.descricaoPdv"/>',
						'<s:property value="#session.notaFiscalSession.dadosGerais.idPdv"/>'));
				
				aCupomFiscal.avancar();
				aCupomFiscal.acionarGuilhotina();
				//aCupomFiscal.fechar();
				//aCupomFiscal.abrirCupom("C:\\MOZART\\Desenvolvimento\\Files\\impressao.txt"); 
							
				//var cabecalho = aCupomFiscal.imprimeCabecalho("teste","teste2","teste2","teste","teste","teste","teste","teste","teste", "teste", "teste");
				//aCupomFiscal.imprimirTexto(cabecalho);
				
				killModal();
				
			}catch(err){
				alert(err.description);
				killModal();
			}	

		</s:if>

	}


	function efetuaPagamentos(){
		aCupomFiscal = document.appletCupomNaoFiscal;
		<s:iterator value="#session.pgtoRelSession" var="pgto">
			aCupomFiscal.efetuaPagamento('<s:property value="descricaoLancamento"/>',
										 '<s:property value="valorLancamento"/>');
		</s:iterator>
	}

	function vendeItens(){
		aCupomFiscal = document.appletCupomNaoFiscal;
		<s:iterator value="#session.movPagosSession" var="mov">
			// VendeItem(String codigo, 
			// String descricao, String aliquota,String tipoQuantidade, 
			// String cQuantidade, int iCasasDecimais,
			// String cUnitario, String tipoDesconto,
			// String desconto)
			aCupomFiscal.vendeItem('<s:property value="idPrato"/>',
					'<s:property value="nomePrato"/>','FF','I',
					'<s:property value="quantidade"/>',2,
					'<s:property value="vlUnitario"/>','$',
					'<s:property value="vlDesconto"/>');
		
		</s:iterator>
	}
	
	function atualizarValores(valorPago){
		$("#valorSaldo").css("color", "");
		if(valorPago!=null && valorPago != ''){

			valorPagar = $("#valorPagar").val();

			valorSaldo = toFloat( valorPagar ) ;
	
			vlPago = toFloat(valorPago) ;
			
			valorSaldo -=  vlPago ;
			 
			$("#valorSaldo").html(arredondaFloat((valorSaldo* 100)/100).toString().replace(".",","));
			if(valorSaldo!= 0.00){
				$("#valorSaldo").css("color", "red");
				$('.fecharConta').hide();
			}
			else{
				$('.fecharConta').show();
			}
		}else{
			$("#valorSaldo").html("");
			$('.fecharConta').hide();
		}

		$("#valorPago").html(valorPago);
		
	}


</script>



<s:form namespace="/app/pdv"
	action="manterMovimentacaoPontoVenda!gravar.action" theme="simple">
	<s:hidden name="dataHotel" id="dataHotel" />
	<s:hidden name="cpfCnpjHidden" id="cpfCnpjHidden" />
	
	<div id="divCpfCnpj" class="divCadastro" style="display: none; height: 130px; width: 300px;">
		<div class="divGrupo" style="width: 96%; height: 60px">
			<div class="divGrupoTitulo">Informe o CPF/CNPJ? (Opcional)</div>
		
			<div class="divLinhaCadastro" >
				<div class="divItemGrupo" style="width: 300px;">
					<p style="width: 95px;">CPF/CNPJ:</p>
					<s:textfield cssClass="cpfCnpj" name="cpfCnpj"
					id="cpfCnpj" onkeypress="mascara(this, numero)" size="14"
					maxlength="14" cssStyle="text-align: right;" />
				</div>
			</div>
		</div>
		<div class="divCadastroBotoes" style="width: 98%;">
			<duques:botao label="OK" imagem="imagens/iconic/png/check-4x.png" onClick="finaliza();" />
		</div>
	</div>
	
	<div class="divFiltroPaiTop">PDV </div>
	<div class="divFiltroPai">
		<div class="divCadastro" style="overflow: auto; height: 610px">
			<div class="divGrupo" style="height: 45px;">
				<div class="divGrupoTitulo">Abertura do PDV</div>

				<div class="divLinhaCadastro" style="height: 20px;">
					<div class="divItemGrupo" style="width: 260px;">
						<p style="width: 100px;">Ponto de Venda:</p>
						<s:select list="comboPontoVenda" name="pontoVenda" id="pontoVenda"
							headerKey="" headerValue="Selecione" 
							onchange="habilitarMesa();getPontoVendaSelecionado(this);"
							listValue="descricao" listKey="idPontoVenda" cssStyle="width: 150px;"/>
					</div>
					
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 70px;">Data:</p>
						<s:textfield cssClass="dataRest" name="dataRest" id="dataRest" size="10"
							maxlength="15" readonly="true" cssStyle="background-color:silver;" />
					</div>
					
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 100px;">Tipo de Refeição:</p>
						<s:select list="comboTipoRefeicao" name="tipoRefeicao"
							id="tipoRefeicao" headerKey="" headerValue="Selecione"
							listValue="descricao" listKey="idTipoRefeicao" />
					</div>

					<div class="divItemGrupo" style="width: 300px;">
						<p style="width: 80px;">Hóspede:</p>

						<s:select list="listApartamentoHospede" name="idCheckin" cssStyle="width: 200px"
							id="idCheckin" headerKey="" headerValue="Selecione" value="idCheckin"
							listValue="texto" listKey="idCheckin" />
					</div>

				</div>

			</div>
			<div class="divGrupo" style="height: 45px;">
				<div class="divGrupoTitulo">Abertura de Mesa</div>

				<div class="divLinhaCadastro" style="height: 20px;">
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 70px;">Mesa:</p>
						<s:textfield cssClass="mesa" name="mesa" id="mesa" size="10"
							maxlength="15" readonly="true" onblur="getMesa(this);"
							cssStyle="background-color:silver;" />
						<s:hidden name="idMesa" id="idMesa" />

					</div>

					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 70px;">Garçom:</p>
						<s:select list="comboGarcon" name="garcon" id="garcon"
							headerKey="" headerValue="Selecione" listValue="nomeGarcon"
							listKey="idGarcon" />
					</div>

					<div class="divItemGrupo" style="width: 250px;">
						<p style="width: 100px;">Num. Pessoas:</p>
						<s:textfield cssClass="numPessoas" name="numPessoas"
							id="numPessoas" onkeypress="mascara(this, quantidadeDecimal)"
							size="10" maxlength="10" cssStyle="text-align: right;" />
					</div>
					
					<div class="divItemGrupo" style="width: 200px;">
					<p style="width: 95px;">Num. Comanda:</p>
					<s:textfield cssClass="numComanda" name="numComanda"
						id="numComanda" onkeypress="mascara(this, numero)" size="10"
						maxlength="10" cssStyle="text-align: right;" />
				</div>

				</div>

			</div>
			<div class="divGrupo" style="height: 400px;">
				<div class="divGrupoTitulo">Movimentação</div>
				<iframe width="100%" height="250" id="idLancamentoFrame"
					name="idLancamentoFrame" scrolling="no" frameborder="0"
					marginheight="0" marginwidth="0"
					src="<s:url value="/app/pdv/include!prepararInclusao.action"/>?time=<%=new java.util.Date()%>">
				</iframe>
				<div class="divGrupo"
					style="width: 31%; margin-top: 1px; HEIGHT: 120px;">
					<div class="divLinhaCadastro" style="height: 20px; width: 99%;">
						<div class="divItemGrupo" style="width: 130px; float: left;">
							<input type="checkbox" class="chkTodos" id="chkTodos" />
							Selecionar Todos
						</div>
						<div class="divItemGrupo" style="width: 165px;">
							<p style="width: 75px;">Valor Total:</p>
							<s:textfield cssClass="valorTotal" name="valorTotal"
								id="valorTotal" onkeypress="mascara(this, moeda)" size="10"
								maxlength="10" readonly="true"
								cssStyle="text-align: right;background-color:silver;" />

						</div>

					</div>

					<div class="divLinhaCadastro" style="height: 20px; width: 99%;">
						<div class="divItemGrupo" style="width: 130px;"></div>
						<div class="divItemGrupo" style="width: 165px;">
							<p style="width: 75px;">Valor Parcial:</p>
							<s:textfield cssClass="valorParcial" name="valorParcial"
								id="valorParcial" onkeypress="mascara(this, moeda)" size="10"
								maxlength="10" readonly="true"
								cssStyle="text-align: right;background-color:silver;" />


						</div>
					</div>
					<div class="divLinhaCadastro" style="height: 20px; width: 99%;">
						<div class="divItemGrupo" style="width: 130px;">
							<p style="width: 90px;">Taxa de serviço:</p>
							<s:textfield cssClass="percTaxaServico" name="percTaxaServico"
								id="percTaxaServico" onkeypress="mascara(this, moeda)" size="1"
								maxlength="2" cssStyle="text-align: right" onblur="" />
						</div>
						<div class="divItemGrupo" style="width: 165px;">
							<p style="width: 75px;">Valor Taxa:</p>
							<s:textfield cssClass="valorTaxa" name="valorTaxa" id="valorTaxa"
								onkeypress="mascara(this, moeda)" size="10" maxlength="10"
								readonly="true"
								cssStyle="text-align: right;background-color:silver;" />

						</div>
					</div>
					<div class="divLinhaCadastro" style="height: 20px; width: 99%;">
						<div class="divItemGrupo" style="width: 130px;"></div>
						<div class="divItemGrupo" style="width: 165px;">
							<p style="width: 75px;">Val. a Pagar:</p>
							<s:textfield cssClass="valorPagar" name="valorPagar"
								id="valorPagar" onkeypress="mascara(this, moeda)" size="10"
								maxlength="10" readonly="true"
								cssStyle="text-align: right;background-color:silver;" />

						</div>
					</div>
				</div>

				<div class="divGrupo"
					style="width: 67.5%; margin-top: 1px; HEIGHT: 120px;">


					<iframe width="100%" height="95" id="idPgtoFrame"
						name="idPgtoFrame" scrolling="no" frameborder="0" marginheight="0"
						marginwidth="0"
						src="<s:url value="/app/pdv/include!prepararPagamento.action"/>?time=<%=new java.util.Date()%>">
					</iframe>
					<div class="divLinhaCadastro" style="height: 20px;">

						<div class="divItemGrupo" style="width: 195px;">
						</div>
						<div class="divItemGrupo" style="width: 65px;">
							<p style="width: 65px;">Total Pago:</p>
						</div>
						<div class="divItemGrupo" id="valorPago"
							style="width: 80px; padding-right: 10px; text-align: right;">
							<s:property value="valorPago" />
						</div>
						<div class="divItemGrupo" style="width: 65px;">
							<p style="width: 65px;">Saldo:</p>
						</div>
						<div class="divItemGrupo" id="valorSaldo"
							style="width: 80px; padding-right: 10px; text-align: right;">
							<s:property value="valorSaldo" />
						</div>
					</div>
				</div>
			</div>
			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="voltar()" />
				<div class="fecharConta"><duques:botao label="Fechar Conta" style="width: 140px;"
					imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" /></div>
			</div>

		</div>
	</div>

</s:form>

<!--Div applet cupom fiscal-->
<div id="divApplet"
	style="position: absolute; margin-left: 850px; float: right; margin-top: 30px;">
	<applet name="appletCupomNaoFiscal" id="appletCupomNaoFiscal"
		code='com.mozart.applet.CupomNaoFiscal'
		archive='<s:url value="/applet/sMozartHotelTelefonia.jar" />'
		,
        width='1' , 
        height='1'
		style="display:<s:property value="#session.HOTEL_SESSION.cupomfiscal == \"S\"?\"block\":\"none\" " />;">
		<param name="TIPO_EXECUCAO" value="2" />
	</applet>
</div>


<script type="text/javascript">
$(function() {
    
    $(window).load( function () { 
    	$('.fecharConta').hide();
    	
        <s:if test='%{#request.abrirPopupNotaFiscal == "true"}'>
          abrirNotaFiscal();
		</s:if>
        <s:if test='%{#request.abrirCupomFiscal == "true"}'>
          abrirCupomFiscal();
		</s:if>
      
	    habilitarMesa();
		$('#idPontoVenda1').css('disabled','<s:property value="#request.PDVReadonly" />');

    } );
});
</script>