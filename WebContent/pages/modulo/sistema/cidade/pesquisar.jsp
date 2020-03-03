<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterCidade!prepararInclusao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterCidade!prepararAlteracao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
	currentMenu = "cidade";
	with(milonic=new menuname("cidade")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarCidade!pesquisar.action" namespace="/app/sistema" theme="simple" >
  	
  	<s:hidden name="entidade.idCidade" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Procedência</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro">
            <duques:filtro tableName="CIDADE_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Procedência" 
    			 condicao="idCidade;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idCidade" 
    			 urlRetorno="pages/modulo/sistema/cidade/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Cidade"			       		propertyValue="cidade" 					style="width:250px;text-align:left;" />
        <duques:column labelProperty="Estado"	 	     			propertyValue="estado"   				style="width:200px;text-align:left;" />
        <duques:column labelProperty="UF"			       			propertyValue="uf" 						style="width:90px;text-align:left;" />
        <duques:column labelProperty="País"			       			propertyValue="pais" 					style="width:200px;text-align:left;" />
        <duques:column labelProperty="Continente"	 	     		propertyValue="continente"   			style="width:250px;text-align:left;" />
        <duques:column labelProperty="DDD"			       			propertyValue="ddd" 					style="width:90px;text-align:left;" />
        <duques:column labelProperty="DDI"			       			propertyValue="ddi" 					style="width:90px;text-align:left;" />
                      
    </duques:grid>
    
</s:form>
