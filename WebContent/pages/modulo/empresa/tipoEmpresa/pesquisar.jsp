<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTipoEmpresa!prepararInclusao.action" namespace="/app/empresa" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTipoEmpresa!prepararAlteracao.action" namespace="/app/empresa" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "tipoEmpresa";
	with(milonic=new menuname("tipoEmpresa")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarTipoEmpresa!pesquisar.action" namespace="/app/empresa" theme="simple" >
  	
  	<s:hidden name="entidade.idTipoEmpresa" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Tipo Empresa</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="TIPO_EMPRESA_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Tipo Empresa" 
    			 condicao="idTipoEmpresa;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idTipoEmpresa" 
    			 urlRetorno="pages/modulo/empresa/tipoEmpresa/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Tipo empresa"			 		propertyValue="tipoEmpresa"    		style="width:150px;"/>
        <duques:column labelProperty="Comissão CRS"			 		propertyValue="crs"    				style="width:140px;"/>        
        
                
    </duques:grid>
    
</s:form>