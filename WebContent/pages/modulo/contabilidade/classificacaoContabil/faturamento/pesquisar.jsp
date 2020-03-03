<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
	$('#linhaMovimentoContabil').css('display','block');

    function init(){
        
    }

    function onEnter(){
        
    }

	
	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterClassificacaoContabilFaturamento!prepararAlteracao.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
    function relatorio() {        
        document.forms[0].action = '<s:url action="relatorioMovimentoContabil!prepararRelatorio.action" namespace="/app/contabilidade" />';        
        submitForm(document.forms[0]);
    }


	function consolidar(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarMovimentoContabil!consolidar.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}

	function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterClassificacaoContabilFaturamento!prepararInclusao.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}
		
    with(milonic=new menuname("faturamento")){
        margin=3;
        style=contextStyle;
        top="offset=2";
       // aI("image=imagens/iconic/png/x-3x.png;text=Excluir;url=javascript:prepararExclusao();");
        aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
        drawMenus(); 
    }
   
    
    </script>

 	<%
       String titulo = "Configuração Classificação Contábil Faturamento";
       String requestvalue = request.getParameter("filtro.filtroTipoPesquisa");
       
    %>
    <script>
    currentMenu = "faturamento"; 
    </script>
  <s:form action="manterClassificacaoContabilFaturamento!pesquisar.action" namespace="/app/contabilidade" theme="simple" >

    <div class="divFiltroPaiTop">Faturamento</div>   
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="CLASSIFICACAO_FATURAMENTO_WEB" titulo="" />
        </div>
    </div> 
    <div id="divMeio" class="divMeio">
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" 	imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();"/>
            <s:if test="%{#session.listaPesquisa.size() == 0}">
            	<duques:botao label="Novo" 			imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
            </s:if>
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="<%=titulo%>"
    			 condicao="" current="obj" 
    			 idAlteracaoValue="idClassificacaoContabil" idAlteracao="idAlteracao"
				 urlRetorno="pages/modulo/contabilidade/classificacaoContabil/faturamento/pesquisar.jsp">

    	<duques:column labelProperty="Classificação Contabil"  	propertyValue="idClassificacaoContabil" />		 
    	<duques:column labelProperty="Descricao"       			propertyValue="descricao"  				/>		 
       	<duques:column labelProperty="Conta Débito"      		propertyValue="nmContaDebito"			style="width:200px;" />
        <duques:column labelProperty="Centro de Custo Débito" 	propertyValue="nmCentroCustoDebito"     />
        <duques:column labelProperty="Conta Crédito"      		propertyValue="nmContaCredito"			style="width:200px;"/>
        <duques:column labelProperty="Centro de Custo Crédito" 	propertyValue="nmCentroCustoCredito"    />
        <duques:column labelProperty="PIS"		 				propertyValue="pis"       				style="width:80px;"/>
        
    </duques:grid>
    
</s:form>