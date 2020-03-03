<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	jQuery(function($) {
		$("#contaContabil").mask('?<s:property value="#session.HOTEL_SESSION.redeHotelEJB.formatoConta"/>');
	});

	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarContaCorrente!prepararPesquisa.action" namespace="/app/controladoria" />';
		submitForm(vForm);
	}

	function getBanco(elemento, idElementoHidden) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarBanco?'
				+ 'OBJ_NAME='
				+ elemento.name
				+ '&OBJ_GROUP='
				+ idElementoHidden
				+ '&OBJ_VALUE='
				+ elemento.value;
		getDataLookup500px(elemento, url, 'Debito', 'TABLE');
	}
	
	function getConta(elemento, grupo, valorDebitoCredito, sincConta, idCampoContaCorrente) {
		var debitoCredito="Credito";

		if(valorDebitoCredito == 'C'){
			debitoCredito = 'Credito';
		} else if(valorDebitoCredito == 'D'){
			debitoCredito = 'Debito';
		}
		
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarClassificacaoContabil'+ debitoCredito +'?OBJ_NAME='
				+ elemento.name
				+ '&OBJ_GROUP='
				+ grupo
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&SINC_CONTA='
				+ sincConta
				+ '&OBJ_CONTA_ID='
				+ idCampoContaCorrente
				;
		getDataLookup500px(elemento, url, debitoCredito, 'TABLE');
	}

	window.onload = function() {
		addPlaceHolder('.planoContas');

		<s:if test="%{operacaoRealizada}">
			parent.reset();
			parent.alerta('<s:property value="mensagemPai" />');
		</s:if>
		<s:elseif test="%{mensagemPai != null && mensagemPai != \"\"}">
			parent.alerta('<s:property value="mensagemPai" />');
		</s:elseif>
		
	};

	function addPlaceHolder(classe) {
		$( classe).attr("placeholder","ex.: digite conta reduzida, conta ou nome da conta");
	}
	
	function gravar() {
		if ($("input[name='entidade.banco']").val() == '') {
			alerta('O campo "Banco" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.nomeAgencia']").val() == '') {
			alerta('O campo "Nome agência" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.numeroAgencia']").val() == '') {
			alerta('O campo "Número agência" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.numContaCorrente']").val() == '') {
			alerta('O campo "Conta corrente" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.flooting']").val() == '') {
			alerta('O campo "Flooting" é obrigatório.');
			return false;
		}
		submitForm(document.forms[0]);
	}
</script>

