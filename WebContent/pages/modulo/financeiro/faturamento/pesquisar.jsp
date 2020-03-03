<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
	$('#linhaFaturamento').css('display','block');

    function init(){
        
    }

    function gerarDuplicata(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="gerarDuplicata!prepararDuplicata.action" namespace="/app/financeiro" />';
		submitForm( vForm );
    	
    }
    
    function parcelar(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="parcelarFaturamento!prepararParcelamento.action" namespace="/app/financeiro" />';
		submitForm( vForm );
    }

    
	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterFaturamento!prepararAlteracao.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

	function prepararEncerramento(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="encerrarFaturamento!prepararEncerramento.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
    function relatorio() {        
        document.forms[0].action = '<s:url action="relatorioFaturamento!prepararRelatorio.action" namespace="/app/financeiro" />'        
        submitForm(document.forms[0]);
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
       String titulo = "Relatório";
       String requestvalue = request.getParameter("filtro.filtroTipoPesquisa");
       
       if ("1".equals( requestvalue)){
           titulo = "Relatório de dup a faturar";
    %>
    <script>
    currentMenu = "NAO_FAZ_NADA"; 
    </script>

    <%
       }else{ 
    	   titulo = "Relatório de dup faturadas";
    %>
    <script>
    currentMenu = "dup"; 
    </script>
    <%	
    	} 
    %> 
    


  <s:form action="pesquisarFaturamento!pesquisar.action" namespace="/app/financeiro" theme="simple" >
  	<s:hidden name="entidade.idDuplicata" id="idAlteracao"/>
    <div class="divFiltroPaiTop">Faturamento</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="DUPLICATA_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros" >
        
			<ul style="width: 200px; height:100%; float: left; padding: 0px; margin: 0px; list-style: none; font-size: 8pt; border-right: 1px solid black;">
				<li style="font-size: 8pt;"><input type="radio"
					<%=(request.getParameter("filtro.filtroTipoPesquisa")==null || "1".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":"")%>
					name="filtro.filtroTipoPesquisa" value="1" />A faturar</li>
				
				
				<li style="font-size: 8pt;"><input type="radio"
					<%="2".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":""%>
					name="filtro.filtroTipoPesquisa" value="2" />Faturadas</li>
			</ul>
			            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" 	imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();"/>
            <duques:botao label="Relatório" 	imagem="imagens/iconic/png/print-3x.png" onClick="relatorio();" />
            <duques:botao label="Gerar duplicata" 	imagem="imagens/iconic/png/check-4x.png" onClick="gerarDuplicata();" style="width:140px"/>
            <duques:botao label="Encerrar" 			imagem="imagens/iconMozart.png" onClick="prepararEncerramento();" />
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="<%=titulo%>" 
    			 condicao="idDuplicata;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracaoValue="idDuplicata" idAlteracao="idAlteracao"
				 urlRetorno="pages/modulo/financeiro/faturamento/pesquisar.jsp">
    			 
    	<duques:column labelProperty="Cód Dup"    			propertyValue="idDuplicata"     	style="width:100px;"/>
    	<duques:column labelProperty="Empresa"       		propertyValue="empresa"  			style="width:300px;" grouped="true"/>		 
        <duques:column labelProperty="Nota"    				propertyValue="numNota"     		style="width:100px;"/>
        <duques:column labelProperty="Num duplicata"    	propertyValue="numDuplicata"      	style="width:150px;" grouped="true"/>
        <duques:column labelProperty="Parcela"         		propertyValue="parcela"      		style="width:110px;text-align:center;" math="count"/>
        <duques:column labelProperty="Vl Duplicata"         propertyValue="valorDuplicata"      style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Comissão"       		propertyValue="comissao"            style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="IR"       			propertyValue="ir"            		style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Ajustes"      		propertyValue="ajuste"          	style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Encargos"      		propertyValue="encargos"          	style="width:110px;text-align:right;" math="sum"/>
        <duques:column labelProperty="Dt vcto"      		propertyValue="dataVencimento"      style="width:100px;text-align:center;" />
        <duques:column labelProperty="Dt lçto"      		propertyValue="dataLancamento"      style="width:100px;text-align:center;" />
        <duques:column labelProperty="Conta"   				propertyValue="contaCorrente"      	style="width:110px;text-align:left;" />
        <duques:column labelProperty="Hotel"       			propertyValue="sigla"  				style="width:100px;" />
                
    </duques:grid>
    
</s:form>

