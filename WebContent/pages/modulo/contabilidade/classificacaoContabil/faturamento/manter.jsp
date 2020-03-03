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
	addPlaceHolder('comissao.debito.contaContabil');
	addPlaceHolder('comissao.credito.contaContabil');
	addPlaceHolder('irrf.debito.contaContabil');
	addPlaceHolder('irrf.credito.contaContabil');
	addPlaceHolder('ajustes.debito.contaContabil');
	addPlaceHolder('ajustes.credito.contaContabil');
	addPlaceHolder('encargos.debito.contaContabil');
	addPlaceHolder('encargos.credito.contaContabil');
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
			gravar()
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
	action="manterClassificacaoContabilFaturamento!salvarClassificacaoContabil"
	theme="simple">
	<s:hidden id="comissao.debito.idPlanoContas"
		name="comissao.debito.idPlanoContas" />
	<s:hidden id="comissao.debito.idHistoricoDebitoCredito"
		name="comissao.debito.idHistoricoDebitoCredito" />
	<s:hidden id="comissao.credito.idPlanoContas"
		name="comissao.credito.idPlanoContas" />
	<s:hidden id="comissao.credito.idHistoricoDebitoCredito"
		name="comissao.credito.idHistoricoDebitoCredito" />
	<s:hidden id="comissao.descricao" name="comissao.descricao"
		value="FAT_COM" />
	<s:hidden id="irrf.debito.idPlanoContas"
		name="irrf.debito.idPlanoContas" />
	<s:hidden id="irrf.debito.idHistoricoDebitoCredito"
		name="irrf.debito.idHistoricoDebitoCredito" />
	<s:hidden id="irrf.credito.idPlanoContas"
		name="irrf.credito.idPlanoContas" />
	<s:hidden id="irrf.credito.idHistoricoDebitoCredito"
		name="irrf.credito.idHistoricoDebitoCredito" />
	<s:hidden id="irrf.descricao" name="irrf.descricao" value="FAT_IRR" />
	<s:hidden id="ajustes.debito.idPlanoContas"
		name="ajustes.debito.idPlanoContas" />
	<s:hidden id="ajustes.debito.idHistoricoDebitoCredito"
		name="ajustes.debito.idHistoricoDebitoCredito" />
	<s:hidden id="ajustes.credito.idPlanoContas"
		name="ajustes.credito.idPlanoContas" />
	<s:hidden id="ajustes.credito.idHistoricoDebitoCredito"
		name="ajustes.credito.idHistoricoDebitoCredito" />
	<s:hidden id="ajustes.descricao" name="ajustes.descricao"
		value="FAT_AJU" />
	<s:hidden id="encargos.debito.idPlanoContas"
		name="encargos.debito.idPlanoContas" />
	<s:hidden id="encargos.debito.idHistoricoDebitoCredito"
		name="encargos.debito.idHistoricoDebitoCredito" />
	<s:hidden id="encargos.credito.idPlanoContas"
		name="encargos.credito.idPlanoContas" />
	<s:hidden id="encargos.credito.idHistoricoDebitoCredito"
		name="encargos.credito.idHistoricoDebitoCredito" />
	<s:hidden id="encargos.descricao" name="encargos.descricao"
		value="FAT_ENC" />


	<div class="divFiltroPaiTop">Faturamento</div>
	<div id="divFiltroPai" class="divFiltroPai">
		<div id="divFiltro" class="divCadastro" style="height: 235%">
			<div class="divGrupo" style="width: 98%; height: 102px">
				<!-- Comissão -->
				<div class="divGrupoTitulo">Comissão</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px !important ">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Débito:</p>
						<s:textfield onblur="getDebito(this, 'comissao.debito')"
							id="comissao.debito.contaContabil"
							name="comissao.debito.contaContabil" size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="comissao.pisDebito" id="comissao.pisDebito">PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="comissao.centroCustoDebito.idCentroCustoContabil"
                            		  id="comissao.centroCustoDebito.idCentroCustoContabil"/>
					</div>
				</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px !important">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Credito:</p>
						<s:textfield onblur="getCredito(this, 'comissao.credito')"
							id="comissao.credito.contaContabil"
							name="comissao.credito.contaContabil" size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="comissao.pisCredito" id="comissao.pisCredito">PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="comissao.centroCustoCredito.idCentroCustoContabil"
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
						<s:textfield onblur="getDebito(this, 'irrf.debito')"
							id="irrf.debito.contaContabil" name="irrf.debito.contaContabil"
							size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="irrf.pisDebito" id="irrf.pisDebito">PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="irrf.centroCustoDebito.idCentroCustoContabil"
                            		  id="irrf.centroCustoDebito.idCentroCustoContabil"/>
					</div>
				</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px !important">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Credito:</p>
						<s:textfield onblur="getCredito(this, 'irrf.credito')"
							id="irrf.credito.contaContabil" name="irrf.credito.contaContabil"
							size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="irrf.pisCredito" id="irrf.pisCredito">PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="irrf.centroCustoCredito.idCentroCustoContabil"
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
						<s:textfield onblur="getDebito(this, 'ajustes.debito')"
							id="ajustes.debito.contaContabil"
							name="ajustes.debito.contaContabil" size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="ajustes.pisDebito" id="ajustes.pisDebito">PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="ajustes.centroCustoDebito.idCentroCustoContabil"
                            		  id="ajustes.centroCustoDebito.idCentroCustoContabil"/>
					</div>
				</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px !important">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Credito:</p>
						<s:textfield onblur="getCredito(this, 'ajustes.credito')"
							id="ajustes.credito.contaContabil"
							name="ajustes.credito.contaContabil" size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="ajustes.pisCredito" id="ajustes.pisCredito">PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="ajustes.centroCustoCredito.idCentroCustoContabil"
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
						<s:textfield onblur="getDebito(this, 'encargos.debito')"
							id="encargos.debito.contaContabil"
							name="encargos.debito.contaContabil" size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="encargos.pisDebito" id="encargos.pisDebito">PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="encargos.centroCustoDebito.idCentroCustoContabil"
                            		  id="encargos.centroCustoDebito.idCentroCustoContabil"/>
					</div>
				</div>
				<div class="divLinhaCadastro" style="height: 35px;border-bottom:0px">
					<div class="divItemGrupo" style="width: 70%; height: 20px">
						<p>Credito:</p>
						<s:textfield onblur="getCredito(this, 'encargos.credito')"
							id="encargos.credito.contaContabil"
							name="encargos.credito.contaContabil" size="100" maxlength="100" />
					</div>
					<div class="divItemGrupo" style="width: 20%; height: 20px">
						<s:checkbox name="encargos.pisCredito" id="encargos.pisCredito">PIS</s:checkbox>
					</div>
					<div class="divItemGrupo" style="width: 100%; height: 20px">
						<p>Centro de Custo</p>
						<s:select cssClass="width:80%;" 
                            		  list="#session.centroCustoList" 
                            		  listKey="idCentroCustoContabil" 
                            		  listValue="descricaoCentroCusto"
                            		  name="encargos.centroCustoCredito.idCentroCustoContabil"
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