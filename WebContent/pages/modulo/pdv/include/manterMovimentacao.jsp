<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<jsp:scriptlet>String base = request.getRequestURL().toString().substring(0,
					request.getRequestURL().toString().indexOf(request.getContextPath())
							+ request.getContextPath().length() + 1);
			session.setAttribute("URL_BASE", base);
			response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
			response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
			response.addHeader("Cache-Control", "post-check=0, pre-check=0");
			response.setHeader("Pragma", "no-cache");</jsp:scriptlet>

<html>
<head>
<base href="<%=base%>" />
<%@ include file="/pages/modulo/includes/headPage.jsp"%>
</head>

<script type="text/javascript">

function getPrato(elemento) {
	
	url = 'app/ajax/ajax!pesquisarPratoHotel?OBJ_NAME=' 
			+ elemento.id
			+ '&OBJ_VALUE=' 
			+ elemento.value 
			+ '&OBJ_HIDDEN=idPrato';
	getDataLookup(elemento, url, 'Prato', 'TABLE');
}

function selecionarPrato(
		elemento, elementoOculto, 
		valorTextual, idEntidade) {
	window.MozartNS.GoogleSuggest.selecionar(elemento, valorTextual, 
			elementoOculto, idEntidade);
}

function adicionarMovimentacao(){
	
	if(!parent.validarParent()){
		return false;
	}
	 
	if ($('#prato').val() == ''){
		parent.alerta("O campo 'Prato' é obrigatório");
		return false;
	}
	
	if ($('#quantidade').val() == ''){
		parent.alerta("O campo 'Quantidade' é obrigatório");
		return false;
	}
	
	if ($('#desconto').val() == ''){
		parent.alerta("O campo 'Desconto' é obrigatório");
		return false;
	}
	
	if ($('#desconto').val() > 100.0){
		parent.alerta("O campo 'Desconto' deve ser menor ou igual a 100%");
		return false;
	}
	
	preencherValoresPai();
	
	parent.loading();
    document.forms[0].submit();
}

function excluirMovimentacao(id, idx){
	if (confirm('Confirma a exclusão do movimento?')){
	    
		document.forms[0].action = '<s:url namespace="/app/pdv" action="include" method="excluirMovimento" />';
		$("#idMovimentoExclusao").val( id ) ;
		$("#indice").val( idx ) ;
		
	    parent.loading();
	    document.forms[0].submit();
	}
}

function pesquisarMovimentacao(){
	preencherValoresPai();
	document.forms[0].action = '<s:url namespace="/app/pdv" action="include" method="pesquisarMovimentacao" />';
	
    parent.loading();
    document.forms[0].submit();
	
}

function killModalPai(){
	parent.killModal();
}

function preencherValoresPai(){
	$('#pontoVenda').val(parent.document.forms[0].pontoVenda.value);
	$('#tipoRefeicao').val(parent.document.forms[0].tipoRefeicao.value);
	$('#idCheckin').val(parent.document.forms[0].idCheckin.value);
	$('#idMesa').val(parent.document.forms[0].idMesa.value);
	$('#garcon').val(parent.document.forms[0].garcon.value);
	$('#numPessoas').val(parent.document.forms[0].numPessoas.value);
	$('#numComanda').val(parent.document.forms[0].numComanda.value);
}

function atualizarValoresPai(){
	if($('#garcon').val() != null && $('#garcon').val().trim() != '')
		parent.document.forms[0].garcon.value=$('#garcon').val();
	
	if($('#numPessoas').val() != null && $('#numPessoas').val().trim() != '')
		parent.document.forms[0].numPessoas.value=$('#numPessoas').val();
}

function resetLancamento() {
}

