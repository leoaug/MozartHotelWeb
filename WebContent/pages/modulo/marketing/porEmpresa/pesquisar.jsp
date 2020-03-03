<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function pesquisar(){
		vForm = document.forms[0];
		if (vForm.elements["filtro.filtroPeriodo.tipoIntervalo"].value == '' || vForm.elements["filtro.filtroPeriodo.valorInicial"].value=='' || vForm.elements["filtro.filtroPeriodo.valorFinal"].value == ''){
			alerta("O campo 'Período' é obrigatorio ou está inválido.");
			return false;			
		}
		submitForm( vForm );

     }

    function relatorio() {        
        document.forms[0].action = '<s:url action="porEmpresaRelatorio!prepararRelatorioPorEmpresa.action" namespace="/app/marketing" />';        
        submitForm(document.forms[0]);
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


  <s:form action="porEmpresa!pesquisarPorEmpresa.action" namespace="/app/marketing" theme="simple" >
  	<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1}" var="isHotel" />
  	<input type="hidden" name="idSelecionado" id="chave"/>
    <div class="divFiltroPaiTop">Por Empresa</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="MKT_POR_EMPRESA" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />
            <s:if test="isHotel"><duques:botao label="Relatório" imagem="imagens/iconic/png/print-3x.png" onClick="relatorio();" /></s:if>
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="Relatório de reservas por empresa" 
    			 condicao="idEmpresa;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="chave" idAlteracaoValue="idEmpresa" urlRetorno="pages/modulo/marketing/porEmpresa/pesquisar.jsp">
        <duques:column labelProperty="Hotel"    		propertyValue="sigla"      	   style="width:100px;" grouped="true"/>
        <duques:column labelProperty="Reserva"    		propertyValue="idReserva"      style="width:100px;" grouped="true"/>
        <duques:column labelProperty="Forma reserva"    propertyValue="formaReserva"   style="width:150px;"/>
        <duques:column labelProperty="Empresa"    		propertyValue="nomeFantasia"   style="width:300px;" grouped="true"/>
        <duques:column labelProperty="Tipo empresa"    	propertyValue="tipoEmpresa"    style="width:150px;"/>
        <duques:column labelProperty="Cidade"    		propertyValue="cidadeEmpresa"  style="width:150px;" grouped="true"/>
        <duques:column labelProperty="Estado"    		propertyValue="estadoEmpresa"  style="width:150px;" grouped="true"/>
        <duques:column labelProperty="País"    			propertyValue="paisEmpresa"    style="width:150px;"/>
        <duques:column labelProperty="Promotor"       	propertyValue="promotor"       style="width:250px;" grouped="true"/>
        <duques:column labelProperty="Usuário"       	propertyValue="nick"       	   style="width:150px;" grouped="true"/>
        <duques:column labelProperty="CRS"      		propertyValue="nomeCrs"        style="width:150px;" />
        <duques:column labelProperty="Hóspede"   		propertyValue="nomeHospede"    style="width:300px;" />
        <duques:column labelProperty="E-mail"   		propertyValue="email"   	   style="width:250px;"/>
        <duques:column labelProperty="Cidade Origem"	propertyValue="cidadeOrigem"  style="width:150px;" grouped="true"/>
        <duques:column labelProperty="Cidade Destino"	propertyValue="cidadeDestino"  style="width:200px;" grouped="true"/>
        <duques:column labelProperty="Grupo"   			propertyValue="nomeGrupo"      style="width:200px;" />
        <duques:column labelProperty="Dt entrada"       propertyValue="dataEntrada"    style="width:100px;text-align:center;" format="dd/MM/yyyy" />
        <duques:column labelProperty="Dt saída"         propertyValue="dataSaida"  	   style="width:100px;text-align:center;" format="dd/MM/yyyy" />
        <duques:column labelProperty="Qtde RN"       	propertyValue="qtdeRoomNight"  style="width:90px;text-align:center;" math="sum"/>
        <duques:column labelProperty="Valor diária"     propertyValue="valorDiaria"    style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Valor extra"      propertyValue="valorExtra"     style="width:110px;text-align:right;"  math="sum"/>
        <duques:column labelProperty="Valor total"      propertyValue="valorTotal"     style="width:110px;text-align:right;"  math="sum"/>
        <duques:column labelProperty="Diária média"     propertyValue="diariaMedia"    style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Diária média extra"      propertyValue="diariaMediaExtra"     style="width:140px;text-align:right;"  />
        <duques:column labelProperty="Ticket médio"      propertyValue="ticketMedio"     style="width:110px;text-align:right;"  math="sum"/>
        
        
        
        
    </duques:grid>
    
</s:form>

