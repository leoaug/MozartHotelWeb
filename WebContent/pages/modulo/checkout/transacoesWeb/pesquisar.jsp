<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

   	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }


	function estornar(){

		if (confirm('Confirma o estorno do lançamento?')){
			vForm = document.forms[0];
			vForm.action = '<s:url action="pesquisarTransacoesWeb!estornar.action" namespace="/app/caixa" />';
			submitForm( vForm );
		}
	}

	currentMenu = "transacao";
	with(milonic=new menuname("transacao")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnDevolver.png;text=Estornar;url=javascript:estornar();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarTransacoesWeb!pesquisar.action" namespace="/app/caixa" theme="simple" >
  	<s:hidden name="entidade.idTransacaoWeb" id="idAlteracao" />
  	<div class="divFiltroPaiTop">Transações Web</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="TRANSACOES_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar"  imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />    
        </div>
    
    </div>
    
<!-- grid -->
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Transações Web" 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idTransacao" 
    			 urlRetorno="pages/modulo/checkout/transacoesWeb/pesquisar.jsp">
    	
        <duques:column labelProperty="Nº Apto"			 		propertyValue="apartamento"    				style="width:120px;"/>
        <duques:column labelProperty="Reserva"			 		propertyValue="idReserva"    				style="width:120px;"/>
        <duques:column labelProperty="Cliente" 					propertyValue="nomeCliente" 				style="width:250px; text-align:left;" />
        <duques:column labelProperty="Cartão"	 				propertyValue="cartao"	    				style="width:150px; text-align:left;"/>
        <duques:column labelProperty="Autorização"	 			propertyValue="codAutorizacao"   			style="width:120px;"/> 
        <duques:column labelProperty="Transação"		 		propertyValue="codTransacao"    			style="width:120px; text-align:left;" />
        <duques:column labelProperty="Dt. Trans"	 			propertyValue="dataTransacao"	    		style="width:150px; text-align:center;" format="dd/MM/yyyy HH:mm:ss"/>
        <duques:column labelProperty="Valor"		 			propertyValue="valorTransacao"    			style="width:120px; text-align:right;"/>
		<duques:column labelProperty="Status"	 				propertyValue="status"   					style="width:180px;"/>
        <duques:column labelProperty="Mensagem"	 				propertyValue="txtMensagem"   				style="width:220px; "/>
    </duques:grid>
    
</s:form>
