<%@ page contentType="text/html; charset=iso-8859-1" %>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script>
	function init() {

	}

	function prepararRelatorio() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="relatorioAuditoria!prepararRelatorio.action" namespace="/app/auditoria" />';
		submitForm(vForm);
	}


	function prepararInclusao() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterAuditoria!prepararInclusao.action" namespace="/app/auditoria" />';
		submitForm(vForm);
	}
	
	function pesquisar() {
		vForm = document.forms[0];
		submitForm(vForm);
	}

	function alterar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterAuditoria!prepararAlteracao.action" namespace="/app/auditoria" />';
		submitForm(vForm);
	}

	currentMenu = "audit";
	with (milonic = new menuname("audit")) {
		margin = 3;
		style = contextStyle;
		top = "offset=2";
		aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:alterar();");
		drawMenus();
	}
</script>


<s:form action="pesquisarAuditoria!pesquisar.action"
	namespace="/app/auditoria" theme="simple">
	<s:hidden name="entidade.idMovimentoApartamento" id="chave" />
	<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1}" var="isHotel" />
	<div class="divFiltroPaiTop">Movimentos</div>
	<div id="divFiltroPai" class="divFiltroPai">
	<div id="divFiltro" class="divFiltro"><duques:filtro
		tableName="AUDITORIA_WEB" titulo="" /></div>
	</div>
	<div id="divMeio" class="divMeio">
		<div id="divOutros" class="divOutros"></div>

		<div id="divBotao" class="divBotao">
			<duques:botao label="Pesquisar"
			imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />
			
			<s:if test="isHotel"><duques:botao label="Relatórios" style="width:120px"
			imagem="imagens/iconic/png/print-3x.png" onClick="prepararRelatorio();" /></s:if>
			
		</div>
	</div>

	<!-- grid -->
	<duques:grid colecao="listaPesquisa" titulo="Relatório de movimentos"
		condicao="idMovimentoApartamento;eq;-1;reservaSemCheckin"
		current="obj" idAlteracao="chave"
		idAlteracaoValue="idMovimentoApartamento"
		urlRetorno="pages/modulo/auditoria/pesquisar.jsp">
    			 
        <duques:column labelProperty="Num apto" 		propertyValue="numApartamento"  style="width:100px;" />
		<duques:column labelProperty="Documento" 		propertyValue="numDocumento" 	style="width:210px;" />
		<duques:column labelProperty="Nota" 			propertyValue="numNota" 		style="width:150px;" />
		<duques:column labelProperty="Usuário" 			propertyValue="usuarioStr" 		style="width:150px;" />
		
		<duques:column labelProperty="Grupo" 			propertyValue="grupoLancamento"  	style="width:100px;text-align:center;" grouped="true" />
		<duques:column labelProperty="Sub-grupo" 		propertyValue="subGrupoLancamento"  style="width:120px;text-align:center;" grouped="true" />
		<duques:column labelProperty="Descrição" 		propertyValue="descricaoLancamento" style="width:200px;" grouped="true" />
		<duques:column labelProperty="Receita checkout" propertyValue="receitaCheckout" 	style="width:150px;text-align:center;" grouped="true" />

		<duques:column labelProperty="Qtde Adultos" 	propertyValue="qtdeAdultos"  		style="width:120px;text-align:center;" math="sum" />
		<duques:column labelProperty="Qtde Café" 		propertyValue="qtdeCafe"  			style="width:120px;text-align:center;" math="sum" />
		<duques:column labelProperty="Qtde MAP" 		propertyValue="map"  				style="width:120px;text-align:center;" math="sum" />
		<duques:column labelProperty="Qtde FAP" 		propertyValue="fap"  				style="width:120px;text-align:center;" math="sum" />

		<duques:column labelProperty="Data lançamento" 	propertyValue="dataLancamento"  style="width:150px;text-align:center;" grouped="true" />
		<duques:column labelProperty="Hora lançamento"	propertyValue="horaLancamento"  style="width:180px;text-align:center;" format="dd/MM/yyyy HH:mm:ss" math="count" />
		<duques:column labelProperty="Valor"			propertyValue="valorLancamento" style="width:110px;text-align:right;" math="sum" />
		<duques:column labelProperty="Quem paga" 		propertyValue="quemPaga" 		style="width:110px;" />
		<duques:column labelProperty="Tipo" 			propertyValue="debitoCredito" 	style="width:110px;" />
		
	</duques:grid>

</s:form>