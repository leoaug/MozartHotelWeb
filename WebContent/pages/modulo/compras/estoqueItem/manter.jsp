<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarEstoqueItem!prepararPesquisa.action" namespace="/app/compras" />';
		submitForm(vForm);
	}

	function validarItens() {

		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEstoqueItem!validarItens.action" namespace="/app/compras" />';
		submitForm(vForm);

	}
	function validarCentroCusto(valor) {

		if (valor == "S") {

			$("#divCentroCusto").attr("display", "block");

		} else {

			$("#divCentroCusto").attr("display", "none");
			$("#centroCusto").val("");

		}

	}

	function gravar() {

		if ($("input[name='entidade.estoqueMaximo']").val() == '') {
			alerta('Campo "Estoque Máx" é obrigatório.');
			return false;
		}
		if ($("input[name='entidade.estoqueMinimo']").val() == '') {
			alerta('Campo "Estoque Mín" é obrigatório.');
			return false;
		}

		if ($("input[name='entidadeRede.nomeItem']").val() == '') {
			alerta('Campo "Descrição" é obrigatório.');
			return false;
		}

		if ($("#centroCusto").val() == '' && $("#direto").val() == 'S') {
			alerta('Campo "Centro Custo" é obrigatório para o item direto.');
			return false;
		}

		if ($("#centroCusto").val() != '' && $("#direto").val() == 'N') {
			alerta('Campo "Centro Custo" só é utilizado para item direto igual a Não.');
			return false;
		}

		submitForm(document.forms[0]);

	}

	function getConta(elemento, grupo, valorDebitoCredito, sincConta,
			idCampoContaCorrente, ativoPassivo) {
		var debitoCredito = "Credito";

		if (valorDebitoCredito == 'C') {
			debitoCredito = 'Credito';
		} else if (valorDebitoCredito == 'D') {
			debitoCredito = 'Debito';
		}

		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarClassificacaoContabil'
				+ debitoCredito
				+ '?OBJ_NAME='
				+ elemento.name
				+ '&OBJ_GROUP='
				+ grupo
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&SINC_CONTA='
				+ sincConta 
				+ '&OBJ_CONTA_ID=' 
				+ idCampoContaCorrente
				+ '&OBJ_ATIVO_PASSIVO_VALUE=' 
				+ ativoPassivo;
		getDataLookup500px(elemento, url, debitoCredito, 'TABLE');
	}

	function selecionarFiscalCodigo(elemento, elementoOculto, valorTextual,
			idEntidade) {
		window.MozartNS.GoogleSuggest.selecionar(elemento, valorTextual,
				elementoOculto, idEntidade);
	}
	function getFiscalCodigo(elemento) {
		url = 'app/ajax/ajax!obterFiscalCodigos?OBJ_NAME=' + elemento.id
				+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idFiscalCodigo';
		getDataLookup(elemento, url, 'FiscalCodigo', 'TABLE');
	}

	function getItem(elemento, grupo) {

		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarItem'
				+ '?OBJ_NAME=' + elemento.name + '&OBJ_GROUP=' + grupo
				+ '&OBJ_VALUE=' + elemento.value;
		getDataLookup500px(elemento, url, "Item", 'TABLE');
	}
	function getTipoItem(elemento, grupo) {

		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarTipoItem'
				+ '?OBJ_NAME=' + elemento.name + '&OBJ_GROUP=' + grupo
				+ '&OBJ_VALUE=' + elemento.value;
		getDataLookup500px(elemento, url, "TipoItem", 'TABLE');
	}

	function habilitaDesativaAliquotas(pObject) {
		var txt = pObject.options[pObject.selectedIndex].innerHTML;
		var codigo = txt.split(" - ")[0];

		if (codigo == '1') {
			document.getElementById("idAliquotasDentro").disabled = false;
			document.getElementById("idAliquotasFora").disabled = false;
		} else {
			document.getElementById("idAliquotasDentro").selectedIndex = 0;
			document.getElementById("idAliquotasDentro").disabled = true;
			document.getElementById("idAliquotasFora").selectedIndex = 0;
			document.getElementById("idAliquotasFora").disabled = true;

		}
	}

	window.onload = function() {

		addPlaceHolder('.item', "ex.: digite a descrição do item");
		addPlaceHolder('.tipoItem', "ex.: digite a descrição do tipo de item");
		addPlaceHolder('.fiscalCodigo',
				"ex.: digite a descrição do tipo de item");
		addPlaceHolder('.planoContas',
				"ex.: digite conta reduzida, conta ou nome da conta");
	};

	function addPlaceHolder(classe, msg) {

		$(classe).attr("placeholder", msg);

	}

	function desabilitarDadosItemsRede() {
		document.getElementById("tipoItem").disabled = true;
	}
