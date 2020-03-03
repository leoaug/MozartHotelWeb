<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
	$('#linhaContasPagar').css('display','block');
	
    function init(){
        
    }


	function pagar(){

			vForm = document.forms[0];
			vForm.action = '<s:url action="pagarContasPagar!prepararPagamento.action" namespace="/app/financeiro" />';
			submitForm( vForm );
			
	}


	function prepararRecebimento(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="receberContasReceber!prepararRecebimentoDuplicata.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}
	
	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterContasPagar!prepararAlteracao.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
    function relatorio() {        
        document.forms[0].action = '<s:url action="relatorioContasPagar!prepararRelatorio.action" namespace="/app/financeiro" />';        
        submitForm(document.forms[0]);
    }

    function baixarDocumento() {          
        document.forms[0].action = '<s:url action="documentoContasPagar!downloadDocumento.action" namespace="/app/financeiro"/>';        
        submitForm(document.forms[0]);
        killLoading();
    }

	function prepararEncerramento(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="encerrarContasPagar!prepararEncerramento.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

	function estornarDuplicata(){

		if (confirm('Confirma o estorno da duplicata selecionada?')){
			vForm = document.forms[0];
			vForm.action = '<s:url action="estornarContasPagar!estornarDuplicata.action" namespace="/app/financeiro" />';
			submitForm( vForm );
		}

	}

	function descontar(){
		vForm = document.forms[0];
		vForm.origemRecebimento.value = 'DESCONTAR';
		vForm.action = '<s:url action="receberContasReceber!prepararRecebimento.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

	
	function descontarDuplicata(){
		vForm = document.forms[0];
		vForm.origemRecebimento.value = 'DESCONTAR';
		vForm.action = '<s:url action="receberContasReceber!prepararRecebimentoDuplicata.action" namespace="/app/financeiro" />';
		submitForm( vForm );

	}

	function parcelar(){

		vForm = document.forms[0];
		vForm.action = '<s:url action="parcelarContasPagar!prepararParcelamento.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}


	function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterContasPagar!prepararInclusao.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

	with(milonic=new menuname("dupAberta")){
        margin=3;
        style=contextStyle;
        top="offset=2";
        aI("image=imagens/btnAlterar.png;text=Parcelar;url=javascript:parcelar();");
        aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
        drawMenus(); 
    }

    with(milonic=new menuname("dupPago")){
        margin=3;
        style=contextStyle;
        top="offset=2"; 
        aI("image=imagens/btnAlterar.png;text=Estornar;url=javascript:estornarDuplicata();");
        drawMenus(); 
    }


    </script>

    <%
       String titulo = "Relatório de duplicatas abertas";
       String requestvalue = request.getParameter("filtro.filtroTipoPesquisa");
       
       if ("1".equals( requestvalue)){
           titulo = "Relatório de duplicatas abertas";
    %>
    <script>
    currentMenu = "dupAberta"; 
    </script>

    <%
       }else if ("2".equals( requestvalue )){
    	   titulo = "Relatório de duplicatas pagas";
    %>
	<script>
    currentMenu = "dupPago"; 
    </script>


    <%
       }
    %>

  <s:form action="pesquisarContasPagar!pesquisar.action" namespace="/app/financeiro" theme="simple" >
  	<s:hidden name="entidadeCP.idContasPagar" id="idAlteracao"/>
  	<s:hidden name="origemParcelamento" value="CP"/>
  	<s:hidden name="origemRecebimento" id="origemRecebimento" value="CP" />
  	
    <div class="divFiltroPaiTop">Contas a pagar</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="CONTAS_PAGAR_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros" >
        
			<ul style="width: 210px; height:100%; float: left; padding: 0px; margin: 0px; list-style: none; font-size: 8pt; border-right: 1px solid black;">
				<li style="width: 100px; font-size: 8pt;float:left;"><input type="radio"
					<%=(request.getParameter("filtro.filtroTipoPesquisa")==null || "1".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":"")%>
					name="filtro.filtroTipoPesquisa" value="1" />Abertas</li>
				
				<li style="width: 100px;font-size: 8pt;float:left;"><input type="radio"
					<%="3".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
					name="filtro.filtroTipoPesquisa" value="3" />Todas</li>
				
				<li style="width: 100px;font-size: 8pt;float:left;"><input type="radio"
					<%="2".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
					name="filtro.filtroTipoPesquisa" value="2" />Pagas</li>
					
			</ul>
			            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" 	imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();"/>
            <duques:botao label="Novo" 			imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
            <duques:botao label="Relatório" 	imagem="imagens/iconic/png/print-3x.png" onClick="relatorio();" />
            <s:if test="%{#request.filtro.filtroTipoPesquisa == \"1\" && #session.listaPesquisa.size() > 0}">
            	<duques:botao label="Pagar" 	imagem="imagens/iconic/png/print-3x.png" onClick="pagar();" />
            </s:if>
            <duques:botao label="Encerrar" 		imagem="imagens/iconMozart.png" onClick="prepararEncerramento();" />
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="<%=titulo%>" 
    			 condicao="" current="obj" 
    			 idAlteracaoValue="idContasPagar" idAlteracao="idAlteracao"
				 urlRetorno="pages/modulo/financeiro/contasPagar/pesquisar.jsp">
    	
    	<duques:column labelProperty="Hotel"       			propertyValue="sigla"  				style="width:100px;" />
    	<duques:column labelProperty="Cód Conta"    		propertyValue="idContasPagar"      	style="width:100px;" />		 
    	<duques:column labelProperty="Conta Corrente"    	propertyValue="contaCorrente"     	style="width:140px;" grouped="true"/>
    	<duques:column labelProperty="Fornecedor"       	propertyValue="empresa"  			style="width:310px;" grouped="true"/>		 		 
        <duques:column labelProperty="Num doc"    			propertyValue="documento"      		style="width:150px;" />
        <duques:column labelProperty="Dt lçto"      		propertyValue="dataLancamento"      style="width:100px;text-align:center;" />
        <duques:column labelProperty="Dt vcto"      		propertyValue="dataVencimento"      style="width:100px;text-align:center;" />
        <duques:column labelProperty="Prorrogado"      		propertyValue="dataProrrogado"    	style="width:100px;text-align:center;" />
        <duques:column labelProperty="Dt pgto."      		propertyValue="dataPagamento"    	style="width:100px;text-align:center;" />
        <duques:column labelProperty="Vl Bruto"         	propertyValue="valorBruto"      	style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Juros"       			propertyValue="juros"	            style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Desconto"       		propertyValue="desconto"            style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Vl Líquido"      		propertyValue="valorLiquido"        style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Vl Pago"      		propertyValue="valorPago"          	style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Num Cheque"    		propertyValue="numCheque"     		style="width:120px;"/>
        <duques:column labelProperty="Tipo Doc"         	propertyValue="tipoDocumento"      	style="width:100px;text-align:center;"/>
        <duques:column labelProperty="Série"    			propertyValue="serieDocumento"     	style="width:100px;text-align:center;"/>        
        <duques:column labelProperty="Situação"         	propertyValue="situacao"      		style="width:100px;text-align:center;"/>
        <duques:column labelProperty="Internet"         	propertyValue="internet"      		style="width:100px;text-align:center;"/>
        <duques:column labelProperty="Observação"         	propertyValue="observacao"      	style="width:400px;"/>
        <duques:column labelProperty="Documento" 			propertyValue="nomeArquivo"			style="width:300px;" fileType="true" scriptFunction="baixarDocumento()"/>
    </duques:grid>
    
</s:form>

