<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
$('#linhaEstoque').css('display', 'block');

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarAjustePdv!prepararPesquisa.action" namespace="/app/custo" />';
	submitForm(vForm);
}


var reportAddress = '';
function imprimir(){

	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
	var formato=$("input[name='FORMATO']:checked").val();
	if (1 == idRel){
		if ($('#dataInicial').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
				
		reportAddress += '/index.jsp?REPORT=custoInventarioPdvReport';
		reportAddress += '&FORMAT='+ formato;
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';IDCCC@'+$('#centroCustoContabil').val(); 

		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}
}
	
</script>



<s:form action="pesquisarRelatorioPdv!prepararPesquisaRelatorio.action" namespace="/app/custo" theme="simple">
<s:hidden id="origemCrs" name="origemCrs" />
<div class="divFiltroPaiTop">Relatório de Custos</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:340px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" checked="checked" />Relatório de Estoque no PDV<br/>
                    </div>
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						
                    </div>
                </div>

                <div class="divLinhaCadastro" id="divPeriodo">
                
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Período:</p> 

                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" /> 
					</div>
                
                </div>
                <div class="divLinhaCadastro" id="divCentroCustoContabil">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Centro Custo:</p> 
                          <s:select cssStyle="width:200px" id="centroCustoContabil" name="centroCustoContabil" list="centroCustoList" headerKey="" headerValue="Todos" listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"/>
                   </div>			
                </div>
                <div class="divLinhaCadastro" id="divLinhaFormatoReport">
                
                    <div class="divItemGrupo" style="width:280px; " ><p style="width:80px;">Formato:</p> 
						<input class="radioFormato"  type="radio" name="FORMATO" id="FORMATO" value="PDF" checked="checked" />PDF 
						<input class="radioFormato"  type="radio" name="FORMATO" id="FORMATO" value="XLS" />EXCEL 
                   </div>       
                </div>
                
              </div>


             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Imprimir" imagem="imagens/iconic/png/print-3x.png" onClick="imprimir()" />
              </div>
              
        </div>
</div>

</s:form>