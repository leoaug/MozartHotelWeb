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
aI("image=imagens/btnAlterar.png;text=Alterar Check-in;url=javascript:alterarCheckin();");
aI("image=imagens/setaSaidaApto.png;text=Lançamento/Check-out;url=javascript:abrirCheckout();");
aI("image=imagens/btnTransferirApto.png;text=Transferir apartamento;url=javascript:transferirApto();");
aI("image=imagens/btnObjeto.png;text=Empréstimo objetos;url=javascript:preparaEmprestimo();");
aI("image=imagens/btnImprimir.png;text=Movimento geral;url=javascript:imprimirMovimento();");
drawMenus(); 
} 

with(milonic=new menuname("divApto")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/setaEntradaApto.png;text=Realizar Walk-in;url=javascript:realizaCheckin();");
drawMenus(); 
} 
with(milonic=new menuname("menuFast")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/setaEntradaApto.png;text=Realizar Check-in;url=javascript:realizaCheckinFast();");
drawMenus(); 
} 
with(milonic=new menuname("menuCofan")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/setaEntradaApto.png;text=Realizar Walk-in;url=javascript:realizaCofan();");
	drawMenus(); 
} 

with(milonic=new menuname("menuDestravar")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/iconic/png/lock-unlocked-4x.png;text=Destravar Apto;url=javascript:destravarApto();");
drawMenus(); 
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
	
	        url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarApartamentoSemReserva?OBJ_VALUE='+valor;
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
        vForm.action = '<s:url action="caixaGeral!transferirApartamento.action" namespace="/app/caixa" />';
        submitForm( vForm );
    }

    function abrirCheckout(){
    
        if (validaId()){
	        loading();
	        vForm = document.forms[0];
	        vForm.action = '<s:url action="checkout!prepararCheckout.action" namespace="/app/caixa" />';
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
	        vForm.action = '<s:url action="manter!preparaAlteracao.action" namespace="/app/checkin" />';
	        vForm.submit();
        }
    }

    function realizaCofan(){
    
        if (validaId()){
	        loading();
	        vForm = document.forms[0];
	        vForm.apartamento.value = vForm.id.value;
	        vForm.action = '<s:url action="manter!preparaManterCofan.action" namespace="/app/checkin" />';
	        vForm.submit();
        }
    }
    function realizaCheckin(){
    
        if (validaId()){
	       loading();
	       vForm = document.forms[0];
	       vForm.apartamento.value = vForm.id.value;
	       vForm.action = '<s:url action="manter!preparaManter.action" namespace="/app/checkin" />';
	       vForm.submit();
        }
    }

    function realizaCheckinFast(){
    
        if (validaId()){
            
        loading();
        vForm = document.forms[0];
        vForm.idReserva.value = vForm.id.value;
        vForm.action = '<s:url action="manterFast!preparaManterFast.action" namespace="/app/checkin" />';
        vForm.submit();
        }
    }


    function destravarApto(){
        if (validaId()){
	        loading();
	        vForm = document.forms[0];
	        vForm.idReserva.value = vForm.id.value;
	        vForm.action = '<s:url action="caixaGeral!destravarApartamento.action" namespace="/app/caixa" />';
	        vForm.submit();
        }

    }


    function preparaEmprestimo(){
        if (validaId()){
			
	        valor = $('#id').val();
	        apto = $("div[id='"+valor+"'] h1").text();
	        showModal('#divEmprestimo');
	        $('#labelAptoEmprestimo').text(apto);     
	        
	        url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarRoomList?idCheckin='+valor;
	        submitFormAjax('selecionarRoomList?idCheckin='+valor+'&idCombo=idRoomListEmprestimo',true);
	        
	   }
    }

    function imprimirMovimento(){
        if (validaId()){
	    	reportAddress = '<s:property value="#session.URL_REPORT"/>';
	   		reportAddress += '/index.jsp?REPORT=detalheCheckinReport';
	   		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
			params +=  ';P_CHECKIN@'+$('#id').val();
	   		reportAddress += '&PARAMS='+params;
	   		showPopupGrande(reportAddress);
        }
    }


    
	
	function pesquisarObjetos(){
	    url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarObjetos';
	    preencherCombo('idObjetoEmprestimo', url);
	}

    function gravarEmprestimo(){

		if ($('#idRoomListEmprestimo').val() == ''){
			alerta("O campo 'Hóspede' é obrigatório.");
			return false;
		}
		if ($('#idObjetoEmprestimo').val() == ''){
			alerta("O campo 'Objeto' é obrigatório.");
			return false;
		}
		if ($('#dataEmprestimo').val() == ''){
			alerta("O campo 'Data' é obrigatório.");
			return false;
		}
		if ($('#qtdeEmprestimo').val() == ''){
			alerta("O campo 'Qtde' é obrigatório.");
			return false;
		}

    	submitFormAjax('gravarEmprestimo?idCheckin='+$('#id').val()+'&idRoomListEmprestimo='+$('#idRoomListEmprestimo').val()+'&idObjetoEmprestimo='+$('#idObjetoEmprestimo').val()+'&dataEmprestimo='+$('#dataEmprestimo').val()+'&qtdeEmprestimo='+$('#qtdeEmprestimo').val()+'&obsEmprestimo='+$('#obsEmprestimo').val(),true);
    }


