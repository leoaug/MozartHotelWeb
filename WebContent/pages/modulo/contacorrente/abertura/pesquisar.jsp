<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
currentMenu = "menu";
with(milonic=new menuname("menu")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:alterarCheckin();");
drawMenus(); 
} 
	function pesquisa() {
		vForm = document.forms[0];
		submitForm(vForm);
	}
	function prepararInclusao() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterAbertura!prepararInclusaoAbertura.action" namespace="/app/contacorrente" />';
		submitForm(vForm);
	}

function alterarCheckin(){
    
        loading();
        vForm = document.forms[0];
        vForm.action = '<s:url action="manterAbertura!prepararAlteracao.action" namespace="/app/contacorrente" />';
        vForm.submit();
   }
</script>


<s:form action="pesquisar!pesquisarAbertura.action"
	namespace="/app/contacorrente" theme="simple">
	<s:hidden name="entidade.idCheckin" id="idCheckin"></s:hidden>
	<div class="divFiltroPaiTop">Abertura de Conta</div>
	<div id="divFiltroPai" class="divFiltroPai">
		<div id="divFiltro" class="divFiltro">
			<duques:filtro tableName="CONTA_CORRENTE_GERAL" titulo="" />
		</div>
	</div>
	<div id="divMeio" class="divMeio">
		<div id="divOutros" class="divOutros" style="width: 460px;"></div>

		<div id="divBotao" class="divBotao">
			<duques:botao label="Pesquisar" style="width:100px"
				imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisa();" />

			<duques:botao label="Novo" style="width:100px"
				imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
		</div>
	</div>
	<!-- grid -->
	<duques:grid colecao="listaPesquisa" titulo="Contas Correntes"
		condicao="" current="obj" idAlteracaoValue="bcIdCheckin" idAlteracao="idCheckin"
		urlRetorno="pages/modulo/contabilidade/classificacaoContabil/padrao/pesquisar.jsp">

		<duques:column labelProperty="Conta Corrente" propertyValue="gracNumApto"
			style="text-align:right;width:170px; " />
		<duques:column labelProperty="Empresa" propertyValue="gracNomeFantasiaEmpresaRede"
			style="width:270px; " />
		<duques:column labelProperty="Observações" propertyValue="gracObsrvacoesCheckin"
			style="width:250px; " />
		<duques:column labelProperty="Loc. da Conta" propertyValue="bcIdCheckin"
			style="text-align:right;width:150px; " />
		<duques:column labelProperty="Unidade" propertyValue="gracSiglaHotel"
			style="width:170px; " />

	</duques:grid>

</s:form>