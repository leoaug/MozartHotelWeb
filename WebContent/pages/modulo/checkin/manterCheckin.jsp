<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<jsp:include page="/pages/modulo/includes/cache.jsp" />
<script type="text/javascript">
    function init(){
        
    }
    
    window.onload = function() {
		addPlaceHolder('nomeHospede');
	};
	
	function addPlaceHolder(classe) {
		document.getElementById(classe).setAttribute("placeholder",
				"ex.: Digitar nome ou sobrenome ou CPF ou passaporte");
	}

    function getCidadeOrigemLookup(elemento){
        url = 'app/ajax/ajax!selecionarCidade?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idCidadeOrigem';
        getDataLookup(elemento, url,'divOrigem','TABLE');
    }

    function getCidadeDestinoLookup(elemento){
        url = 'app/ajax/ajax!selecionarCidade?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idCidadeDestino';
        getDataLookup(elemento, url,'divDestino','TABLE');
    }

    function getEmpresa(elemento){
        url = 'app/ajax/ajax!selecionarEmpresa?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idEmpresa';
        getDataLookup(elemento, url,'Empresa','TABLE');
    }
    
    function abrirHospede(indice){
        showModal('#divHospedeModal', 200, 600);
    }
    
    function verificarPeriodo(){
    
        if ($('#dataInicial').val() ==''){
            alerta("Campo 'Data Entrada' obrigatório.");
            $('#dataInicial').focus();
            return false;
        }
        
        if ($('#dataFinal').val() ==''){
            alerta("Campo 'Data Saída' obrigatório.");
            $('#dataFinal').focus();
            return false;
        }
        return true;

    }
    
    
    function obterComplementoEmpresa(){
        vForm = document.forms[0];
        vForm.action = '<s:url action="manter!obterComplementoEmpresa.action" namespace="/app/checkin" />';
        submitForm( vForm );
    }
    
    
    function inverterDespesas(){
            valor = $("select[name='quemPagaSelecionado']").size();
            for (var x = 0; x < valor; x++){
                novoValor = $("select[name='quemPagaSelecionado']").get(x).value == "E"?"H":"E";
                $("select[name='quemPagaSelecionado']").get(x).value =  novoValor ;
            }
    }
    
    function incluirTipoLancamento(){
    
            vForm = document.forms[0];
            
            if (vForm.idTipoLancamento.value == ''){
                alerta('Você deve selecionar uma despesa.');
                return false;
            }
            if (vForm.qtdeTipoLancamento.value == ''){
                alerta('Você deve informar a quantidade.');
                return false;
            }
            if (vForm.valorTipoLancamento.value == ''){
                alerta('Você deve informar o valor.');
                return false;
            }
            vForm.action = '<s:url action="manter!adicionarTipoLancamento.action" namespace="/app/checkin" />';
            submitForm( vForm );
    }
    function excluirTipoLancamento(pIdxHospede){
        if (confirm('Confirma a exclusão da despesa?')){
            vForm = document.forms[0];
            vForm.idxHospede.value = pIdxHospede;
            vForm.action = '<s:url action="manter!excluirTipoLancamento.action" namespace="/app/checkin" />';
            submitForm( vForm );

        }
    }

    function obterValorTipoLancamento(){
            vForm = document.forms[0];

        if (vForm.idTipoLancamento.value != ''){
            vForm.action = '<s:url action="manter!obterValorTipoLancamento.action" namespace="/app/checkin" />';
            submitForm( vForm );
        }
    
    }    
    
    function incluirHospede(){
    
            vForm = document.forms[0];
            
            if (vForm.idHospede.value == ''){
                alerta('Você deve selecionar um hóspede.');
                return false;
            }
    
            vForm.action = '<s:url action="manter!incluirHospedeWalkin.action" namespace="/app/checkin" />';
            submitForm( vForm );

    }

    function excluirHospede(pIdxHospede){
        if (confirm('Confirma a exclusão do hóspede?')){
            vForm = document.forms[0];
            vForm.idxHospede.value = pIdxHospede;
            vForm.action = '<s:url action="manter!excluirHospede.action" namespace="/app/checkin" />';
            submitForm( vForm );

        }
    }
    
    function getHospedeLookup(elemento){
        url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarHospedePorNomeSobrenomeCpfPassaporte?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idHospede';
        getDataLookup(elemento, url,'Hospedes','TABLE');
    }

    function showPopupHospede(){
        vUrl = '<%=session.getAttribute("URL_BASE")%>pages/modulo/checkin/popup/popupManager.jsp?TIPO=H';
        vUrl += '&idxCheckin=0&qtdePax='+$('#qtdePax').val();
        vUrl += '&seguro='+$('#seguroHospede').val();
        showPopupMedio(vUrl); 
    }  
    
       
    function atualizarHospede(){
        vForm = document.forms[0];
        vForm.action = '<s:url action="manter!prepararPesquisa.action" namespace="/app/checkin" />';
        submitForm( vForm );
    }
    
    
    function gravarCheckin(){
    
            if ($('#qtdePax').val() == '0'){
                alerta("O campo 'PAX' deve ser maior que zero.");
                return false;
            }            
    
            if ($('#apartamento').val() == ''){
                alerta("O campo 'Apto' é obrigatório.");
                return false;
            }       
            
            if (!verificarPeriodo()){
                return false;
            }

            <s:if test="%{cofan == \"S\"}">
					$('#valorTarifa').val('0');
            </s:if>
		    <s:else>
		            if ($('#idCidadeOrigem').val() == ''){
		                alerta("O campo 'Origem' é obrigatório.");
		                return false;
		            }       
		            
		            if ($('#idCidadeDestino').val() == ''){
		                alerta("O campo 'Destino' é obrigatório.");
		                return false;
		            }       
		                
		            if ($('#valorTarifa').val() == ''){
		                alerta("O campo 'Valor' é obrigatório.");
		                return false;
		            }
		    </s:else>

            if ($('#idEmpresa').val() == ''){
                alerta("O campo 'Empresa' é obrigatório.");
                return false;
            }
            vForm = document.forms[0];
            vForm.action = '<s:url action="manter!gravarWalkin.action" namespace="/app/checkin" />';
            submitForm( vForm );
    }
    
    function cancelarCheckin(){
            vForm = document.forms[0];
            vForm.action = '<s:url action="pesquisar!prepararPesquisa.action" namespace="/app/checkin" />';
            submitForm( vForm );
    }
    
    function caixaGeral(){
    	loading();
		window.location.href= '<s:url action="caixaGeral!preparar.action" namespace="/app/caixa" />';
	
    }

