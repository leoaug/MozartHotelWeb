<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

$(document).ready(function() {
	habilitarTela('divDados');
	desabilitarCamposIcms();
	desabilitarCamposIcmsST();
	desabilitarCamposCofins();
	desabilitarCamposPis();
	
	$("#btDivIcms").hide();
	$("#btDivIcmsSt").hide();
	$("#btDivCofins").hide();
	$("#btDivPis").hide();
	$("#btDivII").hide();
	
	if($('#exibeImpostos').val() == "true"){
		$("#btDivIcms").show();
		$("#btDivIcmsSt").show();
		$("#btDivCofins").show();
		$("#btDivPis").show();
		$("#btDivII").show();
	}
	
	if($('#ehAlteracao').val() == "true")
	{
		habilitarCamposIcms($('#sitTributariaIcms')[0]);	
		habilitarCampoOrigemSt($('#idOrigemMercadoriaIcms')[0]);
		habilitarCamposCofins($('#sitTributariaCofins')[0].value);
		habilitarCamposPis($('#sitTributariaPis')[0].value);
		habilitarCamposIpi($('#sitTributariaIpi')[0].value);
	}
});

function habilitarTela(value){
	$("#divDados").hide();
	$("#divIcms").hide();
	$("#divIcmsSt").hide();
	$("#divCofins").hide();
	$("#divPis").hide();
	$("#divII").hide();
	$("#divIpi").hide();
	
	$("#"+value).show();
}

function habilitarCampoOrigemSt(origem) {	
	if(origem.value != ''){
		$('#origemSt').val(origem.selectedOptions[0].innerText);
	}
	else
	{
		$('#origemSt').val("");	
	}
}
function habilitarCamposIcms(situacaoTributaria) {
	
	if(situacaoTributaria.value != ''){
		$('#sitTributarioSt').val(situacaoTributaria.selectedOptions[0].innerText);
	}
	else
	{
		$('#sitTributarioSt').val("");	
	}
	desabilitarCamposIcms();
	desabilitarCamposIcmsST();
	
	if(situacaoTributaria.value == 1){
		$('#modDeterBCICMS').attr('readonly', false);
		$('#modDeterBCICMS').attr('disabled', false);
		$('#modDeterBCICMS').css('background','white');
	}
	else if(situacaoTributaria.value == 2){
		$('#modDeterBCICMS').attr('readonly', false);
		$('#modDeterBCICMS').attr('disabled', false);
		$('#modDeterBCICMS').css('background','white');
		$('#modDeterBCIcmsSt').attr('readonly', false);
		$('#modDeterBCIcmsSt').attr('disabled', false);
		$('#modDeterBCIcmsSt').css('background','white');
		$('#percMargemValAdicionalSt').attr('readonly', false);
		$('#percMargemValAdicionalSt').css('background','white');
		$('#percReducaoBcSt').attr('readonly', false);
		$('#percReducaoBcSt').css('background','white');
	}
	else if(situacaoTributaria.value == 3){
		$('#modDeterBCICMS').attr('readonly', false);
		$('#modDeterBCICMS').attr('disabled', false);
		$('#modDeterBCICMS').css('background','white');
		$('#redBCICMS').attr('readonly', false);
		$('#redBCICMS').css('background','white');
		$('#valIcmsDeson').attr('readonly', false);
		$('#valIcmsDeson').css('background','white');
		$('#motivoDesIcms').attr('readonly', false);
		$('#motivoDesIcms').attr('disabled', false);
		$('#motivoDesIcms').css('background','white');
	}
	else if(situacaoTributaria.value == 4){
		$('#modDeterBCICMS').attr('readonly', false);
		$('#modDeterBCICMS').attr('disabled', false);
		$('#modDeterBCICMS').css('background','white');
		$('#redBCICMS').attr('readonly', false);
		$('#redBCICMS').css('background','white');
		$('#modDeterBCIcmsSt').attr('readonly', false);
		$('#modDeterBCIcmsSt').attr('disabled', false);
		$('#modDeterBCIcmsSt').css('background','white');
		$('#percMargemValAdicionalSt').attr('readonly', false);
		$('#percMargemValAdicionalSt').css('background','white');
		$('#percReducaoBcSt').attr('readonly', false);
		$('#percReducaoBcSt').css('background','white');
		$('#valIcmsDeson').attr('readonly', false);
		$('#valIcmsDeson').css('background','white');
		$('#motivoDesIcms').attr('readonly', false);
		$('#motivoDesIcms').attr('disabled', false);
		$('#motivoDesIcms').css('background','white');
	}
	else if(situacaoTributaria.value == 5 || situacaoTributaria.value == 6 || situacaoTributaria.value == 7){
		$('#valIcmsDeson').attr('readonly', false);
		$('#valIcmsDeson').css('background','white');
		$('#motivoDesIcms').attr('readonly', false);
		$('#motivoDesIcms').css('background','white');
	}
	else if(situacaoTributaria.value == 8){
		$('#modDeterBCICMS').attr('readonly', false);
		$('#modDeterBCICMS').attr('disabled', false);
		$('#modDeterBCICMS').css('background','white');
		$('#redBCICMS').attr('readonly', false);
		$('#redBCICMS').css('background','white');
		$('#motivoDesIcms').attr('readonly', false);
		$('#motivoDesIcms').attr('disabled', false);
		$('#motivoDesIcms').css('background','white');
		$('#percDiferimento').attr('readonly', false);
		$('#percDiferimento').css('background','white');
	}
	else if(situacaoTributaria.value == 9){
		$('#valBcStRet').attr('readonly', false);
		$('#valBcStRet').css('background','white');
	}
	else if(situacaoTributaria.value == 10){
		$('#modDeterBCICMS').attr('readonly', false);
		$('#modDeterBCICMS').attr('disabled', false);
		$('#modDeterBCICMS').css('background','white');
		$('#redBCICMS').attr('readonly', false);
		$('#redBCICMS').css('background','white');
		$('#modDeterBCIcmsSt').attr('readonly', false);
		$('#modDeterBCIcmsSt').attr('disabled', false);
		$('#modDeterBCIcmsSt').css('background','white');
		$('#percMargemValAdicionalSt').attr('readonly', false);
		$('#percMargemValAdicionalSt').css('background','white');
		$('#percReducaoBcSt').attr('readonly', false);
		$('#percReducaoBcSt').css('background','white');
		$('#valIcmsDeson').attr('readonly', false);
		$('#valIcmsDeson').css('background','white');
		$('#motivoDesIcms').attr('readonly', false);
		$('#motivoDesIcms').attr('disabled', false);
		$('#motivoDesIcms').css('background','white');
	}
	else if(situacaoTributaria.value == 11){
		$('#modDeterBCICMS').attr('readonly', false);
		$('#modDeterBCICMS').attr('disabled', false);
		$('#modDeterBCICMS').css('background','white');
		$('#modDeterBCIcmsSt').attr('readonly', false);
		$('#modDeterBCIcmsSt').attr('disabled', false);
		$('#modDeterBCIcmsSt').css('background','white');
		$('#valorBaseCalculoIcmsSt').attr('readonly', false);
		$('#valorBaseCalculoIcmsSt').css('background','white');
		$('#percOperacaoSt').attr('readonly', false);
		$('#percOperacaoSt').css('background','white');
		$('#ufSt').attr('readonly', false);
		$('#ufSt').css('background','white');
		$('#redBCICMS').attr('readonly', false);
		$('#redBCICMS').css('background','white');
		$('#percMargemValAdicionalSt').attr('readonly', false);
		$('#percMargemValAdicionalSt').css('background','white');
		$('#percReducaoBcSt').attr('readonly', false);
		$('#percReducaoBcSt').css('background','white');
		$('#valIcmsDeson').attr('readonly', false);
		$('#valIcmsDeson').css('background','white');
		$('#motivoDesIcms').attr('readonly', false);
		$('#motivoDesIcms').attr('disabled', false);
		$('#motivoDesIcms').css('background','white');
	}
	else if(situacaoTributaria.value == 12){
		$('#aliqCalcCredSN').attr('readonly', false);
		$('#aliqCalcCredSN').css('background','white');
	}
	else if(situacaoTributaria.value == 13 || situacaoTributaria.value == 14 || 
			situacaoTributaria.value == 15 || situacaoTributaria.value == 16){
		desabilitarCamposIcms();
		desabilitarCamposIcmsST();
	}
	else if(situacaoTributaria.value == 17){
		$('#modDeterBCIcmsSt').attr('readonly', false);
		$('#modDeterBCIcmsSt').attr('disabled', false);
		$('#modDeterBCIcmsSt').css('background','white');
		$('#aliqCalcCredSN').attr('readonly', false);
		$('#aliqCalcCredSN').css('background','white');
		$('#percMargemValAdicionalSt').attr('readonly', false);
		$('#percMargemValAdicionalSt').css('background','white');
		$('#percReducaoBcSt').attr('readonly', false);
		$('#percReducaoBcSt').css('background','white');
	}
	else if(situacaoTributaria.value == 18 || situacaoTributaria.value == 19){
		$('#modDeterBCIcmsSt').attr('readonly', false);
		$('#modDeterBCIcmsSt').attr('disabled', false);
		$('#modDeterBCIcmsSt').css('background','white');
		$('#valorBaseCalculoIcmsSt').attr('readonly', false);
		$('#valorBaseCalculoIcmsSt').css('background','white');
		$('#percMargemValAdicionalSt').attr('readonly', false);
		$('#percMargemValAdicionalSt').css('background','white');
		$('#percReducaoBcSt').attr('readonly', false);
		$('#percReducaoBcSt').css('background','white');
	}
	else if(situacaoTributaria.value == 20){
		$('#valBcStRet').attr('readonly', false);
		$('#valBcStRet').css('background','white');
		$('#valorIcmsStRet').attr('readonly', false);
		$('#valorIcmsStRet').css('background','white');
	}
	else if(situacaoTributaria.value == 21){
		$('#modDeterBCICMS').attr('readonly', false);
		$('#modDeterBCICMS').attr('disabled', false);
		$('#modDeterBCICMS').css('background','white');
		$('#modDeterBCIcmsSt').attr('readonly', false);
		$('#modDeterBCIcmsSt').attr('disabled', false);
		$('#modDeterBCIcmsSt').css('background','white');
		$('#aliqCalcCredSN').attr('readonly', false);
		$('#aliqCalcCredSN').css('background','white');
		$('#redBCICMS').attr('readonly', false);
		$('#redBCICMS').css('background','white');
		$('#percMargemValAdicionalSt').attr('readonly', false);
		$('#percMargemValAdicionalSt').css('background','white');
		$('#percReducaoBcSt').attr('readonly', false);
		$('#percReducaoBcSt').css('background','white');
	}
}

