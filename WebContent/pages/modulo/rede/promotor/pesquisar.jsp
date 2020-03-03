<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterPromotor!prepararInclusao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterPromotor!prepararAlteracao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "Promotor";
	with(milonic=new menuname("promotor")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>


  <s:form action="pesquisarPromotor!pesquisar.action" namespace="/app/rede" theme="simple" >
  	
  	<s:hidden name="entidade.idPromotor" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Promotor</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="PROMOTOR_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Promotoria" 
    			 condicao="idPromotor;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idPromotor" 
    			 urlRetorno="pages/modulo/rede/promotor/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Nome"    			propertyValue="nomePromotor"     	style="width:250px;"/>
        <duques:column labelProperty="Comissão"      	propertyValue="comissao" 			style="width:100px;" />
        <duques:column labelProperty="Área"       		propertyValue="area"  				style="width:100px;" />		 
                
    </duques:grid>
    
</s:form>
