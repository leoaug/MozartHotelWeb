<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function relatorio() {        
        document.forms[0].action = '<s:url action="relatorio!prepararRelatorio.action" namespace="/app/caixa" />'        
        submitForm(document.forms[0]);
 	}
    
    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterMiniPDV!prepararInclusao.action" namespace="/app/caixa" />';
		submitForm( vForm );
    }
	    
    	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "";
	with(milonic=new menuname("nada")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarMiniPDV!pesquisar.action" namespace="/app/caixa" theme="simple" >
  	
  	<div class="divFiltroPaiTop">Mini PDV</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="MINI_PDV_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar"  imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />    
    	    <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
    	      <duques:botao label="Relatório" imagem="imagens/iconic/png/print-3x.png" onClick="relatorio();" />
        </div>
    
    </div>
    
<!-- grid -->
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Mini PDV " 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idMiniPdv" 
    			 urlRetorno="pages/modulo/checkout/miniPDV/pesquisar.jsp">
    	
    	<duques:column labelProperty="Mini Pdv" 		 		propertyValue="idMiniPdv"  					style="width:150px;"/>
    	<duques:column labelProperty="Movimento Apto"	 		propertyValue="idMovimentoApartamento"    	style="width:150px;"/>	 
        <duques:column labelProperty="Nº Apto"			 		propertyValue="numApartamento"    			style="width:120px;"/>
        <duques:column labelProperty="Nome PV" 					propertyValue="nomePontoVenda" 				style="width:250px; text-align:left;" />
        <duques:column labelProperty="Checkin"	 				propertyValue="idCheckin"	    			style="width:150px; text-align:left;"/>
        <duques:column labelProperty="Hóspede"	 				propertyValue="hospede"   					style="width:250px;"/> 
        <duques:column labelProperty="Data"		 				propertyValue="data"    					style="width:150px; text-align:left;" format="dd/MM/yyyy"/>
         <duques:column labelProperty="Nome Prato"	 			propertyValue="nomePrato"	    			style="width:200px; text-align:left;"/>
        <duques:column labelProperty="Qtde"	 					propertyValue="qtde"   						style="width:80px; text-align:center;"/>
        <duques:column labelProperty="Valor Total"		 		propertyValue="vlTotal"    					style="width:100px; text-align:left;"/>        
    	
                
    </duques:grid>
    
</s:form>
