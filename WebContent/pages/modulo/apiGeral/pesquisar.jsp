<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>


    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterApiGeral!prepararInclusao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterApiGeral!prepararAlteracao.action" namespace="/app/sistema" />';
		submitForm( vForm );
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
    function relatorio() {        
        document.forms[0].action = '<s:url action="relatorio!prepararRelatorio.action" namespace="/app/sistema" />'        
        submitForm(document.forms[0]);
    }

	currentMenu = "apto";
	with(milonic=new menuname("apto")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>



  <s:form action="pesquisarApiGeral!pesquisar.action" namespace="/app/sistema" theme="simple" >
  	<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1}" var="isHotel" />
  	<s:hidden name="entidade.idApiGeral" id="idApiGeral"/>
    <div class="divFiltroPaiTop">API - GERAL</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="API_GERAL_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" 
    			 titulo="Relatório de api geral" 
    			 current="obj" 
    			 idAlteracao="idApiGeral" 
    			 idAlteracaoValue="idApiGeral" 
    			 urlRetorno="pages/modulo/apiGeral/pesquisar.jsp">
    
       <duques:column labelProperty="Nome API"       						propertyValue="nome"            			    style="width:120px;" />
       <duques:column labelProperty="Ativo"       							propertyValue="ativo"            			    style="width:120px;" />
       <duques:column labelProperty="Razão Social Site"       				propertyValue="razaoSocialString"            	style="width:120px;" />
       <duques:column labelProperty="Token"       							propertyValue="token"            				style="width:120px;" />
       <duques:column labelProperty="URL"       							propertyValue="url"            					style="width:120px;" />
       <duques:column labelProperty="Cód. Registro"       					propertyValue="idApiGeral"            			style="width:120px;" />
	   <duques:column labelProperty="Nome API"       						propertyValue="apiContratoNome"            		style="width:120px;" />
	   <duques:column labelProperty="Ativo"       							propertyValue="apiContratoAtivo"            	style="width:120px;" />
	   <duques:column labelProperty="Nome Fantasia"       					propertyValue="hotelNomeFantasia"            	style="width:120px;" />
	   <duques:column labelProperty="Descrição Lançamento Receita"      	propertyValue="tipoLancamentoDescricao"         style="width:120px;" />
	   <duques:column labelProperty="Descrição Lançamento Recebimento"      propertyValue="tipoLancamentoDescricaoCK"       style="width:120px;" />
	   <duques:column labelProperty="Cód. Registro"      					propertyValue="idApiContrato"       			style="width:120px;" />
	   <duques:column labelProperty="Nome da AP"      						propertyValue="apiVendedorNome"       			style="width:120px;" />
	   <duques:column labelProperty="Ativo"      							propertyValue="apiVendedorAtivo"       			style="width:120px;" />
	   <duques:column labelProperty="Nome Fantasia"      					propertyValue="hotelNomeFantasiaTL"       		style="width:120px;" />
	   <duques:column labelProperty="Cód. Registro"      					propertyValue="apiVendedorId"       		    style="width:120px;" />
		
                
    </duques:grid>
    
</s:form>

