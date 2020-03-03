<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterRamal!prepararInclusao.action" namespace="/app/telefonia" />';
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterRamal!prepararAlteracao.action" namespace="/app/telefonia" />';
		submitForm( vForm );
	}

	function prepararExcluir(){
		
		if (confirm("Confirma a exclusão deste ramal?")){
			vForm = document.forms[0];
			vForm.action = '<s:url action="excluirRamal!excluir.action" namespace="/app/telefonia" />';
			submitForm( vForm );
		}
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "ramal";
	with(milonic=new menuname("ramal")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	aI("image=imagens/btnCancelar.png;text=Excluir;url=javascript:prepararExcluir();");
	drawMenus();  
	} 
    
</script>



  <s:form action="pesquisarRamal!pesquisar.action" namespace="/app/telefonia" theme="simple" >
  	
  	<s:hidden name="entidade.idRamalTelefonico" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Ramal</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="RAMAL_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Relatório de ramal" 
    			 condicao="idRamal;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idRamal" 
    			 urlRetorno="pages/modulo/telefonia/ramal/pesquisar.jsp">
    			
    	<duques:column labelProperty="Ramal"       			propertyValue="ramal"  				style="width:100px;" />		 
        <duques:column labelProperty="Num Apto"    			propertyValue="numApartamento"     	style="width:100px;"/>
        <duques:column labelProperty="Ramal interno"    	propertyValue="interno"      		style="width:120px;"/>
         
                
    </duques:grid>
    
</s:form>

