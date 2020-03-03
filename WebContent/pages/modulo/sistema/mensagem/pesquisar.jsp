<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterMensagem!prepararInclusao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterMensagem!prepararAlteracao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
	currentMenu = "msg";
	with(milonic=new menuname("msg")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarMensagem!pesquisar.action" namespace="/app/sistema" theme="simple" >
  	
  	<s:hidden name="entidade.idMensagem" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Mensagens</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro">
            <duques:filtro tableName="MENSAGEM_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Mensagens" 
    			 condicao="nivel;eq;Urgente;corVermelho#nivel;eq;Médio;corAmarelo" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idMensagem" 
    			 urlRetorno="pages/modulo/sistema/mensagem/pesquisar.jsp">
    			
        <duques:column labelProperty="Criada por"	 	     		propertyValue="criadaPor"   			style="width:150px;text-align:left;" />
        <duques:column labelProperty="Dt Criação"	 	     		propertyValue="dataCriacao"   			style="width:150px;text-align:center;" format="dd/MM/yyyy HH:mm:ss" />
        <duques:column labelProperty="Título"			       		propertyValue="titulo" 					style="width:350px;text-align:left;" />
        <duques:column labelProperty="Nível"			       		propertyValue="nivel" 					style="width:100px;text-align:left;" />
        <duques:column labelProperty="Enviado para"		       		propertyValue="nomeUsuario" 			style="width:200px;text-align:left;" />
        <duques:column labelProperty="Dt Leitura"	 	     		propertyValue="dataResposta"   			style="width:150px;text-align:center;" format="dd/MM/yyyy HH:mm:ss" />
        <duques:column labelProperty="Hotel"			       		propertyValue="nomeHotel" 				style="width:250px;text-align:left;" />
        <duques:column labelProperty="Resposta"	 	     			propertyValue="resposta"   			    style="width:800px;text-align:left;" />
        
                      
    </duques:grid>
    
</s:form>
