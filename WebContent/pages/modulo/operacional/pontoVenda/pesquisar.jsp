<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterPontoVenda!prepararInclusao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterPontoVenda!prepararAlteracao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "pontoVenda";
	with(milonic=new menuname("pontoVenda")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarPontoVenda!pesquisar.action" namespace="/app/operacional" theme="simple" >
  	<s:hidden name="entidade.idPontoVenda" id="idAlteracao"> </s:hidden>
  	<div class="divFiltroPaiTop">Ponto de Venda</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="PONTO_VENDA_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Ponto Venda " 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idPontoVenda" 
    			 urlRetorno="pages/modulo/operacional/pontoVenda/pesquisar.jsp">
    	
    	<duques:column labelProperty="Nome" 		 					propertyValue="descricao"  style="width:250px;"/>
    	<duques:column labelProperty="Tipo" 		 					propertyValue="tipoPdv"  style="width:90px;"/>
    	<duques:column labelProperty="Proprietário"		 		 		propertyValue="proprietario"  	style="width:250px;"/>
    	<duques:column labelProperty="% Taxa"			 		 		propertyValue="taxaServico"  	style="width:90px;"/>
    	        
    </duques:grid>
    
</s:form>