</script>




<s:form namespace="/app/checkin" action="manter!preparaManter.action"
	theme="simple">

	<input type="hidden" name="id" />
	<s:hidden name="idxHospede" />
	<s:hidden name="idxCheckin" value="0" />
	<s:hidden name="cofan" />

	<div class="divFiltroPaiTop">Check-in/Walk-in</div>
	<div id="divFiltroPai" class="divFiltroPai">
	<div id="divFiltro" class="divCadastro" style="height: 110%"><!--Início dados do filtro-->
	<div class="divGrupo" style="height: 105px">
	<div class="divGrupoTitulo">Check-in</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 180px;">
	<p style="width: 60px;">Apto:</p>

	<s:select cssStyle="width:100px;" list="#session.apartamentoList"
		name="apartamento" id="apartamento" headerKey=""
		headerValue=".: Selecione :." listKey="idApartamento" />
	</div>
	
	<div class="divItemGrupo" style="width: 180px;">
	<p style="width: 60px;">PAX:</p>
	<s:select cssStyle="width:80px;" list="qtdePaxList" name="qtdePax"
		id="qtdePax" /></div>

	<div class="divItemGrupo" style="width: 180px;">
	<p style="width: 60px;">Children:</p>
	<s:select cssStyle="width:80px;" list="qtdePaxList" name="qtdeCrianca" />
	</div>
	
	<div class="divItemGrupo" style="width: 180px;">
	<p style="width: 80px;">Valor diária:</p>
	<s:textfield name="valorTarifa" id="valorTarifa" size="10"
		maxlength="12" onkeypress="mascara(this, moeda)" /></div>
	<div class="divItemGrupo" style="width: 220px;">
	<p style="width: 65px;">Justificativa:</p>
	<s:textfield style="width: 130px;" name="justificativaTarifa" id="justificativaTarifa"
		size="20" maxlength="20" /></div>
	
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 180px;">
	<p style="width: 80px;">Data entrada:</p>
		<s:property value="dataInicial"/>
		<s:hidden name="dataInicial" id="dataInicial" />
    </div>

	<div class="divItemGrupo" style="width: 190px;">
	<p style="width: 70px;">Data saída:</p>
	<s:textfield cssClass="dp" name="dataFinal" id="dataFinal" size="10" maxlength="10"  onkeypress="mascara(this, data)" onblur="dataValida(this)" />
	
	</div>

	<div class="divItemGrupo" style="width: 150px;">
	<p style="width: 40px;">Hora:</p>
	<s:textfield name="horaFinal" size="10" maxlength="5"
		onkeypress="mascara(this, hora)" /></div>

	<div class="divItemGrupo" style="width: 120px;">
	<p style="width: 50px;">Cortesia:</p>
	<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
		listValue="value" cssStyle="width:50px;" name="cortesia" />
	</div>
	
	<div class="divItemGrupo" style="width: 300px;">
	<p style="width: 50px;">Grupo:</p>
	<s:textfield name="nomeGrupo" size="30" maxlength="30" /></div>
	
	</div>
