<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
$('#linhaEstoque').css('display', 'block');

window.onload = function() {
	addPlaceHolder('fornecedor', 'ex.: Digitar o nome ou CNPJ');
	addPlaceHolder('planoContas', 'ex.: Digitar o nome da conta, conta contabil ou reduzida');
};

function addPlaceHolder(classe, message) {
	document.getElementById(classe).setAttribute("placeholder",
			message);
}

function cancelar() {
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarLancamento!prepararPesquisa.action" namespace="/app/estoque" />';
	submitForm(vForm);
}

function gravar() {

	if ($("input[name='movimentoEstoque.numDocumento']").val() == '') {
		alerta("Campo 'Num Documento' é obrigatório.");
		return false;
	}

	if ($("input[name='movimentoEstoque.serieDocumento']").val() == '') {
		alerta("Campo 'Série' é obrigatório.");
		return false;
	}
	if ($("input[name='movimentoEstoque.tipoDocumento']").val() == '') {
		alerta("Campo 'Tipo' é obrigatório.");
		return false;
	}
	if ($(
			"input[name='movimentoEstoque.fornecedorHotelEJB.fornecedorRedeEJB.idFornecedor']")
			.val() == '') {
		alerta("Campo 'Fornecedor' é obrigatório.");
		return false;
	}
	if ($("input[name='movimentoEstoque.dataDocumento']").val() == '') {
		alerta("Campo 'Data Emissão' é obrigatório.");
		return false;
	}
	if (pegaDiferencaDiasDatas('<s:property value="#session.CONTROLA_DATA_SESSION.estoque"/>' ,$("input[name='movimentoEstoque.dataDocumento']").val()) < 0){
		alerta("O campo 'Data Emissão' deve ser menor ou igual à Estoque.");
		return false;
	}
	if ($("input[name='movimentoEstoque.dataVencimento']").val() == '') {
		alerta("Campo 'Data vcto' é obrigatório.");
		return false;
	}
	if ($('#somaEntradas').val()!= $('#valorTotal').val()) {
		alerta("Somatório dos lançamentos " + $('#somaEntradas').val() + " é diferente do total da nota " + $('#valorTotal').val());
		return false;
	}

	podeGravar();
}

function podeGravar() {
	vForm = document.forms[0];
	vForm.action = '<s:url action="manterLancamento!salvarEstoque.action" namespace="/app/estoque" />';
	submitForm(vForm);
}

function getFornecedor(elemento) {
	url = 'app/ajax/ajax!obterFornecedoresPorNomeOuCNPJ?OBJ_NAME=' + elemento.id
			+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idFornecedor';
	getDataLookup(elemento, url, 'Fornecedor', 'TABLE');
}

function getPlanoContas(elemento) {
	url = 'app/ajax/ajax!obterPlanoContasDemonstrativoAnalitico?OBJ_NAME=' + elemento.id 
			+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idPlanoContas';
	getDataLookup(elemento, url, 'PlanoContas', 'TABLE');
}

function complementoFornecedor(prazo) {
	if(prazo != ''){
		$("input[name='prazo']").val(prazo);
	}
	var dt = $("input[name='movimentoEstoque.dataDocumento']").val();
	if(dt != '' && $("input[name='prazo']").val() != ''){
		var prazoCal = $("input[name='prazo']").val();
		var data = new Date(dt.split('/')[2],
			parseInt(dt.split('/')[1], 10) - 1, dt.split('/')[0]);
		data.addDays(parseInt(prazoCal, 10));
		$("input[name='movimentoEstoque.dataVencimento']").val(formatDate(data, 'd/m/Y'));
	}
}

function atualizarDadosDefault(valor) {
	if (valor != '') {
		if (Trim($('input[name="movimentoEstoque.valorBruto"]').val()) == '') {
			alerta("O campo 'Vl título' é obrigatório.");
			return false;
		}
		document.getElementById('idLancamentoFrame').contentWindow
				.atualizarDadosDefault(valor);
	}
}

function atualizarValores(valorSomaTotal, valorSomaIcms, quantidadeLancamento) {
	var valAcessorio = 0;
	var valSomaEntradas = valorSomaTotal;
	if($('#valorAcessorio').val() != ''){
		valSomaEntradas = parseFloat(valSomaEntradas) + toFloat($('#valorAcessorio').val());
	}

	$('#valorTotalNotas').val(moeda(numeros(arredondaFloat(valorSomaTotal).toString())));
	//$('#somaValorTotal').val(valorSomaTotal);
	$('#somaEntradas').val(moeda(numeros(arredondaFloat(valSomaEntradas).toString())));
	$('#somarValorICMS').val(moeda(numeros(arredondaFloat(valorSomaIcms).toString())));
}

