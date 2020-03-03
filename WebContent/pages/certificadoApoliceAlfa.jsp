<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<jsp:scriptlet>
        String  base = request.getRequestURL().toString().substring(0, request.getRequestURL().toString().indexOf(request.getContextPath())+request.getContextPath().length()+1);
        session.setAttribute("URL_BASE", base);
        session.setAttribute("BROWSER_TYPE", "ie");
        
        response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
	response.setHeader("Cache-Control","no-store, no-cache, must-revalidate");
	response.addHeader("Cache-Control", "post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
</jsp:scriptlet>


<!--certificado.jsp-->
<html>
<head>
<style>
<!--
.fontTitulo {
	font-family: Arial Narrow;
	font-size: 12pt;
	font-weight: bold;
}
-->
</style>

<base href="<%=base%>" />
<title>Geração de apólice</title>
<meta http-equiv="Cache-Control" content="no-cache">
<jsp:include page="/pages/modulo/includes/headPage.jsp">
	<jsp:param name="data" value="<%=new java.util.Date().getTime()%>" />
</jsp:include>
<script language="javascript" type="text/javascript">loading();

function imprimir(){
	$('#btnPrint').css('display','none');
	window.print();
	$('#btnPrint').css('display','block');
}


</script>

</head>

<body>
<img id="btnPrint" style="position:absolute; left:780px;" title="Imprimir" src="imagens/iconic/png/print-3x.png" onclick="imprimir();">
<s:if test="apolice != null">
	<table border="0" cellpadding="0" cellspacing="0" width="768px">
		<tr>
			<td>

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="25%"><img src="imagens/hoteis/alfaseg.png"
						title="Alfa Seguradora" /></td>
					<td align="center">
					<div class="fontTitulo">CERTIFICADO DE SEGURO</div>
					</td>
					<td width="25%" align="right"><img height="80" width="220"
						src="imagens/hoteis/fnhrbs.png" /></td>
				</tr>
			</table>

			<br />
			<div class="fontTitulo"><img src="imagens/triangulo.bmp" />&nbsp;&nbsp;DADOS
			DA APÓLICE</div>
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td width="33%">
					<div class="fontTitulo" style="float: left;">Apólice nº:</div>
					<div>&nbsp;<s:property value="apolice.numApolice" /></div>
					</td>
					<td width="33%">
					<div class="fontTitulo" style="float: left;">Contrato:</div>
					&nbsp;<s:property value="apolice.numContrato" /></td>
					<td width="33%">
					<div class="fontTitulo" style="float: left;">Certificado:</div>
					&nbsp;<s:property value="apolice.currentSessionID" /></td>
				</tr>
			</table>


			<br />
			<div class="fontTitulo"><img src="imagens/triangulo.bmp" />&nbsp;&nbsp;DADOS
			DO ESTIPULANTE</div>
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					<div class="fontTitulo" style="float: left;">Nome:</div>
					<div>&nbsp;Federação Nacional de Hotéis, Restaurantes, Bares
					e Similares - FNHRBS</div>
					</td>
					<td width="28%">
					<div class="fontTitulo" style="float: left;">CNPJ:</div>
					&nbsp;33.792.235/0001-12</td>
				</tr>
			</table>

			<br />
			<div class="fontTitulo"><img src="imagens/triangulo.bmp" />&nbsp;&nbsp;DADOS
			DO SUB-ESTIPULANTE(Hotel)</div>
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td align="left">
					<div class="fontTitulo" style="float: left;">Nome:</div>
					<div>&nbsp;<s:property value="apolice.nomeHotel" /></div>
					</td>
					<td width="28%" align="left">
					<div class="fontTitulo" style="float: left;">CNPJ:</div>
					&nbsp;<s:property value="apolice.cnpjHotel" /></td>
				</tr>
			</table>

			<br />
			<div class="fontTitulo"><img src="imagens/triangulo.bmp" />&nbsp;&nbsp;DADOS
			DO CORRETOR</div>
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td align="left">
					<div class="fontTitulo" style="float: left;">Nome:</div>
					<div>&nbsp;Itália do Brasil Corretora de Seguros Ltda.</div>
					</td>
					<td width="28%" align="left">
					<div class="fontTitulo" style="float: left;">Nº Susep:</div>
					&nbsp;5081910607053-4</td>
				</tr>
			</table>

			<br />
			<div class="fontTitulo"><img src="imagens/triangulo.bmp" />&nbsp;&nbsp;DADOS
			DO SEGURADO</div>
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="3" align="left">
					<div class="fontTitulo" style="float: left;">Nome:</div>
					<div>&nbsp;<s:property value="apolice.nomeHospede" /></div>
					</td>
				</tr>
				<tr>
					<td width="33%">
					<div class="fontTitulo" style="float: left;">Data de
					Nascimento:</div>
					<div>&nbsp;<s:property value="apolice.dataNascimento" /></div>
					</td>
					<td width="33%">
					<div class="fontTitulo" style="float: left;">CPF:</div>
					<div>&nbsp;<s:property value="apolice.cpf" /></div>
					</td>
					<td width="33%">
					<div class="fontTitulo" style="float: left;">Sexo:</div>
					<div>&nbsp;<s:property value="apolice.sexo" /></div>
					</td>
				</tr>
			</table>

			<br />
			<div class="fontTitulo"><img src="imagens/triangulo.bmp" />&nbsp;&nbsp;DADOS
			DO SEGURO</div>
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td width="33%">
					<div class="fontTitulo" style="float: left;">Ramo:</div>
					<div>&nbsp;Acidentes Pessoais</div>
					</td>
					<td width="33%">
					<div class="fontTitulo" style="float: left;">Produto:</div>
					<div>&nbsp;Alfa Seguro Hospedagem</div>
					</td>
					<td width="33%">
					<div class="fontTitulo" style="float: left;">Sucursal:</div>
					<div>&nbsp;São Paulo</div>
					</td>
				</tr>

				<tr>
					<td colspan="3">
					<div class="fontTitulo" style="float: left; width: 100%">Período
					de Vigência:</div>
					<div style="width: 40%; float: left;">&nbsp;<a
						style="color: red;">Início da vigência:</a> <s:property
						value="apolice.dataEntrada" /></div>
					<div style="width: 55%; float: left;">&nbsp;<a
						style="color: red;">Final da vigência:</a> data e horário de saída
					do Hotel (check out) *</div>
					</td>
				</tr>
			</table>
			* O Check out será sempre comprovado através de documento/registro de
			saída do Hotel. <br />
			<div class="fontTitulo"><img src="imagens/triangulo.bmp" />&nbsp;&nbsp;BENEFICIÁRIOS</div>
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					<div style="float: left;">De acordo com a Legislação em
					vigor.</div>
					</td>
				</tr>
			</table>

			<br />
			<div class="fontTitulo"><img src="imagens/triangulo.bmp" />&nbsp;&nbsp;DEMONSTRATIVO
			DE IMPORTÂNCIA SEGURADA</div>
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td width="50%" align="center">
					<div class="fontTitulo">Coberturas</div>
					</td>
					<td width="50%" align="center">
					<div class="fontTitulo">Capital Segurado</div>
					</td>
				</tr>
				<tr>
					<td align="left">Morte Acidental</td>
					<td align="center">R$ 50.000,00</td>
				</tr>
				<tr>
					<td align="left">Invalidez Permanente Parcial ou Total por
					Acidente</td>
					<td align="center">R$ 50.000,00</td>
				</tr>
				<tr>
					<td align="left">Despesas Médico-Hospitalares (DMH)</td>
					<td align="center">R$ 5.000,00</td>
				</tr>
				<tr>
					<td align="left">Morte - Assistência Funeral Individual</td>
					<td align="center">R$ 3.000,00</td>
				</tr>
			</table>
			<br />
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td width="25%" align="center">
					<div class="fontTitulo" style="float: left">Periodicidade:</div>
					Diário</td>
					<td width="25%" align="center">
					<div class="fontTitulo" style="float: left">Pró-Labore:</div>
					</td>
					<td width="25%" align="center">
					<div class="fontTitulo" style="float: left">Excedente
					Técnico:</div>
					0%</td>
					<td width="25%" align="center">
					<div class="fontTitulo" style="float: left">Prêmio Total:</div>
					A calcular</td>
				</tr>
			</table>

			<br />
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>O presente Certificado garante as coberturas aqui
					descritas, durante o período de estadia no hotel (sub-estipulante).
					Para sua garantia e plena validade do presente Certificado,
					conserve-o até o final de sua estadia.</td>
				</tr>
			</table>

			<br />
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>A Garantia de Morte Acidental, nos seguros de menores de
					14 (quatorze) anos está limitada ao reembolso das despesas com
					funeral.</td>
				</tr>
			</table>

			<br />
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					<div class="fontTitulo" style="float: left">Este seguro é por
					prazo determinado tendo a Seguradora a faculdade de não renovar a
					apólice na data de vencimento, sem devolução dos prêmios pagos nos
					termos da apólice.</div>
					</td>
				</tr>
			</table>

			<br />
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>As Condições Gerais estão disponíveis no site <a
						href="http://www.alfaseguradora.com.br" target="_blank">www.alfaseguradora.com.br</a>
					e no hotel (sub-estipulante) no ato da adesão ao seguro.</td>
				</tr>
			</table>

			<br />
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>Para prestação do serviço de Assistência Funeral entre em
					contato através do número: 0800 707 7882.</td>
				</tr>

				<tr>
					<td>Para outras consultas e atendimento a sinistros ligue para
					Itália do Brasil Corr. de Seguros 0800-282 4545.</td>
				</tr>

				<tr>
					<td>O registro deste plano na SUSEP não implica, por parte da
					Autarquia, incentivo ou recomendação a sua comercialização.</td>
				</tr>

				<tr>
					<td>O segurado poderá consultar a situação cadastral de seu
					corretor de seguros, no site www.susep.gov.br, por meio do número
					de seu registro na SUSEP, nome completo, CNPJ ou CPF.</td>
				</tr>


			</table>

			<br />
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center" style="color: silver">Alfa Previdência e
					Vida S.A. - CNPJ: 02.713.530/0001-02 - Nº Processo Susep AP
					15414.003001/2006-15</td>
				</tr>
				<tr>
					<td align="center" style="color: silver">Alameda Santos, nº
					466 - 9º andar - Cerqueira César - CEP: 01418-000 - São Paulo/SP</td>
				</tr>
			</table>


			</td>
		</tr>
	</table>
</s:if>

</body>
<duques:showMessage imagem="" />
</html>