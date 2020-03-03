<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>


<script>
    function init(){
        
    }

    function relatorio() {        
        document.forms[0].action = '<s:url action="prepararTarifaRelatorio!prepararRelatorio.action" namespace="/app/comercial" />'        
        submitForm(document.forms[0]);
    }
    
    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTarifa!prepararInclusao.action" namespace="/app/comercial" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTarifa!prepararAlteracao.action" namespace="/app/comercial" />';
		submitForm( vForm );
	}
    
    
currentMenu = "tarifa";
with(milonic=new menuname("tarifa")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarTarifa!pesquisar.action" namespace="/app/comercial" theme="simple" >
  	<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1}" var="isHotel" />
  	<s:hidden name="entidade.idTarifa" id="chave"/>
    <div class="divFiltroPaiTop">Tarifa</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="TARIFA_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />
            <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />   
            <s:if test="isHotel"><duques:botao label="Relatório" imagem="imagens/iconic/png/print-3x.png" onClick="relatorio();" /> </s:if>       
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="Relatório de tarifa" 
    			 condicao="bcIdTarifa;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="chave" idAlteracaoValue="bcIdTarifa" 
    			 urlRetorno="pages/modulo/comercial/tarifa/pesquisar.jsp">
    			 
    	<duques:column labelProperty="Hotel"       	propertyValue="bcSiglaHotel"	style="width:80px;" />		 
    	<duques:column labelProperty="Grupo tarifa"       	propertyValue="bcTarifaGrupo"	style="width:120px;" />
    	<duques:column labelProperty="Descrição"       	propertyValue="bcDescricao"	style="width:300px;" />
    	<duques:column labelProperty="Dt inicial"       	propertyValue="bcDataEntrada"	style="width:100px;text-align:center;" format="dd/MM/yyyy" />
    	<duques:column labelProperty="Dt final"       	propertyValue="bcDataSaida"	style="width:100px;text-align:center;" format="dd/MM/yyyy" />
    	<duques:column labelProperty="Moeda"       	propertyValue="bcMoeda"	style="width:80px;" />
    	<duques:column labelProperty="Tipo"       	propertyValue="bcTipo"	style="width:80px;" />
    	<duques:column labelProperty="Ativo"       	propertyValue="bcAtivo"	style="width:80px;" />
    	<duques:column labelProperty="Usuário"       	propertyValue="bcUsuario"	style="width:150px;" />
    	<duques:column labelProperty="Observação"       	propertyValue="bcObservacao"	style="width:350px;" />
        
    </duques:grid>
    
</s:form>

