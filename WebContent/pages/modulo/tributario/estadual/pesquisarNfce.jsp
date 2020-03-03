<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
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
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarNfce!pesquisar.action" namespace="/app/sistema" theme="simple" >
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
    	</div>
    
    </div>
 <!-- grid -->
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Nfce" 
    			 current="obj" 
    			 idAlteracao="idNota" 
    			 idAlteracaoValue="gracIdNota" 
    			 urlRetorno="pages/modulo/tributario/estadual/pesquisarNfce.jsp" >
		
		<duques:column labelProperty="Status"	    	 propertyValue="gracStatus"		 				style="width:120px;" />
		<duques:column labelProperty="Data Emissão"		 propertyValue="gracDataEmissaoFormatada" 		style="width:100px;" />
        <duques:column labelProperty="Num. da Nota"      propertyValue="gracNumNota" 					style="width:80px; text-align: center;" />
        <duques:column labelProperty="Série"	    	 propertyValue="gracSerie" 						style="width:120px;" />
        <duques:column labelProperty="Modelo"     	     propertyValue="gracDescricaoModelo" 			style="width:100px;" />
        <duques:column labelProperty="Nat. Operação"     propertyValue="gracNaturezaOperacao" 			style="width:120px; text-align: right;" />
		<duques:column labelProperty="CPF/CNPJ"	 	 	 propertyValue="" 								style="width:100px; text-align: right;" />
		<duques:column labelProperty="Cliente"    	     propertyValue="" 								style="width:100px; text-align: right;" />
		<duques:column labelProperty="Chave de Acesso" 	 propertyValue="gracChaveAcesso" 				style="width:100px; text-align: right;" />
		<duques:column labelProperty="Valor da Nota"     propertyValue="gracValorTotal" 				style="width:100px; text-align: right;" />
		<duques:column labelProperty="Código"  			 propertyValue="gracNumero" 					style="width:100px; text-align: right;" />
		<duques:column labelProperty="Mensagem"    	 	 propertyValue="gracMensagem" 					style="width:100px; text-align: right;" />
		<duques:column labelProperty="XML"    	 	 	 propertyValue="gracNomeArquivo" 				style="width:100px; text-align: right;" />
		<duques:column labelProperty="Loc. do Item"    	 propertyValue="gracIdNota" 					style="width:100px; text-align: right;" />
		<duques:column labelProperty="Sigla"    	 	 propertyValue="gracSigla" 						style="width:100px; text-align: right;" />
        
    </duques:grid>
    
</s:form>