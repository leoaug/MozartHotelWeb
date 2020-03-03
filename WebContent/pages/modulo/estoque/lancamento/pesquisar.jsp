<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
$('#linhaEstoque').css('display','block');
console.log($('#linhaEstoque'));

function init(){
}
   
function prepararAcao(actionName) {
	var actions = {};
	actionName = actionName || "Pesquisar";
	actions["Pesquisar"] = '<s:url action="pesquisarLancamento!pesquisar.action" namespace="/app/estoque" />';
	actions["Entrada"] = '<s:url action="entradaLancamento!prepararEntrada.action" namespace="/app/estoque" />';
	actions["Relatorio"] = '<s:url action="relatorioLancamento!prepararRelatorio.action" namespace="/app/estoque" />';
	actions["Devolucao"] = '<s:url action="entradaDevolucaoEstoque!prepararEntrada.action" namespace="/app/estoque" />';
	actions["Saida"] = '<s:url action="entradaSaidaEstoque!prepararEntrada.action" namespace="/app/estoque" />';
	executarAcao(actions[actionName]);
}
   
function executarAcao(acaoURI) {
	var obj = document.forms[0];
	obj.action = acaoURI;
	submitForm(obj);
}
   
currentMenu = "estoqueItem";
with (milonic=new menuname("estoqueItem")) {
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
} 
</script>

<s:form action="pesquisarLancamento!pesquisar.action" namespace="/app/estoque" theme="simple" >
  	<div class="divFiltroPaiTop">Estoque</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="MOVIMENTO_ESTOQUE_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros"></div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar"  imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="prepararAcao('Pesquisar');" />    
    	    <duques:botao label="Devolução" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararAcao('Devolucao');"  style="width:110px"/>
    	    <duques:botao label="Saída" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararAcao('Saida');" />
    	    <duques:botao label="Entrada" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararAcao('Entrada');" />
    	    <duques:botao label="Relatório" imagem="imagens/iconic/png/print-3x.png" onClick="prepararAcao('Relatorio');" />
        </div>
    </div>
    
 	<!-- grid -->
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Fornecedor Grupo" 
    			 current="obj" 
    			 idAlteracao="idMovEstoque" 
    			 idAlteracaoValue="idMovEstoque" 
    			 urlRetorno="pages/modulo/estoque/lancamento/pesquisar.jsp">
		<duques:column labelProperty="Item" propertyValue="nmItem" style="width:240px;" />
		<duques:column labelProperty="Tipo Movimento" propertyValue="dsTipoMovimento" style="width:130px;" />
		<duques:column labelProperty="Unid." propertyValue="dsUnidade" style="width:70px;" />
		<duques:column labelProperty="Quant." propertyValue="vlQuantidade" style="width:100px; text-align: right;" />
		<duques:column labelProperty="Vr.Unit." propertyValue="vlUnitario" style="width:100px; text-align: right;" />
		<duques:column labelProperty="Vr.Total" propertyValue="vlTotal" style="width:100px; text-align: right;" />
		<duques:column labelProperty="Centro de custo" propertyValue="dsCentroCusto" style="width:160px;" />
		<duques:column labelProperty="Fornecedor" propertyValue="nmFornecedor" style="width:250px;" />
		<duques:column labelProperty="No. documento" propertyValue="numDocumento" style="width:140px;" />
		<duques:column labelProperty="Data Lançamento" propertyValue="dtMovimento" style="width:160px;" />
		<duques:column labelProperty="Tipo Item" propertyValue="nmTipoItem" style="width:200px;" />
		<duques:column labelProperty="Mútuo" propertyValue="sglHotelMutuo" style="width:120px;" />
		<duques:column labelProperty="Porção" propertyValue="idMovEstqPorcao" style="width:120px;" />
		<duques:column labelProperty="Sigla" propertyValue="sglHotel" style="width:120px;" />
		<duques:column labelProperty="Cód.Estoque" propertyValue="idMovEstoque" style="width:120px;" />
	</duques:grid>
</s:form>
