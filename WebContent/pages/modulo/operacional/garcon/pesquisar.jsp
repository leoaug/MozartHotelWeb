<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterGarcon!prepararInclusao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterGarcon!prepararAlteracao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
	currentMenu = "garcon";
	with(milonic=new menuname("garcon")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarGarcon!pesquisar.action" namespace="/app/operacional" theme="simple" >
  	
  	<s:hidden name="entidade.idGarcon" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Garçon</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro">
            <duques:filtro tableName="GARCON_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Garçon" 
    			 condicao="idGarcon;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idGarcon" 
    			 urlRetorno="pages/modulo/operacional/garcon/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Nome Garçon"			       	propertyValue="nomeGarcon"				style="width:250px;text-align:left;" />
		<duques:column labelProperty="Ativo"				       	propertyValue="ativo"					style="width:80px;text-align:left;" />
        <duques:column labelProperty="Comissão"				       	propertyValue="comissao"				style="width:100px;text-align:left;" />
        <duques:column labelProperty="Data"				       		propertyValue="data"					style="width:200px;text-align:left;" />        

                      
    </duques:grid>
    
</s:form>
