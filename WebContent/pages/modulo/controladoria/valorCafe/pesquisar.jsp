<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterValorCafe!prepararInclusao.action" namespace="/app/controladoria" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterValorCafe!prepararAlteracao.action" namespace="/app/controladoria" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "valorCafe";
	with(milonic=new menuname("valorCafe")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarValorCafe!pesquisar.action" namespace="/app/controladoria" theme="simple" >
  	
  	<s:hidden name="entidade.idValorCafe" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Valor do café</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="VALOR_CAFE_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Valor de Café " 
    			 condicao="idValorCafe;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idValorCafe" 
    			 urlRetorno="pages/modulo/controladoria/valorCafe/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Data"			 		propertyValue="data"    		style="width:150px;"/>
        <duques:column labelProperty="Valor café" 			propertyValue="valorCafe" 		style="width:100px; text-align:right;" />
        <duques:column labelProperty="Tipo pensao"	 		propertyValue="tipoPensao"    	style="width:150px; text-align:right;"/>        
        
                
    </duques:grid>
    
</s:form>