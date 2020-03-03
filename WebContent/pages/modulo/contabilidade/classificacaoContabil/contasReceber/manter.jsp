<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<style type="text/css">
.divLookup {
	background-color: rgb(247, 247, 247);
	list-style: none;
	font-family: Verdana;
	font-size: 10px;
	color: Black;
	position: absolute;
	width: 500px !important;
	border: 1px solid rgb(198, 214, 255);
	height: 150px;
	z-index: 1521;
}

.divLookup h1 {
	background-color: rgb(66, 198, 255);
	height: 20px;
	width: 500px !important;
	font-size: 12px;
	color: White;
	margin-bottom: 0px;
	margin-top: 0px;
}

.divLinhaCadastro select {
	width: 180px;
}

.divLinhaCadastro input {
	text-transform: lowercase !important;
}
</style>
<script type="text/javascript">
	window.onload = function() {

		addPlaceHolder('recRecEjb.planoContasCredito.contaContabil');
		addPlaceHolder('recJurEjb.planoContasCredito.contaContabil');
		addPlaceHolder('recDupEjb.planoContasCredito.contaContabil');
		addPlaceHolder('recFinEjb.planoContasDebito.contaContabil');
		addPlaceHolder('recRddEjb.planoContasDebito.contaContabil');
		addPlaceHolder('recDreEjb.planoContasDebito.contaContabil');
		addPlaceHolder('recDraEjb.planoContasDebito.contaContabil');
		addPlaceHolder('recPisEjb.planoContasDebito.contaContabil');
		addPlaceHolder('recCofEjb.planoContasDebito.contaContabil');
		addPlaceHolder('recCsslEjb.planoContasDebito.contaContabil');
		addPlaceHolder('recIrrfEjb.planoContasDebito.contaContabil');
		addPlaceHolder('recIssEjb.planoContasDebito.contaContabil');
	}

	function addPlaceHolder(classe) {
		document.getElementById(classe).setAttribute("placeholder",
				"ex.: digite conta reduzida, conta ou nome da conta")
	}
	function getDebito(elemento, grupo) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarClassificacaoContabilDebito?OBJ_NAME='
				+ elemento.name
				+ '&OBJ_GROUP='
				+ grupo
				+ '&OBJ_VALUE='
				+ elemento.value;
		getDataLookup500px(elemento, url, 'Debito', 'TABLE');
	}
	function getCredito(elemento, grupo) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarClassificacaoContabilCredito?OBJ_NAME='
				+ elemento.name
				+ '&OBJ_GROUP='
				+ grupo
				+ '&OBJ_VALUE='
				+ elemento.value;
		getDataLookup500px(elemento, url, 'Credito', 'TABLE');
	}

	function validarGravarCReceber() {
		erro = "";
		conector = '\0';

		if (document.getElementById('recRecEjb.planoContasCredito.contaContabil').value == '') {
			erro += '- Insira crédito de Contas a receber' + conector ;
		}
		if (document.getElementById('recJurEjb.planoContasCredito.contaContabil').value == '') {
			erro += '- Insira crédito de Juros'  + conector;
		}
		if (document.getElementById('recDupEjb.planoContasCredito.contaContabil').value == '') {
			erro += '- Insira crédito de Recebimento duplicatas descontada Banco '  + conector;
		}
		if (document.getElementById('recFinEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira débito de Despesas financeiras '  + conector;
		}
		if (document.getElementById('recRddEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira débito de Duplicatas descontadas bancoF '  + conector;
		}
		if (document.getElementById('recDreEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira débito de Duplicatas recompradas '  + conector;
		}
		if (document.getElementById('recDraEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira débito de Desconto recebimento automático  ' + conector;
		}
		if (document.getElementById('recPisEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira débito do PIS ' + conector;
		}
		if (document.getElementById('recCofEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira débito do COFINS ' + conector;
		}
		if (document.getElementById('recCsslEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira débito do CSSL ' + conector;
		}
		if (document.getElementById('recIrrfEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira débito do IRRF ' + conector;
		}
		if (document.getElementById('recIssEjb.planoContasDebito.contaContabil').value == '') {
			erro += '- Insira débito do ISS ' + conector;
		}

		if (erro != '') {
			alerta(erro);
			return false;
		} else {
			gravar();
		}

	}

	function gravar() {
		submitForm(document.forms[0]);
	}

	function getDataLookup500px(obj, url, div, tipoObj) {
		objType = tipoObj;
		if (obj.value.length > 0 && obj.value.length % 3 == 0
				|| obj.value.length >= 4) {
			criarDiv(div);
			obj.disabled = true;
			conjuntoObj = div;
			currSpan = 'span' + div;
			retrieveURL(url);
			var position = $(obj).offset();
			newDiv.css('top', position.top + obj.offsetHeight);
			newDiv.css('left', position.left);
			obj.disabled = false;

		}

	}
	function criarDiv500px(obj) {
		$(document.body)
				.append(
						"<div id=\"divLookup\" class=\"divLookup\" style=\"width:500px !important ; display:none\"><h1 style=\"width:500px !important\"><p>Selecione</p> <img src=\"imagens/fecharColuna.png\" onclick=\"$('div.divLookup').slideUp('slow');\"/> </h1> <div id=\"divLookupBody\" class=\"divLookupBody\"> </div></div>");
		newDiv = $('div.divLookup');
		newDiv.css('display', 'block');
		newDiv.css('width', '500px');
		newSpan = document.createElement('SPAN');
		newSpan.id = "span" + obj;
	}

	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterClassificacaoContabilCReceber!prepararManter.action" namespace="/app/contabilidade" />';
		submitForm(vForm);
	}
</script>

<s:form namespace="/app/contabilidade"
	action="manterClassificacaoContabilCReceber!salvarClassificacaoContabil"
	theme="simple">

	<div class="divFiltroPaiTop">Contas a Receber</div>
	<div id="divFiltroPai" class="divFiltroPai">
		<div id="divFiltro" class="divCadastro" style="height: 235%">



			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Contas a receber - REC -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_REC'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recRecEjb.descricao"
					value="REC_REC" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recRecEjb.idClassificacaoContabil" />

				<s:if
					test="%{hashDsClassificacaoContabil['REC_REC'][1].indexOf('C')!=-1}">
					<s:hidden id="recRecEjb.credito.idPlanoContas"
						name="recRecEjb.planoContasCredito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recRecEjb.credito')"
								id="recRecEjb.planoContasCredito.contaContabil"
								name="recRecEjb.planoContasCredito.contaContabil" size="100"
								value="%{recRecEjb.planoContasCredito.contaReduzida+' - '+recRecEjb.planoContasCredito.contaContabil+' - '+recRecEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recRecEjb.pis"
								id="recRecEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recRecEjb.centroCustoCredito.idCentroCustoContabil"
								id="recRecEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Juros - JUR -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_JUR'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recJurEjb.descricao"
					value="REC_JUR" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recJurEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['REC_JUR'][1].indexOf('D')!=-1}">

					<s:hidden id="recJurEjb.debito.idPlanoContas"
						name="recJurEjb.planoContasDebito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'recJurEjb.debito')"
								id="recJurEjb.planoContasDebito.contaContabil"
								size="100" maxlength="100"
								name="recJurEjb.planoContasDebito.contaContabil"
								value="%{recJurEjb.planoContasDebito.contaReduzida+' - '+recJurEjb.planoContasDebito.contaContabil+' - '+recJurEjb.planoContasDebito.nomeConta.toUpperCase()}"
								 />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recJurEjb.pis"
								id="recJurEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recJurEjb.centroCustoDebito.idCentroCustoContabil"
								id="recJurEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['REC_JUR'][1].indexOf('C')!=-1}">
					<s:hidden id="recJurEjb.credito.idPlanoContas"
						name="recJurEjb.planoContasCredito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recJurEjb.credito')"
								id="recJurEjb.planoContasCredito.contaContabil"
								name="recJurEjb.planoContasCredito.contaContabil" size="100"
								value="%{recJurEjb.planoContasCredito.contaReduzida+' - '+recJurEjb.planoContasCredito.contaContabil+' - '+recJurEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recJurEjb.pis"
								id="recJurEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recJurEjb.centroCustoCredito.idCentroCustoContabil"
								id="recJurEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Recebimento duplicatas descontada Banco - DUP -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_DUP'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recDupEjb.descricao"
					value="REC_DUP" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recDupEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['REC_DUP'][1].indexOf('D')!=-1}">

					<s:hidden id="recDupEjb.debito.idPlanoContas"
						name="recDupEjb.planoContasDebito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'recDupEjb.debito')"
								id="recDupEjb.planoContasDebito.contaContabil"
								size="100" maxlength="100"
								name="recDupEjb.planoContasDebito.contaContabil" 
								value="%{recDupEjb.planoContasDebito.contaReduzida+' - '+recDupEjb.planoContasDebito.contaContabil+' - '+recDupEjb.planoContasDebito.nomeConta.toUpperCase()}"
								/>
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recDupEjb.pis"
								id="recDupEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recDupEjb.centroCustoDebito.idCentroCustoContabil"
								id="recDupEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['REC_DUP'][1].indexOf('C')!=-1}">
					<s:hidden id="recDupEjb.credito.idPlanoContas"
						name="recDupEjb.planoContasCredito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recDupEjb.credito')"
								id="recDupEjb.planoContasCredito.contaContabil"
								name="recDupEjb.planoContasCredito.contaContabil" size="100"
								value="%{recDupEjb.planoContasCredito.contaReduzida+' - '+recDupEjb.planoContasCredito.contaContabil+' - '+recDupEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recDupEjb.pis"
								id="recDupEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recDupEjb.centroCustoCredito.idCentroCustoContabil"
								id="recDupEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!--  despesas financeiras - FIN -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_FIN'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recFinEjb.descricao"
					value="REC_FIN" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recFinEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['REC_FIN'][1].indexOf('D')!=-1}">

					<s:hidden id="recFinEjb.debito.idPlanoContas"
						name="recFinEjb.planoContasDebito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'recFinEjb.debito')"
								id="recFinEjb.planoContasDebito.contaContabil"
								size="100" maxlength="100"
								name="recFinEjb.planoContasDebito.contaContabil"
								value="%{recFinEjb.planoContasDebito.contaReduzida+' - '+recFinEjb.planoContasDebito.contaContabil+' - '+recFinEjb.planoContasDebito.nomeConta.toUpperCase()}"
								 />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recFinEjb.pis"
								id="recFinEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recFinEjb.centroCustoDebito.idCentroCustoContabil"
								id="recFinEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['REC_FIN'][1].indexOf('C')!=-1}">
					<s:hidden id="recFinEjb.credito.idPlanoContas"
						name="recFinEjb.planoContasCredito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recFinEjb.credito')"
								id="recFinEjb.planoContasCredito.contaContabil"
								name="recFinEjb.planoContasCredito.contaContabil" size="100"
								value="%{recFinEjb.planoContasCredito.contaReduzida+' - '+recFinEjb.planoContasCredito.contaContabil+' - '+recFinEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recJurEjb.pis"
								id="recFinEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recFinEjb.centroCustoCredito.idCentroCustoContabil"
								id="recFinEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Duplicatas descontadas banco - RDD -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_RDD'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recRddEjb.descricao"
					value="REC_RDD" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recRddEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['REC_RDD'][1].indexOf('D')!=-1}">

					<s:hidden id="recRddEjb.debito.idPlanoContas"
						name="recRddEjb.planoContasDebito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'recRddEjb.debito')"
								id="recRddEjb.planoContasDebito.contaContabil"
								size="100" maxlength="100"
								name="recRddEjb.planoContasDebito.contaContabil" 
								value="%{recRddEjb.planoContasDebito.contaReduzida+' - '+ recRddEjb.planoContasDebito.contaContabil+' - '+ recRddEjb.planoContasDebito.nomeConta.toUpperCase()}"
								/>
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recRddEjb.pis"
								id="recRddEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recRddEjb.centroCustoDebito.idCentroCustoContabil"
								id="recRddEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['REC_RDD'][1].indexOf('C')!=-1}">
					<s:hidden id="recRddEjb.credito.idPlanoContas"
						name="recRddEjb.planoContasCredito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recRddEjb.credito')"
								id="recRddEjb.planoContasCredito.contaContabil"
								name="recRddEjb.planoContasCredito.contaContabil" size="100"
								value="%{recRddEjb.planoContasCredito.contaReduzida+' - '+ recRddEjb.planoContasCredito.contaContabil+' - '+ recRddEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recRddEjb.pis"
								id="recRddEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recRddEjb.centroCustoCredito.idCentroCustoContabil"
								id="recRddEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Duplicatas recompradas - DRE -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_DRE'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recDreEjb.descricao"
					value="REC_DRE" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recDreEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['REC_DRE'][1].indexOf('D')!=-1}">

					<s:hidden id="recDreEjb.debito.idPlanoContas"
						name="recDreEjb.planoContasDebito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'recDreEjb.debito')"
								id="recDreEjb.planoContasDebito.contaContabil"
								size="100" maxlength="100"
								name="recDreEjb.planoContasDebito.contaContabil" 
								value="%{recDreEjb.planoContasDebito.contaReduzida+' - '+ recDreEjb.planoContasDebito.contaContabil+' - '+ recDreEjb.planoContasDebito.nomeConta.toUpperCase()}"
								/>
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recDreEjb.pis"
								id="recDreEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recDreEjb.centroCustoDebito.idCentroCustoContabil"
								id="recDreEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['REC_DRE'][1].indexOf('C')!=-1}">
					<s:hidden id="recDreEjb.credito.idPlanoContas"
						name="recDreEjb.planoContasCredito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recDreEjb.credito')"
								id="recDreEjb.planoContasCredito.contaContabil"
								name="recDreEjb.planoContasCredito.contaContabil" size="100"
								value="%{recDreEjb.planoContasCredito.contaReduzida+' - '+ recDreEjb.planoContasCredito.contaContabil+' - '+ recDreEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recDreEjb.pis"
								id="recDreEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recDreEjb.centroCustoCredito.idCentroCustoContabil"
								id="recDreEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Desconto recebimento automático - DRA -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_DRA'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recDraEjb.descricao"
					value="REC_DRA" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recDraEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['REC_DRA'][1].indexOf('D')!=-1}">

					<s:hidden id="recDraEjb.debito.idPlanoContas"
						name="recDraEjb.planoContasDebito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'recDraEjb.debito')"
								id="recDraEjb.planoContasDebito.contaContabil"
								size="100" maxlength="100"
								value="%{recDraEjb.planoContasDebito.contaReduzida+' - '+ recDraEjb.planoContasDebito.contaContabil+' - '+ recDraEjb.planoContasDebito.nomeConta.toUpperCase()}"
								name="recDraEjb.planoContasDebito.contaContabil" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recDraEjb.pis"
								id="recDraEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recDraEjb.centroCustoDebito.idCentroCustoContabil"
								id="recDraEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['REC_DRA'][1].indexOf('C')!=-1}">
					<s:hidden id="recDraEjb.credito.idPlanoContas"
						name="recDraEjb.planoContasCredito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 70%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recDraEjb.credito')"
								id="recDraEjb.planoContasCredito.contaContabil"
								name="recDraEjb.planoContasCredito.contaContabil" size="100"
								value="%{recDraEjb.planoContasCredito.contaReduzida+' - '+ recDraEjb.planoContasCredito.contaContabil+' - '+ recDraEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 20%; height: 20px">
							<s:checkbox name="recDraEjb.pis"
								id="recDraEjb.pis">PIS</s:checkbox>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recDraEjb.centroCustoCredito.idCentroCustoContabil"
								id="recDraEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Débito PIS - PIS -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_PIS'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recPisEjb.descricao"
					value="REC_PIS" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recPisEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['REC_PIS'][1].indexOf('D')!=-1}">

					<s:hidden id="recPisEjb.debito.idPlanoContas"
						name="recPisEjb.planoContasDebito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'recPisEjb.debito')"
								id="recPisEjb.planoContasDebito.contaContabil"
								size="100" maxlength="100"
								name="recPisEjb.planoContasDebito.contaContabil" 
								value="%{recPisEjb.planoContasDebito.contaReduzida+' - '+ recPisEjb.planoContasDebito.contaContabil+' - '+ recPisEjb.planoContasDebito.nomeConta.toUpperCase()}"
								/>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recPisEjb.centroCustoDebito.idCentroCustoContabil"
								id="recPisEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if test="%{hashDsClassificacaoContabil['REC_PIS'][1].indexOf('C')!=-1}">
					
					<s:hidden id="recPisEjb.credito.idPlanoContas"
						name="recPisEjb.planoContasCredito.idPlanoContas" />

					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recPisEjb.credito')"
								id="recPisEjb.planoContasCredito.contaContabil"
								name="recPisEjb.planoContasCredito.contaContabil" size="100"
								value="%{recPisEjb.planoContasCredito.contaReduzida+' - '+ recPisEjb.planoContasCredito.contaContabil+' - '+ recPisEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recPisEjb.centroCustoCredito.idCentroCustoContabil"
								id="recPisEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!--  Débito COFINS - COF -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_COF'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recCofEjb.descricao"
					value="REC_COF" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recCofEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['REC_COF'][1].indexOf('D')!=-1}">

					<s:hidden id="recCofEjb.debito.idPlanoContas"
						name="recCofEjb.planoContasDebito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'recCofEjb.debito')"
								id="recCofEjb.planoContasDebito.contaContabil"
								size="100" maxlength="100"
								name="recCofEjb.planoContasDebito.contaContabil" 
								value="%{recCofEjb.planoContasDebito.contaReduzida+' - '+ recCofEjb.planoContasDebito.contaContabil+' - '+ recCofEjb.planoContasDebito.nomeConta.toUpperCase()}"
								/>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recCofEjb.centroCustoDebito.idCentroCustoContabil"
								id="recCofEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['REC_COF'][1].indexOf('C')!=-1}">
					<s:hidden id="recCofEjb.credito.idPlanoContas"
						name="recCofEjb.planoContasCredito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recCofEjb.credito')"
								id="recCofEjb.planoContasCredito.contaContabil"
								name="recCofEjb.planoContasCredito.contaContabil" size="100"
								value="%{recCofEjb.planoContasCredito.contaReduzida+' - '+ recCofEjb.planoContasCredito.contaContabil+' - '+ recCofEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recCofEjb.centroCustoCredito.idCentroCustoContabil"
								id="recCofEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!--  Débito CSSL - CSSL -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_CSSL'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recCsslEjb.descricao"
					value="REC_CSSL" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recCsslEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['REC_CSSL'][1].indexOf('D')!=-1}">

					<s:hidden id="recCsslEjb.debito.idPlanoContas"
						name="recCsslEjb.planoContasDebito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'recCsslEjb.debito')"
								id="recCsslEjb.planoContasDebito.contaContabil"
								size="100" maxlength="100"
								name="recCsslEjb.planoContasDebito.contaContabil" 
								value="%{recCsslEjb.planoContasDebito.contaReduzida+' - '+ recCsslEjb.planoContasDebito.contaContabil+' - '+ recCsslEjb.planoContasDebito.nomeConta.toUpperCase()}"
								/>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recCsslEjb.centroCustoDebito.idCentroCustoContabil"
								id="recCsslEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['REC_CSSL'][1].indexOf('C')!=-1}">
					<s:hidden id="recCsslEjb.credito.idPlanoContas"
						name="recCsslEjb.planoContasCredito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recCsslEjb.credito')"
								id="recCsslEjb.planoContasCredito.contaContabil"
								name="recCsslEjb.planoContasCredito.contaContabil" size="100"
								value="%{recCsslEjb.planoContasCredito.contaReduzida+' - '+ recCsslEjb.planoContasCredito.contaContabil+' - '+ recCsslEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recCsslEjb.centroCustoCredito.idCentroCustoContabil"
								id="recCsslEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Débito IRRF - IRRF -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_IRRF'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recIrrfEjb.descricao"
					value="REC_IRRF" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recIrrfEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['REC_IRRF'][1].indexOf('D')!=-1}">

					<s:hidden id="recIrrfEjb.debito.idPlanoContas"
						name="recIrrfEjb.planoContasDebito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'recIrrfEjb.debito')"
								id="recIrrfEjb.planoContasDebito.contaContabil"
								size="100" maxlength="100"
								name="recIrrfEjb.planoContasDebito.contaContabil" 
								value="%{recIrrfEjb.planoContasDebito.contaReduzida+' - '+ recIrrfEjb.planoContasDebito.contaContabil+' - '+ recIrrfEjb.planoContasDebito.nomeConta.toUpperCase()}"
								/>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recIrrfEjb.centroCustoDebito.idCentroCustoContabil"
								id="recIrrfEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['REC_IRRF'][1].indexOf('C')!=-1}">
					<s:hidden id="recIrrfEjb.credito.idPlanoContas"
						name="recIrrfEjb.planoContasCredito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recIrrfEjb.credito')"
								id="recIrrfEjb.planoContasCredito.contaContabil"
								name="recIrrfEjb.planoContasCredito.contaContabil" size="100"
								value="%{recIrrfEjb.planoContasCredito.contaReduzida+' - '+ recIrrfEjb.planoContasCredito.contaContabil+' - '+ recIrrfEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recIrrfEjb.centroCustoCredito.idCentroCustoContabil"
								id="recIrrfEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Débito ISS - ISS -->

				<div class="divGrupoTitulo">
					<s:property value="hashDsClassificacaoContabil['REC_ISS'][0]" />
				</div>

				<s:hidden id="comissao.descricao" name="recIssEjb.descricao"
					value="REC_ISS" />

				<s:hidden id="comissao.idClassificacaoContabil"
					name="recIssEjb.idClassificacaoContabil" />


				<s:if
					test="%{hashDsClassificacaoContabil['REC_ISS'][1].indexOf('D')!=-1}">

					<s:hidden id="recIssEjb.debito.idPlanoContas"
						name="recIssEjb.planoContasDebito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Débito:</p>
							<s:textfield onblur="getDebito(this, 'recIssEjb.debito')"
								id="recIssEjb.planoContasDebito.contaContabil"
								size="100" maxlength="100"
								name="recIssEjb.planoContasDebito.contaContabil" 
								value="%{recIssEjb.planoContasDebito.contaReduzida+' - '+ recIssEjb.planoContasDebito.contaContabil+' - '+ recIssEjb.planoContasDebito.nomeConta.toUpperCase()}"
								/>
						</div>
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recIssEjb.centroCustoDebito.idCentroCustoContabil"
								id="recIssEjb.centroCustoDebito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
				<s:if
					test="%{hashDsClassificacaoContabil['REC_ISS'][1].indexOf('C')!=-1}">
					<s:hidden id="recIssEjb.credito.idPlanoContas"
						name="recIssEjb.planoContasCredito.idPlanoContas" />

					
						
					<div class="divLinhaCadastro"
						style="height: 35px; border-bottom: 0px !important">
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Credito:</p>
							<s:textfield onblur="getCredito(this, 'recIssEjb.credito')"
								id="recIssEjb.planoContasCredito.contaContabil"
								name="recIssEjb.planoContasCredito.contaContabil" size="100"
								value="%{recIssEjb.planoContasCredito.contaReduzida+' - '+ recIssEjb.planoContasCredito.contaContabil+' - '+ recIssEjb.planoContasCredito.nomeConta.toUpperCase()}"
								maxlength="100" />
						</div>
						
						<div class="divItemGrupo" style="width: 100%; height: 20px">
							<p>Centro de Custo</p>
							<s:select cssClass="width:80%;" list="#session.centroCustoList"
								listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"
								name="recIssEjb.centroCustoCredito.idCentroCustoContabil"
								id="recIssEjb.centroCustoCredito.idCentroCustoContabil" />
						</div>
					</div>
				</s:if>
			</div>
			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
					onClick="validarGravarCReceber()" />
			</div>
		</div>
	</div>
</s:form>