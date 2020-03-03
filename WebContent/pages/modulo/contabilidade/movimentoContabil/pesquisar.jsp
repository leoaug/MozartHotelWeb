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
		vForm.action = '<s:url action="manterMovimentoContabil!prepararAlteracao.action" namespace="/app/contabilidade" />';
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
		vForm.action = '<s:url action="manterMovimentoContabil!prepararInclusao.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}

	function prepararExclusao(){

		if (confirm('Confirma a exclusão desse registro?')){
			vForm = document.forms[0];
			vForm.action = '<s:url action="pesquisarMovimentoContabil!excluir.action" namespace="/app/contabilidade" />';
			submitForm( vForm );
		}

	}


	function encerrar(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="encerrarMovimentoContabil!prepararEncerramento.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}
	
	
	currentMenu = "mov";
	
    with(milonic=new menuname("movConsolidado")){
        margin=3;
        style=contextStyle;
        top="offset=2";
        aI("image=imagens/iconic/png/x-3x.png;text=Excluir;url=javascript:prepararExclusao();");
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
       String titulo = "Relatório de Movimento Contábil";
       String requestvalue = request.getParameter("filtro.filtroTipoPesquisa");
       
       if ("M".equals( requestvalue)){
           titulo = "Relatório dos Movimentos Consolidados";
    %>
    <script>
    currentMenu = "movConsolidado"; 
    </script>
    <%
       }else if ("A".equals( requestvalue )){
    	   titulo = "Relatório dos Movimentos a consolidar";
    %>
	<script>
    currentMenu = "movAConsolidar"; 
    </script>
    <%
       }else if ("E".equals( requestvalue )){
    	   titulo = "Relatório dos Movimentos Excluídos";
    %>
	<script>
    currentMenu = "movExcluidos"; 
    </script>
    <%
       }
    %>
  <s:form action="pesquisarMovimentoContabil!pesquisar.action" namespace="/app/contabilidade" theme="simple" >
  	<s:hidden name="entidadeMov.idMovimentoContabil" id="idAlteracao"/>
  	<s:hidden name="saldoMovimento.totalCredito"/>
  	<s:hidden name="saldoMovimento.totalDebito"/>
  	<s:hidden name="saldoMovimento.diferenca"/>

    <div class="divFiltroPaiTop">Movimento Contábil</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="MOVIMENTO_CONTABIL_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros" style="width:400px;" >
        
        	<ul style="width: 210px; height:100%; float: left; padding: 0px; margin: 0px; list-style: none; font-size: 8pt; border-right: 1px solid black;">
				<li style="width: 100px; font-size: 8pt;float:left;"><input type="radio"
					<%=(request.getParameter("filtro.filtroTipoPesquisa")==null || "M".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":"")%>
					name="filtro.filtroTipoPesquisa" value="M" />Consolidado</li>
				
				<li style="width: 100px;font-size: 8pt;float:left;"><input type="radio"
					<%="A".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
					name="filtro.filtroTipoPesquisa" value="A" />A consolidar</li>
				
				<li style="width: 100px;font-size: 8pt;float:left;"><input type="radio"
					<%="E".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
					name="filtro.filtroTipoPesquisa" value="E" />Excluídas</li>
					
			</ul>
			
			
			<ul style="width: 180px; height:100%; float: left; padding: 0px; margin: 0px; list-style: none; font-size: 8pt; border-right: 1px solid black;">
				<li style="width: 100%; font-size: 8pt;float:left;">
					<div style="float:left; width:70px;">Crédito:</div> 
					<div id="totalCredito" style="text-align:right;width:100px;float:left;color:<s:property value="saldoMovimento.diferenca.doubleValue()!=0.0?\"red\":\"green\""/>"><s:property value="saldoMovimento.totalCredito"/> </div>
				</li>
				
				<li style="width: 100%;font-size: 8pt;float:left;">
					<div style="float:left; width:70px;">Débito:</div> <div id="totalDebito" style="text-align:right;width:100px;float:left;color:<s:property value="saldoMovimento.diferenca.doubleValue()!=0.0?\"red\":\"green\""/>"><s:property value="saldoMovimento.totalDebito"/> </div>
				</li>
				
				<li style="width: 100%;font-size: 8pt;float:left;">
					<div style="float:left; width:70px;">Diferença:</div> <div id="totalDiferenca" style="text-align:right;width:100px;float:left;color:<s:property value="saldoMovimento.diferenca.doubleValue()!=0.0?\"red\":\"green\""/>"><s:property value="saldoMovimento.diferenca"/> </div>
				
				</li>
					
			</ul>
			
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" 	imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();"/>
            <duques:botao label="Novo" 			imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
            <duques:botao label="Relatório" 	imagem="imagens/iconic/png/print-3x.png" onClick="relatorio();" />
            <duques:botao label="Encerrar" 		imagem="imagens/iconMozart.png" onClick="encerrar();" />
            <s:if test="%{#session.listaPesquisa.size() > 0 && #request.filtro.filtroTipoPesquisa == \"A\"}">
            	<duques:botao label="Consolidar" style="width:110px;" imagem="imagens/iconic/png/check-4x.png" onClick="consolidar();" />
            </s:if>
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="<%=titulo%>"
    			 condicao="" current="obj" 
    			 idAlteracaoValue="idMovimentoContabil" idAlteracao="idAlteracao"
				 urlRetorno="pages/modulo/contabilidade/movimentoContabil/pesquisar.jsp">
    	
        <duques:column labelProperty="Seq. Contábil"       	propertyValue="idSeqContabil" 		style="width:140px;" grouped="true"/>
        <duques:column labelProperty="Dt doc"      			propertyValue="dataDocumento"		style="width:100px;text-align:center;" format="dd/MM/yyyy" />
        <duques:column labelProperty="C. Red." 				propertyValue="contaReduzida"       style="width:110px;text-align:center;" />
        <duques:column labelProperty="Nome da conta" 		propertyValue="nomeConta"       	style="width:280px;" />
        <duques:column labelProperty="Valor"      			propertyValue="valor"    			style="width:100px;text-align:right;" math="sum" />
        <duques:column labelProperty="D/C"      			propertyValue="debitoCredito"    	style="width:100px;"  grouped="true"/>
        <duques:column labelProperty="Histórico"       		propertyValue="historico"	    	style="width:250px;"/>
        <duques:column labelProperty="Hist. Compl."         propertyValue="numDocumento"      	style="width:180px;" />
        <duques:column labelProperty="Centro custo"    		propertyValue="centroCusto"	    	style="width:250px;"/>
        <duques:column labelProperty="At.Fixo"     			propertyValue="controleAtivoFixo"	style="width:120px;text-align:right;"/>
        <duques:column labelProperty="Hotel"       			propertyValue="sigla"  				style="width:100px;" grouped="true"/>
    	<duques:column labelProperty="Cód. Mov"       		propertyValue="idMovimentoContabil" style="width:100px;"/>
        
    </duques:grid>
    
</s:form>