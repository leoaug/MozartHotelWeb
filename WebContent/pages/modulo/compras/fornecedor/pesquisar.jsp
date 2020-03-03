<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterFornecedor!prepararInclusao.action" namespace="/app/compras" />';
		submitForm( vForm );
    }
	    
	

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterFornecedor!prepararAlteracao.action" namespace="/app/compras" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "fornecedor";
	with(milonic=new menuname("fornecedor")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarFornecedor!pesquisar.action" namespace="/app/compras" theme="simple" >
  	<s:hidden name = "entidade.idFornecedor" id="idAlteracao"/>
  	<div class="divFiltroPaiTop">Fornecedor</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="FORNECEDOR_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Fornecedor" 
    			 condicao="idFornecedor;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idFornecedor" 
    			 urlRetorno="pages/modulo/compras/fornecedor/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="CNPJ/CPF/OUTROS"   propertyValue="cgc"		 		style="width:150px;" />
        <duques:column labelProperty="Nome Fantasia"     propertyValue="nomeFantasia" 		style="width:260px;" />
        <duques:column labelProperty="Contato"     		 propertyValue="contato" 			style="width:150px;" />
        <duques:column labelProperty="PIS"    			 propertyValue="pis" 				style="width:80px;" />
        <duques:column labelProperty="Contas Pagar"    	 propertyValue="contasPagar" 		style="width:120px;" />
        <duques:column labelProperty="Telefone 1"     	 propertyValue="tel1" 				style="width:120px;" />
        <duques:column labelProperty="Telefone 2"    	 propertyValue="tel2" 				style="width:120px;" />
        <duques:column labelProperty="Telefone 3"        propertyValue="tel3" 				style="width:120px;" />
        <duques:column labelProperty="Fax"    			 propertyValue="fax" 				style="width:100px;" />
		<duques:column labelProperty="E-Mail 1"    		 propertyValue="email1" 			style="width:190px;" />
        <duques:column labelProperty="E-Mail 2"   	 	 propertyValue="email2" 			style="width:190px;" />
        <duques:column labelProperty="E-Mail 3"  		 propertyValue="email3" 			style="width:190px;" />
        
        
        
        
    </duques:grid>
    
</s:form>
