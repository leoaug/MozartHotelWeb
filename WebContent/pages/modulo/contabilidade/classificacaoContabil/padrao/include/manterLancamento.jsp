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
<%@ include file="/pages/modulo/includes/headPage.jsp"%>
</head>
<script type="text/javascript">

function getConta(elemento, grupo, valorDebitoCredito, sincConta, idCampoContaCorrente) {
	var debitoCredito="Credito";

	if(valorDebitoCredito == 'C'){
		debitoCredito = 'Credito';
	} else if(valorDebitoCredito == 'D'){
		debitoCredito = 'Debito';
	}
	
	url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarClassificacaoContabil'+ debitoCredito +'?OBJ_NAME='
			+ elemento.name
			+ '&OBJ_GROUP='
			+ grupo
			+ '&OBJ_VALUE='
			+ elemento.value
			+ '&SINC_CONTA='
			+ sincConta
			+ '&OBJ_CONTA_ID='
			+ idCampoContaCorrente
			;
	getDataLookup500px(elemento, url, debitoCredito, 'TABLE');
}

window.onload = function() {

	addPlaceHolder('.planoContas');

	<s:if test="%{operacaoRealizada}">
		parent.reset();
		parent.alerta('<s:property value="mensagemPai" />');
	</s:if>
	<s:elseif test="%{mensagemPai != null && mensagemPai != \"\"}">
		parent.alerta('<s:property value="mensagemPai" />');
	</s:elseif>
	
};

function addPlaceHolder(classe) {

	$( classe).attr("placeholder","ex.: digite conta reduzida, conta ou nome da conta");
		
}

function adicionarLancamento(){

	if ($('.percentualTes').get(0).value == ''){
		parent.alerta("O campo 'Percentual' é obrigatório");
		return false;
	}
	if ($('.idCentroCustoTes').get(0).value == ''){
		parent.alerta("O campo 'C. Custo' é obrigatório");
		return false;
	}
	if (document.getElementById('planoContaDebCred.idPlanoContas').value == ''){
		parent.alerta("O campo 'Conta' é obrigatório");
		return false;
	}

	parent.loading();
    document.forms[0].submit();
}

function excluirLancamento(idx){
	if (confirm('Confirma a exclusão do lançamento?')){
	    document.forms[0].action = '<s:url namespace="/app/contabilidade" action="includeClassificacaoContabilPadrao" method="excluirLancamento" />';
	    $('#indice').val( idx );
	    parent.loading();
	    document.forms[0].submit();
	}
}
var idx = -1;
function sincronzaConta( id,  idCampoContaCorrente){
	obj = document.getElementById(id);
	parent.loading();
	submitFormAjax('obterComplementoConta?idPlanoContas='+obj.value+'&debitoCredito='
			+$(".debitoCreditoTes").get(idx).value
			+'&idCampoContaCorrente='+idCampoContaCorrente
			,true);
}

function sincronzaContaReturn(idHistorico, valorComboCC, idCampoContaCorrente){
	killModalPai();
	var cc = idCampoContaCorrente.id;
	if (valorComboCC!=''){
		setarValorJS(cc, valorComboCC.split(',')[0]);
	}else {
		
		setarValorJS(cc, '');
	}
}


function atualizarDadosDefault(dia, idClassificacaoPadrao, valor ){
	parent.loading();
	vForm = document.forms[0]; 
	$('#idClassificacaoContabil').val( idClassificacaoPadrao );
	$('#diaLancamento').val( dia );
	$('#valorPadrao').val( valor );
	vForm.action = '<s:url namespace="/app/contabilidade" action="includeClassificacaoContabilPadrao" method="obterClassificacaoPadrao" />';
    vForm.submit();
}


function killModalPai(){
	parent.killModal();
}

function setPlanoContaFinanceiro(idPlanoContaFinanceiro){
	document.getElementById('planoContaFin.idPlanoContas').value = idPlanoContaFinanceiro ;
}
function setDescricao(descricao){
	$('#descricao').val( descricao );
}

