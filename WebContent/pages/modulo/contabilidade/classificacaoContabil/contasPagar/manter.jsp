<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<style type="text/css">
.divLookup {
	background-color: rgb(247, 247, 247);
	list-style: none;
	font-family: Verdana;
	font-size: 10px;
	color: Black;
	position: absolute;
	width: 500px !important;
	border: 1px solid rgb(198, 214, 255);
	height: 150px;
	z-index: 1521;
}

.divLookup h1 {
	background-color: rgb(66, 198, 255);
	height: 20px;
	width: 500px !important;
	font-size: 12px;
	color: White;
	margin-bottom: 0px;
	margin-top: 0px;
}

.divLinhaCadastro select {
	width: 180px;
}

.divLinhaCadastro input {
	text-transform: lowercase !important;
}
</style>
<script type="text/javascript">
	window.onload = function() {

		addPlaceHolder('pagJurEjb.planoContasDebito.contaContabil');
		addPlaceHolder('pagAjuEjb.planoContasCredito.contaContabil');
		addPlaceHolder('pagComEjb.planoContasDebito.contaContabil');
		addPlaceHolder('pagForEjb.planoContasCredito.contaContabil');
	}

	function addPlaceHolder(classe) {
		document.getElementById(classe).setAttribute("placeholder",
				"ex.: digite conta reduzida, conta ou nome da conta");
	}
	function getDebito(elemento, grupo) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarClassificacaoContabilDebito?OBJ_NAME='
				+ elemento.name
				+ '&OBJ_GROUP='
				+ grupo
				+ '&OBJ_VALUE='
				+ elemento.value;
		getDataLookup500px(elemento, url, 'Debito', 'TABLE');
	}
	function getCredito(elemento, grupo) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarClassificacaoContabilCredito?OBJ_NAME='
				+ elemento.name
				+ '&OBJ_GROUP='
				+ grupo
				+ '&OBJ_VALUE='
				+ elemento.value;
		getDataLookup500px(elemento, url, 'Credito', 'TABLE');
	}

	function validarGravarCPagar() {
		erro = "";
		conector = '\0';

		if (document
				.getElementById('pagJurEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira crédito de Contas a receber' + conector;
		}
		if (document
				.getElementById('pagAjuEjb.planoContasCredito.contaContabil').value == '') {
			erro += '- Insira crédito de Juros' + conector;
		}
		if (document
				.getElementById('pagComEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira crédito de Recebimento duplicatas descontada Banco '
					+ conector;
		}
		if (document
				.getElementById('pagForEjb.planoContasCredito.contaContabil').value == '') {
			erro += '- Insira débito de Despesas financeiras ' + conector;
		}

		if (erro != '') {
			alerta(erro);
			return false;
		} else {
			gravar();
		}

	}

	function gravar() {
		submitForm(document.forms[0]);
	}

	function getDataLookup500px(obj, url, div, tipoObj) {
		objType = tipoObj;
		if (obj.value.length > 0 && obj.value.length % 3 == 0
				|| obj.value.length >= 4) {
			criarDiv(div);
			obj.disabled = true;
			conjuntoObj = div;
			currSpan = 'span' + div;
			retrieveURL(url);
			var position = $(obj).offset();
			newDiv.css('top', position.top + obj.offsetHeight);
			newDiv.css('left', position.left);
			obj.disabled = false;

		}

	}
	function criarDiv500px(obj) {
		$(document.body)
				.append(
						"<div id=\"divLookup\" class=\"divLookup\" style=\"width:500px !important ; display:none\"><h1 style=\"width:500px !important\"><p>Selecione</p> <img src=\"imagens/fecharColuna.png\" onclick=\"$('div.divLookup').slideUp('slow');\"/> </h1> <div id=\"divLookupBody\" class=\"divLookupBody\"> </div></div>");
		newDiv = $('div.divLookup');
		newDiv.css('display', 'block');
		newDiv.css('width', '500px');
		newSpan = document.createElement('SPAN');
		newSpan.id = "span" + obj;
	}

	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterClassificacaoContabilCPagar!prepararManter.action" namespace="/app/contabilidade" />';
		submitForm(vForm);
	}
</script>

<s:form namespace="/app/contabilidade"
	action="manterClassificacaoContabilCPagar!salvarClassificacaoContabil"
	theme="simple">

	<div class="divFiltroPaiTop">Contas a Pagar</div>
	<div id="divFiltroPai" class="divFiltroPai">
		<div id="divFiltro" class="divCadastro" style="height: 235%">

			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Juros - JUR -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['PAG_JUR'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="pagJurEjb.descricao"
					value="PAG_JUR" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="pagJurEjb.idClassificacaoContabil" />

				<s:if
					test="%{hashDsClassificacaoContabil['PAG_JUR'][1].indexOf('D')!=-1}">
					<s:hidden id="pagJurEjb.debito.idPlanoContas"
						name="pagJurEjb.planoContasDebito.idPlanoContas" />



					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getCredito(this, 'pagJurEjb.credito')"
								id="pagJurEjb.planoContasDebito.contaContabil"
								name="pagJurEjb.planoContasDebito.contaContabil" size="100"
								value="%{pagJurEjb.planoContasDebito.contaReduzida+' - '+pagJurEjb.planoContasDebito.contaContabil+' - '+pagJurEjb.planoContasDebito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="pagJurEjb.pis" id="pagJurEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="pagJurEjb.centroCustoDebito.idCentroCustoContabil"
								id="pagJurEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Ajustes - AJU -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['PAG_AJU'][0]" />
				</div>

				<s:hidden id="pagAjuEjb.descricao" name="pagAjuEjb.descricao"
					value="PAG_AJU" />

				<s:hidden id="pagAjuEjb.idClassificacaoContabil"
					name="pagAjuEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['PAG_AJU'][1].indexOf('D')!=-1}">

					<s:hidden id="pagAjuEjb.debito.idPlanoContas"
						name="pagAjuEjb.planoContasDebito.idPlanoContas" />



					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'pagAjuEjb.debito')"
								id="pagAjuEjb.planoContasDebito.contaContabil" size="100"
								maxlength="100" name="pagAjuEjb.planoContasDebito.contaContabil"
								value="%{pagAjuEjb.planoContasDebito.contaReduzida+' - '+pagAjuEjb.planoContasDebito.contaContabil+' - '+pagAjuEjb.planoContasDebito.nomeConta.toUpperCase()}" />
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="pagAjuEjb.centroCustoDebito.idCentroCustoContabil"
								id="pagAjuEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['PAG_AJU'][1].indexOf('C')!=-1}">
					<s:hidden id="pagAjuEjb.credito.idPlanoContas"
						name="pagAjuEjb.planoContasCredito.idPlanoContas" />

					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Crédito:</p>
							<s:textfield onblur="getCredito(this, 'pagAjuEjb.credito')"
								id="pagAjuEjb.planoContasCredito.contaContabil"
								name="pagAjuEjb.planoContasCredito.contaContabil" size="100"
								value="%{pagAjuEjb.planoContasCredito.contaReduzida+' - '+pagAjuEjb.planoContasCredito.contaContabil+' - '+pagAjuEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="pagAjuEjb.pis" id="pagAjuEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="pagAjuEjb.centroCustoCredito.idCentroCustoContabil"
								id="pagAjuEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Comissões - COM -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['PAG_COM'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="pagComEjb.descricao"
					value="PAG_COM" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="pagComEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['PAG_COM'][1].indexOf('D')!=-1}">

					<s:hidden id="pagComEjb.debito.idPlanoContas"
						name="pagComEjb.planoContasDebito.idPlanoContas" />



					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'pagComEjb.debito')"
								id="pagComEjb.planoContasDebito.contaContabil" size="100"
								maxlength="100" name="pagComEjb.planoContasDebito.contaContabil"
								value="%{pagComEjb.planoContasDebito.contaReduzida+' - '+pagComEjb.planoContasDebito.contaContabil+' - '+pagComEjb.planoContasDebito.nomeConta.toUpperCase()}" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="pagComEjb.pis" id="pagComEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="pagComEjb.centroCustoDebito.idCentroCustoContabil"
								id="pagComEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['PAG_COM'][1].indexOf('C')!=-1}">
					<s:hidden id="pagComEjb.credito.idPlanoContas"
						name="pagComEjb.planoContasCredito.idPlanoContas" />



					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Crédito:</p>
							<s:textfield onblur="getCredito(this, 'pagComEjb.credito')"
								id="pagComEjb.planoContasCredito.contaContabil"
								name="pagComEjb.planoContasCredito.contaContabil" size="100"
								value="%{pagComEjb.planoContasCredito.contaReduzida+' - '+pagComEjb.planoContasCredito.contaContabil+' - '+pagComEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="pagComEjb.pis" id="pagComEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="pagComEjb.centroCustoCredito.idCentroCustoContabil"
								id="pagComEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!--  despesas financeiras - FIN -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['PAG_FOR'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="pagForEjb.descricao"
					value="PAG_FOR" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="pagForEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['PAG_FOR'][1].indexOf('D')!=-1}">

					<s:hidden id="pagForEjb.debito.idPlanoContas"
						name="pagForEjb.planoContasDebito.idPlanoContas" />



					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'pagForEjb.debito')"
								id="pagForEjb.planoContasDebito.contaContabil" size="100"
								maxlength="100" name="pagForEjb.planoContasDebito.contaContabil"
								value="%{pagForEjb.planoContasDebito.contaReduzida+' - '+pagForEjb.planoContasDebito.contaContabil+' - '+pagForEjb.planoContasDebito.nomeConta.toUpperCase()}" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="pagForEjb.pis" id="pagForEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="pagForEjb.centroCustoDebito.idCentroCustoContabil"
								id="pagForEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['PAG_FOR'][1].indexOf('C')!=-1}">
					<s:hidden id="pagForEjb.credito.idPlanoContas"
						name="pagForEjb.planoContasCredito.idPlanoContas" />



					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Crédito:</p>
							<s:textfield onblur="getCredito(this, 'pagForEjb.credito')"
								id="pagForEjb.planoContasCredito.contaContabil"
								name="pagForEjb.planoContasCredito.contaContabil" size="100"
								value="%{pagForEjb.planoContasCredito.contaReduzida+' - '+pagForEjb.planoContasCredito.contaContabil+' - '+pagForEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="pagForEjb.pis" id="pagForEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="pagForEjb.centroCustoCredito.idCentroCustoContabil"
								id="pagForEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>


			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
					onClick="validarGravarCPagar()" />
			</div>
		</div>
	</div>
</s:form>