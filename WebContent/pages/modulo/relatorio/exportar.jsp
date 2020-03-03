<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarExportar!prepararPesquisa.action" namespace="/app/exportar" />';
	submitForm(vForm);
}

$(document).ready(
		function(){
		    $(".radioTipo").click(
	            function() { 
	                if (this.value == '3'){	  
	                	$("#FORMATO_2").attr('checked', 'checked');
	                }
	                else 
	                	$("#FORMATO_1").attr('checked', 'checked');
	            }
		    );
		}
	);

var reportAddress = '';
function imprimir(){

	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
	var formato=$("input[name='FORMATO']:checked").val();
	var contentType = 'application/vnd.ms-excel';
	if(formato == 'CSV')
		contentType = 'application/force-download';
	
	var params = 'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
	if (1 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
				
		reportAddress += '/index.jsp?REPORT=recebimentosFaturamentoReport';
		reportAddress += '&FORMAT='+ formato;
		reportAddress += '&CONTENTTYPE='+ contentType;
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();

		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (2 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		
		reportAddress += '/index.jsp?REPORT=recebimentosGeralReport';
		reportAddress += '&FORMAT='+ formato;
		reportAddress += '&CONTENTTYPE='+ contentType;
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}
	else if (3 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		
		reportAddress += '/index.jsp?REPORT=contasPagarReport';
		reportAddress += '&FORMAT='+ formato;
		reportAddress += '&CONTENTTYPE='+ contentType;
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}
}
	
</script>



<s:form action="pesquisarRelatorioGeral!prepararPesquisa.action" namespace="/app/exportar" theme="simple">
<s:hidden id="origemCrs" name="origemCrs" />
<div class="divFiltroPaiTop">Exportar</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:340px;">
                <div class="divGrupoTitulo">Tipos de relatório</div>
                
	                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
	                
	                    <div class="divItemGrupo" style="width:250px;color:blue;" >
							<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" checked="checked" />Recebimentos Faturados<br/>
							<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="2" />Recebimentos - Demais<br/>
							<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="3" />Contas a Pagar<br/>
	                    </div>
	                    <div class="divItemGrupo" style="width:250px;color:blue;" >
							
	                    </div>
	                </div>

                	<div class="divLinhaCadastro" id="divPeriodo">
                
	                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Período:</p> 
	
	                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" /> 
						</div>
						<div class="divItemGrupo" id="divDataFinal">
	                          à 
	                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataFinal" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataFinal" size="8" maxlength="10" />
	                    </div>
                	</div>
                
	                <div class="divLinhaCadastro" id="divLinhaFormatoReport">
	                
	                    <div class="divItemGrupo" style="width:280px; " ><p style="width:80px;">Formato:</p> 
							<input class="radioFormato"  type="radio" name="FORMATO" id="FORMATO_1" value="CSV" checked="checked" />CSV
							<input class="radioFormato"  type="radio" name="FORMATO" id="FORMATO_2" value="PDF" />PDF 
							<input class="radioFormato"  type="radio" name="FORMATO" id="FORMATO_3" value="XLS" />EXCEL 
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