function desabilitarCamposIcmsST() {
	$('#modDeterBCIcmsSt').attr('readonly', true);
	$('#modDeterBCIcmsSt').css('background','silver');
	$('#modDeterBCIcmsSt').attr('disabled', true);
	$('#percMargemValAdicionalSt').attr('readonly', true);
	$('#percMargemValAdicionalSt').css('background','silver');
	$('#percReducaoBcSt').attr('readonly', true);
	$('#percReducaoBcSt').css('background','silver');
	$('#valorBaseCalculoIcmsSt').attr('readonly', true);
	$('#valorBaseCalculoIcmsSt').css('background','silver');
	$('#valBcStRet').attr('readonly', true);
	$('#valBcStRet').css('background','silver');
	$('#valBcStRetuf').attr('readonly', true);
	$('#valBcStRetuf').css('background','silver');
	$('#aliqCCredSt').attr('readonly', true);
	$('#aliqCCredSt').css('background','silver');
	$('#valIcmsStRetuf').attr('readonly', true);
	$('#valIcmsStRetuf').css('background','silver');
	$('#valIcmsDeson').attr('readonly', true);
	$('#valIcmsDeson').css('background','silver');
	$('#percOperacaoSt').attr('readonly', true);
	$('#percOperacaoSt').css('background','silver');
	$('#ufSt').attr('readonly', true);
	$('#ufSt').css('background','silver');
	$('#valIcmsStDest').attr('readonly', true);
	$('#valIcmsStDest').css('background','silver');
	$('#valBcStDest').attr('readonly', true);
	$('#valBcStDest').css('background','silver');
	$('#valorIcmsStRet').attr('readonly', true);
	$('#valorIcmsStRet').css('background','silver');
}

function desabilitarCamposIcms() {
	$('#modDeterBCICMS').attr('readonly', true);
	$('#modDeterBCICMS').attr('disabled', true);
	$('#modDeterBCICMS').css('background','silver');
	$('#redBCICMS').attr('readonly', true);
	$('#redBCICMS').css('background','silver');
	$('#aliqCalcCredSN').attr('readonly', true);
	$('#aliqCalcCredSN').css('background','silver');
	$('#valIcmsDeson').attr('readonly', true);
	$('#valIcmsDeson').css('background','silver');
	$('#motivoDesIcms').attr('readonly', true);
	$('#motivoDesIcms').attr('disabled', true);
	$('#motivoDesIcms').css('background','silver');
	$('#valIcmsOperacao').attr('readonly', true);
	$('#valIcmsOperacao').css('background','silver');
	$('#percDiferimento').attr('readonly', true);
	$('#percDiferimento').css('background','silver');
}

function desabilitarCamposCofins() {
	$('#valorBaseCalculoCofins').attr('readonly', true);
	$('#valorBaseCalculoCofins').css('background','silver');
	$('#pCofins').attr('readonly', true);
	$('#pCofins').css('background','silver');
	$('#valorCofins').attr('readonly', true);
	$('#valorCofins').css('background','silver');
	$('#qtdProdCofins').attr('readonly', true);
	$('#qtdProdCofins').css('background','silver');
	$('#valLiqProdCofins').attr('readonly', true);
	$('#valLiqProdCofins').css('background','silver');
	$('#valorBaseCalculoCofinsSt').attr('readonly', true);
	$('#valorBaseCalculoCofinsSt').css('background','silver');
	$('#pCofinsSt').attr('readonly', true);
	$('#pCofinsSt').css('background','silver');
	$('#valorCofinsSt').attr('readonly', true);
	$('#valorCofinsSt').css('background','silver');
	$('#qtdProdCofinsSt').attr('readonly', true);
	$('#qtdProdCofinsSt').css('background','silver');
	$('#valLiqProdCofinsSt').attr('readonly', true);
	$('#valLiqProdCofinsSt').css('background','silver');
}

function habilitarCamposCofins(situacaoTributaria) {
	
	desabilitarCamposCofins();
	if(situacaoTributaria == 1 || situacaoTributaria == 2)
	{
		//$('#valorBaseCalculoCofins').attr('readonly', false);
		//$('#valorBaseCalculoCofins').css('background','white');
		$('#pCofins').attr('readonly', false);
		$('#pCofins').css('background','white');
		$('#valorCofins').attr('readonly', false);
		$('#valorCofins').css('background','white');
		
		//$('#valorBaseCalculoCofinsSt').attr('readonly', false);
		//$('#valorBaseCalculoCofinsSt').css('background','white');
		$('#pCofinsSt').attr('readonly', false);
		$('#pCofinsSt').css('background','white');
		$('#valorCofinsSt').attr('readonly', false);
		$('#valorCofinsSt').css('background','white');
	}
	else if(situacaoTributaria == 3)
	{
		$('#qtdProdCofins').attr('readonly', false);
		$('#qtdProdCofins').css('background','white');
		$('#valLiqProdCofins').attr('readonly', false);
		$('#valLiqProdCofins').css('background','white');
		$('#valorCofins').attr('readonly', false);
		$('#valorCofins').css('background','white');
		
		$('#qtdProdCofinsSt').attr('readonly', false);
		$('#qtdProdCofinsSt').css('background','white');
		$('#valLiqProdCofinsSt').attr('readonly', false);
		$('#valLiqProdCofinsSt').css('background','white');
		$('#valorCofinsSt').attr('readonly', false);
		$('#valorCofinsSt').css('background','white');
	}
	else if(situacaoTributaria == 4 || situacaoTributaria == 5 || situacaoTributaria == 6
			|| situacaoTributaria == 7 || situacaoTributaria == 8 || situacaoTributaria == 9)
	{
		desabilitarCamposCofins();
	}
	else if(situacaoTributaria == 10 || situacaoTributaria == 11 || situacaoTributaria == 12
			|| situacaoTributaria == 13 || situacaoTributaria == 14 || situacaoTributaria == 15
			|| situacaoTributaria == 16 || situacaoTributaria == 17 || situacaoTributaria == 18
			|| situacaoTributaria == 19 || situacaoTributaria == 20 || situacaoTributaria == 21
			|| situacaoTributaria == 22 || situacaoTributaria == 23 || situacaoTributaria == 24)
	{
		//$('#valorBaseCalculoCofins').attr('readonly', false);
		//$('#valorBaseCalculoCofins').css('background','white');
		$('#pCofins').attr('readonly', false);
		$('#pCofins').css('background','white');
		$('#qtdProdCofins').attr('readonly', false);
		$('#qtdProdCofins').css('background','white');
		$('#valLiqProdCofins').attr('readonly', false);
		$('#valLiqProdCofins').css('background','white');
		$('#valorCofins').attr('readonly', false);
		$('#valorCofins').css('background','white');
		
		//$('#valorBaseCalculoCofinsSt').attr('readonly', false);
		//$('#valorBaseCalculoCofinsSt').css('background','white');
		$('#pCofinsSt').attr('readonly', false);
		$('#pCofinsSt').css('background','white');
		$('#qtdProdCofinsSt').attr('readonly', false);
		$('#qtdProdCofinsSt').css('background','white');
		$('#valLiqProdCofinsSt').attr('readonly', false);
		$('#valLiqProdCofinsSt').css('background','white');
		$('#valorCofinsSt').attr('readonly', false);
		$('#valorCofinsSt').css('background','white');
	}
}

