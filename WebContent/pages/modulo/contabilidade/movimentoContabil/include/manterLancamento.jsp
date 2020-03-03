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

function adicionarLancamento(){

	if ($(".quantidadeControleAtivo").val() == 0 && $(".controleAtivoTes").val() != ''){
		alert('Campo C. Ativo não deve ser preenchido.');
	}

	if ($('.valorTes').get(0).value == ''){
		parent.alerta("O campo 'Valor' é obrigatório");
		return false;
	}

	if ($('.idPlanoContas').get(0).value == ''){
		parent.alerta("O campo 'Conta' é obrigatório");
		return false;
	}
	
	parent.loading();
    document.forms[0].submit();
}

function excluirLancamento(idx){
	if (confirm('Confirma a exclusão do lançamento?')){
	    document.forms[0].action = '<s:url namespace="/app/contabilidade" action="includeMovimentoContabil" method="excluirLancamento" />';
	    $('#indice').val( idx );
	    parent.loading();
	    document.forms[0].submit();
	}
}
var idx = -1;
function sincronzaConta( obj ){
	idx = $(".idPlanoContasNome").index( obj );
	if (idx == -1)
		idx = $(".idPlanoContas").index( obj );
	$(".idPlanoContasNome").get(idx).value = obj.value;
	$(".idPlanoContas").get(idx).value = obj.value;
	parent.loading();
	submitFormAjax('obterComplementoConta?idPlanoContas='+obj.value+'&debitoCredito='+$(".debitoCreditoTes").get(idx).value,true);
	submitFormAjax('obterQuantidadeControleAtivo?idPlanoContas='+obj.value,true);
}

function sincronzaDebitoCredito( obj ){
	calcularValor();
	idx = $(".debitoCreditoTes").index( obj );
	idPlano = $(".idPlanoContasNome").get(idx).value;
	parent.loading();
	submitFormAjax('obterComplementoConta?idPlanoContas='+idPlano+'&debitoCredito='+obj.value,true);
}

function sincronzaContaReturn(idHistorico, valorComboCC){
	killModalPai();
	$(".idHistorico").get(idx).value = idHistorico;

}
function atualizarQuantidadeControleAtivo(quantidade){
	killModalPai();
	$(".quantidadeControleAtivo").get(0).value = quantidade;
	if(quantidade == 0){
		$('.controleAtivoTes').value= "";
		$('.controleAtivoTes').attr('readonly', true);
		$('.controleAtivoTes').css("background-color", "silver");
	}
	else{
		$('.controleAtivoTes').value= "";
		$('.controleAtivoTes').attr('readonly', false);
		$('.controleAtivoTes').css("background-color", "white");
	}
}


function atualizarDadosDefault(dia, idClassificacaoPadrao, valor){
	parent.loading();
	vForm = document.forms[0]; 
	$('#idClassificacaoContabil').val( idClassificacaoPadrao );
	$('#diaLancamento').val( dia );
	$('#valorPadrao').val( valor );
	vForm.action = '<s:url namespace="/app/contabilidade" action="includeMovimentoContabil" method="obterClassificacaoPadrao" />';
    vForm.submit();
}

function setSeqContabil(sequencia){
	$('#seqContabil').val( sequencia );
}



function killModalPai(){
	parent.killModal();
}

function setPlanoContaFinanceiro(idPlanoContaFinanceiro){
	$('#idPlanoContasFinanceiro').val( idPlanoContaFinanceiro );
}

function gravar(){
	parent.loading();
		
	if ($('#diaLancamento').val()==''){
		$('#diaLancamento').val(
			parent.document.forms[0].diaLancamento.value
		);
	}
	
	vForm = document.forms[0]; 
	vForm.action = '<s:url namespace="/app/contabilidade" action="includeMovimentoContabil" method="gravar" />';
    vForm.submit();
}