function gravar(){
	parent.loading();

	vForm = document.forms[0]; 
	vForm.action = '<s:url namespace="/app/contabilidade" action="includeClassificacaoContabilPadrao" method="gravar" />';
    vForm.submit();
}


function resetLancamento(){
	$('.debitoCreditoTes').get(0).value= "D";
	$('.planoContaDebCred.contaContabil').get(0).value= "";
	$('.idPlanoContasNome').get(0).value= "";
	$('.controleAtivoTes').get(0).value= "";
	$('.complementoTes').get(0).value= "";
	$('.percentualTes').get(0).value= "";
	//$('.idCentroCustoTes').get(0).value= "";
	$('.pisTes').get(0).value= "S";
	$('.idContaCorrenteTes').get(0).value= "";
}

function calcularValor(){

	var qtde = $(".debitoCreditoTes").length;
	var valorD = toFloat( $("input[name='totalDebito']").val() );
	var valorC = toFloat( $("input[name='totalCredito']").val() );
	
	for (x=1;x<qtde;x++){
		if ("D" ==  $(".debitoCreditoTes").get(x).value){
			valorD += toFloat($(".percentualTes").get(x).value);
		}else{
			valorC += toFloat($(".percentualTes").get(x).value);
		}
	}

	parent.atualizarTotal( moeda(numeros(arredondaFloat(valorD).toString())),
			   			   moeda(numeros(arredondaFloat(valorC).toString())));
}

function editarLancamento(indice){
	document.getElementById('divLinhaCadastroEdit'+indice).style.display='block';
	document.getElementById('divLinhaCadastroView'+indice).style.display='none';
}
function atualizarLancamento(indice){

	if ($('.percentualTes').get(parseInt(indice)+1).value == ''){
		parent.alerta("O campo 'Percentual' é obrigatório");
		return false;
	}
	if ($('.idCentroCustoTes').get(parseInt(indice)+1).value == ''){
		parent.alerta("O campo 'C. Custo' é obrigatório");
		return false;
	}
	
	
	document.getElementById('divLinhaCadastroEdit'+indice).style.display='none';
	document.getElementById('divLinhaCadastroView'+indice).style.display='block';
    document.forms[0].action = '<s:url namespace="/app/contabilidade" action="includeClassificacaoContabilPadrao" method="atualizarLancamento" />';
    $('#indice').val( indice );
    parent.loading();
    document.forms[0].submit();
	
}

function formatarPercentual(obj){
	obj.value = moeda(numeros(arredondaFloat(obj.value).toString()))+' %';
}

