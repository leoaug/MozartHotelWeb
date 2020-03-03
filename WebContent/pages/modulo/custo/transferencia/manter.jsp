<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
$('#linhaEstoque').css('display', 'block');

function cancelar() {
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarTransferenciaCentroCustos!prepararPesquisa.action" namespace="/app/custo" />';
	submitForm(vForm);
}

function gravar() {

	if ($("input[name='numDocumento']").val() == '') {
		alerta("Campo 'Num Documento' é obrigatório.");
		return false;
	}

/* 	if ($("input[name='serieDocumento']").val() == '') {
		alerta("Campo 'Série' é obrigatório.");
		return false;
	} */
	if ($("input[name='tipoDocumento']").val() == '') {
		alerta("Campo 'Tipo' é obrigatório.");
		return false;
	}
	if ($("input[name='dataEmissao']").val() == '') {
		alerta("Campo 'Data Emissão' é obrigatório.");
		return false;
	}
	if (pegaDiferencaDiasDatas('<s:property value="#session.CONTROLA_DATA_SESSION.estoque"/>' ,$("input[name='dataEmissao']").val()) < 0){
		alerta("O campo 'Data Emissão' deve ser menor ou igual à Estoque.");
		return false;
	}

	podeGravar();
}

function podeGravar() {
	vForm = document.forms[0];
	vForm.action = '<s:url action="manterTransferenciaCentroCustos!salvarTransferencia.action" namespace="/app/custo" />';
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

<s:form action="manterTransferenciaCentroCustos!salvarTransferencia.action" theme="simple"
	namespace="/app/custo">

	<s:hidden name="idMovimentoEstoque" />
	
	<p id="divData" style="display: none; visibility: hidden"></p>

	<div class="divFiltroPaiTop">Transferência Centro Custo</div>
	<div class="divFiltroPai">

		<div class="divCadastro" style="overflow: auto; height: 200%;">
			
			<div class="divGrupo" style="height: 130px;">
				<div class="divGrupoTitulo">Dados dos Centros Custos</div>
			
				<div class="divLinhaCadastro">				
					<!-- Data Movimento -->
					<div class="divItemGrupo" style="width: 250px;">
						<p style="width: 120px;">Data do Movimento</p>
						<s:textfield 
							name="dataMovimento"
 							id="dataMovimento"   
  							onkeypress="mascara(this, data);" 
  							size="12" 
  							maxlength="10"  
  							readonly="true"
  							cssStyle="background-color:silver;text-align: right;" /> 
					</div>
				</div>
				
				<div class="divLinhaCadastro">
								
					<!-- Do Centro de Custo -->
					<div id="divDoCentroCusto" class="divItemGrupo" style="width:380px;" >
						<p style="width:120px;">Do Centro de Custo</p>
						<s:select list="centroCustoOrigemList" 
 							cssStyle="width:255px"
 							name="idCentroCustoOrigem" 
 							id="idCentroCustoOrigem" 
 							listKey="idCentroCustoContabil" 
 							listValue="descricaoCentroCusto" 
 							headerKey="" 
 							headerValue="Selecione" /> 
					</div>
					
					<!-- Para Centro de Custo -->
					<div id="divParaCentroCusto" class="divItemGrupo" style="width:380px;" >
						<p style="width:120px;">Para Centro de Custo</p>
						<s:select list="centroCustoDestinoList" 
 							cssStyle="width:255px"
 							name="idCentroCustoDestino" 
 							id="centroCustoAcessorio" 
 							listKey="idCentroCustoContabil" 
 							listValue="descricaoCentroCusto" 
 							headerKey="" 
 							headerValue="Selecione" /> 
					</div>
					
				</div>
				
				<div class="divLinhaCadastro">
					<!-- Data Emissao -->
					<div class="divItemGrupo" style="width: 250px;">
						<p style="width: 120px;">Data emissão</p>
						<s:textfield 
							name="dataEmissao"
 							id="dataEmissao" 
 							onblur="dataValida(this);"  
  							onkeypress="mascara(this, data);" 
  							size="12" 
  							maxlength="10"  
  							cssClass="dp" /> 
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
					
					<!-- Tipo Documento -->
					<div class="divItemGrupo" style="width: 223px;">
						<p style="width: 100px;">Tipo doc</p>
						<s:textfield 
							name="tipoDocumento" 
							id="tipoDocumento" 
							size="12"
 							maxlength="5" 
 							onblur="toUpperCase(this)" />
					</div>
					
				</div>
			</div>
			
			<!-- Grupo Grid -->
			<div id="gridLancamento" class="divGrupo" style="width:99%; height:270px;">
				<div class="divGrupoTitulo" style="float:left;">Dados da Saída</div>
				<iframe width="100%" height="220" id="idLancamentoFrame" scrolling="no" 
						frameborder="0" marginheight="0" marginwidth="0" 
						src="<s:url value="app/custo/includeTransferencia!prepararLancamento.action"/>?time=<%=new java.util.Date()%>"  >
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