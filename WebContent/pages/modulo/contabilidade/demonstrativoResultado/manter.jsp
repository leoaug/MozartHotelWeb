<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	$(function() {

		$("div.divGrupoBody")
				.sortable(
						{
							connectWith : '.divGrupoBody',

							stop : function(ev, ui) {

								if ($('#divGrupo1 .divMovCheckoutBodyItem')
										.index($(ui.item)) >= 0) {
									vId = $(ui.item).attr('id');
									$('div[id="' + vId + '"] .pImg').css(
											'display', 'none');
									if (vId.indexOf('S') == 0
											|| vId.indexOf('T') == 0) {
										$(ui.item).remove();
									}
								} else if ($(
										'#divGrupo2 .divMovCheckoutBodyItem')
										.index($(ui.item)) >= 0) {
									$(
											'div[id="' + $(ui.item).attr('id')
													+ '"] .pImg').css(
											'display', 'block');
								}
								ordenarContas();
							}

						}).disableSelection();

	});

	function ordenarContas() {
		loading();

		for (var x = 0; x < $('div.divGrupoBody').length; x++) {
			grupo = $('div.divGrupoBody')[x];
			itens = $(grupo).sortable('toArray');
			for (var y = 0; y < itens.length; y++) {
				curr = itens[y];
				$("div[id='" + curr + "'] p.ordem").text(y + 1);
			}
		}

		killModal();
	}

	function excluirConta(id) {
		idx = id.substring(3);
		if (confirm('Confirma a exclusão?')) {
			$("div[id='" + idx + "']").remove();
			ordenarContas();
		}
	}

	function incluirSubTotal(id) {
		idx = id.substring(3);
		novoSubTotal = prompt('Informe o título do sub-total:', '');
		novoSubTotal = novoSubTotal.toUpperCase();
		novaOrdem = parseInt($("div[id='" + idx + "'] p.ordem").text(), 10) + 1;

		novoItem = "<div id='S"+novoSubTotal+"' class='divMovCheckoutBodyItem' style='font-size: 8pt; margin: 0px 0px 2px 0px;'>"
				+ "	<p class='ordem' style='top: 0px; margin: 0px; padding: 0px; float: left; height:100%; width:20px; background-color: red; color: white; text-align: center;'>"
				+ novaOrdem
				+ "	</p>"
				+ "	<p style='top: 0px; margin: 0px 0px 0px 5px;  padding: 0px; float: left; color:red;'>"
				+ "		S - "
				+ novoSubTotal
				+ "	</p>"
				+ "	<p class='pImg' style='width:20px; top: 0px; margin: 0px 0px 0px 0px; padding: 0px; float: right;'>"
				+ "		<img id='imgS"
				+ novoSubTotal
				+ "' class='imgExcluir' src='imagens/fecharColuna.png' title='Excluir Sub-Total/Total' onclick='excluirConta(this.id);' /> "
				+ "	</p>"
				+ "	<p class='pImg' style='width:20px; top: 0px; margin: 0px 0px 0px 0px; padding: 0px; float: right;'>"
				+ "		<img id='imgS"
				+ novoSubTotal
				+ "' class='imgIncluirTotal' width='19px' height='20px;' src='imagens/btnIncluir.png' title='Incluir Total' onclick='incluirTotal(this.id);'  />"
				+ "	</p>" + "</div>";
		$(novoItem).insertAfter($("div[id='" + idx + "']"));
		ordenarContas();
	}

	function incluirTotal(id) {
		idx = id.substring(3);
		novoTotal = prompt('Informe o título do total:', '');
		novoTotal = novoTotal.toUpperCase();
		novaOrdem = parseInt($("div[id='" + idx + "'] p.ordem").text(), 10) + 1;

		novoItem = "<div id='T"+novoTotal+"' class='divMovCheckoutBodyItem' style='font-size: 8pt; margin: 0px 0px 2px 0px;'>"
				+ "	<p class='ordem' style='top: 0px; margin: 0px; padding: 0px; float: left; height:100%; width:20px; background-color: blue; color: white; text-align: center;'>"
				+ novaOrdem
				+ "	</p>"
				+ "	<p style='top: 0px; margin: 0px 0px 0px 5px;  padding: 0px; float: left; color:blue;'>"
				+ "		T - "
				+ novoTotal
				+ "	</p>"
				+ "	<p class='pImg' style='width:20px; top: 0px; margin: 0px 0px 0px 0px; padding: 0px; float: right;'>"
				+ "		<img id='imgT"
				+ novoTotal
				+ "' class='imgExcluir' src='imagens/fecharColuna.png' title='Excluir Sub-Total/Total'  onclick='excluirConta(this.id);' /> "
				+ "	</p>" + "</div>";
		$(novoItem).insertAfter($("div[id='" + idx + "']"));
		ordenarContas();
	}

	$('#linhaContabilidade').css('display', 'block');

	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
		submitForm(vForm);
	}

	function gravar() {
		var contas = "";
		var demonstrativos = "";

		for (var x = 0; x < $('div.divGrupoBody').length; x++) {
			grupo = $('div.divGrupoBody')[x];
			itens = $(grupo).sortable('toArray');
			for (var y = 0; y < itens.length; y++) {
				curr = itens[y];
				if (x == 0) {
					contas = contas + curr + '@';
				} else {
					demonstrativos = demonstrativos + curr + '@';
				}
			}
		}

		$('#contas').val(contas);
		$('#demonstrativos').val(demonstrativos);
		submitForm(document.forms[0]);

	}

	function relatorio() {
		document.forms[0].action = '<s:url action="relatorioDemonstrativoResultado.action" namespace="/app/contabilidade" />';
		submitForm(document.forms[0]);
	}
