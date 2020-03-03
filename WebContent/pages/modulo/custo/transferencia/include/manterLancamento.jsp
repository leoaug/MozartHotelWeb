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

function getItemEstoque(elemento) {
	var idCentroCusto = parent.document.forms[0].idCentroCustoOrigem.value;

	if(idCentroCusto == ''){
		parent.alerta("O campo 'Centro de Custo' deve ser preenchido antes do Item.");
		return false;
	}
	
	url = 'app/ajax/ajax!obterItensEstoqueMovimentoEstoque?OBJ_NAME=' 
		+ elemento.id
		+ '&OBJ_VALUE=' 
		+ elemento.value 
		+ '&OBJ_CENTRO_CUSTO_VALUE='
		+ idCentroCusto 
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

	var idCentroCusto = parent.document.forms[0].idCentroCustoOrigem.value;
	if(idCentroCusto != ''){
		calcularQuantidadeValorUnitarioItemEstoque(elemento, idEntidade, idCentroCusto);
	}
	else{
		parent.alerta("O campo 'Centro de Custo' deve ser preenchido antes do Item.");
		return false;
	}
	//validarItem();
}

function calcularQuantidadeValorUnitarioItemEstoque(elemento, idItem, idCentroCusto) {
	url = 'app/ajax/ajax!obterQuantidadeValorUnitarioTransferenciaCusto?idItem=' + idItem 
			+ "&idCentroCusto=" + idCentroCusto;
	getAjaxValue(url, ajaxCallback);
}

function ajaxCallback(valor){
	if(valor != ""){
		var valores = valor.split(';');
		var valorFormatado = valores[0];
		var quantidade = valores[1];
		
		if(valorFormatado <= 0 || quantidade <= 0){
			parent.alerta("Produto não requisitado por este centro de custo.");
			return false;
		}
		
		$('.valorUnitario').get(0).value = moeda4Decimais(numeros(arredondaFloat4Decimais(valorFormatado).toString().replace(".",",")));
		$('.quantidadeEstoque').get(0).value = quantidadeDecimal(numeros(arredondaFloat4Decimais(quantidade).toString().replace(".",",")));
		
		calcularValorTotal();
	}
	else{
		parent.alerta("Produto não requisitado por este centro de custo.");
	}
}

function validarItem() {

	vForm = document.forms[0];
	vForm.action = '<s:url action="includeTransferencia!validarItem.action" namespace="/app/custo" />';
	submitForm(vForm);

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
	
	if ($('.valorTotal').get(0).value == ''){
		parent.alerta("O campo 'Vr. Total' é obrigatório");
		return false;
	}
	
	if ($('.valorTotal').get(0).value <= 0){
		parent.alerta("O campo 'Vr. Total' deve ser maior que zero");
		return false;
	}
		
	parent.loading();
    submitForm(document.forms[0]);
}

function excluirLancamento(idx){
	if (confirm('Confirma a exclusão do lançamento?')){
	    document.forms[0].action = '<s:url namespace="/app/custo" action="includeTransferencia" method="excluirLancamento" />';
	    $('#indice').val( idx );
	    parent.loading();
	    document.forms[0].submit();
	}
}

function killModalPai(){
	parent.killModal();
}

function resetLancamento() {
	$('.itemEstoque').get(0).value= "";
	$('.unidadeEstoque').get(0).value= "";
	$('.quantidadeMovimento').get(0).value= "";
	$('.valorUnitario').get(0).value= "";
	$('.valorTotal').get(0).value= "";
}

function calcularValorTotal() {	
	idx = 0;
	
	if($('.quantidadeMovimento').get(idx).value != '' 
			&& $('.valorUnitario').get(idx).value != ''){
		var valor = $('.valorUnitario').get(idx).value;
		var valorFormatado = valor.replace('.','').replace(',','.');
		var qtdFormatado = $('.quantidadeMovimento').get(idx).value.replace(',','.');
		$('.valorTotal').get(idx).value = moeda4Decimais(numeros(arredondaFloat4Decimais(valorFormatado*qtdFormatado).toString().replace(".",",")));
	}
}


</script>