function desabilitarCamposPis() {
	$('#valorBaseCalculoPis').attr('readonly', true);
	$('#valorBaseCalculoPis').css('background','silver');
	$('#pPis').attr('readonly', true);
	$('#pPis').css('background','silver');
	$('#valPis').attr('readonly', true);
	$('#valPis').css('background','silver');
	$('#qtdProdPis').attr('readonly', true);
	$('#qtdProdPis').css('background','silver');
	$('#valLiqProdPis').attr('readonly', true);
	$('#valLiqProdPis').css('background','silver');
	$('#valorBaseCalculoPisSt').attr('readonly', true);
	$('#valorBaseCalculoPisSt').css('background','silver');
	$('#pPisSt').attr('readonly', true);
	$('#pPisSt').css('background','silver');
	$('#valPisSt').attr('readonly', true);
	$('#valPisSt').css('background','silver');
	$('#qtdProdPisSt').attr('readonly', true);
	$('#qtdProdPisSt').css('background','silver');
	$('#valLiqProdPisSt').attr('readonly', true);
	$('#valLiqProdPisSt').css('background','silver');
}

function habilitarCamposPis(situacaoTributaria) {
	
	desabilitarCamposPis();
	if(situacaoTributaria == 1 || situacaoTributaria == 2)
	{
		$('#valorBaseCalculoPis').attr('readonly', false);
		$('#valorBaseCalculoPis').css('background','white');
		$('#pPis').attr('readonly', false);
		$('#pPis').css('background','white');
		$('#valPis').attr('readonly', false);
		$('#valPis').css('background','white');
		
		$('#valorBaseCalculoPisSt').attr('readonly', false);
		$('#valorBaseCalculoPisSt').css('background','white');
		$('#pPisSt').attr('readonly', false);
		$('#pPisSt').css('background','white');
		$('#valPisSt').attr('readonly', false);
		$('#valPisSt').css('background','white');
	}
	else if(situacaoTributaria == 3)
	{
		$('#qtdProdPis').attr('readonly', false);
		$('#qtdProdPis').css('background','white');
		$('#valLiqProdPis').attr('readonly', false);
		$('#valLiqProdPis').css('background','white');
		$('#valPis').attr('readonly', false);
		$('#valPis').css('background','white');
		
		$('#qtdProdPisSt').attr('readonly', false);
		$('#qtdProdPisSt').css('background','white');
		$('#valLiqProdPisSt').attr('readonly', false);
		$('#valLiqProdPisSt').css('background','white');
		$('#valPisSt').attr('readonly', false);
		$('#valPisSt').css('background','white');
	}
	else if(situacaoTributaria == 4 || situacaoTributaria == 5 || situacaoTributaria == 6
			|| situacaoTributaria == 7 || situacaoTributaria == 8 || situacaoTributaria == 9)
	{
		desabilitarCamposPis();
	}
	else if(situacaoTributaria == 10 || situacaoTributaria == 11 || situacaoTributaria == 12
			|| situacaoTributaria == 13 || situacaoTributaria == 14 || situacaoTributaria == 15
			|| situacaoTributaria == 16 || situacaoTributaria == 17 || situacaoTributaria == 18
			|| situacaoTributaria == 19 || situacaoTributaria == 20 || situacaoTributaria == 21
			|| situacaoTributaria == 22 || situacaoTributaria == 23 || situacaoTributaria == 24)
	{
		$('#valorBaseCalculoPis').attr('readonly', false);
		$('#valorBaseCalculoPis').css('background','white');
		$('#pPis').attr('readonly', false);
		$('#pPis').css('background','white');
		$('#qtdProdPis').attr('readonly', false);
		$('#qtdProdPis').css('background','white');
		$('#valLiqProdPis').attr('readonly', false);
		$('#valLiqProdPis').css('background','white');
		$('#valPis').attr('readonly', false);
		$('#valPis').css('background','white');
		
		$('#valorBaseCalculoPisSt').attr('readonly', false);
		$('#valorBaseCalculoPisSt').css('background','white');
		$('#pPisSt').attr('readonly', false);
		$('#pPisSt').css('background','white');
		$('#qtdProdPisSt').attr('readonly', false);
		$('#qtdProdPisSt').css('background','white');
		$('#valLiqProdPisSt').attr('readonly', false);
		$('#valLiqProdPisSt').css('background','white');
		$('#valPisSt').attr('readonly', false);
		$('#valPisSt').css('background','white');
	}
}

function desabilitarCamposIpi(){
	$('#classeEnquandramentoIpi').attr('readonly', true);
	$('#classeEnquandramentoIpi').css('background','silver');
	$('#cnpjProdutoIpi').attr('readonly', true);
	$('#cnpjProdutoIpi').css('background','silver');
	$('#codSeloIpi').attr('readonly', true);
	$('#codSeloIpi').css('background','silver');
	$('#qtdSeloIpi').attr('readonly', true);
	$('#qtdSeloIpi').css('background','silver');
	$('#codEnquandramentoIpi').attr('readonly', true);
	$('#codEnquandramentoIpi').css('background','silver');
	$('#aliIpi').attr('readonly', true);
	$('#aliIpi').css('background','silver');
	$('#qtdUnidadeIpi').attr('readonly', true);
	$('#qtdUnidadeIpi').css('background','silver');
	$('#valUnidadeIpi').attr('readonly', true);
	$('#valUnidadeIpi').css('background','silver');
	$('#valIpi').attr('readonly', true);
	$('#valIpi').css('background','silver');
}

