<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script>
    function init(){
        
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }


    function creditar(){

        vForm = document.forms[0];
        vForm.action = '<s:url action="manterCreditoEmpresa!prepararAlteracao.action" namespace="/app/rede" />';
        submitForm(vForm);        

    }


    function detalhar(){
			loading();
			_url = "app/ajax/ajax!obterCreditoEmpresaDetalhe?idEmpresa="+document.getElementById('idEmpresa').value+"&data="+<%=new java.util.Date().getTime()%>;
			//submitFormAjax('obterCreditoEmpresaDetalhe?idEmpresa='+document.getElementById('idEmpresa').value,true);
			getAjaxValue(_url,callbackdetalhe);
	}
	function callbackdetalhe( valor ){
		eval(valor);
	}

    function submeterPagina(destino){
        
        vForm = document.forms[0];
        submitForm(vForm);        
        
    }

    function imprimir(pTipo){
    	var reportAddress = "";
    	var params = "";
    	reportAddress = '<s:property value="#session.URL_REPORT"/>';
   		reportAddress += '/index.jsp?REPORT=empresaCreditoDetalheReport';
   		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
   		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
   		params += ';ID_EMP@'+document.getElementById('idEmpresa').value;
   		params += ';TIPO@'+pTipo;
   		reportAddress += '&PARAMS='+params;
   		showPopupGrande(reportAddress);
    }
    
    
currentMenu = "credito";
with(milonic=new menuname("credito")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnComCredito.png;text=Crédito;url=javascript:creditar();");
aI("image=imagens/btnPesquisar.png;text=Detalhar;url=javascript:detalhar();");
drawMenus(); 
}

</script>

<!-- DETALHE DA EMPRESA -->
<div id="divDetalhe" class="divCadastro" style="display:none;height:600px;width:800px;left:10px;top:10px;">
<div id="divDetalheheader">
	<div style="float: left; text-align: left; height: 25px; color: white; font-family: verdana; background-color: rgb(0, 173, 255); width: 730px; font-size: 14px; font-weight: bold;">
		<img src="imagens/iconMozart.png" />Detalhamento da empresa: <label id="divNomeEmpresa"> </label>
	</div>
	<div style="float: left; width: 65px; height: 25px; font-family: verdana; background-color: rgb(0, 173, 255);">
		<img height="24px;" width="24px" src="imagens/iconic/png/print-3x.png" title="Imprimir" onclick="imprimir('');" />
		<img height="24px;" width="24px" src="imagens/iconic/png/xRed-3x.png" title="Fechar" onclick="movePanel.Hide('divDetalhe');" />
	</div>
</div>

<div id="divDetalheBody" class="divGrupo" style="width:98%; height:90%; overflow: auto;">

<div id="divDupVencidas" class="divGrupo" style="height: 200px;">
	<div class="divGrupoTitulo">Duplicatas vencidas</div>
	<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width:60px;"><p style="width:100%">Hotel</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Num duplicata</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Data emissão</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Vencimento</p></div>		
		<div class="divItemGrupo" style="width:100px;text-align:right;"><p style="width:100%">Valor</p></div>
		<div class="divItemGrupo" style="width:50px;float:right;"><img height="24px;" width="24px" src="imagens/iconic/png/print-3x.png" title="Imprimir duplicatas vencidas" onclick="imprimir('1');" /></div>		
	</div>
	<div id="divDupVencidasBody" style="width: 99%; height: 130px; overflow-y: auto;">
	
	
	</div>
</div>

<div id="divDupAbertas" class="divGrupo" style="height: 200px;">
	<div class="divGrupoTitulo">Duplicatas abertas</div>
	<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width:60px;"><p style="width:100%">Hotel</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Num duplicata</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Data emissão</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Vencimento</p></div>		
		<div class="divItemGrupo" style="width:100px;text-align:right;"><p style="width:100%">Valor</p></div>
		<div class="divItemGrupo" style="width:50px;float:right;"><img height="24px;" width="24px" src="imagens/iconic/png/print-3x.png" title="Imprimir duplicatas abertas" onclick="imprimir('2');" /></div>		
	</div>
	<div id="divDupAbertasBody" style="width: 99%; height: 130px; overflow-y: auto;">
	
	
	</div>
</div>

<div id="divReserva" class="divGrupo" style="height: 200px;">
	<div class="divGrupoTitulo">Reservas</div>
	<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width:60px;"><p style="width:100%">Hotel</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Num reserva</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Data entrada</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Data saída</p></div>
		<div class="divItemGrupo" style="width:100px;text-align:right;"><p style="width:100%">Valor</p></div>
		<div class="divItemGrupo" style="width:50px;float:right;"><img height="24px;" width="24px" src="imagens/iconic/png/print-3x.png" title="Imprimir reservas" onclick="imprimir('3');" /></div>
	</div>

	<div id="divReservaBody" style="width: 99%; height: 130px; overflow-y: auto;">
	
	
	</div>
