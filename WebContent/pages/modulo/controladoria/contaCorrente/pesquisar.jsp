<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script>
	function init() {
	}

	function prepararInclusao() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterContaCorrente!prepararInclusao.action" namespace="/app/controladoria" />';
		submitForm(vForm);
	}

	function prepararAlteracao() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterContaCorrente!prepararAlteracao.action" namespace="/app/controladoria" />';
		submitForm(vForm);
	}

	function pesquisar() {
		vForm = document.forms[0];
		submitForm(vForm);
	}

	currentMenu = "contaCorrente";
	with (milonic = new menuname("contaCorrente")) {
		margin = 3;
		style = contextStyle;
		top = "offset=2";
		aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
		drawMenus();
	}
</script>

<s:form action="pesquisarContaCorrente!pesquisar.action"
	namespace="/app/controladoria" theme="simple">
	
	<s:hidden name="entidade.id" id="idAlteracao" />
	<div class="divFiltroPaiTop">Conta Corrente</div>
	<div id="divFiltroPai" class="divFiltroPai">
		<div id="divFiltro" class="divFiltro">
			<!-- TODO: (ContaCorrente) Verificar com relação à Conta Corrente / DICIONARIO -->
			<duques:filtro tableName="CONTA_CORRENTE_WEB" titulo="" />
		</div>
	</div>
	<div id="divMeio" class="divMeio">
		<div id="divOutros" class="divOutros"></div>
		<div id="divBotao" class="divBotao">
			<duques:botao label="Pesquisar" imagem="imagens/iconic/png/magnifying-glass-3x.png"
				onClick="pesquisar();" />
			<duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png"
				onClick="prepararInclusao();" />
		</div>
	</div>

	<!-- grid -->
	<!-- TODO: (ContaCorrente) condicao="contaCorrente;...". idContaCorrente ou numContaCorrente? -->
	<duques:grid colecao="listaPesquisa"
			titulo="Relatório de Conta Corrente"
			condicao="numContaCorrente;eq;-1;reservaSemCheckin" 
			current="obj"
			idAlteracao="idAlteracao" 
			idAlteracaoValue="idContaCorrente"
			urlRetorno="pages/modulo/controladoria/contaCorrente/pesquisar.jsp">
		<duques:column labelProperty="Conta Corrente"
			propertyValue="numContaCorrente" style="width:130px;text-align:left;" />
		<duques:column labelProperty="Banco" propertyValue="banco"
			style="width:200px;text-align:left;" />
		<duques:column labelProperty="Nome agência"
			propertyValue="nomeAgencia" style="width:150px;text-align:left;" />
		<duques:column labelProperty="Número agência"
			propertyValue="numeroAgencia" style="width:150px;text-align:left;" />
		<duques:column labelProperty="Cobrança" propertyValue="cobranca"
			style="width:90px;text-align:left;" />
		<duques:column labelProperty="Pgto" propertyValue="pagamento"
			style="width:90px;text-align:left;" />
		<duques:column labelProperty="Caixa" propertyValue="carteira"
			style="width:90px;text-align:left;" />
		<duques:column labelProperty="Histórico Crédito"
			propertyValue="historicoCredito" style="width:250px;text-align:left;" />
		<duques:column labelProperty="Histórico Débito"
			propertyValue="historicoDebito" style="width:250px;text-align:left;" />
		<duques:column labelProperty="Nome Contas REC"
			propertyValue="nomeContasRec" style="width:250px;text-align:left;" />
		<duques:column labelProperty="Nome Contas PAG"
			propertyValue="nomeContasPag" style="width:250px;text-align:left;" />
		<duques:column labelProperty="Centro custo Crédito"
			propertyValue="centroCustosRec" style="width:200px;text-align:left;" />
		<duques:column labelProperty="Centro custo Débito"
			propertyValue="centroCustosPag" style="width:200px;text-align:left;" />
	</duques:grid>
</s:form>