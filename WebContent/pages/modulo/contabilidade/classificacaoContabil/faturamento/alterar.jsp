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

window.onload=function() {
	addPlaceHolder('comissaoEjb.planoContasDebito.contaContabil');
	addPlaceHolder('comissaoEjb.planoContasCredito.contaContabil');
	addPlaceHolder('irrfEjb.planoContasDebito.contaContabil');
	addPlaceHolder('irrfEjb.planoContasCredito.contaContabil');
	addPlaceHolder('ajustesEjb.planoContasDebito.contaContabil');
	addPlaceHolder('ajustesEjb.planoContasCredito.contaContabil');
	addPlaceHolder('encargosEjb.planoContasDebito.contaContabil');
	addPlaceHolder('encargosEjb.planoContasCredito.contaContabil');
	}
	
	function addPlaceHolder(classe) {
		document.getElementById(classe).setAttribute("placeholder", "ex.: digite conta reduzida, conta ou nome da conta")
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

	function validarGravarReserva() {
		erro = '';

		if (document.getElementById('comissao.debito.idPlanoContas').value == ''
				|| document.getElementById('comissao.debito.idHistoricoDebito').value == '') {
			erro += '- Insira débito da Comissão \n';
		}
		if (document.getElementById('comissao.credito.idPlanoContas').value == ''
				|| document
						.getElementById('comissao.credito.idHistoricoDebito').value == '') {
			erro += '- Insira crédito da Comissão \n';
		}
		if (document.getElementById('irrf.debito.idPlanoContas').value == ''
				|| document.getElementById('irrf.debito.idHistoricoDebito').value == '') {
			erro += '- Insira débito do IRRF \n';
		}
		if (document.getElementById('irrf.credito.idPlanoContas').value == ''
				|| document.getElementById('irrf.credito.idHistoricoDebito').value == '') {
			erro += '- Insira crédito do IRRF \n';
		}
		if (document.getElementById('ajustes.debito.idPlanoContas').value == ''
				|| document.getElementById('ajustes.debito.idHistoricoDebito').value == '') {
			erro += '- Insira débito do Ajustes \n';
		}
		if (document.getElementById('ajustes.credito.idPlanoContas').value == ''
				|| document.getElementById('ajustes.credito.idHistoricoDebito').value == '') {
			erro += '- Insira crédito do Ajustes \n';
		}
		if (document.getElementById('encargos.debito.idPlanoContas').value == ''
				|| document.getElementById('encargos.debito.idHistoricoDebito').value == '') {
			erro += '- Insira débito do Encargos \n';
		}
		if (document.getElementById('encargos.credito.idPlanoContas').value == ''
				|| document.getElementById('encargos.credito.idHistoricoDebito').value == '') {
			erro += '- Insira crédito do Encargos \n';
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
	
	function getDataLookup500px(obj, url, div, tipoObj){
	    objType = tipoObj;
	    if (obj.value.length > 0 && obj.value.length % 3 == 0 || obj.value.length >= 4){
	        criarDiv(div);
	        obj.disabled=true;
	        conjuntoObj = div;
	        currSpan = 'span'+div;
	        retrieveURL(url);
	        var position = $(obj).offset();
	        newDiv.css('top',position.top + obj.offsetHeight);
	        newDiv.css('left',position.left);
	        obj.disabled=false;
	       
	    }

	}
	function criarDiv500px(obj){
		$(document.body).append("<div id=\"divLookup\" class=\"divLookup\" style=\"width:500px !important ; display:none\"><h1 style=\"width:500px !important\"><p>Selecione</p> <img src=\"imagens/fecharColuna.png\" onclick=\"$('div.divLookup').slideUp('slow');\"/> </h1> <div id=\"divLookupBody\" class=\"divLookupBody\"> </div></div>");
		newDiv = $('div.divLookup');
		newDiv.css('display','block');
		newDiv.css('width','500px');
		newSpan = document.createElement('SPAN');
		newSpan.id="span"+obj;
	}
	
	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterClassificacaoContabilFaturamento!prepararManter.action" namespace="/app/contabilidade" />';
		submitForm(vForm);
	}
</script>

<s:form namespace="/app/contabilidade"
	action="manterClassificacaoContabilFaturamento!alterarClassificacaoContabil"
	theme="simple">
	<s:hidden id="comissao.debito.idPlanoContas"
		name="comissaoEjb.planoContasDebito.idPlanoContas" />
		
	<s:hidden id="comissao.debito.idHistoricoDebitoCredito"
		name="comissao.debito.idHistoricoDebitoCredito" />
		
	<s:hidden id="comissao.credito.idPlanoContas"
		name="comissaoEjb.planoContasCredito.idPlanoContas" />
		
	<s:hidden id="comissao.credito.idHistoricoDebitoCredito"
		name="comissao.credito.idHistoricoDebitoCredito" />
		
	<s:hidden id="comissao.descricao" name="comissaoEjb.descricao"
		value="FAT_COM" />
		
	<s:hidden id="comissao.idClassificacaoContabil" 
		name="comissaoEjb.idClassificacaoContabil" />
		<!-- -------------------------------------------------------- -->
	<s:hidden id="irrf.debito.idPlanoContas"
		name="irrfEjb.planoContasDebito.idPlanoContas" />

	<s:hidden id="irrf.debito.idHistoricoDebitoCredito"
		name="irrf.debito.idHistoricoDebitoCredito" />

	<s:hidden id="irrf.credito.idPlanoContas"
		name="irrfEjb.planoContasCredito.idPlanoContas" />

	<s:hidden id="irrf.credito.idHistoricoDebitoCredito"
		name="irrf.credito.idHistoricoDebitoCredito" />

	<s:hidden id="irrf.descricao" name="irrfEjb.descricao" value="FAT_IRR" />

	<s:hidden id="irrf.idClassificacaoContabil" name="irrfEjb.idClassificacaoContabil" />
		<!-- -------------------------------------------------------- -->
	
	<s:hidden name="ajustesEjb.planoContasDebito.idPlanoContas"
		id="ajustes.debito.idPlanoContas" />

	<s:hidden id="ajustes.debito.idHistoricoDebitoCredito"
		name="ajustes.debito.idHistoricoDebitoCredito" />

	<s:hidden id="ajustes.credito.idPlanoContas"
		name="ajustesEjb.planoContasCredito.idPlanoContas" />

	<s:hidden id="ajustes.credito.idHistoricoDebitoCredito"
		name="ajustes.credito.idHistoricoDebitoCredito" />

	<s:hidden id="ajustes.descricao" name="ajustesEJb.descricao"
		value="FAT_AJU" />

	<s:hidden id="ajustes.idClassificacaoContabil" 
	name="ajustesEJb.idClassificacaoContabil" />
		<!-- -------------------------------------------------------- -->
		
	<s:hidden id="encargos.debito.idPlanoContas"
		name="encargosEjb.planoContasDebito.idPlanoContas" />

	<s:hidden id="encargos.debito.idHistoricoDebitoCredito"
		name="encargos.debito.idHistoricoDebitoCredito" />

	<s:hidden id="encargos.credito.idPlanoContas"
		name="encargosEjb.planoContasCredito.idPlanoContas" />

	<s:hidden id="encargos.credito.idHistoricoDebitoCredito"
		name="encargos.credito.idHistoricoDebitoCredito" />

	<s:hidden id="encargos.descricao" name="encargosEjb.descricao"
		value="FAT_ENC" />

	<s:hidden id="encargos.idClassificacaoContabil" 
		name="encargosEjb.idClassificacaoContabil" />
		<!-- -------------------------------------------------------- -->


	<div class="divFiltroPaiTop">Faturamento</div>
	<div id="divFiltroPai" class="divFiltroPai">
		<div id="divFiltro" class="divCadastro" style="height: 235%">
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Comissão -->
				<div class="divGrupoTitulo">Comissão</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px !important ">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Débito:</p>
						<s:textfield style="width: 550px;" onblur="getDebito(this, 'comissao.debito')"
							id="comissaoEjb.planoContasDebito.contaContabil"
							name="comissaoEjb.planoContasDebito.contaContabil"
							value="%{comissaoEjb.planoContasDebito.contaReduzida+' - '+comissaoEjb.planoContasDebito.contaContabil+' - '+comissaoEjb.planoContasDebito.nomeConta.toUpperCase()}"
							 size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="comissaoEjb.pis" id="comissao.pisDebito">PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="comissaoEjb.centroCustoDebito.idCentroCustoContabil"
                            		  id="comissao.centroCustoDebito.idCentroCustoContabil"/>
					</div>
				</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px !important">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Credito:</p>
						<s:textfield style="width: 550px;" onblur="getCredito(this, 'comissao.credito')"
							id="comissaoEjb.planoContasCredito.contaContabil"
							name="comissaoEjb.planoContasCredito.contaContabil"
							value="%{comissaoEjb.planoContasCredito.contaReduzida+' - '+comissaoEjb.planoContasCredito.contaContabil+' - '+comissaoEjb.planoContasCredito.nomeConta.toUpperCase()}"
							 size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="comissaoEjb.centroCustoCredito.idCentroCustoContabil"
                            		  id="comissao.centroCustoCredito.idCentroCustoContabil"/>
					</div>
				</div>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- IRRF -->
				<div class="divGrupoTitulo">IRRF</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px !important">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Débito:</p>
						<s:textfield style="width: 550px;" onblur="getDebito(this, 'irrf.debito')"
							id="irrfEjb.planoContasDebito.contaContabil" name="irrfEjb.planoContasDebito.contaContabil"
							value="%{irrfEjb.planoContasDebito.contaReduzida+' - '+irrfEjb.planoContasDebito.contaContabil+' - '+irrfEjb.planoContasDebito.nomeConta.toUpperCase()}"
							size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="irrfEjb.pis" id="irrf.pisDebito">PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="irrfEjb.centroCustoDebito.idCentroCustoContabil"
                            		  id="irrf.centroCustoDebito.idCentroCustoContabil"/>
					</div>
				</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px !important">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Credito:</p>
						<s:textfield style="width: 550px;" onblur="getCredito(this, 'irrf.credito')"
							id="irrfEjb.planoContasCredito.contaContabil" 
							name="irrfEjb.planoContasCredito.contaContabil"
							value="%{irrfEjb.planoContasCredito.contaReduzida+' - '+irrfEjb.planoContasCredito.contaContabil+' - '+irrfEjb.planoContasCredito.nomeConta.toUpperCase()}"
							size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="irrfEjb.centroCustoCredito.idCentroCustoContabil"
                            		  id="irrf.centroCustoCredito.idCentroCustoContabil"/>
					</div>
				</div>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Ajustes -->
				<div class="divGrupoTitulo">Ajustes</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px !important">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Débito:</p>
						<s:textfield style="width: 550px;" onblur="getDebito(this, 'ajustes.debito')"
							id="ajustesEjb.planoContasDebito.contaContabil"
							name="ajustesEjb.planoContasDebito.contaContabil" 
							value="%{ajustesEjb.planoContasDebito.contaReduzida+' - '+ajustesEjb.planoContasDebito.contaContabil+' - '+ajustesEjb.planoContasDebito.nomeConta.toUpperCase()}"
							size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="ajustesEjb.pis" id="ajustes.pisDebito">PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="ajustesEjb.centroCustoDebito.idCentroCustoContabil"
                            		  id="ajustes.centroCustoDebito.idCentroCustoContabil"/>
					</div>
				</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px !important">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Credito:</p>
						<s:textfield style="width: 550px;" onblur="getCredito(this, 'ajustes.credito')"
							id="ajustesEjb.planoContasCredito.contaContabil"
							name="ajustesEjb.planoContasCredito.contaContabil" 
							value="%{ajustesEjb.planoContasCredito.contaReduzida+' - '+ajustesEjb.planoContasCredito.contaContabil+' - '+ajustesEjb.planoContasCredito.nomeConta.toUpperCase()}"
							 size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="ajustesEjb.centroCustoCredito.idCentroCustoContabil"
                            		  id="ajustes.centroCustoCredito.idCentroCustoContabil"/>
					</div>
				</div>
			</div>
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Encargos -->
				<div class="divGrupoTitulo">Encargos</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Débito:</p>
						<s:textfield style="width: 550px;" onblur="getDebito(this, 'encargos.debito')"
							id="encargosEjb.planoContasDebito.contaContabil"
							value="%{encargosEjb.planoContasDebito.contaReduzida+' - '+encargosEjb.planoContasDebito.contaContabil+' - '+encargosEjb.planoContasDebito.nomeConta.toUpperCase()}"
							name="encargosEjb.planoContasDebito.contaContabil" size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="encargosEjb.pis" id="encargos.pisDebito" >PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="encargosEjb.centroCustoDebito.idCentroCustoContabil"
                            		  id="encargos.centroCustoDebito.idCentroCustoContabil"/>
					</div>
				</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Credito:</p>
						<s:textfield style="width: 550px;" onblur="getCredito(this, 'encargos.credito')"
							id="encargosEjb.planoContasCredito.contaContabil"
							value="%{encargosEjb.planoContasCredito.contaReduzida+' - '+encargosEjb.planoContasCredito.contaContabil+' - '+encargosEjb.planoContasCredito.nomeConta.toUpperCase()}"
							name="encargosEjb.planoContasCredito.contaContabil" size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="encargosEjb.centroCustoCredito.idCentroCustoContabil"
                            		  id="encargos.centroCustoCredito.idCentroCustoContabil"/>
					</div>
				</div>

			</div>
			<div class="divCadastroBotoes">
				<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
					onClick="gravar()" />
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
			</div>
		</div>
	</div>
</s:form>