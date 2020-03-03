<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<jsp:include page="/pages/modulo/includes/cache.jsp" />

<!--meta http-equiv="refresh" content="15" /-->
<script type="text/javascript">

    function init(){
        
    }
    
</script>

<script>
currentMenu = "divApto";
with(milonic=new menuname("divAptoOcupado")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:alterarCheckin();");
aI("image=imagens/setaSaidaApto.png;text=Lançar/Fechar;url=javascript:abrirCheckout();");
aI("image=imagens/btnTransferirApto.png;text=Transferir;url=javascript:transferirApto();");
drawMenus(); 
} 

with(milonic=new menuname("divApto")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/setaEntradaApto.png;text=Abrir Conta;url=javascript:realizaCheckin();");
drawMenus(); 
} 

with(milonic=new menuname("menuDestravar")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/iconic/png/lock-unlocked-4x.png;text=Destravar Conta;url=javascript:destravarApto();");
	drawMenus(); 
	} 
function destravarApto(){
    if (validaId()){
        loading();
        vForm = document.forms[0];
        vForm.idReserva.value = vForm.id.value;
        vForm.action = '<s:url action="caixaGeral!destravarApartamento.action" namespace="/app/contacorrente" />';
        vForm.submit();
    }

}

function realizaCheckin(){
    
    if (validaId()){
       loading();
       vForm = document.forms[0];
       vForm.apartamento.value = vForm.id.value;
       vForm.action = '<s:url action="manterAbertura!prepararInclusaoAbertura.action" namespace="/app/contacorrente" />';
       vForm.submit();
    }
}
</script>

<script type="text/javascript">

    
    function mouseOut(id){
    
    
    }

    function validaId(){
        
        if ($('#id').val() == ''){
            alerta('Selecione um apartamento');
            return false;
        }
        
        return true;
    
    }

    function transferirApto(){
        if (validaId()){
	        valor = $('#id').val();
	        apto = $("div[id='"+valor+"'] h1").text();
	        $('#labelApto').text(apto);        
	
	        url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarContaCorrenteNaoAberta?OBJ_VALUE='+valor;
	        showModal('#divTransferencia');
	        preencherCombo('idApartamentoDestino1', url);        
	        //idApartamentoDestino1 ajax pra pegar os aptos livres
        }
        
    }

    function gravarTransferencia(){
        if ($('#motivoTransferencia').val() == ''){
            alerta("O campo 'Motivo' é obrigatório.");
            return false;
        }
        if ($('#idApartamentoDestino1').val() == ''){
            alerta("O campo 'Apartamento' é obrigatório.");
            return false;
        }
        
        vForm = document.forms[0];
        vForm.motivoTransferencia.value = $('#motivoTransferencia').val();
        $('#idDestino').val( $('#idApartamentoDestino1').val() );
        vForm.action = '<s:url action="caixaGeral!transferirApartamento.action" namespace="/app/contacorrente" />';
        submitForm( vForm );
    }

    function abrirCheckout(){
    
        if (validaId()){
	        loading();
	        vForm = document.forms[0];
	        vForm.action = '<s:url action="manterLancamento!prepararFechamento.action" namespace="/app/contacorrente" />';
	        vForm.submit();
        }
        
    }

    function filtrar(pTipoFiltro){
    
        loading();
        vForm = document.forms[0];
        vForm.tipoPesquisa.value = pTipoFiltro; 
        vForm.submit();
    }
    
    
    function filtrarApto(valor){
    
        if (valor == -1){
            //filtrar('TODOS');
            return false;
        }else{
            $('#id').val( valor );
            filtrar('APARTAMENTO');
        
        }
    
    }

    function alterarCheckin(){
    
        if (validaId()){
	        loading();
	        vForm = document.forms[0];
	        vForm.idCheckin.value = vForm.id.value;
	        vForm.action = '<s:url action="manterAbertura!prepararAlteracao.action" namespace="/app/contacorrente" />';
	        vForm.submit();
        }
    }

    function realizaCheckinFast(){
    
        if (validaId()){
            
        loading();
        vForm = document.forms[0];
        vForm.idReserva.value = vForm.id.value;
        vForm.action = '<s:url action="manterFast!preparaManterFast.action" namespace="/app/contacorrente" />';
        vForm.submit();
        }
    }
	
    function fecharTransferencia(){
   		vForm = document.forms[0];
   		vForm.action = '<s:url action="pesquisar!prepararLancamento.action" namespace="/app/contacorrente" />';
   		submitForm(vForm);
    }

