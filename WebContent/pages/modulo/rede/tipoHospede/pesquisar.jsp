<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTipoHospede!prepararInclusao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTipoHospede!prepararAlteracao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "tipoHospede";
	with(milonic=new menuname("tipoHospede")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarTipoHospede!pesquisar.action" namespace="/app/rede" theme="simple" >
  	
  	<s:hidden name="entidade.idTipoHospede" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Tipo de hóspede</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="TIPOHOSPEDE_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Tipo Hóspede" 
    			 condicao="idTipoHospede;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idTipoHospede" 
    			 urlRetorno="pages/modulo/rede/tipoHospede/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Tipo Hóspede"     propertyValue="tipoHospede" 		style="width:150px;" />
        <duques:column labelProperty="Padrão"       	propertyValue="padrao"  			style="width:100px; text-align:center;" />		 
                
    </duques:grid>
    
</s:form>
