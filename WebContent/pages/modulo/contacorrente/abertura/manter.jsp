<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	window.onload = function() {
		addPlaceHolder('contaCorrente', 'ex.: O número ou nome da conta');
	};

	function addPlaceHolder(id, msg) {
		document.getElementById(id).setAttribute("placeholder", msg);
	}

	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisar!prepararAbertura.action" namespace="/app/contacorrente" />';
		submitForm(vForm);
	}

	function getEmpresa(elemento) {
		url = 'app/ajax/ajax!selecionarEmpresa?OBJ_NAME=' + elemento.name
				+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idEmpresa';
		getDataLookup(elemento, url, 'Empresa', 'TABLE');
	}

	function gravar() {

		if ($("select[name='apto.idApartamento']").val() == '') {
			alerta('Campo "Conta" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.idEmpresa']").val() == '') {
			alerta('Campo "Empresa" é obrigatório.');
			return false;
		}
		submitForm(document.forms[0]);

	}
</script>






<s:form namespace="/app/contacorrente"
	action="manterAbertura!gravarAbertura.action" theme="simple">

	<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1}" var="isHotel" />
	<s:set var="labelTela">
		<s:if test="isHotel">Apartamento</s:if>
		<s:else>Abertura de Conta</s:else>
	</s:set>
	<s:set var="display">
		<s:if test="isHotel">block</s:if>
		<s:else>none</s:else>
	</s:set>


	<div class="divFiltroPaiTop">
		<s:property value="#labelTela" />
	</div>
	<div class="divFiltroPai">
		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 400px;">
				<div class="divGrupoTitulo">Dados</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 500px;">
						<p style="width: 80px;">Conta:</p>
						<s:if test="%{alteracao}">
							<s:hidden name="apto.idApartamento" />
							<s:hidden name="entidade.idCheckin" />
							<s:hidden name="entidade.checkout" />
							<s:hidden name="entidade.dataEntrada" />
							<s:hidden name="entidade.dataSaida" />
							<s:hidden name="entidade.credito" />
							<s:hidden name="entidade.cortesia" />
							<s:hidden name="entidade.calculaIss" />
							<s:hidden name="entidade.calculaRoomtax" />
							<s:hidden name="entidade.calculaTaxa" />
							<s:property value="apto.numApartamento" />
						</s:if>
						<s:else>
							<s:select list="#session.LIST_APTO" cssStyle="width:150px"
								headerValue="Selecione" headerKey="" listKey="idApartamento"
								listValue="numApartamento" id="idApartamento"
								name="apto.idApartamento">
							</s:select>
						</s:else>
					</div>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 500px;">
						<p style="width: 80px;">Empresa:</p>
						<s:set name="dsEmpresa" value="alteracao? entidade.empresaHotelEJB:'' " />
						<s:if test="%{alteracao}">
							<s:property value="entidade.empresaHotelEJB.empresaRedeEJB.nomeFantasia"/> - <s:property value="entidade.empresaHotelEJB.empresaRedeEJB.empresaEJB.cgc"/>
						</s:if>
						<s:else>
						<s:textfield name="empresa" size="50" maxlength="50" id="empresa"
							onblur="getEmpresa(this);" />
						</s:else>
						<s:hidden name="entidade.idEmpresa" id="idEmpresa" />
					</div>
				</div>
				<div class="divLinhaCadastro" style="height: 55px;">
					<div class="divItemGrupo" style="width: 600px;">
						<p style="width: 80px;">Observação:</p>
						<s:textarea name="entidade.observacao" cols="40" rows="2"
							onkeyup="toUpperCase(this);"></s:textarea>
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