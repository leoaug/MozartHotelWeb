<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterVendedor!prepararInclusao.action" namespace="/app/vendedor" />';
		submitForm( vForm );
    }
	    
	

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterVendedor!prepararAlteracao.action" namespace="/app/vendedor" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "vendedor";
	with(milonic=new menuname("vendedor")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarVendedorRede!pesquisar.action" namespace="/app/vendedor" theme="simple" >
  	<s:hidden name = "entidade.idVendedor" id="idAlteracao"/>
  	<div class="divFiltroPaiTop">Vendedor</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="REPRESENTANTE_REDE_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Vendedor" 
    			 condicao="idVendedor;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idVendedor" 
    			 urlRetorno="pages/modulo/operacional/vendedor/pesquisar.jsp">
    			
        <duques:column labelProperty="CNPJ/CPF/OUTROS"   propertyValue="cgc"		 		style="width:150px;" />
        <duques:column labelProperty="Nome Fantasia"     propertyValue="nomeFantasiaCgc" 	style="width:260px;" />
        <duques:column labelProperty="Contato"     		 propertyValue="contato" 			style="width:150px;" />
        <duques:column labelProperty="Telefone 1"     	 propertyValue="tel1" 				style="width:120px;" />
        <duques:column labelProperty="Telefone 2"    	 propertyValue="tel2" 				style="width:120px;" />
		<duques:column labelProperty="E-Mail 1"    		 propertyValue="email1" 			style="width:190px;" />
        <duques:column labelProperty="Comissão"   	 	 propertyValue="comissao" 			style="width:190px;" />
        <duques:column labelProperty="Prazo Pagamento"   propertyValue="prazoPagamento" 	style="width:190px;" />
        <duques:column labelProperty="Loc. do Lançamento" propertyValue="idVendedor" 	style="width:190px;" />
        
    </duques:grid>
    
</s:form>
