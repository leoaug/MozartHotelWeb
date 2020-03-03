<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>
	$('#linhaTesouraria').css('display','block');

    function init(){
        
    }

    function onEnter(){
        
    }

	
	function prepararAlteracao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTesouraria!prepararAlteracao.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

    function pesquisar(){
		vForm = document.forms[0];
		submitForm( vForm );
     }
	
    function relatorio() {        
        document.forms[0].action = '<s:url action="relatorioTesouraria!prepararRelatorio.action" namespace="/app/financeiro" />';        
        submitForm(document.forms[0]);
    }


	function prepararEncerramento(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="encerrarTesouraria!prepararEncerramento.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

	function conciliar(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="conciliarTesouraria!prepararConciliacao.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}


	function encerrar(){

		vForm = document.forms[0];
		vForm.action = '<s:url action="encerrarTesouraria!prepararEncerramento.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}


	function prepararInclusao(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterTesouraria!prepararInclusao.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}
	
	currentMenu = "tesouraria";
	
    with(milonic=new menuname("tesourariaSSSS")){
        margin=3;
        style=contextStyle;
        top="offset=2";
        aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:prepararAlteracao();");
        drawMenus(); 
    }

    </script>


  <s:form action="pesquisarTesouraria!pesquisar.action" namespace="/app/financeiro" theme="simple" >
  	<s:hidden name="entidadeT.idTesouraria" id="idAlteracao"/>

    <div class="divFiltroPaiTop">Tesouraria</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="TESOURARIA_WEB" titulo="" />
        </div>
    </div>
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros" >
        </div>
        
        <div id="divBotao" class="divBotao">
            <duques:botao label="Pesquisar" 	imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="pesquisar();"/>
            <duques:botao label="Novo" 			imagem="imagens/iconic/png/plus-3x.png" onClick="prepararInclusao();" />
            <duques:botao label="Relatório" 	imagem="imagens/iconic/png/print-3x.png" onClick="relatorio();" />
            <s:if test="%{#session.listaPesquisa.size() > 0 && filtro.filtroConciliado.tipoIntervalo eq \"N\"}">
            	<duques:botao label="Conciliar" 	imagem="imagens/iconic/png/print-3x.png" onClick="conciliar();" />
            </s:if>
            <duques:botao label="Encerrar" 		imagem="imagens/iconMozart.png" onClick="prepararEncerramento();" />
        </div>
    </div>
    
 <!-- grid -->     
    <duques:grid colecao="listaPesquisa" titulo="Tesouraria" 
    			 condicao="" current="obj" 
    			 idAlteracaoValue="idTesouraria" idAlteracao="idAlteracao"
				 urlRetorno="pages/modulo/financeiro/tesouraria/pesquisar.jsp">
    	
    	<duques:column labelProperty="Hotel"       			propertyValue="sigla"  				style="width:100px;" grouped="true"/>
    	<duques:column labelProperty="Cód Tes"    			propertyValue="idTesouraria"   		style="width:100px;" />        
    	<duques:column labelProperty="Banco"    			propertyValue="nomeContaCorrente"   style="width:200px;" />
        <duques:column labelProperty="Conta Corrente" 		propertyValue="contaCorrente"       style="width:140px;" />
        <duques:column labelProperty="Dt lçto"      		propertyValue="data"      			style="width:170px;text-align:center;" />
        <duques:column labelProperty="Valor"      			propertyValue="valor"    			style="width:100px;text-align:right;" math="sum" />
        <duques:column labelProperty="D/C"      			propertyValue="debitoCredito"    	style="width:100px;" />
        <duques:column labelProperty="Conciliado"         	propertyValue="conciliado"      	style="width:100px;" />
        <duques:column labelProperty="Dt conc."      		propertyValue="dataConciliado"      style="width:100px;text-align:center;" />
        <duques:column labelProperty="Documento"       		propertyValue="numDocumento"	    style="width:180px;"/>
        <duques:column labelProperty="Histórico"       		propertyValue="historicoPadrao"	    style="width:250px;"/>
    </duques:grid>
    
</s:form>

