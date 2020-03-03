<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	$(document).ready(function() {
		//$('#idResumo').markItUp(myHtmlSettings);
		//$('#idCaracteristica').markItUp(myHtmlSettings);
		$('#idCaracteristica').wysiwyg();
		$('#idResumo').wysiwyg();

	});

	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTransferenciaFotos!prepararInclusao.action" namespace="/app/comercial" />';
		submitForm(vForm);
	}

	function gravar() {

		submitForm(document.forms[0]);
	}
</script>


<s:form namespace="/app/comercial"
	action="manterCaracteristicaGeral!gravar.action" theme="simple" >

	<s:hidden name="entidade.idCaracteristicasGerais" />
	<div class="divFiltroPaiTop">Transferência de fotos</div>
	<div class="divFiltroPai">
			
		<div class="divCadastro" style="overflow: auto;">
				<div class="divLinhaCadastro" >
					<div class="divItemGrupo" style="width: 400px;">Caminho:
					<s:file ></s:file>
					</div>
				</div>

			<div class="divGrupo" style="width: 400px; height: 400px;">
				<div class="divGrupoTitulo">A transferir</div>
				<div class="divLinhaCadastro" >
					<div class="divItemGrupo" style="width: 250px;">
					</div>
				</div>
			</div>
			<div class="divGrupo"style="width: 400px; height: 400px; float: right; margin-right: 5px;">
				<div class="divGrupoTitulo">Transferidas</div>
				<div class="divLinhaCadastro" >
					<div class="divItemGrupo" style="width: 250px; ">
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