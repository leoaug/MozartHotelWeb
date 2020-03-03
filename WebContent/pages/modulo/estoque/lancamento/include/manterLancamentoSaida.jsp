<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<jsp:scriptlet>
	String  base = request.getRequestURL().toString().substring(0, request.getRequestURL().toString().indexOf(request.getContextPath())+request.getContextPath().length()+1);
	session.setAttribute("URL_BASE", base);
	response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
	response.setHeader("Cache-Control","no-store, no-cache, must-revalidate");
	response.addHeader("Cache-Control", "post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
</jsp:scriptlet>

<html>
<head>
	<base href="<%=base%>" />
	<%@ include file="/pages/modulo/includes/headPage.jsp"%>
</head>

<script type="text/javascript">

window.onload = function() {
};

function addPlaceHolder(classe, message) {
	document.getElementById(classe).setAttribute("placeholder",
			message);
}

function getItemEstoque(elemento) {
	url = 'app/ajax/ajax!obterItensEstoqueMovimentoEstoque?OBJ_NAME=' 
			+ elemento.id
			+ '&OBJ_VALUE=' 
			+ elemento.value 
			+ '&OBJ_HIDDEN=idItemEstoque';
	getDataLookup(elemento, url, 'ItemEstoque', 'TABLE');
}

function selecionarItemEstoque(
		elemento, elementoOculto, 
		valorTextual, idEntidade,
		unidadeEstoque, idFiscalIncidencia, idCentroCusto, direto) {
	window.MozartNS.GoogleSuggest.selecionar(elemento, valorTextual, 
			elementoOculto, idEntidade);	
	
	$(".unidadeEstoque").get(0).value = unidadeEstoque;
	calcularValorUnitarioItemEstoque(elemento, idEntidade);
}

function calcularValorUnitarioItemEstoque(elemento, idItem) {
	url = 'app/ajax/ajax!obterValorUnitarioEstoqueMovimentoEstoque?idItem=' + idItem;
	getAjaxValue(url, ajaxCallback);
}

function ajaxCallback(valor){
	if(valor != ""){
		var valores = valor.split(';');
		var valorFormatado = valores[0];
		$('.valorUnitario').get(0).value= moeda4Decimais(numeros(arredondaFloat4Decimais(valorFormatado).toString().replace(".",",")));
		$('.quantidadeEstimada').get(0).value = valores[1];
	}
}

function calcularValorTotal(obj) {	
	idx = 0;
	
	if($('.quantidadeMovimento').get(idx).value != '' 
			&& $('.valorUnitario').get(idx).value != ''){
		var valor = $('.valorUnitario').get(idx).value;
		var valorFormatado = valor.replace('.','').replace(',','.');
		var qtdFormatado = $('.quantidadeMovimento').get(idx).value.replace(',','.');
		$('.valorTotal').get(idx).value = moeda4Decimais(numeros(arredondaFloat4Decimais(valorFormatado*qtdFormatado).toString().replace(".",",")));
	}
}
function adicionarLancamento(){
	
	//var valor = parent.document.forms[0].elements["entidadeCP.valorBruto"].value;

	if ($('.itemEstoque').get(0).value == ''){
		parent.alerta("O campo 'Item' é obrigatório");
		return false;
	}
	
	if ($('.quantidadeMovimento').get(0).value == ''){
		parent.alerta("O campo 'Quantidade' é obrigatório");
		return false;
	}
	
	if ($('.quantidadeMovimento').get(0).value <= 0){
		parent.alerta("O campo 'Quantidade' deve ser maior que zero");
		return false;
	}
	
	if (Number($('.quantidadeMovimento').get(0).value) > Number($('.quantidadeEstimada').get(0).value)){
		parent.alerta("Valor da Quantidade não pode ser maior do que a de estoque");
		return false;
	}
	
	if ($('.valorTotal').get(0).value == ''){
		parent.alerta("O campo 'Vr. Total' é obrigatório");
		return false;
	}
	
	if ($('.valorTotal').get(0).value <= 0){
		parent.alerta("O campo 'Vr. Total' deve ser maior que zero");
		return false;
	}
		
	//$("#valor").val (valor);
	parent.loading();
    submitForm(document.forms[0]);
}

function excluirLancamento(idx){
	if (confirm('Confirma a exclusão do lançamento?')){
	    document.forms[0].action = '<s:url namespace="/app/estoque" action="includeSaida" method="excluirLancamento" />';
	    $('#indice').val( idx );
	    parent.loading();
	    document.forms[0].submit();
	}
}

function killModalPai(){
	parent.killModal();
}

function resetLancamento() {
	//$('.idMovimento').get(0).value= "";
	$('.itemEstoque').get(0).value= "";
	$('.unidadeEstoque').get(0).value= "";
	$('.quantidadeMovimento').get(0).value= "";
	$('.valorUnitario').get(0).value= "";
	$('.valorTotal').get(0).value= "";
}

</script>

<body>
	<div class="divGrupo"
		style="overflow: auto; margin-top: 0px; width: 965px; height: 98%; border: 0px;">
		<s:form namespace="/app/estoque" action="includeSaida!incluirLancamentoSaida" theme="simple">

			<s:hidden name="indice" id="indice" />
			<s:hidden name="status" id="status" />

			<div class="divLinhaCadastroPrincipal" 
					style="margin-bottom: 0px; border: 0px; width: 99%; float: left; height: 20px;">
				<!-- Item -->
				<!-- <input type="hidden" cssClass="idMovimento" name="idMovimento" value="" /> -->
				<div class="divItemGrupo" style="width: 270px;">
					<p style="color: white; width: 30px;">Item</p>
					<s:textfield style="width: 220px;"
							cssClass="itemEstoque" 
							name="itemEstoque"
							size="40" 
							maxlength="50"
							onblur="getItemEstoque(this);" />
					<s:hidden name="idItemEstoque" id="idItemEstoque" />
				</div>
				
				<div class="divItemGrupo" style="width: 90px;">
					<p style="color: white; width: 30px;">Und.</p>
					<s:textfield 
						cssClass="unidadeEstoque"
						name="unidadeEstoque"
						readonly="true"
						value=""
 						size="4" 
 						maxlength="5"
 						cssStyle="background-color:silver;" />
				</div>
				
				<div class="divItemGrupo" style="width: 110px;">
					<p style="color: white; width: 30px;">Qtd.</p>
					<s:textfield 
							cssClass="quantidadeMovimento"
							name="quantidadeMovimento"
							onkeypress="mascara(this, moeda4Decimais)" 
							onblur="calcularValorTotal(this);"
							size="8" 
							maxlength="9" 
							cssStyle="text-align: right;" />
				</div>
				
				<div class="divItemGrupo" style="width: 140px;">
					<p style="color: white; width: 60px;">Qtd. Est.</p>
					<s:textfield 
							cssClass="quantidadeEstimada"
							name="quantidadeEstimada"
							readonly="true"
							onkeypress="mascara(this, moeda4Decimais)" 
							size="8" 
							maxlength="9" 
							cssStyle="background-color:silver;text-align: right;" />
				</div>
				
				<div class="divItemGrupo" style="width: 140px;">
					<p style="color: white; width: 50px;">Vr.Unit.</p>
					<s:textfield 
							cssClass="valorUnitario"
							readonly="true"
							name="valorUnitario"
							onblur="calcularValorTotal(this);"
							onkeypress="mascara(this, moeda4Decimais)" 
							size="10" 
							maxlength="10"  
							cssStyle="background-color:silver;text-align: right;"/>
				</div>
				
				<div class="divItemGrupo" style="width: 140px;">
					<p style="color: white; width: 50px;">Vr.Total</p>
					<s:textfield 
							cssClass="valorTotal"
							name="valorTotal"
							readonly="true"
							onkeypress="mascara(this, moeda)" 
							size="10" 
							maxlength="10" 
							cssStyle="background-color:silver;text-align: right;"/>
				</div>
				<div class="divItemGrupo" style="width:30px;" >
					<s:if test="%{status != \"alteracao\"}">
                 			<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png" title="Adicionar lançamento" style="margin:0px;" onclick="adicionarLancamento();"/>
                 		</s:if>
				</div>
			</div>
			
			<s:set name="valorSomaTotal" value="%{0.0}" />
			<s:set name="quantidadeLancamentos" value="%{0}" />
			<s:iterator value="#session.entidadeSession"
 					var="item" status="row">
				<!-- <input type="hidden" cssClass="idMovimento" name="idMovimento" value="%{#item.idMovimentoEstoque}" /> -->
				
				<s:set name="valorSomaTotal" value='%{#valorSomaTotal + #item.valorTotal}' />
				<s:set name="quantidadeLancamentos" value='%{#quantidadeLancamentos + 1}' />
				
				<div class="divLinhaCadastro" id="divLinha${row.index}"	
					style="margin-bottom: 0px; margin-left: 1px; border: 0px; width: 99%; float: left; height: 20px;">
				<!-- Item -->
				<div class="divItemGrupo" style="width: 270px;">
					<p style="width: 32px;">Item</p>
					<s:property value="%{#item.item.itemRedeEJB.nomeItem}" />
					<s:hidden name="idItemEstoque" id="idItemEstoque" value="%{#item.item.id.idItem}" />
				</div>
				
				<div class="divItemGrupo" style="width: 90px;">
					<p style="width: 30px;">Und.</p>
					<s:textfield 
						cssClass="unidadeEstoque"
						name="unidadeEstoque"
						readonly="true"
						cssStyle="background-color:silver;"
 						size="4" 
 						value="%{#item.item.itemRedeEJB.unidadeEstoqueRedeEJB.nomeUnidadeReduzido}"
 						maxlength="5" />
				</div>
				
				<div class="divItemGrupo" style="width: 110px;">
					<p style="width: 30px;">Qtd.</p>
					<s:textfield 
							cssClass="quantidadeMovimento"
							name="quantidadeMovimento"
							onkeypress="mascara(this, moeda4Decimais)" 
							onblur="calcularValorTotal(this);"
							size="8" 
							maxlength="9" 
							value="%{#item.quantidade}"
							cssStyle="text-align: right;" />
				</div>
				<div class="divItemGrupo" style="width: 140px;"></div>
				<div class="divItemGrupo" style="width: 140px;">
					<p style="width: 50px;">Vr.Unit.</p>
					<s:textfield 
							cssClass="valorUnitario"
							name="valorUnitario"
							readonly="true"
							onkeypress="mascara(this, moeda4Decimais)"
							onblur="calcularValorTotal(this);" 
							size="10" 
							maxlength="10"
							cssStyle="background-color:silver;text-align: right;" 
							value="%{#item.valorUnitario}" />
				</div>
				
				<div class="divItemGrupo" style="width: 140px;">
					<p style="width: 50px;">Vr.Total</p>
					<s:textfield 
							cssClass="valorTotal"
							name="valorTotal"
							onkeypress="mascara(this, moeda)" 
							size="10" 
							readonly="true"
							maxlength="10"
							value="%{#item.valorTotal}"
							cssStyle="background-color:silver;text-align: right;" />
				</div>
				<div class="divItemGrupo" style="width:31px;" >
				<s:if test="%{status != \"alteracao\"}">
      					<img width="30px" height="30px" title="Excluir lançamento" src="imagens/iconic/png/x-3x.png" onclick="excluirLancamento('${row.index}')"/>
      				</s:if>
				</div>
			</div>
			</s:iterator>

		</s:form>
	</div>
</body>

<script>
	parent.atualizarValores('<s:property value="%{#valorSomaTotal}" />', '<s:property value="%{#valorSomaIcms}" />', '<s:property value="%{#quantidadeLancamentos}" />' );
	killModalPai();
	resetLancamento();
</script>

</html>