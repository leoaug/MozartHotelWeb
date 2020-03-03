<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
    function init(){
        
    }

    function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterGDS!prepararInclusao.action" namespace="/app/rede" />';
		submitForm( vForm );
    }

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
    }

	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterGDS!prepararAlteracao.action" namespace="/app/rede" />';
		submitForm( vForm );
	}
    
    
currentMenu = "administradorCanal";
with(milonic=new menuname("administradorCanal")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
drawMenus();  
} 
    
    
</script>


  <s:form action="pesquisarGDS!pesquisar.action" namespace="/app/rede" theme="simple" >
  	<s:hidden name="entidade.idGds" id="chave"/>
    <div class="divFiltroPaiTop">Administrador de Canais</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="GDS_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros">
            
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();" />
            <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />           
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="Administradores de Canais" 
    			 current="obj" 
    			 idAlteracao="chave" idAlteracaoValue="idGds" 
    			 urlRetorno="pages/modulo/rede/administradorCanais/pesquisar.jsp">
    			 
        <duques:column labelProperty="Nome Fantasia"			propertyValue="nomeFantasia"  				style="width:300px;"/>
        <duques:column labelProperty="Código"       			propertyValue="codigo"						style="width:100px;" />
        <duques:column labelProperty="Ativo"       				propertyValue="ativo"						style="width:100px;text-align:center;" />
        <duques:column labelProperty="Comissão"      			propertyValue="comissao" 					style="width:120px;text-align:center;" />
        <duques:column labelProperty="Valor por Reserva"       	propertyValue="feeReserva"					style="width:170px;" />
        <duques:column labelProperty="Valor Mensal"       		propertyValue="feeMensal"					style="width:120px;" />
        <duques:column labelProperty="Bloqueio/Disponibilidade"	propertyValue="disponibilidadeBloqueio"		style="width:180px;" />
    </duques:grid>
    
</s:form>
