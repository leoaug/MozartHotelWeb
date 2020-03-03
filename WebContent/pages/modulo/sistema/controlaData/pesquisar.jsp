<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterControlaData!prepararInclusao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterControlaData!prepararAlteracao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
    
    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "controlaData";
	with(milonic=new menuname("controlaData")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarControlaData!pesquisar.action" namespace="/app/sistema" theme="simple" >
  	<s:hidden name="entidade.idHotel" id="idAlteracao"/>
  	<div class="divFiltroPaiTop">Controla Data</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
        <duques:filtro tableName="CONTROLA_DATA_WEB" titulo="" />
            
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Controla Data" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idHotel" 
    			 urlRetorno="pages/modulo/sistema/controlaData/pesquisar.jsp">
    	
    	<duques:column labelProperty="Id Hotel"		 			  	propertyValue="idHotel"		  				style="width:110px;"/>
    	<duques:column labelProperty="Front Office" 			  	propertyValue="frontOffice"  				style="width:250px;"/>
    	<duques:column labelProperty="Faturamento Contas Receber" 	propertyValue="faturamentoContasReceber"    style="width:250px;"/>	 
        <duques:column labelProperty="Contabilidade"			  	propertyValue="contabilidade"    			style="width:250px;"/>
        <duques:column labelProperty="Contas a Pagar" 			  	propertyValue="contasPagar" 				style="width:130px;"/>
        <duques:column labelProperty="Tesouraria"	 			  	propertyValue="tesouraria"	    			style="width:110px;"/>
        <duques:column labelProperty="Estoque"			 		  	propertyValue="estoque"		   				style="width:110px;"/>
        <duques:column labelProperty="Ultimo Nota Hosp."		 	propertyValue="ultimaNotaHospedagem"	    style="width:200px;"/>        
        <duques:column labelProperty="Último Num. Dup."			 	propertyValue="ultimoNumDuplicata"		    style="width:150px;"/>
        <duques:column labelProperty="Último Num. Cotação"		 	propertyValue="ultimoNumCotacao"		    style="width:180px;"/>
        <duques:column labelProperty="Último Num. Pedido"		 	propertyValue="ultimoNumPedido"		    	style="width:160px;"/>
        <duques:column labelProperty="Último Num. Contas Pagar"		propertyValue="ultimoNumContasPagar"		style="width:200px;"/>
        <duques:column labelProperty="Telefonia"					propertyValue="telefonia"		    		style="width:160px;"/>
        <duques:column labelProperty="Contas a Receber"				propertyValue="contasReceber"		    	style="width:160px;"/>
        <duques:column labelProperty="Id Rede Hotel"				propertyValue="idRedeHotel"		    		style="width:160px;"/>
        <duques:column labelProperty="Saldo Elevado"				propertyValue="saldoElevado"		    	style="width:160px;"/>
        <duques:column labelProperty="Fechadura"					propertyValue="fechadura"		    		style="width:160px;"/>
        <duques:column labelProperty="Última Requisição"			propertyValue="ultimaRequisicao"		    style="width:160px;"/>
        <duques:column labelProperty="Central Adviser"				propertyValue="centralAdviser"		    	style="width:160px;"/>
        <duques:column labelProperty="Aud. Encerra"					propertyValue="audEncerra"		    		style="width:160px;"/>
        <duques:column labelProperty="Última NFS"					propertyValue="ultimaNfs"		    		style="width:160px;"/>
        <duques:column labelProperty="Última CNFS"					propertyValue="UltimaCnfs"		    		style="width:160px;"/>
        <duques:column labelProperty="Último Sequência Bancária"	propertyValue="ultimaSeqBancaria"		    style="width:200px;"/>
        
        
        
    </duques:grid>
    
</s:form>