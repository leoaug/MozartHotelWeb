<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	$('#linhaFaturamento').css('display', 'block');

	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarFaturamento!prepararPesquisa.action" namespace="/app/financeiro" />';
		submitForm(vForm);
	}

	function gravar() {

		if ($(
				"input[name='entidade.empresaHotelEJB.empresaRedeEJB.empresaEJB.idEmpresa']")
				.val() == '') {
			alerta('Campo "Empresa" � obrigat�rio.');
			return false;
		}

		if ($("input[name='entidade.dataVencimento']").val() == '') {
			alerta('Campo "Dt vencimento" � obrigat�rio.');
			return false;
		}

		if ($("input[name='entidade.dataini']").val() == ''
				|| $("input[name='entidade.datafim']").val() == '') {
			alerta('Campo "Data" � obrigat�rio.');
			return false;
		}

		if ($("input[name='entidade.horaini']").val() == ''
				|| $("input[name='entidade.horafim']").val() == '') {
			alerta('Campo "Hora" � obrigat�rio.');
			return false;
		}
		if ($("input[name='entidade.ndiscini']").val() == ''
				|| $("input[name='entidade.ndiscfim']").val() == '') {
			alerta('Campo "N. Disc" � obrigat�rio.');
			return false;
		}
		if ($("input[name='entidade.tempoini']").val() == ''
				|| $("input[name='entidade.tempofim']").val() == '') {
			alerta('Campo "Tempo" � obrigat�rio.');
			return false;
		}
		if ($("input[name='entidade.custoini']").val() == ''
				|| $("input[name='entidade.custofim']").val() == '') {
			alerta('Campo "Custo" � obrigat�rio.');
			return false;
		}
		if ($("input[name='entidade.taxaini']").val() == ''
				|| $("input[name='entidade.taxafim']").val() == '') {
			alerta('Campo "Taxa" � obrigat�rio.');
			return false;
		}

		if ($("#tarifaTaxa").val() == 'S'
				&& $("input[name='entidade.taxa']").val() == '') {
			alerta('Campo "% Acr�scimo" � obrigat�rio.');
			return false;
		}

		if ($("input[name='entidade.acobrar']").val() == '') {
			alerta('Campo "Valor a cobrar" � obrigat�rio.');
			return false;
		}

		if ($("input[name='entidade.caminho']").val() == '') {
			alerta('Campo "Pasta telefonia" � obrigat�rio.');
			return false;
		}

		if ($("input[name='entidade.tipoLancamentoTelefonia.idTipoLancamento']")
				.val() == '') {
			alerta('Campo "Conta telefonia" � obrigat�rio.');
			return false;
		}

		submitForm(document.forms[0]);
	}

	function getEmpresa(elemento) {
		url = 'app/ajax/ajax!selecionarEmpresa?OBJ_NAME=' + elemento.name
				+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idEmpresa';
		getDataLookup(elemento, url, 'Empresa', 'TABLE');
	}

	function obterComplementoEmpresa() {
	}

	function atualizarValorLiquido() {
		vlDuplicata =toFloat( document.getElementById('valorDuplicata').value);
		vlComissao =toFloat( document.getElementById('comissao').value);
		vlIr = toFloat(document.getElementById('ir').value);
		vlEncargos = toFloat(document.getElementById('encargos').value);
		vlAjustes = toFloat(document.getElementById('ajustes').value);
		vlIrRetencao = toFloat(document.getElementById('irRetencao').value);
		vlCofins = toFloat(document.getElementById('cofins').value);
		vlPis = toFloat(document.getElementById('pis').value);
		vlCssl = toFloat(document.getElementById('cssl').value);
		vlIss = toFloat(document.getElementById('iss').value);

		vlDuplicata = vlDuplicata + vlIr - vlComissao - vlAjustes - vlEncargos - vlIrRetencao - vlCofins - vlPis - vlCssl - vlIss;

		document.getElementById('divValorLiquido').innerHTML = moeda(numeros(arredondaFloat(vlDuplicata).toString()));
	}
</script>






