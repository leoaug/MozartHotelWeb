<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterHotel!prepararInclusao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterHotel!prepararAlteracao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
    
    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "hotel";
	with(milonic=new menuname("hotel")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarHotel!pesquisar.action" namespace="/app/sistema" theme="simple" >
  	<s:hidden name="entidade.idHotel" id="idAlteracao"/>
  	<div class="divFiltroPaiTop">Hotel</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro">
        <duques:filtro tableName="HOTEL_WEB" titulo="" />
            
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Hotel" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idHotel" 
    			 urlRetorno="pages/modulo/sistema/hotel/pesquisar.jsp">
    	
    	<duques:column labelProperty="Id Hotel"		 		propertyValue="idHotel"		  			style="width:100px;"/>
    	<duques:column labelProperty="Nome Fantasia" 		propertyValue="nomeFantasia"  			style="width:250px;"/>
    	<duques:column labelProperty="Razão Social"	 		propertyValue="razaoSocial"    			style="width:500px;"/>	 
        <duques:column labelProperty="Endereço"			 	propertyValue="endereco"    			style="width:300px;"/>
        <duques:column labelProperty="CEP" 					propertyValue="cep" 					style="width:110px;"/>
        <duques:column labelProperty="Bairro"	 			propertyValue="bairro"	    			style="width:170px;"/>
        <duques:column labelProperty="Telefone"			 	propertyValue="telefone"	   			style="width:110px;"/>
        <duques:column labelProperty="E-mail"		 		propertyValue="email"	    			style="width:250px;"/>        
        <duques:column labelProperty="FAX"			 		propertyValue="fax"		    			style="width:110px;"/>
        <duques:column labelProperty="CNPJ"		 			propertyValue="cgc"		    			style="width:160px;"/>
        
    </duques:grid>
    
</s:form>