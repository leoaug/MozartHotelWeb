<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterBanco!prepararInclusao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterBanco!prepararAlteracao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "banco";
	with(milonic=new menuname("banco")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>



  <s:form action="pesquisarBanco!pesquisar.action" namespace="/app/sistema" theme="simple" >
  	
  	<s:hidden name="entidade.idBanco" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Banco</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="BANCO_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar"  imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />    
    	    <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
        </div>
    
    
    </div>
    
    
 <!-- grid -->
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Banco" 
    			 condicao="idBanco;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idBanco" 
    			 urlRetorno="pages/modulo/sistema/banco/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Número Banco" 		propertyValue="numeroBanco"    	style="width:150px;"/>
        <duques:column labelProperty="Banco"      			propertyValue="banco" 			style="width:250px;" />
        <duques:column labelProperty="Nome Banco"       	propertyValue="nomeFantasia"  	style="width:250px;" />		 
        
                
    </duques:grid>
    
</s:form>

