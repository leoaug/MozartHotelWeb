<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<jsp:scriptlet>String base = request
					.getRequestURL()
					.toString()
					.substring(
							0,
							request.getRequestURL().toString()
									.indexOf(request.getContextPath())
									+ request.getContextPath().length() + 1);
			session.setAttribute("URL_BASE", base);
			response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
			response.setHeader("Cache-Control",
					"no-store, no-cache, must-revalidate");
			response.addHeader("Cache-Control", "post-check=0, pre-check=0");
			response.setHeader("Pragma", "no-cache");</jsp:scriptlet>

<html>
<head>
<base href="<%=base%>" />
<%@ include file="/pages/modulo/includes/headPage.jsp"%>
</head>

<script type="text/javascript">

function getApartamento(elemento, idHidden, div) {
	url = 'app/ajax/ajax!pesquisarApartamentoHospede?OBJ_NAME='
			+ elemento.id + '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN='
			+ idHidden;
	getDataLookup(elemento, url, div, 'TABLE');
}

function selecionarApartamento(elemento, elementoOculto, valorTextual,
		idEntidade, idCheckin) {
	window.MozartNS.GoogleSuggest.selecionar(elemento, valorTextual,
			elementoOculto, idEntidade);
	$('#idRoomListDebito').val(idCheckin);
}

function habilitarFormaPagamento() {
	//$('#idTipoLancamento').attr('disabled',
	//		false);
	//$('#idTipoLancamento').css(
	//		'background-color', 'white');
	//$('#valorPagamento').attr('readonly', false);
	//$('#valorPagamento').css('background-color',
	//		'white');

}
function desabilitarFormaPagamento() {
//	$('#idTipoLancamento').attr('disabled',
//	'disabled');
//	$('#idTipoLancamento').val('');
//	$('#idTipoLancamento').css(
//		'background-color', 'silver');
//	$('#valorPagamento').attr('readonly',
//		true);
//	$('#valorPagamento').css('background-color',
//		'silver');
//	liberarAptoDebito('0');
}



function liberarAptoDebito(idIdentificaLancamento) {
	$("#idIdentificaLancamento").val = idIdentificaLancamento;
	$("#idIdentificaLancamento").val(idIdentificaLancamento);
	idIdentificaLancamentoAux = '<s:property value="restauranteProprio?18:53"/>';

	if (idIdentificaLancamentoAux == idIdentificaLancamento) {
		$("#apartamentoDebito").attr("readOnly", false);
		$("#apartamentoDebito").css('background-color', 'white');
		$("#divAptoDebido").show();
		$("#divAptoDebidoVazio").hide();
		$("#divRestContaCorrente").hide();
		$("#").attr("readOnly", true);
		$("#").css('background-color', 'silver');
	}
	else {
		if (idIdentificaLancamento == 18) {
			$("#divRestContaCorrente").show();
			$("#divAptoDebidoVazio").hide();
			$("#divAptoDebido").hide();
			$("#apartamentoDebito").attr("readOnly", true);
			$("#apartamentoDebito").css('background-color', 'silver');
			$("#apartamentoDebito").val("");
			$("#idApartamentoDebito").val("");
		}
		else {
			$("#divAptoDebidoVazio").show();
			$("#divAptoDebido").hide();
			$("#apartamentoDebito").attr("readOnly", true);
			$("#apartamentoDebito").css('background-color', 'silver');
			$("#apartamentoDebito").val("");
			$("#idApartamentoDebito").val("");
			$("#divRestContaCorrente").hide();
		}
	}

}