</script>

<s:form namespace="/app/compras"
	action="manterEstoqueItem!gravar.action" theme="simple">

	<s:hidden name="entidadeRede.id.idRedeHotel"
		value="%{#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel}" />
	<s:hidden name="entidade.id.idHotel"
		value="%{#session.HOTEL_SESSION.idHotel}" />

	<div class="divFiltroPaiTop">Item Estoque</div>
	<div class="divFiltroPai">


		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 180px;">
				<div class="divGrupoTitulo">Rede</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 510px;">
						<p style="width: 160px;">Item:</p>

						<s:hidden name="entidadeRede.id.idItem"
							id="entidadeRede.id.idItem" />

						<s:textfield onblur="toUpperCase(this);getItem(this, 'entidadeRede.id');" 
							id="entidadeRede.nomeItem"
							name="entidadeRede.nomeItem" size="50" cssStyle="width:280px"
							maxlength="100" cssClass="item" />

					</div>
					<div class="divItemGrupo" style="width: 370px;">
						<p style="width: 100px;">Unidade Compra:</p>
						<s:select list="unidadeEstoqueList" cssStyle="width:100px"
							name="entidadeRede.unidadeEstoqueCompraEJB.idUnidadeEstoque"
							listKey="idUnidadeEstoque" listValue="nomeUnidade"
							disabled="%{#session.USER_ADMIN eq \"FALSE\" && not #session.ATIVAR_CAMPOS_REDE }">
						</s:select>
					</div>
				</div>


				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 510px;">
						<p style="width: 160px;">Tipo:</p>

						<s:select list="tipoItemList" cssStyle="width:285px"
							name="entidadeRede.tipoItemEJB.idTipoItem"
							id="entidadeRede.tipoItemEJB.idTipoItem" listKey="idTipoItem"
							listValue="nomeTipo"
							disabled="%{#session.USER_ADMIN eq \"FALSE\" && not #session.ATIVAR_CAMPOS_REDE }"
							headerKey="" headerValue="Selecione">

						</s:select>



					</div>

					<div class="divItemGrupo" style="width: 370px;">
						<p style="width: 100px;">Uni. Requisição:</p>
						<s:select list="unidadeEstoqueList" cssStyle="width:100px"
							name="entidadeRede.unidadeEstoqueRequisicaoJB.idUnidadeEstoque"
							listKey="idUnidadeEstoque" listValue="nomeUnidade"
							disabled="%{#session.USER_ADMIN eq \"FALSE\" && not #session.ATIVAR_CAMPOS_REDE }">
						</s:select>
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 510px;">
						<p style="width: 160px;">Conta Despesa/Imobilizado:</p>
						<s:hidden name="entidadeRede.contaContabilEJB.idPlanoContas"
							id="entidadeRede.contaContabilEJB.idPlanoContas" />

						<s:textfield
							onblur="getConta(this, 'entidadeRede.contaContabilEJB', 'D', 'false','','');"
							id="entidadeRede.contaContabilEJB.dsContaContabil"
							cssClass="planoContas"
							name="entidadeRede.contaContabilEJB.dsContaContabil" size="50"
							cssStyle="width:280px" maxlength="100"
							disabled="%{#session.USER_ADMIN eq \"FALSE\" && not #session.ATIVAR_CAMPOS_REDE }" />



					</div>
					<div class="divItemGrupo" style="width: 370px;">
						<p style="width: 100px;">Uni. Estoque:</p>
						<s:select list="unidadeEstoqueList" cssStyle="width:100px"
							name="entidadeRede.unidadeEstoqueRedeEJB.idUnidadeEstoque"
							listKey="idUnidadeEstoque" listValue="nomeUnidade"
							disabled="%{#session.USER_ADMIN eq \"FALSE\" && not #session.ATIVAR_CAMPOS_REDE }">
						</s:select>
					</div>

				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 510px;">
						<p style="width: 160px;">Conta Estoque Ativo:</p>
						<s:hidden name="entidadeRede.planoContaEJB.idPlanoContas"
							id="entidadeRede.planoContaEJB.idPlanoContas" />

						<s:textfield
							onblur="getConta(this, 'entidadeRede.planoContaEJB', 'D', 'false','', 'A');"
							id="entidadeRede.planoContaEJB.dsContaContabil"
							cssClass="planoContas"
							name="entidadeRede.planoContaEJB.dsContaContabil" size="50"
							cssStyle="width:280px" maxlength="100"
							disabled="%{#session.USER_ADMIN eq \"FALSE\" && not #session.ATIVAR_CAMPOS_REDE }" />

					</div>
					<div class="divItemGrupo" style="width: 370px;">
						<p style="width: 100px;">Cód. NCM:</p>

						<s:textfield id="entidadeRede.codNcm" name="entidadeRede.codNcm"
							size="8" maxlength="8"
							disabled="%{#session.USER_ADMIN eq \"FALSE\" && not #session.ATIVAR_CAMPOS_REDE }" />

					</div>
				</div>
			</div>

			<div class="divGrupo" style="height: 280px;">
				<div class="divGrupoTitulo">Unidade</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 310px;">
						<p style="width: 120px;">É controlado no PDV:</p>
						<s:select list="#session.LISTA_CONFIRMACAO" cssStyle="width:80px"
							name="entidade.controlado" listKey="id" listValue="value">
						</s:select>

					</div>

					<div class="divItemGrupo" style="width: 210px;">
						<p style="width: 100px;">Compra Direta:</p>
						<s:select onchange="validarCentroCusto(this.value)"
							list="#session.LISTA_CONFIRMACAO" cssStyle="width:80px"
							id="direto" name="entidade.direto" listKey="id" listValue="value">
						</s:select>

					</div>


					<div id="divCentroCusto" class="divItemGrupo" style="width: 310px;">
						<p style="width: 80px;">Centro Custo:</p>
						<s:select list="centroCustoContabilList" cssStyle="width:200px"
							name="entidade.idCentroCusto" id="centroCusto"
							listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
							headerKey="" headerValue="Selecione">
						</s:select>

					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 310px;">
						<p style="width: 120px;">Estoque Mín.:</p>
						<s:textfield maxlength="10" name="entidade.estoqueMinimo" id=""
							size="10" />
					</div>

					<div class="divItemGrupo" style="width: 210px;">
						<p style="width: 100px;">Estoque Máx.:</p>
						<s:textfield maxlength="10" name="entidade.estoqueMaximo" id=""
							size="10" />
					</div>
				</div>


				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 510px;">
						<p style="width: 120px;">CFOP:</p>

						<s:hidden name="entidade.idFiscalCodigo" id="idFiscalCodigo" />

						<s:textfield type="text" onblur="getFiscalCodigo(this);"
							id="descricaoFiscalCodigo"
							name="entidade.fiscalCodigoEJB.descricao" size="50"
							cssStyle="width:369px" maxlength="100" cssClass="fiscalCodigo" />

					</div>
				</div>

				<s:hidden name="entidade.imobilizado" />
				<s:hidden name="entidade.geraEtiqueta" />

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
<script>
	validarCentroCusto($("#direto").val());

	
</script>