</div>

<div id="divCheckin" class="divGrupo" style="height: 200px;">
	<div class="divGrupoTitulo">Check-ins</div>
		<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width:60px;"><p style="width:100%">Hotel</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Num reserva</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Num checkin</p></div>
		<div class="divItemGrupo" style="width:60px;"><p style="width:100%">Num apto</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Data entrada</p></div>
		<div class="divItemGrupo" style="width:100px;"><p style="width:100%">Data saída</p></div>
		<div class="divItemGrupo" style="width:100px;text-align:right;"><p style="width:100%">Valor</p></div>
		<div class="divItemGrupo" style="width:50px;float:right;"><img height="24px;" width="24px" src="imagens/iconic/png/print-3x.png" title="Imprimir check-ins" onclick="imprimir('4');" /></div>		
	</div>
	
	<div id="divCheckinBody" style="width: 99%; height: 130px; overflow-y: auto;">
	
	
	</div>
</div>
</div>
</div>
<!-- DETALHE DA EMPRESA -->

<s:form action="pesquisarCreditoEmpresa!pesquisar.action" namespace="/app/rede"	theme="simple">
	<s:hidden name="entidade.empresaEJB.idEmpresa" id="idEmpresa"/>
	<div class="divFiltroPaiTop">Pesquisa de crédito</div>
	<div id="divFiltroPai" class="divFiltroPai">
	<div id="divFiltro" class="divFiltro"><duques:filtro
		tableName="CREDITO_EMPRESA_WEB" titulo="" /></div>
	</div>
	<div id="divMeio" class="divMeio">
	<div id="divOutros" class="divOutros" style="width: 520px;">
	
	<ul
		style="width: 210px; float: left; padding: 0px; margin: 0px; list-style: none; font-size: 8pt;">
		<li style="font-size: 8pt;"><img src="imagens/imgLegAmarelo.png"
			width="10px" height="10px" />&nbsp;Saldo negativo</li>
		<li style="font-size: 8pt;"><img src="imagens/imgLegVermelho.png"
			width="10px" height="10px" />&nbsp;Sem crédito</li>
		<li style="font-size: 8pt;"><img src="imagens/imgLegVerde.png"
			width="10px" height="10px" />&nbsp;Dup. vencidas</li>
	</ul>

	</div>

		<div id="divBotao" class="divBotao">
		<duques:botao
			label="Pesquisar" 
			imagem="imagens/iconic/png/magnifying-glass-3x.png"
			onClick="pesquisar();" /> 
		</div>
		
	</div>


	<duques:grid colecao="listaPesquisa" titulo="Crédito de empresa"
		condicao="credito;eq;N;corVermelho#saldo;lt;0;corAmarelo#duplicatasVencidas;mt;0;corVerde#"
		current="obj" idAlteracao="idEmpresa"
		idAlteracaoValue="idEmpresa"
		urlRetorno="pages/modulo/rede/creditoEmpresa/pesquisar.jsp">
		
		<duques:column labelProperty="CNPJ" propertyValue="cnpj" style="width:120px;" />
		<duques:column labelProperty="Nome fantasia" propertyValue="nomeFantasia" style="width:350px;" />
		<duques:column labelProperty="Crédito" propertyValue="credito" style="width:100px;text-align:center;" grouped="true" />
		<duques:column labelProperty="Vr crédito" propertyValue="valorCredito" style="width:120px;text-align:right;"  />
		<duques:column labelProperty="Dup Vencidas D-10" propertyValue="duplicatasVencidas" style="width:150px;text-align:right;" math="sum" />
		<duques:column labelProperty="Dup a vencer D-10" propertyValue="duplicatasAbertas" style="width:150px;text-align:right;" math="sum"  />
		<duques:column labelProperty="Reservas" 	propertyValue="valorReservas" style="width:150px;text-align:right;" math="sum"  />
		<duques:column labelProperty="Check-ins" 	propertyValue="valorCheckins" style="width:150px;text-align:right;" math="sum"  />
		<duques:column labelProperty="Total" 		propertyValue="valorTotal" style="width:150px;text-align:right;" math="sum"  />
		<duques:column labelProperty="Saldo" 		propertyValue="saldo" style="width:150px;text-align:right;" math="sum"  />
		<duques:column labelProperty="Dt cadastro" propertyValue="dataCadastro" style="width:100px;" format="dd/MM/yyyy" />		
		<duques:column labelProperty="Observação" propertyValue="observacao" style="width:400px;" />
	</duques:grid>
</s:form>