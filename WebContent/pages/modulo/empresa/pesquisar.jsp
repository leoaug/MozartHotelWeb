<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEmpresa!prepararInclusao.action" namespace="/app/empresa" />';
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEmpresa!prepararAlteracao.action" namespace="/app/empresa" />';
		submitForm( vForm );
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
    function relatorio() {        
        document.forms[0].action = '<s:url action="relatorio!prepararRelatorio.action" namespace="/app/empresa" />'        
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



  <s:form action="pesquisarEmpresa!pesquisar.action" namespace="/app/empresa" theme="simple" >
  	<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1}" var="isHotel" />
  	<s:hidden name="entidade.idEmpresa" id="idEmpresa"/>
    <div class="divFiltroPaiTop">Empresas</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="EMPRESA_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />
            <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
           	<s:if test="isHotel"> <duques:botao label="Relatório" imagem="imagens/iconic/png/print-3x.png" onClick="relatorio();" /></s:if>
           
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="Relatório de empresa" 
    			 condicao="idEmpresa;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="idEmpresa" idAlteracaoValue="idEmpresa" urlRetorno="pages/modulo/empresa/pesquisar.jsp">
    			 
    	<duques:column labelProperty="Sigla"       			propertyValue="siglaHotel"  		style="width:100px;" />		 
        <duques:column labelProperty="Nome fantasia"    	propertyValue="nomeFantasia"     	style="width:400px;"/>
        <duques:column labelProperty="CNPJ/CPF/OUTROS"    	propertyValue="cnpj"     			style="width:150px;"/>
        <duques:column labelProperty="Tipo empresa"    		propertyValue="tipoEmpresa"      	style="width:150px;"/>
        <duques:column labelProperty="Telefone"         	propertyValue="telefone"            style="width:120px;"/>
        <duques:column labelProperty="Fax"       			propertyValue="fax"            		style="width:120px;" />
        <duques:column labelProperty="Telex"       			propertyValue="telex"            	style="width:100px;" />
        <duques:column labelProperty="Contato"      		propertyValue="contato"          	style="width:220px;" />
        <duques:column labelProperty="Crédito"      		propertyValue="credito"          	style="width:100px;text-align:center;" />
        <duques:column labelProperty="Comissão CRS"      	propertyValue="comissaoCRS"         style="width:120px;text-align:right;" />
        <duques:column labelProperty="E-mail"      			propertyValue="email"         		style="width:350px;" />
        <duques:column labelProperty="Comissão"   			propertyValue="comissao"      		style="width:110px;text-align:right;" />
        <duques:column labelProperty="Prazo PGTO"       	propertyValue="prazoPagamento"  	style="width:110px;text-align:center;" />
        <duques:column labelProperty="Endereço"       		propertyValue="endereco"  			style="width:400px;" />
        <duques:column labelProperty="Número"	       		propertyValue="numero"  			style="width:100px;" />
        <duques:column labelProperty="Complemento"     		propertyValue="complemento"  		style="width:300px;" />
        <duques:column labelProperty="Bairro"       		propertyValue="bairro"  			style="width:200px;" />
        <duques:column labelProperty="Cidade"       		propertyValue="cidade"  			style="width:200px;" />
        <duques:column labelProperty="Estado"       		propertyValue="estado"  			style="width:200px;" />
        <duques:column labelProperty="País"       			propertyValue="pais"  				style="width:200px;" />
        <duques:column labelProperty="Loc. Empresa"       	propertyValue="idEmpresa"  			style="width:150px;" />
                
    </duques:grid>
    
</s:form>

