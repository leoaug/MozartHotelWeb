<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTipoApartamento!prepararInclusao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTipoApartamento!prepararAlteracao.action" namespace="/app/operacional" />';
		submitForm( vForm );
	}
    
    
currentMenu = "tipoApto";
with(milonic=new menuname("tipoApto")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarTipoApartamento!pesquisar.action" namespace="/app/operacional" theme="simple" >
  	<s:hidden name="entidade.idTipoApartamento" id="tipoApto"/>
    <div class="divFiltroPaiTop">Tipo de Apartamento</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="TIPO_APARTAMENTO_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Relatório de tipo de apartamento" 
    			 condicao="bcIdTipoApartamento;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="tipoApto" idAlteracaoValue="bcIdTipoApartamento" 
    			 urlRetorno="pages/modulo/operacional/tipoApartamento/pesquisarTipoApartamento.jsp">
    			 
        <duques:column labelProperty="Sigla"    		propertyValue="bcFantasia"      			style="width:100px;"/>
        <duques:column labelProperty="Tipo Apto"        propertyValue="bcTipoApartamento"			style="width:200px;"/>
        <duques:column labelProperty="Descrição"       	propertyValue="bcDescricaoApartamento"	style="width:300px;" />
    </duques:grid>
    
</s:form>