function resetLancamento(){
	$('.debitoCreditoTes').get(0).value= "D";
	$('.idPlanoContas').get(0).value= "";
	$('.idPlanoContasNome').get(0).value= "";
	$('.controleAtivoTes').get(0).value= "";
	$('.complementoTes').get(0).value= "";
	$('.valorTes').get(0).value= "";
	$('.pisTes').get(0).value= "S";
}

function calcularValor(){

	var qtde = $(".debitoCreditoTes").length;
	var valorD = toFloat( $("input[name='saldoMovimento.totalDebito']").val() );
	var valorC = toFloat( $("input[name='saldoMovimento.totalCredito']").val() );
	
	for (x=1;x<qtde;x++){
		if ("D" ==  $(".debitoCreditoTes").get(x).value){
			valorD += toFloat($(".valorTes").get(x).value);
		}else{
			valorC += toFloat($(".valorTes").get(x).value);
		}
	}

	parent.atualizarTotal( moeda(numeros(arredondaFloat(valorD).toString())),
			   			   moeda(numeros(arredondaFloat(valorC).toString())));
}
</script>
<body>
<div class="divGrupo" style="overflow: auto; margin-top:0px;width:100%; height:98%; border:0px;">
<s:form namespace="/app/contabilidade" action="includeMovimentoContabil!incluirLancamento" theme="simple">

                <s:hidden name="indice" id="indice" />
                <s:hidden name="status" id="status" />
                <s:hidden name="valorPadrao" id="valorPadrao" />
                <s:hidden name="seqContabil" id="seqContabil" />
                <s:hidden name="idPlanoContasFinanceiro" id="idPlanoContasFinanceiro" />
                <s:hidden name="classificacaoPadrao" id="idClassificacaoContabil" />
                <s:hidden name="diaLancamento" id="diaLancamento" />
                <s:hidden name="contaCorrenteTes" value=""  />
                <s:hidden name="dataLancamento"  value="%{#session.CONTROLA_DATA_SESSION.contabilidade}" />
				<s:hidden name="saldoMovimento.totalCredito"/>
				<s:hidden name="saldoMovimento.totalDebito"/>
				<s:hidden name="saldoMovimento.diferenca"/>
				<s:hidden name="origemMovimento" value="CONTABILIDADE"/>
                <s:hidden name="idMovimento" value=""  />
                
				<div class="divLinhaCadastroPrincipal" style="margin-bottom:0px; border: 0px;width:100%; float:left;  height: 20px;">

                    <div class="divItemGrupo" style="width:25%;" ><p style="color:white;width:48px;">D/C:</p>
                    	<span id="comboDebitoCredito">
						<s:select id="debitoCredito" name="debitoCreditoTes" cssClass="debitoCreditoTes" 
								  cssStyle="width:70px;" 
								  list="debitoCreditoList"
								  listKey="id"
								  listValue="value" />
						</span>
                    </div>
                    <div class="divItemGrupo" style="width:32%;" ><p style="color:white;width:36px;">Conta:</p>
						<s:select name="idPlanoContaTes" cssClass="idPlanoContas" id="idPlanoContas" onchange="sincronzaConta(this)" 
								  cssStyle="width:90px;" 
								  list="planoContaList"
								  listKey="idPlanoContas"
								  listValue="contaReduzida"
								  headerKey=""
								  headerValue="Selecione" />
								  
						<s:select name="idPlanoContaNomeTes" cssClass="idPlanoContasNome" id="idPlanoContasNome"  onchange="sincronzaConta(this)"
								  cssStyle="width:175px;" 
								  list="planoContaList"
								  listKey="idPlanoContas"
								  listValue="nomeConta" 
								  headerKey=""
								  headerValue="Selecione"/>
		  
                    </div>

                    <div class="divItemGrupo" style="width:13%;" ><p style="color:white;width:44px;">C. Ativo:</p>
						<s:textfield name="controleAtivoTes" cssClass="controleAtivoTes" onkeypress="mascara(this, numeros)" size="10" maxlength="5" />
						<s:hidden cssClass="quantidadeControleAtivo" name="quantidadeControleAtivo" id="quantidadeControleAtivo" />	
                    </div>
 					<div class="divItemGrupo" style="width:20%;" ><p style="color:white;width:57px;">Pis:</p>
                    	<s:select list="#session.LISTA_CONFIRMACAO"
                    			cssStyle="width:50px"
                    			listKey="id"
                    			listValue="value"
                    			name="pisTes"
                    			cssClass="pisTes"
                    	 />
                    </div>
					
				</div>
				
				<div class="divLinhaCadastroPrincipal" style="width:100%; float:left;  height: 20px;">
                    <div class="divItemGrupo" style="width:25%;" ><p style="color:white;width:48px;">Histórico:</p>
						<s:select name="idHistoricoTes"
								  cssClass="idHistorico"
								  id="idHistorico" 
								  cssStyle="width:190px;" 
								  list="historicoList"
								  listKey="idHistorico"
								  listValue="historico" />
                    </div>
                    <div class="divItemGrupo" style="width:32%;" ><p style="color:white;width:36px;">Compl.:</p>
						<s:textfield name="complementoTes" cssClass="complementoTes" onblur="toUpperCase(this)" size="20" maxlength="50" />
                    </div>
					
					<div class="divItemGrupo" style="width:13%;" ><p style="color:white;width:45px;">Valor:</p>
						<s:textfield name="valorTes" cssClass="valorTes" cssStyle="text-align:right;" onkeypress="mascara(this, moeda)" size="10" maxlength="10" />	
                    </div>


                    <div class="divItemGrupo" style="width:25%;" ><p style="color:white;width:57px;">C.Custo:</p>
						<s:select name="idCentroCustoTes" cssClass="idCentroCustoTes" 
								  cssStyle="width:150px;" 
								  list="centroCustoList"
								  listKey="idCentroCustoContabil"
								  listValue="descricaoCentroCusto" />
                    </div>

					
					<div class="divItemGrupo" style="width:3%;" >
						<s:if test="%{status != \"alteracao\"}">
                  			<img width="30px" height="16px" src="imagens/iconic/png/plus-3x.png" title="Adicionar lançamento" style="margin:0px;" onclick="adicionarLancamento();"/>
                  		</s:if>
					</div>
				</div>  
            
			<s:set name="valorD" value="%{0.0}" />
			<s:set name="valorC" value="%{0.0}" />
            <s:iterator value="#session.entidadeSession" var="obj" status="row" >
            		<s:hidden name="contaCorrenteTes" value=""  />
            		<input type="hidden" name="idMovimento" value="<s:property value="idMovimentoContabil" />" />
            		
					<s:if test="%{idMovimentoContabil == null}">
						<s:if test="%{debitoCredito == \"D\"}">
							<s:set name="valorD" value='%{#valorD + #obj.valor}' />
						</s:if>
						<s:else>
							<s:set name="valorC" value='%{#valorC + #obj.valor}' />
						</s:else>
					</s:if>

					
						<div class="divLinhaCadastro" id="divLinha${row.index}" style="margin-bottom:0px; border:0px; width:945px;">
							<div class="divItemGrupo" style="width:145px;" ><p style="width:70px;">D/C:</p>
								<s:select id="debitoCredito" cssClass="debitoCreditoTes"  name="debitoCreditoTes" value="%{#obj.debitoCredito}" 
								  onchange="sincronzaDebitoCredito(this)"	
								  cssStyle="width:70px;" 
								  list="debitoCreditoList"
								  listKey="id"
								  listValue="value" />
							</div>
							<div class="divItemGrupo" style="width:365px;" ><p style="width:60px;">Conta:</p>
									<s:select name="idPlanoContaTes" cssClass="idPlanoContas" onchange="sincronzaConta(this)" value="%{#obj.planoContaEJB.idPlanoContas}"
									cssStyle="width:90px;" 
									list="planoContaList"
									listKey="idPlanoContas"
									listValue="contaReduzida"
									 />

									<s:select name="idPlanoContaNomeTes" cssClass="idPlanoContasNome"  onchange="sincronzaConta(this)" value="%{#obj.planoContaEJB.idPlanoContas}"
									cssStyle="width:175px;" 
									list="planoContaList"
									listKey="idPlanoContas"
									listValue="nomeConta" 
									/>
							</div>

							<div class="divItemGrupo" style="width:150px;" ><p style="width:60px;">C. Ativo:</p>
								<s:textfield name="controleAtivoTes" onkeypress="mascara(this, numeros)" size="10" maxlength="5" value="%{#obj.controleAtivoFixo}"/>	
							</div>
							<div class="divItemGrupo" style="width:85px;" ><p style="color:white;width:30px;">Pis:</p>
                    			<s:select list="#session.LISTA_CONFIRMACAO"
		                    			cssStyle="width:50px"
		                    			listKey="id"
		                    			listValue="value"
		                    			name="pisTes"
		                    			cssClass="pisTes"
		                    			value="%{#obj.pis}"
		                    	 />
		                    </div>
							

						</div>
						

						<div class="divLinhaCadastro" id="divLinha${row.index}" style="margin-bottom:2px; border-bottom:1px solid black; width:945px;">
							<div class="divItemGrupo" style="width:285px;" ><p style="width:70px;">Histórico:</p>
								<s:select name="idHistoricoTes" value="%{#obj.historicoContabilEJB.idHistorico}"
								cssClass="idHistorico" 
								cssStyle="width:190px;" 
								list="historicoList"
								listKey="idHistorico"
								listValue="historico" />
							</div>
							<div class="divItemGrupo" style="width:225px;" ><p style="width:60px;">Compl.:</p>
								<s:textfield name="complementoTes" onblur="toUpperCase(this)" size="20" maxlength="50" value="%{#obj.numDocumento}" />
							</div>

							<div class="divItemGrupo" style="width:150px;" ><p style="width:60px;">Valor:</p>
									<s:textfield name="valorTes" cssClass="valorTes" cssStyle="text-align:right;" onkeyup="calcularValor()" onkeypress="mascara(this, moeda)" value="%{#obj.valor}" size="10" maxlength="10" />
							</div>


							<div class="divItemGrupo" style="width:245px;" ><p style="width:90px;">C.Custo:</p>
								<s:select name="idCentroCustoTes" cssClass="idCentroCustoTes" value="%{#obj.centroCustoContabilEJB.idCentroCustoContabil}" 
								cssStyle="width:140px;" 
								list="centroCustoList"
								listKey="idCentroCustoContabil"
								listValue="descricaoCentroCusto" />
							</div>
							<div class="divItemGrupo" style="width:31px;" >
								<s:if test="%{status != \"alteracao\"}">
                  					<img width="30px" height="30px" title="Excluir lançamento" src="imagens/iconic/png/x-3x.png" onclick="excluirLancamento('${row.index}')"/>
                  				</s:if>
							
								
							</div>
						</div>
            </s:iterator>
            
</s:form>                
</div>
</body>

<script>
	parent.atualizarTotal('<s:property value="%{#valorD + saldoMovimento.totalDebito}" />', '<s:property value="%{#valorC + saldoMovimento.totalCredito}" />' );
	killModalPai();
	resetLancamento();
	<s:if test="%{operacaoRealizada}">
		parent.reset();
		parent.alerta('<s:property value="mensagemPai" />');
	</s:if>
	<s:elseif test="%{mensagemPai != null && mensagemPai != \"\"}">
		parent.alerta('<s:property value="mensagemPai" />');
	</s:elseif>
</script>

</html>