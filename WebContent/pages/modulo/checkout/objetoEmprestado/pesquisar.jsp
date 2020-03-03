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
	

	currentMenu = "NENHUM";
	with(milonic=new menuname("objetosEmprestados")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>



  <s:form action="pesquisarObjetoEmprestado!pesquisar.action" namespace="/app/caixa" theme="simple" >
  	
  	<s:hidden name="filtro.idMovimentoObjeto" id="idAlteracao"/>
  	
    <div class="divFiltroPaiTop">Emprestados</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="MOVIMENTO_OBJETO_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />    
        </div>
    
    
    </div>
    
    
 <!-- grid -->
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório de empréstimo de objetos" 
    			 condicao="idMovimentoObjeto;eq;-1;reservaSemCheckin" 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="idMovimentoObjeto" 
    			 urlRetorno="pages/modulo/checkout/objetoEmprestado/pesquisar.jsp">
    			
    		 
        <duques:column labelProperty="Apto" 				propertyValue="apartamento"    	style="width:100px;"/>
        <duques:column labelProperty="Hóspede"      		propertyValue="hospede" 		style="width:250px;" />
        <duques:column labelProperty="Objeto"       		propertyValue="objeto"  		style="width:150px;" />		 
        <duques:column labelProperty="Dt empréstimo"       	propertyValue="data"  			style="width:150px;" />
        <duques:column labelProperty="Qtde"       			propertyValue="qtde"  			style="width:100px;text-align:center;" />
        <duques:column labelProperty="Vl objeto"       		propertyValue="valorObjeto"  	style="width:100px;text-align:right;" />
        <duques:column labelProperty="Vl total"       		propertyValue="valorEmprestimo" style="width:100px;text-align:right;" />
        <duques:column labelProperty="Vl debitado"       	propertyValue="valorLancamento" style="width:100px;text-align:right;" />
        <duques:column labelProperty="Observação"       	propertyValue="observacao" 		style="width:350px;" />
        
        
                
    </duques:grid>
    
</s:form>