<s:form action="manterFaturamento!gravar.action" theme="simple"
	namespace="/app/financeiro">

	<s:hidden name="entidade.idDuplicata" />
	<s:hidden name="entidade.numParcelas" />
	<s:hidden id="valorDuplicata" name="entidade.valorDuplicata" />
	

	<div class="divFiltroPaiTop">Faturamento</div>
	<div class="divFiltroPai">

		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 180px;">
				<div class="divGrupoTitulo">Dados da duplicata</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 400px;">
						<p style="width: 100px;">Num Nota:</p>
						<s:property value="#session.entidadeSession.numDuplicata" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 400px;">
						<p style="width: 100px;">Empresa:</p>
						<input type="text"
							value='<s:property value="entidade.empresaHotelEJB.empresaRedeEJB.nomeFantasia" />'
							name="empresa" id="empresa" size="50" maxlength="50"
							onblur="getEmpresa(this)" />
						<s:hidden
							name="entidade.empresaHotelEJB.empresaRedeEJB.empresaEJB.idEmpresa"
							id="idEmpresa" />
						<input type="text"
							style="width: 1px; border: 0px; background-color: rgb(247, 247, 247);" />
					</div>
				</div>


				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 500px;">
						<p style="width: 100px;">Conta corrente:</p>
						<s:select list="contaCorrenteList" listKey="idContaCorrente"
							cssStyle="width:250px;" name="entidade.contaCorrente.id"
							id="idContaCorrente" />
					</div>

				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 300px;">
						<p style="width: 100px;">Dt. Emiss�o:</p>
						<s:property value="#session.entidadeSession.dataLancamento" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 300px;">
						<p style="width: 100px;">Data vencimento:</p>
						<s:textfield cssClass="dp" name="entidade.dataVencimento"
							id="dataVencimento" size="10" maxlength="10"
							onkeypress="mascara(this, data)" onblur="dataValida(this)" />
					</div>
				</div>

			</div>
			<div class="divGrupo" style="height: 160px;">
				<div class="divGrupoTitulo">Valores/Taxas</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 220px;">
						<p style="width: 120px;">Comiss�o - Ag�ncia:</p>
						<s:textfield onchange="atualizarValorLiquido()" name="entidade.comissao" id="comissao" size="10"
							maxlength="10" onkeypress="mascara(this, moeda)" />
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 100px;">IR - Comiss�o:</p>
						<s:textfield onchange="atualizarValorLiquido()" name="entidade.ir" id="ir" size="10" maxlength="10"
							onkeypress="mascara(this, moeda)" />
					</div>
					<div class="divItemGrupo" style="width: 220px;">
						<p style="width: 120px;">Encargos - Cart�o:</p>
						<s:textfield onchange="atualizarValorLiquido()" name="entidade.encargos" id="encargos" size="10"
							maxlength="10" onkeypress="mascara(this, moeda)" />
					</div>
					<div class="divItemGrupo" style="width: 160px;">
						<p style="width: 60px;">Ajustes:</p>
						<s:textfield onchange="atualizarValorLiquido()" name="entidade.ajustes" id="ajustes" size="10"
							maxlength="10" onkeypress="mascara(this, moeda)" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 100px;">IR - Reten��o:</p>
						<s:textfield onchange="atualizarValorLiquido()" name="entidade.irRetencao" id="irRetencao" size="10"
							maxlength="10" onkeypress="mascara(this, moeda)" />
					</div>
					<div class="divItemGrupo" style="width: 220px;">
						<p style="width: 120px;">COFINS - Reten��o:</p>
						<s:textfield onchange="atualizarValorLiquido()" name="entidade.cofins" id="cofins" size="10"
							maxlength="10" onkeypress="mascara(this, moeda)" />
					</div>
					<div class="divItemGrupo" style="width: 190px;">
						<p style="width: 100px;">PIS - Reten��o:</p>
						<s:textfield onchange="atualizarValorLiquido()" name="entidade.pis" id="pis" size="10" maxlength="10"
							onkeypress="mascara(this, moeda)" />
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 110px;">CSSL - Reten��o:</p>
						<s:textfield onchange="atualizarValorLiquido()" name="entidade.cssl" id="cssl" size="10"
							maxlength="10" onkeypress="mascara(this, moeda)" />
					</div>

				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 100px;">ISS - Reten��o:</p>
						<s:textfield onchange="atualizarValorLiquido()" name="entidade.iss" id="iss" size="10" maxlength="10"
							onkeypress="mascara(this, moeda)" />
					</div>
					<div class="divItemGrupo" style="width: 400px;">
						<p style="width: 80px;">Justificativa:</p>
						<s:textfield name="entidade.justificaAjuste" id="justificaAjuste"
							size="30" maxlength="50" onblur="toUpperCase(this)" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 120px;">
							<b>Vr. Dupl. Liquido:</b>
						</p>
						<div id="divValorLiquido">
							<s:property value="entidade.valorAlteracao" />
						</div>
					</div>
				</div>

			</div>


			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
					onClick="gravar()" />
			</div>

		</div>
	</div>
</s:form>