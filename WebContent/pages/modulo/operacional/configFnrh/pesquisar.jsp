<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterConfigFnrh!prepararInclusao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterConfigFnrh!prepararAlteracao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }

    function excluir(){
        if (confirm('Deseja realmente excluir este item?')){
			vForm = document.forms[0];
			vForm.action = '<s:url action="pesquisarConfigFnrh!excluir.action" namespace="/app/operacional" />';
			submitForm( vForm );
        }
    }
    
	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
	currentMenu = "configFnrh";
	with(milonic=new menuname("configFnrh")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	aI("image=imagens/iconic/png/x-3x.png;text=Excluir;url=javascript:excluir();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarConfigFnrh!pesquisar.action" namespace="/app/operacional" theme="simple" >
  	
  	<s:hidden name="entidade.idConfig" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Config FNRH</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"></div>
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
    
    <duques:grid colecao="listaPesquisa" titulo="Relat�rio de Config Fnrh" 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idConfig" 
    			 urlRetorno="pages/modulo/operacional/configFnrh/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="T�tulo"				       	propertyValue="titulo"					style="width:250px;"/>
        <duques:column labelProperty="Descri��o"			       	propertyValue="descricao"				style="width:500px;" />
        
                      
    </duques:grid>
    
</s:form>