function adicionarPgto(){

	if(!parent.validarParent()){
		return false;
	}
	 
	if ($('#idTipoLancamento').val() == ''){
		parent.alerta("O campo 'Forma Pag' é obrigatório");
		return false;
	}
	
	if ($('#valorPagamento').val() == ''){
		parent.alerta("O campo 'Valor pago' é obrigatório");
		return false;
	}

	idIdentificaLancamentoAux = '<s:property value="restauranteProprio?18:53"/>';
	idIdentificaLancamento = $("#idIdentificaLancamento").val();
	
	if (idIdentificaLancamentoAux == idIdentificaLancamento) {
		if ($('#idRoomListDebito').val() == ''){
			parent.alerta("O campo 'apto a debitar' é obrigatório");
			return false;
		}
	}
	else{
		if (idIdentificaLancamento == 18 && $('#idContaCorrenteDebito').val() == ''){
			parent.alerta("O campo 'Ct Corrente' é obrigatório");
			return false;
		}
	}

	var idMovimentos = parent.getIdMovimentosSelecionados();

	idMovimentos.forEach(carregarIdMovimentosPagamento);
	
	$("#pontoVenda").val( parent.document.getElementById("pontoVenda").value ) ;
	$("#valorTaxa").val( parent.document.getElementById("valorTaxa").value ) ;

	parent.loading();
    document.forms[0].submit();
}

function carregarIdMovimentosPagamento(item, index){
	$("#idMovimentosPagamento").val( item ) ;
	
	var input = document.createElement("input");

	input.setAttribute("type", "hidden");

	input.setAttribute("name", "idMovimentosPagamento");
	input.setAttribute("id", "idMovimentosPagamento"+index);

	input.setAttribute("value", item);

	document.forms[0].appendChild(input);
}

function excluirPgto(id, idx){
	if (confirm('Confirma a exclusão do Pagamento?')){
	    
		document.forms[0].action = '<s:url namespace="/app/pdv" action="include" method="removerPgto" />';
		$("#idPgtoExclusao").val( id ) ;
		$("#indicePgto").val( idx ) ;
		
	    parent.loading();
	    document.forms[0].submit();
	}
}

function killModalPai(){
	parent.killModal();
}

function efetuaPagamentos(){
	aCupomFiscal = parent.document.appletCupomFiscal;
	<s:iterator value="#session.pgtoSession">
		aCupomFiscal.efetuaPagamento('<s:property value="tipoLancamentoEJB.descricaoLancamento"/>',
									 '<s:property value="valorLancamento<0?valorLancamento*-1:valorLancamento"/>');
	</s:iterator>

	
}


</script>

