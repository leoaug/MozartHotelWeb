<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterUsuarioConsumoInterno!prepararInclusao.action" namespace="/app/custo" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterUsuarioConsumoInterno!prepararAlteracao.action" namespace="/app/custo" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "UsuarioConsumoInterno";
	 with(milonic=new menuname("UsuarioConsumoInterno")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	}  
    
</script>

  <s:form action="pesquisarUsuarioConsumoInterno!pesquisar.action" namespace="/app/custo" theme="simple" >
  	<s:hidden name="entidade.id" id="idAlteracao"> </s:hidden>
  	<div class="divFiltroPaiTop">CI - Usuários</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="USUARIOS_CONSUMO_INTERNO_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Pesquisa Consumo Interno Usuários" 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="codUsuario" 
    			 urlRetorno="pages/modulo/custo/consumo/pesquisar.jsp">
    	
    	<duques:column labelProperty="Sigla" 		 						propertyValue="sigla"  			style="width:250px;"/>
    	<duques:column labelProperty="Nome do Usuario"	 				 			propertyValue="nomeUsuario" style="width:250px;"/>
    	<duques:column labelProperty="Ativo"		 		 				propertyValue="ativoDesc"		style="width:120px;"/>
    	<duques:column labelProperty="Centro de Custo"		 		 				propertyValue="centroCustoDesc"		style="width:160px; text-align: right;"/>
    	<duques:column labelProperty="Validade Inicial"		 		 				propertyValue="validadeInicial"		style="width:120px; text-align: right;"/>
    	<duques:column labelProperty="Validade Final"		 		 				propertyValue="validadeFinal"		style="width:120px; text-align: right;"/>
    	<duques:column labelProperty="Alcoolica"		 		 						propertyValue="alcoolica"		  	style="width:100px; text-align: right;"/>
    	<duques:column labelProperty="Pensão"		 		 					propertyValue="pensao"		style="width:100px; text-align: right;"/>
    	<duques:column labelProperty="Cód Usuário"		 		 					propertyValue="codUsuario"		  	style="width:100px; text-align: right;"/>
    	   
    </duques:grid>
    
</s:form>