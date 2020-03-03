<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisar!prepararPesquisa.action" namespace="/app/checkin" />';
		submitForm(vForm);
	}

	var reportAddress = '';
	function imprimir() {

		var idRel = $("input[name='TIPO']:checked").val();
		reportAddress = '<s:property value="#session.URL_REPORT"/>';
		if (1 == idRel) {
			if ($('#dataInicial').val() == '' || $('#dataFinal').val() == '') {
				alerta("O campo 'Período' é obrigatório.");
				return false;
			}
			reportAddress += '/index.jsp?REPORT=ckHospedeSeguradoReport';
			params = 'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
			params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
			params += ';P_DATA@01/' + $('#dataInicial').val();
			params += ';P_DATA_FIM@01/' + $('#dataFinal').val();
			reportAddress += '&PARAMS=' + params;
			showPopupGrande(reportAddress);

		}else if (2 == idRel) {
			if ($('#dataInicialHospede').val() == '' || $('#dataFinalHospede').val() == '') {
				alerta("O campo 'Período' é obrigatório.");
				return false;
			}
			reportAddress += '/index.jsp?REPORT=fnrhReport';
			params = 'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
			params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
			params += ';P_RESERVA@' + $('#hospede').val();
			params += ';P_DATA1@' + $('#dataInicialHospede').val();
			params += ';P_DATA2@' + $('#dataFinalHospede').val();
			reportAddress += '&PARAMS=' + params;
			showPopupGrande(reportAddress);

		}

	}

	function carregarHospedes(){

		if ($('#dataInicialHospede').val() == '' || $('#dataFinalHospede').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}

		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarHospedeFNRH?&dataInicial='+$('#dataInicialHospede').val()+'&dataFinal='+$('#dataFinalHospede').val();
		preencherCombo('hospede', url);        
		
	}
	
	$(document).ready(function() {
		$(".radioTipo").click(function() {
			$('#divDataFinal').css('display', 'block');
			$('#divPeriodo').css('display', 'none');
			$('#divHospede').css('display', 'none');
			$('#divPeriodoHospede').css('display', 'none');
			if (this.value == '1') {
				$('#divPeriodo').css('display', 'block');
			}else if (this.value == '2') {
				$('#divPeriodoHospede').css('display', 'block');
				$('#divHospede').css('display', 'block');
				carregarHospedes();

			}
		});

	})
</script>

<s:form action="pesquisar!pesquisar.action" namespace="/app/checkin"
	theme="simple">
	<div class="divFiltroPaiTop">Checkin</div>
	<div class="divFiltroPai">
		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 400px;">
				<div class="divGrupoTitulo">Tipos de relatório</div>

				<div class="divLinhaCadastro"
					style="height: 180px; border: 1px solid black;">

					<div class="divItemGrupo" style="width: 250px; color: blue;">
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO"
							value="1" checked="checked" />Seguro<br />
							<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="2"  />FNRH<br />
					</div>
					<div class="divItemGrupo" style="width: 250px; color: blue;">
					</div>
				</div>


				<div class="divLinhaCadastro" id="divPeriodo">
					<div class="divItemGrupo" style="width: 180px;">
						<p style="width: 80px;">Período:</p>
						<input class="dpFMT"
							value='<s:property value="@com.mozart.model.util.MozartUtil@format(#session.CONTROLA_DATA_SESSION.frontOffice).substring(3)"/>'
							type="text" name="dataInicial" onblur="dataValida(this);"
							onkeypress="mascara(this,mesano);" id="dataInicial" size="8"
							maxlength="7" onchange="verificaRelatorio()" />
					</div>
					<div class="divItemGrupo" id="divDataFinal" style="display: block">
						à <input class="dpFMT"
							value='<s:property value="@com.mozart.model.util.MozartUtil@format(#session.CONTROLA_DATA_SESSION.frontOffice).substring(3)"/>'
							type="text" name="dataFinal" onblur="dataValida(this);"
							onkeypress="mascara(this,mesano);" id="dataFinal" size="8"
							maxlength="7" />
					</div>
				</div>
				
				<div class="divLinhaCadastro" id="divPeriodoHospede" style="display: none">
					<div class="divItemGrupo" style="width: 180px;">
						<p style="width: 80px;">Período:</p>
						<input class="dp"
							value='<s:property value="@com.mozart.model.util.MozartUtil@format(#session.CONTROLA_DATA_SESSION.frontOffice)"/>'
							type="text" name="dataInicialHospede" onblur="dataValida(this); carregarHospedes();"
							onkeypress="mascara(this,data);" id="dataInicialHospede" size="8"
							maxlength="10" onchange="verificaRelatorio()" />
					</div>
					<div class="divItemGrupo" id="divDataFinal" style="display: block">
						à <input class="dp"
							value='<s:property value="@com.mozart.model.util.MozartUtil@format(#session.CONTROLA_DATA_SESSION.frontOffice)"/>'
							type="text" name="dataFinalHospede" onblur="dataValida(this); carregarHospedes();"
							onkeypress="mascara(this,data);" id="dataFinalHospede" size="8"
							maxlength="10" />
					</div>
				</div>
				<div class="divLinhaCadastro" id="divHospede" style="display: none;">

					<div class="divItemGrupo" style="width: 300px;">
						<p style="width: 80px;">Hóspede:</p>
						<select name="hospede" id="hospede" style="width:150px;">
							</select>

					</div>

				</div>

			</div>


			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao label="Imprimir" imagem="imagens/iconic/png/print-3x.png"
					onClick="imprimir()" />
			</div>

		</div>
	</div>

</s:form>