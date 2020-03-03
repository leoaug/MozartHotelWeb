<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterCanal!prepararInclusao.action" namespace="/app/comercial" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterCanal!prepararAlteracao.action" namespace="/app/comercial" />';
		submitForm( vForm );
	}
    
    
currentMenu = "canalVenda";
with(milonic=new menuname("canalVenda")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarCanal!pesquisar.action" namespace="/app/comercial" theme="simple" >
  	<s:hidden name="entidade.idGdsCanal" id="chave"/>
    <div class="divFiltroPaiTop">Canais de Vendas</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="GDS_CANAL_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Canais de Vendas" 
    			  current="obj" 
    			 idAlteracao="chave" idAlteracaoValue="idGdsCanal" 
    			 urlRetorno="pages/modulo/comercial/canalVenda/pesquisar.jsp">
    			 
        <duques:column labelProperty="Nome Fantasia"			propertyValue="nomeFantasia"    style="width:300px;"/>
        <duques:column labelProperty="Código"       			propertyValue="codigo"			style="width:100px;" />
        <duques:column labelProperty="Ativo"       				propertyValue="ativo"			style="width:80px;text-align:center;" />
        <duques:column labelProperty="Administrador do Canal"   propertyValue="nomeAdmCanal"	style="width:300px;" />
        
    </duques:grid>
    
</s:form>
