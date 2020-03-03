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
		vForm.action = '<s:url action="manterClassificacaoContabilPadrao!prepararAlteracao.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
    function relatorio() {        
        document.forms[0].action = '<s:url action="relatorioClassificacaoContabilPadrao!prepararRelatorio.action" namespace="/app/contabilidade" />';        
        submitForm(document.forms[0]);
    }


	function consolidar(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarClassificacaoContabilPadrao!consolidar.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}

	function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterClassificacaoContabilPadrao!prepararInclusao.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}

	function prepararExclusao(){

		if (confirm('Confirma a exclusão desse registro?')){
			vForm = document.forms[0];
			vForm.action = '<s:url action="pesquisarClassificacaoContabilPadrao!excluir.action" namespace="/app/contabilidade" />';
			submitForm( vForm );
		}

	}

	function encerrar(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="encerrarClassificacaoContabilPadrao!prepararEncerramento.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}
	
	currentMenu = "mov";
	
    with(milonic=new menuname("movConsolidado")){
        margin=3;
        style=contextStyle;
        top="offset=2";
        aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
        drawMenus(); 
    }
    with(milonic=new menuname("movAConsolidar")){
        margin=3;
        style=contextStyle;
        top="offset=2";
        aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
        drawMenus(); 
    }
    with(milonic=new menuname("movExcluidos")){
        margin=3;
        style=contextStyle;
        top="offset=2";
        aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
        drawMenus(); 
    }

    </script>

 	<%
       String titulo = "Classificação Contábil Padrão";
       String requestvalue = request.getParameter("filtro.filtroTipoPesquisa");
    %>
    <script>
    currentMenu = "movConsolidado"; 
    </script>
    
  <s:form action="pesquisarClassificacaoContabilPadrao!pesquisar.action" namespace="/app/contabilidade" theme="simple" >
  	<s:hidden name="idClassificacaoContabil" id="idClassificacaoContabil"/>

    <div class="divFiltroPaiTop">Classificação Padrão</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="CLASS_CONTABIL_PADRAO_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" 	imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();"/>
            <duques:botao label="Novo" 			imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="<%=titulo%>"
    			 condicao="" current="obj" 
    			 idAlteracaoValue="idClassificacaoContabil" idAlteracao="idClassificacaoContabil" 
				 urlRetorno="pages/modulo/contabilidade/classificacaoContabil/padrao/pesquisar.jsp">
    	
    	<duques:column labelProperty="Hotel"       			propertyValue="sigla"  						style="width:70px; " />
    	<duques:column labelProperty="Cód. Classificação"	propertyValue="idClassificacaoContabil" 	style="width:150px; text-align: right;"/>		 
        <duques:column labelProperty="Descricao"       		propertyValue="descricao"	    			style="width:280px;"/>
        <duques:column labelProperty="D/C"      			propertyValue="debitoCredito"    			style="width:60px;" />
        <duques:column labelProperty="Percentual"         	propertyValue="percentual"      			style="width:100px; text-align: right;" />
        <duques:column labelProperty="C. Red." 				propertyValue="contaReduzida"       		style="width:80px; text-align: right;" />
        <duques:column labelProperty="Nome da conta" 		propertyValue="nomeConta"       			style="width:280px;" />
        <duques:column labelProperty="Centro custo"    		propertyValue="descricaoCentroCusto"	    style="width:200px;"/>
        <duques:column labelProperty="Conta financeira "    propertyValue="contaFinanceira"	    		style="width:250px;"/>
        <duques:column labelProperty="Pis"     				propertyValue="pis"							style="width:60px;"/>
        
    </duques:grid>
    
</s:form>