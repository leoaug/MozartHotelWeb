<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
	$('#linhaContasPagar').css('display','block');

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
    function relatorio() {        
        document.forms[0].action = '<s:url action="relatorioContasPagarComissao!prepararRelatorio.action" namespace="/app/financeiro" />';        
        submitForm(document.forms[0]);
    }

	function gerar(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="gerarContasPagarComissao!prepararGeracao.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

    </script>

    <%
       String titulo = "Relatório de Contas a Pagar - Comissão - gerar";
       String requestvalue = request.getParameter("filtro.filtroTipoPesquisa");
       
       if ("1".equals( requestvalue)){
           titulo = "Relatório de Contas a Pagar - Comissão - gerar";
       }else if ("2".equals( requestvalue )){
    	   titulo = "Relatório de Contas a Pagar - Comissão - geradas";
       }
    %>


  <s:form action="pesquisarContasPagarComissao!pesquisar.action" namespace="/app/financeiro" theme="simple" >
    <s:set value="%{#session.HOTEL_SESSION.idPrograma == 1}" var="isHotel" />
    <div class="divFiltroPaiTop">Comissão Agência</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="CONTAS_PAGAR_COMISSAO_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros" >
			<ul style="width: 210px; height:100%; float: left; padding: 0px; margin: 0px; list-style: none; font-size: 8pt; border-right: 1px solid black;">
				<li style="width: 100px; font-size: 8pt;float:left;"><input type="radio"
					<%=(request.getParameter("filtro.filtroTipoPesquisa")==null || "1".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":"")%>
					name="filtro.filtroTipoPesquisa" value="1" />A Gerar</li>
				<li style="width: 100px;font-size: 8pt;float:left;"><input type="radio"
					<%="2".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
					name="filtro.filtroTipoPesquisa" value="2" />Gerados</li>	
			</ul>
        </div>
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" 	imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();"/>
            <s:if test="%{(#session.filtroTipoPesquisa == \"1\" || #request.filtro.filtroTipoPesquisa == \"1\") && #session.listaPesquisa.size() > 0}">
            	<duques:botao label="Gerar" 		imagem="imagens/iconic/png/plus-3x.png" onClick="gerar();" />
            </s:if>
            <s:if test="isHotel"><duques:botao label="Relatório" 	imagem="imagens/iconic/png/print-3x.png" onClick="relatorio();" /></s:if>
        </div>
    </div>
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="<%=titulo%>" 
    			 condicao="" current="obj" 
				 urlRetorno="pages/modulo/financeiro/contasPagarComissao/pesquisar.jsp">
    	<duques:column labelProperty="Empresa"       			propertyValue="nomeEmpresa"			style="width:300px;" />
        <duques:column labelProperty="Valor Diária"         	propertyValue="valorDiaria"      	style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="% Comissão"         		propertyValue="comissao"			style="width:110px;text-align:right;"/>
        <s:if test="%{#request.filtro.filtroTipoPesquisa == \"2\"}">
			<duques:column labelProperty="Vr. Comissão"         	propertyValue="valorComissao"      	style="width:110px;text-align:right;"/>
		</s:if>
        <duques:column labelProperty="Hóspede"         			propertyValue="nomeHospede"      	style="width:300px;"/>
        <s:if test="%{#request.filtro.filtroTipoPesquisa == \"2\"}">
       		<duques:column labelProperty="Num. Nota"         		propertyValue="numNota"      		style="width:110px;text-align:right;"/>
       		<duques:column labelProperty="Dt Gerado"         		propertyValue="dataGerado"      	style="width:110px;text-align:right;"/>
       	</s:if>
        <duques:column labelProperty="Dt Saída"         		propertyValue="dataSaida"      		style="width:110px;text-align:right;"/>
        <s:if test="%{#request.filtro.filtroTipoPesquisa == \"2\"}">
        	<duques:column labelProperty="Cód Conta"        		propertyValue="idContasPagar"      	style="width:150px;text-align:right;"/>
        </s:if>
        <duques:column labelProperty="Sigla"         			propertyValue="sigla"      			style="width:110px;text-align:right;"/>  
    </duques:grid>
    
</s:form>

