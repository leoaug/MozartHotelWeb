<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterSetorPatrimonio!prepararInclusao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterSetorPatrimonio!prepararAlteracao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
	currentMenu = "setorPatrimonio";
	with(milonic=new menuname("setorPatrimonio")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarSetorPatrimonio!pesquisar.action" namespace="/app/rede" theme="simple" >
  	
  	<s:hidden name="entidade.idSetorPatrimonio" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Setor Patrimônio</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="SETORPATRIMONIO_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Setor de Patrimônio" 
    			 condicao="idSetorPatrimonio;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idSetorPatrimonio" 
    			 urlRetorno="pages/modulo/rede/setorPatrimonio/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Setor de Patrimônio"     propertyValue="descricao" 		style="width:400px;" />
        <duques:column labelProperty="Nome Fantasia"     	   propertyValue="nomeFantasia" 	style="width:250px;" />
        
    </duques:grid>
    
</s:form>
