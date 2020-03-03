<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterUnidadeEstoque!prepararInclusao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterUnidadeEstoque!prepararAlteracao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "unidadeEstoque";
	with(milonic=new menuname("unidadeEstoque")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarUnidadeEstoque!pesquisar.action" namespace="/app/operacional" theme="simple" >
  	<s:hidden name="entidade.idUnidadeEstoque" id="idAlteracao"> </s:hidden>
  	<div class="divFiltroPaiTop">Unidade Estoque</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Unidade Estoque" 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idUnidadeEstoque" 
    			 urlRetorno="pages/modulo/operacional/unidadeEstoque/pesquisar.jsp">
    	
    	<duques:column labelProperty="Nome Unidade" 		 							propertyValue="nomeUnidade"  			style="width:250px;"/>
    	<duques:column labelProperty="Nome Reduzido"	 		 						propertyValue="nomeUnidadeReduzido"  	style="width:140px;"/>
    	        
    </duques:grid>
    
</s:form>