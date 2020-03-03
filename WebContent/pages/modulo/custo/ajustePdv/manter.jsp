<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
$('#linhaEstoque').css('display', 'block');

function getPontoVendaSelecionado(elemento){
	loading();
	submitFormAjax('getPontoVendaSelecionado?'
				+ '&OBJ_VALUE=' + elemento.value,true);
}

function atualizarDataRestaurante(data){
	if( data != null && data != 'null' && data != ''){
		$('#dataEmissao').val(data);
	} 
}

function cancelar() {
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarAjustePdv!prepararPesquisa.action" namespace="/app/custo" />';
	submitForm(vForm);
}

function gravar() {

	if ($("select[name='idPontoVenda']").val() == '') {
		alerta("Campo 'Ponto de Venda' é obrigatório.");
		return false;
	}
	
	if ($("input[name='motivo']").val() == '') {
		alerta("Campo 'Motivo' é obrigatório.");
		return false;
	}
	
	if ($("input[name='numDocumento']").val() == '') {
		alerta("Campo 'Num Documento' é obrigatório.");
		return false;
	}

	if ($("input[name='tipoDocumento']").val() == '') {
		alerta("Campo 'Tipo' é obrigatório.");
		return false;
	}
	if ($("input[name='dataEmissao']").val() == '') {
		alerta("Campo 'Data Emissão' é obrigatório.");
		return false;
	}
	/*if (pegaDiferencaDiasDatas('<s:property value="#session.CONTROLA_DATA_SESSION.estoque"/>' ,$("input[name='dataEmissao']").val()) < 0){
		alerta("O campo 'Data Emissão' deve ser menor ou igual à Estoque.");
		return false;
	}*/

	podeGravar();
}

function podeGravar() {
	vForm = document.forms[0];
	vForm.action = '<s:url action="manterAjustePdv!salvarAjustePdv.action" namespace="/app/custo" />';
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
</script>

<s:form action="manterAjustePdv!salvarAjustePdv.action" theme="simple"
	namespace="/app/custo">

	<s:hidden name="idMovimentoEstoque" />
	
	<p id="divData" style="display: none; visibility: hidden"></p>

	<div class="divFiltroPaiTop">PDV - Ajustes</div>
	<div class="divFiltroPai">

		<div class="divCadastro" style="overflow: auto; height: 200%;">
			
			<div class="divGrupo" style="height: 130px;">
				<div class="divGrupoTitulo">Dados dos Centros Custos</div>
			
				<div class="divLinhaCadastro">				
					<!-- Ponto de Venda -->
					<div class="divItemGrupo" style="width: 300px;">
						<p style="width: 120px;">Ponto de Venda</p>
						<s:select list="pontoVendaList" 
 							cssStyle="width:150px"
 							name="idPontoVenda" 
 							id="idPontoVenda" 
 							listKey="id.idPontoVenda" 
 							listValue="nomePontoVenda" 
 							headerKey="" 
 							onchange="getPontoVendaSelecionado(this);"
 							headerValue="Selecione" />  
					</div>
					
					<!-- Motivo -->
					<div class="divItemGrupo" style="width: 450px;">
						<p style="width: 100px;">Motivo</p>
						<s:textfield 
							name="motivo" 
							id="motivo"
							onblur="toUpperCase(this)"
							size="50" 
							maxlength="50" />
					</div>
				</div>
				
				<div class="divLinhaCadastro">
					<!-- Data Emissao -->
					<div class="divItemGrupo" style="width: 300px;">
						<p style="width: 120px;">Data emissão</p>
						<s:textfield 
							name="dataEmissao"
 							id="dataEmissao" 
  							size="12" 
  							maxlength="10"  
  							readonly="true" cssStyle="background-color:silver;"/> 
					</div>
					
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
					
				</div>
			</div>
			
			<!-- Grupo Grid -->
			<div id="gridLancamento" class="divGrupo" style="width:99%; height:270px;">
				<div class="divGrupoTitulo" style="float:left;">Dados</div>
				<iframe width="100%" height="220" id="idLancamentoFrame" scrolling="no" 
						frameborder="0" marginheight="0" marginwidth="0" 
						src="<s:url value="app/custo/includeAjustePdv!prepararLancamento.action"/>?time=<%=new java.util.Date()%>"  >
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