</script>
<body>
	<div class="divGrupo"
		style="overflow: auto; margin-top: 0px; width: 970px; height: 98%; border: 0px;">
		<s:form namespace="/app/contabilidade"
			action="includeClassificacaoContabilPadrao!incluirLancamento"
			theme="simple">

			<s:hidden name="indice" id="indice" />
			<s:hidden name="status" id="status" />
			<s:hidden name="valorPadrao" id="valorPadrao" />
			<!-- s:hidden name="planoContaFinArr.idPlanoContas"
				id="planoContaFinArr.idPlanoContas" / -->
			<s:hidden name="idPlanoContasFin" id="idPlanoContasFin.idPlanoContas"/>
			
			<s:hidden name="descricao" id="descricao" />
			<s:hidden name="planoContaDebCred.idPlanoContas"
				id="planoContaDebCred.idPlanoContas"
				onchange="sincronzaConta(this);" />
			<s:hidden name="classificacaoPadrao" id="idClassificacaoContabil" />
			<s:hidden name="idClassificacaoContabilTes" id="idClassificacaoContabilTes" />
			<s:hidden name="diaLancamento" id="diaLancamento" />
			<s:hidden name="dataLancamento"
				value="%{#session.CONTROLA_DATA_SESSION.contabilidade}" />
			<s:hidden name="totalCredito" />
			<s:hidden name="totalDebito" />
			<s:hidden name="diferenca" />
			<s:hidden name="origemMovimento" value="CONTABILIDADE" />
			<s:hidden name="idMovimento" value="" />

			<div class="divLinhaCadastroPrincipal"
				style="margin-bottom: 0px; border: 0px; width: 960px; float: left; height: 20px;">

				<div class="divItemGrupo" style="width: 30px;"></div>
				<div class="divItemGrupo" style="width: 150px;">
					<p style="color: white; width: 60px;">D/C:</p>
					<span id="comboDebitoCredito"> <s:select id="debitoCredito"
							name="debitoCreditoTes" cssClass="debitoCreditoTes"
							cssStyle="width:70px;" list="debitoCreditoList" listKey="id"
							listValue="value" />
					</span>
				</div>
				<div class="divItemGrupo" style="width: 435px;">
					<p style="color: white; width: 60px;">Conta:</p>
					<s:textfield style="width: 370px;"
						onblur="getConta(this, 'planoContaDebCred', debitoCredito.value, 'true','contaCorrenteDs');"
						id="planoContaDebCred.contaContabil"
						cssClass="planoContas"
						name="planoContaDebCred.contaContabil" size="65" value=""
						maxlength="100" />

				</div>

				<div class="divItemGrupo" style="width: 250px;">
					<p style="color: white; width: 90;">Conta Corrente:</p>
					<s:textfield name="contaCorrenteDs" id="contaCorrenteDs"
						cssClass="contaCorrenteDs" onkeypress="" size="10" style="width:152px;"
						readonly="true" value="" />
				</div>
				<div class="divItemGrupo" style="width: 85px;">
					<p style="color: white; width: 30px;">Pis:</p>
					<s:select list="listaConfirmacao" cssStyle="width:50px"
						listKey="id" listValue="value" name="pisTes" cssClass="pisTes" />
				</div>

			</div>

			<div class="divLinhaCadastroPrincipal"
				style="width: 960px; float: left; height: 20px;">
				<div class="divItemGrupo" style="width: 30px;"></div>
				<div class="divItemGrupo" style="width: 150px; color: white;">
					<p style="color: white; width: 60px;">Percentual:</p>
					<s:textfield onkeypress="mascara(this, moeda)" name="percentualTes"
						cssClass="percentualTes" onblur="" style="width:56px;" size="7"
						maxlength="50" value="" /> %
				</div>

				<div class="divItemGrupo" style="width: 435px;">
					<p style="color: white; width: 60px;">Conta fin.:</p>
					<s:textfield style="width: 370px;" name="planoContaFinDs"
						id="planoContaFinDs"
						onblur="getConta(this, 'idPlanoContasFin', debitoCredito.value, 'false','')"
						cssClass="planoContas" size="65" value="" />
				</div>

				<div class="divItemGrupo" style="width: 310px;">
					<p style="color: white; width: 90px;">C.Custo:</p>
					<s:select name="idCentroCustoTes" cssClass="idCentroCustoTes"
						cssStyle="width:152px;" list="#session.CENTRO_CUSTO"
						listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
						value="" />
				</div>


				<div class="divItemGrupo" style="width: 30px;">
					<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png"
						title="Adicionar lançamento" style="margin: 0px;"
						onclick="adicionarLancamento();" />
				</div>
			</div>

			<s:set name="valorD" value="%{0.0}" />
			<s:set name="valorC" value="%{0.0}" />
			<s:iterator value="#session.entidadeSession" var="obj" status="row">
				<s:hidden name="idContaCorrenteTes" value="" />
				<input type="hidden" name="idPlanoContasFin${row.index}.idPlanoContas" id="idPlanoContasFin${row.index}.idPlanoContas" value='<s:property value="%{#obj.planoContasFin.idPlanoContas}" />' />
				<s:hidden name="idClassificacaoContabilTes" value="%{#obj.idClassificacaoContabil}" />

				<s:if test="%{#obj.planoContasDebito != null}">
					<input type="hidden"  name="idPlanoContasTes${row.index}.idPlanoContas"
						value='<s:property value="%{#obj.planoContasDebito.idPlanoContas}" />' id="idPlanoContasTes${row.index}.idPlanoContas"/>
				</s:if>
				<s:if test="%{#obj.planoContasCredito != null}">
					<input type="hidden" name="idPlanoContasTes${row.index}.idPlanoContas" id="idPlanoContasTes${row.index}.idPlanoContas"
						value='<s:property value="%{#obj.planoContasCredito.idPlanoContas}" />'  />
				</s:if>
				
				<input type="hidden" name="idClassificacao"
					value="<s:property value="idClassificacaoContabil" />" />

				<s:if test="%{idClassificacaoContabil == null}">

					<s:if test="%{#obj.debitoCredito.equals(\"D\")}">
						<s:set name="valorD" value='%{#valorD + #obj.percentual}' />
					</s:if>
					<s:if test="%{#obj.debitoCredito.equals(\"C\")}">
						<s:set name="valorC" value='%{#valorC + #obj.percentual}' />
					</s:if>
				</s:if>

				<div class="divLinhaCadastroView"
					id="divLinhaCadastroView${row.index}" style="display: block;">
					<div class="divLinhaCadastro" id="divLinha${row.index}"
						style="margin-bottom: 0px; border: 0px; width: 960px;">
						<div class="divItemGrupo" style="width: 30px;"
							onclick="editarLancamento('${row.index}');">
							<img title="Editar" src="imagens/btnAlterar.png" />
						</div>
						<div class="divItemGrupo" style="width: 150px;">
							<p style="width: 60px;">D/C:</p>
							<span id="comboDebitoCredito"> <s:property
									value="%{#obj.debitoCredito.equalsIgnoreCase('C')?'Crédito':'Débito'}"></s:property>

							</span>
						</div>
						<div class="divItemGrupo" style="width: 435px;">
							<p style="width: 60px;">Conta:</p>
							<span id="comboDebitoCredito"> <s:if
									test="%{#obj.planoContasDebito != null}">
									<s:property
										value="%{#obj.planoContasDebito.contaReduzida+' - '+ #obj.planoContasDebito.contaContabil+' - ' + #obj.planoContasDebito.nomeConta}"></s:property>

								</s:if> <s:if test="%{#obj.planoContasCredito != null}">
									<s:property
										value="%{#obj.planoContasCredito.contaReduzida+' - '+ #obj.planoContasCredito.contaContabil+' - ' + #obj.planoContasCredito.nomeConta}"></s:property>

								</s:if>
							</span>
						</div>
						<div class="divItemGrupo" style="width: 250px;">
							<p style="width: 90;">Conta Corrente:</p>

							<span id="comboDebitoCredito"> <s:if
									test="%{#obj.contaCorrente != null}">
									<s:property value="%{#obj.numContaCorrente + ' - '+ #obj.contaCorrente.numeroAgencia +' - ' + #obj.contaCorrente.nomeAgencia}"></s:property>

								</s:if>
							</span>
						</div>

						<div class="divItemGrupo" style="width: 85px;">
							<p style="width: 30px;">Pis:</p>
							<span> <s:property value="%{#obj.pis ? 'Sim' : 'Não'}" />
							</span>
						</div>


					</div>

					<div class="divLinhaCadastro" id="divLinha${row.index}"
						style="margin-bottom: 2px; border-bottom: 1px solid black; width: 960px;">

						<div class="divItemGrupo" style="width: 30px;"></div>
						<div class="divItemGrupo" style="width: 150px;">
							<p style="width: 60px;">Percentual:</p>
							<span id="percentual" onload="formatarPercentual(this);">
							<s:property value="%{#obj.percentual}" /> %
							</span>
						</div>
						<div class="divItemGrupo" style="width: 435px;">
							<p style="width: 60px;">Conta fin.:</p>

							<s:if
								test="%{#obj.planoContasFin != null && #obj.planoContasFin.idPlanoContas != null}">
								<s:property
									value="%{#obj.planoContasFin.contaReduzida+' - '+ #obj.planoContasFin.contaContabil+' - ' + #obj.planoContasFin.nomeConta}"></s:property>

							</s:if>

						</div>
						<div class="divItemGrupo" style="width: 310px;">
							<p style="width: 90px;">C.Custo:</p>
							<s:if test="%{#obj.centroCustoDebito != null}">
								<s:property
									value="%{#obj.centroCustoDebito.descricaoCentroCusto}" />
							</s:if>
							<s:if test="%{#obj.centroCustoCredito != null}">
								<s:property
									value="%{#obj.centroCustoCredito.descricaoCentroCusto}" />
							</s:if>
						</div>
						<div class="divItemGrupo" style="width: 30px;">
							<s:if test="%{status.equals(\"alteracao\")}">
								<img width="30px" height="30px" title="Excluir lançamento"
									src="imagens/iconic/png/x-3x.png"
									onclick="excluirLancamento('${row.index}')" />
							</s:if>

						</div>
					</div>
				</div>



				<div class="divLinhaCadastroEdit"
					id="divLinhaCadastroEdit${row.index}"
					style="margin-bottom: 0px; border: 0px; width: 960px; display: none;">
					<div class="divLinhaCadastro" id="divLinha${row.index}"
						style="margin-bottom: 0px; border: 0px; width: 960px;">
						<div class="divItemGrupo" style="width: 30px;"
							onclick="atualizarLancamento('${row.index}');">
							<img title="Atualizar" src="imagens/iconic/png/check-4x.png" />
						</div>
						<div class="divItemGrupo" style="width: 150px;">
							<p style="width: 60px;">D/C:</p>
							<span id="comboDebitoCredito"> <s:select
									id="debitoCredito" cssClass="debitoCreditoTes"
									name="debitoCreditoTes" value="%{#obj.debitoCredito}"
									onchange="" cssStyle="width:70px;"
									list="debitoCreditoList" listKey="id" listValue="value" />
							</span>
						</div>
						<div class="divItemGrupo" style="width: 435px;">
							<p style="width: 60px;">Conta:</p>
							<s:if test="%{#obj.planoContasDebito != null}">
								<input
									onblur="getConta(this, 'idPlanoContasTes${row.index}', debitoCredito.value ,'true','contaCorrenteDs${row.index}')"
									id="planoContaDebCredDs${row.index}"
									class="planoContas"
									name="planoContaDebCredDs${row.index}" size="65"
									value='<s:property value="%{#obj.planoContasDebito.contaReduzida+' - '+ #obj.planoContasDebito.contaContabil+' - ' + #obj.planoContasDebito.nomeConta}" />'
									maxlength="100" />

							</s:if>
							<s:if test="%{#obj.planoContasCredito != null}">
								<input
									onblur="getConta(this, 'idPlanoContasTes${row.index}', debitoCredito.value ,'true','contaCorrenteDs${row.index}')"
									id="planoContaDebCredDs${row.index}"
									class="planoContas"
									name="planoContaDebCredDs${row.index}" size="65"
									value='<s:property value="%{#obj.planoContasCredito.contaReduzida+' - '+ #obj.planoContasCredito.contaContabil+' - ' + #obj.planoContasCredito.nomeConta}"  />'
									maxlength="100" />

							</s:if>
						</div>
						<div class="divItemGrupo" style="width: 250px;">
							<p style="width: 90;">Conta Corrente:</p>
							<s:if test="%{#obj.contaCorrente != null}">
								<input name="contaCorrenteDs${row.index}"
									id="contaCorrenteDs${row.index}"
									style="width:152px;"
									class="obj.contaCorrente.id.contaCorrente" onkeypress=""
									size="10" 
									value='<s:property value="%{#obj.contaCorrente.id.contaCorrente+ ' - '+ #obj.contaCorrente.numeroAgencia +' - ' + #obj.contaCorrente.nomeAgencia}" />'
									readonly />
							</s:if>
							<s:elseif test="%{#obj.contaCorrente == null}">
								<input name="contaCorrenteDs${row.index}"
									id="contaCorrenteDs${row.index}"
									style="width:152px;"
									class="obj.contaCorrente.id.contaCorrente" onkeypress=""
									size="10" value="" readonly />
							</s:elseif>
						</div>

						<div class="divItemGrupo" style="width: 85px;">
							<p style="width: 30px;">Pis:</p>
							<s:select list="listaConfirmacao" cssStyle="width:50px"
								listKey="id" listValue="value" name="pisTes" cssClass="pisTes"
								value="%{#obj.pis ? 'S' : 'N'}" />
						</div>


					</div>

					<div class="divLinhaCadastro" id="divLinha${row.index}"
						style="margin-bottom: 2px; border-bottom: 1px solid black; width: 960px;">

						<div class="divItemGrupo" style="width: 30px;"></div>
						<div class="divItemGrupo" style="width: 150px; color: black;">
							<p style="width: 60px;">Percentual:</p>
							<s:textfield name="percentualTes" cssClass="percentualTes"
								onblur="" size="7" style="width: 56px;" maxlength="50"
								onkeypress="mascara(this, moeda)" value="%{#obj.percentual}" /> %
						</div>
						<div class="divItemGrupo" style="width: 435px;">
							<p style="width: 60px;">Conta fin.:</p>
							<input name="planoContaFinDs${row.index}"
								id="planoContaFinDs${row.index}"
								class="planoContas"
								onblur="getConta(this, 'idPlanoContasFin${row.index}', debitoCredito.value ,'false','') "
								size="65" maxlength="50" onkeypress=""
								value='<s:property value="%{#obj.planoContasFin.contaReduzida+' - '+ #obj.planoContasFin.contaContabil+' - ' + #obj.planoContasFin.nomeConta}" />'
								 />
						</div>
						<div class="divItemGrupo" style="width: 310px;">
							<p style="width: 90px;">C.Custo:</p>
							<s:if test="%{#obj.centroCustoDebito != null}">
								<s:select name="idCentroCustoTes" cssClass="idCentroCustoTes"
									cssStyle="width:152px;" list="#session.CENTRO_CUSTO"
									listKey="idCentroCustoContabil"
									listValue="descricaoCentroCusto"
									value="%{#obj.centroCustoDebito.idCentroCustoContabil}" />
							</s:if>
							<s:if test="%{#obj.centroCustoCredito != null}">
								<s:select name="idCentroCustoTes" cssClass="idCentroCustoTes"
									cssStyle="width:152px;" list="#session.CENTRO_CUSTO"
									listKey="idCentroCustoContabil"
									listValue="descricaoCentroCusto"
									value="%{#obj.centroCustoCredito.idCentroCustoContabil}" />
							</s:if>
						</div>
						<div class="divItemGrupo" style="width: 30px;">
							<s:if test="%{status != \"alteracao\"}">
								<img width="30px" height="30px" title="Excluir lançamento"
									src="imagens/iconic/png/x-3x.png"
									onclick="excluirLancamento('${row.index}')" />
							</s:if>


						</div>
					</div>
				</div>
			</s:iterator>

		</s:form>
	</div>
</body>

<script>
	parent.atualizarTotal('<s:property value="%{totalDebito}" />', '<s:property value="%{totalCredito}" />' );
	killModalPai();
	resetLancamento();
	
</script>

</html>