<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterRedeHotel!prepararInclusao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterRedeHotel!prepararAlteracao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
    
    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "redeHotel";
	with(milonic=new menuname("redeHotel")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarRedeHotel!pesquisar.action" namespace="/app/sistema" theme="simple" >
  	<s:hidden name="entidade.idRedeHotel" id="idAlteracao"/>
  	<div class="divFiltroPaiTop">Rede Hotel</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
        <duques:filtro tableName="REDE_HOTEL_WEB" titulo="" />
            
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Rede Hotel" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idRedeHotel" 
    			 urlRetorno="pages/modulo/sistema/redeHotel/pesquisar.jsp">
    	
    	<duques:column labelProperty="ID Rede Hotel" 		propertyValue="idRedeHotel"  	style="width:150px;"/>
    	<duques:column labelProperty="Nome Fantasia" 		propertyValue="nomeFantasia"  	style="width:250px;"/>
    	<duques:column labelProperty="Razão Social"	 		propertyValue="razaoSocial"    	style="width:250px;"/>	 
        <duques:column labelProperty="Endereço"			 	propertyValue="endereco"    	style="width:250px;"/>
        <duques:column labelProperty="CEP" 					propertyValue="cep" 			style="width:110px;"/>
        <duques:column labelProperty="Bairro"	 			propertyValue="bairro"	    	style="width:110px;"/>
        <duques:column labelProperty="Telefone"			 	propertyValue="telefone"	   	style="width:110px;"/>
        <duques:column labelProperty="E-mail"		 		propertyValue="email"	    	style="width:160px;"/>        
        <duques:column labelProperty="FAX"			 		propertyValue="fax"		    	style="width:110px;"/>
        <duques:column labelProperty="CNPJ"		 			propertyValue="cgc"		    	style="width:160px;"/>
        <duques:column labelProperty="Insc. Estadual" 		propertyValue="inscEstadual"	style="width:150px;"/>
        <duques:column labelProperty="Insc. Municipal"		propertyValue="inscMunicipal"	style="width:150px;"/>
        <duques:column labelProperty="Insc. Embratur"		propertyValue="inscEmbratur"	style="width:150px;"/>
        <duques:column labelProperty="Telex"				propertyValue="telex"	    	style="width:110px;"/>
        <duques:column labelProperty="Automático"			propertyValue="automatico"	    style="width:110px;"/>
        <duques:column labelProperty="Valor Inscrição"		propertyValue="valorInscricao"	style="width:140px;"/>
        <duques:column labelProperty="Qtde Valor"			propertyValue="qtdValor"	    style="width:110px;"/>
        <duques:column labelProperty="Expirar"				propertyValue="expirar"	    	style="width:110px;"/>
        <duques:column labelProperty="Fora Ano"				propertyValue="foraAno"	    	style="width:110px;"/>
        <duques:column labelProperty="Sigla"				propertyValue="sigla"	    	style="width:110px;"/>
        <duques:column labelProperty="Endereço Logo Tipo"	propertyValue="enderecoLogotipo"style="width:250px;"/>
        <duques:column labelProperty="Link Voucher"			propertyValue="linkVoucher"	    style="width:450px;"/>
        <duques:column labelProperty="Formato Conta"		propertyValue="formatoConta"	style="width:150px;"/>
        
        
    </duques:grid>
    
</s:form>