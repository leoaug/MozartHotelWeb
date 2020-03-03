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

		addPlaceHolder('estEstEjb.planoContasDebito.contaContabil');
		addPlaceHolder('estForEjb.planoContasCredito.contaContabil');
	};

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

	function validarGravarEstoque() {
		erro = "";
		conector = '\0';

		if (document
				.getElementById('estEstEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira Débito de Estoque '
					+ conector;
		}
		if (document
				.getElementById('estForEjb.planoContasCredito.contaContabil').value == '') {
			erro += '- Insira Crédito de Fornecedores ' + conector;
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
		vForm.action = '<s:url action="manterClassificacaoContabilEstoque!prepararManter.action" namespace="/app/contabilidade" />';
		submitForm(vForm);
	}
</script>

<s:form namespace="/app/contabilidade"
	action="manterClassificacaoContabilEstoque!salvarClassificacaoContabil"
	theme="simple">

	<div class="divFiltroPaiTop">Estoque</div>
	<div id="divFiltroPai" class="divFiltroPai">
		<div id="divFiltro" class="divCadastro" style="height: 235%">

						<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Juros - JUR -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['EST_EST'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="estEstEjb.descricao"
					value="EST_EST" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="estEstEjb.idClassificacaoContabil" />

				<s:if
					test="%{hashDsClassificacaoContabil['EST_EST'][1].indexOf('D')!=-1}">
					<s:hidden id="estEstEjb.debito.idPlanoContas"
						name="estEstEjb.planoContasDebito.idPlanoContas" />



					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getCredito(this, 'estEstEjb.credito')"
								id="estEstEjb.planoContasDebito.contaContabil"
								name="estEstEjb.planoContasDebito.contaContabil" size="100"
								value="%{estEstEjb.planoContasDebito.contaReduzida+' - '+estEstEjb.planoContasDebito.contaContabil+' - '+estEstEjb.planoContasDebito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="estEstEjb.pis" id="estEstEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="estEstEjb.centroCustoDebito.idCentroCustoContabil"
								id="estEstEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!--  despesas financeiras - FIN -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['EST_FOR'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="estForEjb.descricao"
					value="EST_FOR" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="estForEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['EST_FOR'][1].indexOf('D')!=-1}">

					<s:hidden id="estForEjb.debito.idPlanoContas"
						name="estForEjb.planoContasDebito.idPlanoContas" />



					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'estForEjb.debito')"
								id="estForEjb.planoContasDebito.contaContabil" size="100"
								maxlength="100" name="estForEjb.planoContasDebito.contaContabil"
								value="%{estForEjb.planoContasDebito.contaReduzida+' - '+estForEjb.planoContasDebito.contaContabil+' - '+estForEjb.planoContasDebito.nomeConta.toUpperCase()}" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="estForEjb.pis" id="estForEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="estForEjb.centroCustoDebito.idCentroCustoContabil"
								id="estForEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['EST_FOR'][1].indexOf('C')!=-1}">
					<s:hidden id="estForEjb.credito.idPlanoContas"
						name="estForEjb.planoContasCredito.idPlanoContas" />



					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Crédito:</p>
							<s:textfield onblur="getCredito(this, 'estForEjb.credito')"
								id="estForEjb.planoContasCredito.contaContabil"
								name="estForEjb.planoContasCredito.contaContabil" size="100"
								value="%{estForEjb.planoContasCredito.contaReduzida+' - '+estForEjb.planoContasCredito.contaContabil+' - '+estForEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="estForEjb.pis" id="estForEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="estForEjb.centroCustoCredito.idCentroCustoContabil"
								id="estForEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>

			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
					onClick="validarGravarEstoque()" />
			</div>
		</div>
	</div>
</s:form>