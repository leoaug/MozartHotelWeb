<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterObjeto!prepararInclusao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterObjeto!prepararAlteracao.action" namespace="/app/operacional" />';
		submitForm( vForm );
	}
    
    
currentMenu = "obj";
with(milonic=new menuname("obj")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarObjeto!pesquisar.action" namespace="/app/operacional" theme="simple" >
  	<s:hidden name="entidade.idObjeto" id="idAlteracao"/>
    <div class="divFiltroPaiTop">Objetos</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="OBJETO_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Relatório de objetos" 
    			 condicao="idObjeto;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="idAlteracao" idAlteracaoValue="idObjeto" 
    			 urlRetorno="pages/modulo/operacional/objetos/pesquisar.jsp">
    			 
        <duques:column labelProperty="Fantasia"    		propertyValue="fantasia"      			style="width:250px;"/>
        <duques:column labelProperty="Valor"        	propertyValue="valor"					style="width:100px;text-align:right;"/>
        <duques:column labelProperty="Descrição"    	propertyValue="descricao"      			style="width:350px;"/>

    </duques:grid>
    
</s:form>

