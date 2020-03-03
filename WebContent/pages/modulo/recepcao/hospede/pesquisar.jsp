<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		<s:if test="origemHospede"> 
			vForm.action = '<s:url action="manterHospede!prepararInclusao.action" namespace="/app/recepcao" />';
		</s:if>
		<s:else>
			vForm.action = '<s:url action="manterHospede!prepararInclusao.action" namespace="/app/comercial" />';
		</s:else>
		
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		<s:if test="origemHospede"> 
			vForm.action = '<s:url action="pesquisarHospede!pesquisar.action" namespace="/app/recepcao" />';
		</s:if>
		<s:else>
			vForm.action = '<s:url action="pesquisarHospede!pesquisar.action" namespace="/app/comercial" />';
		</s:else>
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		<s:if test="origemHospede"> 
			vForm.action = '<s:url action="manterHospede!prepararAlteracao.action" namespace="/app/recepcao" />';
		</s:if>
		<s:else>
			vForm.action = '<s:url action="manterHospede!prepararAlteracao.action" namespace="/app/comercial" />';
		</s:else>
	
		
		submitForm( vForm );
	}
    
    
currentMenu = "hospede";
with(milonic=new menuname("hospede")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarHospede!pesquisar.action" namespace="/app/comercial" theme="simple" >
  	<s:hidden name="entidade.idHospede" id="chave"/>
    <div class="divFiltroPaiTop">Hóspede</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="HOSPEDE_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar"  imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />
            
            <s:if test="origemHospede"> 
            	<duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
            </s:if>           
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="Relatório de hóspede" 
    			 condicao="bcIdHospede;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="chave" idAlteracaoValue="bcIdHospede" 
    			 urlRetorno="pages/modulo/recepcao/hospede/pesquisar.jsp">
    			 
        <duques:column labelProperty="Nome"    			propertyValue="bcNomeHospede"   style="width:300px;"/>
        <duques:column labelProperty="CPF"       		propertyValue="bcCpf"			style="width:120px;" />
        <duques:column labelProperty="Dt. Nascimento"   propertyValue="bcNascimento"	style="width:140px;text-align:center;" />
        <duques:column labelProperty="Passaporte"       propertyValue="bcPassaporte"	style="width:120px;" />
        <duques:column labelProperty="Identidade"       propertyValue="bcIdentidade"	style="width:120px;" />
        <duques:column labelProperty="Telefone"       	propertyValue="bcTelefone"		style="width:120px;" />
        <duques:column labelProperty="Fax"       		propertyValue="bcFax"			style="width:120px;" />
        <duques:column labelProperty="Celular"       	propertyValue="bcCelular"		style="width:120px;" />
        <duques:column labelProperty="Telex"       		propertyValue="bcTelex"			style="width:120px;" />
        <duques:column labelProperty="E-mail"       	propertyValue="bcEmail"			style="width:220px;" />
           
    </duques:grid>
    
</s:form>