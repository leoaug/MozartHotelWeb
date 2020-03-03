<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function lancarMovimento(){
        if (confirm("Confirma o lançamento?")){
			vForm = document.forms[0];
			vForm.action = '<s:url action="pesquisarDiscrepancia!lancarMovimento.action" namespace="/app/telefonia" />';
			submitForm( vForm );
        }
	}

	
    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	

	currentMenu = "discrepancia";
	with(milonic=new menuname("discrepancia")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Lançar Movimento;url=javascript:lancarMovimento();");
	drawMenus();  
	} 
    
</script>



  <s:form action="pesquisarDiscrepancia!pesquisar.action" namespace="/app/telefonia" theme="simple" >
  	
  	<s:hidden name="entidade.idTelefonia" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Discrepância</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="DISCREPANCIA_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Discrepância" 
    			 condicao="idDiscrepancia;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idDiscrepancia" 
    			 urlRetorno="pages/modulo/telefonia/discrepancia/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Ramal"    			propertyValue="ramal"     			style="width:100px;"/>
        <duques:column labelProperty="Nº Apartamento"      	propertyValue="numApartamento" 		style="width:130px;" />
        <duques:column labelProperty="Nº Telefone"       	propertyValue="numTelefone"  		style="width:150px;" />		 
        <duques:column labelProperty="Data"    				propertyValue="data"     			style="width:100px;text-align:center;"/>
        <duques:column labelProperty="Hora Inicio"       	propertyValue="horaInicio"  		style="width:100px;text-align:center;" />		 
        <duques:column labelProperty="Valor"    			propertyValue="valor"     			style="text-align:right;width:100px;"/>                 
                
    </duques:grid>
    
</s:form>

