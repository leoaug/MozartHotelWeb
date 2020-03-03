<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterPrato!prepararInclusao.action" namespace="/app/custo" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterPrato!prepararAlteracao.action" namespace="/app/custo" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "prato";
	with(milonic=new menuname("prato")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarPrato!pesquisar.action" namespace="/app/custo" theme="simple" >
  	<s:hidden name="entidade.id.idPrato" id="idAlteracao"> </s:hidden>
  	<div class="divFiltroPaiTop">Produto</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="PRODUTO_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Produto" 
    			 condicao="#gracValorIncompleto;eq;S;corVermelho" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idPrato" 
    			 urlRetorno="pages/modulo/custo/prato/pesquisar.jsp">
    	
    	<duques:column labelProperty="Nome Prato" 		 							propertyValue="nomePrato"  			style="width:250px;"/>
    	<duques:column labelProperty="Tipo"	 				 						propertyValue="tipo"			  	style="width:160px;"/>
    	<duques:column labelProperty="Grupo"		 		 						propertyValue="grupo"		  		style="width:160px;"/>
    	<duques:column labelProperty="Vr Custo"		 		 						propertyValue="vrCusto"		  		style="width:120px; text-align: right;"/>
    	<duques:column labelProperty="Vr Venda"		 		 						propertyValue="vrVenda"		  		style="width:120px; text-align: right;"/>
    	<duques:column labelProperty="% Custo"		 		 						propertyValue="custoPerc"		  	style="width:120px; text-align: right;"/>
    	
    	
    	        
    </duques:grid>
    
</s:form>