function calcularValorParcial() {
	var percentual = $('#percTaxaServico').val();
	parent.document.forms[0].percTaxaServico.value = percentual;
	var tot = $("input:checkbox[class='chk']").length;
	var totSelecionado = $("input:checkbox[class='chk'][checked='true']").length;
	parent.chkTodos.checked= (tot==totSelecionado);
		
	var valorParcial = 0;
	for(idx=0; idx < totSelecionado; idx++ ){
		idChk = $("input:checkbox[class='chk'][checked='true']")[idx].value;
		valor = Trim($($("div[id='divLinha"+idChk+"'] .divItemGrupo")[9]).text().replace(".","").replace(",","."));
		valorParcial +=  parseFloat( valor ) * 100/100;
	}
	if(valorParcial>0){
		parent.habilitarFormaPagamento();
	}else{
		parent.desabilitarFormaPagamento();
	}
	parent.document.forms[0].valorParcial.value = arredondaFloat((valorParcial* 100)/100).toString().replace(".",",");
	parent.document.forms[0].valorTaxa.value = arredondaFloat(valorParcial*(percentual/100)).toString().replace(".",",");
	parent.document.forms[0].valorPagar.value = arredondaFloat(valorParcial*(percentual/100)+((valorParcial* 100)/100)).toString().replace(".",",");
}

function calcularValorTotal() {
	var valorTotal = $('#valorTotal').val();
	
	if(valorTotal != null && valorTotal.trim() != '')
		parent.document.forms[0].valorTotal.value = valorTotal.toString().replace(".",",");	
}

$(function() {
	$(".chk").click(
            function() { 
            	calcularValorParcial();
            	parent.atualizaSaldoValores();
            }
    );
});

function habilitaCheckTodos() {
	calcularValorTotal();
	parent.document.forms[0].chkTodos.disabled=false;
}

function desabilitaCheckTodos() {
	calcularValorTotal();
	parent.document.forms[0].chkTodos.disabled=true;
}

function vendeItens(){
	aCupomFiscal = parent.document.appletCupomFiscal;
	
	<s:iterator value="#session.entidadeSession" var="mov">
	
		// VendeItem(String codigo, 
		// String descricao, String aliquota,String tipoQuantidade, 
		// String cQuantidade, int iCasasDecimais,
		// String cUnitario, String tipoDesconto,
		// String desconto)
		aCupomFiscal.vendeItem('<s:property value="idPrato"/>',
				'<s:property value="nomePrato"/>','FF','I',
				'<s:property value="quantidade"/>',2,
				'<s:property value="valorUnitario"/>','$',
				'<s:property value="valorDesconto"/>');
	
	</s:iterator>
}


</script>

