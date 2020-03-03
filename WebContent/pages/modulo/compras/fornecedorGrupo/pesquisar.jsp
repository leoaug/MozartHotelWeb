<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterFornecedorGrupo!prepararInclusao.action" namespace="/app/compras" />';
		submitForm( vForm );
    }
	 
	

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterFornecedorGrupo!prepararAlteracao.action" namespace="/app/compras" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "fornecedorGrupo";
	with(milonic=new menuname("fornecedorGrupo")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarFornecedorGrupo!pesquisar.action" namespace="/app/compras" theme="simple" >
  	<s:hidden name = "entidade.idFornecedorGrupo" id="idAlteracao"/>
  	<div class="divFiltroPaiTop">Fornecedor Grupo</div>    
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Fornecedor Grupo" 
    			 condicao="idFornecedorGrupo;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idFornecedorGrupo" 
    			 urlRetorno="pages/modulo/compras/fornecedorGrupo/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Descrição"    			 propertyValue="descricao"		 		style="width:160px;" />
        
        
    </duques:grid>
    
</s:form>
