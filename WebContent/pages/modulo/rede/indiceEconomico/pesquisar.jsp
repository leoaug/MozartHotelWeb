<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterIndiceEconomico!prepararInclusao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterIndiceEconomico!prepararAlteracao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
	currentMenu = "indiceEconomico";
	with(milonic=new menuname("indiceEconomico")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarIndiceEconomico!pesquisar.action" namespace="/app/rede" theme="simple" >
  	
  	<s:hidden name="entidade.idIndiceEconomico" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Índice Econômico</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro">
            <duques:filtro tableName="INDICE_CORRECAO_MONETARIA_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Índice de Correção Monetária" 
    			 condicao="idIndiceEconomico;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idIndiceEconomico" 
    			 urlRetorno="pages/modulo/rede/indiceEconomico/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Data"       		propertyValue="data" 					style="width:130px;text-align:left;" />
        <duques:column labelProperty="Índice tipo"      propertyValue="indiceTipo.nomeIndice"   style="width:130px;text-align:left;" />
        <duques:column labelProperty="Índice mês"       propertyValue="indiceMes" 				style="width:130px;text-align:left;" />
        <duques:column labelProperty="Índice anual"     propertyValue="indiceAnual"				style="width:130px;text-align:left;" />
        <duques:column labelProperty="Índice do ano"    propertyValue="indiceDoAno" 			style="width:130px;text-align:left;" />
        
    </duques:grid>
    
</s:form>
