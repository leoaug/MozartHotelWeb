<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterAcessoWeb!prepararInclusao.action" namespace="/app/comercial" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterAcessoWeb!prepararAlteracao.action" namespace="/app/comercial" />';
		submitForm( vForm );
	}
    
    
currentMenu = "empresaAcesso";
with(milonic=new menuname("empresaAcesso")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarAcessoWeb!pesquisar.action" namespace="/app/comercial" theme="simple" >
  	<s:hidden name="entidade.idUser" id="chave"/>
    <div class="divFiltroPaiTop">Acesso web</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="ACESSO_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Relatório de acessos" 
    			 condicao="idUser;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="chave" idAlteracaoValue="idUser" 
    			 urlRetorno="pages/modulo/comercial/acessoWeb/pesquisar.jsp">
    			 
        <duques:column labelProperty="Nome"    			propertyValue="nome"      	style="width:300px;"/>
        <duques:column labelProperty="E-mail"       	propertyValue="email"		style="width:250px;" />
        <duques:column labelProperty="Master"       	propertyValue="master"		style="width:100px;text-align:center;" />
        <duques:column labelProperty="Ativo"       		propertyValue="ativo"		style="width:100px;text-align:center;" />
        <duques:column labelProperty="Dt validade"      propertyValue="dataValidade"style="width:120px;text-align:center;" />
        <duques:column labelProperty="Empresa"       	propertyValue="nomeFantasia"style="width:350px;" />
    </duques:grid>
    
</s:form>
