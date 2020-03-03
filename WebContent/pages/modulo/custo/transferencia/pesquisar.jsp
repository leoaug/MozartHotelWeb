<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

	$('#linhaEstoque').css('display', 'block');

	function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTransferenciaCentroCustos!prepararInclusao.action" namespace="/app/custo" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTransferenciaCentroCustos!prepararAlteracao.action" namespace="/app/custo" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "prato";
	/* with(milonic=new menuname("prato")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} */ 
    
</script>

  <s:form action="pesquisarTransferenciaCentroCustos!pesquisar.action" namespace="/app/custo" theme="simple" >
  	<div class="divFiltroPaiTop">Transferência Centro Custo</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="TRANSFERENCIA_CCC_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Pesquisa Transferência" 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="idMovimentoEstoque" 
    			 idAlteracaoValue="idMovimentoEstoque" 
    			 urlRetorno="pages/modulo/custo/transferencia/pesquisar.jsp">
    	
    	<duques:column labelProperty="Nome do Item" 		 						propertyValue="nomeItemDesc"  			style="width:250px;"/>
    	<duques:column labelProperty="Centro de custo"	 				 			propertyValue="descricaoCentroCustoDesc" style="width:160px;" grouped="true" math="count"/>
    	<duques:column labelProperty="Data Movimento"		 		 				propertyValue="dataMovimentoDesc"		style="width:160px;" grouped="true" math="count"/>
    	<duques:column labelProperty="Núm. Documento"		 		 				propertyValue="numDocumentoDesc"		style="width:160px; text-align: right;" grouped="true" math="count"/>
    	<duques:column labelProperty="Tipo Documento"		 		 				propertyValue="tipoDocumento"		style="width:150px; text-align: right;"/>
    	<duques:column labelProperty="Tipo Movimento"		 		 				propertyValue="tipoMovimento"		style="width:160px; text-align: right;" grouped="true" math="count"/>
    	<duques:column labelProperty="Quant."		 		 						propertyValue="quantidade"		  	style="width:120px; text-align: right;" math="sum"/>
    	<duques:column labelProperty="Vr. Unit."		 		 					propertyValue="valorUnitario"		style="width:100px; text-align: right;" math="sum"/>
    	<duques:column labelProperty="Vr. Total"		 		 					propertyValue="valorTotal"		  	style="width:100px; text-align: right;" math="sum"/>
    	<duques:column labelProperty="Sigla."		 		 						propertyValue="sigla"		  		style="width:80px; text-align: right;"/>
    	<duques:column labelProperty="Cód. Mov. Estoque"		 		 			propertyValue="idMovimentoEstoque"	style="width:140px; text-align: right;"/>
    	   
    </duques:grid>
    
</s:form>