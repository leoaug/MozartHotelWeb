<%@page contentType="text/html;charset=iso-8859-1"%>
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

	if ($('.valorTes').get(0).value == ''){
		parent.alerta("O campo 'Valor' é obrigatório");
		return false;
	}

	if ($('.idPlanoContas').get(0).value == ''){
		parent.alerta("O campo 'Conta' é obrigatório");
		return false;
	}

	if ($('.idCentroCustoTes').get(0).value == ''){
		parent.alerta("O campo 'C.Custo' é obrigatório");
		return false;
	}

	if ($('.idHistorico').get(0).value == ''){
		parent.alerta("O campo 'Histórico' é obrigatório");
		return false;
	}
	
	var selected = $("#contaCorrente0 option:selected");    
	cc = selected.text();
	$('#contaCorrenteTxt').val(cc);
	parent.loading();
    document.forms[0].submit();
}

function excluirLancamento(idx){
	if (confirm('Confirma a exclusão do lançamento?')){
	    document.forms[0].action = '<s:url namespace="/app/financeiro" action="includeTesouraria" method="excluirLancamento" />';
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
	sincronzaContaReturn(null, ' | ');
	parent.loading();
	submitFormAjax('obterComplementoConta?idPlanoContas='+obj.value+'&debitoCredito='+$(".debitoCreditoTes").get(idx).value,true);
}

function sincronzaDebitoCredito( obj ){
	calcularValor();
	idx = $(".debitoCreditoTes").index( obj );
	idPlano = $(".idPlanoContasNome").get(idx).value;
	sincronzaContaReturn(null, ' | ');
	parent.loading();
	submitFormAjax('obterComplementoConta?idPlanoContas='+idPlano+'&debitoCredito='+obj.value,true);
}

function sincronzaContaReturn(idHistorico, valorComboCC){
	//pegar o idx
	killModalPai();
	$(".idHistorico").get(idx).value = idHistorico;

	if (valorComboCC!=''){
		var cc = "contaCorrente"+idx;
		preencherComboBoxJS(cc, valorComboCC);
	}
}


function atualizarDadosDefault(dia, idClassificacaoPadrao, valor ){
	parent.loading();
	vForm = document.forms[0]; 
	$('#idClassificacaoContabil').val( idClassificacaoPadrao );
	$('#diaLancamento').val( dia );
	$('#valorPadrao').val( valor );
	vForm.action = '<s:url namespace="/app/financeiro" action="includeTesouraria" method="obterClassificacaoPadrao" />';
    vForm.submit();
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
	vForm.action = '<s:url namespace="/app/financeiro" action="includeTesouraria" method="gravar" />';
    vForm.submit();
}


function resetLancamento(){
	$('.debitoCreditoTes').get(0).value= "D";
	$('.idPlanoContas').get(0).value= "";
	//$('.idCentroCustoTes').get(0).value= "";
	//$('.idHistorico').get(0).value= "";
	$('.idPlanoContasNome').get(0).value= "";
	$('.controleAtivoTes').get(0).value= "";
	preencherComboBoxJS("contaCorrente0", ",");
	$('.complementoTes').get(0).value= "";
	$('.valorTes').get(0).value= "";
	$('.pisTes').get(0).value= "S";
}

function calcularValor(){

	var qtde = $(".debitoCreditoTes").length;
	var valorD = 0.0;
	var valorC = 0.0;
	
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
<div class="divGrupo" style="overflow: auto; margin-top:0px;width:965px; height:98%; border:0px;">
<s:form namespace="/app/financeiro" action="includeTesouraria!incluirLancamento" theme="simple">

                <s:hidden name="indice" id="indice" />
                <s:hidden name="contaCorrenteTxt" id="contaCorrenteTxt" />
                <s:hidden name="idMovimento" />
                <s:hidden name="valorPadrao" id="valorPadrao" />
                <s:hidden name="idPlanoContasFinanceiro" id="idPlanoContasFinanceiro" />
                <s:hidden name="classificacaoPadrao" id="idClassificacaoContabil" />
                <s:hidden name="diaLancamento" id="diaLancamento" />
                <s:hidden name="dataLancamento"  value="%{#session.CONTROLA_DATA_SESSION.tesouraria}" />
                <s:hidden name="origemMovimento" value="TESOURARIA"/>
                
                
				<div class="divLinhaCadastroPrincipal" style="margin-bottom:0px; border: 0px;width:945px; float:left;  height: 20px;">

                    <div class="divItemGrupo" style="width:145px;" ><p style="color:white;width:70px;">D/C:</p>
                    	<span id="comboDebitoCredito">
						<s:select id="debitoCredito" name="debitoCreditoTes" cssClass="debitoCreditoTes" 
								  cssStyle="width:70px;" 
								  list="debitoCreditoList"
								  listKey="id"
								  listValue="value" />
						</span>
                    </div>
                    <div class="divItemGrupo" style="width:365px;" ><p style="color:white;width:60px;">Conta:</p>
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

                    <div class="divItemGrupo" style="width:95px;" ><p style="color:white;width:50px;">C. Ativo:</p>
						<s:textfield name="controleAtivoTes" cssClass="controleAtivoTes" onkeypress="mascara(this, numeros)" size="2" maxlength="5" />	
                    </div>
                    <div class="divItemGrupo" style="width:85px;" ><p style="color:white;width:30px;">Pis:</p>
                    	<s:select list="#session.LISTA_CONFIRMACAO"
                    			cssStyle="width:50px"
                    			listKey="id"
                    			listValue="value"
                    			name="pisTes"
                    			cssClass="pisTes"
                    	 />
                    </div>

                    <div class="divItemGrupo" style="width:245px;" >
                    		<p style="color:white;width:90px;">Conta corrente:</p>
							<select name="contaCorrenteTes" id="contaCorrente0" style="width:150px;">
								<option value="1"></option>
							</select>
                    </div>
					
				</div>
				
				<div class="divLinhaCadastroPrincipal" style="width:945px; float:left;  height: 20px;">
                    <div class="divItemGrupo" style="width:285px;" ><p style="color:white;width:70px;">Histórico:</p>
						<s:select name="idHistoricoTes"
								  cssClass="idHistorico"
								  id="idHistorico" 
								  cssStyle="width:190px;" 
								  list="historicoList"
								  listKey="idHistorico"
								  listValue="historico" />
                    </div>
                    <div class="divItemGrupo" style="width:225px;" ><p style="color:white;width:60px;">Compl.:</p>
						<s:textfield name="complementoTes" cssClass="complementoTes" onblur="toUpperCase(this)" size="20" maxlength="50" />
                    </div>
					
					<div class="divItemGrupo" style="width:150px;" ><p style="color:white;width:50px;">Valor:</p>
						<s:textfield name="valorTes" cssStyle="text-align:right;" cssClass="valorTes" onkeypress="mascara(this, moeda)" size="10" maxlength="10" />	
                    </div>


                    <div class="divItemGrupo" style="width:245px;" ><p style="color:white;width:90px;">C.Custo:</p>
						<s:select name="idCentroCustoTes" id="idCentroCustoTes" cssClass="idCentroCustoTes" 
								  cssStyle="width:150px;"
								  list="centroCustoList"
								  listKey="idCentroCustoContabil"
								  listValue="descricaoCentroCusto" />
                    </div>

					
					<div class="divItemGrupo" style="width:31px;" >
                  		<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png" title="Adicionar lançamento" style="margin:0px;" onclick="adicionarLancamento();"/>
					</div>
				</div>  
            
			<s:set name="valorD" value="%{0.0}" />
			<s:set name="valorC" value="%{0.0}" />
            <s:iterator value="#session.entidadeSession" var="obj" status="row" >
            		
					<s:hidden name="idMovimento" />
					<s:if test="%{debitoCredito == \"D\"}">
						<s:set name="valorD" value='%{#valorD + #obj.valor}' />
					</s:if>
					<s:else>
						<s:set name="valorC" value='%{#valorC + #obj.valor}' />
					</s:else>

					
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
							
							<div class="divItemGrupo" style="width:95px;" ><p style="width:50px;">C. Ativo:</p>
								<s:textfield name="controleAtivoTes" onkeypress="mascara(this, numeros)" size="2" maxlength="5" value="%{#obj.controleAtivoFixo}"/>	
							</div>

		                    <div class="divItemGrupo" style="width:85px;" ><p style="width:30px;">Pis:</p>
		                    	<s:select list="#session.LISTA_CONFIRMACAO"
		                    			cssStyle="width:50px"
		                    			listKey="id"
		                    			listValue="value"
		                    			name="pisTes"
		                    			cssClass="pisTes"
		                    			value="%{#obj.pis}"
		                    	 />
		                    </div>

							<div class="divItemGrupo" style="width:245px;" ><p style="width:90px;">Conta corrente:</p>
								<select name="contaCorrenteTes" id="contaCorrente${row.index+1}" style="width:150px;">
									<option value='<s:property value="contaCorrente" />'><s:property value="contaCorrenteTxt" /></option>
								</select>
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

							<div class="divItemGrupo" style="width:150px;" ><p style="width:50px;">Valor:</p>
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
								<img width="30px" height="30px" title="Excluir lançamento" src="imagens/iconic/png/x-3x.png" onclick="excluirLancamento('${row.index}')"/>
							</div>
						</div>
            </s:iterator>
            
</s:form>                
</div>
</body>

<script>
	parent.atualizarTotal('<s:property value="%{#valorD}" />', '<s:property value="%{#valorC}" />' );
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