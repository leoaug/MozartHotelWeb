<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
	$('#linhaContasReceber').css('display','block');

    function init(){
        
    }


	function receber(){

			vForm = document.forms[0];
			vForm.action = '<s:url action="receberContasReceber!prepararRecebimento.action" namespace="/app/financeiro" />';
			submitForm( vForm );
			
	}


	function prepararRecebimento(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="receberContasReceber!prepararRecebimentoDuplicata.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}
	
	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterContasReceber!prepararAlteracao.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
    function relatorio() {        
        document.forms[0].action = '<s:url action="relatorioContasReceber!prepararRelatorio.action" namespace="/app/financeiro" />';      
        submitForm(document.forms[0]);
    }


	function prepararEncerramento(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="encerrarContasReceber!prepararEncerramento.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

	function estornarDuplicata(){

		if (confirm('Confirma o estorno da duplicata selecionada?')){
			vForm = document.forms[0];
			vForm.action = '<s:url action="manterContasReceber!estornarDuplicata.action" namespace="/app/financeiro" />';
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

	function parcelarDuplicata(){

		vForm = document.forms[0];
		vForm.action = '<s:url action="parcelarFaturamento!prepararParcelamento.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}


	function recomprarDuplicata(){
		if (confirm('Confirma a recompra da duplicata selecionada?')){
			vForm = document.forms[0];
			vForm.action = '<s:url action="manterContasReceber!recomprarDuplicata.action" namespace="/app/financeiro" />';
			submitForm( vForm );
		}

	}
	
    with(milonic=new menuname("dupAberta")){
        margin=3;
        style=contextStyle;
        top="offset=2";
        aI("image=imagens/btnAlterar.png;text=Descontar;url=javascript:descontarDuplicata();");
        aI("image=imagens/btnAlterar.png;text=Parcelar;url=javascript:parcelarDuplicata();");
        aI("image=imagens/btnAlterar.png;text=Receber;url=javascript:prepararRecebimento();");
        aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
        drawMenus(); 
    }

    with(milonic=new menuname("dupRecebida")){
        margin=3;
        style=contextStyle;
        top="offset=2";
        aI("image=imagens/btnAlterar.png;text=Estornar;url=javascript:estornarDuplicata();");
        drawMenus(); 
    }

    with(milonic=new menuname("dupDescontada")){
        margin=3;
        style=contextStyle;
        top="offset=2";
        aI("image=imagens/btnAlterar.png;text=Recomprar;url=javascript:recomprarDuplicata();");
        drawMenus(); 
    }

    
    with(milonic=new menuname("dup")){
    margin=3;
    style=contextStyle;
    top="offset=2";
    aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
    aI("image=imagens/btnImprimir.png;text=Parcelar;url=javascript:parcelar();");
    drawMenus(); 
    }

    </script>

    <%
       String titulo = "Relatório de duplicatas";
       String requestvalue = request.getParameter("filtro.filtroTipoPesquisa");
       
       if ("1".equals( requestvalue)){
           titulo = "Relatório de duplicatas abertas";
    %>
    <script>
    currentMenu = "dupAberta"; 
    </script>

    <%
       }else if ("2".equals( requestvalue )){
    	   titulo = "Relatório de duplicatas recebidas";
    %>
	<script>
    currentMenu = "dupRecebida"; 
    </script>


    <%
       }else  if ("3".equals( requestvalue )){ 
    	   titulo = "Relatório de duplicatas descontadas";
    %>
    <script>
    currentMenu = "dupDescontada"; 
    </script>
    <%	
    	} 
    %> 
    


  <s:form action="pesquisarContasReceber!pesquisar.action" namespace="/app/financeiro" theme="simple" >
  	<s:hidden name="entidade.idDuplicata" id="idAlteracao"/>
  	<s:hidden name="origemParcelamento" value="CR"/>
  	<s:hidden name="origemRecebimento" id="origemRecebimento" value="CR" />
  	
    <div class="divFiltroPaiTop">Contas a receber</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="CONTAS_RECEBER_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros" >
        
			<ul style="width: 210px; height:100%; float: left; padding: 0px; margin: 0px; list-style: none; font-size: 8pt; border-right: 1px solid black;">
				<li style="width: 100px; font-size: 8pt;float:left;"><input type="radio"
					<%=(request.getParameter("filtro.filtroTipoPesquisa")==null || "1".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":"")%>
					name="filtro.filtroTipoPesquisa" value="1" />Abertas</li>
				
				
				<li style="width: 100px;font-size: 8pt;float:left;"><input type="radio"
					<%="2".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
					name="filtro.filtroTipoPesquisa" value="2" />Recebidas</li>

				<li style="width: 100px;font-size: 8pt;float:left;"><input type="radio"
					<%=("3".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":"")%>
					name="filtro.filtroTipoPesquisa" value="3" />Descontadas</li>
				
				
				<li style="width: 100px;font-size: 8pt;float:left;"><input type="radio"
					<%="4".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
					name="filtro.filtroTipoPesquisa" value="4" />Todas</li>
			</ul>
			            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" 	imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();"/>
            <duques:botao label="Relatório" 	imagem="imagens/iconic/png/print-3x.png" onClick="relatorio();" />
            <s:if test="%{#request.filtro.filtroTipoPesquisa == \"1\" && #session.listaPesquisa.size() > 0}">
            	<duques:botao label="Receber" 		imagem="imagens/iconic/png/print-3x.png" onClick="receber();" />
            	<duques:botao label="Descontar" 	imagem="imagens/iconic/png/print-3x.png" onClick="descontar();" style="width:110px;" />
            	
            </s:if>
            <duques:botao label="Encerrar" 		imagem="imagens/iconMozart.png" onClick="prepararEncerramento();" />
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="<%=titulo%>" 
    			 condicao="idDuplicata;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracaoValue="idDuplicata" idAlteracao="idAlteracao"
				 urlRetorno="pages/modulo/financeiro/contasReceber/pesquisar.jsp">
    	
    	<duques:column labelProperty="Hotel"       			propertyValue="sigla"  				style="width:100px;" />		 
		<duques:column labelProperty="Cód duplicata"    	propertyValue="idDuplicata"      	style="width:100px;"/>
    	<duques:column labelProperty="Empresa"       		propertyValue="empresa"  			style="width:300px;" grouped="true"/>		 
        <duques:column labelProperty="Num duplicata"    	propertyValue="numDuplicata"      	style="width:150px;" grouped="true"/>
        <duques:column labelProperty="Vl Duplicata"         propertyValue="valorDuplicata"      style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Dt lçto"      		propertyValue="dataLancamento"      style="width:100px;text-align:center;" />
        <duques:column labelProperty="Dt vcto"      		propertyValue="dataVencimento"      style="width:100px;text-align:center;" />
        <duques:column labelProperty="Dt desc"      		propertyValue="dataDesconto"      	style="width:100px;text-align:center;" />
        <duques:column labelProperty="Dt receb."      		propertyValue="dataRecebimento"    	style="width:100px;text-align:center;" />
        <duques:column labelProperty="Prorrogado"      		propertyValue="dataProrrogado"    	style="width:100px;text-align:center;" />
        <duques:column labelProperty="Dt recom."      		propertyValue="dataRecompra"    	style="width:100px;text-align:center;" />
        <duques:column labelProperty="Comissão"       		propertyValue="comissao"            style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="IR"       			propertyValue="ir"            		style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Ajustes"      		propertyValue="ajuste"          	style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Encargos"      		propertyValue="encargos"          	style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Retenções"      		propertyValue="retencao"          	style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Desc. Receb."    		propertyValue="descontoRecebimento" style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Num Lote"    			propertyValue="numLote"     		style="width:100px;"/>        
        <duques:column labelProperty="Agrupar"         		propertyValue="agrupar"      		style="width:100px;text-align:center;"/>
                
    </duques:grid>
    
</s:form>