</div>
<div class="divGrupo" style="height: 100px">
	<div class="divGrupoTitulo">FNRH - Dados</div>
	
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 275px;">
	<p style="width: 60px;">Origem:</p>
	<s:textfield name="cidadeOrigem" id="cidadeOrigem" maxlength="50"
		size="30" onblur="getCidadeOrigemLookup(this)" /> <s:hidden
		name="idCidadeOrigem" id="idCidadeOrigem" /> <input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"  />
	</div>
	<div class="divItemGrupo" style="width: 275px;">
	<p style="width: 60px;">Destino:</p>
	<s:textfield name="cidadeDestino" id="cidadeDestino" maxlength="50"
		size="30" onblur="getCidadeDestinoLookup(this)" /> <s:hidden
		name="idCidadeDestino" id="idCidadeDestino" /></div>
			
	<div class="divItemGrupo" style="width: 190px;">
	<p style="width: 90px;">Motivo viagem:</p>
	<s:select cssStyle="width:90px;" list="motivoViagem"
		name="motivoDaViagem" /></div>
	<div class="divItemGrupo" style="width: 180px;">
	<p style="width: 70px;">Transporte:</p>
	<s:select cssStyle="width:100px;" list="tipoTransporte"
		name="tipoDoTransporte" /></div>
			
	</div>
</div>

