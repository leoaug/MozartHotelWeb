<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTipoItem!prepararInclusao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTipoItem!prepararAlteracao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "tipoItem";
	with(milonic=new menuname("tipoItem")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarTipoItem!pesquisar.action" namespace="/app/operacional" theme="simple" >
  	<s:hidden name="entidade.idTipoItem" id="idAlteracao"> </s:hidden>
  	<div class="divFiltroPaiTop">Tipo Item</div>    
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Tipo Item" 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idTipoItem" 
    			 urlRetorno="pages/modulo/operacional/tipoItem/pesquisar.jsp">
    	
    	<duques:column labelProperty="Nome Tipo" 		 					propertyValue="nomeTipo"  style="width:250px;"/>
    	<duques:column labelProperty="Apelido" 		 						propertyValue="apelido"  style="width:90px;"/>
    	        
    </duques:grid>
    
</s:form>