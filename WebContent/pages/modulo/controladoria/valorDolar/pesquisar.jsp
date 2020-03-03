<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterValorDolar!prepararInclusao.action" namespace="/app/controladoria" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterValorDolar!prepararAlteracao.action" namespace="/app/controladoria" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "valorDolar";
	with(milonic=new menuname("valorDolar")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarValorDolar!pesquisar.action" namespace="/app/controladoria" theme="simple" >
  	
  	<s:hidden name="entidade.idValorDolar" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Cotação da Moeda</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="VALOR_DOLAR_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />    
    	    <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
        </div>
    
    
    </div>
    
    
 <!-- grid -->
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Cotação da moeda " 
    			 condicao="idMoeda;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idMoeda" 
    			 urlRetorno="pages/modulo/controladoria/valorDolar/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Data"			 		propertyValue="data"    		style="width:150px;"/>
        <duques:column labelProperty="Valor dólar" 			propertyValue="valorDolar" 		style="width:100px; text-align:right;" />
        <duques:column labelProperty="Símbolo"		 		propertyValue="simbolo"    		style="width:100px; text-align:right;"/>        
        <duques:column labelProperty="Nome Moeda"	 		propertyValue="nomeMoeda"  		style="width:120px; text-align:right;"/>
                
    </duques:grid>
    
</s:form>

