<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterMoeda!prepararInclusao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterMoeda!prepararAlteracao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "moeda";
	with(milonic=new menuname("moeda")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>



  <s:form action="pesquisarMoeda!pesquisar.action" namespace="/app/rede" theme="simple" >
  	
  	<s:hidden name="entidade.idMoeda" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Moeda</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="MOEDA_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Moeda" 
    			 condicao="idMoeda;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idMoeda" 
    			 urlRetorno="pages/modulo/rede/moeda/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Nome"    				propertyValue="nomeMoeda"     	style="width:150px;"/>
        <duques:column labelProperty="Sigla"      			propertyValue="sigla" 			style="width:100px;" />
        <duques:column labelProperty="Símbolo"       		propertyValue="simbolo"  		style="width:100px;" />		 
                
    </duques:grid>
    
</s:form>

