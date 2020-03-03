<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterNoticia!prepararInclusao.action" namespace="/app/comercial" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterNoticia!prepararAlteracao.action" namespace="/app/comercial" />';
		submitForm( vForm );
	}
    
    
currentMenu = "noticia";
with(milonic=new menuname("noticia")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarNoticia!pesquisar.action" namespace="/app/comercial" theme="simple" >
  	<s:hidden name="entidade.id.idNoticia" id="idAlteracao"/>
    <div class="divFiltroPaiTop">Notícias</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="NOTICIA_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Relatório de notícias" 
    			 condicao="" current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="id.idNoticia" 
    			 urlRetorno="pages/modulo/comercial/cadastroWeb/noticia/pesquisar.jsp">
    			 
        <duques:column labelProperty="Título"    		propertyValue="titulo"      style="width:300px;"/>
        <duques:column labelProperty="Data"       		propertyValue="data"		style="width:120px;" />
        <duques:column labelProperty="Ativo"       		propertyValue="ativo"		style="width:100px;text-align:center;" />
    </duques:grid>
    
</s:form>