function habilitarCamposIpi(situacaoTributaria) {
	
	desabilitarCamposIpi();
	if(situacaoTributaria == 1 || situacaoTributaria == 7 ||
	   situacaoTributaria == 8 || situacaoTributaria == 14)
	{
		$('#classeEnquandramentoIpi').attr('readonly', false);
		$('#classeEnquandramentoIpi').css('background','white');
		$('#cnpjProdutoIpi').attr('readonly', false);
		$('#cnpjProdutoIpi').css('background','white');
		$('#codSeloIpi').attr('readonly', false);
		$('#codSeloIpi').css('background','white');
		$('#qtdSeloIpi').attr('readonly', false);
		$('#qtdSeloIpi').css('background','white');
		$('#codEnquandramentoIpi').attr('readonly', false);
		$('#codEnquandramentoIpi').css('background','white');
		$('#aliIpi').attr('readonly', false);
		$('#aliIpi').css('background','white');
		$('#qtdUnidadeIpi').attr('readonly', false);
		$('#qtdUnidadeIpi').css('background','white');
		$('#valUnidadeIpi').attr('readonly', false);
		$('#valUnidadeIpi').css('background','white');
		$('#valIpi').attr('readonly', false);
		$('#valIpi').css('background','white');
	}
	else if(situacaoTributaria == 2 || situacaoTributaria == 3 ||
			situacaoTributaria == 4 || situacaoTributaria == 5 ||
			situacaoTributaria == 6 || situacaoTributaria == 9 ||
			situacaoTributaria == 10 || situacaoTributaria == 11 ||
			situacaoTributaria == 12 || situacaoTributaria == 13)
	{
		desabilitarCamposIpi();
	}
}

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarPrato!prepararPesquisa.action" namespace="/app/custo" />';
        		submitForm(vForm);
            }


			function atualizarCusto(valor){
				$("input[id='valorCusto']").val(valor);
				calcularPercentCusto();
			}

			function calcularPercentCusto(){	
				var custo = $("input[id='valorCusto']").val();
				var total = $("input[id='valorTotal']").val();
				var percentCusto = 0;
				if(total !='' &&  toFloat(total)>0 &&  custo!=''){
					percentCusto = toFloat(custo) * 100 / toFloat(total);
				}
				
				$("input[id='percentCusto']").val(arredondaFloatDecimal(percentCusto).toString().replace(".",",")  );
				

			}
			
			function gravar(){
			
				if ($("input[name='entidade.nomePrato']").val() == ''){
	                alerta('Campo "Nome Produto" é obrigatório.');
	                return false;
	            }
	
				if ($("input[name='entidade.descricaoPrato']").val() == ''){
	                alerta('Campo "Descrição" é obrigatório.');
	                return false;
	            }
				
				if ($("input[name='entidade.idGrupoPrato']").val() == ''){
					alerta('Campo "Grupo de Prato" é obrigatório.');
					return false;
				}
	
				if ( toFloat($("input[name='entidade.valorPrato']").val()) == 0.0){
					alerta('Campo "Vr Prato" deve ser MAIOR que ZERO.');
					return false;
				}
				
				if($('#exibeImpostos').val() == "true")
				{
					if(!validarInclusaoIcms())
						return false;
					if(!validarInclusaoCofins())
						return false;
					if(!validarInclusaoPis())
						return false;
				}
				
		        submitForm(document.forms[0]);
            }
			
			function gravarImpostos(){
				if(validarInclusaoIcms()){				
					document.forms[0].action = '<s:url action="manterPrato!gravarImpostos.action" namespace="/app/custo" />'
		        	submitForm(document.forms[0]);
				}				
            }
			
			function validarInclusaoIcms()
			{
				if($("#sitTributariaIcms").val() == null || $("#sitTributariaIcms").val() == "")
				{
					alert("Situação Tributária do Icms deve ser preenchida.");
					return false;
				}
				if($("#idOrigemMercadoriaIcms").val() == null || $("#idOrigemMercadoriaIcms").val() == "")
				{
					alert("Origem do Icms deve ser preenchida.");
					return false;
				}
				if($("#sitTributariaIcms").val() == 1){
					if($('#modDeterBCICMS').val() == null || $('#modDeterBCICMS').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS deve ser preenchida.");
						return false;
					}
				}
				else if($("#sitTributariaIcms").val() == 2){
					if($('#modDeterBCICMS').val() == null || $('#modDeterBCICMS').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS deve ser preenchida.");
						return false;
					}
					if($('#modDeterBCIcmsSt').val() == null || $('#modDeterBCIcmsSt').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS ST deve ser preenchida.");
						return false;
					}
				}
				else if($("#sitTributariaIcms").val() == 3){
					if($('#modDeterBCICMS').val() == null || $('#modDeterBCICMS').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS deve ser preenchida.");
						return false;
					}
					if($('#redBCICMS').val() == null || $('#redBCICMS').val() == ""){
						alert("% Redução da Base de Cálculo deve ser preenchido.");
						return false;
					}
					if($('#valIcmsDeson').val() != null && $('#valIcmsDeson').val() != ""){
						if($('#motivoDesIcms').val() == null || $('#motivoDesIcms').val() == ""){
							alert("Motivo da desoneração do ICMS deve ser preenchido.");
							return false;
						}
					}
				}
				else if($("#sitTributariaIcms").val() == 4){
					if($('#modDeterBCICMS').val() == null || $('#modDeterBCICMS').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS deve ser preenchida.");
						return false;
					}
					if($('#redBCICMS').val() == null || $('#redBCICMS').val() == ""){
						alert("% Redução da Base de Cálculo deve ser preenchido.");
						return false;
					}
					if($('#modDeterBCIcmsSt').val() == null || $('#modDeterBCIcmsSt').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS ST deve ser preenchida.");
						return false;
					}
					if($('#valIcmsDeson').val() != null && $('#valIcmsDeson').val() != ""){
						if($('#motivoDesIcms').val() == null || $('#motivoDesIcms').val() == ""){
							alert("Motivo da desoneração do ICMS deve ser preenchido.");
							return false;
						}
					}
				}
				else if($("#sitTributariaIcms").val() == 5 || $("#sitTributariaIcms").val() == 6 || $("#sitTributariaIcms").val() == 7){
					if($('#valIcmsDeson').val() != null && $('#valIcmsDeson').val() != ""){
						if($('#motivoDesIcms').val() == null || $('#motivoDesIcms').val() == ""){
							alert("Motivo da desoneração do ICMS deve ser preenchido.");
							return false;
						}
					}
				}
				else if($("#sitTributariaIcms").val() == 9){
					if($('#valBcStRet').val() != null && $('#valBcStRet').val() != ""){
						if($('#valorIcmsStRet').val() == null || $('#valorIcmsStRet').val() == ""){
							alert("Valor do ICMS ST retido deve ser preenchido.");
							return false;
						}
					}
				}
				else if($("#sitTributariaIcms").val() == 10){
					if($('#modDeterBCICMS').val() == null || $('#modDeterBCICMS').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS deve ser preenchida.");
						return false;
					}
					if($('#redBCICMS').val() == null || $('#redBCICMS').val() == ""){
						alert("% Redução da Base de Cálculo deve ser preenchido.");
						return false;
					}
					if($('#modDeterBCIcmsSt').val() == null || $('#modDeterBCIcmsSt').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS ST deve ser preenchida.");
						return false;
					}
					if($('#valIcmsDeson').val() != null && $('#valIcmsDeson').val() != ""){
						if($('#motivoDesIcms').val() == null || $('#motivoDesIcms').val() == ""){
							alert("Motivo da desoneração do ICMS deve ser preenchido.");
							return false;
						}
					}
				}
				else if($("#sitTributariaIcms").val() == 11){
					if($('#modDeterBCICMS').val() == null || $('#modDeterBCICMS').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS deve ser preenchida.");
						return false;
					}
					if($('#modDeterBCIcmsSt').val() == null || $('#modDeterBCIcmsSt').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS ST deve ser preenchida.");
						return false;
					}
					if($('#percOperacaoSt').val() == null || $('#percOperacaoSt').val() == ""){
						alert("Percentual da Bc da operação própria deve ser preenchida.");
						return false;
					}
					if($('#ufSt').val() == null || $('#ufSt').val() == ""){
						alert("UF para qual é devido o ICMS ST deve ser preenchida.");
						return false;
					}
					if($('#valIcmsDeson').val() != null && $('#valIcmsDeson').val() != ""){
						if($('#motivoDesIcms').val() == null || $('#motivoDesIcms').val() == ""){
							alert("Motivo da desoneração do ICMS deve ser preenchido.");
							return false;
						}
					}
				}
				else if($("#sitTributariaIcms").val() == 12){
					if($('#aliqCalcCredSN').val() == null || $('#aliqCalcCredSN').val() == ""){
						alert("Alíquota de cálculo do crédito (Simples Nac.) deve ser preenchida.");
						return false;
					}
				}
				else if($("#sitTributariaIcms").val() == 17){
					if($('#modDeterBCIcmsSt').val() == null || $('#modDeterBCIcmsSt').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS ST deve ser preenchida.");
						return false;
					}
					if($('#aliqCalcCredSN').val() == null || $('#aliqCalcCredSN').val() == ""){
						alert("Alíquota de cálculo do crédito (Simples Nac.) deve ser preenchida.");
						return false;
					}
				}
				else if($("#sitTributariaIcms").val() == 18 || $("#sitTributariaIcms").val() == 19){
					if($('#modDeterBCIcmsSt').val() == null || $('#modDeterBCIcmsSt').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS ST deve ser preenchida.");
						return false;
					}
				}
				else if($("#sitTributariaIcms").val() == 21){
					if($('#modDeterBCICMS').val() == null || $('#modDeterBCICMS').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS deve ser preenchida.");
						return false;
					}
					if($('#modDeterBCIcmsSt').val() == null || $('#modDeterBCIcmsSt').val() == ""){
						alert("Modalidade da determinação da base de cálculo ICMS ST deve ser preenchida.");
						return false;
					}
					if($('#aliqCalcCredSN').val() == null || $('#aliqCalcCredSN').val() == ""){
						alert("Alíquota de cálculo do crédito (Simples Nac.) deve ser preenchida.");
						return false;
					}
				}
				
				return true;
			}
			
			function validarInclusaoCofins()
			{
				if($("#sitTributariaCofins").val() == null || $("#sitTributariaCofins").val() == "")
				{
					alert("Situação Tributária do COFINS deve ser preenchida.");
					return false;
				}
				if($("#sitTributariaCofins").val() == 1 || $("#sitTributariaCofins").val() == 2){
					if($('#pCofins').val() == null || $('#pCofins').val() == ""){
						alert("Alíquota em percentual COFINS deve ser preenchida.");
						return false;
					}
					if($('#valorCofins').val() == null || $('#valorCofins').val() == ""){
						alert("Valor do COFINS deve ser preenchido.");
						return false;
					}
				}
				else if($("#sitTributariaCofins").val() == 3){
					if($('#qtdProdCofins').val() == null || $('#qtdProdCofins').val() == ""){
						alert("Quantidade Vendia COFINS deve ser preenchida.");
						return false;
					}
					if($('#valLiqProdCofins').val() == null || $('#valLiqProdCofins').val() == ""){
						alert("Alíquota do COFINS em reais deve ser preenchida.");
						return false;
					}
					if($('#valorCofins').val() == null || $('#valorCofins').val() == ""){
						alert("Valor do COFINS deve ser preenchido.");
						return false;
					}
				}
				else if($("#sitTributariaCofins").val() == 10 || $("#sitTributariaCofins").val() == 11 || $("#sitTributariaCofins").val() == 12
						|| $("#sitTributariaCofins").val() == 13 || $("#sitTributariaCofins").val() == 14 || $("#sitTributariaCofins").val() == 15
						|| $("#sitTributariaCofins").val() == 16 || $("#sitTributariaCofins").val() == 17 || $("#sitTributariaCofins").val() == 18
						|| $("#sitTributariaCofins").val() == 19 || $("#sitTributariaCofins").val() == 20 || $("#sitTributariaCofins").val() == 21
						|| $("#sitTributariaCofins").val() == 22 || $("#sitTributariaCofins").val() == 23 || $("#sitTributariaCofins").val() == 24){
					if($('#pCofins').val() == null || $('#pCofins').val() == ""){
						alert("Alíquota em percentual COFINS deve ser preenchida.");
						return false;
					}
					if($('#qtdProdCofins').val() == null || $('#qtdProdCofins').val() == ""){
						alert("Quantidade Vendia COFINS deve ser preenchida.");
						return false;
					}
					if($('#valLiqProdCofins').val() == null || $('#valLiqProdCofins').val() == ""){
						alert("Alíquota do COFINS em reais deve ser preenchida.");
						return false;
					}
					if($('#valorCofins').val() == null || $('#valorCofins').val() == ""){
						alert("Valor do COFINS deve ser preenchido.");
						return false;
					}
				}
				
				return true;
			}
			
			function validarInclusaoPis()
			{
				if($("#sitTributariaPis").val() == null || $("#sitTributariaPis").val() == "")
				{
					alert("Situação Tributária do PIS deve ser preenchida.");
					return false;
				}
				if($("#sitTributariaPis").val() == 1 || $("#sitTributariaPis").val() == 2){
					if($('#pPis').val() == null || $('#pPis').val() == ""){
						alert("Alíquota em percentual PIS deve ser preenchida.");
						return false;
					}
					if($('#valPis').val() == null || $('#valPis').val() == ""){
						alert("Valor do PIS deve ser preenchido.");
						return false;
					}
				}
				else if($("#sitTributariaPis").val() == 3){
					if($('#qtdProdPis').val() == null || $('#qtdProdPis').val() == ""){
						alert("Quantidade Vendia PIS deve ser preenchida.");
						return false;
					}
					if($('#valLiqProdPis').val() == null || $('#valLiqProdPis').val() == ""){
						alert("Alíquota do PIS em reais deve ser preenchida.");
						return false;
					}
					if($('#valPis').val() == null || $('#valPis').val() == ""){
						alert("Valor do PIS deve ser preenchido.");
						return false;
					}
				}
				else if($("#sitTributariaPis").val() == 10 || $("#sitTributariaPis").val() == 11 || $("#sitTributariaPis").val() == 12
						|| $("#sitTributariaPis").val() == 13 || $("#sitTributariaPis").val() == 14 || $("#sitTributariaPis").val() == 15
						|| $("#sitTributariaPis").val() == 16 || $("#sitTributariaPis").val() == 17 || $("#sitTributariaPis").val() == 18
						|| $("#sitTributariaPis").val() == 19 || $("#sitTributariaPis").val() == 20 || $("#sitTributariaPis").val() == 21
						|| $("#sitTributariaPis").val() == 22 || $("#sitTributariaPis").val() == 23 || $("#sitTributariaPis").val() == 24){
					if($('#pPis').val() == null || $('#pPis').val() == ""){
						alert("Alíquota em percentual PIS deve ser preenchida.");
						return false;
					}
					if($('#qtdProdPis').val() == null || $('#qtdProdPis').val() == ""){
						alert("Quantidade Vendia PIS deve ser preenchida.");
						return false;
					}
					if($('#valLiqProdPis').val() == null || $('#valLiqProdPis').val() == ""){
						alert("Alíquota do PIS em reais deve ser preenchida.");
						return false;
					}
					if($('#valPis').val() == null || $('#valPis').val() == ""){
						alert("Valor do PIS deve ser preenchido.");
						return false;
					}
				}
				
				return true;
			}

