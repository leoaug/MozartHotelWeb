<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterApartamento!prepararInclusao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

function alterarApartamento(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="manterApartamento!prepararAlteracao.action" namespace="/app/operacional" />';
	submitForm( vForm );
}
    
    
currentMenu = "apto";
with(milonic=new menuname("apto")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:alterarApartamento();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarApartamento!pesquisar.action" namespace="/app/operacional" theme="simple" >
  	<s:hidden name="apto.idApartamento" id="apto"/>
  	<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1}" var="isHotel" />
  	<s:set var="labelTela" >
	  	<s:if test="isHotel">Apartamentos</s:if>
	  	<s:else>Conta Corrente</s:else>
  	</s:set>
  		<s:set var="display" >
	  	<s:if test="isHotel">block</s:if>
	  	<s:else>none</s:else>
  	</s:set>
  	
    <div class="divFiltroPaiTop"><s:property value="#labelTela" /> </div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <s:if test="isHotel"><duques:filtro tableName="APARTAMENTO_WEB" titulo="" /></s:if>
            <s:else><duques:filtro tableName="APARTAMENTO_GERAL" titulo="" /></s:else>
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
    <duques:grid colecao="listaPesquisa" titulo="Relatório de apartamento" 
    			 condicao="numApartamento;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="apto" idAlteracaoValue="idApartamento" urlRetorno="pages/modulo/operacional/apartamento/pesquisarApartamento.jsp">
        <duques:column labelProperty="Número"    		propertyValue="numApartamento"      style="width:100px;"/>
        <duques:column labelProperty="Tipo"    		    propertyValue="tipoApartamentoEJB.fantasia"      style="width:100px;"/>
        <s:if test="isHotel">
	        <duques:column labelProperty="Área"         	propertyValue="area"            	style="width:100px; "/>
	        <duques:column labelProperty="Status"       	propertyValue="status"            	style='width:100px;text-align:center; ' />
	        <duques:column labelProperty="Cofan"      		propertyValue="cofan"          		style='width:100px;text-align:center; ' />
	        <duques:column labelProperty="Característica"   propertyValue="caracteristica"      style='width:150px; display: ' />
	        <duques:column labelProperty="Bloco"       		propertyValue="bloco"  				style='width:100px;text-align:center; ' />
	        <duques:column labelProperty="Camareira"       	propertyValue="camareira.nomeCamareira"  style='width:220px;text-align:center; ' />
	        <duques:column labelProperty="Dt Int.In"        propertyValue="dataEntrada"         style='width:110px;text-align:center; ' />
	        <duques:column labelProperty="Dt Int.Out"      	propertyValue="dataSaida"          	style='width:110px;text-align:center; ' />
        </s:if>
        <duques:column labelProperty="Observação"   	propertyValue="observacao"      	style="width:350px;" />
        
    </duques:grid>
    
</s:form>

