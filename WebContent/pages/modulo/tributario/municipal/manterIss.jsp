<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarIss!prepararPesquisa.action" namespace="/app/sistema" />';
		submitForm(vForm);
	}

	function gravar() {
		if ($('#entidade_status option:selected').val() != 'OK') {

			if ($("input[name='entidade.motivoCancelamento']").val() == '') {
				alerta('Campo "Motivo Cancelamento" é obrigatório.');
				return false;
			}
		}

		submitForm(document.forms[0]);

	}

	function getEmpresa(elemento) {
		url = 'app/ajax/ajax!selecionarEmpresa?OBJ_NAME=' + elemento.name
				+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idEmpresa';
		getDataLookup(elemento, url, 'Empresa', 'TABLE');
	}

	function getHospedeLookup(elemento) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarHospede?OBJ_NAME='
				+ elemento.name
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=idHospede';
		getDataLookup(elemento, url, 'Hospede', 'TABLE');
	}

	function atualizarIss() {
		vlBaseCalculo =toFloat( document.getElementById('entidade.baseCalculo').value);
		vlAliquota = toFloat(document.getElementById('entidade.aliquotaIss').value);

		vlAliquota = vlAliquota / 100;
		vlIss = vlBaseCalculo * vlAliquota;

		document.getElementById('divIss').innerHTML = 			moeda(numeros(arredondaFloat(vlIss).toString()));
	}
	
	function habilitarCampoTomador(quemPaga){
		if(quemPaga == 'E'){
			$("#empresa").show();
			$("#hospede").hide();
		}
		else
		{
			$("#empresa").hide();
			$("#hospede").show();
		}
	}
</script>

