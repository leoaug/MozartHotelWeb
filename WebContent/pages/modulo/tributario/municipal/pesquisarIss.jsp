<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="gerarLoteIss!prepararLotes.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterIss!prepararAlteracao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
    
    function prepararInclusaoDiscriminacao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterIss!prepararAlteracaoDiscriminacao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "idNota";
	with(milonic=new menuname("idNota")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	aI("image=imagens/btnAlterar.png;text=Alterar a Discriminação;url=javascript:prepararInclusaoDiscriminacao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarIss!pesquisar.action" namespace="/app/sistema" theme="simple" >
  	<s:hidden name="entidade.idNota" id="idNota"/>
  	
  	<div class="divFiltroPaiTop">NFS-e</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="NFSE_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
      <!--  <div id="divOutros" class="divOutros">
            <ul style="width: 200px; height:100%; float: left; padding: 0px; margin: 0px; list-style: none; font-size: 8pt; border-right: 1px solid black;">
				<li style="font-size: 8pt;"><input type="radio"
					<%=(request.getParameter("filtro.filtroTipoPesquisa")==null || "1".equals(request.getParameter("filtro.filtroTipoPesquisa"))?"checked":"")%>
					name="filtro.filtroTipoPesquisa" value="1" />A Gerar</li>
			</ul>
        </div>
        -->  
        <div id="divBotao" class="divBotao">
            <duques:botao style="width:110px " label="Pesquisar"  imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />    
            <duques:botao style="width:110px " label="Gerar Lote" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
    	</div>
    
    </div>
    
 <!-- grid -->
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório RPS " 
    			 current="obj" 
    			 idAlteracao="idNota" 
    			 idAlteracaoValue="gracIdNota" 
    			 urlRetorno="pages/modulo/tributario/municipal/pesquisarIss.jsp" >
		
		<duques:column labelProperty="Status RPS"     	 propertyValue="gracStatusRPS" 				style="width:100px;" />
        <duques:column labelProperty="No.RPS"    	 	 propertyValue="gracNotaInicial" 			style="width:110px;" />
        <duques:column labelProperty="Série"     		 propertyValue="gracSerie" 					style="width:80px; text-align: center;" />
        <duques:column labelProperty="Data Emissao"    	 propertyValue="gracDataEmissaoFormatada" 	style="width:120px;" />
        <duques:column labelProperty="Vr. Servicos"      propertyValue="gracValorServico" 			style="width:120px; text-align: right;" />
        <duques:column labelProperty="Vr. Iss"  		 propertyValue="gracValorISS" 				style="width:100px; text-align: right;" />
        <duques:column labelProperty="Nome Fantasia"     propertyValue="gracRazaoSocial"		 	style="width:230px;" />
		<duques:column labelProperty="Vr. Iss Retido"    propertyValue="gracISSRetido" 				style="width:120px; text-align: right;" />
		<duques:column labelProperty="Vr. Pis"    	     propertyValue="gracValorPIS" 				style="width:100px; text-align: right;" />
		<duques:column labelProperty="Vr. Cofins"    	 propertyValue="gracValorCOFINS" 			style="width:100px; text-align: right;" />
        <duques:column labelProperty="Vr. Inss"   	     propertyValue="gracValorINSS" 				style="width:100px; text-align: right;" />
        <duques:column labelProperty="Vr. Ir"  		     propertyValue="gracValorIR" 				style="width:100px; text-align: right;" />
        <duques:column labelProperty="Vr. Csll"  		 propertyValue="gracValorCSLL" 				style="width:100px; text-align: right;" />
        <duques:column labelProperty="Outras Retenções"  propertyValue="gracOutrasRetencoes" 		style="width:140px; text-align: right;" />
		<duques:column labelProperty="Loc. do Item"    	 propertyValue="gracIdNota"		 			style="width:120px;" />

    </duques:grid>
    
</s:form>