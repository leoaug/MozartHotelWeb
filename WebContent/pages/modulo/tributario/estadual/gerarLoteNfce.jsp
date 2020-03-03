<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarIss!prepararPesquisa.action" namespace="/app/sistema" />';
		submitForm(vForm);
	}
	
	function consultarDatas() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="gerarLoteIss!prepararLotes.action" namespace="/app/sistema" />';
		submitForm(vForm);
	}

	function gravar() {

		if ($("input[name='nomeArquivo']").val() == '') {
			alerta('Campo "Nome do Arquivo" é obrigatório.');
			return false;
		}

		iFrameRPS = document.getElementById('idRPSFrame');
	
   	   	if(iFrameRPS != null){
   	   	 	if(!iFrameRPS.contentWindow.validarObrigatoriedadeRps()){
   	   	 		alerta('A Seleção de Nota é obrigatória.');
				return false;
   	   	 	}
   	   	 	
   	   		iFrameRPS.contentWindow.preencherIdsRps();
   	   		vForm = document.forms[0];
			vForm.action = '<s:url action="gerarLoteIss!gerarLote.action" namespace="/app/sistema" />';
			submitForm(vForm);
		}
	}
	
	function downloadLote() {
		if ($("input[name='nomeArquivo']").val() == '') {
			alerta('Campo "Nome do Arquivo" é obrigatório.');
			return false;
		}

		iFrameRPS = document.getElementById('idRPSFrame');
	
   	   	if(iFrameRPS != null){
   	   	 	if(!iFrameRPS.contentWindow.validarObrigatoriedadeRps()){
   	   	 		alerta('A Seleção de Nota é obrigatória.');
				return false;
   	   	 	}
   	   	 	
   	   		iFrameRPS.contentWindow.preencherIdsRps();
   	   	
			url = '${sessionScope.URL_BASE}app/ajax/ajax!downloadXmlNotaFiscal?OBJ_NAME='
					+ $("input[name='nomeArquivo']").val()
					+ '&OBJ_VALUE='
					+ $("#rpsSelecionadasString").val();
			getAjaxValue(url, ajaxCallback);
   	   	}
    }
    
    function ajaxCallback(data) {
    	var contentType = 'text/plain;charset=windows-1252';
        var blob=new Blob([data], {type: contentType});
        var link=document.createElement('a');
        link.href=window.URL.createObjectURL(blob);
        link.download="Lote_"+new Date()+".xml";
        link.click();
        //gravar();
    }

    function download(){
    	vForm = document.forms[0];
		vForm.action = '<s:url action="gerarLoteIss!downloadLote.action" namespace="/app/sistema" />';
		submitForm(vForm);
		KillModal();
    }
	
	function atualizar(){
		submitForm(document.forms[0]);
	}

	 $(function() { 
         $(".chkTodos").click(
                 function() { 
                     newValue = this.checked;
                     $('.RPSFrame').contents().find('.chk').attr('checked',newValue);
                 }
         );
			
     });
</script>
	
<s:form namespace="/app/sistema"
	action="gerarLoteIss!gerarLote.action" theme="simple">

	<div class="divFiltroPaiTop">Gerar NFS-e</div>
	<div class="divFiltroPai">
	<s:hidden name="rpsSelecionadasString" id="rpsSelecionadasString" />
	<s:hidden name="numRpsSelecionadasString" id="numRpsSelecionadasString" />
	
		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 50px;">
				<div class="divGrupoTitulo">Período</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 210px;">
						<p style="width: 50px;">De:</p>
						<s:textfield cssClass="dp" name="filtro.data.valorInicial"
							onkeypress="mascara(this,data);" onchange="consultarDatas();" id="filtro.data.valorInicial"
							size="10" maxlength="10" />
					</div>
					<div class="divItemGrupo" style="width: 210px;">
						<p style="width: 50px;">Até:</p>
						<s:textfield cssClass="dp" name="filtro.data.valorFinal" onchange="consultarDatas();"
							onkeypress="mascara(this,data);" id="filtro.data.valorFinal"
							size="10" maxlength="10" />
					</div>
				</div>

			</div>
			<div class="divGrupo" style="height: 50px;">
				<div class="divGrupoTitulo">Dados do Arquivo</div>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 800px;">
						<p style="width: 150px;">Nome do Arquivo:</p>
						<s:textfield name="nomeArquivo" 
							id="nomeArquivo" size="60" />
					</div>
				</div>

			</div>
			<div class="divGrupo" style="height: 320px;">
				<div class="divGrupoTitulo">RPS - Recibo Prestação de Serviço</div>



				<iframe width="100%" height="260" id="idRPSFrame" class="RPSFrame" scrolling="no"
					frameborder="0" marginheight="0" marginwidth="0"
					src="<s:url value="app/sistema/includeNfceRPS!prepararRPS.action"/>?time=<%=new java.util.Date()%>"></iframe>

				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 400px; float: left;">
						<input type="checkbox" class="chkTodos"
							id="chk<s:property value="#session.checkinCorrente.empresaHotelEJB.empresaRedeEJB.empresaEJB.idEmpresa" />" />
						Selecionar Todos
					</div>
					<div class="divItemGrupo" style="width: 320pt; float: left;">
					</div>
				</div>
			</div>

			<div class="divCadastroBotoes">
				<duques:botao label="Voltar" imagem="imagens/btnCancelar.png"
					onClick="cancelar()" />
				<duques:botao style="width:110px " label="Gerar Lote"
					imagem="imagens/btnGravar.png" onClick="gravar()" />
			</div>
		</div>
	</div>
	
</s:form>