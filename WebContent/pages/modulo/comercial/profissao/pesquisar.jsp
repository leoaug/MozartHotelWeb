<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterProfissao!prepararInclusao.action" namespace="/app/comercial" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterProfissao!prepararAlteracao.action" namespace="/app/comercial" />';
		submitForm( vForm );
	}
    
    
currentMenu = "profissao";
with(milonic=new menuname("profissao")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarProfissao!pesquisar.action" namespace="/app/comercial" theme="simple" >
  	<s:hidden name="entidade.idProfissao" id="chave"/>
    <div class="divFiltroPaiTop">Profissão</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="PROFISSAO_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Relatório de profissão" 
    			 condicao="idProfissao;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="chave" idAlteracaoValue="idProfissao" 
    			 urlRetorno="pages/modulo/comercial/profissao/pesquisar.jsp">
    			 
        <duques:column labelProperty="Profissão"       	propertyValue="profissao"	style="width:300px;" />
    </duques:grid>
    
</s:form>