<s:form namespace="/app/sistema" action="manterIss!gravar.action"
	theme="simple">

	<s:hidden name="entidade.idNota" />
	<s:hidden name="entidade.numNota" />
	<s:hidden name="entidade.data" />
	<s:hidden id="entidade.iss" name="entidade.iss" />
	<s:hidden id="entidade.baseCalculo" name="entidade.baseCalculo" />
	<div class="divFiltroPaiTop">NFS-e - Alteração</div>
	<div class="divFiltroPai">


		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 110px;">
				<div class="divGrupoTitulo">RPS - Dados</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 70px;">Data Front:</p>
						<s:property value="entidade.data" />
					</div>
					<div class="divItemGrupo" style="width: 130px;">
						<p style="width: 50px;">Número:</p>
						<s:textfield name="entidade.notaInicial"
							id="entidade.notaInicial" size="8"
							maxlength="12" onkeypress="mascara(this,numeros);"/>
					</div>
					<div class="divItemGrupo" style="width: 100px;">
						<p style="width: 50px;">Série:</p>
						<s:textfield name="entidade.serie" id="entidade.data" size="3"
							maxlength="10" />
					</div>
					<div class="divItemGrupo" style="width: 120px;">
						<p style="width: 70px;">Sub-série:</p>
						<s:textfield name="entidade.subSerie" id="entidade.data" size="3"
							maxlength="10" />
					</div>
					<div class="divItemGrupo" style="width: 120px;">
						<p style="width: 50px;">Aliquota:</p>
						<s:textfield name="entidade.aliquotaIss"
							onkeypress="mascara(this,moeda);"  onblur="atualizarIss()" id="entidade.aliquotaIss" size="3"
							maxlength="10" />%
					</div>
					<div class="divItemGrupo" style="width: 230px;">
						<p style="width: 100px;">Data Emissão:</p>
						<s:textfield cssClass="dp" name="entidade.dataEmissao" onkeypress="mascara(this,data);" id="entidade.dataEmissao" size="8" maxlength="10" />
					</div>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 170px;">
						<p style="width: 70px;">Quem Paga:</p>

						<s:select onchange="habilitarCampoTomador(this.value)" cssStyle="width:90px;" list="quemPagaList"
							name="entidade.quemPaga" id="entidade_quempaga"
							value="entidade.quemPaga" listKey="id" listValue="value" />

					</div>
					<div class="divItemGrupo" style="width: 361px;">
						<p style="width: 50px;">Tomador:</p>
						<s:hidden name="entidade.idEmpresa" id="idEmpresa" />
						<s:hidden name="entidade.idHospede" id="idHospede" />
						<input type="text" style="display:none;"
							value='<s:property value="entidade.empresaHotel.empresaRedeEJB.nomeFantasia" />'
							name="empresa" id="empresa" size="50" maxlength="50"
							onblur="getEmpresa(this)" />
						<input type="text" style="display:none;"
							value='<s:property value="entidade.hospede.nomeHospede" />'
							id="hospede" name="hospede" size="50"
							onblur="getHospedeLookup(this)" maxlength="10" />
					</div>
					<div class="divItemGrupo" style="width: 150px;">
						<p style="width: 50px;">Status:</p>

						<s:select cssStyle="width:90px;" list="statusList"
							name="entidade.status" id="entidade_status"
							value="entidade.status" listKey="id" listValue="value" />


					</div>
					<div class="divItemGrupo" style="width: 170px;">
						<p style="width: 70px;">Status RPS:</p>

						<s:select cssStyle="width:90px;" list="rpsStatusList"
							name="entidade.rpsStatus" id="entidade_rpsStatus"
							value="entidade.rpsStatus" listKey="id" listValue="value" />


					</div>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 430px;">
						<p style="width: 130px;">Motivo Cancelamento:</p>
						<s:textfield name="entidade.motivoCancelamento"
							id="entidade.motivoCancelamento" size="50" maxlength="50" />
					</div>
					<div class="divItemGrupo" style="width: 170px;">
						<p style="width: 70px;">Nota Subst.:</p>
						<s:textfield name="entidade.notaSubstituta" onkeypress="mascara(this, numeros);"
							id="entidade.notaSubstituta" size="10" maxlength="10" />
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 90px;">Data da Subst.:</p>
						<s:textfield cssClass="dp" name="entidade.dataSubstituta" onkeypress="mascara(this,data);" id="entidade.dataSubstituta" size="8" maxlength="10" />
					</div>
					<div class="divItemGrupo" style="width: 150px;">
						<p style="width: 90px;">Série da Subst.:</p>
						<s:textfield name="entidade.serieSubstituta" id="entidade.serieSubstituta" size="3"
							maxlength="10" />
					</div>
				</div>
			</div>
			<div class="divGrupo" style="height: 50px;">
				<div class="divGrupoTitulo">Valores</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 170px;">
						<p style="width: 80px;">Base Cálculo:</p>
						<div id="divBaseCalculo">
							<s:property value="entidade.baseCalculo" />
						</div>
					</div>
					<div class="divItemGrupo" style="width: 170px;">
						<p style="width: 50px;">Vr. ISS:</p>
						<div id="divIss">
							<s:property value="entidade.iss" />
						</div>
					</div>
				</div>

			</div>
			<div class="divGrupo" style="height: 50px;">
				<div class="divGrupoTitulo">Retenções</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 125px;">
						<p style="width: 50px;">PIS:</p>
						<s:textfield name="entidade.pis" onkeypress="mascara(this,moeda);"
							id="entidade.data" size="6" />
					</div>
					<div class="divItemGrupo" style="width: 125px;">
						<p style="width: 50px;">COFINS:</p>
						<s:textfield name="entidade.cofins"
							onkeypress="mascara(this,moeda);" id="entidade.data" size="6" />
					</div>
					<div class="divItemGrupo" style="width: 125px;">
						<p style="width: 50px;">INSS:</p>
						<s:textfield name="entidade.inss"
							onkeypress="mascara(this,moeda);" id="entidade.data" size="6" />
					</div>
					<div class="divItemGrupo" style="width: 125px;">
						<p style="width: 50px;">IR:</p>
						<s:textfield name="entidade.irRetencao"
							onkeypress="mascara(this,moeda);" id="entidade.data" size="6" />
					</div>
					<div class="divItemGrupo" style="width: 125px;">
						<p style="width: 50px;">CSLL:</p>
						<s:textfield name="entidade.csll"
							onkeypress="mascara(this,moeda);" id="entidade.data" size="6" />
					</div>
					<div class="divItemGrupo" style="width: 125px;">
						<p style="width: 50px;">ISS:</p>
						<s:textfield name="entidade.issRetido"
							onkeypress="mascara(this,moeda);" id="entidade.data" size="6" />
					</div>
				</div>
			</div>
			<div class="divGrupo" style="height: 450px;">
				<div class="divGrupoTitulo">Discriminação</div>

				<div class="divLinhaCadastro" style="height: 400px;">
					<div class="divItemGrupo" style="width: 900px;">
						<s:textarea name="entidade.discriminacao" id="discriminacao" cols="100" maxlength="2000" rows="20" ></s:textarea>
					</div>
				</div>
			</div>

			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao style="width:110px " label="Gravar"
					imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
			</div>

		</div>
	</div>
</s:form>
<script>
	<s:if test="%{entidade.quemPaga eq \"E\"}">
		habilitarCampoTomador('E');
	</s:if>
	<s:else>
		habilitarCampoTomador('H');
	</s:else>
</script>