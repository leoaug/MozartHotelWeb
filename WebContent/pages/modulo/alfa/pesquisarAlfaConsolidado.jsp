<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script>
    function init(){
        
    }

    function upload(){
        vForm = document.forms[0];
        vForm.action = '<s:url action="manter!prepararUpload.action" namespace="/app/alfa" />';
        vForm.submit();
    }
</script>


<s:form action="pesquisarConsolidada!pesquisaConsolidada.action"
	namespace="/app/alfa" theme="simple">
	<div class="divFiltroPaiTop">Consolidação</div>
	<div id="divFiltroPai" class="divFiltroPai">
	<div id="divFiltro" class="divFiltro"><duques:filtro
		tableName="EMPRESA_SEGURADORA_CONSOLIDADO" titulo="" /></div>
	</div>
	<div id="divMeio" class="divMeio">
	<div id="divOutros" class="divOutros"></div>

	<div id="divBotao" class="divBotao"><duques:botao
		label="Pesquisar"
		imagem="imagens/iconic/png/magnifying-glass-3x.png"
		onClick="submitForm(document.forms[0]);" /> <span style="display: none">
	<duques:botao label="Upload" style="width:100px"
		imagem="imagens/upload.png" onClick="upload();" /> </span></div>
	</div>

	<!-- grid -->
	<duques:grid colecao="listaPesquisa"
		titulo="Relatório de consolidação da Alfa"
		condicao="redeHotel;eq;RIO;reservaSemCheckin" current="obj"
		idAlteracao="idSeguradora" idAlteracaoValue="idSeguradora"
		urlRetorno="pages/modulo/alfa/pesquisarAlfaConsolidado.jsp">
		<duques:column labelProperty="Rede de Hotel" propertyValue="redeHotel"
			style="width:200px;" />
		<duques:column labelProperty="Hotel" propertyValue="hotel"
			style="width:200px;" grouped="true" />
		<duques:column labelProperty="Vigência" propertyValue="vigencia"
			style="width:100px;text-align:center;" grouped="true" />
		<duques:column labelProperty="Vr. Seguro" propertyValue="vlSeguro"
			style="width:100px;text-align:right;" />
		<duques:column labelProperty="Qtde Diária" propertyValue="qtdeDiaria"
			style="width:100px;text-align:right;" math="sum" />
		<duques:column labelProperty="Total Seguro"
			propertyValue="vlTotalSeguro" style="width:120px;text-align:right;"
			math="sum" />
		<duques:column labelProperty="Vr. Manut." math="sum"
			propertyValue="vlManutencao" style="width:140px;text-align:right;" />
		<duques:column labelProperty="Qtde Apto" propertyValue="qtdeApto" math="sum"
			style="width:100px;text-align:right;" />
		<duques:column labelProperty="Total Manut."
			propertyValue="vlTotalManutencao"
			style="width:120px;text-align:right;" math="sum" />
		<duques:column labelProperty="Vr. Datacenter" math="sum"
			propertyValue="vlDatacenter" style="width:160px;text-align:right;" />
		<duques:column labelProperty="Total Datacenter"
			propertyValue="vlTotalDatacenter"
			style="width:140px;text-align:right;" math="sum" />
		<duques:column labelProperty="Total a pagar"
			propertyValue="vlTotalPagar" style="width:160px;text-align:right;"
			math="sum" />
	</duques:grid>

</s:form>

