<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterMudanca!prepararInclusao.action" namespace="/app/mudanca" />';
		submitForm( vForm );
    }

    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterMudanca!prepararAlteracao.action" namespace="/app/mudanca" />';
		submitForm( vForm );
    }

currentMenu = "mudanca";
with(milonic=new menuname("mudanca")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Detalhar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarMudanca!pesquisar.action" namespace="/app/mudanca" theme="simple" >
  	<input type="hidden" name="entidade.idMudanca" id="idAlteracao"/>
    <div class="divFiltroPaiTop">Solicitação de mudança</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="SOLICITACAO_MUDANCA" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Relatório solicitação de mudança" 
    			 condicao="" current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idMudanca" 
    			 urlRetorno="pages/modulo/mudanca/pesquisar.jsp">
    			 
        <duques:column labelProperty="Cód. Mudança"   	propertyValue="idMudanca"      style="width:115px;"/>
        <duques:column labelProperty="Sistema"    		propertyValue="dsSistema"      style="width:150px;"/>
        <duques:column labelProperty="Título"    		propertyValue="dsTitulo"   	   style="width:250px;"/>
        <duques:column labelProperty="Caminho"    		propertyValue="dsCaminho"      style="width:300px;"/>
        <duques:column labelProperty="Prioridade"    	propertyValue="dsPrioridade"   style="width:110px;"/>
        <duques:column labelProperty="Status"    		propertyValue="dsStatus"  	   style="width:150px;"/>
        <duques:column labelProperty="Data"    			propertyValue="data"  		   style="width:150px;" format="dd/MM/yyyy HH:mm:ss" />
        <duques:column labelProperty="Criado Por"    	propertyValue="criadaPor"      style="width:150px;"/>
        <duques:column labelProperty="Responsável"     	propertyValue="responsavel"    style="width:150px;"/>
        
    </duques:grid>
    
</s:form>

