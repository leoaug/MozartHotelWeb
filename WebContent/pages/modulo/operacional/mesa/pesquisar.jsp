<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterMesa!prepararInclusao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterMesa!prepararAlteracao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }

	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
	currentMenu = "mesa";
	with(milonic=new menuname("mesa")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarMesa!pesquisar.action" namespace="/app/operacional" theme="simple" >
  	
  	<s:hidden name="entidade.idMesa" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Mesa</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro">
            <duques:filtro tableName="MESA_WEB" titulo="" />
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de Mesa" 
    			 condicao="idMesa;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idMesa" 
    			 urlRetorno="pages/modulo/operacional/mesa/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Nº Mesa"			       		propertyValue="numMesa"					style="width:100px;text-align:left;" />
        <duques:column labelProperty="Nome garçon"				    propertyValue="nomeGarcon"				style="width:250px;text-align:left;" />
        <duques:column labelProperty="Nome Ponto Venda"		       	propertyValue="nomePontoVenda"			style="width:250px;text-align:left;" />
        <duques:column labelProperty="Status mesa"       			propertyValue="statusMesa"				style="width:120px;text-align:left;" />
        <duques:column labelProperty="Nº Pessoas"	       			propertyValue="numPessoas"				style="width:110px;text-align:left;" />        
                      
    </duques:grid>
    
</s:form>
