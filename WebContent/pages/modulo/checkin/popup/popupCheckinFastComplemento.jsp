<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script language="javascript" type="text/javascript">loading();</script>

</head>

<script language="javaScript">


    
    function getCidadeOrigemLookup(elemento){
        url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarCidade?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idCidadeOrigem';
        getDataLookup(elemento, url,'Origem','TABLE');
    }
    function getCidadeDestinoLookup(elemento){
        url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarCidade?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idCidadeDestino';
        getDataLookup(elemento, url,'Destino','TABLE');
    }


    function obterValorTipoLancamento(){
            vForm = document.forms[0];

        if (vForm.idTipoLancamento.value != ''){
            vForm.action = '<s:url action="popupComplemento!obterValorTipoLancamento.action" namespace="/app/checkin" />';
            vForm.submit();
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
            vForm.action = '<s:url action="popupComplemento!adicionarTipoLancamento.action" namespace="/app/checkin" />';
            vForm.submit();
    }

    function excluirTipoLancamento(pIdxHospede){
        if (confirm('Confirma a exclusão da despesa?')){
            vForm = document.forms[0];
            vForm.idxHospede.value = pIdxHospede;
            vForm.action = '<s:url action="popupComplemento!excluirTipoLancamento.action" namespace="/app/checkin" />';
            vForm.submit();
        }
    }
    
    function atualizar(){

        window.opener.atualizar();
        window.close();
    }
    
    function confirmarAlteracao(){        
        vForm = document.forms[0];
        
        if ('S' == vForm.salvarParaTodos.value){
            if (!confirm('Confirma a inclusão destes dados em todos os check-ins?')){
                vForm.salvarParaTodos.value = 'N';
            }
        }
        vForm.action = '<s:url action="popupComplemento!gravarPopupComplemento.action" namespace="/app/checkin" />';
        vForm.submit();
    }

<s:if test="#request.fecharPopup != null">
    atualizar();
    
</s:if>
    
    
</script>

<s:form namespace="/app/checkin"
	action="popupComplemento!popupAdicionarComplemento" theme="simple">
	<s:hidden name="idxCheckin" />
	<s:hidden name="idxHospede" />


	<div class="divFiltroPaiTop">Complemento</div>
	<div id="divFiltroPai" class="divFiltroPai"
		style="height: 100px; width: 495px;">
	<div id="divFiltro" class="divCadastro" style="height: 450px;"><!--Início dados do filtro-->
	<div class="divGrupo" style="height: 170px; width: 480px">
	<div class="divGrupoTitulo">Dados</div>
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 99%;">
	<p style="width: 60px;">Hóspede:</p>
	<s:property
		value="#session.checkinCorrente.reservaApartamentoEJB.hospedePrincipal" />
	</div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 170px;">
	<p style="width: 60px;">Motivo:</p>
	<s:select list="motivoViagem" cssStyle="width:100px;"
		name="motivoDaViagem" value="checkinCorrente.motivoViagem" />
	</div>
	<div class="divItemGrupo" style="width: 200px;">
	<p style="width: 90px;">Tipo transporte:</p>
	<s:select list="tipoTransporte" cssStyle="width:100px;"
		name="tipoDoTransporte" value="checkinCorrente.meioTransporte" />
	</div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo">
	<p style="width: 60px;">Origem:</p>
	<s:textfield name="cidadeOrigem" id="cidadeOrigem" maxlength="50"
		size="40" onblur="getCidadeOrigemLookup(this)" /> <s:hidden
		name="idCidadeOrigem" id="idCidadeOrigem" /></div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo">
	<p style="width: 60px;">Destino:</p>
	<s:textfield name="cidadeDestino" id="cidadeDestino" maxlength="50"
		size="40" onblur="getCidadeDestinoLookup(this)" /> <s:hidden
		name="idCidadeDestino" id="idCidadeDestino" /></div>
	</div>

	<div class="divLinhaCadastro">
	
	<s:if test='%{#session.HOTEL_SESSION.seguro > 0.0}'>
		<div class="divItemGrupo" style="width:115px;">
		<p style="width: 60px">Seguro?:</p>
		<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
			listValue="value" cssStyle="width:50px;" name="seguroPopUp" />
		</div>
	</s:if>
	<s:else>
		<s:hidden name="seguroPopUp" id="seguroPopUp" value="N" />
	</s:else>	
	
	<div class="divItemGrupo" style="width:245px;">
	<p style="width: 190px">Salvar para todos os checkins?:</p>
	<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
		listValue="value" cssStyle="width:50px;" name="salvarParaTodos" />
	</div>
	</div>
	</div>

	<!--Grupo das despesas -->

	<div class="divGrupo" style="height: 180px; width: 480px;">
	<div class="divGrupoTitulo">Despesas</div>
	<div class="divGrupoBody">
	<ul>
		<li style="width: 100%;">
		<div class="divLinhaCadastro" style="height: 40px;">
		<div class="divItemGrupo" style="width: 150px;">
		<p style="width: 100%">Despesa:</p>
		<s:select list="#session.listaTipoLancamento" cssStyle="width:100px;"
			listKey="idTipoLancamento" listValue="descricaoLancamento"
			name="idTipoLancamento" headerValue=".:Selecione:." headerKey=""
			onchange="obterValorTipoLancamento()" />
		</div>
		<div class="divItemGrupo" style="width: 120px;">
		<p style="width: 100%">Qtde:</p>
		<s:textfield name="qtdeTipoLancamento" size="5" maxlength="2"
			onkeypress="mascara(this, numeros)" /></div>
		<div class="divItemGrupo" style="width: 120px;">
		<p style="width: 100%">Valor:</p>
		<s:textfield name="valorTipoLancamento" size="10" maxlength="6"
			onkeypress="mascara(this, moeda)" /></div>
		<div class="divItemGrupo" style="width: 50px; text-align: center;">
		<img width="24px" height="24px" src="imagens/iconic/png/plus-3x.png"
			title="Incluir despesa" onclick="incluirTipoLancamento()" /></div>
		</div>
		</li>
	</ul>
	<ul>
		<s:iterator
			value="#session.checkinCorrente.checkinTipoLancamentoEJBList"
			status="row">
			<li style="width: 100%;">
			<div class="divItemGrupo" style="width: 150px;"><s:property
				value="tipoLancamentoEJB.descricaoLancamento" /></div>
			<div class="divItemGrupo" style="width: 120px;"><s:property
				value="quantidade" /></div>
			<div class="divItemGrupo" style="width: 120px;"><s:property
				value="valorUnitario" /></div>
			<div class="divItemGrupo" style="width: 50px; text-align: center;">
			<img width="24px" height="24px" src="imagens/iconic/png/x-3x.png"
				title="Excluir despesa"
				onclick="excluirTipoLancamento('${row.index}')" /></div>
			</li>
		</s:iterator>
	</ul>

	</div>
	</div>





	<!--Grupo das despesas -->

	<div class="divCadastroBotoes" style="width: 98%;"><duques:botao
		label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="atualizar();" />
	<duques:botao label="Confirmar" imagem="imagens/iconic/png/check-4x.png"
		onClick="confirmarAlteracao();" /></div>

	</div>
	</div>



</s:form>
</html>