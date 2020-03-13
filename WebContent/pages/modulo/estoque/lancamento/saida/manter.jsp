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

	if ($("select[name='idCentroCusto']").val() == '') {
		alerta("Campo 'Centro de Custo' é obrigatório.");
		return false;
	}
	
	if ($("input[name='tipoMovimento']").val() == '') {
		alerta("Campo 'Tipo Movimento' é obrigatório.");
		return false;
	}
	
	if ($("input[name='movimentoEstoque.numDocumento']").val() == '') {
		alerta("Campo 'Num Requisição' é obrigatório.");
		return false;
	}

	if ($("input[name='movimentoEstoque.tipoDocumento']").val() == '') {
		alerta("Campo 'Tipo' é obrigatório.");
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

	podeGravar();
}

function podeGravar() {
	vForm = document.forms[0];
	vForm.action = '<s:url action="entradaSaidaEstoque!salvarSaida.action" namespace="/app/estoque" />';
	submitForm(vForm);
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
	$('#valorTotalNotas').val(moeda(numeros(arredondaFloat(valorSomaTotal).toString())));
	//$('#somaValorTotal').val(valorSomaTotal);
	$('#somaEntradas').val(moeda(numeros(arredondaFloat(valorSomaTotal).toString())));
	$('#somarValorICMS').val(moeda(numeros(arredondaFloat(valorSomaIcms).toString())));
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

<s:form action="entradaDevolucaoEstoque!salvarSaida.action" theme="simple"
	namespace="/app/estoque">

	<s:hidden name="movimentoEstoque.idMovimentoEstoque" />
	<s:hidden name="prazo" />
	
	<p id="divData" style="display: none; visibility: hidden"></p>

	<!-- divHistorico -->
	<div class="divFiltroPaiTop">Estoque - Saídas</div>
	<div class="divFiltroPai">

		<div class="divCadastro" style="overflow: auto; height: 200%;">
			
			<!-- Grupo Dados do Fornecedor -->
			<div class="divGrupo" style="height: 105px;">
				<div class="divGrupoTitulo">Dados do Requisitante</div>
				
				<div class="divLinhaCadastro">
					<!-- Fornecedor -->
					<div class="divItemGrupo" style="width: 450px;">
						<p style="width: 100px;">Centro de Custo</p>
						<s:select 
							name="idCentroCusto"
							id="idCentroCusto"
							list="listCentrosCusto" 
							listKey="idCentroCustoContabil"
							listValue="descricaoCentroCusto"
							headerKey="" 
 							headerValue="Selecione" 
	 							cssStyle="width: 200px;" />
					</div>
					
					
					<div class="divItemGrupo" style="width: 400px;">
						<p style="width: 100px;">Tipo Movimento</p>
						<select name="tipoMovimento" id="tipoMovimento" style="width:100px;">
							<option selected="selected" value="S">Saída</option>
							<option value="P">A Porcionar</option>
						</select>
					</div>
				</div> 

				<div class="divLinhaCadastro">
					<!-- Num Documento -->
					<div class="divItemGrupo" style="width: 220px;">
						<p style="width: 100px;">Num Documento</p>
						<s:textfield 
							name="movimentoEstoque.numDocumento" 
							id="numDocumento"
							onkeypress="mascara(this, numeros);"
								size="12" 
								maxlength="8" 
								required="required" />
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
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 80px;">Tipo doc</p>
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
							size="8"
 							maxlength="5" 
 							onblur="toUpperCase(this)" 
 							required="required" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 250px;">
						<p style="width: 120px;">Total da Requisição</p>
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
			
			<!-- Grupo Grid -->
			<div id="gridLancamento" class="divGrupo" style="width:99%; height:270px;">
				<div class="divGrupoTitulo" style="float:left;">Dados da Saída</div>
				<iframe width="100%" height="220" id="idLancamentoFrame" scrolling="no" 
						frameborder="0" marginheight="0" marginwidth="0" 
						src="<s:url value="app/estoque/includeSaida!prepararLancamentoSaida.action"/>?time=<%=new java.util.Date()%>"  >
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