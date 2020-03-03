<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterAchadosPerdido!prepararInclusao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }
	    
    function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterAchadosPerdido!prepararAlteracao.action" namespace="/app/sistema" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	currentMenu = "achadosPerdido";
	with(milonic=new menuname("achadosPerdido")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>

  <s:form action="pesquisarAchadosPerdido!pesquisar.action" namespace="/app/sistema" theme="simple" >
  	<s:hidden name="entidade.getIdAchadosPerdidos" id="idAlteracao"/>
  	
  	<div class="divFiltroPaiTop">Achados e Perdidos</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="ACHADOS_PERDIDO_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar"  imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />    
            <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
    	</div>
    
    </div>
    
 <!-- grid -->
    
    <duques:grid colecao="listaPesquisa" titulo="Relatório Achados e Perdidos " 
    			 current="obj" 
    			 idAlteracao="idAlteracao" 
    			 idAlteracaoValue="getIdAchadosPerdidos" 
    			 urlRetorno="pages/modulo/sistema/achadosPerdido/pesquisar.jsp">
    	
    	
		<duques:column labelProperty="Id Achados Perdidos"    	 propertyValue="idAchadosPerdidos;"		 		style="width:130px;" />
        <duques:column labelProperty="Objeto"    		 		 propertyValue="objeto;" 						style="width:260px;" />
        <duques:column labelProperty="Período"     		 		 propertyValue="periodo;" 						style="width:150px;" />
        <duques:column labelProperty="Local"    				 propertyValue="local;" 						style="width:80px;" />
        <duques:column labelProperty="Data"  				  	 propertyValue="data;" 							style="width:120px;" />
        <duques:column labelProperty="Funcionário Achou"     	 propertyValue="funcionarioAchou;" 				style="width:120px;" />
        <duques:column labelProperty="ID Hóspede"    			 propertyValue="idHospede;" 					style="width:120px;" />
        <duques:column labelProperty="Data Devolução"        	 propertyValue="dataDevolucao;" 				style="width:120px;" />
        <duques:column labelProperty="Funcionário Recebe"    	 propertyValue="funcionarioRecebe;" 			style="width:100px;" />
		<duques:column labelProperty="Documento"    			 propertyValue="documento;" 					style="width:190px;" />
        <duques:column labelProperty="ID Hotel"   	 			 propertyValue="idHotel;" 						style="width:190px;" />
        <duques:column labelProperty="Recebedor"  				 propertyValue="recebedor;" 					style="width:190px;" />
        <duques:column labelProperty="Doc. Recebedor"  			 propertyValue="docRecebedor;;" 				style="width:190px;" />
        <duques:column labelProperty="Hóspede"  				 propertyValue="hospede;;" 						style="width:190px;" />
        <duques:column labelProperty="Celular"  				 propertyValue="celular;;" 						style="width:190px;" />
        




    </duques:grid>
    
</s:form>