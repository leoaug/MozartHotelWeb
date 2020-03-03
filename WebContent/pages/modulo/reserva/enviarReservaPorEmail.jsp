<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisar!prepararPesquisa.action" namespace="/app/reserva" />';
		submitForm(vForm);
	}

	function enviar() {

		if ($('#emailPara').val() == '') {
			alerta("O campo 'Para' é obrigatório.");
			return false;
		}

		vForm = document.forms[0];
		vForm.emailBody.value = $("div[id='divBody']").html();
		vForm.action = '<s:url action="enviarEmail!enviarEmail.action" namespace="/app/reserva" />';
		submitForm(vForm);

	}

	function imprimirReserva() {

		var printWin = window
				.open(
						"",
						"PopUp",
						',status=yes,resizable=no,location=no,scrollbars=no,width=850,height=500, left=200, top=50');
		printWin.document.open();
		printWin.document.write($("div[id='divBody']").html());
		printWin.document.close();
		printWin.print();
		printWin.close();

	}
</script>



<s:form namespace="/app/reserva"
	action="enviarEmail!prepararEnviarReservaPorEmail.action"
	theme="simple">
	<s:hidden name="emailBody" id="emailBody"></s:hidden>
	<s:hidden name="reservaVO.bcIdReserva"></s:hidden>
	<div class="divFiltroPaiTop">Enviar Reservas</div>
	<div class="divFiltroPai">
		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 460px;">
				<div class="divGrupoTitulo">Confirmação por e-mail</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 350px;">
						<p style="width: 100px;">Para:</p>
						<s:textfield name="emailPara" id="emailPara" maxlength="200"
							size="40" />
					</div>
					<div class="divItemGrupo" style="width: 350px;">
						<p style="width: 100px;">CC:</p>
						<s:textfield name="emailCC" id="emailCC" maxlength="200" size="40" />
					</div>
				</div>

				<div id="divBody" class="divLinhaCadastro"
					style="height: 410px; background-color: white; border: 1px solid black; overflow: auto;">


					<link
						href="http://iasserver.mozart.com.br/ReservaHotel/crshoteis.css"
						rel="stylesheet" type="text/css">
					<meta http-equiv='content-type'
						content='text/html;charset=iso-8859-1' />


					<!-- inicio do corpo do email -->
					<table width="750" border="0" align="center" cellpadding="0"
						cellspacing="0">
						<tr>
							<td>
								<div style="padding: 5px 0px 0px 0px;" class="fs_13 fw_Bold">
									VOUCHER.</div>

								<div style="padding: 0px 0px 0px 20px;">Prezado cliente,
									para sua maior comodidade, aconselhamos imprimir este Voucher
									contendo as informa&ccedil;&otilde;es da sua reserva. Favor
									verificar as margens para assegurar-se de que todo
									conte&uacute;do ser&aacute; impresso.</div>

								<hr>
							</td>
						</tr>

						<!-- Inicio - Linha Informações Hotel, Empresa, Período -->
						<tr>
							<td>
								<!-- Inicio - Corpo Voucher -->
								<div style="padding: 5px 0px 5px 0px;">

									<!-- Inicio - Tabela Dados Hotel -->
									<table width="100%" border="0" align="center" cellpadding="0"
										cellspacing="0">
										<tr>
											<!-- Inicio - Coluna Logomarca -->
											<td width="102"><img width="100px" height="35px;"
												src="<s:property value="#session.HOTEL_SESSION.enderecoLogotipo"/>"
												title="<s:property value="#session.HOTEL_SESSION.nomeFantasia"/>" />
											</td>
											<!-- Fim - Coluna Logomarca -->

											<!-- Inicio - Coluna Dados Hotel(1) -->
											<td valign="top">

												<div style="padding: 0px 10px 0px 10px;">
													<!-- Inicio - Tabela Dados Hotel(1) -->
													<table cellpadding="0" cellspacing="0" border="0">
														<tr>
															<td class="ff_Arial fs_13 fc_Black fw_Bold"><s:property
																	value="#session.HOTEL_SESSION.nomeFantasia" /></td>
														</tr>
														<tr>
															<td>CNPJ: <s:property
																	value="@com.mozart.model.util.MozartUtil@formatCNPJ(#session.HOTEL_SESSION.cgc)" /></td>
														</tr>
														<tr>
															<td><s:property
																	value="#session.HOTEL_SESSION.endereco" />, <s:property
																	value="#session.HOTEL_SESSION.bairro" /></td>
														</tr>
														<tr>
															<td><s:property
																	value="#session.HOTEL_SESSION.cidadeEJB.cidade" /> - <s:property
																	value="#session.HOTEL_SESSION.cidadeEJB.estado.estado" />
																- <s:property
																	value="#session.HOTEL_SESSION.cidadeEJB.estado.pais.pais" />
															</td>
														</tr>
														<tr>
															<td>CEP: <s:property
																	value="@com.mozart.model.util.MozartUtil@formatCEP(#session.HOTEL_SESSION.cep)" />
															</td>
														</tr>
														<tr align="left">
															<td><s:property
																	value="#session.HOTEL_SESSION.site.toLowerCase()" /></td>
														</tr>
													</table>
													<!-- Fim - Tabela Dados Hotel(1) -->
												</div>

											</td>
											<!-- Fim - Coluna Dados Hotel(1) -->

											<!-- Inicio - Coluna Dados Hotel(2) -->
											<td valign="top">

												<div style="padding: 0px 10px 0px 10px;">
													<!-- Inicio - Tabela Dados Hotel(2) -->
													<table cellpadding="0" cellspacing="0" border="0">
														<tr>
															<td class="ff_Arial fs_13 fc_Black fw_Bold">Data da
																Reserva: <s:property value="reservaVO.bcDataReserva" />
															</td>
														</tr>
														<tr>
															<td>&nbsp;</td>
														</tr>
														<tr>
															<td>Toll-Free:<s:property
																	value="#session.HOTEL_SESSION.tollFree" /></td>
														</tr>
														<tr>
															<td>Telefone: <s:property
																	value="#session.HOTEL_SESSION.telefone" />
															</td>
														</tr>
														<tr>
															<td>Fax: <s:property
																	value="#session.HOTEL_SESSION.fax" />
															</td>
														</tr>
														<tr>
															<td>E-mail: <s:property
																	value="#session.HOTEL_SESSION.email.toLowerCase()" />
															</td>
														</tr>
													</table>
													<!-- Fim - Tabela Dados Hotel(2) -->
												</div>

											</td>
											<!-- Fim - Coluna Dados Hotel(2) -->

											<!-- Inicio - Coluna Dados CRS -->
											<td valign="top">

												<div style="padding: 0px 10px 0px 10px;"></div>

											</td>
											<!-- Fim - Coluna Dados CRS -->
										</tr>
									</table>
									<!-- Fim - Tabela Dados Hotel -->

									<hr>

									<!-- Inicio - Tabela Responsavel Pela Reserva -->
									<table border="0" cellpadding="0" cellspacing="0">
										<tr>
											<!-- Inicio - Coluna Empresa e Responsavel -->
											<td valign="top">

												<div style="padding: 0px 10px 0px 10px;">
													<!-- Inicio - Tabela Empresa e Responsavel -->
													<table cellpadding="0" cellspacing="0" border="0">
														<tr>
															<td>Empresa:</td>
															<td>
																<div style="padding: 0px 40px 0px 10px;">
																	<s:property
																		value="reservaVO.empresaHotelVO.bcNomeFantasia" />
																</div>
															</td>
														</tr>
														<tr>
															<td>Contato:</td>
															<td>
																<div style="padding: 0px 40px 0px 10px;">
																	<s:property value="reservaVO.bcContato" />
																</div>
															</td>
														</tr>
														<tr>
															<td>E-mail:</td>
															<td>
																<div style="padding: 0px 40px 0px 10px;">
																	<s:property
																		value="reservaVO.bcEmailContato.toLowerCase()" />
																</div>
															</td>
														</tr>




													</table>
													<!-- Fim - Tabela Empresa e Responsavel -->
												</div>

											</td>
											<!-- Fim - Coluna Empresa e Responsavel -->

											<!-- Inicio - Coluna Periodo -->
											<td valign="top">

												<div style="padding: 0px 10px 0px 10px;">
													<!-- Inicio - Tabela Empresa e Responsavel -->
													<table cellpadding="0" cellspacing="0" border="0">
														<tr>
															<td colspan="2"><span class="fw_Bold">Per&iacute;odo:</span>
															</td>
														</tr>
														<tr>
															<td>Data de Entrada:</td>
															<td>
																<div style="padding: 0px 10px 0px 10px;">
																	<s:property value="reservaVO.bcDataEntrada" />
																</div>
															</td>
														</tr>
														<tr>
															<td>Data de Sa&iacute;da:</td>
															<td>
																<div style="padding: 0px 10px 0px 10px;">
																	<s:property value="reservaVO.bcDataSaida" />
																</div>
															</td>
														</tr>
														<tr>
															<td>Prazo cancelamento:</td>
															<td>
																<div style="padding: 0px 10px 0px 10px;">
																	<s:property value="reservaVO.bcDataConfirmaBloqueio" />
																</div>
															</td>
														</tr>
													</table>
													<!-- Fim - Tabela Empresa e Responsavel -->
												</div>

											</td>
											<!-- Fim - Coluna Periodo -->
										</tr>
									</table>
									<!-- Fim - Tabela Responsavel Pela Reserva -->

								</div> <!-- Fim - Corpo Voucher -->

							</td>
						</tr>
						<!-- Fim - Linha Informações Hotel, Empresa, Período -->

						<!-- Inicio - Linha Informações Hotel, Empresa, Período -->
						<tr>
							<td>
								<!-- Separador -->
								<div style="padding-top: 5px;"></div> <!-- Separador --> <!-- Inicio - Corpo Voucher -->
								<div style="padding: 5px 0px 5px 0px;">

									<!-- Inicio - Tabela Localizador -->
									<table width="100%" align="center" cellpadding="0"
										cellspacing="0" border="0">
										<tr>
											<td>
												<div style="padding-left: 10px;" class="fs_13 fw_Bold">
													Localizador:
													<s:property value="reservaVO.bcIdReserva" />
												</div>
											</td>
										</tr>
									</table>
									<!-- Fim - Tabela Localizador -->

									<div style="padding: 0px 10px 0px 10px;"></div>


									<!-- Inicio - Tabela Informações Reserva(1) -->
									<div style="padding: 0px 10px 0px 10px;">
										<table width="100%" align="center" cellpadding="0"
											cellspacing="0" border="0">
											<tr>
												<td valign="top">
													<!-- Inicio - Tabela Hospedes -->
													<table cellpadding="0" cellspacing="1" border="0"
														class="edit_bg_nivel_1">
														<tr>
															<td class="edit_bg_nivel_6">
																<div style="padding: 2px 5px 2px 5px;" class="fw_Bold">
																	Hóspede(s)</div>
															</td>
															<td class="edit_bg_nivel_6">
																<div style="padding: 2px 5px 2px 5px;" class="fw_Bold">
																	Tipo Hóspede</div>
															</td>
															<td class="edit_bg_nivel_6">
																<div style="padding: 2px 5px 2px 5px;" class="fw_Bold">
																	Tipo Apto</div>
															</td>
															<td class="edit_bg_nivel_6">
																<div style="padding: 2px 5px 2px 5px;" class="fw_Bold">
																	Apto</div>
															</td>
															<td class="edit_bg_nivel_6">
																<div style="padding: 2px 5px 2px 5px;" class="fw_Bold">
																	Período</div>
															</td>
															<td class="edit_bg_nivel_6" align="center">
																<div style="padding: 2px 5px 2px 5px;" class="fw_Bold">
																	Pax</div>
															</td>
															<td class="edit_bg_nivel_6" align="center">
																<div style="padding: 2px 5px 2px 5px;" class="fw_Bold">
																	Child-Free</div>
															</td>
															<td class="edit_bg_nivel_6" align="center">
																<div style="padding: 2px 5px 2px 5px;" class="fw_Bold">
																	Adic.</div>
															</td>
															<td class="edit_bg_nivel_6" align="center">
																<div style="padding: 2px 5px 2px 5px;" class="fw_Bold">
																	Qtde Apto</div>
															</td>
														</tr>

														<s:set name="idResApto" value="%{null}" />

														<s:set name="qtdeSeguro" value="%{0}" />

														<s:iterator value="reservaVO.listReservaApartamento"
															var="obj" status="row">
															<s:if
																test="%{somenteReservaApartamento=='' || somenteReservaApartamento == bcIdReservaApartamento}">

																<s:if
																	test="%{#idResApto==null || idResApto != bcIdReservaApartamento}">
																	<s:set name="qtdeSeguro"
																		value="#qtdeSeguro + (#obj.bcQtdePax * #obj.bcQtdeApartamento * (@com.mozart.model.util.MozartUtil@getDiferencaDia(#obj.bcDataEntrada, #obj.bcDataSaida)==0?1:@com.mozart.model.util.MozartUtil@getDiferencaDia(#obj.bcDataEntrada, #obj.bcDataSaida)))" />
																</s:if>
																<s:set name="idResApto"
																	value="%{#obj.bcIdReservaApartamento}" />

																<s:iterator value="listRoomList" var="hosp"
																	status="rowHosp">
																	<s:if
																		test='%{bcPrincipal == "S"}'>
																		<tr>
																			<td class="edit_bg_nivel_6"><s:property
																					value="bcIdReservaApartamento" /> - <s:property
																					value="bcNomeHospede" /> <s:property
																					value="bcSobenomeHospede" /></td>
																			<td class="edit_bg_nivel_6"><s:property
																					value="bcTipoHospede" /></td>
																			<td class="edit_bg_nivel_6"><s:property
																					value="bcTipoApartamentoDesc" /></td>
																			<td class="edit_bg_nivel_6"><s:property
																					value="bcApartamentoDesc" /></td>
																			<td class="edit_bg_nivel_6"><s:property
																					value="bcDataEntrada" />-<s:property
																					value="bcDataSaida" /></td>
																			<td class="edit_bg_nivel_6" align="center"><s:property
																					value="bcQtdePax" /></td>
																			<td class="edit_bg_nivel_6" align="center"><s:property
																					value="bcQtdeCrianca" /></td>
																			<td class="edit_bg_nivel_6" align="center"><s:property
																					value="bcAdicional" /></td>
																			<td class="edit_bg_nivel_6" align="center"><s:property
																					value="bcQtdeApartamento" /></td>
																		</tr>

																	</s:if>
																</s:iterator>
															</s:if>
														</s:iterator>
													</table> <!-- Inicio - Tabela Hospedes -->
												</td>
											</tr>
										</table>
									</div>
									<!-- Fim - Tabela Informações Reserva(1) -->

								</div> <!-- Separador -->
								<div style="padding-top: 5px;"></div> <!-- Separador --> <!-- Inicio - Corpo Voucher -->
								<div style="padding: 5px 0px 5px 0px;">

									<!-- Inicio - Tabela Titulo -->
									<table width="100%" align="center" cellpadding="0"
										cellspacing="0" border="0">
										<tr>
											<td>
												<div style="padding-left: 10px;" class="fs_13 fw_Bold">
													Informa&ccedil;&otilde;es Adicionais</div>
											</td>
										</tr>
									</table>
									<!-- Fim - Tabela Titulo -->

									<!-- Inicio - Tabela Informações Reserva(2) -->
									<div style="padding: 0px 10px 0px 10px;">
										<table width="100%" align="center" cellpadding="0"
											cellspacing="0" border="0">
											<tr>
												<!-- Inicio - Coluna Esquerda -->
												<td valign="top" align="center">

													<div style="padding-right: 10px;">
														<!-- Inicio - Tabela Pagamento -->
														<table width="100%" cellpadding="0" cellspacing="1"
															border="0" class="edit_bg_nivel_1">
															<tr>
																<td class="edit_bg_nivel_6">
																	<div style="padding: 2px 5px 2px 5px;">
																		Forma&nbsp;de&nbsp;Pagamento:</div>
																</td>
																<td align="center" class="edit_bg_nivel_6">
																	<div style="padding: 2px 5px 2px 5px;">
																		<s:iterator value="reservaVO.listPagamento" var="obj"
																			status="row">
																			<s:property
																				value='bcFormaPg=="F"?"Faturado":bcFormaPg=="A"?"Antecipado":"Direto"' />
																			<br />
																		</s:iterator>
																	</div>
																</td>
															</tr>
															<tr>
																<td class="edit_bg_nivel_6">
																	<div style="padding: 2px 5px 2px 5px;">Forma de
																		Reserva:</div>
																</td>
																<td class="edit_bg_nivel_6" align="center">
																	<div style="padding: 2px 5px 2px 5px;">
																		<s:property value="reservaVO.bcFormaReserva" />
																	</div>
																</td>
															</tr>
															<tr>
																<td class="edit_bg_nivel_6">
																	<div style="padding: 2px 5px 2px 5px;">Tipo de
																		Pens&atilde;o:</div>
																</td>
																<td class="edit_bg_nivel_6" align="center">
																	<div style="padding: 2px 5px 2px 5px;">
																		<s:property
																			value="reservaVO.bcTipoPensao==\"SIM\"?\"Com café\":reservaVO.bcTipoPensao==\"NAO\"?\"Sem Café\":reservaVO.bcTipoPensao" />
																	</div>
																</td>
															</tr>
															<tr>
																<td class="edit_bg_nivel_6">
																	<div style="padding: 2px 5px 2px 5px;">Status
																		Reserva:</div>
																</td>
																<td class="edit_bg_nivel_6" align="center">
																	<div style="padding: 2px 5px 2px 5px;">
																		<s:property
																			value='reservaVO.bcConfirma=="S"?"Confirmada":"Não confirmada"' />
																	</div>
																</td>
															</tr>
															<tr>
																<td class="edit_bg_nivel_6">
																	<div style="padding: 2px 5px 2px 5px;">Moeda
																		Corrente:</div>
																</td>
																<td class="edit_bg_nivel_6" align="center">
																	<div style="padding: 2px 5px 2px 5px;">Real</div>
																</td>
															</tr>
															<tr>
																<td class="edit_bg_nivel_6">
																	<div style="padding: 2px 5px 2px 5px;">Garante
																		no show?</div>
																</td>
																<td class="edit_bg_nivel_6" align="center">
																	<div style="padding: 2px 5px 2px 5px;">
																		<s:property
																			value='reservaVO.bcGaranteNoShow=="S"?"Sim":"Não"' />
																	</div>
																</td>
															</tr>

														</table>
														<!-- Inicio - Tabela Pagamento -->

														<!-- Separador -->
														<div style="padding-top: 5px;"></div>
														<!-- Separador -->
														<s:set name="total" value="%{reservaVO.valorTotalReserva}" />
														<s:set name="totalReserva"
															value="%{reservaVO.valorTotalReserva}" />
														<!-- Inicio - Tabela Valores -->
														<table width="100%" cellpadding="0" cellspacing="1"
															border="0" class="edit_bg_nivel_1">
															<tr>
																<td class="edit_bg_nivel_6">
																	<div style="padding: 2px 5px 2px 5px;">Valor da
																		Reserva:</div>
																</td>
																<td class="edit_bg_nivel_6" align="right">
																	<div style="padding: 2px 5px 2px 5px;">
																		R$
																		<s:property value="%{#totalReserva}" />
																	</div>
																</td>
															</tr>

															<s:if test='%{reservaVO.bcCalculaIss=="S"}'>
																<tr>
																	<td class="edit_bg_nivel_6">
																		<div style="padding: 2px 5px 2px 5px;">Valor do
																			ISS:</div>
																	</td>
																	<td class="edit_bg_nivel_6" align="right">
																		<div style="padding: 2px 5px 2px 5px;">
																			R$
																			<s:property
																				value='#session.HOTEL_SESSION.iss.doubleValue()/100*reservaVO.valorTotalReserva' />
																		</div>
																	</td>
																</tr>
																<s:set name="totalReserva"
																	value="%{#totalReserva + (#session.HOTEL_SESSION.iss.doubleValue()/100*#total)}" />
															</s:if>
															<s:if test='%{reservaVO.bcCalculaRoomTax=="S"}'>
																<tr>
																	<td class="edit_bg_nivel_6">
																		<div style="padding: 2px 5px 2px 5px;">Room
																			Tax:</div>
																	</td>
																	<td class="edit_bg_nivel_6" align="right">
																		<div style="padding: 2px 5px 2px 5px;">
																			R$
																			<s:property
																				value='#session.HOTEL_SESSION.roomtax.doubleValue() * #qtdeSeguro' />
																		</div>
																	</td>
																</tr>
																<s:set name="totalReserva"
																	value="%{#totalReserva + (#session.HOTEL_SESSION.roomtax.doubleValue() * #qtdeSeguro)}" />
															</s:if>
															<s:if test='%{reservaVO.bcCalculaTaxa=="S"}'>
																<tr>
																	<td class="edit_bg_nivel_6">
																		<div style="padding: 2px 5px 2px 5px;">Taxa de
																			Servi&ccedil;o:</div>
																	</td>
																	<td class="edit_bg_nivel_6" align="right">
																		<div style="padding: 2px 5px 2px 5px;">
																			R$
																			<s:property
																				value='#session.HOTEL_SESSION.taxaServico.doubleValue()/100*reservaVO.valorTotalReserva' />
																		</div>
																	</td>
																</tr>
																<s:set name="totalReserva"
																	value="%{#totalReserva + (#session.HOTEL_SESSION.taxaServico.doubleValue()/100*#total)}" />
															</s:if>
															<s:if
																test='%{#session.HOTEL_SESSION.seguro.doubleValue() > 0.0 && reservaVO.bcCalculaSeguro=="S"}'>
																<tr>
																	<td class="edit_bg_nivel_6">
																		<div style="padding: 2px 5px 2px 5px;">Seguro:
																		</div>
																	</td>
																	<td class="edit_bg_nivel_6" align="right">
																		<div style="padding: 2px 5px 2px 5px;">
																			R$
																			<s:property
																				value='#session.HOTEL_SESSION.seguro.doubleValue() * #qtdeSeguro' />
																		</div>
																	</td>
																</tr>
																<s:set name="totalReserva"
																	value="%{#totalReserva + (#session.HOTEL_SESSION.seguro.doubleValue() * #qtdeSeguro)}" />
															</s:if>

															<!--
                                        <tr>
					  <td class="edit_bg_nivel_6" > <div style="padding: 2px 5px 2px 5px; " > Seguro: </div> </td>
					  <td class="edit_bg_nivel_6" align="right" > <div style="padding: 2px 5px 2px 5px; " > R$ 0,00 </div> </td>
					</tr>
                                        -->
															<tr>
																<td class="edit_bg_nivel_6">
																	<div style="padding: 2px 5px 2px 5px;" class="fw_Bold">
																		Valor Total:</div>
																</td>
																<td class="edit_bg_nivel_6" align="right">
																	<div style="padding: 2px 5px 2px 5px;" class="fw_Bold">
																		R$
																		<s:property value="%{#totalReserva}" />
																	</div>
																</td>
															</tr>
														</table>
														<!-- Fim - Tabela Valores -->
													</div>

												</td>
												<!-- Fim - Coluna Esquerda -->

												<!-- Inicio - Coluna Direita -->
												<td valign="top">
													<!-- Inicio - Tabela Observações -->
													<table cellpadding="0" cellspacing="1" border="0">
														<tr>
															<td>
																<div style="padding: 0px 5px 0px 5px;" class="fw_Bold">&nbsp;&nbsp;&nbsp;
																	Considera&ccedil;&otilde;es Gerais:</div>
															</td>
														</tr>

														<tr>
															<td>
																<div style="padding: 0px 5px 0px 5px;" align="justify">
																	<s:if
																		test='%{#session.HOTEL_SESSION.reservaCondicoesEJB != null}'>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha1 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha1" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha2 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha2" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha3 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha3" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha4 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha4" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha5 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha5" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha6 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha6" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha7 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha7" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha8 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha8" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha9 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha9" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha10 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha10" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha11 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha11" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha12 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha12" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha13 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha13" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha14 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha14" />
																			<br />
																		</s:if>
																		<s:if
																			test='%{#session.HOTEL_SESSION.reservaCondicoesEJB.linha15 != null}'>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<s:property
																				value="#session.HOTEL_SESSION.reservaCondicoesEJB.linha15" />
																			<br />
																		</s:if>
																	</s:if>
																</div>
															</td>
														</tr>

														<tr>
															<td>
																<div style="padding: 10px 5px 0px 5px;" class="fw_Bold">
																	&nbsp;&nbsp;&nbsp;&nbsp;Observa&ccedil;ão:</div>
															</td>
														</tr>

														<tr>
															<td>
																<div style="padding: 0px 10px 0px 5px;" align="justify">
																	&nbsp;&nbsp;&nbsp;&nbsp;
																	<s:property value="reservaVO.bcObservacaoVoucher" />
																</div>
															</td>
														</tr>
														<tr>
															<td>
																<div style="padding: 10px 5px 0px 5px;" class="fw_Bold">
																	&nbsp;&nbsp;&nbsp;&nbsp;Em caso de Pagamento por Boleto
																	Banc&aacute;rio:</div>
															</td>
														</tr>

														<tr>
															<td>
																<div style="padding: 0px 10px 0px 5px;" align="justify">
																	&nbsp;&nbsp;&nbsp;&nbsp;Sua reserva somente ser&aacute;
																	confirmada mediante comprova&ccedil;&atilde;o do
																	pagamento. <br>&nbsp;&nbsp;&nbsp;&nbsp;Confirme o
																	pagamento atrav&eacute;s de um dos nossos canais de
																	comunica&ccedil;&atilde;o.
																</div>
															</td>
														</tr>
													</table> <!-- Fim - Tabela Observações -->

												</td>
												<!-- Fim - Coluna Direita -->
											</tr>
										</table>
									</div>
									<!-- Fim - Tabela Informações Reserva(2) -->

								</div>


								<div style="padding: 5px 0px 5px 0px;">
									<!-- Inicio - Tabela Localizador -->
									<table width="100%" height="18" align="center" cellpadding="0"
										cellspacing="0" border="0" class="edit_bg_nivel_6">
										<tr>
											<td>
												<div style="padding-left: 10px;">
													<a href="http://www.mozart.com.br/" target="_blank"
														class="fc_Black fw_Bold "> Este &eacute; um
														servi&ccedil;o oferecido pela &reg; Mozart Systems. &copy;
														1998-2010 Mozart Systems, todos os direitos reservados. </a>
												</div>
											</td>
										</tr>
									</table>
									<!-- Fim - Tabela Localizador -->
								</div>

							</td>
						</tr>
						<!-- Fim - Linha Informações Hotel, Empresa, Período -->

					</table>

					<!--  final do corpo do email-->
				</div>

			</div>



			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar();" />
				<duques:botao label="Enviar" imagem="imagens/iconEmail.png"
					onClick="enviar();" />
				<duques:botao label="Imprimir" imagem="imagens/iconic/png/print-3x.png"
					onClick="imprimirReserva();" />

			</div>


		</div>
	</div>
</s:form>