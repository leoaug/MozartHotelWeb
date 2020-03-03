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
	addPlaceHolder('fiscalCodigoPlace', 'ex.: Digitar o CFOP ou a descrição da entrada');
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

function getFiscalCodigo(elemento) {
	url = 'app/ajax/ajax!obterFiscalCodigos?OBJ_NAME=' 
			+ elemento.id
			+ '&OBJ_VALUE=' 
			+ elemento.value 
			+ '&OBJ_HIDDEN=idCodigoFiscal';
	getDataLookup(elemento, url, 'FiscalCodigo', 'TABLE');
}

function selecionarItemEstoque(
		elemento, elementoOculto, 
		valorTextual, idEntidade,
		unidadeEstoque, idFiscalIncidencia, idCentroCusto, direto) {
	window.MozartNS.GoogleSuggest.selecionar(elemento, valorTextual, 
			elementoOculto, idEntidade);
	$(".unidadeEstoque").get(0).value = unidadeEstoque;
	if(direto == 'S'){
		$(".idCentroCustos").get(0).value = idCentroCusto;
	}
	
	validarItem();
}

function validarItem() {

	vForm = document.forms[0];
	vForm.action = '<s:url action="include!validarItem.action" namespace="/app/estoque" />';
	submitForm(vForm);

}

function selecionarFiscalCodigo(
		elemento, elementoOculto, 
		valorTextual, idEntidade) {
	window.MozartNS.GoogleSuggest.selecionar(elemento, valorTextual, 
			elementoOculto, idEntidade);
}

