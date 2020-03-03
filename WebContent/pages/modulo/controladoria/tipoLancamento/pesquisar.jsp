<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTipoLancamento!prepararInclusao.action" namespace="/app/controladoria" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTipoLancamento!prepararAlteracao.action" namespace="/app/controladoria" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
	currentMenu = "tipoLancamento";
	with(milonic=new menuname("tipoLancamento")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>
	
  <s:form action="pesquisarTipoLancamento!pesquisar.action" namespace="/app/controladoria" theme="simple" >
  	
  	<s:hidden name="entidade.idTipoLancamento" id="idAlteracao"/>  	
    <div class="divFiltroPaiTop">Tipo Lançamento</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro">
            <duques:filtro tableName="TIPO_LANCAMENTO_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />    
    	    <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
        </div>
    
    </div>
    
 <!-- grid -->
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Tipo Lançamento" 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idTipoLancamento" 
    			 urlRetorno="pages/modulo/controladoria/tipoLancamento/pesquisar.jsp">
  			 
        <duques:column labelProperty="Sigla"       					propertyValue="sigla" 				style="width:110px;text-align:left;" />
        <duques:column labelProperty="Descrição" 	 	    		propertyValue="descricaoLancamento"			style="width:220px;text-align:left;" />
        <duques:column labelProperty="Grupo"       					propertyValue="grupo"						style="width:150px;text-align:left;" />
        <duques:column labelProperty="Sub Grupo"    				propertyValue="subGrupo"					style="width:150px;text-align:left;" />
        <duques:column labelProperty="D/C" 							propertyValue="debitoCredito"		 	 	style="width:110px;text-align:left;" />
        <duques:column labelProperty="Nota Fiscal"					propertyValue="notaFiscal"		  	 		style="width:110px;text-align:left;" />
        <duques:column labelProperty="ISS"							propertyValue="iss" 						style="width:110px;text-align:left;" />
        <duques:column labelProperty="Taxa Serviço"					propertyValue="taxaServico"   				style="width:110px;text-align:left;" />
    </duques:grid>
    
</s:form>
