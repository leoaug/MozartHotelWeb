<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEmpresa!prepararInclusao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEmpresa!prepararAlteracao.action" namespace="/app/sistema" />';
		submitForm( vForm );
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
	currentMenu = "empresa";
	with(milonic=new menuname("empresa")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>



  <s:form action="pesquisarEmpresa!pesquisar.action" namespace="/app/sistema" theme="simple" >
  	<s:hidden name="entidade.idEmpresa" id="idEmpresa"/>
    <div class="divFiltroPaiTop">Empresas</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="EMPRESA_SISTEMA_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar"  imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />
      
            
           
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="Relatório de empresa" 
    			 condicao="idEmpresa;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="idEmpresa" idAlteracaoValue="idEmpresa" urlRetorno="pages/modulo/sistema/empresa/pesquisar.jsp">
    			 
    	<duques:column labelProperty="Razão social"       	propertyValue="razaoSocial"  		style="width:400px;" />    	
        <duques:column labelProperty="Endereço"       		propertyValue="endereco"  			style="width:400px;" />
        <duques:column labelProperty="Número"       		propertyValue="numero"  			style="width:100px;" />
        <duques:column labelProperty="Complemento"     		propertyValue="complemento"			style="width:300px;" />
        <duques:column labelProperty="Bairro"       		propertyValue="bairro"  			style="width:200px;" />
        <duques:column labelProperty="Cidade"       		propertyValue="cidade"  			style="width:200px;" />
        <duques:column labelProperty="Estado"       		propertyValue="estado"  			style="width:200px;" />
        <duques:column labelProperty="País"       			propertyValue="pais"  				style="width:200px;" />
        <duques:column labelProperty="Loc. Empresa"    		propertyValue="idEmpresa"  			style="width:150px;" />
                
    </duques:grid>
    
</s:form>

