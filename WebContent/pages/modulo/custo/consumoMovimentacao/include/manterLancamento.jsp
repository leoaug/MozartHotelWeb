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
	var idUsuarioConsumo = parent.document.forms[0].idUsuario.value;
	var idPontoVenda = parent.document.forms[0].idPontoVenda.value;

	if(idUsuarioConsumo == ''){
		parent.alerta("O campo 'Usuário' deve ser preenchido antes do Item.");
		return false;
	}
	
	if(idPontoVenda == ''){
		parent.alerta("O campo 'Ponto de Venda' deve ser preenchido antes do Item.");
		return false;
	}
	
	url = 'app/ajax/ajax!obterPratoPorUsuarioConsumoInterno?OBJ_NAME=' 
		+ elemento.id
		+ '&OBJ_VALUE=' 
		+ elemento.value 
		+ '&OBJ_PONTO_VENDA='
		+ idPontoVenda 
		+ '&OBJ_USUARIO_CONSUMO='
		+ idUsuarioConsumo
		+ '&OBJ_HIDDEN=idPrato';
	
	getDataLookup(elemento, url, 'ItemEstoque', 'TABLE');
}

function selecionarPratoConsumoInterno( 
		elemento, elementoOculto, 
		valorTextual, idEntidade,
		unidadeEstoque) {
	window.MozartNS.GoogleSuggest.selecionar(elemento, valorTextual, 
			elementoOculto, idEntidade);
	$(".unidadeEstoque").get(0).value = unidadeEstoque;

	calcularCustoVendaPrato(elemento, idEntidade);
	
}

function calcularCustoVendaPrato(elemento, idItem) {
	url = 'app/ajax/ajax!obterCustoVendaConsumoMovimentacao?idItem=' + idItem;
	getAjaxValue(url, ajaxCallback);
}

function ajaxCallback(valor){
	if(valor != ""){
		var valores = valor.split(';');
		var valorCusto = valores[0];
		var valorVenda = valores[1];
			
		$('.custo').get(0).value = moeda4Decimais(numeros(arredondaFloat4Decimais(valorCusto).toString().replace(".",",")));
		$('.venda').get(0).value = moeda4Decimais(numeros(arredondaFloat4Decimais(valorVenda).toString().replace(".",",")));
		
		calcularValorTotal();
	}
	else{
		parent.alerta("Produto não requisitado por este centro de custo.");
	}
}

function validarItem() {

	vForm = document.forms[0];
	vForm.action = '<s:url action="includeConsumoMovimentacao!validarItem.action" namespace="/app/custo" />';
	submitForm(vForm);

}

function adicionarLancamento(){
	
	//var valor = parent.document.forms[0].elements["entidadeCP.valorBruto"].value;

	if ($('.itemEstoque').get(0).value == ''){
		parent.alerta("O campo 'Item' é obrigatório");
		return false;
	}
	
	if ($('.quantidadeEstoque').get(0).value == ''){
		parent.alerta("O campo 'Quantidade' é obrigatório");
		return false;
	}
	
	if ($('.quantidadeEstoque').get(0).value <= 0){
		parent.alerta("O campo 'Quantidade' deve ser maior que zero");
		return false;
	}
	
	parent.loading();
    submitForm(document.forms[0]);
}