</script>

<div style="display: none"><%=new java.util.Date()%></div>

<s:form action="caixaGeral!pesquisar.action" namespace="/app/caixa"
	theme="simple">
	<input type="hidden" name="id" id="id" />
	<s:hidden name="idCheckin" id="idCheckin" />
	<s:hidden name="idReserva" id="idReserva" />
	<s:hidden name="apartamento" id="apartamento" />

	<s:hidden name="tipoPesquisa" id="tipoPesquisa" />
	<input type="hidden" name="classe" id="classe" />

	<s:hidden name="motivoTransferencia" id="motivo" />
	<s:hidden name="idApartamentoDestino" id="idDestino" />

	<!--Div emprestimo-->
	<div id="divEmprestimo" class="divCadastro" style="display: none; height: 310px; width: 700px;">

	<div class="divGrupo" style="width: 98%; height: 220px">
	<div class="divGrupoTitulo">Empréstimos</div>
	<div class="divGrupoBody">
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 150pt; color: red">
	<p style="width: 100px;">Apto:</p>
	<label id="labelAptoEmprestimo">101</label></div>
	</div>
	<div class="divLinhaCadastro">
	
		<div class="divItemGrupo" style="width: 350px;">
		<p style="width: 100px;">Hóspede:</p>
			<select  style="width:200px;" 
					name="idRoomListEmprestimo"
					id="idRoomListEmprestimo">
				<option value="">Selecione</option>
			</select>
		</div>
		
		<div class="divItemGrupo" style="width: 180px;">
			<p style="width: 60px;">Data:</p>
			<input class="dp" value="<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>" type="text" name="dataEmprestimo" id="dataEmprestimo" size="10" maxlength="10" onkeypress="mascara(this, data)"  onblur="dataValida(this)"/>
		</div>
		
	</div>
	
	<div class="divLinhaCadastro" >

		<div class="divItemGrupo" style="width: 350px;">
		<p style="width: 100px;">Objeto:</p>
			<select style="width:200px;" 
					name="idObjetoEmprestimo"
					id="idObjetoEmprestimo">
				<option value="">Selecione</option>
			</select>
		</div>
		
		<div class="divItemGrupo" style="width: 180px;">
		<p style="width: 60px;">Qtde:</p>
			<input value="1" type="text" name="qtdeEmprestimo" id="qtdeEmprestimo" size="5" 
				   maxlength="3" onkeypress="mascara(this, numeros)" />
		</div>

	</div>

	<div class="divLinhaCadastro">

		<div class="divItemGrupo" style="width: 100%;">
		<p style="width: 100px;">Observação:</p>
			<input type="text" size="50" maxlength="60" name="obsEmprestimo" id="obsEmprestimo" onblur="toUpperCase(this)"/>
		</div>
		
	</div>
	

	</div>
	</div>

	<div class="divCadastroBotoes" style="width: 98%;"><duques:botao
		label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="$.modal.close()" />
	<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
		onClick="gravarEmprestimo()" /></div>
	</div>
	<!--final Div emprestimo-->


	<!--Div transferencia-->
	<div id="divTransferencia" class="divCadastro"
		style="display: none; height: 310px; width: 600px;">

	<div class="divGrupo" style="width: 98%; height: 220px">
	<div class="divGrupoTitulo">Transferência</div>
	<div class="divGrupoBody">
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 150pt; color: red">
	<p style="width: 100px;">Apto:</p>
	<label id="labelApto">101</label></div>
	</div>
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 310pt;">
	<p style="width: 100px;">Destino:</p>
		<s:select cssStyle="width:180px;" list="#session.listaAptoLivre"
				  listKey="idApartamento" name="idApartamentoDestino1"
					id="idApartamentoDestino1" />
	</div>
	</div>
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 310pt;">
	<p style="width: 100px;">Motivo:</p>
	<s:textfield size="30" maxlength="50" name="motivoTransferencia1"
		id="motivoTransferencia" /></div>
	</div>


	</div>
	</div>

	<div class="divCadastroBotoes" style="width: 98%;"><duques:botao
		label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="$.modal.close()" />
	<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png"
		onClick="gravarTransferencia()" /></div>
	</div>
	<!--final Div transferencia-->



	<div class="divFiltroPaiTop" style="width: 210px;">Movimentação</div>
	<div class="divFiltroPai">

	<div class="divCadastro" style="overflow: auto;">
	<div class="divGrupo" style="height: 100%; width: 22%;">
	<div class="divGrupoTitulo">Opções</div>
	<div class="divAptoOpcoes">
	<ul>
		<li onclick="filtrar('CHECKOUT_AGORA')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/btnDinheiro.png" title="Entrada do dia" />
		<p>Fazendo Check-out</p>
		<p id="qtdeCheckoutAgora" style="color: red"></p>
		</li>
		<li onclick="filtrar('ENTRADA')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/setaEntradaApto.png" title="Entrada do dia" />
		<p>Entrada do dia</p>
		<p id="qtdeCheckinDia" style="color: red"></p>
		</li>
		<li onclick="filtrar('SAIDA')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/setaSaidaApto.png" title="Checkout do dia" />
		<p>Check-out do dia</p>
		<p id="qtdeCheckoutDia" style="color: red"></p>
		</li>
		<li onclick="filtrar('SUJO')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/aptoSujo.png" title="Sujo" />
		<p>Sujo</p>
		<p id="qtdeSujo" style="color: red"></p>
		</li>
		<li onclick="filtrar('OCUPADO')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/aptoOcupado.png" title="Ocupado" />
		<p>Ocupado</p>
		<p id="qtdeOcupado" style="color: red"></p>
		</li>
		<li onclick="filtrar('LIVRE')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/aptoLivre.png" title="Livre" />
		<p>Livre</p>
		<p id="qtdeLivre" style="color: red"></p>
		</li>
		<li onclick="filtrar('LIVRE_LIVRE')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/aptoLivre.png" title="Livre" />
		<p>Livre e limpo</p>
		<p id="qtdeLivreLivre" style="color: red"></p>
		</li>
		<li onclick="filtrar('INTERDITADO')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/aptoInterditado.png" title="Interditado" />
		<p>Interditado</p>
		<p id="qtdeInterditado" style="color: red"></p>
		</li>
		<li onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/apartamento.png" title="Selecione o apartamento" />&nbsp; <s:select
			list="#session.listaApartamentoGeral" headerKey="-1"
			headerValue="Selecione" cssStyle="width:110px;"
			listKey="numApartamento" name="idTipoLancamento"
			onchange="filtrarApto(this.value)" /></li>

		
		<li onclick="filtrar('TODOS')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/btnTodos.png" title="Todos" />
		<p>Todos</p>
		<p id="qtdeTodos" style="color: red"></p>
		</li>
		
		<li onclick="filtrar('COFAN')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/btnCofan.png" title="Cofan" />
		<p>Cofan</p>
		<p id="qtdeCofan" style="color: red"></p>
		</li>

	</ul>
	</div>
	</div>


	<div class="divGrupo" style="height: 100%; width: 76%;">
	<div class="divGrupoTitulo">Apartamentos</div>
	<div style="height: 100%; width: 100%; overflow-y: auto;"><s:set
		name="objetoCorrente" value="" /> <s:iterator
		value="#session.listaApartamento" status="row" var="obj">
		<s:if test='%{status == "OA" || status == "OS"}'>
			<s:set name="statusSelecionado" value="%{'divAptoOcupado'}" />
			<s:set name="menu" value="%{'divAptoOcupado'}" />
			<s:set name="idObjeto" value="%{idCheckin}" />

			<s:if test='%{checkout == "S"}'>
				<s:set name="idObjeto" value="%{idApartamento}" />
				<s:set name="menu" value="%{'menuDestravar'}" />
			</s:if>

		</s:if>
		<s:elseif test='%{status == "LL" || status == "LS" || status == "LA"}'>
			
			<s:set name="statusSelecionado" value="%{'divApto'}" />
			<s:set name="menu" value="%{'divAptoNada'}" />
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
		<s:elseif test='%{status == "IN"}'>
			<s:set name="statusSelecionado" value="%{'divApto'}" />
			<s:set name="menu" value="%{'NAOFAZNADA'}" />
			<s:set name="idObjeto" value="%{numApartamento}" />
		</s:elseif>

		<s:if test="%{#session.USER_SESSION.usuarioEJB.nivel.intValue() == 0}">
				<s:set name="menu" value="%{'SOMENTE_LEITURA'}" />
		</s:if>

		<div id='<s:property value="#idObjeto"/>'
			class='<s:property value="#statusSelecionado"  />'
			onmouseout='this.className="<s:property value="#statusSelecionado"  />"'
			onmouseover="$('#id').val()!=''?  document.getElementById($('#id').val()).className=$('#classe').val() :''; $('#classe').val(this.className);this.className='divAptoOver'"
			onmouseup="$('#id').val(this.id);this.className='divAptoUp';contextDisabled=false;currentMenu='<s:property value="#menu"  />';">

		<h1><s:property value="apelido==null?numApartamento:apelido.length() > 5?apelido.substring(0,5).concat(\"...\"):apelido" /></h1>


		<s:if test='%{status == "OA" || status == "OS"}'>
			<div class="divAptoImagem"><s:if test='%{cofan == "S"}'>
				<img class="qtdeCofan" src="imagens/btnCofan.png" title="Cofan" />
			</s:if> <img class="qtdeOcupado" src="imagens/aptoOcupado.png"
				title="Ocupado por: <s:property value="nomeHospedeCheckin" />" /> <s:if
				test='%{status == "OS"}'>
				<img class="qtdeSujo" src="imagens/aptoSujo.png" title="Sujo" />
			</s:if> <s:if test='%{saidaDia == "S"}'>
				<img class="qtdeCheckout" src="imagens/setaSaidaApto.png"
					title="Checkout do dia" />
			</s:if> <s:if test='%{checkout == "S"}'>
				<img class="qtdeCheckoutAgora" src="imagens/btnDinheiro.png"
					title="Fazendo Checkout agora" />
			</s:if></div>
			<img class="qtdeTotal" src="imagens/casaOcupada.png" style="height: 48px; width: 48px;" title='Apto: <s:property value="apelido==null?numApartamento:apelido" />, Tipo: <s:property value="tipoApartamento" />, Hóspede:  <s:property value="nomeHospedeCheckin" />, IN:  <s:property value="dataEntrada" />, OUT:  <s:property value="dataSaida" />, Num Reserva:  <s:property value="idReserva" />, Num Checkin:  <s:property value="idCheckin" />'/>

		</s:if> <s:elseif
			test='%{status == "LL" || status == "LS" || status == "LA"}'>
			<div class="divAptoImagem" style="text-align: left;"><s:if
				test='%{cofan == "S"}'>
				<img class="qtdeCofan" src="imagens/btnCofan.png" title="Cofan" />
			</s:if> 
			<s:if test='%{idReservaApartamento != null}'>
				<img class="qtdeCheckin" src="imagens/setaEntradaApto.png"
					title="Entrada do dia" />
				<img class="qtdeOcupado" src="imagens/aptoOcupado.png"
					title="Reservado por: <s:property value="nomeHospedeReserva" />" />
			</s:if> <s:if test='%{status == "LS"}'>
				<img class="qtdeSujo" src="imagens/aptoSujo.png" title="Sujo" />
			</s:if> 
			<s:elseif test='%{status == "LL"}'>
				<img class="qtdeLivreLivre" style="display: none" src="imagens/aptoSujo.png" title="Sujo" />
			</s:elseif> 
			<img class="qtdeLivre" style="display: none" src="imagens/aptoSujo.png" title="Sujo" />
			
			</div>
			<s:if test='%{status == "LA"}'>
				<img src="imagens/aptoLivreArrumado.png" style="height: 48px; width: 48px;" title='Apto: <s:property value="apelido==null?numApartamento:apelido" />, Tipo: <s:property value="tipoApartamento" />, Hóspede:  <s:property value="nomeHospedeCheckin" />, IN:  <s:property value="dataEntrada" />, OUT:  <s:property value="dataSaida" />, Num Reserva:  <s:property value="idReserva" />, Num Checkin:  <s:property value="idCheckin" />'/>				
			</s:if>
			<s:else>
				<img src="imagens/aptoLivre.png" style="height: 48px; width: 48px;" title='Apto: <s:property value="apelido==null?numApartamento:apelido" />, Tipo: <s:property value="tipoApartamento" />, Hóspede:  <s:property value="nomeHospedeCheckin" />, IN:  <s:property value="dataEntrada" />, OUT:  <s:property value="dataSaida" />, Num Reserva:  <s:property value="idReserva" />, Num Checkin:  <s:property value="idCheckin" />'/>
			</s:else>

		</s:elseif> 
		<s:elseif test='%{status == "IN"}'>
			<div class="divAptoImagem" style="text-align: left;">
			<s:if
				test='%{cofan == "S"}'>
				<img class="qtdeCofan" src="imagens/btnCofan.png" title="Cofan" />
			</s:if> 
			<img class="qtdeInterditado" src="imagens/aptoInterditado.png"	title="Interditado" /></div>
			<img src="imagens/aptoInter.png" style="height: 48px; width: 48px;" title='Apto: <s:property value="apelido==null?numApartamento:apelido" />, Tipo: <s:property value="tipoApartamento" />, Obs:  <s:property value="obs" />'/>	
		</s:elseif></div>
		<s:set name="objetoCorrente" value="obj" />

	</s:iterator>

	<div></div>
	</div>
	</div>
	</div>
	</div>

</s:form>


<script>

    $("#qtdeCheckinDia").text ("- ("+ $("img.qtdeCheckin").size() +")" );
    $("#qtdeCheckoutDia").text ("- ("+ $("img.qtdeCheckout").size()+")" );
    $("#qtdeSujo").text ("- ("+ $("img.qtdeSujo").size() +")" );
    $("#qtdeOcupado").text ("- ("+ $("img.qtdeOcupado").size()+")" );
    $("#qtdeLivre").text ("- ("+ $("img.qtdeLivre").size() +")" );
    $("#qtdeInterditado").text ("- ("+ $("img.qtdeInterditado").size() +")" );
    $("#qtdeCofan").text ("- ("+ $("img.qtdeCofan").size() +")" );
    $("#qtdeTodos").text ("- ("+ ($("div.divAptoOcupado").size() + $("div.divApto").size() ) +")" );
    $("#qtdeLivreLivre").text ("- ("+ $("img.qtdeLivreLivre").size() +")" );
    $("#qtdeCheckoutAgora").text ("- ("+ $("img.qtdeCheckoutAgora").size() +")" );


</script>

