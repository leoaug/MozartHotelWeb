<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarEmpresa!prepararPesquisa.action" namespace="/app/empresa" />';
	submitForm(vForm);
}


var reportAddress = '';
function imprimir(){

	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
	if (1 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=tarifasExpiradasReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();

		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	} else if (2 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=ultimaMovimentacaoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}	



}
            
</script>



<s:form action="pesquisar!prepararPesquisa.action" namespace="/app/empresa" theme="simple">
<div class="divFiltroPaiTop">Relatório</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Tipos de relatório</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input type="radio" name="TIPO" id="TIPO" value="1" checked="checked" />Tarifas expiradas<br/>
						<input type="radio" name="TIPO" id="TIPO" value="2" />Última movimentação<br/>
                    </div>
                    <div class="divItemGrupo" style="width:250px;color:blue;" >

                    </div>
                </div>

                <div class="divLinhaCadastro" id="divPeriodo">
                
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Período:</p> 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" /> 
                          à 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataFinal" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataFinal" size="8" maxlength="10" />
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