<!--Fim dados do filtro --> <!--Início dados da despesa -->
	<div class="divGrupo" style="width: 40%; height: 350px">
	<div class="divGrupoTitulo">Despesas</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 321px;">
	<p style="width: 60px;">Empresa:</p>
	<s:textfield style="width: 250px;" onfocus="verificarPeriodo()" onblur="getEmpresa(this)"
		name="empresa" size="50" maxlength="50" id="empresa" /> <s:hidden
		name="idEmpresa" id="idEmpresa" />
		<input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"  />
		</div>
		
	<div class="divItemGrupo" style="width: 25px;"><img
		src="imagens/iconic/png/loop-circular-3x.png" title="Inventer despesas"
		onclick="inverterDespesas()" /></div>
	</div>
	<div style="width: 99%; height: 250px; overflow-y: auto;">
	<%int a=0;%> <s:iterator
		value="#session.checkinCorrente.checkinGrupoLancamentoEJBList"
		var="row">
		<input type="hidden" name="identificaLancamento"
			value="<s:property value="identificaLancamentoEJB.idIdentificaLancamento" />" />

		<div class="divLinhaCadastro"
			style="background-color: white; width: 350px;">
		<div class="divItemGrupo" style="width: 340px;">

		<p style="width: 220px;"><s:property
			value="identificaLancamentoEJB.descricaoLancamento" /></p>
		<s:select cssStyle="width:90px;" list="#session.quemPagaList"
			name="quemPagaSelecionado" value="quemPaga" listKey="id"
			listValue="value" /></div>


		</div>
	</s:iterator></div>


	</div>
	<!--Fim dados da despesa --> <!--Início dados de hóspede-->
	<div class="divGrupo" style="height: 150px; width: 570px;">
	<div class="divGrupoTitulo">Hóspedes</div>
	<div class="divLinhaCadastro" style="width: 530px;">
	<div class="divItemGrupo" style="width: 450px;">
	<p style="width: 60px;">Hóspede:</p>
		<s:textfield name="nomeHospede" id="nomeHospede" size="50" maxlength="50" onblur="getHospedeLookup(this)" /> 
		<s:hidden name="idHospede" id="idHospede" /><input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"  />
	</div>
	<div class="divItemGrupo" style="width: 60px; text-align: center;">
	<img width="24px" height="24px" src="imagens/iconic/png/plus-3x.png"
		title="Incluir hóspede" onclick="incluirHospede()" /> <img
		width="24px" height="24px" src="imagens/hospede.png"
		title="Gerenciar hóspede" onclick="showPopupHospede()" /></div>
	</div>

	<div style="width: 99%; height: 60px; overflow-y: auto;"><s:iterator
		value="#session.checkinCorrente.reservaApartamentoEJB.roomListEJBList"
		status="row">
		<s:if test="%{dataSaida == null}">
			<div class="divLinhaCadastro" style="width: 530px;">
			<div class="divItemGrupo" style="width: 210px;">
			<p style="width: 100%;"><s:property value="hospede.nomeHospede" />
			<s:property value="hospede.sobrenomeHospede" /></p>
			</div>
			<div class="divItemGrupo" style="width: 120px;">
			<p style="width: 60px;">Principal?:</p>
			<s:property value="principal" /></div>
			<div class="divItemGrupo" style="width: 120px;">
			<p style="width: 60px;">Chegou?:</p>
			<s:property value="chegou" /></div>
			<div class="divItemGrupo" style="width: 30px; text-align: center;">
			<s:if test="%{dataEntrada == null}">
				<img width="24px" height="24px" src="imagens/iconic/png/x-3x.png"
					title="Excluir hóspede" onclick="excluirHospede('${row.index}')" />
			</s:if></div>
			</div>
		</s:if>

	</s:iterator></div>

	</div>
	<!--Fim dados de hóspede--> <!--Início dados da despesa automática-->
	<div class="divGrupo" style="height: 150px; width: 570px;">
	<div class="divGrupoTitulo">Despesas</div>
	<div class="divLinhaCadastro" style="width: 530px;">
	<div class="divItemGrupo" style="width: 165px;">
	<p style="width: 60px;">Despesa.:</p>
	<s:select list="#session.listaTipoLancamento" cssStyle="width:100px;"
		listKey="idTipoLancamento" listValue="descricaoLancamento"
		name="idTipoLancamento" headerValue=".:Selecione:." headerKey=""
		onchange="obterValorTipoLancamento()" />
	</div>
	<div class="divItemGrupo" style="width: 140px;">
	<p style="width: 50px;">Qtde:</p>
	<s:textfield name="qtdeTipoLancamento" size="5" maxlength="2"
		onkeypress="mascara(this, numeros)" /></div>
	<div class="divItemGrupo" style="width: 160px;">
	<p style="width: 50px;">Valor:</p>
	<s:textfield name="valorTipoLancamento" size="10" maxlength="6"
		onkeypress="mascara(this, moeda)" /></div>
	<div class="divItemGrupo" style="width: 30px; text-align: center;">
	<img width="24px" height="24px" src="imagens/iconic/png/plus-3x.png"
		title="Incluir despesa" onclick="incluirTipoLancamento()" /></div>
	</div>

	<div style="width: 99%; height: 60px; overflow-y: auto;"><s:iterator
		value="#session.checkinCorrente.checkinTipoLancamentoEJBList"
		status="row">
		<div class="divLinhaCadastro" style="width: 530px;">
		<div class="divItemGrupo" style="width: 165px;">
		<p style="width: 100%;"><s:property
			value="tipoLancamentoEJB.descricaoLancamento" /></p>
		</div>
		<div class="divItemGrupo" style="width: 140px;">
		<p style="width: 100%; text-align: center;"><s:property
			value="quantidade" /></p>
		</div>
		<div class="divItemGrupo" style="width: 160px;">
		<p style="width: 100%; text-align: center;"><s:property
			value="valorUnitario" /></p>
		</div>
		<div class="divItemGrupo" style="width: 30px; text-align: center;">
		<img width="24px" height="24px" src="imagens/iconic/png/x-3x.png"
			title="Excluir despesa"
			onclick="excluirTipoLancamento('${row.index}')" /></div>
		</div>

	</s:iterator></div>
	</div>
	<!--Fim dados da despesa automatica-->

