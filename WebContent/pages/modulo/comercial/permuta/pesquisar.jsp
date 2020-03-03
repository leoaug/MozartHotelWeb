<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterPermuta!prepararInclusao.action" namespace="/app/comercial" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterPermuta!prepararAlteracao.action" namespace="/app/comercial" />';
		submitForm( vForm );
	}
    
    
currentMenu = "permuta";
with(milonic=new menuname("permuta")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarPermuta!pesquisar.action" namespace="/app/comercial" theme="simple" >
  	<s:hidden name="entidade.idPermuta" id="chave"/>
    <div class="divFiltroPaiTop">Permuta</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="PERMUTA_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Relatório de PERMUTA" 
    			 condicao="idPermuta;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="chave" idAlteracaoValue="idPermuta" 
    			 urlRetorno="pages/modulo/comercial/permuta/pesquisar.jsp">
    			 
        <duques:column labelProperty="Sigla"    		propertyValue="sigla"      	style="width:100px;"/>
        <duques:column labelProperty="Nº Contrato"      propertyValue="idPermuta"	style="width:120px;" />
        <duques:column labelProperty="Empresa"       	propertyValue="nomeEmpresa"	style="width:300px;" />
        <duques:column labelProperty="Descrição"       	propertyValue="descricao"	style="width:300px;" />
        <duques:column labelProperty="Dt início"       	propertyValue="dataInicio"	style="width:120px;text-align:center;" />
        <duques:column labelProperty="Dt fim"       	propertyValue="dataFim"		style="width:120px;text-align:center;" />
        <duques:column labelProperty="Qtde Diária"      propertyValue="qtdeDiaria"	style="width:120px;text-align:center;" />
        <duques:column labelProperty="Valor Diária"     propertyValue="valorDiaria"	style="width:120px;text-align:right;" />
    </duques:grid>
    
</s:form>
