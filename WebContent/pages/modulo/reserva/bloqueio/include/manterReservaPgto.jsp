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


function adicionarPagamento(){
    if (document.getElementById('pagamentoReservaVO.bcValor').value!='')  {
        index = document.getElementById('pagamentoReservaVO.bcIdTipoLancamento').selectedIndex;    
        document.forms[0].action = '<s:url namespace="/app/bloqueio" action="include" method="adicionarPagamento" />';
        document.forms[0].formaPgtoSel.value = document.getElementById('pagamentoReservaVO.bcIdTipoLancamento').options[index].text;
        submitForm(document.forms[0]);
    }
    else
        alerta('- Insira o valor.');
}

function excluirPagamento(indicePagamento){
    document.forms[0].action = '<s:url namespace="/app/bloqueio" action="include" method="excluirPagamento" />';
    document.forms[0].indicePagamento.value = indicePagamento;
    submitForm(document.forms[0]);
}

function carregaTipoPagamento(obj) {
	loading();
    submitFormAjax('carregarTipoPagamentoReserva?formaPg='+obj.value,true);
}

function setValor(valor){	
	document.getElementById('pagamentoReservaVO.bcValor').value = valor;	
}

</script>
<body>

<div class="divGrupo" style="overflow: auto; margin-top:0px;width:965px; height:98%; border:0px;">
<s:form namespace="/app/bloqueio" action="include!adicionarReservaApto" theme="simple">
                <s:hidden name="indicePagamento" />
                <s:hidden name="formaPgtoSel"/>
                <div class="divLinhaCadastroPrincipal" style="width:99%; float:left;  height: 40px;">
                    <div class="divItemGrupo" style="width:85pt;" ><p style="color:white;">Forma PGTO:</p><br/> 
                            <select name="pagamentoReservaVO.bcFormaPg" style="width:70pt;" onchange="carregaTipoPagamento(this);">
                                <option value="F">Faturado</option>
                                <option value="A">Antecipado</option>
                                <option value="D">Direto</option> 
                            </select>
                    </div>
                    <div class="divItemGrupo" style="width:115px;" ><p style="color:white;">Tipo PGTO:</p><br/> 
                            <s:select list="listFormaPgto" cssStyle="width:110px;" id="pagamentoReservaVO.bcIdTipoLancamento" name="pagamentoReservaVO.bcIdTipoLancamento" listKey="bcIdTipoLancamento" listValue="bcFormaPg"/>                            
                    </div>
                    <div class="divItemGrupo" style="width:65px;" ><p style="width:40pt; color:white;">Validade:</p> <br/>
                            <s:textfield id="pagamentoReservaVO.bcValidadeCartao" name="pagamentoReservaVO.bcValidadeCartao" size="2" maxlength="2" onkeypress="mascara(this,numeros)" /> 
                    </div>
                    <div class="divItemGrupo" style="width:110px;" ><p style="width:40pt; color:white;">Valor:</p> <br/>
                            <s:textfield id="pagamentoReservaVO.bcValor" name="pagamentoReservaVO.bcValor" onkeypress="mascara(this, moeda);" size="12" maxlength="12" /> 
                    </div>
                    
                    <div class="divItemGrupo" style="width:90pt;" ><p style="width:60pt; color:white;">Data:</p> <br/>
                            <s:textfield cssClass="dp" name="pagamentoReservaVO.bcDataConfirma" id="pagamentoReservaVO.bcDataConfirma" onkeypress="mascara( this, data );" onblur="dataValida(this);" size="10" maxlength="10" />
                    </div>
                    <div class="divItemGrupo" style="width:110px;" ><p style="width:60pt; color:white;">Num. Doc.:</p> <br/>
                            <s:textfield name="pagamentoReservaVO.bcNumDocumento" id="pagamentoReservaVO.bcNumDocumento" size="12" maxlength="20" /> 
                    </div>
                    
                    <div class="divItemGrupo" style="width:80px;" ><p style="width:30pt; color:white;">Conf.:</p><br/>
                            <select name="pagamentoReservaVO.bcConfirma" style="width:40px;">
                                <option value="S">Sim</option>
                                <option value="N">Não</option>
                            </select>
                    </div>
                  
                  <div class="divItemGrupo" style="width:35px;" >
                  		<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png" title="Adicionar reserva pagamento" style="margin:0px;" onclick="adicionarPagamento();"/>
                  </div>
                    
                </div>
                
            <s:iterator value="#session.TELA_RESERVA_PAGAMENTO_RESERVA" var="resPgtoCorr" status="row" >
                    <div class="divLinhaCadastro" id="divLinha${row.index}" style="width:98%;background-color: rgb(255,165,165);">
                        <div class="divItemGrupo" style="width:85pt;" ><p><s:property  value="bcFormaPgDesc" /></p></div>
                        <div class="divItemGrupo" style="width:125px;" ><p><s:property  value="bcTipoLancamento" /></p></div>
                        <div class="divItemGrupo" style="width:65px;" ><p style="width:40pt;"><s:property  value="bcValidadeCartao" /></p></div>
                        <div class="divItemGrupo" style="width:110px;" ><p style="width:40pt;"><s:property  value="bcValor" /></p></div>
                        <div class="divItemGrupo" style="width:90pt;" ><p style="width:60pt;"><s:property  value="bcDataConfirma" /></p></div>
                        <div class="divItemGrupo" style="width:110px;" ><p style="width:95pt;"><s:property  value="bcNumDocumento" /></p></div>
                        <div class="divItemGrupo" style="width:90pt;" ><p style="width:30pt"><s:property  value="bcConfirmaDesc" /></p></div>
                        <div class="divItemGrupo" style="width:35pt;" ><img width="30px" height="30px" title="Excluir pagamento apartamento" src="imagens/iconic/png/x-3x.png" onclick="excluirPagamento('${row.index}')"/></div>
                    </div>
            </s:iterator>

                
                
</s:form>                
</div>
</body>
</html>