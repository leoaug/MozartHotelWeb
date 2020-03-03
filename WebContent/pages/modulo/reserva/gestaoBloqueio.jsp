<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	function getBloqueio() {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarBloqueio?'
				+ 'OBJ_NAME='
				+ document.getElementById('reservaBloqueioVO.bloqueio').name
				+ '&OBJ_HIDDEN=reservaVO.bcIdReservaBloqueio' + '&OBJ_VALUE='
				+ document.getElementById('reservaBloqueioVO.bloqueio').value;
		getDataLookup(document.getElementById('reservaBloqueioVO.bloqueio'),
				url, 'Bloqueio', 'TABLE');
	}

	function consultarTarifasEApartamentos() {
		idBloqueio = document.getElementById('reservaVO.bcIdReservaBloqueio').value;
		submitFormAjax(
				'consultarTarifasEApartamentos?idBloqueio=' + idBloqueio, true);
	}
</script>


<s:form namespace="/app/reserva"
	action="manterMapa!pesquisarMapa.action" theme="simple">
	<s:hidden id="origemCrs" name="origemCrs" />
	<s:hidden id="reservaVO.bcIdReservaBloqueio"
		name="reservaVO.bcIdReservaBloqueio" />

	<div class="divFiltroPaiTop">Gestão do bloqueio</div>
	<div class="divFiltroPai">
		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 157px;">
				<div class="divGrupoTitulo">Filtro de pesquisa</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 500px;">
						<p style="width: 100px;">Bloqueio:</p>
						<s:textfield onblur="getBloqueio();"
							id="reservaBloqueioVO.bloqueio" name="reservaBloqueioVO.bloqueio"
							size="50" maxlength="50" />
					</div>
				</div>

				<iframe width="100%" height="105" id="idGestaoBloqueioCabecalho" scrolling="no" 
						frameborder="0" marginheight="0" marginwidth="0" 
						src="<s:url value="app/reserva/include!prepararCabecalhoGestaoBloqueio.action"/>">
				</iframe>
			</div>

			<div class="divGrupo" style="height: 390px;">
				<div class="divGrupoTitulo">Gestão do Bloqueio</div>
				<div id="divMovimento"
					style="width: 99%; height: 360px; overflow-y: auto; margin: 0px; padding: 0px; background-color: white;">
					<iframe width="100%" height="115" id="idGestaoBloqueioTarifas" scrolling="no" 
						frameborder="0" marginheight="0" marginwidth="0" 
						src="<s:url value="app/reserva/include!prepararTarifasGestaoBloqueio.action"/>">
					</iframe>
					<iframe width="100%" height="115" id="idGestaoBloqueioQtde" scrolling="no" 
						frameborder="0" marginheight="0" marginwidth="0" 
						src="<s:url value="app/reserva/include!prepararQtdeGestaoBloqueio.action"/>">
					</iframe>
				</div>
			</div>
		</div>
	</div>
	<div class="divCadastroBotoes">
		<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
			onClick="cancelar();" />
	</div>
	</div>
	</div>
</s:form>