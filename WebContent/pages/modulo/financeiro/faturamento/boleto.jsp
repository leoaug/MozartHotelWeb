<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">

</script>



<s:form action="pesquisarFaturamento!prepararPesquisa.action"
	namespace="/app/financeiro" theme="simple">
	<div class="divFiltroPaiTop">Faturamento</div>
	<s:a href="?MT=gerarBoletoFaturamento&contaCorrente=53440&data=03/05/2013&ids=31080661">Boleto</s:a>
	<s:a href="?MT=gerarArquivoRemessa&contaCorrente=53440&data=03/05/2013&ids=31080661">Remessa</s:a>
</s:form>