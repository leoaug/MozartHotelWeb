<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
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
	function validarEmpresa(cnpj){

		if (cnpj != '' && cnpj != null){
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
		}
	}

	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarEmpresa!prepararPesquisa.action" namespace="/app/sistema" />';
		submitForm(vForm);
	}

	function gravar() {

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

		if ($("input[name='entidade.razaoSocial']").val() == '') {
			alerta('Campo "Razão social" é obrigatório.');
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
			alerta('Campo "CEP" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.cidade']").val() == '') {
			alerta('Campo "Cidade" é obrigatório.');
			return false;
		}

		if ($("#nacional").val() == 'N') {

			$("input[name='entidade.cgc']").val(
					$("input[name='entidade.codigo']").val());

		}

		submitForm(document.forms[0]);

	}

	function getCidadeEmpresaLookup(elemento) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarCidade?OBJ_NAME='
				+ elemento.id
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=idCidadeEmpresa';
		getDataLookup(elemento, url, 'divEmpresa', 'TABLE');
	}
</script>


<s:form namespace="/app/sistema"
	action="manterEmpresa!gravarEmpresa.action" theme="simple">

	<s:hidden name="entidade.cgc" />
	<s:hidden name="entidade.idEmpresa" />
	<div class="divFiltroPaiTop">Empresa</div>
	<div class="divFiltroPai">

		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 235px;">
				<div class="divGrupoTitulo">Dados do Fornecedor</div>



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

					<div id="divCNPJ" class="divItemGrupo" style="width: 300px;<s:if test='%{entidade.nacional != "1"}'>display: none;</s:if>">
						<p style="width: 100px;">CNPJ:</p>
						<s:textfield id="cnpjEmpresa" name="empresaCnpj" maxlength="18"
							size="20" onkeypress="mascara(this, cnpj)"
							onblur="validarEmpresa(this.value)" />
					</div>
					
					<div id="divCPF" class="divItemGrupo" style="width: 300px; <s:if test='%{entidade.nacional != "2"}'>display: none;</s:if>">
						<p style="width: 100px;">CPF:</p>
						<s:textfield id="cpfEmpresa" name="empresaCpf" maxlength="14"
							size="16" onkeypress="mascara(this, cpf)"
							onblur="validarEmpresa(this.value)" />
					</div>

					<div id="divCodigo" class="divItemGrupo"
						style="width: 300px; <s:if test='%{entidade.nacional != "3"}'>display: none;</s:if>">
						<p style="width: 100px;">Código:</p>
						<s:textfield id="codEmpresa" name="entidade.codigo" maxlength="18"
							size="20" />
					</div>

				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 500px;">
						<p style="width: 100px;">Razão Social:</p>
						<s:textfield name="entidade.razaoSocial" required="true"
							maxlength="40" size="70"
							onblur="toUpperCase(this);setValue('empresaRede.nomeFantasia', this.value);"></s:textfield>
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 400px;">
						<p style="width: 100px;">Endereço:</p>
						<s:textfield name="entidade.endereco" maxlength="40" size="50"
							onblur="toUpperCase(this);setValue('empresaHotel.enderecoCobranca',this.value);" />
					</div>
					<div class="divItemGrupo" style="width: 180px;">
						<p style="width: 100px;">Número:</p>
						<s:textfield name="entidade.numero" maxlength="40" size="5"
							onblur="mascara(this,numero);" />
					</div>
					<div class="divItemGrupo" style="width: 300px;">
						<p style="width: 100px;">Complemento:</p>
						<s:textfield name="entidade.complemento" maxlength="40" size="20"
							onblur="toUpperCase(this);" />
					</div>
					
				</div>


				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 300px;">
						<p style="width: 100px;">Bairro:</p>
						<s:textfield name="entidade.bairro" maxlength="30" size="30"
							onblur="toUpperCase(this);setValue('empresaHotel.bairro',this.value);" />
					</div>

					<div class="divItemGrupo" style="width: 300px;">
						<p style="width: 100px;">CEP:</p>
						<s:textfield name="entidade.cep" maxlength="9" size="15"
							onkeypress="mascara(this, cep)"
							onblur="setValue('empresaHotel.cep',this.value);" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 500px;">
						<p style="width: 100px;">Cidade:</p>

						<s:textfield name="entidade.cidade.cidade" id="cidadeEmpresa"
							maxlength="50" size="40" onblur="getCidadeEmpresaLookup(this)" />
						<s:hidden name="entidade.cidade.idCidade" id="idCidadeEmpresa" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 300px;">
						<p style="width: 100px;">Insc. Estadual:</p>
						<s:textfield name="entidade.inscEstadual" maxlength="20" size="20" />
					</div>

					<div class="divItemGrupo" style="width: 300px;">
						<p style="width: 100px;">Insc. Municipal:</p>
						<s:textfield name="entidade.inscMunicipal" maxlength="10"
							size="20" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 500px;">
						<p style="width: 100px;">Tipo Empresa:</p>
						<s:select list="tipoEmpresaList" cssStyle="width:200px;"
							headerKey="" headerValue="Selecione" listKey="id"
							listValue="value" name="entidade.tipo" />
					</div>
				</div>

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