<s:form namespace="/app/controladoria"
	action="manterContaCorrente!gravarContaCorrente.action" theme="simple">
	<s:hidden name="alteracao" />
	<s:hidden name="possuiPagamento" />
	<s:hidden name="possuiRecebimento" />
	<s:hidden name="possuiCarteira" />
	
	<div class="divFiltroPaiTop">Conta Corrente</div>
	<div class="divFiltroPai">
		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 200px;">
				<div class="divGrupoTitulo">Dados</div>
				
				<s:hidden name="entidade.id" />

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 600px;">
						<p style="width: 100px;">Banco:</p>
						<s:textfield onblur="getBanco(this, 'entidade.bancoEJB.idBanco')"
							id="dsBanco" name="dsBanco"
							value="%{entidade.bancoEJB.numeroBanco+' - '+entidade.bancoEJB.banco+' - '+entidade.bancoEJB.nomeFantasia}"
							size="50" maxlength="100" />
						<s:hidden id="entidade.bancoEJB.idBanco"
							name="entidade.bancoEJB.idBanco" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 195px;">
						<p style="width: 100px;">Número Agência:</p>
						<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"
							name="entidade.numeroAgencia" id="" size="10" />
					</div>

					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 10px;">&nbsp;-&nbsp;</p>
						<s:textfield onkeypress="mascara(this, numeros)" maxlength="2"
							name="entidade.digitoAgencia" id="" size="2" />
					</div>

					<div class="divItemGrupo" style="width: 350px;">
						<p style="width: 100px;">Nome Agência:</p>
						<s:textfield onkeydown="toUpperCase(this)" onkeyup="toUpperCase(this)" 
							onblur="toUpperCase(this)" maxlength="10"
							name="entidade.nomeAgencia" id="" size="25" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 195px;">
						<p style="width: 100px;">Conta Corrente:</p>
						<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"
							name="entidade.numContaCorrente" id="" size="10" />
					</div>

					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 10px;">&nbsp;-&nbsp;</p>
						<s:textfield onkeypress="mascara(this, numeros)" maxlength="2"
							name="entidade.digitoConta" id="" size="2" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<s:if test='%{possuiPagamento=="S" && alteracao!="S"}'>
						<div class="divItemGrupo" style="width: 200px; color: blue;">
							<p style="width: 100px;">Pagamento:</p>
							<s:hidden name="entidade.pagamento" />
							Não
						</div>
					</s:if>
					<s:else>
						<div class="divItemGrupo" style="width: 200px">
							<p style="width: 100px;">Pagamento:</p>
							<s:select list="#session.LISTA_CONFIRMACAO"
								onchange="verificaPagamento(this.value)" cssStyle="width:55px"
								id="pagamento" name="entidade.pagamento" listKey="id"
								listValue="value">
							</s:select>
						</div>
					</s:else>

					<s:if test='%{possuiRecebimento=="S" && alteracao!="S"}'>
						<div class="divItemGrupo" style="width: 175px; color: blue;">
							<p style="width: 100px;">Recebimento:</p>
							<s:hidden name="entidade.cobranca" />
							Não
						</div>
					</s:if>
					<s:else>
						<div class="divItemGrupo" style="width: 175px">
							<p style="width: 100px;">Recebimentos:</p>
							<s:select list="#session.LISTA_CONFIRMACAO"
								onchange="verificaCobranca(this.value)" cssStyle="width:55px"
								id="pagamento" name="entidade.cobranca" listKey="id"
								listValue="value">
							</s:select>

						</div>
					</s:else>

					<s:if test='%{possuiCarteira=="S" && alteracao!="S"}'>
						<div class="divItemGrupo" style="width: 175px; color: blue;">
							<p style="width: 100px;">Caixa:</p>
							<s:hidden name="entidade.carteira" />
							Não
						</div>
					</s:if>
					<s:else>
						<div class="divItemGrupo" style="width: 175px">
							<p style="width: 100px;">Caixa:</p>
							<s:select list="#session.LISTA_CONFIRMACAO"
								onchange="verificaCarteira(this.value)" cssStyle="width:55px"
								id="pagamento" name="entidade.carteira" listKey="id"
								listValue="value">
							</s:select>
						</div>
					</s:else>

					<div class="divItemGrupo" style="width: 180px">
						<p style="width: 90px;">Fluxo de caixa:</p>
						<s:select list="#session.LISTA_CONFIRMACAO"
							onchange="verificaFluxoCaixa(this.value)" cssStyle="width:55px"
							id="pagamento" name="entidade.fluxoCaixa" listKey="id"
							listValue="value">
						</s:select>
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 100px;">Nº último cheque:</p>
						<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"
							name="entidade.ultimoCheque" id="" size="10" />
					</div>
					<div class="divItemGrupo" style="width: 175px;">
						<p style="width: 100px;">Flooting:</p>
						<s:textfield onkeypress="mascara(this, numeros)" maxlength="2"
							name="entidade.flooting" id="" size="5" />
					</div>
					<div class="divItemGrupo" style="width: 175px;">
						<p style="width: 100px;">Espécie Docum.:</p>
						<s:textfield onkeypress="" maxlength="2"
							name="entidade.especieDocumento" id="entidade.numCarteira"
							size="5" />
					</div>
					<div class="divItemGrupo" style="width: 180px;">
						<p style="width: 90px;">Num. Carteira:</p>
						<s:textfield onkeypress="" maxlength="10"
							name="entidade.numCarteira" id="entidade.numCarteira" size="9" />
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 115px;">Cód Cob. Bradesco:</p>
						<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"
							name="entidade.codigoBradesco" id="entidade.codigoBradesco"
							size="9" />
					</div>
				</div>
			</div>

			<div class="divGrupo" style="height: 100px; width: 99%;">
				<div class="divGrupoTitulo">Classificação Contábil</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo">
						<p style="width: 100px;">Conta contábil:</p>
						<s:hidden name="planoContaDebCred.idPlanoContas"
							id="planoContaDebCred.idPlanoContas" />
						<s:textfield
							onblur="getConta(this, 'planoContaDebCred', 'D', 'false','');"
							id="planoContaDebCred.nomeConta" class="planoContas"
							name="planoContaDebCred.nomeConta" size="50"
							cssStyle="width:280px" maxlength="100" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo">
						<p style="width: 100px;">Centro custo</p>
						<s:select list="centroCustoList" cssStyle="width:280px"
							name="entidade.idCentroCustoContabilD"
							listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
							headerKey="" headerValue="Selecione">
						</s:select>
					</div>
				</div>
			</div>

			<div class="divGrupo" style="height: 120px; width: 99%;">
				<div class="divGrupoTitulo">Instrução Boleto</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 49.5%">
						<s:textfield onkeypress="" maxlength="60" name="instrucao"
							id="instrucao01" cssStyle="width: 95%"
							value="%{configBloqueteList[0].descricao}" />
					</div>
					<div class="divItemGrupo" style="width: 49.5%">
						<s:textfield onkeypress="" maxlength="60" name="instrucao"
							id="instrucao02" cssStyle="width: 95%"
							value="%{configBloqueteList[1].descricao}" />
					</div>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 49.5%">
						<s:textfield onkeypress="" maxlength="60" name="instrucao"
							id="instrucao03" cssStyle="width: 95%"
							value="%{configBloqueteList[2].descricao}" />
					</div>
					<div class="divItemGrupo" style="width: 49.5%">
						<s:textfield onkeypress="" maxlength="60" name="instrucao"
							id="instrucao04" cssStyle="width: 95%"
							value="%{configBloqueteList[3].descricao}" />
					</div>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 49.5%">
						<s:textfield onkeypress="" maxlength="60" name="instrucao"
							id="instrucao05" cssStyle="width: 95%"
							value="%{configBloqueteList[4].descricao}" />
					</div>
					<div class="divItemGrupo" style="width: 49.5%">
						<s:textfield onkeypress="" maxlength="60" name="instrucao"
							id="instrucao06" cssStyle="width: 95%"
							value="%{configBloqueteList[5].descricao}" />
					</div>
				</div>
			</div>

			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
					onClick="gravar()" />
			</div>
		</div>
	</div>
</s:form>