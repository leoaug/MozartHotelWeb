<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterCamareira!prepararInclusao.action" namespace="/app/operacional" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterCamareira!prepararAlteracao.action" namespace="/app/operacional" />';
		submitForm( vForm );
	}
    
    
	currentMenu = "camareira";
	with(milonic=new menuname("camareira")){
	margin=3;
	style=contextStyle;
	top="offset=2";
	aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
	drawMenus();  
	} 
    
</script>


  <s:form action="pesquisarCamareira!pesquisar.action" namespace="/app/operacional" theme="simple" >
  	<s:hidden name="entidade.idCamareira" id="idCamareira"/>
    <div class="divFiltroPaiTop">Camareira</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="CAMAREIRA_WEB" titulo="" />
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
    <duques:grid colecao="listaPesquisa" titulo="Relat�rio de camareira" 
    			 condicao="idCamareira;eq;-1;reservaSemCheckin" current="obj" 
    			 idAlteracao="idCamareira" idAlteracaoValue="idCamareira" urlRetorno="pages/modulo/operacional/camareira/pesquisar.jsp">
        <duques:column labelProperty="Nome"    						propertyValue="nome"     			style="width:220px;"/>
        <duques:column labelProperty="Ativo"    					propertyValue="ativo"      			style="width:100px;"/>
        <duques:column labelProperty="C�d. Do Registro"         	propertyValue="idCamareira"   style="width:100px;"/>
        <duques:column labelProperty="Sigla"         				propertyValue="sigla"   style="width:100px;"/>
    </duques:grid>
    
</s:form>