</script>


<s:form action="manterDemonstrativoResultado!gravar.action"
	theme="simple" namespace="/app/contabilidade">
	<s:hidden name="contas" id="contas" />
	<s:hidden name="demonstrativos" id="demonstrativos" />
	<div class="divFiltroPaiTop">Demonstrativo Resultado</div>
	<div class="divFiltroPai">
		
		<div class="divCadastro" style="overflow: auto; height: 200%;">


			<div class="divGrupo" style="width: 400px; height: 400px;">
				<div class="divGrupoTitulo" style="float: left;">Contas</div>
				<div id="divGrupo1" class="divGrupoBody"
					style="margin-top: 0px; height: 90%;">


					<s:iterator value="demonstrativoPlanoContasList" var="obj"
						status="row">
						<div id='<s:property value="idPlanoContas" />'
							class="divMovCheckoutBodyItem"
							style="font-size: 8pt; margin: 0px 0px 2px 0px;">
							<p class="ordem"
								style="top: 0px; margin: 0px; padding: 0px; float: left; height: 100%; width: 20px; background-color: rgb(0, 173, 255); color: white; text-align: center;">
								${row.index + 1}</p>

							<p
								style="top: 0px; margin: 0px 0px 0px 5px; padding: 0px; float: left;">
								<s:property value="contaContabil" />
								-
								<s:property value="nome" />
							</p>

							<p class='pImg'
								style='width: 20px; top: 0px; margin: 0px 0px 0px 0px; padding: 0px; float: right; display: none;'>
								<img
									id='img<s:property value="idPlanoContas==null?tipoConta+nome:idPlanoContas" />'
									class="imgIncluirSubTotal" width="19px" height="20px;"
									src="imagens/iconic/png/plus-3x.png" title="Incluir Sub-Total"
									onclick="incluirSubTotal(this.id)" />
							</p>

						</div>
					</s:iterator>


				</div>
			</div>

			<div class="divGrupo"
				style="width: 400px; height: 400px; float: right; margin-right: 5px;">
				<div class="divGrupoTitulo" style="float: left;">Demonstrativo</div>
				<div id="divGrupo2" class="divGrupoBody"
					style="margin-top: 0px; height: 90%;">
					<s:iterator value="demonstrativoResultadoList" var="objDemo"
						status="rowDemo">
						<div
							id='<s:property value="idPlanoContas==null?tipoConta+nome:idPlanoContas" />'
							class="divMovCheckoutBodyItem"
							style="font-size: 8pt; margin: 0px 0px 2px 0px;">
							<p class="ordem"
								style='top: 0px; margin: 0px; padding: 0px; float: left; height:100%; width:20px; background-color: <s:property value="tipoConta.equals(\"S\")?\"red;\":tipoConta.equals(\"T\")?\"blue;\":\"rgb(0, 173, 255);\" " /> color: white; text-align: center;'>
								${rowDemo.index + 1}</p>

							<p
								style='top: 0px; margin: 0px 0px 0px 5px;  padding: 0px; float: left;<s:property value="tipoConta.equals(\"S\")?\"color:red;\":tipoConta.equals(\"T\")?\"color:blue;\":\"\" " />'>
								<s:property value="contaContabil==null?tipoConta:contaContabil" />
								-
								<s:property value="nome" />
							</p>

							<s:if test="%{!tipoConta.equals(\"C\")}">

								<p class='pImg'
									style='width: 20px; top: 0px; margin: 0px 0px 0px 0px; padding: 0px; float: right;'>
									<img
										id='img<s:property value="idPlanoContas==null?tipoConta+nome:idPlanoContas" />'
										class="imgExcluir" src="imagens/fecharColuna.png"
										title="Excluir Sub-Total/Total"
										onclick="excluirConta(this.id)" />
								</p>

								<s:if test="%{tipoConta.equals(\"S\")}">
									<p class='pImg'
										style='width: 20px; top: 0px; margin: 0px 0px 0px 0px; padding: 0px; float: right;'>
										<img
											id='img<s:property value="idPlanoContas==null?tipoConta+nome:idPlanoContas" />'
											class="imgIncluirTotal" width="19px" height="20px;"
											src="imagens/iconic/png/plus-3x.png" title="Incluir Total"
											onclick="incluirTotal(this.id)" />
									</p>
								</s:if>


							</s:if>
							<s:else>
								<p class='pImg'
									style='width: 20px; top: 0px; margin: 0px 0px 0px 0px; padding: 0px; float: right;'>
									<img
										id='img<s:property value="idPlanoContas==null?tipoConta+nome:idPlanoContas" />'
										class="imgIncluirSubTotal" width="19px" height="20px;"
										src="imagens/iconic/png/plus-3x.png" title="Incluir Sub-Total"
										onclick="incluirSubTotal(this.id)" />
								</p>
							</s:else>

						</div>
					</s:iterator>

				</div>
			</div>

			
           <div class="divCadastroBotoes">
                  <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                  <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
                  <duques:botao label="Relatório" 	imagem="imagens/iconic/png/print-3x.png" onClick="relatorio();" />
           </div>
              
        </div>
</div>
</s:form>
