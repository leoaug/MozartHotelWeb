<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">


	function init() {

	}

	function abrirHospede(indice) {
		showModal('#divHospedeModal', 200, 600);
	}

	function abrirReserva(obj, idReserva) {
		if (obj != '') {
			$('div.divResConfChkFst').css('background-color', '');
			$("div.divResConfChkFst[id='" + obj + "']").css('background-color',
					'rgb(231,231,231)');
		}
		document.getElementById('idChkFstFrame').contentWindow
				.abrirReserva(idReserva);
	}

	function gravarCheckin() {
		document.getElementById('idChkFstFrame').contentWindow
				.gravarCheckin(-1);

	}
	function cancelarCheckinFast() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisar!prepararPesquisa.action" namespace="/app/checkin" />';
		submitForm(vForm);

	}

	function filtrar(valor) {
		$('div.divResConfChkFst').css('display', 'none');
		$("div.divResConfChkFst[id*='" + valor + ";']").css('display', 'block');
	}

	function atualizar() {
		submitForm(document.forms[0]);
	}

	function mensagemFromIFrame(msg) {
		killModal();
		alerta(msg);
	}

	function caixaGeral() {
		loading();
		window.location.href = '<s:url action="caixaGeral!preparar.action" namespace="/app/caixa" />'

	}
</script>


<div style="display: none"><%=new java.util.Date()%></div>

<s:form namespace="/app/checkin"
	action="manterFast!preparaManterFast.action" theme="simple">

	<input type="hidden" name="id" />
	<input type="hidden" name="idEmpresa" id="idEmpresa" />


	<div class="divFiltroPaiTop">Check-in FAST</div>
	<div id="divFiltroPai" class="divFiltroPai">
		<div id="divFiltro" class="divCadastro" style="height: 550px;">
			<!--Início dados do filtro-->
			<div class="divGrupo" style="height: 50px">
				<div class="divGrupoTitulo">Filtros</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 230px;">
						<p style="width: 70px;">Reserva:</p>
						<s:select list="listaReservaCombo" cssStyle="width:150px;"
							onchange="filtrar(this.value)" headerValue=".:Todos:."
							headerKey="" /> 
					</div>

					<div class="divItemGrupo" style="width: 230px;">
						<p style="width: 70px;">Hóspedes:</p>
						<s:select list="listaHospedeCombo" cssStyle="width:150px;"
							onchange="filtrar(this.value)" headerValue=".:Todos:."
							headerKey="" />

					</div>

					<div class="divItemGrupo" style="width: 230px;">
						<p style="width: 70px;">Grupo:</p>
						<s:select list="listaGrupoCombo" cssStyle="width:150px;"
							onchange="filtrar(this.value)" headerValue=".:Todos:."
							headerKey="" />
					</div>

					<div class="divItemGrupo" style="width: 230px;">
						<p style="width: 70px;">Empresa:</p>
						<s:select list="listaEmpresaCombo" cssStyle="width:150px;"
							onchange="filtrar(this.value)" headerValue=".:Todos:."
							headerKey="" />
					</div>
				</div>


			</div>
			<!--Fim dados do filtro -->
			<!--Início dados da reserva -->
			<div class="divGrupo" style="width: 99%; height: 100px">
				<div class="divGrupoTitulo">Reservas confirmadas do dia</div>
				<div class="divGrupoBody" style="height: 80px">
					<s:iterator value="#session.listaReservaDia" var="corrente"
						status="row">


						<s:if test="#row.count == 1">
							<%
								request.setAttribute("abrirReserva", "sim");
							%>
							<div class="divResConfChkFst"
								style="background-color: rgb(231, 231, 231);"
								id="<s:property value="idReserva" />;<s:property value="nomeHospede" />;<s:property value="nomeGrupo" />;<s:property value="nomeFantasia" />;">
								<ul>
									<li style="text-align: center; width: 30px;"><img
										src="imagens/checkin.png" title="Realizar checkin"
										width="23px" height="22px"
										onclick="abrirReserva('<s:property value="idReserva" />;<s:property value="nomeHospede" />;<s:property value="nomeGrupo" />;<s:property value="nomeFantasia" />;', '${row.index}');"></li>
									<li style="width: 120px;">
										<p>Reserva:</p> <s:property value="idReserva" />
									</li>
									<li style="width: 350px;">
										<p>Hóspede:</p> <s:property value="nomeHospede" />
									</li>
									<li style="width: 180px;">
										<p>Grupo:</p> <s:property value="nomeGrupo" />
									</li>
									<li style="width: 450px;">
										<p>Empresa:</p> <s:property value="nomeFantasia" />
									</li>
								</ul>
							</div>


						</s:if>
						<s:else>

							<div class="divResConfChkFst"
								id="<s:property value="idReserva" />;<s:property value="nomeHospede" />;<s:property value="nomeGrupo" />;<s:property value="nomeFantasia" />;">
								<ul>
									<li style="text-align: center; width: 30px;"><img
										src="imagens/checkin.png" title="Realizar checkin"
										width="23px" height="22px"
										onclick="abrirReserva('<s:property value="idReserva" />;<s:property value="nomeHospede" />;<s:property value="nomeGrupo" />;<s:property value="nomeFantasia" />;', '${row.index}');"></li>
									<li style="width: 120px;">
										<p>Reserva:</p> <s:property value="idReserva" />
									</li>
									<li style="width: 350px;">
										<p>Hóspede:</p> <s:property value="nomeHospede" />
									</li>
									<li style="width: 180px;">
										<p>Grupo:</p> <s:property value="nomeGrupo" />
									</li>
									<li style="width: 450px;">
										<p>Empresa:</p> <s:property value="nomeFantasia" />
									</li>
								</ul>
							</div>

						</s:else>

					</s:iterator>
				</div>
			</div>
			<!--Fim dados da reserva -->
			<!--Inicio dados hospedes-->
			<div class="divGrupo" style="width: 99%; height: 290px">
				<div class="divGrupoTitulo">Dados do apartamento</div>
				<iframe width="100%" height="260" id="idChkFstFrame" scrolling="no"
					frameborder="0" marginheight="0" marginwidth="0"
					src="<s:url value="app/checkin/include!prepararCheckinHospede.action"/>?time=<%=new java.util.Date()%>"></iframe>
			</div>
			<!--Fim dados hospedes-->
			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelarCheckinFast()" />
				<duques:botao label="Caixa Geral" imagem="imagens/btnCaixa.png"
					style="width:120px;" onClick="caixaGeral();" />
				<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
					onClick="gravarCheckin()" />
			</div>
		</div>
	</div>

</s:form>

<s:if test="#request.abrirReserva != ''">
	<script>
		//setTimeout("abrirReserva('', '0')",2000)
	</script>
</s:if>
