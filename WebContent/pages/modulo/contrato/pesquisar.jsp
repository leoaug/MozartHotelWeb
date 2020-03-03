<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manter!prepararInclusao.action" namespace="/App/contrato" />';
		submitForm( vForm );
    }
    
    function prepararPesquisa(){
		vForm = document.forms[0];
		submitForm(vForm);
	}
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manter!prepararAlteracao.action" namespace="/App/contrato" />';
		submitForm( vForm );
    }

	currentMenu = "contrato";
	with(milonic=new menuname("contrato")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisar!pesquisar.action" namespace="/App/contrato" theme="simple" >
  	<s:hidden name="entidade.id" id="idAlteracao"> </s:hidden>
  	<div class="divFiltroPaiTop">Contratos</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="SERVICOS_CONTRATO_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="prepararPesquisa();" />    
            <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
    	</div>
    
    </div>
    
 <!-- grid -->
    <duques:grid colecao="listaPesquisa" titulo="Relatório Contratos" 
    			 condicao="#gracValorIncompleto;eq;S;corVermelho" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idContrato" 
    			 urlRetorno="pages/modulo/contrato/pesquisar.jsp">
    	
    	<duques:column labelProperty="Cancelado" 		 							propertyValue="cancelado"  			style="width:100px;"/>
    	<duques:column labelProperty="Cliente"	 			 						propertyValue="nomeCliente"			style="width:200px;"/>
    	<duques:column labelProperty="Data Inicial"		 	 						propertyValue="dataInicio"		  	style="width:120px; text-align: right;"/>
    	<duques:column labelProperty="Data Final"		 	 						propertyValue="dataFim"		  		style="width:120px; text-align: right;"/>
    	<duques:column labelProperty="Dia do Faturamento"	 						propertyValue="diaFaturamento"		style="width:160px; text-align: right;"/>
    	<duques:column labelProperty="Tipo do Serviço" 		 						propertyValue="tipoServico"		  	style="width:250px; text-align: right;"/>
    	<duques:column labelProperty="Descrição do Serviço" 		 				propertyValue="descricaoServico"	style="width:250px; text-align: right;"/>
    	<duques:column labelProperty="Quantidade" 		 							propertyValue="quantidade"		  	style="width:110px; text-align: right;"/>
    	<duques:column labelProperty="Vr.Unit." 		 							propertyValue="vlUnitario"		  	style="width:110px; text-align: right;"/>
    	<duques:column labelProperty="Valor Total" 		 							propertyValue="vlTotal"		  		style="width:110px; text-align: right;"/>
    	<duques:column labelProperty="ISS" 		 									propertyValue="iss"		  			style="width:100px; text-align: right;"/>
    	<duques:column labelProperty="Taxa Serviço" 		 						propertyValue="taxaServico"		  	style="width:120px; text-align: right;"/>
    	<duques:column labelProperty="Loc. da Conta" 		 						propertyValue="idContrato"		  	style="width:120px; text-align: right;"/>
    	<duques:column labelProperty="Unidade" 		 								propertyValue="unidade"		  		style="width:120px; text-align: right;"/>
    	
    	
    	        
    </duques:grid>
    
</s:form>