<body style="margin: 0px;">
	<!-- <div class="divGrupo"
			style="overflow: none; margin-top: 0px; width: 99%; border: 0px;">
			</div>-->
	<div class="divGrupo"
		style="overflow: auto; margin-top: 0px; width: 98%; height: 98%; border: 0px;">
		<s:form namespace="/app/pdv" action="include!incluirMovimentacao"
			theme="simple">
			<s:hidden name="status" id="status" />
			<s:hidden name="pontoVenda" id="pontoVenda" />
			<s:hidden name="tipoRefeicao" id="tipoRefeicao" />
			<s:hidden name="idCheckin" id="idCheckin" />
			<s:hidden name="idMesa" id="idMesa" />
			<s:hidden name="garcon" id="garcon" />
			<s:hidden name="numPessoas" id="numPessoas" />
			<s:hidden name="numComanda" id="numComanda" />
			<s:hidden name="percTaxaServico" id="percTaxaServico" />
			<s:hidden name="valorTotal" id="valorTotal" />
			<s:hidden name="indice" id="indice" />
			<s:hidden name="idMovimentoExclusao" id="idMovimentoExclusao" />

			<div class="divLinhaCadastroPrincipal"
				style="width: 99%; float: left; height: 25px;">
				<div class="divItemGrupo" style="width: 350px;">
					<p style="width: 70px;">Produto:</p>
					<s:textfield cssClass="prato" name="prato" id="prato" size="40"
						maxlength="50" onblur="getPrato(this);" />
					<s:hidden name="idPrato" id="idPrato" />
				</div>

				<div class="divItemGrupo" style="width: 140px;">
					<p style="width: 30px;">Qtd:</p>
					<s:textfield cssClass="quantidade" name="quantidade"
						id="quantidade" onkeypress="mascara(this, quantidadeDecimal)"
						size="10" maxlength="10" cssStyle="text-align: right;" />
				</div>

				<div class="divItemGrupo" style="width: 180px;">
					<p style="width: 75px;">Desconto %:</p>
					<s:textfield cssClass="desconto" name="desconto" id="desconto" value="0,00"
						onkeypress="mascara(this, moeda)" size="6" maxlength="6"
						cssStyle="text-align: right;" />
				</div>

				

				<div class="divItemGrupo" style="width: 30px;">
					<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png"
						title="Adicionar Movimentação" style="margin: 0px;"
						onclick="adicionarMovimentacao();" />
				</div>

			</div>


			<s:iterator value="#session.entidadeSession" status="row">

				<div class="divLinhaCadastro"
					id='divLinha<s:property value="idMovimentoRestaurante" />'
					style="margin-bottom: 0px; border: 0px; width: 99%; float: left; height: 20px;">
					<div class="divItemGrupo"
						style="width: 25px; border-right: 1px solid black;">
						<input type="checkbox"
							value='<s:property value="idMovimentoRestaurante" />'
							name="idMovimentosRestaurante" class="chk" />
					</div>
					
					<div class="divItemGrupo" style="width: 250px;">
						<s:property value="nomePrato" />
					</div>

					<div class="divItemGrupo" style="width: 30px;">
						<p style="width: 30px;">Qtd:</p>
					</div>

					<div class="divItemGrupo"
						style="width: 10px; padding-right: 10px; text-align: right;">
						<s:property value="quantidade" />
					</div>

					<div class="divItemGrupo" style="width: 45px;">
						<p style="width: 45px;">Vlr Unit:</p>
					</div>
					<div class="divItemGrupo"
						style="width: 60px; padding-right: 10px; text-align: right;">
						<s:property value="vlUnitario" />
					</div>

					<div class="divItemGrupo" style="width: 70px;">
						<p style="width: 70px;">Desconto %:</p>
					</div>
					<div class="divItemGrupo"
						style="width: 20px; padding-right: 10px; text-align: right;">
						<s:property value="vlDesconto" />
					</div>

					<div class="divItemGrupo" style="width: 35px;">
						<p style="width: 35px;">Total:</p>
					</div>
					<div class="divItemGrupo"
						style="width: 60px; text-align: right; padding-right: 10px;">
						<s:property value="vlPrato" />
					</div>
					<div class="divItemGrupo" style="width: 60px;">
						<p style="width: 60px;">Comanda:</p>
					</div>
					<div class="divItemGrupo"
						style="width: 60px;">
						<s:property value="numComanda" />
					</div>
					<div class="divItemGrupo" style="width: 45px;">
						<p style="width: 45px;">Garçon:</p>
					</div>
					<div class="divItemGrupo"
						style="width: 95px;">
						<s:property value="nomeGarcon" />
					</div>

					<div class="divItemGrupo" style="width: 31px;">
						<img width="30px" height="30px" title="Excluir lançamento"
							src="imagens/iconic/png/x-3x.png"
							onclick="excluirMovimentacao('<s:property value="idMovimentoRestaurante" />', '${row.index}')" />
					</div>

				</div>

			</s:iterator>
		</s:form>
	</div>
</body>

<script>
	killModalPai();
	resetLancamento();
	atualizarValoresPai();
	<s:if test="%{#session.entidadeSession != null && #session.entidadeSession.size > 0}">
		habilitaCheckTodos();
		//parent.bloquearCamposAposInclusao();
	</s:if>
	<s:else>
		desabilitaCheckTodos();
		//parent.desbloquearCamposAposRemocao();
	</s:else>
</script>

</html>