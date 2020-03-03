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

		document.forms[0].action = '<s:url value="app/bloqueio/include!prepararTarifasGestaoBloqueio.action"/>';
		document.forms[0].submit();

	}
	function formatarMoeda(obj){
		obj.value = moeda(numeros(arredondaFloat(obj.value).toString()));
	}

	function editarTarifa(indice){
		document.getElementById('divLinhaCadastroEdit'+indice).style.display='block';
		document.getElementById('divLinhaCadastroView'+indice).style.display='none';
	}
	function atualizarTarifa(indice,key){
	//	document.getElementById('divLinhaCadastroEdit'+indice).style.display='none';
	//	document.getElementById('divLinhaCadastroView'+indice).style.display='block';

		iFrameTarifas = parent.document.getElementById('idGestaoBloqueioTarifas');
   	 	dtEntrada = parent.document.getElementById('bcDataEntrada');
		dtSaida = parent.document.getElementById('bcDataSaida');


		document.forms[0].action = "app/bloqueio/include!atualizarTarifasGestaoBloqueio.action?bcDataEntrada="+dtEntrada.value+ "&bcDataSaida="+dtSaida.value+"&grupo="+key;

		document.forms[0].submit();
 	   	
		
	}
</script>

</head>
<body style="margin: 0px;" >
	<s:form namespace="/app/bloqueio" action="include!atualizarTarifasGestaoBloqueio" theme="simple" >
		<s:hidden name="bcDataEntrada" id="bcDataEntrada" /> 
        <s:hidden name="bcDataSaida" id="bcDataSaida" />
		<s:set name="bloqueio" value="#session.BLOQUEIO" />
 
		<div class="divGrupo" style="margin: 0px; border: 0px; min-width:50px; width: <s:property value="%{(arrayDias.size()*50)+100+arrayDias.size()+1}" />px;" >
			<s:if test="%{hmGridTarifa != null && hmGridTarifa.size()>0}">
				<div class="divLinhaCadastro"
					style="height: 12px; background-color: silver; width: 100%;">
					<div class="divItemGrupo"
						style="width: 100px; color: rgb(148, 0, 0); position: static; font-weight: bold;">
						TIPO APTO/PAX:</div>
					<s:iterator value="arrayDias" var="dia" status="coluna">
						<div class="divItemGrupo"
							style="width: 50px; color: rgb(148, 0, 0); text-align: center;">
							<s:date name="#dia" format="dd/MM" />
						</div>
					</s:iterator>
				</div>
				<div class="divLinhaCadastro" style="height: 12px; width: 100%">
					<div class="divItemGrupo"
						style="width: 100px; color: rgb(148, 0, 0); background-color: silver;">

					</div>
					<s:iterator value="diaSemana" var="diaSem" status="dia">
						<div class="divItemGrupo"
							style="width: 50px;text-align: center;">
							<s:property value="#diaSem" />
						</div>
					</s:iterator>
				</div>
				<s:iterator value="#session.HASH_TARIFAS" var="array" status="linha">
					<div class="divLinhaCadastro" style="height: 12px; width: 100%;">
					<div class="divLinhaCadastroView" id="divLinhaCadastroView${linha.index}" style="height: 12px; width: 100%;">
						<div class="divItemGrupo"
							style="width: 87px; background-color: silver; color: rgb(148, 0, 0);">
								<s:property value="%{key.replace('[[*]]',' - ')}" />
						</div>
						<div class="divItemGrupo"
							style="width: 12px; background-color: silver; color: rgb(148, 0, 0);">
							<img src="imagens/btnAlterar.png"
								title="Alterar Tarifas para este Grupo" style="margin: 0 0 0 0px; width:12px; height: 12px; vertical-align:top;"
								onclick="editarTarifa('${linha.index}');" />
						</div>
						
						
						<!--
						-->
						<s:iterator value="arrayDias" var="col" status="coluna">
							<div class="divItemGrupo" style="width: 50px; height: 12px; text-align: center;">
							<s:set name="dt" value="#col.time.time"></s:set>
								<s:iterator value="value" var="obj" status="celula">
									<s:set name="dtIn" value="#obj.dtEntrada.time"></s:set>
									<s:if test="%{#dt.equals(#dtIn)}" >
												<input type="hidden" name="campoHidden" value="${obj.valorChave}">
												
												<span id="${obj.valorChave}" onload="formatarMoeda(this);">
													<s:property value="%{#obj.valor}"/> 
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
								<s:property value="%{key.replace('[[*]]',' - ')}" />
						</div>
						<div class="divItemGrupo"
							style="width: 12px; background-color: silver; color: rgb(148, 0, 0);">
							<img src="imagens/iconic/png/check-4x.png"
								title="Gravar Tarifas para este Grupo" style="margin: 0 0 0 0px; width:12px; height: 12px; vertical-align:top;"
								onclick="atualizarTarifa('${linha.index}','${key}');" />
						</div>
						
						
						<!--
						-->
						<s:iterator value="arrayDias" var="col" status="coluna">
							<div class="divItemGrupo" style="width: 50px; height: 12px; text-align: center;">
							<s:set name="dt" value="#col.time.time"></s:set>
							<s:set name="criarCampoVazio" value="true"></s:set>
								<s:iterator value="value" var="obj" status="celula">
									<s:set name="dtIn" value="#obj.dtEntrada.time"></s:set>
									<s:if test="%{#dt.equals(#dtIn)}" >
									<s:set name="criarCampoVazio" value="false"></s:set>
												<input type="hidden" name="campoHidden" value="${obj.valorChave}" />
												<input name="${key}[[*]]${coluna.index}"
														id="${key}[[*]]${coluna.index}"
														onkeypress="mascara(this, moeda)"  
														value='<s:property value="%{#obj.valor}"/>'  
														style="font-size: 10px;
													    height: 13px;
													    margin: 0;
													    text-align: right;
													    width: 50px; " />
									</s:if>
								</s:iterator>
								<s:if test="%{#criarCampoVazio}">
											<input value=''  name="${key}[[*]]${coluna.index}" 
													id="${key}[[*]]${coluna.index}"
													onkeypress="mascara(this, moeda)"
													style="font-size: 10px;
														    height: 13px;
														    margin: 0;
														    text-align: right;
														    width: 50px; " />
								</s:if>
							</div>
						</s:iterator>
						
					</div>
					</div>
				</s:iterator>
			</s:if>
		</div>
	</s:form>
</body>
</html>