</script>


<s:form namespace="/app/custo" action="manterPrato!gravarPrato.action" theme="simple">

<s:hidden name="entidade.id.idPrato" />
<s:hidden name="entidadeIcms.idNfeIcmsCadastro" />
<s:hidden name="entidadeCofins.idNfeCofinsCadastro" />
<s:hidden name="entidadeCofinsSt.idNfeCofinsCadastroSt" />
<s:hidden name="entidadePis.idNfePisCadastro" />
<s:hidden name="entidadePisSt.idNfePisCadastroSt" />
<s:hidden name="entidadeII.idNfeIICadastro" />
<s:hidden name="entidadeIpi.idNfeIpiCadastro" />

<s:hidden id="ehAlteracao" name="ehAlteracao" />
<s:hidden id="exibeImpostos" name="exibeImpostos" />
<div class="divFiltroPaiTop">Produto</div>
<div class="divFiltroPai" >
        
       <div class="divCadastro" style="overflow:auto; height:750PX;" >
       		  <div class="divTopButtons"> 
       		  	<input class=inputTopButtons type="button" onClick="habilitarTela('divDados');" value="Dados" />
       		  	<input id="btDivIcms" class=inputTopButtons type="button" onClick="habilitarTela('divIcms');" value="ICMS" />
       		  	<input id="btDivIcmsSt" class=inputTopButtons type="button" onClick="habilitarTela('divIcmsSt');" value="ICMS ST" />
       		  	<input id="btDivCofins" class=inputTopButtons type="button" onClick="habilitarTela('divCofins');" value="COFINS" />
       		  	<input id="btDivPis" class=inputTopButtons type="button" onClick="habilitarTela('divPis');" value="PIS" /> 
       		  	<input id="btDivII" class=inputTopButtons type="button" onClick="habilitarTela('divII');" value="II" /> 
       		  	<input id="btDivIpi" class=inputTopButtons type="button" onClick="habilitarTela('divIpi');" value="IPI" />  
       		  </div>	
       
       		<div id="divDados">
	              <div class="divGrupo" style="height:170px;">
	                <div class="divGrupoTitulo">Dados</div>
	                	
						<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Nome Produto:</p>
									<s:textfield id="nomePrato" onkeypress="toUpperCase(this)" maxlength="40"  name="entidade.nomePrato" size="50" />
								</div>
						</div>
						
						<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Descrição:</p>
									<s:textfield id="descricaoPrato" onkeypress="toUpperCase(this)" maxlength="150"  name="entidade.descricaoPrato" size="50" />
								</div>
						</div>
	                
	                <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Grupo:</p>
						<s:select list="grupoPratoList" 
								  id="grupoPrato"
								  cssStyle="width:145px"  
								  name="entidade.idGrupoPrato"
								  listKey="idGrupoPrato"
								  listValue="nomeGrupoPrato"> </s:select>
							
						</div>
	                    <div class="divItemGrupo" style="width:350px;"><p style="width:100px;">Tipo:</p>
						<s:select list="tipoItemList" 
								  id="tipo"
								  cssStyle="width:235px"
								  headerKey=""
								  headerValue="Selecione"  
								  name="entidade.idTipoItem"
								  listKey="idTipoItem"
								  listValue="nomeTipo"> </s:select>
							
						</div>
						
						<div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Alcóolica:</p>
						<s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:80px"  
								  id="alcoolica"
								  name="entidade.flgAlcoolica"
								  value="%{'N'}"
								  listKey="id"
								  listValue="value"> </s:select>
							
						</div>
				    </div>
				    
				    <div class="divLinhaCadastro">
		                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Fiscal Cod:</p>
							<s:select list="fiscalCodigoList" 
									  cssStyle="width:145px" 
									  id="fiscalCod" 
									  headerKey=""
									  headerValue="Selecione"  
									  name="entidade.idFiscalCodigo"
									  listKey="idCodigoFiscal"
									  listValue="%{subCodigo + ' - ' + descricao}" > </s:select>
								
							</div>
							<div class="divItemGrupo" style="width:180px;" ><p style="width:60px;">Alíquota:</p>
							<s:select list="aliquotaList" 
									  cssStyle="width:100px"  
									  headerKey=""
									  id="aliquota"
									  headerValue="Selecione"  
									  name="entidade.idAliquota"
									  listKey="idAliquotas"
									  listValue="%{aliquota + ' - ' + descricao}"> </s:select>
								
							</div>
							<div class="divItemGrupo" style="width:230px;" ><p style="width:120px;">Unidade de Venda:</p>
							<s:select list="unidadeNfeList" 
									  cssStyle="width:100px"  
									  headerKey=""
									  id="unidadeVenda"
									  headerValue="Selecione"  
									  name="entidade.idNfeUnidade"
									  listKey="idUnidadeNfe"
									  listValue="descricao"> </s:select>
							</div>
						
						</div>
						
						<div class="divLinhaCadastro">					
		                    <div class="divItemGrupo" style="width:250px;" ><p style="width:80px;">Cód. NCM:</p>
								<s:textfield id="codNcm" maxLength="8" name="entidade.ncm"></s:textfield>
							</div>
							
							<div class="divItemGrupo" style="width:250px;" ><p style="width:80px;">CEST:</p>
								<s:textfield id="codCest" maxLength="8" name="entidade.cest"></s:textfield>
							</div>
							
							<div class="divItemGrupo" style="width:250px;" ><p style="width:80px;">CEAM:</p>
								<s:textfield id="codCean" maxLength="14" name="entidade.cean"></s:textfield>
							</div>
				    	</div>
				</div>	
					
				 <!--Inicio dados FTP-->
	           <div id="divReservaApartamento" class="divGrupo" style="width:99%; height:275px;">
	             <div class="divGrupoTitulo" style="float:left;">Ficha Técnica</div>
	              
	              <iframe width="100%" height="200" id="idLancamentoFrame" scrolling="no" frameborder="0" marginheight="0" marginwidth="0" 
	             		 src="<s:url value="app/custo/include!prepararFichaTecnica.action"/>?time=<%=new java.util.Date()%>"  ></iframe> 
	
					<div class="divLinhaCadastro" style="width:99%; float:left;  height: 20px; text-align:center;">
						<div class="divItemGrupo" style="width:620px;" ></div>
						<div class="divItemGrupo" style="width:160px;" ><p style="width:60px;">Vr Custo:</p>
							<input type="text"  maxlength="10" name=""  id="valorCusto" size="12" readonly="readonly" style="background-color:silver;text-align:right;" />
						</div>
	                </div>
					<div class="divLinhaCadastro" style="width:99%; float:left;  height: 20px; text-align:center;">
						<div class="divItemGrupo" style="width:620px;" ></div>
						<div class="divItemGrupo" style="width:160px;" ><p style="width:60px;">Vr Venda:</p>
							<s:textfield type="text" maxlength="10" name="entidade.valorPrato" id="valorTotal" size="12"  style="text-align:right;" onkeypress="mascara(this,moeda)" onblur="calcularPercentCusto()" />
						</div>
						<div class="divItemGrupo" style="width:150px;" ><p style="width:60px;">% Custo:</p>
							<input type="text"  maxlength="7"  id="percentCusto" size="6" readonly="readonly" style="background-color:silver;text-align:right;" />
						</div>
	                </div>
	
	           </div>
	           <!--Fim dados FTP-->	
           </div>	
           
			<div id="divImpostos">            
	           <div>
	              <div id="divIcms" class="divGrupo" style="height:525px;">
	                <div class="divGrupoTitulo">ICMS</div>
	               	
	               	<div class="divLinhaCadastro">	
						<div class="divItemGrupo" style="width:365px;">
							<p style="width: 120px;">Regime</p>
							<s:textfield 
								disabled="true"
								readonly="true"
								cssStyle="background-color:silver;"
								name="regimeTributario"
								id="regimeTributario" /> 
						</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div id="divSitTributaria" class="divItemGrupo" style="width:700px;" >
							<p style="width:150px;">Sit. Tributária</p>
							<s:select list="situacaoTributariaIcmsList" 
	 							cssStyle="width:500px"
	 							name="entidadeIcms.nfeIcmsCst.idNfeIcmsCst"
	 							id="sitTributariaIcms" 
	 							listKey="idSituacaoTributaria" 
	 							onchange="habilitarCamposIcms(this)"
	 							listValue="descricao" 
	 							headerKey="" 
	 							headerValue="Selecione" /> 
						</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div id="divOrigem" class="divItemGrupo" style="width:700px;" >
							<p style="width:150px;">Origem</p>
							<s:select list="origemMercadoriaIcmsList" 
									  cssStyle="width:500px"  
									  id="idOrigemMercadoriaIcms"
									  headerKey=""
									  headerValue="Selecione"  
									  onchange="habilitarCampoOrigemSt(this)"
									  name="entidadeIcms.nfeIcmsOrigemMercadoria.idNfeIcmsOrigemMercadoria"
									  listKey="idNfeIcmsOrigemMercadoria"
									  listValue="%{codigo + ' - ' + descricao}" > </s:select>
								
						</div>
					</div>
					
					<div class="divGrupo" style="height:350px;">
		                
						<div class="divLinhaCadastro">
							<div id="divOrigem" class="divItemGrupo" style="width:800px;" >
								<p style="width:300px;">Modalidade da determinação da base de cálculo ICMS</p>
								<s:select list="modalidadeBaseCalculoIcmsList" 
		 							cssStyle="background-color:silver;width:450px;"
		 							readonly="true"
		 							id="modDeterBCICMS"
		 							name="entidadeIcms.nfeIcmsModBcIcms.idNfeIcmsModBcIcms" 
		 							listKey="idNfeIcmsModBcIcms" 
		 							listValue="%{codigo + ' - ' + descricao}"
		 							headerKey="" 
		 							headerValue="Selecione" /> 
							</div>
						</div>
						
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">% Redução da Base de Cálculo</p>
							<s:textfield 
									name="entidadeIcms.percReducaoBc"
									
									readonly="true"
									id="redBCICMS"
									onkeypress="mascara(this, moeda4Decimais)" 
									size="11" 
									maxlength="11" 
									cssStyle="background-color:silver;text-align: right;" />
							</div>
						</div>
						
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Alíquota de cálculo do crédito (Simples Nac.)</p>
							<s:textfield 
									readonly="true"
									id="aliqCalcCredSN"
									name="entidadeIcms.percCreditoSimplesNacional"
									onkeypress="mascara(this, moeda4Decimais)"
									 
									size="11" 
									maxlength="11" 
									cssStyle="background-color:silver;text-align: right;" />
							</div>
						</div>
						
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Vr. Do ICMS desonerado</p>
							<s:textfield 
									name="entidadeIcms.valIcmsDeson"
									readonly="true"
									id="valIcmsDeson"
									
									onkeypress="mascara(this, moeda)" 
									size="12" 
									maxlength="12" 
									cssStyle="background-color:silver;text-align: right;" />
							</div>
						</div>
						
						<div class="divLinhaCadastro">
							<div id="divOrigem" class="divItemGrupo" style="width:700px;" >
								<p style="width:300px;">Motivo da desoneração do ICMS</p>
								<s:select list="motivoDesoneracaoIcmsList" 
									readonly="true"
		 							cssStyle="background-color:silver;width:300px"
		 							name="entidadeIcms.nfeIcmsMotivoDesoneracao.idNfeIcmsMotivoDesoneracao" 
		 							id="motivoDesIcms"
		 							listKey="idNfeIcmsMotivoDesoneracao" 
		 							listValue="%{codigo + ' - ' + descricao}"
		 							headerKey="" 
		 							headerValue="Selecione" /> 
							</div>
						</div>
						
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Vr. do ICMS da operação</p>
							<s:textfield 
									name="entidadeIcms.valIcmsOperacao"
									id="valIcmsOperacao"
									
									readonly="true"
									onkeypress="mascara(this, moeda)" 
									size="12" 
									maxlength="12" 
									cssStyle="background-color:silver;text-align: right;" />
							</div>
						</div>
						
						<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Percentual do diferimento</p>
							<s:textfield 
									name="entidadeIcms.percDiferimento"
									id="percDiferimento"
									
									readonly="true"
									onkeypress="mascara(this, moeda4Decimais)" 
									size="11" 
									maxlength="11" 
									cssStyle="background-color:silver;text-align: right;" />
							</div>
						</div>
					</div>
				  </div>	 
	           </div>
	           
	           <div>
		           <div id="divIcmsSt" class="divGrupo" style="height:600px;">
			          <div class="divGrupoTitulo">ICMS ST</div>
			          
			          <div class="divLinhaCadastro">	
						<div class="divItemGrupo" style="width:465px;">
							<p style="width: 120px;">Regime</p>
							<s:textfield 
								disabled="true"
								size="40"
								readonly="true"
								cssStyle="background-color:silver;"
								name="regimeTributarioSt"
								id="regimeTributarioSt" /> 
						</div>
					  </div>
					
					  <div class="divLinhaCadastro">
						<div id="divSitTributaria" class="divItemGrupo" style="width:700px;" >
							<p style="width:150px;">Sit. Tributária</p>
							<s:textfield 
								size="100"
								disabled="true"
								readonly="true"
								cssStyle="background-color:silver;"
								name="sitTributarioSt"
								id="sitTributarioSt" /> 
						</div>
					  </div>
					
					  <div class="divLinhaCadastro">
						<div id="divOrigem" class="divItemGrupo" style="width:700px;" >
							<p style="width:150px;">Origem</p>
							<s:textfield 
								disabled="true"
								size="100"
								readonly="true"
								cssStyle="background-color:silver;"
								name="origemSt"
								id="origemSt" /> 
								
						</div>
					  </div>
					  
					  <div class="divLinhaCadastro">
							<div id="divOrigem" class="divItemGrupo" style="width:800px;" >
								<p style="width:300px;">Modalidade da determinação da base de cálculo ICMS</p>
								<s:select list="modalidadeBaseCalculoIcmsStList" 
		 							cssStyle="background-color:silver;width:450px;"
		 							readonly="true"
		 							id="modDeterBCIcmsSt"
		 							name="entidadeIcms.nfeIcmsModBcIcmsSt.idNfeIcmsModBcIcmsSt" 
		 							listKey="idNfeIcmsModBcIcmsSt" 
		 							listValue="%{codigo + ' - ' + descricao}"
		 							headerKey="" 
		 							headerValue="Selecione" /> 
							</div>
						</div>
						
					  <div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 700px;">
						<p style="width: 300px;">% da margem do valor Adicionado ST</p>
						<s:textfield 
								name="entidadeIcms.percMargemValAdicional"
								id="percMargemValAdicionalSt"
								
								onkeypress="mascara(this, moeda4Decimais)" 
								size="11" 
								maxlength="11" 
								cssStyle="text-align: right;" />
						</div>
					  </div>
					  <div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 700px;">
						<p style="width: 300px;">% da redução da Base de Cálculo ST</p>
						<s:textfield 
								name="entidadeIcms.percReducaoBcSt"
								id="percReducaoBcSt"
								onkeypress="mascara(this, moeda4Decimais)" 
								size="11" 
								maxlength="11" 
								cssStyle="text-align: right;" />
						</div>
					  </div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Valor da BC do ICMS ST retido</p>
							<s:textfield 
								name="entidadeIcms.valBcStRet"
								id="valBcStRet"
								onkeypress="mascara(this, moeda4Decimais)" 
								size="11" 
								maxlength="11" 
								cssStyle="text-align: right;" />
						</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Valor do ICMS ST retido</p>
							<s:textfield 
									cssClass="valorIcmsStRet"
									id="valorIcmsStRet"
									name="entidadeIcms.valIcmsStRet"
									onkeypress="mascara(this, moeda)" 
									size="12" 
									maxlength="12" 
									cssStyle="text-align: right;" />
						</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Alíquota de cálculo do crédito (Simples Nac.)</p>
							<s:textfield 
								name="entidadeIcms.valBcStRet"
								id="aliqCCredSt"
								onkeypress="mascara(this, moeda4Decimais)" 
								size="11" 
								maxlength="11" 
								cssStyle="text-align: right;" />
						</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Vr. da BC do ICMS ST retido na UF remetente</p>
							<s:textfield 
									cssClass="valorIcmsSt"
									name="entidadeIcms.valBcStRetuf"
									
									id="valBcStRetuf"
									onkeypress="mascara(this, moeda)" 
									size="12" 
									maxlength="12" 
									cssStyle="text-align: right;" />
						</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Vr. do ICMS ST retido na UF remetente</p>
							<s:textfield 
									cssClass="valIcmsStRetuf"
									name="entidadeIcms.valIcmsStRetuf"
									
									id="valIcmsStRetuf"
									onkeypress="mascara(this, moeda)" 
									size="12" 
									maxlength="12" 
									cssStyle="text-align: right;" />
						</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Percentual da Bc da operação própria</p>
							<s:textfield 
								name="entidadeIcms.percOperacao"
								id="percOperacaoSt"
								onkeypress="mascara(this, moeda4Decimais)" 
								size="11" 
								maxlength="11" 
								cssStyle="text-align: right;" />
						</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">UF para qual é devido o ICMS ST</p>
							<s:textfield 
								name="entidadeIcms.ufSt"
								id="ufSt"
								size="2" 
								maxlength="2" 
								cssStyle="text-align: right;" />
						</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Valor da BC do ICMS ST da UF destino</p>
							<s:textfield 
									cssClass="valBcStDest"
									name="entidadeIcms.valBcStDest"
									
									id="valBcStDest"
									onkeypress="mascara(this, moeda)" 
									size="12" 
									maxlength="12" 
									cssStyle="text-align: right;" />
						</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 700px;">
							<p style="width: 300px;">Valor do ICMS ST da UF destino</p>
							<s:textfield 
									cssClass="valIcmsStDest"
									name="entidadeIcms.valIcmsStDest"
									id="valIcmsStDest"
									onkeypress="mascara(this, moeda)" 
									size="12" 
									maxlength="12" 
									cssStyle="text-align: right;" />
						</div>
					</div>
			       </div>
	           </div>
	           
	           <div>
	           		<div id="divCofins" class="divGrupo" style="height:500px;">
						<div class="divGrupoTitulo">COFINS</div>
			           	<div class="divLinhaCadastro">	
							<div class="divItemGrupo" style="width:365px;">
								<p style="width: 120px;">Regime</p>
								<s:textfield 
									disabled="true"
									readonly="true"
									cssStyle="background-color:silver;"
									name="regimeTributarioCofins"
									id="regimeTributarioCofins" /> 
							</div>
						</div>
						
						<div class="divLinhaCadastro">
							<div id="divSitTributaria" class="divItemGrupo" style="width:700px;" >
								<p style="width:150px;">Sit. Tributária</p>
								<s:select list="situacaoTributariaCofinsList" 
		 							cssStyle="width:500px"
		 							name="entidadeCofins.nfeCofinsCst.idNfeCofinsCst" 
		 							id="sitTributariaCofins" 
		 							onchange="habilitarCamposCofins(this.value)"
		 							listKey="idNfeCofinsCst" 
		 							listValue="%{cst + ' - ' + descricao}" 
		 							headerKey="" 
		 							headerValue="Selecione" /> 
							</div>
						</div>
					
						<div class="divGrupo" style="height:160px;">
							
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Alíquota em percentual</p>
									<s:textfield 
										name="entidadeCofins.pCofins"
										id="pCofins"
										
										onkeypress="mascara(this, moeda4Decimais)" 
										size="14" 
										maxlength="14" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Valor do COFINS</p>
									<s:textfield 
											cssClass="valorCofins"
											name="entidadeCofins.valCofins"
											
											id="valorCofins"
											readonly="true"
											onkeypress="mascara(this, moeda)" 
											size="15" 
											maxlength="15" 
											cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Quantidade Vendia</p>
									<s:textfield 
										name="entidadeCofins.qbcProd"
										id="qtdProdCofins"
										
										onkeypress="mascara(this, moeda4Decimais)" 
										size="16" 
										maxlength="16" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Alíquota do COFINS em reais</p>
									<s:textfield 
										name="entidadeCofins.valLiqProd"
										id="valLiqProdCofins"
										
										onkeypress="mascara(this, moeda4Decimais)" 
										size="15" 
										maxlength="15" 
										cssStyle="text-align: right;" />
								</div>
							</div>
						</div>
					
						<div class="divGrupo" style="height:180px;">
							<div class="divGrupoTitulo">COFINS ST</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Alíquota em percentual</p>
									<s:textfield 
										name="entidadeCofinsSt.pCofins"
										
										id="pCofinsSt"
										onkeypress="mascara(this, moeda4Decimais)" 
										size="14" 
										maxlength="14" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Valor do COFINS</p>
									<s:textfield 
											cssClass="valorCofinsSt"
											id="valorCofinsSt"
											name="entidadeCofinsSt.valCofins"
											readonly="true"
											onkeypress="mascara(this, moeda)" 
											size="15" 
											maxlength="15" 
											cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Quantidade Vendia</p>
									<s:textfield 
										name="entidadeCofinsSt.qbcProd"
										
										id="qtdProdCofinsSt"
										onkeypress="mascara(this, moeda4Decimais)" 
										size="16" 
										maxlength="16" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Alíquota do COFINS em reais</p>
									<s:textfield 
										name="entidadeCofinsSt.valLiqProd"
										id="valLiqProdCofinsSt"
										
										onkeypress="mascara(this, moeda4Decimais)" 
										size="15" 
										maxlength="15" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
						</div>
					</div>
	           </div>
	           
	           <div>
	           		<div id="divPis" class="divGrupo" style="height:500px;">
						<div class="divGrupoTitulo">PIS</div>
			           	<div class="divLinhaCadastro">	
							<div class="divItemGrupo" style="width:365px;">
								<p style="width: 120px;">Regime</p>
								<s:textfield 
									disabled="true"
									readonly="true"
									cssStyle="background-color:silver;"
									name="regimeTributarioPis"
									id="regimeTributarioPis" /> 
							</div>
						</div>
						
						<div class="divLinhaCadastro">
							<div id="divSitTributaria" class="divItemGrupo" style="width:700px;" >
								<p style="width:150px;">Sit. Tributária</p>
								<s:select list="situacaoTributariaPisList" 
		 							cssStyle="width:500px"
		 							name="entidadePis.nfePisCst.idNfePisCst" 
		 							id="sitTributariaPis" 
		 							onchange="habilitarCamposPis(this.value)"
		 							listKey="idNfePisCst" 
		 							listValue="%{cst + ' - ' + descricao}" 
		 							headerKey="" 
		 							headerValue="Selecione" /> 
							</div>
						</div>
					
						<div class="divGrupo" style="height:160px;">
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Alíquota em percentual</p>
									<s:textfield 
										name="entidadePis.pPis"
										id="pPis"
										
										onkeypress="mascara(this, moeda4Decimais)" 
										size="14" 
										maxlength="14" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Valor do PIS</p>
									<s:textfield 
											cssClass="valorPis"
											name="entidadePis.valPis"
											
											id="valPis"
											readonly="true"
											onkeypress="mascara(this, moeda)" 
											size="15" 
											maxlength="15" 
											cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Quantidade Vendia</p>
									<s:textfield 
										name="entidadePis.qbcProd"
										id="qtdProdPis"
										
										onkeypress="mascara(this, moeda4Decimais)" 
										size="16" 
										maxlength="16" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Alíquota do PIS em reais</p>
									<s:textfield 
										name="entidadePis.valLiqProd"
										id="valLiqProdPis"
										
										onkeypress="mascara(this, moeda4Decimais)" 
										size="15" 
										maxlength="15" 
										cssStyle="text-align: right;" />
								</div>
							</div>
						</div>
					
						<div class="divGrupo" style="height:180px;">
							<div class="divGrupoTitulo">PIS ST</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Alíquota em percentual</p>
									<s:textfield 
										name="entidadePisSt.pPis"
										id="pPisSt"
										
										onkeypress="mascara(this, moeda4Decimais)" 
										size="14" 
										maxlength="14" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Valor do PIS</p>
									<s:textfield 
											cssClass="valorPis"
											name="entidadePisSt.valPis"
											id="valPisSt"
											readonly="true"
											onkeypress="mascara(this, moeda)"
											 
											size="15" 
											maxlength="15" 
											cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Quantidade Vendia</p>
									<s:textfield 
										name="entidadePisSt.qbcProd"
										id="qtdProdPisSt"
										
										onkeypress="mascara(this, moeda4Decimais)" 
										size="16" 
										maxlength="16" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Alíquota do PIS em reais</p>
									<s:textfield 
										name="entidadePisSt.valLiqProd"
										
										id="valLiqProdPisSt"
										onkeypress="mascara(this, moeda4Decimais)" 
										size="15" 
										maxlength="15" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
						</div>
					</div>
	           </div>
	
	           <div>
	           		<div id="divII" class="divGrupo" style="height:300px;">
						<div class="divGrupoTitulo">II - Imposto de Importação</div>
			           	<div class="divLinhaCadastro">	
							<div class="divItemGrupo" style="width:365px;">
								<p style="width: 120px;">Regime</p>
								<s:textfield 
									disabled="true"
									readonly="true"
									cssStyle="background-color:silver;"
									name="regimeTributarioII"
									id="regimeTributarioII" /> 
							</div>
						</div>
					
						<div class="divGrupo" style="height:160px;">
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Valor das despesas aduaneiras</p>
									<s:textfield 
										name="entidadeII.valDespAdu"
										
										onkeypress="mascara(this, moeda)" 
										size="15" 
										maxlength="15" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Valor de II - Imposto de importação</p>
									<s:textfield 
										name="entidadeII.vII"
										
										onkeypress="mascara(this, moeda)" 
										size="15" 
										maxlength="15" 
										cssStyle="text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Valor do IOF - Imposto de operações financeiras</p>
									<s:textfield 
										name="entidadeII.vIof"
										
										onkeypress="mascara(this, moeda)" 
										size="15" 
										maxlength="15" 
										cssStyle="text-align: right;" />
								</div>
							</div>
						</div>
					</div>
	           </div>
	           
	           <div>
	           		<div id="divIpi" class="divGrupo" style="height:450px;">
						<div class="divGrupoTitulo">IPI</div>
			           	<div class="divLinhaCadastro">	
							<div class="divItemGrupo" style="width:365px;">
								<p style="width: 120px;">Regime</p>
								<s:textfield 
									disabled="true"
									readonly="true"
									cssStyle="background-color:silver;"
									name="regimeTributarioIpi"
									id="regimeTributarioIpi" /> 
							</div>
						</div>
						
						<div class="divLinhaCadastro">
							<div id="divSitTributaria" class="divItemGrupo" style="width:700px;" >
								<p style="width:150px;">Sit. Tributária</p>
								<s:select list="situacaoTributariaIpiList" 
		 							cssStyle="width:500px"
		 							name="entidadeIpi.nfeIpiCst.idNfeIpiCst" 
		 							id="sitTributariaIpi" 
		 							listKey="idNfeIpiCst" 
		 							onchange="habilitarCamposIpi(this.value)"
		 							listValue="%{cst + ' - ' + descricao}" 
		 							headerKey="" 
		 							headerValue="Selecione" /> 
							</div>
						</div>
					
						<div class="divGrupo" style="height:320px;">
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Classe de enquadramento para Cigarros e bebidas</p>
									<s:textfield 
										name="entidadeIpi.classeEnquandramento"
										id="classeEnquandramentoIpi"
										readonly="true"
										size="5" 
										maxlength="5" 
										cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">CNPJ do produtor diferente do emitente - Exportação</p>
									<s:textfield 
											cssClass="cnpjProdutoIpi"
											id="cnpjProdutoIpi"
											readonly="true"
											name="entidadeIpi.cnpjProduto"
											onkeypress="mascara(this, numeros)" 
											size="20" 
											maxlength="14" 
											cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Código do selo de controle</p>
									<s:textfield 
										name="entidadeIpi.codSelo" 
										id="codSeloIpi"
										readonly="true"
										size="60" 
										maxlength="60" 
										cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Quantidade de selo de controle</p>
									<s:textfield 
										name="entidadeIpi.qtdSelo"
										
										id="qtdSeloIpi"
										readonly="true"
										onkeypress="mascara(this, numeros)" 
										size="12" 
										maxlength="12" 
										cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Código do enquadramento legal</p>
									<s:textfield 
										name="entidadeIpi.codEnquandramento"
										id="codEnquandramentoIpi"
										readonly="true"
										size="5" 
										maxlength="3" 
										cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Alíquota do IPI</p>
									<s:textfield 
										name="entidadeIpi.aliIpi"
										id="aliIpi"
										
										readonly="true"
										onkeypress="mascara(this, moeda4Decimais)" 
										size="11" 
										maxlength="11" 
										cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Quantidade total na unidade padrão para tributação</p>
									<s:textfield 
										name="entidadeIpi.qtdUnidade"
										id="qtdUnidadeIpi"
										
										readonly="true"
										onkeypress="mascara(this, moeda4Decimais)" 
										size="16" 
										maxlength="16" 
										cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Valor por unidade tributável</p>
									<s:textfield 
										name="entidadeIpi.valUnidade"
										
										id="valUnidadeIpi"
										readonly="true"
										onkeypress="mascara(this, moeda4Decimais)" 
										size="15" 
										maxlength="15" 
										cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
							
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 700px;">
									<p style="width: 300px;">Valor do IPI</p>
									<s:textfield 
										name="entidadeIpi.valIpi"
										id="valIpi"
										
										readonly="true"
										onkeypress="mascara(this, moeda4Decimais)" 
										size="15" 
										maxlength="15" 
										cssStyle="background-color:silver;text-align: right;" />
								</div>
							</div>
						</div>
					</div>
	           </div>
	
			 <div class="divCadastroBotoes">
					<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
					<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
			 </div>
		</div>	   
	</div>
</div> 

</s:form>			
			 