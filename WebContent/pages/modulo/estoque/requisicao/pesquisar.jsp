<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
$('#linhaEstoque').css('display','block');
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterRequisicao!prepararInclusao.action" namespace="/app/estoque" />';
		submitForm( vForm );
    }
	 
	
	
	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEstoqueItem!prepararAlteracao.action" namespace="/app/estoque" />';
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

  <s:form action="pesquisarRequisicao!pesquisar.action" namespace="/app/estoque" theme="simple" >
  	<s:hidden name = "entidadeRede.id.idItem" id="idAlteracao"/>
  	<s:hidden name ="entidadeRede.id.idRedeHotel" value="%{#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel}"/>
	<s:hidden name ="entidade.id.idHotel" value="%{#session.HOTEL_SESSION.idHotel}"/>
  	
  	<div class="divFiltroPaiTop">Requisição</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="ESTOQUE_ITEM_WEB" titulo="" />
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
    			 urlRetorno="pages/modulo/estoque/requisicao/pesquisar.jsp">
    			
    		 
			<duques:column labelProperty="Centro Custos" 	propertyValue="idItem"					style="width:160px;" />
			<duques:column labelProperty="No. Req."  		propertyValue="imobilizado"				style="width:130px;" />
			<duques:column labelProperty="Data"  			propertyValue="nomeItem"				style="width:250px;" />
			<duques:column labelProperty="Tipo"  			propertyValue="nomeUnidadeReduzida"		style="width:140px;" />
			<duques:column labelProperty="Usuário"  		propertyValue="nomeConta"				style="width:210px;" />
			<duques:column labelProperty="Item"  			propertyValue="descricaoCentroCusto"	style="width:160px;" />
			<duques:column labelProperty="Unnidade"  		propertyValue="direto"					style="width:100px;" />
			<duques:column labelProperty="Qt. Sol."  		propertyValue="controlado"				style="width:100px;" />
			<duques:column labelProperty="Qt. Aut."  		propertyValue="aliquota"				style="width:100px;" />
			<duques:column labelProperty="Qt. Lib."  		propertyValue="estoqueMinimo"			style="width:120px;" />
			<duques:column labelProperty="Qt. Rec."  		propertyValue="estoqueMaximo"			style="width:120px;" />
			<duques:column labelProperty="Cód. Reg."  		propertyValue="nomeTipo"				style="width:220px;" />



        
        
    </duques:grid>
    
</s:form>
