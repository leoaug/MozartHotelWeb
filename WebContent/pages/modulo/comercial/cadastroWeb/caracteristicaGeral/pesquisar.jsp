<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterCaracteristicaGeral!prepararInclusao.action" namespace="/app/comercial" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterCaracteristicaGeral!prepararAlteracao.action" namespace="/app/comercial" />';
		submitForm( vForm );
	}
    
    
currentMenu = "manterCaracteristicaGeral";
with(milonic=new menuname("manterCaracteristicaGeral")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarCaracteristicaGeral!pesquisar.action" namespace="/app/comercial" theme="simple" >
  	<s:hidden name="entidade.idCaracteristicasGerais" id="chave"/>
    <div class="divFiltroPaiTop">Características Web</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="CARACT_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />
            <s:if test="%{(#session.listaPesquisa.size() lt idiomaList.size())}">
	            <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />           
            </s:if>
        </div>
        
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Características Web" 
    			 condicao="idCaracteristicasGerais;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="chave" idAlteracaoValue="idCaracteristicasGerais" 
    			 urlRetorno="pages/modulo/comercial/cadastroWeb/caracteristicaGeral/pesquisar.jsp">
        <duques:column labelProperty="Idioma"       	propertyValue="idioma.descricao"		style="width:150px;" />
    </duques:grid>
    
</s:form>
