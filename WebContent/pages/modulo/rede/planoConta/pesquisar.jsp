<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterPlanoConta!prepararInclusao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterPlanoConta!prepararAlteracao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
	currentMenu = "planoConta";
	with(milonic=new menuname("planoConta")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarPlanoConta!pesquisar.action" namespace="/app/rede" theme="simple" >
  	
  	<s:hidden name="entidade.idPlanoContas" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Plano de contas</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro">
            <duques:filtro tableName="PLANO_CONTAS_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Plano de Contas" 
    			 condicao="idPlanoContas;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idPlanoContas" 
    			 urlRetorno="pages/modulo/rede/planoConta/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Conta contábil"       		propertyValue="contaContabil" 				style="width:130px;text-align:left;" />
        <duques:column labelProperty="Conta reduzida"      			propertyValue="contaReduzida"   			style="width:130px;text-align:left;" />
        <duques:column labelProperty="Nome conta"       			propertyValue="nomeConta" 					style="width:250px;text-align:left;" />
        <duques:column labelProperty="Histórico Débito"    			propertyValue="historicoDebito"				style="width:250px;text-align:left;" />
        <duques:column labelProperty="Histórico Crédito"			propertyValue="historicoCredito" 	 		style="width:250px;text-align:left;" />
        <duques:column labelProperty="Plano Contas SPED"			propertyValue="planoContasSped"	  	 		style="width:250px;text-align:left;" />
        <duques:column labelProperty="R.Aux."  						propertyValue="razaoAuxiliar" 				style="width:100px;text-align:center;" />
        <duques:column labelProperty="Depr."						propertyValue="depreciacao"  	 			style="width:100px;text-align:center;" />
        <duques:column labelProperty="Tipo conta"					propertyValue="tipoConta"	  	 			style="width:130px;text-align:left;" /> 
        <duques:column labelProperty="C.Monet."						propertyValue="correcaoMonetaria"  	 		style="width:100px;text-align:center;" /> 
        <duques:column labelProperty="A/P/O"						propertyValue="ativoPassivo"	  	 		style="width:100px;text-align:center;" />
        
              
    </duques:grid>
    
</s:form>
