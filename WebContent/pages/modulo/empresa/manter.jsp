<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">

	$(document).ready(function() {
		habilitarTela('divDados');
	});

	window.onload = function() {
		addPlaceHolder('cidadeEmpresa');
		addPlaceHolder('cidadeCobranca');
	};
	
	function addPlaceHolder(classe) {
		document.getElementById(classe).setAttribute("placeholder",
				"ex.: Digitar o nome da Cidade");
	}
	
	function habilitarTela(value){
		$("#divDados").hide();
		$("#divDadosLegais").hide();
		
		$("#"+value).show();
	}

	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarEmpresa!prepararPesquisa.action" namespace="/app/empresa" />';
		submitForm(vForm);
	}

	function validarEmpresa(cnpj) {

		if (cnpj != '' && cnpj != null) {

			var cnpjcpfformatado = cnpj.replace(/[./-]/g,'');
			if ($("#opcoes").val() == '1'){
				$("input[name='entidade.cgc']").val(cnpjcpfformatado);
				$("input[name='empresaCpf']").val("");
			}
			else if ($("#opcoes").val() == '2')
			{
				$("input[name='entidade.cgc']").val(cnpjcpfformatado);
				$("input[name='empresaCnpj']").val("");
			}
			
			if ($("#opcoes").val() == '1' && !validarCNPJ(cnpjcpfformatado) ){
				alerta('Campo "CNPJ" é inválido.');
				return false;
			}
			else if ($("#opcoes").val() == '2' && !validarCPF(cnpjcpfformatado) ){
				alerta('Campo "CPF" é inválido.');
				return false;
			}

			vForm = document.forms[0];
			vForm.action = '<s:url action="manterEmpresa!validarEmpresa.action" namespace="/app/empresa" />';
			submitForm(vForm);
		}

	}

	function incluirReferencia() {

		if ($("input[name='nomeBanco']").val() == '') {
			alerta('Campo "Nome" é obrigatório.');
			return false;
		}
		if ($("input[name='contatoBanco']").val() == '') {
			alerta('Campo "Contato" é obrigatório.');
			return false;
		}
		if ($("input[name='telefoneBanco']").val() == '') {
			alerta('Campo "Telefone" é obrigatório.');
			return false;
		}

		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEmpresa!incluirReferencia.action" namespace="/app/empresa" />';
		submitForm(vForm);

	}

	function excluirReferencia(idx) {

		vForm = document.forms[0];
		vForm.indice.value = idx;
		vForm.action = '<s:url action="manterEmpresa!excluirReferencia.action" namespace="/app/empresa" />';
		submitForm(vForm);
	}

	function excluirSocio(idx) {

		vForm = document.forms[0];
		vForm.indice.value = idx;
		vForm.action = '<s:url action="manterEmpresa!excluirSocio.action" namespace="/app/empresa" />';
		submitForm(vForm);
	}

	function incluirSocio() {

		if ($("input[name='nomeSocio']").val() == '') {
			alerta('Campo "Nome" é obrigatório.');
			return false;
		}
		if ($("input[name='cpfSocio']").val() == '') {
			alerta('Campo "CPF" é obrigatório.');
			return false;
		}
		if ($("input[name='participacaoSocio']").val() == '') {
			alerta('Campo "Part. %" é obrigatório.');
			return false;
		}

		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEmpresa!incluirSocio.action" namespace="/app/empresa" />';
		submitForm(vForm);
	}

	function getCidadeCobrancaLookup(elemento) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarCidade?OBJ_NAME='
				+ elemento.id
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=idCidadeCobranca';
		getDataLookup(elemento, url, 'divCobranca', 'TABLE');
	}

	function getCidadeEmpresaLookup(elemento) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarCidade?OBJ_NAME='
				+ elemento.id
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=idCidadeEmpresa';
		getDataLookup(elemento, url, 'divEmpresa', 'TABLE');
	}

	function getEmpresa(elemento) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarEmpresa?OBJ_NAME='
				+ elemento.id
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=idEmpresa';
		getDataLookup(elemento, url, 'Empresa', 'TABLE');
	}

	function obterComplementoEmpresa() {

	}

	function inverterDespesas() {
		valor = $("select[name='quemPagaSelecionado']").size();
		for (var x = 0; x < valor; x++) {
			novoValor = $("select[name='quemPagaSelecionado']").get(x).value == "E" ? "H"
					: "E";
			$("select[name='quemPagaSelecionado']").get(x).value = novoValor;
		}
	}

	function selecionarTarifa(idGrupo) {

		$("li.linhaTarifa").css('display', 'none');
		if (idGrupo == null || idGrupo == '') {
			$("li.linhaTarifa").css('display', 'block');
		} else {
			$("li[id$=';" + idGrupo + "']").css('display', 'block');
		}
	}

	function adicionarTarifa(obj) {
		arr = obj.id.split(';');
		//id;dtEntrada;dtSaida;descricao;idgrupo
		//year, month, date
		qtde = $("#tarifaDestino li").length;

		arrDT = arr[1].split('/');
		dataNova = new Date(arrDT[2], parseInt(arrDT[1], 10) - 1, arrDT[0]);
		arrDT = arr[2].split('/');
		dataFimNova = new Date(arrDT[2], parseInt(arrDT[1], 10) - 1, arrDT[0]);

		for (idx = 0; idx < qtde; idx++) {

			objLinha = $("#tarifaDestino li")[idx];
			arrLinha = objLinha.id.split(';');

			if (arrLinha[3] == arr[3]) {
				alerta('Tarifa já cadastrada.');
				return false;
			} else {

				arrDT = arrLinha[1].split('/');
				dataEntradaLinha = new Date(arrDT[2],
						parseInt(arrDT[1], 10) - 1, arrDT[0]);
				arrDT = arrLinha[2].split('/');
				dataSaidaLinha = new Date(arrDT[2], parseInt(arrDT[1], 10) - 1,
						arrDT[0]);

				if (dataNova >= dataEntradaLinha && dataNova <= dataSaidaLinha) {
					alerta('Conflito encontrado.');
					return false;
				}

				if (dataFimNova >= dataEntradaLinha
						&& dataFimNova <= dataSaidaLinha) {
					alerta('Conflito encontrado.');
					return false;
				}

				if (dataEntradaLinha >= dataNova
						&& dataEntradaLinha <= dataFimNova) {
					alerta('Conflito encontrado.');
					return false;
				}

				if (dataSaidaLinha >= dataNova && dataSaidaLinha <= dataFimNova) {
					alerta('Conflito encontrado.');
					return false;
				}

			}

		}

		loading();
		qtde = (qtde == 0 ? 1 : qtde);
		linha = "<li style='width: 100%; cursor: pointer; margin-bottom:2px;' ondblclick='removerTarifa(this);' id='"
				+ (qtde - 1)
				+ ";"
				+ arr[1]
				+ ";"
				+ arr[2]
				+ "'><p style='width:200px;float:left'>"
				+ arr[3]
				+ "</p><p style='width:80px;float:left'>&nbsp;"
				+ arr[1]
				+ "</p><p style='width:80px;float:left'>&nbsp;"
				+ arr[2]
				+ "</p></li>";
		$("#tarifaDestino").append(linha);
		submitFormAjax('empresaIncluirTarifa?indice=' + arr[0], true);

		//<li id="<s:property value="#linhaTarifa.index" />;<s:property value="tarifaEJB.dataEntrada" />;<s:property value="tarifaEJB.dataSaida" />"> 
		//<p style="width:100px;float:left"> <s:property value="tarifaEJB.descricao" /> </p> 
		//<p style="width:60px;float:left"><s:property value="tarifaEJB.dataEntrada" /></p> 
		//<p style="width:60px;float:left"><s:property value="tarifaEJB.dataSaida" /> </p> </li>

		//adicionar na sessao via ajax
	}

	function removerTarifa(obj) {
		arr = obj.id.split(';');
		loading();
		//id;dtEntrada;dtSaida;descricao;idgrupo
		$(obj).remove();

		submitFormAjax('empresaExcluirTarifa?indice=' + arr[0], true);
		//remover na sessao via ajax
	}

	function verificaCNPJCodigo(pNacional) {

		if (pNacional == "1") {
			$('#codEmpresa').val('');
			$('#cpfEmpresa').val('');
			$('#divCodigo').css('display', 'none');
			$('#divCPF').css('display', 'none');
			$('#divCNPJ').css('display', 'block');
		} 
		else if (pNacional == "2"){
			$('#cnpjEmpresa').val('');
			$('#codEmpresa').val('');
			$('#divCPF').css('display', 'block');
			$('#divCNPJ').css('display', 'none');
			$('#divCodigo').css('display', 'none');
		}
		else {
			$('#cnpjEmpresa').val('');
			$('#cpfEmpresa').val('');
			$('#divCodigo').css('display', 'block');
			$('#divCPF').css('display', 'none');
			$('#divCNPJ').css('display', 'none');
		}
	}
	
	function gravar() {

		// validacao da empresa
		if ($("#opcoes").val() == '1'
				&& $("input[name='entidade.cgc']").val() == '') {
			alerta('Campo "CNPJ" é obrigatório.');
			return false;
		}

		if ($("#opcoes").val() == '1'
				&& !validarCNPJ($("input[name='entidade.cgc']").val())) {
			alerta('Campo "CNPJ" é inválido.');
			return false;
		}
		
		if ($("#opcoes").val() == '2'
			&& $("input[name='entidade.cgc']").val() == '') {
			alerta('Campo "CPF" é obrigatório.');
			return false;
		}
	
		if ($("#opcoes").val() == '2'
				&& !validarCPF($("input[name='entidade.cgc']").val())) {
			alerta('Campo "CPF" é inválido.');
			return false;
		}

		if ($("#opcoes").val() == '3'
				&& $("input[name='entidade.codigo']").val() == '') {
			alerta('Campo "Código" é obrigatório.');
			return false;
		}
		if ( $("input[name='empresaRede.deadLine']").val() == '') {
			alerta('Campo "Dead Line" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.razaoSocial']").val() == '') {
			alerta('Campo "Razão Social" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.endereco']").val() == '') {
			alerta('Campo "Endereço" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.bairro']").val() == '') {
			alerta('Campo "Bairro" é obrigatório.');
			return false;
		}
		if ($("input[name='entidade.cep']").val() == '') {
			alerta('Campo "Cep" é obrigatório.');
			return false;
		}
		if (!validaCep($("input[name='entidade.cep']").val())) {
			alerta('"Cep" digitado é inválido');
			return false;
		}

		if ($("input[name='entidade.cidade.cidade']").val() == ''
				|| $("input[name='entidade.cidade.idCidade']").val() == '') {
			alerta('Campo "Cidade" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.inscEstadual']").val() == '') {
			alerta('Campo "Insc. Estadual" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.inscMunicipal']").val() == '') {
			//alerta('Campo "Insc. Municipal" é obrigatório.');
			//return false;
		}

		if ($("input[name='entidade.tipo']").val() == '') {
			//alerta('Campo "Tipo empresa" é obrigatório.');
			//return false;
		}

		// cobrança
		if ($("input[name='empresaRede.nomeFantasia']").val() == '') {
			alerta('Campo "Nome fantasia" é obrigatório.');
			return false;
		}

		if ($("input[name='empresaRede.enderecoCobranca']").val() == '') {
			alerta('Campo "Endereço de cobrança" é obrigatório.');
			return false;
		}

		if ($("input[name='empresaRede.bairro']").val() == '') {
			alerta('Campo "Bairro de cobrança" é obrigatório.');
			return false;
		}

		if ($("input[name='empresaRede.cep']").val() == '') {
			alerta('Campo "Cep de cobrança" é obrigatório.');
			return false;
		}

		if (!validaCep($("input[name='empresaRede.cep']").val())) {
			alerta('"Cep de cobrança" digitado é inválido');
			return false;
		}
		if ($("input[name='empresaRede.cidade.cidade']").val() == ''
				|| $("input[name='empresaRede.cidade.idCidade']").val() == '') {
			alerta('Campo "Cidade de cobrança" é obrigatório.');
			return false;
		}

		if ($("#empresaHotelidTipoEmpresa").val() == '') {
			alerta('Campo "Tipo empresa de cobrança" é obrigatório.');
			return false;
		}

		if ($("#empresaRedepromotorEJBidPromotor").val() == '') {
			alerta('Campo "Promotor" é obrigatório.');
			return false;
		}

		//contato
		if ($("input[name='empresaRede.contato']").val() == '') {
			alerta('Campo "Nome do contato" é obrigatório.');
			return false;
		}

		if ($("input[name='empresaRede.telefone']").val() == ''
				&& $("input[name='empresaRede.telefone2']").val() == '') {
			alerta('Ao menos um "Telefone" é obrigatório.');
			return false;
		}

		if ($("input[name='empresaRede.email']").val() == ''
				&& $("input[name='empresaRede.email2']").val() == '') {
			alerta('Ao menos um "E-mail" é obrigatório.');
			return false;
		}

		//Despesas
		if ($("input[name='empresaHotel.prazoPagamento']").val() == '') {
			alerta('Campo "Prazo pgto" é obrigatório.');
			return false;
		}

		submitForm(document.forms[0]);

	}

	function setValue(name, valor) {
		$("input[name='" + name + "']").val(valor);
	}
