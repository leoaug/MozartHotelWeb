
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
	    document.forms[0].action = '/app/financeiro/includeTesouraria!excluirLancamento.action';
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
	vForm.action = '/app/financeiro/includeTesouraria!obterClassificacaoPadrao.action';
    vForm.submit();
}

function killModalPai(){
	parent.killModal();
}

function setPlanoContaFinanceiro(idPlanoContaFinanceiro){
	$('#idPlanoContasFinanceiro').val( idPlanoContaFinanceiro );
}

function gravar(){ // tesouraria
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
	$('.idCentroCustoTes').get(0).value= "";
	$('.idHistorico').get(0).value= "";
	$('.idPlanoContasNome').get(0).value= "";
	$('.controleAtivoTes').get(0).value= "";
	preencherComboBoxJS("contaCorrente0", " , |");
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
