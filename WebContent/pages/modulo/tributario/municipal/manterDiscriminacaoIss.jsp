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
		
		if ($("input[name='entidade.discriminacao']").val() == '') {
			alerta('Campo "Discriminação" é obrigatório.');
			return false;
		}

		submitForm(document.forms[0]);
	}
	
</script>

<s:form namespace="/app/sistema" action="manterIss!gravarDiscriminacao.action"
	theme="simple">

	<s:hidden name="entidade.idNota" />
	<s:hidden name="entidade.numNota" />
	<s:hidden name="entidade.data" />
	<s:hidden name="entidade.iss" />
	<s:hidden name="entidade.baseCalculo" />
	<div class="divFiltroPaiTop">NFS-e - Discriminação</div>
	<div class="divFiltroPai">


		<div class="divCadastro" style="overflow: auto;">
			
			<div class="divGrupo" style="height: 450px;">

				<div class="divLinhaCadastro" style="height: 400px;">
					<div class="divItemGrupo" style="width: 850px;">
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