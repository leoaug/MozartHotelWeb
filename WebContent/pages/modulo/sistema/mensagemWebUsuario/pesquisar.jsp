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

	currentMenu = "mensagemWebUsuario";
	with(milonic=new menuname("mensagemWebUsuario")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarMensagemWebUsuario!pesquisar.action" namespace="/app/sistema" theme="simple" >
  	
  	<div class="divFiltroPaiTop">Mensagem Web Usu�rio</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="MSG_WEB_USUARIO_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relat�rio Mensagem Usu�rio " 
    			 condicao="nivel;eq;Urgente;corVermelho#nivel;eq;M�dio;corAmarelo" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idMensagemWebUsuario" 
    			 urlRetorno="pages/modulo/sistema/mensagemWebUsuario/pesquisar.jsp">
    	
    	<duques:column labelProperty="Usu�rio" 		 		propertyValue="usuarioCriacao"  style="width:150px;"/>
    	<duques:column labelProperty="Data Cria��o"	 		propertyValue="dataCriacao"    	style="width:150px; text-align:center;" format="dd/MM/yyyy HH:mm:ss"/>	 
        <duques:column labelProperty="Titulo"			 	propertyValue="titulo"    		style="width:250px;"/>
        <duques:column labelProperty="Descri��o" 			propertyValue="descricao" 		style="width:800px; text-align:left;" />
        <duques:column labelProperty="N�vel"	 			propertyValue="nivel"	    	style="width:150px; text-align:left;"/>
        <duques:column labelProperty="Data resposta"	 	propertyValue="dataResposta"   	style="width:150px; text-align:center;" format="dd/MM/yyyy HH:mm:ss"/>
        <duques:column labelProperty="Resposta"		 		propertyValue="resposta"    	style="width:800px; text-align:left;"/>        
    </duques:grid>
    
</s:form>