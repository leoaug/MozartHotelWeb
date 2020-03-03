<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<jsp:scriptlet>String base = request
					.getRequestURL()
					.toString()
					.substring(
							0,
							request.getRequestURL().toString()
									.indexOf(request.getContextPath())
									+ request.getContextPath().length() + 1);
			session.setAttribute("URL_BASE", base);
			response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
			response.setHeader("Cache-Control",
					"no-store, no-cache, must-revalidate");
			response.addHeader("Cache-Control", "post-check=0, pre-check=0");
			response.setHeader("Pragma", "no-cache");</jsp:scriptlet>

<html>
<head>
<base href="<%=base%>" />
<jsp:include page="/pages/modulo/includes/headPage.jsp" />
<script type="text/javascript">
	function atualizar() {
		loading();
		document.getElementById('bcDataEntrada').value = parent.document.getElementById('bcDataEntrada').value;
		document.getElementById('bcDataSaida').value = parent.document.getElementById('bcDataSaida').value;

		document.forms[0].action = '<s:url value="app/bloqueio/include!prepararQtdeGestaoBloqueio.action"/>';
		document.forms[0].submit();
	}
	function editarQuantidade(indice) {
		document.getElementById('divLinhaCadastroEdit' + indice).style.display = 'block';
		document.getElementById('divLinhaCadastroView' + indice).style.display = 'none';
	}
	function atualizarQuantidade(indice, key) {
		document.getElementById('divLinhaCadastroEdit' + indice).style.display = 'none';
		document.getElementById('divLinhaCadastroView' + indice).style.display = 'block';

		iFrameTarifas = parent.document.getElementById('idGestaoBloqueioQtde');
		dtEntrada = parent.document.getElementById('bcDataEntrada');
		dtSaida = parent.document.getElementById('bcDataSaida');

		document.forms[0].action = "app/bloqueio/include!atualizarQtdeGestaoBloqueio.action?bcDataEntrada="
				+ dtEntrada.value
				+ "&bcDataSaida="
				+ dtSaida.value
				+ "&grupo="
				+ key;

		document.forms[0].submit();

	}