function adicionarLancamento(){
	
	//var valor = parent.document.forms[0].elements["entidadeCP.valorBruto"].value;

	if ($('.itemEstoque').get(0).value == ''){
		parent.alerta("O campo 'Item' é obrigatório");
		return false;
	}

	if ($('.fiscalCodigo').get(0).value == ''){
		parent.alerta("O campo 'Fiscal' é obrigatório");
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
	
	
	//$("#valor").val (valor);
	parent.loading();
    submitForm(document.forms[0]);
}

function excluirLancamento(idx){
	if (confirm('Confirma a exclusão do lançamento?')){
	    document.forms[0].action = '<s:url namespace="/app/estoque" action="include" method="excluirLancamento" />';
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
	$('.idCentroCustos').get(0).value= "";
	$('.idFiscalIncidencia').get(0).value= "";
	$('.baseCalculo').get(0).value= "";
	$('.fiscalCodigo').get(0).value= "";
	$('.idAliquotas').get(0).value= "0";
	$('.icmsValor').get(0).value= "";	
}

function calcularValorUnitario(obj) {
	//idx = $(".quantidadeMovimento").index( obj );
	//if(idx == null || idx == '' || idx == '-1'){
	//	idx = $(".valorTotal").index( obj );
	//}
	
	idx = 0;
	
	if($('.quantidadeMovimento').get(idx).value != '' 
			&& $('.valorTotal').get(idx).value != ''){
		var valor = $('.valorTotal').get(idx).value;
		var valorFormatado = valor.replace('.','').replace(',','.');
		var qtdFormatado = $('.quantidadeMovimento').get(idx).value.replace(',','.');
		$('.valorUnitario').get(idx).value = moeda4Decimais(numeros(arredondaFloat4Decimais(valorFormatado/qtdFormatado).toString().replace(".",",")));
	}
}

function calcularICMS(obj) {
	//idx = $(".baseCalculo").index( obj );
	//if(idx == null || idx == '' || idx == '-1'){
	//	idx = $(".idAliquotas").index( obj );
	//}
	//else if(idx == null || idx == '' || idx == '-1'){
	//	idx = $(".icmsValor").index( obj );
	//}
	
	idx = 0;
	
	if($('.baseCalculo').get(idx).value != '' 
			&& ($('.idAliquotas').get(idx).value != '' && $('.idAliquotas').get(idx).value != '0')){
		var percentual = $('.idAliquotas').get(idx).selectedOptions[0].text.split('-')[1].replace(',','.').trim();  
		percentual = !isNaN(percentual) ? percentual : 0;
		var valor = $('.baseCalculo').get(idx).value;
		var valorFormatado = valor.replace('.','').replace(',','.');
		$('.icmsValor').get(idx).value = moeda(numeros(arredondaFloat(valorFormatado*(percentual/100)).toString().replace(".",",")));
	}
}

function habilitarBaseCalculo(obj) {
	//idx = $(".idFiscalIncidencia").index( obj );
	idx = 0;
	
	if($('.idFiscalIncidencia').get(idx).value != ''){
		var codigoFiscal = $('.idFiscalIncidencia').get(idx).selectedOptions[0].text.split('-')[0].trim();
		if(codigoFiscal == 1){
			$('.baseCalculo').get(idx).readOnly = false;	
			$('.baseCalculo').get(idx).style.background="white";
			$('.idAliquotas').get(idx).readOnly = false;
			$('.idAliquotas').get(idx).disabled = false;
			$('.idAliquotas').get(idx).style.background="white";
		}
		else{
			$('.baseCalculo').get(idx).readOnly = true;
			$('.baseCalculo').get(idx).style.background="silver";
			$('.baseCalculo').get(idx).value= "";
			$('.idAliquotas').get(idx).readOnly = true;
			$('.idAliquotas').get(idx).disabled = true;
			$('.idAliquotas').get(idx).style.background="silver";
		}
	}
}

</script>

<body>
	<div class="divGrupo"
		style="overflow: auto; margin-top: 0px; width: 965px; height: 98%; border: 0px;">
		<s:form namespace="/app/estoque" action="include!incluirLancamento" theme="simple">

<%-- 			<s:hidden name="entidadeCP.valorBruto" id="valor" /> --%>
<%-- 			<s:hidden name="entidadeCP.dataLancamento" id="dataLancamento" /> --%>
<%-- 			<s:hidden name="entidadeCP.contaCorrente" id="contaCorrente" /> --%>
<%-- 			<s:hidden name="idMovimento" /> --%>
				<s:hidden name="indice" id="indice" />
				<s:hidden name="status" id="status" />
<%-- 			<s:hidden name="classificacaoPadrao" id="idClassificacaoContabil" /> --%>

			<div class="divLinhaCadastroPrincipal" 
					style="margin-bottom: 0px; border: 0px; width: 99%; float: left; height: 20px;">
				<!-- Item -->
				<!-- <input type="hidden" cssClass="idMovimento" name="idMovimento" value="" /> -->
				<div class="divItemGrupo" style="width: 360px;">
					<p style="color: white; width: 50px;">Item</p>
					<s:textfield
							cssClass="itemEstoque" 
							name="itemEstoqueEJB.itemRedeEJB.nomeItem"
							id="itemEstoque"
							size="44" 
							maxlength="50"
							onblur="getItemEstoque(this);" 
							tabindex="1"/>
					<s:hidden name="idItemEstoque" id="idItemEstoque" />
				</div>
				
				<div class="divItemGrupo" style="width: 110px;">
					<p style="color: white; width: 40px;">Und.</p>
					<s:textfield 
						cssClass="unidadeEstoque"
						name="itemEstoqueEJB.itemRedeEJB.unidadeEstoqueRedeEJB.nomeUnidadeReduzido"
						id="unidadeEstoque"
						readonly="false"
 						size="4"  
 						maxlength="50"
 						cssStyle="background-color:silver;" />
				</div>
				
				<div class="divItemGrupo" style="width: 130px;">
					<p style="color: white; width: 40px;">Qtd.</p>
					<s:textfield 
							cssClass="quantidadeMovimento"
							name="qtdeMovimento"
							onkeypress="mascara(this, quantidadeDecimal)" 
							onblur="calcularValorUnitario(this);"
							size="8" 
							maxlength="9" 
							cssStyle="text-align: right;" 
							tabindex="2"/>
				</div>
				
				<div class="divItemGrupo" style="width: 150px;">
					<p style="color: white; width: 50px;">Vr.Unit.</p>
					<s:textfield 
							cssClass="valorUnitario"
							name="valorUnitario"
							readonly="true"
							value=""
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
							onkeypress="mascara(this, moeda)" 
							onblur="calcularValorUnitario(this);"
							size="10" 
							maxlength="10" 
							cssStyle="text-align: right;" 
							tabindex="3"/>
				</div>
			</div>
			
			<div class="divLinhaCadastroPrincipal"
					style="margin-bottom: 0px; margin-left: 0px;  border: 0px; width: 99%; float: left; height: 20px;">
				<!-- Centro de Custo Contabil -->
				<div class="divItemGrupo" style="width:360px;" >
					<p style="color: white; width:96px;">Centro de Custo</p>
					<s:select 
							cssClass="idCentroCustos"  
							name="itemEstoqueEJB.idCentroCusto" 
							list="centrosCustoContabil" 
							listKey="idCentroCustoContabil" 
							listValue="descricaoCentroCusto" 
							headerKey="" 
							headerValue="Selecione" 
							cssStyle="width: 252px"/> 
				</div>
				
				<!-- Código Fiscal -->
				<div class="divItemGrupo" style="width: 530px;">
					<p style="color: white; width: 40px;">CFOP</p>
					<s:textfield 
							cssClass="fiscalCodigo" 
							id="fiscalCodigoPlace"
							name="fiscalCodigo"
							size="61" 
							maxlength="50"
							cssStyle="width: 334px"
							onblur="getFiscalCodigo(this);" 
							value="%{itemEstoqueEJB.fiscalCodigoEJB.subCodigo} - %{itemEstoqueEJB.fiscalCodigoEJB.descricao}" 
							>
							
							</s:textfield>
							
					<s:hidden name="itemEstoqueEJB.fiscalCodigoEJB.idCodigoFiscal" id="idCodigoFiscal" />
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
				<!-- <input type="hidden" cssClass="idMovimento" name="idMovimento" value="%{#item.idMovimentoEstoque}" /> -->
				
				<s:set name="valorSomaTotal" value='%{#valorSomaTotal + #item.valorTotal}' />
				<s:set name="quantidadeLancamentos" value='%{#quantidadeLancamentos + 1}' />
				<s:if test="%{#item.icmsValor != null}">
					<s:set name="valorSomaIcms" value='%{#valorSomaIcms + #item.icmsValor}' />
				</s:if>
				
				<div class="divLinhaCadastro" id="divLinha${row.index}"	
					style="margin-bottom: 0px; margin-left: 1px; border: 0px; width: 99%; float: left; height: 20px;">
				<!-- Item -->
				<div class="divItemGrupo" style="width: 360px;">
					<p style="width: 96px;">Item</p>
					<s:property value="%{#item.item.itemRedeEJB.nomeItem}" />
					<s:hidden name="idItemEstoque" id="idItemEstoque" value="%{#item.item.id.idItem}" />
				</div>
				
				<div class="divItemGrupo" style="width: 110px;">
					<p style="width: 40px;">Und.</p>
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
					<p style="width: 40px;">Qtd.</p>
					<s:textfield 
							cssClass="quantidadeMovimento"
							name="quantidadeMovimento"
							onkeypress="mascara(this, quantidadeDecimal)" 
							onblur="calcularValorUnitario(this);"
							size="8" 
							maxlength="9" 
							value="%{#item.quantidade}"
							cssStyle="text-align: right;" 
							tabindex="2"/>
				</div>
				
				<div class="divItemGrupo" style="width: 150px;">
					<p style="width: 50px;">Vr.Unit.</p>
					<s:textfield 
							cssClass="valorUnitario"
							name="valorUnitario"
							readonly="true"
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
							onkeypress="mascara(this, moeda)" 
							size="10" 
							maxlength="10"
							onblur="calcularValorUnitario(this);" 
							value="%{#item.valorTotal}"
							cssStyle="text-align: right;" 
							tabindex="3"/>
				</div>
			</div>
			
			<div class="divLinhaCadastro" id="divLinha${row.index}" 
					style="margin-bottom: 0px; margin-left: 1px; border: 0px; width: 99%; float: left; height: 20px;">
				<!-- Centro de Custo Contabil -->
				
           			<div class="divItemGrupo" style="width:360px;" >
					<p style="width:96px;">Centro de Custo</p>
					<s:select 
								cssClass="idCentroCustos"  
								name="idCentroCustos" 
								list="centrosCustoContabil" 
								listKey="idCentroCustoContabil" 
								listValue="descricaoCentroCusto"  
								headerKey="0" 
								headerValue="Selecione" 
								value="%{#item.centroCustoContabil.idCentroCustoContabil}"
								cssStyle="width: 252px" /> 
				</div>				
				
			
				<div class="divItemGrupo" style="width: 530px;">
					<p style="width: 40px;">CFOP</p>
					<s:property value="%{#item.fiscalCodigo.subCodigo}" /> - <s:property value="%{#item.fiscalCodigo.descricao}" />
					<s:hidden name="idCodigoFiscal" id="idCodigoFiscal" value="%{#item.fiscalCodigo.idCodigoFiscal}" />
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
	//resetLancamento();
	//<s:elseif test="%{mensagemPai != null && mensagemPai != \"\"}">
	//	parent.alerta('<s:property value="mensagemPai" />');
	//</s:elseif>
</script>

</html>