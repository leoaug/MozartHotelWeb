<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEstoqueItem!prepararInclusao.action" namespace="/app/compras" />';
		submitForm( vForm );
    }
	 
	
	
	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEstoqueItem!prepararAlteracao.action" namespace="/app/compras" />';
		submitForm( vForm );
    }
	
	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "estoqueItem";
	with(milonic=new menuname("estoqueItem")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarEstoqueItem!pesquisar.action" namespace="/app/compras" theme="simple" >
  	<s:hidden name = "entidadeRede.id.idItem" id="idAlteracao"/>
  	<s:hidden name ="entidadeRede.id.idRedeHotel" value="%{#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel}"/>
	<s:hidden name ="entidade.id.idHotel" value="%{#session.HOTEL_SESSION.idHotel}"/>
  	
  	<div class="divFiltroPaiTop">Item Estoque</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="ITEM_ESTOQUE_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Fornecedor Grupo" 
    			 condicao="idItem;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idItem" 
    			 urlRetorno="pages/modulo/compras/estoqueItem/pesquisar.jsp">
    			
    		 
			<duques:column labelProperty="ID Item" 				 propertyValue="idItem"	style="width:160px;" />
			<duques:column labelProperty="Imobilizado"  		 propertyValue="imobilizado"	style="width:130px;" />
			<duques:column labelProperty="Nome Item"  			 propertyValue="nomeItem"	style="width:250px;" />
			<duques:column labelProperty="Nome Uni. Red."  		 propertyValue="nomeUnidadeReduzida"	style="width:140px;" />
			<duques:column labelProperty="Nome Conta"  			 propertyValue="nomeConta"	style="width:210px;" />
			<duques:column labelProperty="Desc. C.C."  			 propertyValue="descricaoCentroCusto"	style="width:160px;" />
			<duques:column labelProperty="Direto"  				 propertyValue="direto"	style="width:100px;" />
			<duques:column labelProperty="Controlado"  			 propertyValue="controlado"	style="width:100px;" />
			<duques:column labelProperty="Aliquota"  			 propertyValue="aliquota"	style="width:100px;" />
			<duques:column labelProperty="Estoque Mín."  		 propertyValue="estoqueMinimo"	style="width:120px;" />
			<duques:column labelProperty="Estoque Máx."  		 propertyValue="estoqueMaximo"	style="width:120px;" />
			<duques:column labelProperty="Nome Tipo"  			 propertyValue="nomeTipo"	style="width:220px;" />
			<duques:column labelProperty="Sigla"  				 propertyValue="sigla"	style="width:160px;" />
			<duques:column labelProperty="Unidade Rede"  		 propertyValue="unidadeRede"	style="width:160px;" />
			<duques:column labelProperty="Unidade Compra"  		 propertyValue="unidadeCompra"	style="width:160px;" />
			<duques:column labelProperty="Unidade Req."  		 propertyValue="unidadeRequisicao"	style="width:160px;" />



        
        
    </duques:grid>
    
</s:form>
