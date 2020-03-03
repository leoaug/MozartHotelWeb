<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "";
	
    
</script>

  <s:form action="pesquisarLogUsuario!pesquisar.action" namespace="/app/controladoria" theme="simple" >
  	<s:hidden name="tabela" id=""/>
  	<s:hidden name="titulo" id=""/>
  	<s:hidden name="filtro.idAuditado" id="idAlteracao"/>
  	<div class="divFiltroPaiTop"><s:property value="titulo"/></div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="LOG_USUARIO_WEB" titulo="" />
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
    
    <%
    	String tit = String.valueOf(request.getAttribute("titulo"));
    %>
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Log <%=tit%>" 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idAuditado" 
    			 urlRetorno="pages/modulo/controladoria/logUsuario/pesquisar.jsp">
    	
    	<duques:column labelProperty="ID"		 		 	propertyValue="idAuditado"  	style="width:100px;"/>
    	<duques:column labelProperty="Operação"		 		propertyValue="operacao"    	style="width:150px;"/>	 
        <duques:column labelProperty="Usuário"			 	propertyValue="nick"    		style="width:150px;"/>
        <duques:column labelProperty="Estação" 				propertyValue="estacao" 		style="width:150px; text-align:left;" />
        <duques:column labelProperty="Data Sistema"	 		propertyValue="data"	    	style="width:120px; text-align:left;"/>
        <duques:column labelProperty="Hora"	 				propertyValue="hora"   			style="width:180px; text-align:center;" format="dd/MM/yyyy HH:mm:ss"/>
        <duques:column labelProperty="Geral"		 		propertyValue="geral"    		style="width:300px; text-align:left;"/>
        <duques:column labelProperty="Geral 2"		 		propertyValue="geral2"    		style="width:300px; text-align:left;"/>
        <duques:column labelProperty="Alteração"	 		propertyValue="alteracao"    	style="width:650px; text-align:left;"/>              
    </duques:grid>
    
</s:form>