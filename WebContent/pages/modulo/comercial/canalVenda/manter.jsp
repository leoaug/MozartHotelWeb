<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
		window.onload = function() {
		
			addPlaceHolder('empresa');
			addPlaceHolder('empresaAdmCanal');
		};
		
		function addPlaceHolder(classe) {
			document.getElementById(classe).setAttribute("placeholder",
					"ex.: digite o nome da empresa");
		}

	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarCanal!prepararPesquisa.action" namespace="/app/comercial" />';
		submitForm(vForm);
	}

	function gravar() {

		if ($("input[name='entidade.empresa.idEmpresa']").val() == '') {
			alerta('Campo "Nome Fantasia" é obrigatório.');
			return false;
		}
		if ($("input[name='entidade.codigo']").val() == '') {
			alerta('Campo "Código" é obrigatório.');
			return false;
		}
		if ($("input[name='entidade.administradorCanais.empresaRede.idEmpresa']").val() == '') {
			alerta('Campo "Administrador do Canal" é obrigatório.');
			return false;
		}
		submitForm(document.forms[0]);
	}

	function getEmpresa(elemento,idHidden) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarEmpresa?OBJ_NAME='
				+ elemento.id
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN='
				+ idHidden
				;
		getDataLookup(elemento, url,'Empresa', 'TABLE');
	}
	function getGds(elemento,idHidden) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarGds?OBJ_NAME='
				+ elemento.id
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN='
				+ idHidden
				;
		getDataLookup(elemento, url,'Gds', 'TABLE');
	}
</script>


<s:form namespace="/app/comercial" action="manterCanal!gravar.action"
	theme="simple">

	<s:hidden name="entidade.idGdsCanal" />
	<div class="divFiltroPaiTop">Canal de Vendas</div>
	<div class="divFiltroPai">
		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 400px;">
				<div class="divGrupoTitulo">Dados do canal</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 500px;">
						<p style="width: 150px;">Nome Fantasia:</p>
						<s:textfield onblur="getEmpresa(this,'idEmpresa')"
							name="entidade.empresa.empresaRedeEJB.nomeFantasia" size="40" maxlength="50"
							id="empresa" />
						<s:hidden name="entidade.empresa.idEmpresa" id="idEmpresa" />
					</div>
					<div class="divItemGrupo" style="width: 250px;">
						<p style="width: 100px;">Código:</p>
						<s:textfield maxlength="15" name="entidade.codigo"
							id="entidade.email" size="15" onblur="toUpperCase(this)" />
					</div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 100px;">Ativo:</p>
							<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
							listValue="value" cssStyle="width:50px;" name="entidade.ativo" />
					</div>
				</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 500px;">
						<p style="width: 150px;">Administrador do Canal:</p>
						<s:textfield maxlength="40" name="entidade.administradorCanais.empresaRedeEJB.nomeFantasia"
							onblur="getGds(this,'idEmpresaAdmCanal')"
							id="empresaAdmCanal" size="40" />
						<s:hidden name="entidade.administradorCanais.idGds" id="idEmpresaAdmCanal" />
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