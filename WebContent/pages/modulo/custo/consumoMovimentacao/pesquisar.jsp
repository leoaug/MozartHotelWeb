<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterConsumoInterno!prepararInclusao.action" namespace="/app/custo" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterConsumoInterno!prepararAlteracao.action" namespace="/app/custo" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "ConsumoInterno";
	/* with(milonic=new menuname("prato")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} */ 
    
</script>
  <s:set name="menu" value="%{'SOMENTE_LEITURA'}" />
  <s:form action="pesquisarConsumoInterno!pesquisar.action" namespace="/app/custo" theme="simple" >
  	<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1 || #session.HOTEL_SESSION.idPrograma == 11}" var="isHotel" />
  	<s:hidden name="entidade.id" id="idAlteracao"> </s:hidden>
  	<div class="divFiltroPaiTop">Consumo Interno - Movimentação</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="CONSUMO_INTERNO_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
        	<duques:botao label="Pesquisar"  imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />
            <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
            <s:if test="isHotel"><duques:botao label="Relatórios" style="width:120px" imagem="imagens/iconic/png/print-3x.png" onClick="prepararRelatorio();" /></s:if>    
    	</div>
    
    </div>
    
 <!-- grid -->
    <duques:grid colecao="listaPesquisa" titulo="Pesquisa Consumo Interno Usuários" 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="entidade.id" 
    			 idAlteracaoValue="entidade.id" 
    			 urlRetorno="pages/modulo/custo/consumoMovimentacao/pesquisar.jsp">
    	
    	<duques:column labelProperty="Nome do Usuario"	 				 		propertyValue="nomeUsuario" 	style="width:160px;" grouped="true" math="count"/>
    	<duques:column labelProperty="Data"		 								propertyValue="data"    		style="width:150px; text-align:left;" format="dd/MM/yyyy" grouped="true" math="count"/>
    	<duques:column labelProperty="Ponto de Venda"		 		 			propertyValue="pontoVendaDesc"	style="width:160px; text-align: right;" grouped="true" math="count"/>
    	<duques:column labelProperty="Prato"		 		 					propertyValue="prato"			style="width:120px; text-align: left;"/>
    	<duques:column labelProperty="Núm. doc."		 		 				propertyValue="numDocumento"	style="width:120px; text-align: right;"/>
    	<duques:column labelProperty="Qtde."		 		 					propertyValue="quantidade"		style="width:100px; text-align: right;" math="sum"/>
    	<duques:column labelProperty="Custo"		 		 					propertyValue="custo"			style="width:100px; text-align: right;" />
    	<duques:column labelProperty="Custo Total"		 		 				propertyValue="custoTotal"		style="width:100px; text-align: right;" math="sum"/>
    	<duques:column labelProperty="Venda"		 		 					propertyValue="venda"			style="width:100px; text-align: right;" />
    	<duques:column labelProperty="Venda Total"		 		 				propertyValue="vendaTotal"		style="width:100px; text-align: right;" math="sum"/>
    	<duques:column labelProperty="% Custo"		 		 					propertyValue="percentualCusto"	style="width:100px; text-align: right;"/>
    	<duques:column labelProperty="Sigla"		 		 					propertyValue="sigla"		  	style="width:100px; text-align: right;"/>
    	<duques:column labelProperty="Cod. Movimento"		 		 			propertyValue="codMovimento"	style="width:150px; text-align: right;"/>
    	   
    </duques:grid>
    
</s:form>