function atualizarValoresEntrada() {
	var valAcessorio = 0;
	if($('#valorAcessorio').val() != ''){
		valAcessorio = toFloat($('#valorAcessorio').val());
	}
	
	var valSomaEntradas = 0;
	if($('#somaEntradas').val() != ''){
		valSomaEntradas = toFloat($('#somaEntradas').val());
	}
	
	$('#somaEntradas').val(moeda(numeros(arredondaFloat(valSomaEntradas + valAcessorio).toString())));
}

function showData() {
	$('#divData').DatePicker({
		flat : true,
		calendars : 1,
		format : 'd/m/Y',
		mode : 'range',
		starts : 0,
	});
}
</script>

<s:form action="manterLancamento!salvarEstoque.action" theme="simple"
	namespace="/app/estoque">

	<s:hidden name="movimentoEstoque.idMovimentoEstoque" />
	<s:hidden name="prazo" />
	
	<p id="divData" style="display: none; visibility: hidden"></p>

	<!-- divHistorico -->
	<div class="divFiltroPaiTop">Estoque - Entradas</div>
	<div class="divFiltroPai">

		<div class="divCadastro" style="overflow: auto; height: 200%;">
			
			<!-- Grupo Dados do Fornecedor -->
			<div class="divGrupo" style="height: 105px;">
				<div class="divGrupoTitulo">Dados do Fornecedor</div>
				
				<div class="divLinhaCadastro">
					<!-- Fornecedor -->
					<div class="divItemGrupo" style="width: 470px;">
						<p style="width: 100px;">Fornecedor</p>
						<s:textfield
							name="movimentoEstoque.fornecedorHotelEJB.fornecedorRedeEJB.nomeFantasia"
							id="fornecedor" 
							size="50" 
							cssStyle="width: 350px;"
							maxlength="50"
							onblur="getFornecedor(this)" />
						<s:hidden name="idFornecedor" id="idFornecedor" />
					</div>
					
					<div class="divItemGrupo" style="width: 470px;">
						<p style="width: 100px;">Chave de acesso</p>
						<s:textfield
							name="movimentoEstoque.chaveAcesso"
							id="chaveAcesso" 
							size="45" 
							maxlength="44" />
					</div>
					<!-- Num Pedido -->
					<!-- TODO: (ID) Falta implementar funcionalidade de Pedidos -->
