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

		if ($("input[name='entidade.cidade']").val() == '') {
			alerta('Campo "Cidade" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.estado']").val() == '') {
			alerta('Campo "Estado" é obrigatório.');
			return false;
		}

		submitForm(document.forms[0]);

	}
</script>

<s:form namespace="/app/sistema"
	action="manterAchadosPerdido!gravar.action" theme="simple">

	<s:hidden name="entidade.idAchadosPerdidos" />
	<div class="divFiltroPaiTop">Gerar NFS-e</div>
	<div class="divFiltroPai">


		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 50px;">
				<div class="divGrupoTitulo">Período</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 210px;">
						<p style="width: 50px;">De:</p>
						<s:textfield cssClass="dp" name="entidade.data"
							onkeypress="mascara(this,data);" id="entidade.data" size="10"
							maxlength="10" />
					</div>
					<div class="divItemGrupo" style="width: 210px;">
						<p style="width: 50px;">Até:</p>
						<s:textfield cssClass="dp" name="entidade.data"
							onkeypress="mascara(this,data);" id="entidade.data" size="10"
							maxlength="10" />
					</div>
				</div>

			</div>
			<div class="divGrupo" style="height: 50px;">
				<div class="divGrupoTitulo">Dados do Arquivo</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 800px;">
						<p style="width: 150px;">Nome do Arquivo:</p>
						<s:textfield name="entidade.data" onkeypress="mascara(this,data);"
							id="entidade.data" size="60" />
					</div>
				</div>

			</div>
			<div class="divGrupo"  style="height: 320px;" >
				<div class="divGrupoTitulo">RPS - Recibo Prestação de Serviço</div>

				
				
				<iframe width="100%" height="260" id="idRPSFrame" scrolling="no" frameborder="0" marginheight="0" marginwidth="0" src="<s:url value="app/sistema/includeRPS!prepararRPS.action"/>?time=<%=new java.util.Date()%>"  ></iframe>
                  
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo"  style="width:25px; float:left;" >
						<s:checkbox id="entidade.data" name="entidade.data" title="Selecionar Todos"/> 
                    </div>                    
                    <div class="divItemGrupo"  style="width:320pt; float:left;" >
	                    <p>Selecionar Todos</p> 
                    </div>                    
                </div>
			</div>

			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
					onClick="cancelar()" />
				<duques:botao style="width:110px "  label="Gerar Lote" imagem="imagens/iconic/png/check-4x.png"
					onClick="gravar()" />
			</div>

		</div>
	</div>
</s:form>