<body>
	<div class="divGrupo"
		style="overflow: auto; margin-top: 0px; width: 965px; height: 98%; border: 0px;">
		<s:form namespace="/app/custo" action="includeTransferencia!incluirLancamento" theme="simple">

				<s:hidden name="indice" id="indice" />
				<s:hidden name="status" id="status" />

			<div class="divLinhaCadastroPrincipal" 
					style="margin-bottom: 0px; border: 0px; width: 99%; float: left; height: 20px;">
				<!-- Item -->

				<div class="divItemGrupo" style="width: 270px;">
					<p style="color: white; width: 50px;">Item</p>
					<s:textfield
							cssClass="itemEstoque" 
							name="itemEstoqueEJB.itemRedeEJB.nomeItem"
							id="itemEstoque"
							size="30" 
							maxlength="50"
							onblur="getItemEstoque(this);" 
							tabindex="1"/>
					<s:hidden name="idItemEstoque" id="idItemEstoque" />
				</div>
				
				<div class="divItemGrupo" style="width: 90px;">
					<p style="color: white; width: 30px;">Und.</p>
					<s:textfield 
						cssClass="unidadeEstoque"
						name="itemEstoqueEJB.itemRedeEJB.unidadeEstoqueRedeEJB.nomeUnidadeReduzido"
						id="unidadeEstoque"
						readonly="false"
 						size="4"  
 						maxlength="4"
 						cssStyle="background-color:silver;" />
				</div>
				
				<div class="divItemGrupo" style="width: 130px;">
					<p style="color: white; width: 50px;">Qtd Est.</p>
					<s:textfield 
							cssClass="quantidadeEstoque"
							name="quantidadeEstoque"
							readonly="true"
							onchange="mascara(this, quantidadeDecimal)"
							onkeypress="mascara(this, quantidadeDecimal)" 
							size="8" 
							maxlength="9" 
							cssStyle="background-color:silver;text-align: right;" 
							tabindex="2"/>
				</div>
				
				<div class="divItemGrupo" style="width: 120px;">
					<p style="color: white; width: 30px;">Qtd.</p>
					<s:textfield 
							cssClass="quantidadeMovimento"
							name="qtdeMovimento"
							onkeypress="mascara(this, quantidadeDecimal)" 
							onblur="calcularValorTotal();"
							size="8" 
							maxlength="9" 
							cssStyle="text-align: right;" 
							tabindex="2"/>
				</div>
				
				<div class="divItemGrupo" style="width: 150px;">
					<p style="color: white; width: 45px;">Vr.Unit.</p>
					<s:textfield 
							cssClass="valorUnitario"
							name="valorUnitario"
							readonly="true"
							value=""
							onblur="calcularValorTotal();"
							onkeypress="mascara(this, moeda4Decimais)" 
							size="10" 
							maxlength="10" 
							cssStyle="background-color:silver;text-align: right;" />
				</div>
				
				<div class="divItemGrupo" style="width: 150px;">
					<p style="color: white; width: 50px;">Vr.Total</p>
					<s:textfield 
							cssClass="valorTotal"
							name="vlrTotal"
							readonly="true"
							onkeypress="mascara(this, moeda)" 
							size="10" 
							maxlength="10" 
							cssStyle="background-color:silver;text-align: right;"
							tabindex="3"/>
				</div>
				
				<div class="divItemGrupo" style="width:30px;" >
					<s:if test="%{status != \"alteracao\"}">
                 			<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png" title="Adicionar lançamento" style="margin:0px;" onclick="adicionarLancamento();"/>
                 		</s:if>
				</div>
				
			</div>

			<s:set name="valorSomaTotal" value="%{0.0}" />
			<s:set name="valorSomaIcms" value="%{0.0}" />
			<s:set name="quantidadeLancamentos" value="%{0}" />
			<s:iterator value="#session.entidadeSession"
 					var="item" status="row">
				
				<s:set name="valorSomaTotal" value='%{#valorSomaTotal + #item.valorTotal}' />
				<s:set name="quantidadeLancamentos" value='%{#quantidadeLancamentos + 1}' />
				
			<div class="divLinhaCadastro" id="divLinha${row.index}"	
					style="margin-bottom: 0px; margin-left: 1px; border: 0px; width: 99%; float: left; height: 20px;">
				<!-- Item -->
				<div class="divItemGrupo" style="width: 270px;">
					<p style="width: 96px;">Item</p>
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
				
				<div class="divItemGrupo" style="width: 130px;">
				</div>
				
				<div class="divItemGrupo" style="width: 120px;">
					<p style="width: 30px;">Qtd.</p>
					<s:textfield 
							cssClass="quantidadeMovimento"
							name="quantidadeMovimento"
							readonly="true"
							onkeypress="mascara(this, quantidadeDecimal)" 
							onblur="calcularValorTotal();"
							size="8" 
							maxlength="9" 
							value="%{#item.quantidade}"
							cssStyle="background-color:silver;text-align: right;"
							tabindex="2"/>
				</div>
				
				<div class="divItemGrupo" style="width: 150px;">
					<p style="width: 50px;">Vr.Unit.</p>
					<s:textfield 
							cssClass="valorUnitario"
							name="valorUnitario"
							readonly="true"
							onblur="calcularValorTotal();"
							onkeypress="mascara(this, moeda4Decimais)" 
							size="10" 
							maxlength="10" 
							value="%{#item.valorUnitario}"
							cssStyle="background-color:silver;text-align: right;" />
				</div>
				
				<div class="divItemGrupo" style="width: 150px;">
					<p style="width: 50px;">Vr.Total</p>
					<s:textfield 
							cssClass="valorTotal"
							name="valorTotal"
							readonly="true"
							onkeypress="mascara(this, moeda)" 
							size="10" 
							maxlength="10"
							value="%{#item.valorTotal}"
							cssStyle="background-color:silver;text-align: right;"
							tabindex="3"/>
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
	//parent.atualizarValores('<s:property value="%{#valorSomaTotal}" />', '<s:property value="%{#valorSomaIcms}" />', '<s:property value="%{#quantidadeLancamentos}" />' );
	killModalPai();
	//resetLancamento();
	//<s:elseif test="%{mensagemPai != null && mensagemPai != \"\"}">
	//	parent.alerta('<s:property value="mensagemPai" />');
	//</s:elseif>
</script>

</html>