<!-- 					<div class="divItemGrupo" style="width: 200px;"> -->
<!-- 						<p style="width: 100px;">Número Pedido</p> -->
<%-- 						<s:if test="%{movimentoEstoque.idMovimentoEstoque == null}"> --%>
<%-- 							<s:textfield name="movimentoEstoque.numDocumento" id="numPedido" --%>
<%-- 								size="10" maxlength="8" /> --%>
<%-- 						</s:if> --%>
<%-- 						<s:else> --%>
<%-- 							<s:property value="movimentoEstoque.numDocumento" /> --%>
<%-- 							<s:hidden name="movimentoEstoque.numDocumento" id="numPedido" /> --%>
<%-- 						</s:else> --%>
<!-- 					</div> -->
				</div> 

				<div class="divLinhaCadastro">
					<!-- Num Documento -->
					<div class="divItemGrupo" style="width: 220px;">
						<p style="width: 100px;">Num Documento</p>
						<s:if test="%{movimentoEstoque.idMovimentoEstoque == null}">
							<s:textfield 
								name="movimentoEstoque.numDocumento" 
								id="numDocumento"
								onkeypress="mascara(this, numeros);"
 								size="12" 
 								maxlength="8" 
 								required="required" />
 						</s:if> 
 						<s:else> 
 							<s:property value="movimentoEstoque.numDocumento" /> 
 							<!-- TODO: (ID) Porquê expôr valores que não podem ser alterados em campos hidden? -->
							<s:hidden name="movimentoEstoque.numDocumento" id="numDocumento" /> 
 						</s:else> 
					</div>
					
					<!-- Data Emissao -->
					<div class="divItemGrupo" style="width: 250px;">
						<p style="width: 120px;">Data emissão</p>
						<s:textfield 
							name="movimentoEstoque.dataDocumento"
 							id="dataDocumento" 
 							onblur="dataValida(this);complementoFornecedor('');"  
  							onkeypress="mascara(this, data);" 
  							size="12" 
  							maxlength="10"  
  							cssClass="dp" /> 
					</div>
					
					<!-- Tipo Documento -->
					<div class="divItemGrupo" style="width: 223px;">
						<p style="width: 100px;">Tipo doc</p>
						<s:textfield 
							name="movimentoEstoque.tipoDocumento" 
							id="tipoDocumento" 
							size="12"
 							maxlength="5" 
 							onblur="toUpperCase(this)" 
 							required="required" />
					</div>
					
					<!-- Serie Documento -->
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 60px;">Série</p>
						<s:textfield 
							name="movimentoEstoque.serieDocumento" 
							id="serieDocumento" 
							size="5"
 							maxlength="3" 
 							onblur="toUpperCase(this)" 
 							required="required" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<!-- Total da Nota -->
					<div class="divItemGrupo" style="width: 220px;">
						<p style="width: 100px;">Total da Nota</p>
						<s:textfield
							name="valorTotal"
	 						id="valorTotal" 
	 						onkeypress="mascara(this, moeda);"
							size="12" 
							maxlength="12" />
						<s:hidden id="valorTotalNotas" name="valorTotalNotas" />
					</div>
					
					<!-- Entradas -->
					<div class="divItemGrupo" style="width: 250px;">
						<p style="width: 120px;">Entradas</p>
						<s:textfield 
							disabled="true"
							readonly="true"
							cssStyle="background-color:silver;"
							name="somaEntradas"
							id="somaEntradas" 
							onkeypress="mascara(this, moeda);" 
							size="12" 
							maxlength="12" /> 
					</div>
					
					
				</div>
			</div>
			<!-- Fim Grupo Dados do Fornecedor -->
			
			<!-- Grupo Acessórios -->
			<div class="divGrupo" style="height: 75px;">
				<div class="divGrupoTitulo">Acessórios</div>
			
				<div class="divLinhaCadastro">
					<!-- Conta Contabil -->
					<div class="divItemGrupo" style="width: 470px;">
						<p style="width: 100px;">Conta Contábil</p>
						<s:textfield
							name="representacaoPlanoContas"
							id="planoContas" 
							onblur="getPlanoContas(this)"
							size="50" 
							cssStyle="width: 350px;"
							maxlength="50" />
						<s:hidden name="idPlanoContas" id="idPlanoContas" />
					</div>
					
					<!-- Centro de Custo Contabil Acessor -->
					<div id="divCentroCustoContabilAcessorio" class="divItemGrupo" style="width:365px;" >
						<p style="width:100px;">Centro de Custo</p>
						<s:select list="centrosCustoContabil" 
 							cssStyle="width:255px"
 							name="idCentroCusto" 
 							id="centroCustoAcessorio" 
 							listKey="idCentroCustoContabil" 
 							listValue="descricaoCentroCusto" 
 							headerKey="" 
 							headerValue="Selecione" /> 
					</div>
					
					
				</div>
				
				<div class="divLinhaCadastro">
					<!-- Justificativa -->
					<div class="divItemGrupo" style="width: 470px;">
						<p style="width: 100px;">Justificativa</p>
						<s:textfield 
							name="movimentoEstoque.observacao" 
							id="justificativa" 
							size="50" 
							cssStyle="width: 350px;"
							maxlength="255" />
					</div>
					<!-- Valor Acessorio -->
					<div class="divItemGrupo" style="width: 220px;">
						<p style="width: 100px;">Valor</p>
						<s:textfield 
							name="valorAcessorio" 
							id="valorAcessorio" 
							size="10"
 							maxlength="10" 
 							onkeypress="mascara(this, moeda)"
 							onblur="atualizarValoresEntrada();" />
					</div>
				</div>
			</div>
			<!-- Fim Grupo Acessórios -->
			
			<!-- Grupo Contas a Pagar -->
			<div class="divGrupo" style="height: 50px;">
				<div class="divGrupoTitulo">Contas a Pagar</div>
				
				<div class="divLinhaCadastro">
					<!-- Banco -->
					<div class="divItemGrupo" style="width: 470px;">
						<p style="width: 100px;">Conta corrente</p>
						<s:select 
							name="idContaCorrente"
							id="idContaCorrente"
							list="contasCorrente" 
							listKey="idContaCorrente"
							listValue="bancoAgenciaContaCorrente"
	 							cssStyle="width: 350px;" />
					</div>
					
					<!-- Data Vencimento -->
					<div class="divItemGrupo" style="width: 250px;">
						<p style="width: 100px;">Data Vencimento</p>
						<s:textfield 
							name="movimentoEstoque.dataVencimento"
 							id="dataVencimento" 
 							onblur="dataValida(this);" 
 							onkeypress="mascara(this, data);" 
 							size="12" 
 							maxlength="10" 
 							cssClass="dp" />
					</div>
				</div>
			</div>
			<!-- Fim Grupo Contas a Pagar -->			

			<!-- Grupo Grid -->
			<div id="gridLancamento" class="divGrupo" style="width:99%; height:270px;">
				<div class="divGrupoTitulo" style="float:left;">Dados da Entrada</div>
				<iframe width="100%" height="220" id="idLancamentoFrame" scrolling="no" 
						frameborder="0" marginheight="0" marginwidth="0" 
						src="<s:url value="app/estoque/include!prepararLancamento.action"/>?time=<%=new java.util.Date()%>"  >
				</iframe>
			</div>
			<!-- Fim Grupo Grid -->

			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
					onClick="gravar()" />
			</div>

		</div>
	</div>
</s:form>
<script>
	showData();
</script>