<div class="divGrupo" style="height: 325px">
	<div class="divGrupoTitulo">Demais Condições</div>
	<div class="divLinhaCadastro">
	<div class="divItemGrupo"
		style="width: 100px; background-color: silver;">Taxa de hóspede</div>
	<div class="divItemGrupo" style="width: 200px;">
	<p style="width: 100px;">ISS:</p>
	<s:if test='%{#session.HOTEL_SESSION.iss.doubleValue() > 0.0}'>
	<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
		listValue="value" cssStyle="width:50px;" name="issHospede" />
	</s:if>
	<s:else>
		<s:property value="\"Não\""/>
		<s:hidden name="issHospede" id="issHospede" value="N" />
	</s:else>
	</div>
	<div class="divItemGrupo" style="width: 200px;">
	<p style="width: 100px;">Taxa de serviço:</p>
	<s:if test='%{#session.HOTEL_SESSION.taxaServico.doubleValue() > 0.0}'>
	<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
		listValue="value" cssStyle="width:50px;" name="taxaServicoHospede" />
	</s:if>
	<s:else>
		<s:property value="\"Não\""/>
		<s:hidden name="taxaServicoHospede" id="taxaServicoHospede" value="N" />
	</s:else>
	</div>
	<div class="divItemGrupo" style="width: 200px;">
	<p style="width: 100px;">Room tax:</p>
	<s:if test='%{#session.HOTEL_SESSION.roomtax.doubleValue() > 0.0}'>
	<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
		listValue="value" cssStyle="width:50px;" name="roomTaxHospede" />
	</s:if>
	<s:else>
		<s:property value="\"Não\""/>
		<s:hidden name="roomTaxHospede" id="roomTaxHospede" value="N" />
	</s:else>		
	</div>
	
    <s:if test='%{#session.HOTEL_SESSION.seguro > 0.0}'>
		<div class="divItemGrupo" style="width: 200px;">
			<p style="width: 100px;">Seguro:</p>
			<s:select list="#session.LISTA_CONFIRMACAO" listKey="id" listValue="value" cssStyle="width:50px;" id="seguroHospede" name="seguroHospede" />
		</div>
	</s:if>
	<s:else>
		<s:hidden name="seguroHospede" id="seguroHospede" value="N" />
	</s:else>

	</div>
	<div class="divLinhaCadastro">
	<div class="divItemGrupo"
		style="width: 100px; background-color: silver;">Taxa empresa</div>
	<div class="divItemGrupo" style="width: 200px;">
		<p style="width: 100px;">ISS:</p> 
		<s:property value="issEmpresa == \"S\"?\"Sim\":\"Não\""/>
		<s:hidden name="issEmpresa" />
	</div>
	<div class="divItemGrupo" style="width: 200px;">
		<p style="width: 100px;">Taxa de serviço:</p>
		<s:property value="taxaServicoEmpresa == \"S\"?\"Sim\":\"Não\""/>
		<s:hidden name="taxaServicoEmpresa" />
	</div>
	<div class="divItemGrupo" style="width: 200px;">
		<p style="width: 100px;">Room tax:</p>
		<s:property value="roomTaxEmpresa == \"S\"?\"Sim\":\"Não\""/>
		<s:hidden name="roomTaxEmpresa" />
	</div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 210px;">
	<p style="width: 100px;">Possui crédito:</p>
	<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
		listValue="value" cssStyle="width:50px;" name="possuiCredito" />
	</div>
	<div class="divItemGrupo" style="width: 210px;">
	<p style="width: 100px;">Bebida alcóolica:</p>
	<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
		listValue="value" cssStyle="width:50px;" name="bebidaAlcoolica" />
	</div>
	<div class="divItemGrupo" style="width: 210px;">
	<p style="width: 100px;">Tipo pensão:</p>
	<s:select list="tipoPensaoList" listKey="id" listValue="value"
		cssStyle="width:100px;" name="tipoPensao" />
	</div>
	
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 210px;">
	<p style="width: 100px;">Tarifa empresa:</p>
	<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
		listValue="value" cssStyle="width:50px;" name="tarifaEmpresa" />

	</div>
	<div class="divItemGrupo" style="width: 210px;">
	<p style="width: 100px;">Comissão:</p>
	<s:textfield name="comissao" id="comissao" size="10" maxlength="6"
		onkeypress="mascara(this, moeda)" /></div>
		
	<div class="divItemGrupo" style="width: 140px;">
	<p style="width: 50px;">Moeda:</p>
	<s:select list="#session.moedaList" listKey="idMoeda"
		cssStyle="width:80px;" name="idMoeda" />
	</div>
	
	</div>

	<div class="divLinhaCadastro" style="height: 53px;">
	<div class="divItemGrupo" style="width: 99%">
	<p style="width: 100px;">Observação:</p>
	<s:textarea name="observacao" cols="60" rows="2"></s:textarea></div>
	</div>


	</div>
	




	<div class="divCadastroBotoes"><duques:botao label="Voltar"
		imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelarCheckin()" /> <duques:botao
		label="Caixa Geral" imagem="imagens/btnCaixa.png" style="width:120px;"
		onClick="caixaGeral();" /> <duques:botao label="Gravar"
		imagem="imagens/iconic/png/check-4x.png" onClick="gravarCheckin();" /></div>
	</div>
	</div>

</s:form>