function excluirLancamento(idx){
	if (confirm('Confirma a exclusão do lançamento?')){
	    document.forms[0].action = '<s:url namespace="/app/custo" action="includeConsumoMovimentacao" method="excluirLancamento" />';
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
	$('.quantidadeEstoque').get(0).value= "";
	$('.custo').get(0).value= "";
	$('.custoTotal').get(0).value= "";
	$('.venda').get(0).value= "";
	$('.vendaTotal').get(0).value= "";
}

function calcularValorTotal() {	
	idx = 0;
	
	if($('.quantidadeEstoque').get(idx).value != '' 
			&& $('.custo').get(idx).value != ''){
		var valor = $('.custo').get(idx).value;
		var valorFormatado = valor.replace('.','').replace(',','.');
		var qtdFormatado = $('.quantidadeEstoque').get(idx).value.replace(',','.');
		$('.custoTotal').get(idx).value = moeda4Decimais(numeros(arredondaFloat4Decimais(valorFormatado*qtdFormatado).toString().replace(".",",")));
	}
	
	if($('.quantidadeEstoque').get(idx).value != '' 
		&& $('.venda').get(idx).value != ''){
	var valor = $('.venda').get(idx).value;
	var valorFormatado = valor.replace('.','').replace(',','.');
	var qtdFormatado = $('.quantidadeEstoque').get(idx).value.replace(',','.');
	$('.vendaTotal').get(idx).value = moeda4Decimais(numeros(arredondaFloat4Decimais(valorFormatado*qtdFormatado).toString().replace(".",",")));
}
}


</script>

<body>
	<div class="divGrupo"
		style="overflow: auto; margin-top: 0px; width: 965px; height: 98%; border: 0px;">
		<s:form namespace="/app/custo" action="includeConsumoMovimentacao!incluirLancamento" theme="simple">

				<s:hidden name="indice" id="indice" />
				<s:hidden name="status" id="status" />

			<div class="divLinhaCadastroPrincipal" 
					style="margin-bottom: 0px; border: 0px; width: 99%; float: left; height: 20px;">
				<!-- Item -->

				<div class="divItemGrupo" style="width: 190px;">
					<p style="color: white; width: 30px;">Item</p>
					<s:textfield
							cssClass="itemEstoque" 
							name="consumoInternoEntidade.prato"
							id="itemEstoque"
							size="20" 
							maxlength="50"
							onblur="getItemEstoque(this);" 
							tabindex="1"/>
					<s:hidden name="idPrato" id="idPrato" />
				</div>
				
				<div class="divItemGrupo" style="width: 90px;">
					<p style="color: white; width: 30px;">Und.</p>
					<s:textfield 
						cssClass="unidadeEstoque"
						name="unidade"
						id="unidadeEstoque"
						readonly="false"
 						size="4"  
 						maxlength="4"
 						cssStyle="background-color:silver;" />
				</div>
				
				<div class="divItemGrupo" style="width: 110px;">
					<p style="color: white; width: 30px;">Qtd.</p>
					<s:textfield 
							cssClass="quantidadeEstoque"
							name="qtde"
							onchange="mascara(this, quantidadeDecimal)"
							onkeypress="mascara(this, quantidadeDecimal)" 
							size="8" 
							maxlength="9" 
							cssStyle="text-align: right;" 
							tabindex="2"/>
				</div>
				
				<div class="divItemGrupo" style="width: 110px;">
					<p style="color: white; width: 30px;">Custo</p>
					<s:textfield 
							cssClass="custo"
							name="valCusto"
							readonly="true"
							onkeypress="mascara(this, moeda4Decimais)" 
							onblur="calcularValorTotal();"
							size="8" 
							maxlength="9" 
							cssStyle="background-color:silver;text-align: right;"
							tabindex="2"/>
				</div>
				
				<div class="divItemGrupo" style="width: 140px;">
					<p style="color: white; width: 50px;">Tot.Custo</p>
					<s:textfield 
							cssClass="custoTotal"
							name="valCustoTotal"
							readonly="true"
							value=""
							onblur="calcularValorTotal();"
							onkeypress="mascara(this, moeda4Decimais)" 
							size="10" 
							maxlength="10" 
							cssStyle="background-color:silver;text-align: right;" />
				</div>
				
				<div class="divItemGrupo" style="width: 130px;">
					<p style="color: white; width: 40px;">Venda</p>
					<s:textfield 
							cssClass="venda"
							name="valVenda"
							readonly="true"
							onkeypress="mascara(this, moeda4Decimais)" 
							size="10" 
							maxlength="10" 
							cssStyle="background-color:silver;text-align: right;"
							tabindex="3"/>
				</div>
				
				<div class="divItemGrupo" style="width: 140px;">
					<p style="color: white; width: 50px;">Tot.Venda</p>
					<s:textfield 
							cssClass="vendaTotal"
							name="valVendaTotal"
							readonly="true"
							onkeypress="mascara(this, moeda4Decimais)" 
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

			<s:set name="valorSomaCustoTotal" value="%{0.0}" />
			<s:set name="valorSomaVendaTotal" value="%{0.0}" />
			<s:set name="quantidadeLancamentos" value="%{0}" />
			<s:iterator value="#session.entidadeSession"
 					var="item" status="row">
				
				<s:set name="valorSomaCustoTotal" value='%{#valorSomaCustoTotal + #item.custoTotal}' />
				<s:set name="valorSomaVendaTotal" value='%{#valorSomaVendaTotal + #item.vendaTotal}' />
				<s:set name="quantidadeLancamentos" value='%{#quantidadeLancamentos + 1}' />
				
			<div class="divLinhaCadastro" id="divLinha${row.index}"	
					style="margin-bottom: 0px; margin-left: 1px; border: 0px; width: 99%; float: left; height: 20px;">
				<!-- Item -->
				<div class="divItemGrupo" style="width: 190px;">
					<p style="width: 30px;">Item</p>
					<s:property value="%{#item.prato}" />
					<s:hidden name="idPrato" id="idPrato" value="%{#item.idPrato}" />
				</div>
				
				<div class="divItemGrupo" style="width: 90px;">
					<p style="width: 30px;">Und.</p>
					<s:textfield 
						cssClass="unidade"
						name="unidade"
						readonly="true"
						cssStyle="background-color:silver;"
 						size="4" 
 						value="%{#item.unidade}"
 						maxlength="5" />
				</div>
				
				<div class="divItemGrupo" style="width: 110px;">
					<p style="width: 30px;">Qtd.</p>
					<s:textfield 
							cssClass="quantidade"
							name="quantidade"
							readonly="true"
							onkeypress="mascara(this, quantidadeDecimal)" 
							onkeyup="calcularValorTotal();"
							onblur="calcularValorTotal();"
							size="8" 
							maxlength="9" 
							value="%{#item.quantidade}"
							cssStyle="background-color:silver;text-align: right;"
							tabindex="2"/>
				</div>
				
				<div class="divItemGrupo" style="width: 110px;">
					<p style="width: 30px;">Custo</p>
					<s:textfield 
							cssClass="custo"
							name="custo"
							readonly="true"
							onblur="calcularValorTotal();"
							onkeypress="mascara(this, moeda4Decimais)" 
							size="8" 
							maxlength="9" 
							value="%{#item.custo}"
							cssStyle="background-color:silver;text-align: right;" />
				</div>
				
				<div class="divItemGrupo" style="width: 140px;">
					<p style="width: 50px;">Tot.Custo</p>
					<s:textfield 
							cssClass="custoTotal"
							name="custoTotal"
							readonly="true"
							onkeypress="mascara(this, moeda4Decimais)" 
							size="10" 
							maxlength="10" 
							value="%{#item.custoTotal}"
							cssStyle="background-color:silver;text-align: right;" />
				</div>
				
				<div class="divItemGrupo" style="width: 130px;">
					<p style="width: 40px;">Venda</p>
					<s:textfield 
							cssClass="venda"
							name="venda"
							readonly="true"
							onblur="calcularValorTotal();"
							onkeypress="mascara(this, moeda4Decimais)" 
							size="10" 
							maxlength="10" 
							value="%{#item.venda}"
							cssStyle="background-color:silver;text-align: right;" />
				</div>
				
				<div class="divItemGrupo" style="width: 140px;">
					<p style="width: 50px;">Tot.Venda</p>
					<s:textfield 
							cssClass="vendaTotal"
							name="vendaTotal"
							readonly="true"
							onkeypress="mascara(this, moeda4Decimais)"  
							size="10" 
							maxlength="10"
							value="%{#item.vendaTotal}"
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
	parent.atualizarValores('<s:property value="%{#valorSomaCustoTotal}" />', '<s:property value="%{#valorSomaVendaTotal}" />');
	killModalPai();
	//resetLancamento();
	//<s:elseif test="%{mensagemPai != null && mensagemPai != \"\"}">
	//	parent.alerta('<s:property value="mensagemPai" />');
	//</s:elseif>
</script>

</html>