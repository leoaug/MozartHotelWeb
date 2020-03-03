<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
	
	$('#linhaEstoque').css('display', 'block');

    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterAjustePdv!prepararInclusao.action" namespace="/app/custo" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterAjustePdv!prepararAlteracao.action" namespace="/app/custo" />';
		submitForm( vForm );
    }
    
	function prepararRelatorio() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarRelatorioPdv!prepararPesquisaRelatorio.action" namespace="/app/custo" />';
		submitForm(vForm);
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "AjustePdv";
	 with(milonic=new menuname("AjustePdv")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	//aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	}  
    
</script>

  <s:form action="pesquisarAjustePdv!pesquisar.action" namespace="/app/custo" theme="simple" >
  	<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1 || #session.HOTEL_SESSION.idPrograma == 11}" var="isHotel" />
  	<s:hidden name="entidade.id" id="idAlteracao"> </s:hidden>
  	<div class="divFiltroPaiTop">PDV - Ajuste</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="AJUSTE_ESTOQUE_PDV_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar"  imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />    
            <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
            <s:if test="isHotel"><duques:botao label="Relatórios" style="width:120px" imagem="imagens/iconic/png/print-3x.png" onClick="prepararRelatorio();" /></s:if>
    	</div>
    
    </div>
    
 <!-- grid -->
    <duques:grid colecao="listaPesquisa" titulo="Pesquisa Ajuste Pdv" 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="codMovimento" 
    			 urlRetorno="pages/modulo/custo/ajustePdv/pesquisar.jsp">
    	
    	<duques:column labelProperty="Data" 		 								propertyValue="data"  			style="width:150px;"/>
    	<duques:column labelProperty="Centro de Custo"	 				 			propertyValue="centroCustoDesc" style="width:200px;"/>
    	<duques:column labelProperty="Nome Item"		 		 					propertyValue="nomeItemDesc"		style="width:250px;"/>
    	<duques:column labelProperty="Tipo Movimento"		 		 				propertyValue="tipoMovimentoDesc"		style="width:150px; text-align: right;"/>
    	<duques:column labelProperty="Movimento"		 		 					propertyValue="movimento"		style="width:200px; text-align: right;"/>
    	<duques:column labelProperty="Num. Documento"		 		 				propertyValue="numDocumento"		style="width:160px; text-align: right;"/>
    	<duques:column labelProperty="Tipo Documento"		 		 				propertyValue="tipoDocumento"		  	style="width:140px; text-align: right;"/>
    	<duques:column labelProperty="Qtde."		 		 						propertyValue="quantidade"		style="width:100px; text-align: right;"/>
    	<duques:column labelProperty="Motivo"		 		 						propertyValue="motivo"		style="width:100px; text-align: right;"/>
    	<duques:column labelProperty="Cód. Movimento"		 		 				propertyValue="codMovimento"		  	style="width:140px; text-align: right;"/>
    	   
    </duques:grid>
    
</s:form>