</script>

<div style="display: none"><%=new java.util.Date()%></div>

<s:form action="pesquisar!prepararLancamento.action"
	namespace="/app/contacorrente" theme="simple">
	<input type="hidden" name="id" id="id" />
	<s:hidden name="entidade.idCheckin" id="idCheckin" />
	<s:hidden name="idReserva" id="idReserva" />
	<s:hidden name="idApartamento" id="apartamento" />

	<s:hidden name="tipoPesquisa" id="tipoPesquisa" />
	<input type="hidden" name="classe" id="classe" />

	<s:hidden name="motivoTransferencia" id="motivo" />
	<s:hidden name="idApartamentoDestino" id="idDestino" />

	<!--Div transferencia-->
	<div id="divTransferencia" class="divCadastro"
		style="display: none; height: 310px; width: 600px;">

		<div class="divGrupo" style="width: 98%; height: 220px">
			<div class="divGrupoTitulo">Transferência</div>
			<div class="divGrupoBody">
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 150pt; color: red">
						<p style="width: 100px;">Apto:</p>
						<label id="labelApto">101</label>
					</div>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 310pt;">
						<p style="width: 100px;">Destino:</p>
						<s:select cssStyle="width:180px;" list="#session.listaAptoLivre"
							listKey="idApartamento" listValue="numApartamento" name="idApartamentoDestino1"
							id="idApartamentoDestino1" />
					</div>
				</div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 310pt;">
						<p style="width: 100px;">Motivo:</p>
						<s:textfield size="30" maxlength="50" name="motivoTransferencia1"
							id="motivoTransferencia" />
					</div>
				</div>


			</div>
		</div>

		<div class="divCadastroBotoes" style="width: 98%;">
			<duques:botao label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png"
				onClick="fecharTransferencia()" />
			<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
				onClick="gravarTransferencia()" />
		</div>
	</div>
	<!--final Div transferencia-->



	<div class="divFiltroPaiTop" style="width: 210px;">Movimentação</div>
	<div class="divFiltroPai">

		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 510px; width: 250px;">
				<div class="divGrupoTitulo">Opções</div>
				<div class="divAptoOpcoes">
					<ul>
						<li onclick="filtrar('CHECKOUT_AGORA')"
							onmouseover="$(this).css('background-color','rgb(181,231,255)');"
							onmouseout="$(this).css('background-color','');"><img
							src="imagens/iconic/png/imgContas-4x.png" title="Entrada do dia" />
							<p>Fechando Conta</p>
							<p id="qtdeCheckoutAgora" style="color: red"></p></li>
						<li onclick="filtrar('OCUPADO')"
							onmouseover="$(this).css('background-color','rgb(181,231,255)');"
							onmouseout="$(this).css('background-color','');"><img
							src="imagens/casaOcupada.png" title="Ocupado" />
							<p>Aberta</p>
							<p id="qtdeOcupado" style="color: red"></p></li>
						<li onclick="filtrar('LIVRE')"
							onmouseover="$(this).css('background-color','rgb(181,231,255)');"
							onmouseout="$(this).css('background-color','');"><img
							src="imagens/aptoLivre.png" title="Livre" />
							<p>Disponível</p>
							<p id="qtdeLivre" style="color: red"></p></li>

						<li
							onmouseover="$(this).css('background-color','rgb(181,231,255)');"
							onmouseout="$(this).css('background-color','');"><img
							src="imagens/apartamento.png" title="Selecione o apartamento" />&nbsp;
							<s:select list="#session.listaApartamentoGeral" headerKey="-1"
								headerValue="Selecione" cssStyle="width:110px;"
								listKey="numApartamento" listValue="numApartamento"
								name="idTipoLancamento" onchange="filtrarApto(this.value)" /></li>


						<li onclick="filtrar('TODOS')"
							onmouseover="$(this).css('background-color','rgb(181,231,255)');"
							onmouseout="$(this).css('background-color','');"><img
							src="imagens/btnTodos.png" title="Todos" />
							<p>Todos</p>
							<p id="qtdeTodos" style="color: red"></p></li>

					</ul>
				</div>
			</div>


			<div class="divGrupo" style="height: 510px; width: 700px;">
				<div class="divGrupoTitulo">Contas</div>
				<div style="height: 480px; width: 680px; overflow-y: auto;">
					<s:set name="objetoCorrente" value="" />

					<s:iterator value="#session.listaApartamento" status="row"
						var="obj">

						<s:if test='%{status == "OA" || status == "OS"}'>
							<s:set name="statusSelecionado" value="%{'divAptoOcupado'}" />
							<s:set name="menu" value="%{'divAptoOcupado'}" />
							<s:set name="idObjeto" value="%{idCheckin}" />

							<s:if test='%{checkout == "S"}'>
								<s:set name="idObjeto" value="%{idApartamento}" />
								<s:set name="menu" value="%{'menuDestravar'}" />
							</s:if>

						</s:if>

						<s:elseif
							test='%{status == "LL" || status == "LS" || status == "LA"}'>

							<s:set name="statusSelecionado" value="%{'divApto'}" />
							<s:set name="menu" value="%{'divApto'}" />
							<s:set name="idObjeto" value="%{idApartamento}" />
							<s:if test='%{cofan == "S"}'>
								<s:set name="menu" value="%{'menuCofan'}" />
							</s:if>
							<s:elseif test='%{status != "LS"}'>
								<s:set name="menu" value="%{'divApto'}" />
							</s:elseif>
							<s:elseif test='%{idReservaApartamento != null}'>
								<s:set name="idObjeto" value="%{idReserva}" />
								<s:set name="menu" value="%{'menuFast'}" />
							</s:elseif>

						</s:elseif>


						<s:if
							test="%{#session.USER_SESSION.usuarioEJB.nivel.intValue() == 0}">
							<s:set name="menu" value="%{'SOMENTE_LEITURA'}" />
						</s:if>

						<div id='<s:property value="#idObjeto"/>'
							class='<s:property value="#statusSelecionado"  />'
							onmouseout='this.className="<s:property value="#statusSelecionado"  />"'
							onmouseover="$('#id').val()!=''?  document.getElementById($('#id').val()).className=$('#classe').val() :''; $('#classe').val(this.className);this.className='divAptoOver'"
							onmouseup="$('#id').val(this.id);this.className='divAptoUp';contextDisabled=false;currentMenu='<s:property value="#menu"  />';">

							<h1>
								<s:property
									value="apelido==null?numApartamento:apelido.length() > 5?apelido.substring(0,5).concat(\"...\"):apelido" />
							</h1>


							<s:if test='%{status == "OA" || status == "OS"}'>
								<div class="divAptoImagem">
									<img class="qtdeOcupado" />
									<s:if test='%{cofan == "S"}'>
										<img class="qtdeCofan" src="imagens/btnCofan.png"
											title="Cofan" />
									</s:if>

									<s:if test='%{status == "OS"}'>
										<img class="qtdeSujo" src="imagens/aptoSujo.png" title="Sujo" />
									</s:if>
									<s:if test='%{saidaDia == "S"}'>
										<img class="qtdeCheckout" src="imagens/setaSaidaApto.png"
											title="Checkout do dia" />
									</s:if>
									<s:if test='%{checkout == "S"}'>
										<img class="qtdeCheckoutAgora" src="imagens/iconic/png/imgContas-4x.png"
											title="Fazendo Checkout agora" />
									</s:if>
								</div>
								<img class="qtdeTotal" src="imagens/casaOcupada.png"
									style="height: 48px; width: 48px;"
									title='Empresa: <s:property value="empresa" />' />

							</s:if>
							<s:elseif
								test='%{status == "LL" || status == "LS" || status == "LA"}'>
								<div class="divAptoImagem" style="text-align: left;">

									<img class="qtdeLivre" style="display: none"
										src="imagens/aptoSujo.png" title="Sujo" />

								</div>
								<img src="imagens/aptoLivre.png"
									style="height: 48px; width: 48px;"
									title='Conta: <s:property value="numApartamento" />' />

							</s:elseif>
						</div>
						<s:set name="objetoCorrente" value="obj" />

					</s:iterator>

					<div></div>
				</div>
			</div>
		</div>
	</div>

</s:form>


<script>

    $("#qtdeOcupado").text ("- ("+ $("img.qtdeOcupado").size()+")" );
    $("#qtdeLivre").text ("- ("+ $("img.qtdeLivre").size() +")" );
    $("#qtdeTodos").text ("- ("+ ($("div.divAptoOcupado").size() + $("div.divApto").size() ) +")" );
    $("#qtdeCheckoutAgora").text ("- ("+ $("img.qtdeCheckoutAgora").size() +")" );


</script>

