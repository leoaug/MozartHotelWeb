<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterGrupoEconomico!prepararInclusao.action" namespace="/app/comercial" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterGrupoEconomico!prepararAlteracao.action" namespace="/app/comercial" />';
		submitForm( vForm );
	}
    
    
currentMenu = "grupoEco";
with(milonic=new menuname("grupoEco")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarGrupoEconomico!pesquisar.action" namespace="/app/comercial" theme="simple" >
  	<s:hidden name="entidade.idGrupoEconomico" id="chave"/>
    <div class="divFiltroPaiTop">Grupo econômico</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="GRUPO_ECONOMICO_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Relatório de grupo econômico" 
    			 condicao="idGrupoEconomico;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="chave" idAlteracaoValue="idGrupoEconomico" 
    			 urlRetorno="pages/modulo/comercial/grupoEconomico/pesquisar.jsp">
    			 
        <duques:column labelProperty="Sigla"    		propertyValue="sigla"      		style="width:100px;"/>
        <duques:column labelProperty="Nome"       		propertyValue="nomeGrupo"	style="width:300px;" />
        <duques:column labelProperty="Tipo"       		propertyValue="tipoGrupo"	style="width:150px;" />
    </duques:grid>
    
</s:form>

