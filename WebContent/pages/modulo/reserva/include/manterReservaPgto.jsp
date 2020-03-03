<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<jsp:scriptlet>
        String  base = request.getRequestURL().toString().substring(0, request.getRequestURL().toString().indexOf(request.getContextPath())+request.getContextPath().length()+1);
        session.setAttribute("URL_BASE", base);
        response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
	response.setHeader("Cache-Control","no-store, no-cache, must-revalidate");
	response.addHeader("Cache-Control", "post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
</jsp:scriptlet>

<html>
    <head>
    <base href="<%=base%>" /> 
    <%@ include file="/pages/modulo/includes/headPage.jsp" %>
</head>
<script type="text/javascript">
$(function() {

	$.datepicker.setDefaults($.datepicker.regional['pt-BR']);
	
	$(".dp").datepicker({
		showOn: 'button',
		buttonImage: 'imagens/iconic/png/calendar-2x.png',
		buttonImageOnly: true,
		dateFormat: 'dd/mm/yy',
		numberOfMonths: [1,2]
		         		
	});
	
	
});

function validaId(){
    
    if ($('#id').val() == ''){
        alerta('Selecione um apartamento');
        return false;
    }
    
    return true;

}

function verificaValidade(obj){
	index = document.getElementById('pagamentoReservaVO.bcIdTipoLancamento').selectedIndex;   
	idIdentificaLancamento = document.getElementById('pagamentoReservaVO.bcIdTipoLancamento').options[index].getAttribute("identificaLancamento");
	
	if('19' != idIdentificaLancamento){
		return true;
	}
	
	controlaData = '<s:property value="@com.mozart.model.util.MozartUtil@format(@com.mozart.model.util.MozartUtil@primeiroDiaMes(#session.CONTROLA_DATA_SESSION.frontOffice))" />';
	validade =	'01/'+obj.value;
	
	if( pegaDiferencaDiasDatas(validade,controlaData) < 0){
		alerta('A validade do Cartão não pode ser inferior ao controla data! ');
		obj.focus();
		return false;
	}
	
	return true;
}

function abrirCheckout(){
    
    if (validaId()){
        loading();
        vForm = document.forms[0];
        vForm.action = '<s:url action="checkout!prepararCheckout.action" namespace="/app/caixa" />';
        vForm.submit();
    }
    
}

function adicionarPagamento(){

	
	
	var tpPagamento = getTipoPagamentoSelecionado();
	if(tpPagamento == 'A'  && document.getElementById('movimentoApartamento.checkinEJB.idCheckin').value=='0'){
		alerta("Selecione o Apto COFAN");
		return false;
	}

	if(getIdentificaLancamentoSelecionado() == 19){
		if($('#pagamentoReservaVO.bcNomeCartao').val()=='')
			return false;
		if($('#pagamentoReservaVO.bcNumDocumento').val()=='')
			return false;
		if($('#pagamentoReservaVO.bcValidadeCartao').val()=='' || !verificaValidade(document.getElementById('pagamentoReservaVO.bcValidadeCartao')))
			return false;
		if($('#pagamentoReservaVO.bcCodigoSeguranca').val()=='')
			return false;
	}
    if (document.getElementById('pagamentoReservaVO.bcValor').value!='')  {
        index = document.getElementById('pagamentoReservaVO.bcIdTipoLancamento').selectedIndex;    
        document.forms[0].action = '<s:url namespace="/app/reserva" action="include" method="adicionarPagamento" />';
        document.forms[0].formaPgtoSel.value = document.getElementById('pagamentoReservaVO.bcIdTipoLancamento').options[index].text;
        document.forms[0].idIdentificaLancamento.value = getIdentificaLancamentoSelecionado();
        submitForm(document.forms[0]);
    }
    else
        alerta('- Insira o valor.');
}

function excluirPagamento(indicePagamento, checkin){
	if (checkin == 'S')
        alerta('- Não é possivel excluir pagamento com checkin.');
    else{
	    document.forms[0].action = '<s:url namespace="/app/reserva" action="include" method="excluirPagamento" />';
	    document.forms[0].indicePagamento.value = indicePagamento;
	    submitForm(document.forms[0]);
    }
}

function carregaTipoPagamento(obj) {
	loading();
    submitFormAjax('carregarTipoPagamentoReserva?formaPg='+obj.value,true);
}

function getTipoPagamentoSelecionado(){
	var select = document.getElementById('pagamentoReservaVO.bcFormaPg');
	return select.options[select.selectedIndex].value;
}

function getIdentificaLancamentoSelecionado(){
	var select = document.getElementById('pagamentoReservaVO.bcIdTipoLancamento');
	return select.options[select.selectedIndex].getAttribute('identificaLancamento');
}

function ativarDesativarCofan(obj){

	var tpPagamento = getTipoPagamentoSelecionado();
	var ativarCofan = (tpPagamento == 'A' ? true : false);
	document.getElementById('movimentoApartamento.checkinEJB.idCheckin').disabled = ! ativarCofan;
	
}

function setValor(valor){	
	document.getElementById('pagamentoReservaVO.bcValor').value = valor;	
}

</script>
<body>

<div class="divGrupo" style="overflow: auto; margin-top:0px;width:965px; height:98%; border:0px;">
<s:form namespace="/app/reserva" action="include!adicionarReservaApto" theme="simple">
                <s:hidden name="indicePagamento" />
                <s:hidden name="formaPgtoSel"/>
                <s:hidden id="idIdentificaLancamento" name="idIdentificaLancamento"/>
                <div class="divLinhaCadastroPrincipal" style="width:99%; float:left;  height: 40px;">
                    <div class="divItemGrupo" style="width:75pt;" ><p style="color:white;">Forma PGTO:</p><br/> 
                            <select name="pagamentoReservaVO.bcFormaPg" id="pagamentoReservaVO.bcFormaPg" style="width:70pt;" onchange="carregaTipoPagamento(this);">
                                <option value="F">Faturado</option>
                                <option value="A">Antecipado</option>
                                <option value="D">Direto</option> 
                            </select>
                    </div>
                    <div class="divItemGrupo" style="width:115px;" ><p style="color:white;">Tipo PGTO:</p><br/> 
                            <select name="pagamentoReservaVO.bcIdTipoLancamento"  
                             id="pagamentoReservaVO.bcIdTipoLancamento" style="width: 110px">
								<s:iterator value="listFormaPgto" status="row" >
									<option value='<s:property value="bcIdTipoLancamento" />' identificaLancamento='<s:property value="bcIdIdentificaLancamento" />'>
										<s:property	value="bcFormaPg" />
									</option>
								</s:iterator>
							</select>
                            
                                                        
                    </div>
                    <div class="divItemGrupo" style="width:100px;" ><p style="width:40pt; color:white;">Valor:</p> <br/>
                            <s:textfield id="pagamentoReservaVO.bcValor" name="pagamentoReservaVO.bcValor" onkeypress="mascara(this, moeda);" size="12" maxlength="12" /> 
                    </div>
                    
                    <div class="divItemGrupo" style="width:80pt;" ><p style="width:60pt; color:white;">Data:</p> <br/>
                            <s:textfield cssClass="dp" name="pagamentoReservaVO.bcDataConfirma" id="pagamentoReservaVO.bcDataConfirma" onkeypress="mascara( this, data );" onblur="dataValida(this);" size="8" maxlength="10" />
                    </div>
                    <div class="divItemGrupo" style="width:150px;" ><p style="width:80pt; color:white;">Nome:</p> <br/>
                            <s:textfield id="pagamentoReservaVO.bcNomeCartao" name="pagamentoReservaVO.bcNomeCartao" size="22" maxlength="50" onkeypress="" />
                           
                    </div>
                    <div class="divItemGrupo" style="width:157px;" ><p style="width:170pt; color:white;">Num. Doc.:</p> <br/>
                            <s:textfield name="pagamentoReservaVO.bcNumDocumento" id="pagamentoReservaVO.bcNumDocumento" size="24" maxlength="20" /> 
                    </div>
                    <div class="divItemGrupo" style="width:57px;" ><p style="width:40pt; color:white;">Validade:</p> <br/>
                            <s:textfield id="pagamentoReservaVO.bcValidadeCartao" name="pagamentoReservaVO.bcValidadeCartao" size="4" maxlength="7" onkeypress="mascara(this,validadeCartao)" onblur="dataValida(this); verificaValidade(this);"/> 
                    </div>
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:40pt; color:white;">Cod.Seg:</p> <br/>
                            <s:textfield id="pagamentoReservaVO.bcCodigoSeguranca" name="pagamentoReservaVO.bcCodigoSeguranca" size="3" maxlength="4" /> 
                    </div>
                    <div class="divItemGrupo" style="width:85px;" ><p style="width:75pt; color:white;">Apto:</p> <br/>
                             
                            <s:select list="listApartamentoCofan" cssStyle="width:85px;" id="movimentoApartamento.checkinEJB.idCheckin" 
                            	name="movimentoApartamento.checkinEJB.idCheckin" listKey="idCheckin" headerKey="0" headerValue="Selecione" listValue="bcObservacao" disabled="not #session.ATIVAR_COFAN"/>                            
                    </div>
                    
                    <!-- div class="divItemGrupo" style="width:65px;" ><p style="width:30pt; color:white;">Conf.:</p><br/>
                            <select name="pagamentoReservaVO.bcConfirma" style="width:50px;">
                                <option value="S">Sim</option>
                                <option value="N">Não</option>
                            </select>
                    </div -->
                  
                  <div class="divItemGrupo" style="width:18px;" >
                  		<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png" title="Adicionar reserva pagamento" style="margin:0px;" onclick="adicionarPagamento();"/>
                  </div>
                    
                </div>
                
            <s:iterator value="#session.TELA_RESERVA_PAGAMENTO_RESERVA" var="resPgtoCorr" status="row" >
            	
                    <div class="divLinhaCadastro" id="divLinha${row.index}" style="width:99%;background-color: rgb(255,165,165);">
                        <div class="divItemGrupo" style="width:75pt;" ><p><s:property  value="bcFormaPgDesc" /></p></div>
                        <div class="divItemGrupo" style="width:115px;" ><p><s:property  value="bcBandeira" /></p></div>
                        <div class="divItemGrupo" style="width:100px;" ><p style="width:40pt;"><s:property  value="bcValor" /></p></div>
                        <div class="divItemGrupo" style="width:80pt;" ><p style="width:60pt;"><s:property  value="bcDataConfirma" /></p></div>
                        <div class="divItemGrupo" style="width:150px;" ><p style="width:110pt;"><s:property  value="bcNomeCartao" /></p></div>
                        <div class="divItemGrupo" style="width:157px;" ><p style="width:95pt;"><s:property  value="bcNumDocumento" /></p></div>
                        <div class="divItemGrupo" style="width:57px;" ><p style="width:40pt;"><s:property  value="bcValidadeCartao" /></p></div>
                        <div class="divItemGrupo" style="width:54px;" ><p style="width:40pt;"><s:property  value="bcCodigoSeguranca" /></p></div>
                        <div class="divItemGrupo" style="width:84px;" ><p style="width:40pt;"><s:property  value="dsAptoCofan" /></p></div>
                        <!-- div class="divItemGrupo" style="width:65pt;" ><p style="width:30pt"><s:property  value="bcConfirmaDesc" /></p></div -->
                        <div class="divItemGrupo" style="width:20px;" >
                        <s:if test="bcIdMovimentoApartamento == null">
                        	<img width="30px" height="30px" title="Excluir pagamento apartamento" src="imagens/iconic/png/x-3x.png" onclick="excluirPagamento('${row.index}', '<s:property  value="bcCheckin" />')"/>
						</s:if>
                        </div>
                        <!-- div class="divItemGrupo" style="width:35pt;" ><img width="30px" height="30px" title="Excluir pagamento apartamento" src="imagens/iconic/png/arrow-thick-bottom-3x.png" onclick="abrirCheckout()"/></div -->
                    </div>
            </s:iterator>

                
                
</s:form>                
</div>
</body>
</html>