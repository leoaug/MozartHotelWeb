<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
		submitForm(vForm);
	}

	function gravar() {

		if ($('#idApartamentoOrigem').val() == '') {
			alerta("O campo 'Origem' é obrigatório.");
			return false;
		}
		if ($('#idApartamentoDestino').val() == '') {
			alerta("O campo 'Destino' é obrigatório.");
			return false;
		}

		if ($('#idApartamentoDestino').val() == $('#idApartamentoOrigem').val()) {
			alerta("O campo 'Destino' deve ser diferente da origem.");
			return false;
		}

		if ($('#idHospede').val() == '') {
			alerta("O campo 'Hóspede' é obrigatório.");
			return false;
		}

		if ($('#motivo').val() == '') {
			alerta("O campo 'Motivo' é obrigatório.");
			return false;
		}

		total = $("input:checkbox[id='despesas'][checked='true']").length;
		if (total == 0) {
			alerta("Marque ao menos um lançamento.");
			return false;
		}

		submitForm(document.forms[0]);
	}

	function obterMovimento(valor) {
		if (valor != '') {
			loading();
			//_url = "app/ajax/ajax!obterMovimentoDoApartamento?idApartamento="+valor+"&data="+
<%=new java.util.Date().getTime()%>
	;
			submitFormAjax('obterMovimentoDoApartamento?idApartamento=' + valor
					+ "&data=" +
<%=new java.util.Date().getTime()%>
	, true);

			//getAjaxValue(_url,callbackdetalhe);
		}
	}

	function obterRoomList(valor) {

		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarHospedePorApartamento?OBJ_VALUE='
				+ valor;
		preencherCombo('idHospede', url);

	}

	function callbackdetalhe(valor) {
		eval(valor);
	}

	function marcarTodos(obj) {
		newValue = obj.checked;
		$("input:checkbox[id='despesas']").attr('checked', newValue);
	}

	<s:if test="#session.msgCofan != null && #session.msgCofan != ''">
		alerta("<s:property value='#session.msgCofan' />");
	</s:if>
</script>


<s:form namespace="/app/caixa"
	action="transferenciaDespesa!gravar.action" theme="simple">

	<div class="divFiltroPaiTop">Transferência</div>
	<div class="divFiltroPai">
		<div class="divCadastro" style="overflow: auto;">

			<div class="divGrupo" style="height: 80px;">
				<div class="divGrupoTitulo">Apartamentos</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 210px;">
						<p style="width: 100px;">Origem:</p>
						<s:select list="#session.apartamentoOcupadoOrigemList"
							cssStyle="width:100px" listKey="idApartamento" headerKey=""
							headerValue="Selecione" name="origem.idApartamento"
							id="idApartamentoOrigem" onchange="obterMovimento(this.value)">
						</s:select>
					</div>
					<div class="divItemGrupo" style="width: 210px;">
						<p style="width: 100px;">Destino:</p>
						<s:select list="#session.apartamentoOcupadoDestinoList"
							cssStyle="width:100px" listKey="idApartamento" headerKey=""
							headerValue="Selecione" name="destino.idApartamento"
							id="idApartamentoDestino" onchange="obterRoomList(this.value)">
						</s:select>
					</div>
					<div class="divItemGrupo" style="width: 360px;">
						<p style="width: 100px;">Hóspede:</p>

						<s:select id="idHospede" list="roomList" listKey="id"
							listValue="value" cssStyle="width:250px;" name="idRoomList" />

					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 510px;">
						<p style="width: 100px;">Motivo:</p>
						<s:textfield name="motivo" maxlength="100" size="50" id="motivo"
							onblur="toUpperCase(this)"></s:textfield>
					</div>
				</div>
			</div>

			<div class="divGrupo" style="height: 350px;">
				<div class="divGrupoTitulo">Despesas</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 100%">Lançamento</p>
					</div>
					<div class="divItemGrupo" style="width: 100px; text-align: right;">
						<p style="width: 100%;">Valor</p>
					</div>
					<div class="divItemGrupo" style="width: 160px; text-align: center;">
						<p style="width: 100%">Data/hora</p>
					</div>
					<div class="divItemGrupo" style="width: 170px;">
						<p style="width: 100%">Documento</p>
					</div>
					<div class="divItemGrupo" style="width: 250px;">
						<p style="width: 100%">Hóspede</p>
					</div>
				</div>
				<div id="divMovimento"
					style="width: 99%; height: 220px; overflow-y: auto;">
					<s:iterator
						value="#session.movimentoApartamentoList"
						var="movApto" status="row">
						
						<div class="divLinhaCadastro" style="border:0px;background-color:white;">
							<div class="divItemGrupo" style="width:200px;" >
								<input type="checkbox" name="despesas" id="despesas" value='<s:property value="idMovimentoApartamento" />' />
								<s:property value="tipoLancamentoEJB.descricaoLancamento"/>
							</div>
							
							<div class="divItemGrupo" style="width:100px;text-align:right;" >
								<s:property value="valorLancamento"/>
								&nbsp;
							</div>
							<div class="divItemGrupo" style="width:160px;text-align:center;" >
							
								<s:property value="horaLancamento"/>
								&nbsp;
							</div>
							<div class="divItemGrupo" style="width:170px;" >
								<s:property value="numDocumento"/>
								&nbsp;
							</div>
							<div class="divItemGrupo" style="width:250px;" >
								<s:property value="roomListEJB.hospede.nomeHospede"/>
								&nbsp;
								<s:property value="roomListEJB.hospede.sobrenomeHospede"/>
								&nbsp;
							</div>
						</div>
						
						
					</s:iterator>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 150px;">
						<input type="checkbox" id="todos" onclick="marcarTodos(this)" />-
						TODOS
					</div>
				</div>

			</div>

			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao label="Lançar" imagem="imagens/iconic/png/check-4x.png"
					onClick="gravar()" />
			</div>

		</div>
	</div>
</s:form>