</script>


<s:form namespace="/app/empresa"
	action="manterEmpresa!gravarEmpresa.action" theme="simple">
	<input type="hidden" name="issEmpresa" id="issEmpresa" />
	<input type="hidden" name="taxaServicoEmpresa" id="taxaServicoEmpresa" />
	<input type="hidden" name="roomTaxEmpresa" id="roomTaxEmpresa" />
	<s:hidden name="empresaRede.idRedeHotel" />
	<s:hidden name="empresaRede.credito" />
	<s:hidden name="empresaHotel.idHotel" />
	<s:hidden name="indice"></s:hidden>
	<s:hidden name="entidade.idEmpresa" />
	<s:hidden name="entidade.cartaoCredito" />

	<s:hidden name="entidade.dataCadastro" />
	<s:hidden name="empresaRede.dataCadastro" />
	<s:hidden name="bloquearEmpresa" />
	<s:hidden name="bloquearEmpresaRede" />
	<s:hidden name="entidade.cgc" />

	<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1}" var="isHotel" />

	<div class="divFiltroPaiTop">Cliente</div>
	<div class="divFiltroPai">
		<div class="divCadastro" style="overflow: auto; height: 220%">
			<div class="divTopButtons"> 
       		  	<input class=inputTopButtons type="button" onClick="habilitarTela('divDados');" value="Dados" />
       		  	<input id="btDivIcms" class=inputTopButtonsBig type="button" onClick="habilitarTela('divDadosLegais');" value="Dados Legais" />
       		</div>	
			
			<div id="divDados">
				<s:if test="%{!bloquearEmpresa}">
					
					<!-- Grupo dados da empresa -->
					<div class="divGrupo" style="height: 190px;">
						<div class="divGrupoTitulo">Dados</div>
	
	
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 300px;">
								<p style="width: 100px;">Opções:</p>
								<s:select id="opcoes" list="opcoesList" 
									  cssStyle="width:80px"  
									  name="entidade.nacional"
									  listKey="id"
									  listValue="value"
									  onchange="verificaCNPJCodigo(this.value);" > </s:select>
							</div>
	
							<div id="divCNPJ" class="divItemGrupo" style="width: 400px;<s:if test='%{entidade.nacional != null && entidade.nacional != "1"}'>display: none;</s:if>">
								<p style="width: 100px;">CNPJ:</p>
								<s:textfield id="cnpjEmpresa" name="empresaCnpj" maxlength="18"
									size="20" onkeypress="mascara(this, cnpj)"
									onblur="validarEmpresa(this.value)" />
							</div>
							
							<div id="divCPF" class="divItemGrupo" style="width: 400px; <s:if test='%{entidade.nacional != "2"}'>display: none;</s:if>">
								<p style="width: 100px;">CPF:</p>
								<s:textfield id="cpfEmpresa" name="empresaCpf" maxlength="14"
									size="16" onkeypress="mascara(this, cpf)"
									onblur="validarEmpresa(this.value)" />
							</div>
							
							<div id="divCodigo" class="divItemGrupo"
								style="width: 300px; <s:if test='%{entidade.nacional != "3"}'>display: none;</s:if>">
								<p style="width: 100px;">Código:</p>
								<s:textfield id="codEmpresa" name="entidade.codigo"
									maxlength="18" size="20" />
							</div>
	
						</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 800px;">
								<p style="width: 100px;">Razão Social:</p>
								<s:textfield name="entidade.razaoSocial" required="true"
									maxlength="80" size="70"
									onblur="toUpperCase(this);setValue('empresaRede.nomeFantasia', this.value);"></s:textfield>
							</div>
						</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 395px;">
								<p style="width: 100px;">Endereço:</p>
								<s:textfield name="entidade.endereco" maxlength="60" size="50"
									style="width: 260px;" onblur="toUpperCase(this);setValue('empresaHotel.enderecoCobranca',this.value);" />
							</div>
							<div class="divItemGrupo" style="width: 140px;">
								<p style="width: 50px;">Número:</p>
								<s:textfield name="entidade.numero" maxlength="10" size="6"
									onblur="toUpperCase(this);" />
							</div>
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Complemento:</p>
								<s:textfield name="entidade.complemento" maxlength="60" size="20"
									onblur="toUpperCase(this);" />
							</div>
						</div>
	
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 300px;">
								<p style="width: 100px;">Bairro:</p>
								<s:textfield name="entidade.bairro" maxlength="30" size="30"
									style="width: 180px;" onblur="toUpperCase(this);setValue('empresaHotel.bairro',this.value);" />
							</div>
	
							<div class="divItemGrupo" style="width: 235px;">
								<p style="width: 100px;">CEP:</p>
								<s:textfield name="entidade.cep" maxlength="9" size="15"
									onkeypress="mascara(this, cep)"
									onblur="setValue('empresaHotel.cep',this.value);" />
							</div>
							
							<div class="divItemGrupo" style="width: 300px;">
								<p style="width: 80px;">Cidade:</p>
	
								<s:textfield name="entidade.cidade.cidade" id="cidadeEmpresa"
									maxlength="50" size="30" onblur="getCidadeEmpresaLookup(this)" />
								<s:hidden name="entidade.cidade.idCidade" id="idCidadeEmpresa" />
							</div>
						</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 300px;">
								<p style="width: 100px;">Insc. Estadual:</p>
								<s:textfield name="entidade.inscEstadual" maxlength="20"
									size="20" />
							</div>
	
							<div class="divItemGrupo" style="width: 300px;">
								<p style="width: 100px;">Insc. Municipal:</p>
								<s:textfield name="entidade.inscMunicipal" maxlength="20"
									size="20" />
							</div>
						</div>
	
					</div>
				</s:if>
				<s:else>
	
					<!-- Grupo dados da empresa -->
					<div class="divGrupo" style="height: 220px;">
						<div class="divGrupoTitulo">Dados</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 300px;">
								<p style="width: 100px;">Opções:</p>
								<s:if test='%{entidade.nacional == "1"}'>
									Pessoa Jurídica
								</s:if>
								<s:if test='%{entidade.nacional == "2"}'>
									Pessoa Física
								</s:if>
								<s:if test='%{entidade.nacional == "3"}'>
									Outros
								</s:if>
								<s:hidden name="entidade.nacional"></s:hidden>
							</div>
							
							<div id="divCNPJ" class="divItemGrupo" style="width: 300px;<s:if test='%{entidade.nacional != "1"}'>display: none;</s:if>">
								<p style="width: 100px;">CNPJ:</p>
								<s:property value="entidade.cgc" />
							</div>
							
							<div id="divCPF" class="divItemGrupo" style="width: 300px;<s:if test='%{entidade.nacional != "2"}'>display: none;</s:if>">
								<p style="width: 100px;">CPF:</p>
								<s:property value="entidade.cgc" />
							</div>
	
							<div id="divCodigo" class="divItemGrupo"
								style="width: 300px; <s:if test='%{entidade.nacional != "3"}'>display: none;</s:if>">
								<p style="width: 100px;">Código:</p>
								<s:property value="entidade.codigo" />
								<s:hidden id="codEmpresa" name="entidade.codigo" />
							</div>
	
						</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 800px;">
								<p style="width: 100px;">Razão Social:</p>
								<s:property value="entidade.razaoSocial" />
								<s:hidden name="entidade.razaoSocial" />
							</div>
						</div>
	
						<div class="divLinhaCadastro">
	
							<div class="divItemGrupo" style="width: 395px;">
								<p style="width: 100px;">Endereço:</p>
								<s:property value="entidade.endereco" />
								<s:hidden name="entidade.endereco" />
							</div>
							<div class="divItemGrupo" style="width: 140px;">
								<p style="width: 50px;">Número:</p>
								<s:property value="entidade.numero" />
								<s:hidden name="entidade.numero" />
							</div>
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Complemento:</p>
								<s:property value="entidade.complemento" />
								<s:hidden name="entidade.complemento" />
							</div>
						</div>
	
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 300px;">
								<p style="width: 100px;">Bairro:</p>
								<s:property value="entidade.bairro" />
								<s:hidden name="entidade.bairro" />
							</div>
	
							<div class="divItemGrupo" style="width: 235px;">
								<p style="width: 100px;">CEP:</p>
								<s:property value="entidade.cep" />
								<s:hidden name="entidade.cep" />
							</div>
							
							<div class="divItemGrupo" style="width: 300px;">
								<p style="width: 80px;">Cidade:</p>
								<s:property value="entidade.cidade.cidade" />
								<s:hidden name="entidade.cidade.cidade" id="cidadeEmpresa" />
								<s:hidden name="entidade.cidade.idCidade" id="idCidadeEmpresa" />
							</div>
						</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 300px;">
								<p style="width: 100px;">Insc. Estadual:</p>
								<s:property value="entidade.inscEstadual" />
								<s:hidden name="entidade.inscEstadual" />
							</div>
	
							<div class="divItemGrupo" style="width: 300px;">
								<p style="width: 100px;">Insc. Municipal:</p>
								<s:property value="entidade.inscMunicipal" />
								<s:hidden name="entidade.inscMunicipal" />
							</div>
						</div>
	
					</div>
	
				</s:else>	
			
			<s:if
				test="%{!bloquearEmpresaRede || \"TRUE\" == #session.USER_ADMIN}">

				<!-- Grupo dados cobranca -->
				<div class="divGrupo" style="height: 280px;">
					<div class="divGrupoTitulo">Rede</div>
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Nome fantasia:</p>
							<s:textfield name="empresaRede.nomeFantasia" maxlength="80"
								size="30" onblur="toUpperCase(this);" />
						</div>
						
						<div class="divItemGrupo" style="width: 220px;">
							<p style="width: 80px;">Tipo Empresa:</p>
							<s:select list="#session.tipoEmpresaList" headerKey=""
								headerValue="Selecione" listKey="idTipoEmpresa"
								listValue="tipoEmpresa" cssStyle="width:120px;"
								name="empresaHotel.idTipoEmpresa" id="empresaHotelidTipoEmpresa"></s:select>
						</div>
						
						<div class="divItemGrupo" style="width: 200px;">
							<p style="width: 70px;">Prazo pgto:</p>
							<s:textfield name="empresaHotel.prazoPagamento"
								onkeypress="mascara(this, numeros)" maxlength="3" size="5" />
							&nbsp;(em dias)
						</div>
						
					</div>
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Corporate:</p>

							<s:textfield onblur="getEmpresa(this)"
								name="empresaRede.empresaCorporateEJB.nomeFantasia" size="30"
								maxlength="50" id="empresaCorporate" />
							<s:hidden name="empresaRede.empresaCorporateEJB.idEmpresa"
								id="idEmpresa" />
						</div>
						<div class="divItemGrupo" style="width: 220px;">
							<p style="width: 80px;">Grupo econ.:</p>

							<s:select list="#session.grupoEconomicoList" headerKey=""
								headerValue="Selecione" listKey="idGrupoEconomico"
								listValue="nomeGrupo"
								name="empresaRede.grupoEconomico.idGrupoEconomico"
								cssStyle="width:120px;"></s:select>
						</div>

					</div>
					
					<div class="divLinhaCadastro">
						
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Promotor:</p>

							<s:select list="#session.promotorList" headerKey=""
								headerValue="Selecione" listKey="idPromotor"
								listValue="promotor" name="empresaRede.promotorEJB.idPromotor"
								id="empresaRedepromotorEJBidPromotor" cssStyle="width:200px;"></s:select>
						</div>
						
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 70px;">Representante:</p>

							<s:select list="#session.representanteList" headerKey=""
								headerValue="Selecione" listKey="idRepresentante"
								listValue="nomeFantasia" name="empresaRede.idRepresentante"
								id="empresaRederepresentanteEJBidRepresentante" cssStyle="width:200px;"></s:select>
						</div>
						
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 70px;">Vendedor:</p>

							<s:select list="#session.vendedorList" headerKey=""
								headerValue="Selecione" listKey="idVendedor"
								listValue="nomeFantasia" name="empresaRede.idVendedor"
								id="empresaRedevendedorEJBidVendedor" cssStyle="width:200px;"></s:select>
						</div>
						

					</div>


					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="color: rgb(148, 0, 0); font-weight: bold;">Cobrança</p>
						</div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Endereço:</p>
							<s:textfield name="empresaRede.enderecoCobranca" maxlength="80"
								style="width: 220px;" size="40" onblur="toUpperCase(this);" />
						</div>
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Bairro:</p>
							<s:textfield name="empresaRede.bairro" maxlength="30" size="30"
								onblur="toUpperCase(this);" />
						</div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Cidade:</p>
							<s:textfield style="width: 220px;" name="empresaRede.cidade.cidade" id="cidadeCobranca"
								maxlength="50" size="40" onblur="getCidadeCobrancaLookup(this)" />
							<s:hidden name="empresaRede.cidade.idCidade"
								id="idCidadeCobranca" />
						</div>
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">CEP:</p>
							<s:textfield name="empresaRede.cep" maxlength="9" size="15"
								onkeypress="mascara(this, cep)" />
						</div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 550px;">
							<p style="color: rgb(148, 0, 0); font-weight: bold; width: 350px;">Retenções em percentuais</p>
						</div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 125px;">
							<p style="width: 50px;">PIS:</p>
							<s:textfield name="empresaRede.pis"
								onkeypress="mascara(this,moeda);" id="entidade.data" size="6" />
						</div>
						<div class="divItemGrupo" style="width: 125px;">
							<p style="width: 50px;">COFINS:</p>
							<s:textfield name="empresaRede.cofins"
								onkeypress="mascara(this,moeda);" id="entidade.data" size="6" />
						</div>
						<div class="divItemGrupo" style="width: 125px;">
							<p style="width: 50px;">INSS:</p>
							<s:textfield name="empresaRede.inss"
								onkeypress="mascara(this,moeda);" id="entidade.data" size="6" />
						</div>
						<div class="divItemGrupo" style="width: 125px;">
							<p style="width: 50px;">IR:</p>
							<s:textfield name="empresaRede.irRetencao"
								onkeypress="mascara(this,moeda);" id="entidade.data" size="6" />
						</div>
						<div class="divItemGrupo" style="width: 125px;">
							<p style="width: 50px;">CSLL:</p>
							<s:textfield name="empresaRede.csll"
								onkeypress="mascara(this,moeda);" id="entidade.data" size="6" />
						</div>
						<div class="divItemGrupo" style="width: 225px;">
							<p style="width: 120px;">Outras Retenções:</p>
							<s:textfield name="empresaRede.outrasRetencoes"
								onkeypress="mascara(this,moeda);" id="entidade.data" size="6" />
						</div>
					</div>




				</div>

				<!-- Grupo dados contato -->

				<div class="divGrupo" style="height: 230px;">
					<div class="divGrupoTitulo">Rede - Contato</div>


					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Nome:</p>
							<s:textfield style="width: 220px;" name="empresaRede.contato" maxlength="60" size="40"
								onblur="toUpperCase(this);" />
						</div>

						<div class="divItemGrupo" style="width: 250px;">
							<p style="width: 100px;">Dt Nasc.:</p>
							<s:textfield cssClass="dp" id="dataNascContato"
								name="empresaRede.dataNascimento" size="15"
								onblur="dataValida(this)" maxlength="10"
								onkeypress="mascara(this,data)" />
						</div>

					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Telefone:</p>
							<s:textfield name="empresaRede.telefone" maxlength="15" size="16"
								onkeypress="mascara(this,celular)" />
						</div>
						
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Telefone2:</p>
							<s:textfield name="empresaRede.telefone2" maxlength="15"
								size="16" onkeypress="mascara(this,celular)" />
						</div>
						
						<div class="divItemGrupo" style="width: 170px;">
							<p style="width: 50px;">Fax:</p>
							<s:textfield name="empresaRede.fax" maxlength="14" size="15"
								onkeypress="mascara(this,telefone)" />
						</div>
					</div>

					<div class="divLinhaCadastro">
						<s:if test="isHotel">
							<div class="divItemGrupo" style="width: 350px;">
								<p style="width: 100px;">E-mail Reserva:</p>
								<s:textfield style="width: 220px;" name="empresaRede.email" maxlength="40" size="40"
									onblur="toUpperCase(this);" />
							</div>
						</s:if>
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;"><s:if test="isHotel">E-mail Financeiro:</s:if><s:else>E-mail:</s:else></p>
							<s:textfield style="width: 220px;" name="empresaRede.email2" maxlength="40" size="40"
								onblur="toUpperCase(this);" />
						</div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="color: rgb(148, 0, 0); font-weight: bold;">Outras condições</p>
						</div>
					</div>
					<s:if test="isHotel">
						<div class="divLinhaCadastro">
							
							<div class="divItemGrupo" style="width: 350px;">
								<p style="width: 100px;">Bloq.Res.CRS:</p>
	
								<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
									listValue="value" cssStyle="width:50px;" name="empresaRede.crs"></s:select>
							</div>
	
							<div class="divItemGrupo" style="width: 350px;">
								<p style="width: 100px;">Bloq.Res.Internet:</p>
	
								<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
									listValue="value" cssStyle="width:50px;"
									name="empresaRede.internet"></s:select>
							</div>
	
						</div>
					</s:if>

					<div class="divLinhaCadastro" style="height: 50px;">
						<div class="divItemGrupo" style="width: 500px;">
							<p style="width: 100px;">Observação:</p>
							<s:textarea cols="40" rows="2" name="empresaRede.observacao">
							</s:textarea>
						</div>

					</div>

				</div>

				<!-- Grupo dados Despesa -->
				<s:if test="isHotel">
					<div class="divGrupo" style="height: 330px;">
						<div class="divGrupoTitulo">Hotel - Despesas</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 220px;">
								<p style="width: 100px;">ISS:</p>
								<s:if test='%{#session.HOTEL_SESSION.iss > 0}'>
									<s:select list="#session.LISTA_CONFIRMACAO"
										cssStyle="width:50px;" listKey="id" listValue="value"
										name="empresaHotel.calculaIss" />
								</s:if>
								<s:else>
									<font color="red"><b>Não</b></font>
									<s:hidden name="empresaHotel.calculaIss" value="N" />
								</s:else>
							</div>
							<div class="divItemGrupo" style="width: 180px;">
								<p style="width: 100px;">Taxa serviço:</p>
								<s:if test='%{#session.HOTEL_SESSION.taxaServico > 0}'>
									<s:select list="#session.LISTA_CONFIRMACAO"
										cssStyle="width:50px;" listKey="id" listValue="value"
										name="empresaHotel.calculaTaxa" />
								</s:if>
								<s:else>
									<font color="red"><b>Não</b></font>
									<s:hidden name="empresaHotel.calculaTaxa" value="N" />
								</s:else>
	
							</div>
							<div class="divItemGrupo" style="width: 180px;">
								<p style="width: 100px;">Room tax:</p>
								<s:if test='%{#session.HOTEL_SESSION.roomtax > 0}'>
									<s:select list="#session.LISTA_CONFIRMACAO"
										cssStyle="width:50px;" listKey="id" listValue="value"
										name="empresaHotel.calculaRoomtax" />
								</s:if>
								<s:else>
									<font color="red"><b>Não</b></font>
									<s:hidden name="empresaHotel.calculaRoomtax" value="N" />
								</s:else>
							</div>
							<div class="divItemGrupo" style="width: 160px;">
								<p style="width: 100px;">Seguro:</p>
								<s:if test='%{#session.HOTEL_SESSION.seguro > 0}'>
									<s:select list="#session.LISTA_CONFIRMACAO"
										cssStyle="width:50px;" listKey="id" listValue="value"
										name="empresaHotel.calculaSeguro" />
								</s:if>
								<s:else>
									<font color="red"><b>Não</b></font>
									<s:hidden name="empresaHotel.calculaSeguro" value="N" />
								</s:else>
							</div>
						</div>
	
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 220px;">
								<p style="width: 100px;">Pensão:</p>
								<s:select list="pensaoList" cssStyle="width:110px;" listKey="id"
									listValue="value" name="empresaHotel.tipoPensao" />
							</div>
							
							<div class="divItemGrupo" style="width: 180px;">
								<p style="width: 100px;">Dead Line:</p>
								<s:textfield name="empresaRede.deadLine" maxlength="3" size="2"
									onblur="toUpperCase(this);" />
							</div>
	
							<div class="divItemGrupo" style="width: 180px;">
								<p style="width: 100px;">No Show:</p>
	
								<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
									listValue="value" cssStyle="width:50px;"
									name="empresaRede.noShow" />
							</div>
							
							<div class="divItemGrupo" style="width: 180px;">
								<p style="width: 100px;">Comissão:</p>
								<s:textfield name="empresaHotel.comissao"
									id="empresaHotel.comissao" onkeypress="mascara(this, moeda)"
									maxlength="4" size="5" />
							</div>
							
						</div>
						
						<s:iterator
							value="#session.entidadeSession.empresaRedeEJBList.get(0).empresaHotelEJBList.get(0).empresaGrupoLancamentoEJBList"
							status="row">
							<div class="divLinhaCadastro" style="background-color: white;">
								<div class="divItemGrupo" style="width: 340px;">
									<p style="width: 220px;">
										<s:property value="identificaLancamentoEJB.descricaoLancamento" />
									</p>
									<s:select cssStyle="width:90px;" list="quemPagaList"
										name="quemPagaSelecionado" value="quemPaga" listKey="id"
										listValue="value" />
								</div>
	
								<s:if test="#row.index == 0">
									<div class="divItemGrupo" style="width: 25px;">
										<img src="imagens/iconic/png/loop-circular-3x.png" title="Inventer despesas"
											onclick="inverterDespesas()" />
									</div>
								</s:if>
							</div>
						</s:iterator>
	
	
					</div>
				


					<!-- Grupo dados tarifa -->
	
					<div class="divGrupo" style="height: 400px;">
						<div class="divGrupoTitulo">Tarifa</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 350px;">
								<p style="width: 100px;">Grupo de tarifa:</p>
								<s:select list="#session.grupoTarifaList" cssStyle="width:150px;"
									listKey="idTarifaGrupo" listValue="descricao" headerKey=""
									headerValue="Todos" name="idGrupoTarifa"
									onchange="selecionarTarifa(this.value)" />
							</div>
						</div>
	
	
	
						<div class="divLinhaCadastroPrincipal"
							style="background-color: rgb(49, 115, 255);">
	
							<div class="divItemGrupo"
								style="width: 420px; background-color: rgb(49, 115, 255)">
								<p style="width: 200px; float: left; color: white;">Tarifa</p>
								<p style="width: 80px; float: left; color: white;">&nbsp;Data
									entrada</p>
								<p style="width: 80px; float: left; color: white;">&nbsp;Data
									saída</p>
								<p style="width: 50px; float: left; color: white;">
									&nbsp;<b>(Hotel)</b>
								</p>
							</div>
	
							<div class="divItemGrupo" style="width: 30px;">&nbsp;</div>
	
							<div class="divItemGrupo"
								style="width: 430px; background-color: rgb(49, 115, 255)">
								<p style="width: 200px; float: left; color: white;">Tarifa</p>
								<p style="width: 80px; float: left; color: white;">&nbsp;Data
									entrada</p>
								<p style="width: 80px; float: left; color: white;">&nbsp;Data
									saída</p>
								<p style="width: 50px; float: left; color: white;">
									&nbsp;<b>(Empresa)</b>
								</p>
							</div>
	
						</div>
	
						<div class="divLinhaCadastro" style="height: 300px">
	
							<div id="divTarifas" class="divItemGrupo"
								style="width: 420px; height: 300px; overflow: auto;">
	
								<ul style="margin: 0px; padding: 0px;">
									<s:iterator value="#session.tarifaList" status="idxTarifa">
										<li ondblclick="adicionarTarifa(this);"
											style="width: 100%; cursor: pointer; margin-bottom: 2px;"
											class="linhaTarifa"
											id="<s:property value="#idxTarifa.index" />;<s:property value="dataEntrada" />;<s:property value="dataSaida" />;<s:property value="descricao" />;<s:property value="tarifaGrupo.idTarifaGrupo" />">
											<p style="width: 200px; float: left">
												<s:property value="descricao" />
											</p>
											<p style="width: 80px; float: left">
												&nbsp;
												<s:property value="dataEntrada" />
											</p>
											<p style="width: 80px; float: left">
												&nbsp;
												<s:property value="dataSaida" />
											</p>
										</li>
									</s:iterator>
								</ul>
	
							</div>
	
							<div class="divItemGrupo"
								style="width: 30px; height: 300px; background-color: silver;">
	
							</div>
	
							<div class="divItemGrupo"
								style="width: 420px; height: 300px; overflow-y: auto;">
								<ul style="margin: 0px; padding: 0px;" id="tarifaDestino">
									<s:iterator
										value="#session.entidadeSession.empresaRedeEJBList.get(0).empresaHotelEJBList.get(0).empresaTarifaEJBList"
										status="linhaTarifa">
										<li style="width: 100%; cursor: pointer; margin-bottom: 2px;"
											ondblclick="removerTarifa(this);"
											id="<s:property value="#linhaTarifa.index" />;<s:property value="tarifaEJB.dataEntrada" />;<s:property value="tarifaEJB.dataSaida" />">
											<p style="width: 200px; float: left">
												<s:property value="tarifaEJB.descricao" />
											</p>
											<p style="width: 80px; float: left">
												&nbsp;
												<s:property value="tarifaEJB.dataEntrada" />
											</p>
											<p style="width: 80px; float: left">
												&nbsp;
												<s:property value="tarifaEJB.dataSaida" />
											</p>
										</li>
									</s:iterator>
								</ul>
							</div>
	
						</div>
	
	
					</div>
				</s:if>

			</s:if>

			<s:else>

				<!-- Grupo dados cobranca -->
				<div class="divGrupo" style="height: 210px;">
					<div class="divGrupoTitulo">Cobrança</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 500px;">
							<p style="width: 100px;">Nome fantasia:</p>
							<s:property value="empresaRede.nomeFantasia" />
							<s:hidden name="empresaRede.nomeFantasia" />
						</div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 500px;">
							<p style="width: 100px;">Endereço:</p>
							<s:textfield name="empresaRede.enderecoCobranca" maxlength="50"
								size="40" onblur="toUpperCase(this);" />
						</div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Bairro:</p>
							<s:textfield name="empresaRede.bairro" maxlength="30" size="30"
								onblur="toUpperCase(this);" />
						</div>

						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">CEP:</p>
							<s:textfield name="empresaRede.cep" maxlength="9" size="15"
								onkeypress="mascara(this, cep)" />
						</div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Cidade:</p>
							<s:textfield name="empresaRede.cidade.cidade" id="cidadeCobranca"
								maxlength="50" size="40" onblur="getCidadeCobrancaLookup(this)" />
							<s:hidden name="empresaRede.cidade.idCidade"
								id="idCidadeCobranca" />
						</div>

						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Grupo econ.:</p>

							<s:property value="empresaRede.grupoEconomico.nomeGrupo" />
							<s:hidden name="empresaRede.grupoEconomico.idGrupoEconomico" />

						</div>

					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 500px;">
							<p style="width: 100px;">Corporate:</p>
							<s:property value="empresaRede.empresaCorporateEJB.nomeFantasia" />
							<s:hidden name="empresaRede.empresaCorporateEJB.idEmpresa" />
							<s:hidden name="empresaRede.empresaCorporateEJB.nomeFantasia" />

						</div>

					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Tipo Empresa:</p>
							<s:select list="#session.tipoEmpresaList" headerKey=""
								headerValue="Selecione" listKey="idTipoEmpresa"
								listValue="tipoEmpresa" cssStyle="width:180px;"
								name="empresaHotel.idTipoEmpresa"></s:select>
						</div>

						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Promotor:</p>

							<s:property value="empresaRede.promotorEJB.promotor" />
							<s:hidden name="empresaRede.promotorEJB.idPromotor" />
							<s:hidden name="empresaRede.promotorEJB.promotor" />

						</div>

					</div>


				</div>

				<!-- Grupo dados contato -->

				<div class="divGrupo" style="height: 230px;">
					<div class="divGrupoTitulo">Contato</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Nome:</p>

							<s:property value="empresaRede.contato" />
							<s:hidden name="empresaRede.contato" />

						</div>

						<div class="divItemGrupo" style="width: 250px;">
							<p style="width: 100px;">Dt Nasc.:</p>
							<s:property value="empresaRede.dataNascimento" />
							<s:hidden name="empresaRede.dataNascimento" />
						</div>

					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Telefone:</p>
							<s:property value="empresaRede.telefone" />
							<s:hidden name="empresaRede.telefone" />
						</div>

						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Fax:</p>
							<s:property value="empresaRede.fax" />
							<s:hidden name="empresaRede.fax" />
						</div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Telefone2:</p>
							<s:property value="empresaRede.telefone2" />
							<s:hidden name="empresaRede.telefone2" />

						</div>
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Telex:</p>
							<s:property value="empresaRede.telex" />
							<s:hidden name="empresaRede.telex" />

						</div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">E-mail:</p>
							<s:property value="empresaRede.email" />
							<s:hidden name="empresaRede.email" />
						</div>
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">E-mail2:</p>
							<s:property value="empresaRede.email2" />
							<s:hidden name="empresaRede.email2" />
						</div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Bloq.Res.CRS:</p>
							<s:if test="%{empresaRede.crs == 'S'}">
			Sim
		</s:if>
							<s:else>
			Não
		</s:else>
							<s:hidden name="empresaRede.crs" />

						</div>

						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Bloq.Res.Internet:</p>
							<s:if test="%{empresaRede.internet == 'S'}">
			Sim
		</s:if>
							<s:else>
			Não
		</s:else>
							<s:hidden name="empresaRede.internet" />

						</div>

					</div>


					<div class="divLinhaCadastro" style="height: 50px;">
						<div class="divItemGrupo" style="width: 500px;">
							<p style="width: 100px;">Observação:</p>
							<s:property value="empresaRede.observacao" />
							<s:hidden name="empresaRede.observacao" />
						</div>

					</div>

				</div>

				<!-- Grupo dados Despesa -->

				<div class="divGrupo" style="height: 290px;">
					<div class="divGrupoTitulo">Despesas</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 220px;">
							<p style="width: 100px;">ISS:</p>
							<s:if test='%{#session.HOTEL_SESSION.iss > 0}'>
								<s:select list="#session.LISTA_CONFIRMACAO"
									cssStyle="width:50px;" listKey="id" listValue="value"
									name="empresaHotel.calculaIss" />
							</s:if>
							<s:else>
								<font color="red"><b>Não</b></font>
								<s:hidden name="empresaHotel.calculaIss" value="N" />
							</s:else>
						</div>
						<div class="divItemGrupo" style="width: 180px;">
							<p style="width: 100px;">Taxa serviço:</p>
							<s:if test='%{#session.HOTEL_SESSION.taxaServico > 0}'>
								<s:select list="#session.LISTA_CONFIRMACAO"
									cssStyle="width:50px;" listKey="id" listValue="value"
									name="empresaHotel.calculaTaxa" />
							</s:if>
							<s:else>
								<font color="red"><b>Não</b></font>
								<s:hidden name="empresaHotel.calculaTaxa" value="N" />
							</s:else>

						</div>
						<div class="divItemGrupo" style="width: 180px;">
							<p style="width: 100px;">Room tax:</p>
							<s:if test='%{#session.HOTEL_SESSION.roomtax > 0}'>
								<s:select list="#session.LISTA_CONFIRMACAO"
									cssStyle="width:50px;" listKey="id" listValue="value"
									name="empresaHotel.calculaRoomtax" />
							</s:if>
							<s:else>
								<font color="red"><b>Não</b></font>
								<s:hidden name="empresaHotel.calculaRoomtax" value="N" />
							</s:else>
						</div>
						<div class="divItemGrupo" style="width: 160px;">
							<p style="width: 100px;">Seguro:</p>
							<s:if test='%{#session.HOTEL_SESSION.seguro > 0}'>
								<s:select list="#session.LISTA_CONFIRMACAO"
									cssStyle="width:50px;" listKey="id" listValue="value"
									name="empresaHotel.calculaSeguro" />
							</s:if>
							<s:else>
								<font color="red"><b>Não</b></font>
								<s:hidden name="empresaHotel.calculaSeguro" value="N" />
							</s:else>
						</div>
					</div>


					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 220px;">
							<p style="width: 100px;">Pensão:</p>
							<s:select list="pensaoList" cssStyle="width:110px;" listKey="id"
								listValue="value" name="empresaHotel.tipoPensao" />
						</div>
						<div class="divItemGrupo" style="width: 180px;">
							<p style="width: 100px;">Comissão:</p>
							<s:textfield name="empresaHotel.comissao"
								id="empresaHotel.comissao" onkeypress="mascara(this, moeda)"
								maxlength="4" size="5" />
						</div>
						<div class="divItemGrupo" style="width: 250px;">
							<p style="width: 100px;">Prazo pgto:</p>
							<s:textfield name="empresaHotel.prazoPagamento"
								onkeypress="mascara(this, numeros)" maxlength="3" size="5" />
							&nbsp;(em dias)
						</div>
					</div>


					<s:iterator
						value="#session.entidadeSession.empresaRedeEJBList.get(0).empresaHotelEJBList.get(0).empresaGrupoLancamentoEJBList"
						status="row">
						<div class="divLinhaCadastro" style="background-color: white;">
							<div class="divItemGrupo" style="width: 340px;">
								<p style="width: 220px;">
									<s:property value="identificaLancamentoEJB.descricaoLancamento" />
								</p>
								<s:select cssStyle="width:90px;" list="quemPagaList"
									name="quemPagaSelecionado" value="quemPaga" listKey="id"
									listValue="value" />
							</div>

							<s:if test="#row.index == 0">
								<div class="divItemGrupo" style="width: 25px;">
									<img src="imagens/iconic/png/loop-circular-3x.png" title="Inventer despesas"
										onclick="inverterDespesas()" />
								</div>
							</s:if>
						</div>
					</s:iterator>


				</div>


				<!-- Grupo dados tarifa -->

				<div class="divGrupo" style="height: 400px;">
					<div class="divGrupoTitulo">Tarifa</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 350px;">
							<p style="width: 100px;">Grupo de tarifa:</p>
							<s:select list="#session.grupoTarifaList" cssStyle="width:150px;"
								listKey="idTarifaGrupo" listValue="descricao" headerKey=""
								headerValue="Todos" name="idGrupoTarifa"
								onchange="selecionarTarifa(this.value)" />
						</div>
					</div>



					<div class="divLinhaCadastroPrincipal"
						style="background-color: rgb(49, 115, 255);">

						<div class="divItemGrupo"
							style="width: 420px; background-color: rgb(49, 115, 255)">
							<p style="width: 200px; float: left">Tarifa</p>
							<p style="width: 80px; float: left">&nbsp;Data entrada</p>
							<p style="width: 80px; float: left">&nbsp;Data saída</p>
							<p style="width: 50px; float: left">
								&nbsp;<b>(Hotel)</b>
							</p>
						</div>

						<div class="divItemGrupo" style="width: 30px;">&nbsp;</div>

						<div class="divItemGrupo"
							style="width: 430px; background-color: rgb(49, 115, 255)">
							<p style="width: 200px; float: left">Tarifa</p>
							<p style="width: 80px; float: left">&nbsp;Data entrada</p>
							<p style="width: 80px; float: left">&nbsp;Data saída</p>
							<p style="width: 50px; float: left">
								&nbsp;<b>(Empresa)</b>
							</p>
						</div>

					</div>

					<div class="divLinhaCadastro" style="height: 300px">

						<div id="divTarifas" class="divItemGrupo"
							style="width: 420px; height: 300px; overflow-y: auto;">

							<ul style="margin: 0px; padding: 0px;">
								<s:iterator value="#session.tarifaList" status="idxTarifa">
									<li ondblclick="adicionarTarifa(this);"
										style="width: 100%; cursor: pointer; margin-bottom: 2px;"
										class="linhaTarifa"
										id="<s:property value="#idxTarifa.index" />;<s:property value="dataEntrada" />;<s:property value="dataSaida" />;<s:property value="descricao" />;<s:property value="tarifaGrupo.idTarifaGrupo" />">
										<p style="width: 200px; float: left">
											<s:property value="descricao" />
										</p>
										<p style="width: 80px; float: left">
											&nbsp;
											<s:property value="dataEntrada" />
										</p>
										<p style="width: 80px; float: left">
											&nbsp;
											<s:property value="dataSaida" />
										</p>
									</li>
								</s:iterator>
							</ul>

						</div>

						<div class="divItemGrupo"
							style="width: 30px; height: 300px; background-color: silver;">

						</div>

						<div class="divItemGrupo"
							style="width: 420px; height: 300px; overflow-y: auto;">
							<ul style="margin: 0px; padding: 0px;" id="tarifaDestino">
								<s:iterator
									value="#session.entidadeSession.empresaRedeEJBList.get(0).empresaHotelEJBList.get(0).empresaTarifaEJBList"
									status="linhaTarifa">
									<li style="width: 100%; cursor: pointer; margin-bottom: 2px;"
										ondblclick="removerTarifa(this);"
										id="<s:property value="#linhaTarifa.index" />;<s:property value="tarifaEJB.dataEntrada" />;<s:property value="tarifaEJB.dataSaida" />">
										<p style="width: 200px; float: left">
											<s:property value="tarifaEJB.descricao" />
										</p>
										<p style="width: 80px; float: left">
											&nbsp;
											<s:property value="tarifaEJB.dataEntrada" />
										</p>
										<p style="width: 80px; float: left">
											&nbsp;
											<s:property value="tarifaEJB.dataSaida" />
										</p>
									</li>
								</s:iterator>
							</ul>
						</div>

					</div>


				</div>

			</s:else>
			</div>
			<div id="divDadosLegais">
				<s:if test="%{!bloquearEmpresa}">
					<!-- Grupo dados junta comercial -->
	
					<div class="divGrupo" style="height: 80px;">
						<div class="divGrupoTitulo">Junta comercial (Opcional)</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Fundação:</p>
								<s:textfield name="entidade.empresaJuntaEJB.junta1"
									maxlength="30" size="15" />
							</div>
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Data:</p>
								<s:textfield id="dataInicio"
									name="entidade.empresaJuntaEJB.dataCadastro1" size="15"
									onblur="dataValida(this)" maxlength="10"
									onkeypress="mascara(this,data)" cssClass="dp" />
							</div>
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Capital:</p>
								<s:textfield name="entidade.empresaJuntaEJB.capital"
									maxlength="15" size="15" />
							</div>
	
						</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Últ. Alteração:</p>
								<s:textfield name="entidade.empresaJuntaEJB.junta2"
									maxlength="30" size="15" />
							</div>
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Data:</p>
								<s:textfield id="dataFim"
									name="entidade.empresaJuntaEJB.dataCadastro2" size="15"
									onblur="dataValida(this)" maxlength="10"
									onkeypress="mascara(this,data)" cssClass="dp" />
							</div>
						</div>
	
					</div>
	
					<!-- Grupo dados sócios -->
	
					<div class="divGrupo" style="height: 120px;">
						<div class="divGrupoTitulo">Sócios (Opcional)</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Nome:</p>
								<s:textfield name="nomeSocio" id="nomeSocio" maxlength="40"
									size="20" />
							</div>
							<div class="divItemGrupo" style="width: 200px;">
								<p style="width: 70px;">CPF:</p>
								<s:textfield id="cpfSocio" name="cpfSocio" size="15"
									onblur="validarCPF(this)" maxlength="14"
									onkeypress="mascara(this,cpf)" />
							</div>
							<div class="divItemGrupo" style="width: 200px;">
								<p style="width: 70px;">Part. %:</p>
								<s:textfield name="participacaoSocio" id="participacaoSocio"
									maxlength="6" size="15" onkeypress="mascara(this,moeda)" />
							</div>
							<div class="divItemGrupo" style="width: 30px; text-align: center;">
								<img width="24px" height="24px" src="imagens/iconic/png/plus-3x.png"
									title="Incluir sócio" onclick="incluirSocio();" />
							</div>
	
						</div>
	
						<div style="width: 99%; height: 60px; overflow-y: auto;">
							<s:iterator value="#session.entidadeSession.empresaSocioEJBList"
								status="row">
								<div class="divLinhaCadastro">
									<div class="divItemGrupo" style="width: 250px;">
										<p style="width: 100%;">
											<s:property value="nome" />
										</p>
									</div>
									<div class="divItemGrupo" style="width: 200px;">
										<p style="width: 100%;">
											<s:property value="cpf" />
										</p>
									</div>
									<div class="divItemGrupo" style="width: 200px;">
										<p style="width: 100%;">
											<s:property value="participacao" />
										</p>
									</div>
									<div class="divItemGrupo"
										style="width: 30px; text-align: center;">
										<img width="24px" height="24px" src="imagens/iconic/png/x-3x.png"
											title="Excluir sócio" onclick="excluirSocio('${row.index}')" />
									</div>
								</div>
							</s:iterator>
						</div>
	
					</div>
	
	
					<!-- Grupo ref bancária -->
	
					<div class="divGrupo" style="height: 175px;">
						<div class="divGrupoTitulo">Referências (Opcional)</div>
	
						<div class="divLinhaCadastro" style="height: 45px;">
							<div class="divItemGrupo" style="width: 220px;">
								<p style="width: 100px;">Nome:</p>
								<s:textfield name="nomeBanco" id="nomeBanco" maxlength="50"
									size="30" onblur="toUpperCase(this);" />
							</div>
							<div class="divItemGrupo" style="width: 200px;">
								<p style="width: 80px;">Contato:</p>
								<s:textfield id="contatoBanco" name="contatoBanco" size="30"
									onblur="toUpperCase(this);" maxlength="30" />
							</div>
							<div class="divItemGrupo" style="width: 120px;">
								<p style="width: 80px;">Telefone:</p>
								<s:textfield name="telefoneBanco" id="telefoneBanco"
									maxlength="15" size="16" onkeypress="mascara(this,telefone)" />
							</div>
							<div class="divItemGrupo" style="width: 200px;">
								<p style="width: 80px;">E-mail:</p>
								<s:textfield id="emailBanco" name="emailBanco" size="30"
									maxlength="50" onblur="toUpperCase(this);" />
							</div>
							<div class="divItemGrupo" style="width: 150px;">
								<p style="width: 70px;">Tipo:</p>
								<s:select list="tipoReferenciaList" listKey="id"
									listValue="value" cssStyle="width:100px;" name="tipoReferencia" />
							</div>
							<div class="divItemGrupo" style="width: 30px; text-align: center;">
								<img width="24px" height="24px" src="imagens/iconic/png/plus-3x.png"
									title="Incluir sócio" onclick="incluirReferencia();" />
							</div>
	
						</div>
	
						<div style="width: 99%; height: 60px; overflow-y: auto;">
							<s:iterator
								value="#session.entidadeSession.empresaReferenciaEJBList"
								status="row">
								<div class="divLinhaCadastro">
									<div class="divItemGrupo" style="width: 220px;">
										<p style="width: 100%;">
											<s:property value="razaoSocial" />
										</p>
									</div>
									<div class="divItemGrupo" style="width: 200px;">
										<p style="width: 100%;">
											<s:property value="contato" />
										</p>
									</div>
									<div class="divItemGrupo" style="width: 120px;">
										<p style="width: 100%;">
											<s:property value="telefone" />
										</p>
									</div>
									<div class="divItemGrupo" style="width: 200px;">
										<p style="width: 100%;">
											<s:property value="email" />
										</p>
									</div>
									<div class="divItemGrupo" style="width: 150px;">
										<p style="width: 100%;">
											<s:if test='%{tipo == "B"}'>
													Bancária
												</s:if>
											<s:else>
													Comercial
												</s:else>
										</p>
									</div>
									<div class="divItemGrupo"
										style="width: 30px; text-align: center;">
										<img width="24px" height="24px" src="imagens/iconic/png/x-3x.png"
											title="Excluir referência"
											onclick="excluirReferencia('${row.index}')" />
									</div>
								</div>
							</s:iterator>
						</div>
	
					</div>
					<!-- fim -->
				</s:if>
				<s:else>
	
					<!-- Grupo dados junta comercial -->
	
					<div class="divGrupo" style="height: 80px;">
						<div class="divGrupoTitulo">Junta comercial (Opcional)</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Fundação:</p>
	
								<s:property value="entidade.empresaJuntaEJB.junta1" />
								<s:hidden name="entidade.empresaJuntaEJB.junta1" />
	
							</div>
	
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Data:</p>
								<s:property value="entidade.empresaJuntaEJB.dataCadastro1" />
								<s:hidden name="entidade.empresaJuntaEJB.dataCadastro1" />
	
							</div>
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Capital:</p>
	
								<s:property value="entidade.empresaJuntaEJB.capital" />
								<s:hidden name="entidade.empresaJuntaEJB.capital" />
	
							</div>
	
						</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Últ. Alteração:</p>
	
								<s:property value="entidade.empresaJuntaEJB.junta2" />
								<s:hidden name="entidade.empresaJuntaEJB.junta2" />
	
							</div>
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Data:</p>
								<s:property value="entidade.empresaJuntaEJB.dataCadastro2" />
								<s:hidden name="entidade.empresaJuntaEJB.dataCadastro2"></s:hidden>
	
							</div>
						</div>
	
					</div>
	
					<!-- Grupo dados sócios -->
	
					<div class="divGrupo" style="height: 120px;">
						<div class="divGrupoTitulo">Sócios (Opcional)</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 250px;">
								<p style="width: 100px;">Nome</p>
	
							</div>
							<div class="divItemGrupo" style="width: 200px;">
								<p style="width: 70px;">CPF</p>
							</div>
							<div class="divItemGrupo" style="width: 200px;">
								<p style="width: 70px;">Part. %</p>
	
							</div>
							<div class="divItemGrupo" style="width: 30px; text-align: center;">
								&nbsp;</div>
	
						</div>
	
						<div style="width: 99%; height: 60px; overflow-y: auto;">
							<s:iterator value="#session.entidadeSession.empresaSocioEJBList"
								status="row">
								<div class="divLinhaCadastro">
									<div class="divItemGrupo" style="width: 250px;">
										<s:property value="nome" />
									</div>
									<div class="divItemGrupo" style="width: 200px;">
										<s:property value="cpf" />
									</div>
									<div class="divItemGrupo" style="width: 200px;">
										<s:property value="participacao" />
									</div>
									<div class="divItemGrupo"
										style="width: 30px; text-align: center;">&nbsp;</div>
								</div>
							</s:iterator>
						</div>
	
					</div>
	
	
					<!-- Grupo ref bancária -->
	
					<div class="divGrupo" style="height: 175px;">
						<div class="divGrupoTitulo">Referências (Opcional)</div>
	
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 220px;">
								<p style="width: 100px;">Nome</p>
	
							</div>
							<div class="divItemGrupo" style="width: 200px;">
								<p style="width: 80px;">Contato</p>
	
							</div>
							<div class="divItemGrupo" style="width: 120px;">
								<p style="width: 80px;">Telefone</p>
	
							</div>
							<div class="divItemGrupo" style="width: 200px;">
								<p style="width: 80px;">E-mail</p>
	
							</div>
							<div class="divItemGrupo" style="width: 150px;">
								<p style="width: 70px;">Tipo</p>
							</div>
							<div class="divItemGrupo" style="width: 30px; text-align: center;">
								&nbsp;</div>
	
						</div>
	
						<div style="width: 99%; height: 60px; overflow-y: auto;">
							<s:iterator
								value="#session.entidadeSession.empresaReferenciaEJBList"
								status="row">
								<div class="divLinhaCadastro">
									<div class="divItemGrupo" style="width: 220px;">
										<s:property value="razaoSocial" />
									</div>
									<div class="divItemGrupo" style="width: 200px;">
										<s:property value="contato" />
									</div>
									<div class="divItemGrupo" style="width: 120px;">
										<s:property value="telefone" />
									</div>
									<div class="divItemGrupo" style="width: 200px;">
										<s:property value="email" />
									</div>
									<div class="divItemGrupo" style="width: 150px;">
										<s:if test='%{tipo == "B"}'>
													Bancária
												</s:if>
										<s:else>
													Comercial
												</s:else>
									</div>
									<div class="divItemGrupo"
										style="width: 30px; text-align: center;">&nbsp;</div>
								</div>
							</s:iterator>
						</div>
	
					</div>
					<!-- fim -->

				</s:else>
			</div>

			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
					onClick="gravar()" />
			</div>

		</div>
	</div>


</s:form>