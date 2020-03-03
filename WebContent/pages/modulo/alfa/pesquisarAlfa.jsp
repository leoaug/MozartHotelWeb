<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script>
    function init(){
        
    }

    function upload(){
        vForm = document.forms[0];
        vForm.action = '<s:url action="pesquisar!gerarArquivo01.action" namespace="/app/alfa" />';
        
        vForm.submit();
    }


	function gerarArquivo01(){
	
		 vForm = document.forms[0];
	     vForm.action = '<s:url action="pesquisar!gerarArquivo01.action" namespace="/app/alfa" />';
         submitForm(vForm);
	}

    
   function mostrarCertificado(){
        vUrl = '<%=session.getAttribute("URL_BASE")%>pages/certificadoAlfa.jsp?currentSessionID='+document.forms[0].numCertificado.value;
        window.open(vUrl,"NumCertificado", ',status=yes,resizable=no,location=no,type=fullWindow,fullscreen,scrollbars=yes');
   } 

</script>


<script>
currentMenu = "alfa";
with(milonic=new menuname("alfa")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/certificado.png;text=Certificado;url=javascript:mostrarCertificado();");
drawMenus();  
} 
</script>

<s:form action="pesquisar!pesquisa.action" namespace="/app/alfa"
	theme="simple">
	<s:hidden name="numCertificado" id="numCertificado" />
	<div class="divFiltroPaiTop">Pesquisa de Hóspede</div>
	<div id="divFiltroPai" class="divFiltroPai">
	<div id="divFiltro" class="divFiltro"><duques:filtro
		tableName="EMPRESA_SEGURADORA" titulo="" /></div>
	</div>
	<div id="divMeio" class="divMeio">
	<div id="divOutros" class="divOutros"></div>

	<div id="divBotao" class="divBotao"><duques:botao
		label="Pesquisar"
		imagem="imagens/iconic/png/magnifying-glass-3x.png"
		onClick="submitForm(document.forms[0]);" /> 
		
		<s:if test="#session.USER_SESSION.usuarioEJB.idUsuario eq 82">
			<duques:botao label="Arquivo 01" imagem="imagens/btnAlterar.png" style="width:120px;" onClick="gerarArquivo01();" />
		</s:if>
		
		</div>
	</div>

	<!-- grid -->

	<s:if test="#session.USER_SESSION.usuarioEJB.idUsuario eq 82">
		<duques:grid colecao="listaPesquisa" titulo="Relatório de hóspedes"
			condicao="redeHotel;eq;RIO;reservaSemCheckin" current="obj"
			idAlteracao="numCertificado" idAlteracaoValue="certificado"
			urlRetorno="pages/modulo/alfa/pesquisarAlfa.jsp">
			<duques:column labelProperty="Rede de Hotel" grouped="true"
				propertyValue="redeHotel" style="width:250px;" />
			<duques:column labelProperty="Hotel" grouped="true"
				propertyValue="hotel" style="width:250px;" />
			<duques:column labelProperty="Cidade do hotel" propertyValue="local"
				style="width:150px;" />
			<duques:column labelProperty="Apto" propertyValue="apto"
				style="width:80px;" />
			<duques:column labelProperty="Hóspede" propertyValue="nomeHospede"
				style="width:300px;" />
			<duques:column labelProperty="Dt. Nasc."
				propertyValue="dataNascimento" style="width:100px;"
				format="dd/MM/yyyy" />
			<duques:column labelProperty="CPF" propertyValue="cpf"
				style="width:100px;" />
			<duques:column labelProperty="Passaporte" propertyValue="passaporte"
				style="width:100px;" />
			<duques:column labelProperty="Certificado"
				propertyValue="certificado" style="width:100px;" />
			<duques:column labelProperty="Dt. Certificado"
				propertyValue="dataCertificado" style="width:150px;"
				format="dd/MM/yyyy HH:mm:ss" />
			<duques:column labelProperty="Origem" propertyValue="origem"
				style="width:180px;" />
			<duques:column labelProperty="Destino" propertyValue="destino"
				style="width:180px;" />
			<duques:column labelProperty="Dt. Entrada"
				propertyValue="dataEntradaStr" grouped="true" style="width:130px;" />
			<duques:column labelProperty="Dt. In" propertyValue="dataEntrada"
				style="width:180px;" format="dd/MM/yyyy HH:mm:ss" />
			<duques:column labelProperty="Dt. Out" propertyValue="dataSaida"
				style="width:180px;" format="dd/MM/yyyy HH:mm:ss" />
			<duques:column labelProperty="Qtde Diária" propertyValue="qtdeDiaria"
				style="width:100px;text-align:right;" math="sum" />
			<duques:column labelProperty="Vl. Seguro" propertyValue="valorSeguro"
				style="width:100px;text-align:right;" />
			<duques:column labelProperty="Vl. Pago" propertyValue="valorTotal"
				style="width:100px;text-align:right;" math="sum" />
		</duques:grid>
	
	</s:if>
	<s:else>
			<duques:grid colecao="listaPesquisa" titulo="Relatório de hóspedes"
			condicao="redeHotel;eq;RIO;reservaSemCheckin" current="obj"
			idAlteracao="numCertificado" idAlteracaoValue="certificado"
			urlRetorno="pages/modulo/alfa/pesquisarAlfa.jsp">
			<duques:column labelProperty="Hotel" propertyValue="hotel"
				style="width:250px;" />

			<duques:column labelProperty="Cidade do hotel" propertyValue="local"
				style="width:150px;" />
			<duques:column labelProperty="Hóspede" propertyValue="nomeHospede"
				style="width:300px;" />
			<duques:column labelProperty="Dt. Nasc."
				propertyValue="dataNascimento" style="width:100px;"
				format="dd/MM/yyyy" />
			<duques:column labelProperty="CPF" propertyValue="cpf"
				style="width:100px;" />
			<duques:column labelProperty="Passaporte" propertyValue="passaporte"
				style="width:100px;" />
			<duques:column labelProperty="Certificado"
				propertyValue="certificado" style="width:100px;" />
			<duques:column labelProperty="Dt. Certificado"
				propertyValue="dataCertificado" style="width:150px;"
				format="dd/MM/yyyy HH:mm:ss" />
			<duques:column labelProperty="Dt. In" propertyValue="dataEntrada"
				style="width:180px;" format="dd/MM/yyyy HH:mm:ss" />
			<duques:column labelProperty="Dt. Out" propertyValue="dataSaida"
				style="width:180px;" format="dd/MM/yyyy HH:mm:ss" />
				
		</duques:grid>
	
		</s:else>

</s:form>

