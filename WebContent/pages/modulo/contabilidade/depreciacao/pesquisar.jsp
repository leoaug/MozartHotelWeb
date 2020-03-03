<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

	$('#linhaMovimentoContabil').css('display', 'block');

	function init(){
        
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterImobilizadoDepreciacao!prepararAlteracao.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
    }
    
    function calcular(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="encerrarImobilizadoDepreciacao!prepararEncerramento.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}
    
    function prepararRelatorio(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="relatorioImobilizadoDepreciacao!prepararRelatorio.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "depreciacao";
	with(milonic=new menuname("depreciacao")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarImobilizadoDepreciacao!pesquisar.action" namespace="/app/contabilidade" theme="simple" >
  	<s:hidden name="idMovimentoContabil" id="chave" />
  	<div class="divFiltroPaiTop">Imobilizado - Depreciação</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="IMOBILIZADO_DEPRECIACAO_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar"  imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />    
            <duques:botao label="Relatório" style="width:120px" imagem="imagens/iconic/png/print-3x.png" onClick="prepararRelatorio();" />
            <duques:botao label="Calcular" imagem="imagens/iconMozart.png" onClick="calcular();" />
    	</div>
    
    </div>
    
 <!-- grid -->
    <duques:grid colecao="listaPesquisa" titulo="Pesquisa Depreciação" 
    			 condicao="" 
    			 current="obj" 
    			 idAlteracao="chave" 
    			 idAlteracaoValue="idMovimentoContabil" 
    			 urlRetorno="pages/modulo/contabilidade/depreciacao/pesquisar.jsp">
    	
    	<duques:column labelProperty="Controle" 		 				propertyValue="controle"  			style="width:100px;"/>
    	<duques:column labelProperty="Data"	 				 			propertyValue="dataDocumento" style="width:160px;"/>
    	<duques:column labelProperty="Descrição"		 		 		propertyValue="numDocumentoDesc"		style="width:350px;" />
    	<duques:column labelProperty="Centro de Custo"		 		 	propertyValue="descricaoCentroCusto"		style="width:160px; text-align: right;" />
    	<duques:column labelProperty="Valor"		 		 			propertyValue="valor"		style="width:130px; text-align: right;"/>
    	<duques:column labelProperty="Deb./Cred."		 		 		propertyValue="debCred"		style="width:120px; text-align: right;" />
    	<duques:column labelProperty="Núm.Conta"		 		 		propertyValue="numContaContabil"		  	style="width:120px; text-align: right;" />
    	<duques:column labelProperty="Nome Conta"		 		 		propertyValue="nomeContaContabil"		style="width:220px; text-align: right;" />
    	<duques:column labelProperty="Conta Credora"		 		 	propertyValue="nomeContaCredora"		  	style="width:220px; text-align: right;" />
    	<duques:column labelProperty="Conta Depreciação"		 		propertyValue="nomeContaDepreciacao"		  		style="width:220px; text-align: right;"/>
    	<duques:column labelProperty="Setor"		 		 			propertyValue="setor"		  		style="width:120px; text-align: right;"/>
    	<duques:column labelProperty="Histórico"		 		 		propertyValue="historico"		  		style="width:220px; text-align: right;"/>
    	<duques:column labelProperty="Cód. Registro"		 		 	propertyValue="idMovimentoContabil"	style="width:140px; text-align: right;"/>

    </duques:grid>
    
</s:form>