</script>
</head>
<body style="margin: 0px;" >
	<s:form namespace="/app/reserva" theme="simple">
		<s:hidden name="bcDataEntrada" id="bcDataEntrada" /> 
        <s:hidden name="bcDataSaida" id="bcDataSaida" />
		<s:set name="bloqueio" value="#session.BLOQUEIO" />
		
		<div class="divGrupo" style='margin: 0px; border: 0px; min-width:50px; width: <s:property value="%{(arrayDias.size()*50)+100+arrayDias.size()+2}" />px;' >
			<s:if test="%{hmGridQtd != null && hmGridQtd.size()>0}">
				<s:iterator value="#session.HASH_QTD" var="array" status="linha">
					<div class="divLinhaCadastro" style="height: 12px; width: 100%;">
						<div class="divLinhaCadastroView"
							id="divLinhaCadastroView${linha.index}"
							style="height: 12px; width: 100%;">
							<!-- ITERATOR  QUANTIDADE DE BLOQUEIO POR TIPO APTO-->
							<div class="divItemGrupo"
								style="width: 87px; background-color: silver; color: rgb(148, 0, 0);">
								<s:property value="%{key}" />
							</div>

							<div class="divItemGrupo"
								style="width: 12px; background-color: silver; color: rgb(148, 0, 0);">
								<img src="imagens/btnAlterar.png"
									title="Alterar Tarifas para este Grupo"
									style="margin: 0 0 0 0px; width: 12px; height: 12px; vertical-align: top;"
									onclick="editarQuantidade('${linha.index}');" />
							</div>
							<s:iterator value="arrayDias" var="col" status="coluna">
								<div class="divItemGrupo"
									style="width: 50px; height: 12px; text-align: center; background-color:#99D699;color:green;">
									<s:set name="dt" value="#col.time.time"></s:set>
									<s:iterator value="value" var="obj" status="celula">
										<s:set name="dtIn" value="#obj.data.time"></s:set>
										<s:if test="%{#dt.equals(#dtIn)}">
											<input type="hidden" name="campoHidden"
												value="${obj.valorChave}">

											<span id="${obj.valorChave}"> <s:property
													value="%{#obj.valor}" />
											</span>
										</s:if>
									</s:iterator>
								</div>
							</s:iterator>
						</div>
						<div class="divLinhaCadastroEdit"
							id="divLinhaCadastroEdit${linha.index}"
							style="margin-bottom: 0px; border: 0px; width: 100%; display: none;">
							<div class="divItemGrupo"
								style="width: 87px; background-color: silver; color: rgb(148, 0, 0);">
								<s:property value="%{key}" />
							</div>
							<div class="divItemGrupo"
								style="width: 12px; background-color: silver; color: rgb(148, 0, 0);">
								<img src="imagens/iconic/png/check-4x.png"
									title="Gravar Quantidades para este Grupo"
									style="margin: 0 0 0 0px; width: 12px; height: 12px; vertical-align: top;"
									onclick="atualizarQuantidade('${linha.index}','${key}');" />
							</div>


							<!--
						-->
							<s:iterator value="arrayDias" var="col" status="coluna">
								<div class="divItemGrupo"
									style="width: 50px; height: 12px; text-align: center;">
									<s:set name="dt" value="#col.time.time"></s:set>
									<s:set name="criarCampoVazio" value="true"></s:set>
									<s:iterator value="value" var="obj" status="celula">
										<s:set name="dtIn" value="#obj.data.time"></s:set>
										<s:if test="%{#dt.equals(#dtIn)}">
											<s:set name="criarCampoVazio" value="false"></s:set>
											<input type="hidden" name="campoHidden"
												value="${obj.valorChave}" />
											<input name="${key}[[*]]${coluna.index}"
												id="${key}[[*]]${coluna.index}"
												onkeypress="mascara(this, numeros)"
												value='<s:property value="%{#obj.valor}"/>'
												style="font-size: 10px; height: 13px; margin: 0; text-align: right; width: 50px;" />
										</s:if>
									</s:iterator>
									<s:if test="%{#criarCampoVazio}">
										<input value='' name="${key}[[*]]${coluna.index}"
											id="${key}[[*]]${coluna.index}"
											onkeypress="mascara(this, numeros)"
											style="font-size: 10px; height: 13px; margin: 0; text-align: right; width: 50px;" />
									</s:if>
								</div>
							</s:iterator>

						</div>



					</div>
				</s:iterator>

				<!-- TOTALIZADOR BLOQUEIOS-->
				<div class="divLinhaCadastro" style="height: 12px; width: 100%;">
					<div class="divItemGrupo"
						style="width: 100px; background-color: silver; font-weight: bold; color: rgb(148, 0, 0);">
						Bloqueio Total:</div>

					<s:iterator value="arrayDias" var="col" status="coluna">
						<div class="divItemGrupo"
							style="width: 50px; height: 12px; text-align: center; font-weight: bold; background-color:#99D699;color:green;">
							<s:set name="dt" value="#col.time.time"></s:set>
							<s:set name="total" value="%{0}"></s:set>
							<s:iterator value="#session.HASH_QTD" var="array" status="linha">
								<s:iterator value="value" var="obj" status="celula">

									<s:set name="dtIn" value="#obj.data.time"></s:set>
									<s:if test="%{#dt.equals(#dtIn)}">
										<s:set name="total" value='%{#total + #obj.valor}' />
									</s:if>

								</s:iterator>
							</s:iterator>
							<span id="${obj.valorChave}"> <s:property
									value="%{#total}" />
							</span>

						</div>
					</s:iterator>
				</div>
				<div class="divLinhaCadastro" style="height: 12px; width: 100%;">
					<!-- SEPARADOR -->
				</div>
				
				<div class="divLinhaCadastro" style="height: 12px; width: 100%;">
					<!-- TOTALIZADOR RASERVADOS-->
					<div class="divItemGrupo"
						style="width: 100px; background-color: silver; font-weight: bold; color: rgb(148, 0, 0);">
						Reservados:</div>
					<s:iterator value="arrayDias" var="col" status="coluna">
						<div class="divItemGrupo"
							style="width: 50px; height: 12px; text-align: center;">
							<s:set name="dt" value="#col.time.time"></s:set>
							<s:set name="total" value="%{0}"></s:set>
							<s:iterator value="#session.HASH_DISP" var="array" status="linha">
								<s:iterator value="value" var="obj" status="celula">

									<s:set name="dtIn" value="#obj.data.time"></s:set>
									<s:if test="%{#dt.equals(#dtIn)}">
										<s:set name="total" value='%{#total + #obj.quantidade}' />
									</s:if>

								</s:iterator>
							</s:iterator>
							<span id="${obj.valorChave}"> <s:property
									value="%{#total}" />
							</span>

						</div>
					</s:iterator>
				</div>
				<div class="divLinhaCadastro" style="height: 12px; width: 100%;">
					<!-- SEPARADOR -->

				</div>
				<div class="divLinhaCadastro" style="height: 12px; width: 100%;">
					<div class="divItemGrupo"
						style="width: 100px; background-color: silver; font-weight: bold; color: rgb(148, 0, 0);">
						Disponível:</div>

					<s:iterator value="arrayDias" var="col" status="coluna">
						<div class="divItemGrupo"
							style="width: 50px; height: 12px; text-align: center;">
							<s:set name="dt" value="#col.time.time"></s:set>
							<s:set name="total" value="%{0}"></s:set>
							<s:iterator value="#session.HASH_QTD" var="array" status="linha">
								<s:iterator value="value" var="obj" status="celula">

									<s:set name="dtIn" value="#obj.data.time"></s:set>
									<s:if test="%{#dt.equals(#dtIn)}">
										<s:set name="total" value='%{#total + #obj.valor}' />
									</s:if>

								</s:iterator>
							</s:iterator>
							<s:iterator value="#session.HASH_DISP" var="array" status="linha">
								<s:iterator value="value" var="obj" status="celula">

									<s:set name="dtIn" value="#obj.data.time"></s:set>
									<s:if test="%{#dt.equals(#dtIn)}">
										<s:set name="total" value='%{#total - #obj.quantidade}' />
									</s:if>

								</s:iterator>
							</s:iterator>
							<span id="${obj.valorChave}"> <s:property
									value="%{#total}" />
							</span>

						</div>
					</s:iterator>

				</div>
				
				<div class="divLinhaCadastro" style="height: 12px; width: 100%;">
					<!-- SEPARADOR -->
				</div>
				<s:iterator value="#session.HASH_DISP" var="array" status="linha">
					<div class="divLinhaCadastro" style="height: 12px; width: 100%;">
						<!-- ITERATOR  QUANTIDADE DIÁRIA DE RESERVA POR BLOQUEIO -->
						<div class="divItemGrupo"
							style="width: 100px; background-color: silver; color: rgb(148, 0, 0);">
							<s:property value="%{key}" />
						</div>
						<s:iterator value="arrayDias" var="col" status="coluna">
							<div class="divItemGrupo"
								style="width: 50px; height: 12px; text-align: center; ">
								<s:set name="dt" value="#col.time.time"></s:set>
								<s:iterator value="value" var="obj" status="celula">
									<s:set name="dtIn" value="#obj.data.time"></s:set>
									<s:if test="%{#dt.equals(#dtIn)}">
										<span id="${obj.valorChave}"> <s:property
												value="%{#obj.quantidade}" />
										</span>
									</s:if>
								</s:iterator>
							</div>
						</s:iterator>
					</div>
				</s:iterator>

				
			</s:if>
		</div>
	</s:form>
</body>
</html>