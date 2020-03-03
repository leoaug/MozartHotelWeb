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

	var valor = parent.document.forms[0].elements["entidadeCP.valorBruto"].value;

	if ($('.valorLancamento').get(0).value == ''){
		parent.alerta("O campo 'Valor' é obrigatório");
		return false;
	}

	if ($('.idPlanoContas').get(0).value == ''){
		parent.alerta("O campo 'Conta' é obrigatório");
		return false;
	}

	if ($('.idCentroCusto').get(0).value == ''){
		parent.alerta("O campo 'C.Custo' é obrigatório");
		return false;
	}

	if ($('.idHistoricoContabil').get(0).value == ''){
		parent.alerta("O campo 'Histórico' é obrigatório");
		return false;
	}
	
	$("#valor").val (valor);
    submitForm(document.forms[0]);
}

function excluirLancamento(idx){
	if (confirm('Confirma a exclusão do lançamento?')){
	    document.forms[0].action = '<s:url namespace="/app/financeiro" action="include" method="excluirLancamento" />';
	    $('#indice').val( idx );
	    submitForm(document.forms[0]);
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
	submitFormAjax('obterComplementoConta?idPlanoContas='+obj.value+'&debitoCredito='+$(".debitoCredito").get(idx).value,true);
}

function sincronzaContaReturn(idHistorico, valorComboCC){
	killModalPai();
	$(".idHistoricoContabil").get(idx).value = idHistorico;
}

function sincronzaDebitoCredito( obj ){
	calcularValor();
	idx = $(".debitoCredito").index( obj );
	idPlano = $(".idPlanoContasNome").get(idx).value;
	parent.loading();
	submitFormAjax('obterComplementoConta?idPlanoContas='+idPlano+'&debitoCredito='+obj.value,true);
}


function validaDC( obj ){

	idx = $(".lancarContasPagarCredito").index( obj );
	objValor = $(".valorLancamento").get(idx);
	
	$(".valorLancamento").attr("readonly","");
	$(".valorLancamento").css("background-color","white");

	
	if ( obj.value == 'S'){
		$(".lancarContasPagarCredito").val('N');
		obj.value = 'S';

		$(objValor).attr("readonly","true");
		$(objValor).css("background-color","silver");
		$(objValor).val( parent.document.forms[0].elements["entidadeCP.valorBruto"].value );
	}
}


function atualizarDadosDefault( idClassificacaoPadrao  ){

	parent.loading();
	vForm = document.forms[0]; 
	$('#idClassificacaoContabil').val( idClassificacaoPadrao );
	$('#valor').val( parent.document.forms[0].elements["entidadeCP.valorBruto"].value );
	vForm.action = '<s:url namespace="/app/financeiro" action="include" method="obterClassificacaoPadrao" />';
    vForm.submit();
}


function killModalPai(){
	parent.killModal();
}

function resetLancamento(){
	$('.lancarContasPagarCredito').get(0).value= "N";
	$('.debitoCredito').get(0).value= "D";
	$('.idPlanoContas').get(0).value= "";
	$('.idPlanoContasNome').get(0).value= "";
	//$('.idHistoricoContabil').get(0).value= "";
	//$('.idCentroCusto').get(0).value= "";
	$('.controleAtivo').get(0).value= "";
	$('.pis').get(0).value= "N";
	$('.complementoHistorico').get(0).value= "";
	$('.valorLancamento').get(0).value= "";
	
}

function calcularValor(){

	var qtde = $(".debitoCredito").length;
	var valorD = 0.0;
	var valorC = 0.0;
	
	for (x=1;x<qtde;x++){
		if ("D" ==  $(".debitoCredito").get(x).value){
			valorD += toFloat($(".valorLancamento").get(x).value);
		}else{
			valorC += toFloat($(".valorLancamento").get(x).value);
		}
	}

	parent.atualizarTotal(arredondaFloat(valorD).toString().replace('.',','),
						  arredondaFloat(valorC).toString().replace('.',','));
}

function preGravar(){

	qtde = $(".lancarContasPagarCredito").length;
	achou = false;
	for (val = 1;val<qtde;val++){
		if ($(".lancarContasPagarCredito").get(val).value == "S"){
			achou = true;
			break;
		}
	}

	if (!achou){
		parent.alerta("Você deve informar, um lançamento para o Contas a Pagar");
		return false;
	}	

	vForm = document.forms[0];
	parent.loading();
	vForm.action = '<s:url namespace="/app/financeiro" action="include" method="preGravar" />';
    vForm.submit();
}



</script>
<body>
<div class="divGrupo" style="overflow: auto; margin-top:0px;width:965px; height:98%; border:0px;">
<s:form namespace="/app/financeiro" action="include!incluirLancamento" theme="simple">

				<s:hidden name="entidadeCP.valorBruto" id="valor" />
				<s:hidden name="entidadeCP.dataLancamento" id="dataLancamento" />
				<s:hidden name="entidadeCP.contaCorrente" id="contaCorrente" />
				<s:hidden name="idMovimento" />
                <s:hidden name="indice" id="indice" />
                <s:hidden name="classificacaoPadrao" id="idClassificacaoContabil" />

				<div class="divLinhaCadastroPrincipal" style="margin-bottom:0px; border: 0px;width:99%; float:left;  height: 20px;">
                    <div class="divItemGrupo" style="width:150px;" ><p style="color:white;width:70px;">C. Pagar:</p>
                    	
                    	<s:if test="%{#session.entidadeSession.idContasPagar == null}">
							<s:select name="lancarContasPagarCredito" id="lancarContasPagarCredito" cssClass="lancarContasPagarCredito" onchange="validaDC(this)"
									  cssStyle="width:70px;" 
									  list="#session.LISTA_CONFIRMACAO"
									  listKey="id"
									  listValue="value" />
						</s:if>
						<s:else>
							<p style="width:70px;">Não:</p>
							<s:hidden name="lancarContasPagarCredito" id="lancarContasPagarCredito" cssClass="lancarContasPagarCredito"/>
						</s:else>
						
                    </div>
                    <div class="divItemGrupo" style="width:135px;" ><p style="color:white;width:40px;">D/C:</p>
						<s:select id="debitoCredito" name="debitoCredito" cssClass="debitoCredito" 
								  cssStyle="width:70px;" 
								  list="debitoCreditoList"
								  listKey="id"
								  listValue="value" />
                    </div>
                    <div class="divItemGrupo" style="width:310px;" ><p style="color:white;width:60px;">Conta:</p>
						<s:select name="idPlanoContas" id="idPlanoContas" cssClass="idPlanoContas" onchange="sincronzaConta(this)" 
								  cssStyle="width:80px;" 
								  list="planoContaList"
								  listKey="idPlanoContas"
								  listValue="contaReduzidaNomeConta" 
								  headerKey=""
								  headerValue="Selecione" />
						<s:select name="idPlanoContas2" id="idPlanoContasNome" cssClass="idPlanoContasNome" onchange="sincronzaConta(this)"
								  cssStyle="width:150px;" 
								  list="planoContaList"
								  listKey="idPlanoContas"
								  listValue="nomeConta" 
								  headerKey=""
								  headerValue="Selecione" />
		  
                    </div>

                    <div class="divItemGrupo" style="width:150px;" ><p style="color:white;width:60px;">C. Ativo:</p>
						<s:textfield name="controleAtivo" cssClass="controleAtivo" onkeypress="mascara(this, numeros)" size="10" maxlength="5" />	
                    </div>

                    <div class="divItemGrupo" style="width:130px;" ><p style="color:white;width:60px;">PIS:</p>
                    	<s:select name="pis" cssClass="pis"
								  cssStyle="width:60px;" 
								  list="#session.LISTA_CONFIRMACAO"
								  listKey="id"
								  listValue="value" />
                    </div>
					
				</div>
				
				<div class="divLinhaCadastroPrincipal" style="width:99%; float:left;  height: 20px;">
                    <div class="divItemGrupo" style="width:285px;" ><p style="color:white;width:70px;">Histórico:</p>
						<s:select name="idHistoricoContabil" cssClass="idHistoricoContabil" 
								  cssStyle="width:190px;"
								  list="historicoList"
								  listKey="idHistorico"
								  listValue="historico" />
                    </div>
                    <div class="divItemGrupo" style="width:225px;" ><p style="color:white;width:60px;">Compl.:</p>
						<s:textfield name="complementoHistorico" cssClass="complementoHistorico" onblur="toUpperCase(this)" size="20" maxlength="50" />
                    </div>
					
					<div class="divItemGrupo" style="width:150px;" ><p style="color:white;width:60px;">Valor:</p>
						<s:textfield name="valorLancamento" cssClass="valorLancamento" id="valorLancamento" onkeypress="mascara(this, moeda)" size="10" maxlength="10" />	
                    </div>


                    <div class="divItemGrupo" style="width:230px;" ><p style="color:white;width:60px;">C.Custo:</p>
						<s:select name="idCentroCusto" id="idCentroCusto" cssClass="idCentroCusto" 
								  cssStyle="width:140px;"
								  list="centroCustoList"
								  listKey="idCentroCustoContabil"
								  listValue="descricaoCentroCusto" />
                    </div>

					<div class="divItemGrupo" style="width:35px;" >
                  		<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png" title="Adicionar lançamento" style="margin:0px;" onclick="adicionarLancamento();"/>
					</div>
				</div>  
            
			<s:set name="valorD" value="%{0.0}" />
			<s:set name="valorC" value="%{0.0}" />
            <s:iterator value="#session.entidadeSession.movimentoContabilEJBList" var="cp" status="row" >
            		<s:hidden name="idMovimento" />
					
					<s:if test="%{debitoCredito == \"D\"}">
						<s:set name="valorD" value='%{#valorD + #cp.valor}' />
					</s:if>
					<s:else>
						<s:set name="valorC" value='%{#valorC + #cp.valor}' />
					</s:else>
					
            		<s:set name="corLancamento" value="%{'rgb(255,165,165)'}" />
            		<s:if test="%{lancarContasPagarCredito == \"S\" || (#session.entidadeSession.valorBruto.equals(valor) && #session.entidadeSession.idPlanoContasCredito == planoContaEJB.idPlanoContas)}">
            			<s:set name="corLancamento" value="%{'green'}" />
            		</s:if>
            
            		<s:if test="%{idMovimentoContabil == null}">
            		
						<div class="divLinhaCadastro" style="margin-bottom:0px; border: 0px;width:99%; float:left;  height: 20px;">
		                    <div class="divItemGrupo" style="width:150px;" ><p style="width:70px;">C. Pagar:</p>
								<s:select name="lancarContasPagarCredito" id="lancarContasPagarCredito" cssClass="lancarContasPagarCredito"
										  value="%{#cp.lancarContasPagarCredito}" 	 
										  onchange="validaDC(this)"
										  cssStyle="width:70px;" 
										  list="#session.LISTA_CONFIRMACAO"
										  listKey="id"
										  listValue="value" />
								
		                    </div>
		                    <div class="divItemGrupo" style="width:135px;" ><p style="width:40px;">D/C:</p>
								<s:select id="debitoCredito" name="debitoCredito" cssClass="debitoCredito"
										  onchange="sincronzaDebitoCredito(this)" 
										  value="%{#cp.debitoCredito}"										
										  cssStyle="width:70px;" 
										  list="debitoCreditoList"
										  listKey="id"
										  listValue="value" />
		                    </div>
		                    <div class="divItemGrupo" style="width:310px;" ><p style="width:60px;">Conta:</p>
								<s:select name="idPlanoContas" id="idPlanoContas" cssClass="idPlanoContas" onchange="sincronzaConta(this)"
										  value="%{#cp.planoContaEJB.idPlanoContas}"
										  cssStyle="width:80px;" 
										  list="planoContaList"
										  listKey="idPlanoContas"
										  listValue="contaReduzida"
										  headerKey=""
								  		  headerValue="Selecione" />
								<s:select name="idPlanoContas2" id="idPlanoContasNome" cssClass="idPlanoContasNome" onchange="sincronzaConta(this)"
										  value="%{#cp.planoContaEJB.idPlanoContas}"
										  cssStyle="width:150px;" 
										  list="planoContaList"
										  listKey="idPlanoContas"
										  listValue="nomeConta" 
										  headerKey=""
								  		  headerValue="Selecione" />
				  
		                    </div>
		
		                    <div class="divItemGrupo" style="width:150px;" ><p style="width:60px;">C. Ativo:</p>
								<s:textfield name="controleAtivo" value="%{#cp.controleAtivoFixo}" cssClass="controleAtivo" onkeypress="mascara(this, numeros)" size="10" maxlength="5" />	
		                    </div>
		
		                    <div class="divItemGrupo" style="width:130px;" ><p style="width:60px;">PIS:</p>
		                    	<s:select name="pis" cssClass="pis"
										  value="%{#cp.pis}"
										  cssStyle="width:60px;" 
										  list="#session.LISTA_CONFIRMACAO"
										  listKey="id"
										  listValue="value" />
		                    </div>
							
						</div>
				
						<div class="divLinhaCadastro" style="width:99%; float:left;  height: 20px;">
		                    <div class="divItemGrupo" style="width:285px;" ><p style="width:70px;">Histórico:</p>
								<s:select name="idHistoricoContabil" cssClass="idHistoricoContabil" 
										  value="%{#cp.historicoContabilEJB.idHistorico}"
										  cssStyle="width:190px;" 
										  list="historicoList"
										  listKey="idHistorico"
										  listValue="historico" />
		                    </div>
		                    <div class="divItemGrupo" style="width:225px;" ><p style="width:60px;">Compl.:</p>
								<s:textfield name="complementoHistorico" value="%{#cp.numDocumento}" cssClass="complementoHistorico" onblur="toUpperCase(this)" size="20" maxlength="50" />
		                    </div>
							
							<s:if test="%{#cp.lancarContasPagarCredito == \"S\"}">
								<div class="divItemGrupo" style="width:150px;" ><p style="width:60px;">Valor:</p>
									<s:textfield name="valorLancamento" value="%{#cp.valor}" onkeyup="calcularValor()" cssClass="valorLancamento" id="valorLancamento" onkeypress="mascara(this, moeda)" size="10" maxlength="10" readonly="true" cssStyle="background-color:silver;" />	
			                    </div>
							</s:if>
							<s:else>
								<div class="divItemGrupo" style="width:150px;" ><p style="width:60px;">Valor:</p>
									<s:textfield name="valorLancamento" value="%{#cp.valor}" onkeyup="calcularValor()" cssClass="valorLancamento" id="valorLancamento" onkeypress="mascara(this, moeda)" size="10" maxlength="10" />	
			                    </div>
							</s:else>						
							
		
		
		                    <div class="divItemGrupo" style="width:230px;" ><p style="width:60px;">C.Custo:</p>
								<s:select name="idCentroCusto" id="idCentroCusto" cssClass="idCentroCusto" 
										  value="%{#cp.centroCustoContabilEJB.idCentroCustoContabil}"
										  cssStyle="width:140px;" 
										  headerKey="" headerValue="Selecione"
										  list="centroCustoList"
										  listKey="idCentroCustoContabil"
										  listValue="descricaoCentroCusto" />
		                    </div>
	            		
	            			<div class="divItemGrupo" style="width:31px;" >
								<img width="30px" height="30px" title="Excluir lançamento" src="imagens/iconic/png/x-3x.png" onclick="excluirLancamento('${row.index}')"/>
							</div>
						</div>
            		</s:if>
            		<s:else>
            			
            			<s:hidden name="debitoCredito" id="debitoCredito" cssClass="debitoCredito" value="%{#cp.debitoCredito}"/>
            			<s:hidden name="idPlanoContas" id="idPlanoContas" cssClass="idPlanoContas"  value="%{#cp.planoContaEJB.idPlanoContas}"/>
            			<s:hidden name="idPlanoContas2" id="idPlanoContasNome" cssClass="idPlanoContasNome" value="%{#cp.planoContaEJB.idPlanoContas}" />
            			<s:hidden name="controleAtivo" id="controleAtivo" cssClass="controleAtivo" value="%{#cp.controleAtivoFixo}" />
            			<s:hidden name="pis" id="pis" cssClass="pis" value="%{#cp.pis}"/>
            			<s:hidden name="idHistoricoContabil" id="idHistoricoContabil" cssClass="idHistoricoContabil" value="%{#cp.historicoContabilEJB.idHistorico}"/>
            			<s:hidden name="complementoHistorico" id="complementoHistorico" cssClass="complementoHistorico" value="%{#cp.numDocumento}"/>
            			<s:hidden name="valorLancamento" id="valorLancamento" cssClass="valorLancamento" value="%{#cp.valor}"/>
            			<s:hidden name="idCentroCusto" id="idCentroCusto" cssClass="idCentroCusto" value="%{#cp.centroCustoContabilEJB.idCentroCustoContabil}"/>
            		
            			<s:set name="lancCreditoTxt" value="%{'Não'}" />
            			<s:if test="%{#session.entidadeSession.idPlanoContasCredito.longValue() == planoContaEJB.idPlanoContas.longValue() && #session.entidadeSession.valorBruto.doubleValue() == valor.doubleValue()}">
            				<s:hidden name="lancarContasPagarCredito" id="lancarContasPagarCredito" cssClass="lancarContasPagarCredito" value="S"/>
            				<s:set name="lancCreditoTxt" value="%{'Sim'}" />
            			</s:if>
            			<s:else>
            				<s:hidden name="lancarContasPagarCredito" id="lancarContasPagarCredito" cssClass="lancarContasPagarCredito" value="N"/>
            				
            			</s:else>
            		
	                    <div class="divLinhaCadastro" id="divLinha${row.index}" style="margin-bottom:0px; border:0px; width:99%;">
							<div class="divItemGrupo" style="width:150px;" ><p style="width:70px;">&nbsp;</p>
								<s:property  value="%{#lancCreditoTxt}" />		
		                    </div>
	                        <div class="divItemGrupo" style="width:135px;" ><p style="width:40px;">&nbsp;</p>${row.index + 1 } - <s:property  value="debitoCredito==\"D\"?\"Débito\":\"Crédito\"" /></div>
	                        <div class="divItemGrupo" style="width:360px;" ><p style="width:60px;">&nbsp;</p><s:property  value="planoContaEJB" /></div>
	                        <div class="divItemGrupo" style="width:100px;" ><p style="width:60px;">&nbsp;</p><s:property  value="controleAtivoFixo" /></div>
	                        <div class="divItemGrupo" style="width:130px;" ><p style="width:60px;">&nbsp;</p><s:property  value="pis==\"S\"?\"Sim\":\"Não\"" /></div>
	                    </div>
	                    <div class="divLinhaCadastro" id="divLinha2${row.index}" style="width:99%;">
	                        <div class="divItemGrupo" style="width:285px;" ><p style="width:70px;">&nbsp;</p><s:property  value="historicoContabilEJB.historico" /></div>
	                        <div class="divItemGrupo" style="width:225px;" ><p style="width:60px;">&nbsp;</p><s:property  value="numDocumento" /></div>
	                        <div class="divItemGrupo" style="width:150px;" ><p style="width:60px;">&nbsp;</p><s:property  value="valor" /></div>
	                        <div class="divItemGrupo" style="width:230px;" ><p style="width:60px;">&nbsp;</p><s:property  value="centroCustoContabilEJB.descricaoCentroCusto" /></div>
	           				<div class="divItemGrupo" style="width:31px;" ><img width="30px" height="30px" title="Não é possível excluir este lançamento" src="imagens/btnExcluirCinza.png" /></div>                        
	                    </div>
                    </s:else>
            </s:iterator>

                
                
</s:form>                
</div>
</body>

<script>
	parent.atualizarTotal('<s:property value="%{#valorD}" />', '<s:property value="%{#valorC}" />' );
	<s:if test="%{!podeGravar}">
		killModalPai();
	</s:if>
	resetLancamento();
	<s:if test="%{podeGravar}">
		parent.podeGravar();
	</s:if>
	<s:elseif test="%{mensagemPai != null && mensagemPai != \"\"}">
		parent.alerta('<s:property value="mensagemPai" />');
	</s:elseif>


</script>


</html>