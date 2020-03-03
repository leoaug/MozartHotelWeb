<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">

function cancelar() {
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarConsumoInterno!prepararPesquisa.action" namespace="/app/custo" />';
	submitForm(vForm);
}

function obterValoresPontoVendaPensao(idItem) {
	var idUsuario = $('select[name=idUsuario]').val();
	
	if (idUsuario == '') {
		alerta("Campo 'Usuário' é obrigatório.");
		$("select[name='idPontoVenda']").val('');
		return false;
	}
	
	url = 'app/ajax/ajax!obterDadosUsuarioConsumoInternoMovimentacao?OBJ_USUARIO_VALUE=' + idUsuario
			+ '&OBJ_PV_VALUE=' + idItem;
	getAjaxValue(url, ajaxCallback);
}

function ajaxCallback(valor){
	if(valor != ""){
		var valores = valor.split(';');
		var idPontoVenda = valores[0];
		var data = valores[1];
		var pensao = valores[2];
		var tipoPensao = valores[3];
		
		$("input[name='idPontoVenda']").val(idPontoVenda);
		$("input[name='dataEmissao']").val(data);
		$("input[name='idPensao']").val(pensao);
		$("input[name='tipoPensao']").val(tipoPensao);
	}
	else
	{
		$("input[name='idPontoVenda']").val("");
		$("input[name='dataEmissao']").val("");
		$("input[name='idPensao']").val("");
		$("input[name='tipoPensao']").val("");
	}
}

function gravar() {

	if ($('select[name=idUsuario]').val() == '') {
		alerta("Campo 'Usuário' é obrigatório.");
		return false;
	}

	if ($('select[name=idPontoVenda]').val() == '') {
		alerta("Campo 'Ponto de Venda' é obrigatório.");
		return false;
	}

	if ($("input[name='numDocumento']").val() == '') {
		alerta("Campo 'Num Documento' é obrigatório.");
		return false;
	}

	if ($("input[name='dataEmissao']").val() == '') {
		alerta("Campo 'Data Emissão' é obrigatório.");
		return false;
	}
	
	if ($("input[name='idPensao']").val() == '') {
		alerta("Campo 'Pensão' é obrigatório.");
		return false;
	}

	podeGravar();
}

function podeGravar() {
	vForm = document.forms[0];
	vForm.action = '<s:url action="manterConsumoInterno!salvarConsumo.action" namespace="/app/custo" />';
	submitForm(vForm);
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

function atualizarValores(valorTotalCusto, valorTotalVenda){

	if(valorTotalCusto!=null && valorTotalCusto != '' &&
			valorTotalVenda!=null && valorTotalVenda != ''){

		$("#somaValorTotalCusto").val(moeda4Decimais(numeros(arredondaFloat4Decimais(parseFloat(valorTotalCusto.toString().replace(",","."))).toString().replace(".",","))));
		$("#somaValorTotalVenda").val(moeda4Decimais(numeros(arredondaFloat4Decimais(parseFloat(valorTotalVenda.toString().replace(",","."))).toString().replace(".",","))));
	}
}
</script>

<s:form action="manterConsumoInterno!salvarTransferencia.action" theme="simple"
	namespace="/app/custo">

	<s:hidden name="idMovimentoEstoque" />
	 
	<p id="divData" style="display: none; visibility: hidden"></p>

	<div class="divFiltroPaiTop">CI - Movimentação</div>
	<div class="divFiltroPai">

		<div class="divCadastro" style="overflow: auto; height: 200%;">
			
			<div class="divGrupo" style="height: 130px;">
				<div class="divGrupoTitulo">Dados do Consumo Interno</div>
			
				<div class="divLinhaCadastro">			
				
					<!-- Usuário -->
					<div id="divUsuario" class="divItemGrupo" style="width:380px;" >
						<p style="width:100px;">Usuário</p>
						<s:select list="usuarioList" 
 							cssStyle="width:255px"
 							name="idUsuario" 
 							id="idUsuario" 
 							listKey="idUsuario" 
 							listValue="nomeUsuario" 
 							headerKey="" 
 							headerValue="Selecione" /> 
					</div>
					
					<!-- Ponto Venda -->
					<div id="divPontoVenda" class="divItemGrupo" style="width:300px;" >
						<p style="width:90px;">Ponto Venda</p>
						<s:select list="pontoVendaList" 
 							name="idPontoVenda" 
 							id="idPontoVenda" 
 							listKey="idPontoVenda" 
 							listValue="pontoVendaDesc" 
 							headerKey="" 
 							onchange="obterValoresPontoVendaPensao(this.value);"
 							headerValue="Selecione" 
  							cssStyle="width:200px;"/> 
					</div>
						
					<!-- Data Movimento -->
					<div class="divItemGrupo" style="width: 250px;">
						<p style="width: 90px;">Data Emissão</p>
						<s:textfield 
							name="dataEmissao"
 							id="dataEmissao"   
  							onkeypress="mascara(this, data);" 
  							size="12" 
  							maxlength="10"  
  							readonly="true"
  							cssStyle="background-color:silver;text-align: right;" /> 
					</div>
				</div>
				
				
				<div class="divLinhaCadastro">
					
					<!-- Num Documento -->
					<div class="divItemGrupo" style="width: 220px;">
						<p style="width: 100px;">Num Documento</p>
						<s:textfield 
							name="numDocumento" 
							id="numDocumento"
							onkeypress="mascara(this, numeros);"
								size="12" 
								maxlength="8" />
					</div>
					
					<!-- Pensão -->
					<div class="divItemGrupo" style="width: 260px;">
						<p style="width: 80px;">Pensão</p>
						<s:textfield 
							name="idPensao" 
							id="idPensao" 
							size="20"
 							maxlength="20" 
 							onblur="toUpperCase(this)"
							readonly="true"
  							cssStyle="background-color:silver;text-align: right;"/>
					</div>
					<s:hidden name="tipoPensao" id="tipoPensao" />
				</div>
			</div>
			
			<!-- Grupo Grid -->
			<div id="gridLancamento" class="divGrupo" style="width:99%; height:270px;">
				<div class="divGrupoTitulo" style="float:left;">Dados da Saída</div>
				<iframe width="100%" height="220" id="idLancamentoFrame" scrolling="no" 
						frameborder="0" marginheight="0" marginwidth="0" 
						src="<s:url value="app/custo/includeConsumoMovimentacao!prepararLancamento.action"/>?time=<%=new java.util.Date()%>"  >
				</iframe> 
				<div class="divLinhaCadastro" style="height: 20px;">

						<div class="divItemGrupo" style="width: 250px;">
						</div>
						<div class="divItemGrupo" style="width: 250px;">
							<p style="width: 100px;">Vr. Total do Custo:</p>
							<s:textfield cssClass="somaValorTotalCusto" name="somaValorTotalCusto"
								id="somaValorTotalCusto" onkeypress="mascara(this, moeda4Decimais)" size="10"
								maxlength="10" readonly="true"
								cssStyle="text-align: right;background-color:silver;" />
						</div>
						<div class="divItemGrupo" style="width: 250px;">
							<p style="width: 110px;">Vr. Total da Venda:</p>
							<s:textfield cssClass="somaValorTotalVenda" name="somaValorTotalVenda"
								id="somaValorTotalVenda" onkeypress="mascara(this, moeda4Decimais)" size="10"
								maxlength="10" readonly="true"
								cssStyle="text-align: right;background-color:silver;" />
						</div>
					</div>
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