<body>
	<div class="divGrupo"
		style="overflow: auto; margin-top: 0px; width: 99%; height: 98%; border: 0px;">
		<s:form namespace="/app/pdv" action="include!adicionarPgto"
			theme="simple">

			<s:hidden name="status" id="status" />
			<s:hidden name="pontoVenda" id="pontoVenda" />
			<s:hidden name="tipoRefeicao" id="tipoRefeicao" />
			<s:hidden name="idApartamento" id="idApartamento" />
			<s:hidden name="idMesa" id="idMesa" />
			<s:hidden name="garcon" id="garcon" />
			<s:hidden name="numPessoas" id="numPessoas" />
			<s:hidden name="numComanda" id="numComanda" />
			<s:hidden name="percTaxaServico" id="percTaxaServico" />
			<s:hidden name="valorTaxa" id="valorTaxa" />
			<s:hidden name="valorTotal" id="valorTotal" />
			<s:hidden name="indicePgto" id="indicePgto" />
			<s:hidden name="idPgtoExclusao" id="idPgtoExclusao" />


			<div class="divLinhaCadastroPrincipal"
				style="width: 99.9%; float: left; height: 25px;">

				<div class="divItemGrupo" style="width: 192px;">
					<p style="width: 65px;">Forma Pag:</p>
					<s:hidden name="idIdentificaLancamento"
						cssClass="idIdentificaLancamento" id="idIdentificaLancamento"></s:hidden>
					<select 
						onchange="liberarAptoDebito(this.options[this.selectedIndex].id);"
						style="width: 120px; "
						id="idTipoLancamento" name="idTipoLancamento">
						<option value="">Selecione</option>
						<s:iterator value="tipoPagamentoList" var="tpPgto">
							<option value="<s:property value='idTipoLancamento'/>"
								id="<s:property value='identificaLancamento.idIdentificaLancamento'/>">
								<s:property value="descricaoLancamento" />
							</option>

						</s:iterator>
					</select>
				</div>

				<div class="divItemGrupo" style="width: 160px;">
					<p style="width: 65px;">Valor Pago:</p>
					<s:textfield style="width: 70px;" cssClass="valorPagamento" name="valorPagamento" id="valorPagamento"
						onkeypress="mascara(this, moeda)" size="10"
						maxlength="10" 
						cssStyle="text-align: right;" />
				</div>
				<div class="divItemGrupo" id="divAptoDebido"
					style="display: none; width: 270px;">
					<p style="width: 80px;">Hóspede:</p>
										
						<s:select list="listApartamentoHospede" name="idRoomListDebito"
							id="idRoomListDebito" headerKey="" headerValue="Selecione" value="idRoomListDebito"
							listValue="texto" listKey="bcIdRoomList" />
				</div>
				<div class="divItemGrupo" id="divRestContaCorrente"
					style="display: none; width: 270px;">
					<p style="width: 80px;">Ct. Corrente:</p>
										
						<s:select list="listContaCorrente" name="idContaCorrenteDebito"
							id="idContaCorrenteDebito" headerKey="" headerValue="Selecione" value="idContaCorrenteDebito"
							listKey="bcIdCheckin" listValue="%{gracNumApto + ' - ' + gracNomeFantasiaEmpresaRede}" />
				</div>
				<div class="divItemGrupo" id="divAptoDebidoVazio"
					style="display: block; width: 270px;">
				</div>
				<div class="divItemGrupo" style="width: 30px;">
					<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png"
						title="Adicionar Pagamento" style="margin: 0px;"
						onclick="adicionarPgto();" />
				</div>
			</div>
			<s:iterator value="#session.pgtoSession" status="row" var="p"  >
				<s:if test="valorLancamento>0">
					<div class="divLinhaCadastro"
						id='divLinha<s:property value="idPgtoRestaurante" />'
						style="margin-bottom: 0px; border: 0px; width: 99%; float: left; height: 20px;">
	
						<div class="divItemGrupo" style="width: 192px;">
							<p style="width: 65px;">Forma pag:</p>
							<s:property value="tipoLancamentoEJB.descricaoLancamento" />
						</div>
	
						<div class="divItemGrupo" style="width: 65px;">
							<p style="width: 65px;">Valor pago:</p>
						</div>
	
						<div class="divItemGrupo" style="width: 78px;text-align:right; padding-right:10px">
							<s:property value="valorLancamento" />
						</div>
						<s:if test="%{#checkinEJB.apartamentoEJB.cofan.equals('N')}">
							<div class="divItemGrupo" style="width: 65px;">
								<p style="width: 65px;">Apto:</p>
							</div>
							<div class="divItemGrupo" style="width: 70px; padding-right:10px">
								<s:property value="checkinEJB.apartamentoEJB.numApartamento" /> 
							</div>
						</s:if>
						<s:else >
							<div class="divItemGrupo" style="width: 263px;" ></div>
						</s:else >
	
						
						<div class="divItemGrupo" style="width: 31px;">
							<img width="30px" height="30px" title="Excluir pagamento"
								src="imagens/iconic/png/x-3x.png"
								onclick="excluirPgto('<s:property value="idPgtoRestaurante" />', '${row.index}')" />
						</div> 
					</div>
				</s:if>
			</s:iterator>
		</s:form>
	</div>
</body>

<script>
	parent.atualizarValores('<s:property value="valorPago" />');
	killModalPai();
	resetLancamento();
	<s:if test="%{#session.entidadeSession != null && #session.entidadeSession.size > 0}">
		habilitaCheckTodos();
		parent.bloquearCamposAposInclusao();
	</s:if>
	<s:else>
		desabilitaCheckTodos();
		parent.desbloquearCamposAposRemocao();
	</s:else>
</script>

</html>