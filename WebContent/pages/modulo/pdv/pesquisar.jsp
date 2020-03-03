<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
	}
	function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterMovimentacaoPontoVenda!prepararInclusao.action" namespace="/app/pdv" />';
		submitForm( vForm );
	}
</script>


<s:form namespace="/app/pdv" action="movimentacaoPontoVenda!pesquisar.action"
	theme="simple">


    <div class="divFiltroPaiTop">Movimentação - PDV</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="MOVIMENTO_RESTAURANTE_WEB" titulo="" />
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
 <duques:grid colecao="listaPesquisa" titulo="Relatório de Movimentação-PDV" 
    			 current="obj" 
    			 idAlteracao="idMovimentoRestaurante" idAlteracaoValue="idMovimentoRestaurante" urlRetorno="pages/modulo/pdv/pesquisar.jsp">
    			 
    	<duques:column labelProperty="Ponto de Venda"       propertyValue="nomePontoVenda"  		style="width:200px;" />		 
        <duques:column labelProperty="Nome do Prato"    	propertyValue="nomePrato"     	style="width:400px;"/>
        <duques:column labelProperty="Núm. da Mesa"    		propertyValue="numMesa"     			style="width:150px;"/>
        <duques:column labelProperty="Quant."    			propertyValue="quantidade"      	style="width:75px;"/>
        <duques:column labelProperty="Num.Nota"         	propertyValue="numNota"            style="width:120px;"/>
        <duques:column labelProperty="Vr. do Prato"       	propertyValue="vlPrato"            		style="width:125px;text-align:right;" />
        <duques:column labelProperty="Vr. Unitário"       	propertyValue="vlUnitario"            	style="width:125px;text-align:right;" />
        <duques:column labelProperty="Vr. Desconto"      	propertyValue="vlDesconto"          	style="width:125px;text-align:right;" />
        <duques:column labelProperty="Sigla"      			propertyValue="siglaHotel"          	style="width:100px;" />
        <duques:column labelProperty="Loc. do lançamento"   propertyValue="idMoviementoRestaurante"         style="width:150px;" />
                
    
                
    </duques:grid>
       
    
</s:form>