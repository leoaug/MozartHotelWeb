<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisar!prepararPesquisa.action" namespace="/app/reserva" />';
	submitForm(vForm);
}


var reportAddress = '';
function imprimir(){

	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
	if (1 == idRel){
		if ($('#dataInicial').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=noShowReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();


		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (2 == idRel){
		if ($('#dataInicial').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=movimentacaoReservasReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA_FIM@'+$('#dataInicial').val();

		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (3 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=reservasCanceladasReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();

		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (4 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=reservasAptoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
	
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (5 == idRel){
		if ($('#dataInicial').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=reservasChartEmpresaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
	
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (6 == idRel){
		if ($('#dataInicial').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=chartPorReservaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
	
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	} 
}


$(document).ready(
		function(){
			    $(".radioTipo").click(
			            function() { 
			            	$('#spanDataFinal').css('display','block');	
			                if (this.value == '5' || this.value == '6'|| this.value == '1' || this.value == '2'){
								$('#spanDataFinal').css('display','none');
			                }
			            }
			    );
		        
		}
	)
	
</script>



<s:form action="pesquisar!prepararPesquisa.action" namespace="/app/reserva" theme="simple">
<s:hidden id="origemCrs" name="origemCrs" />
<div class="divFiltroPaiTop">Relatório</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:280px;">
                <div class="divGrupoTitulo">Tipos de relatório</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" checked="checked" />No show<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="2" />Movimentação<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="3"  />Reservas canceladas<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="4"  />Reservas por Apto<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="5"  />Chart por empresa<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="6"  />Chart por reserva<br/>
                    </div>
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						
                    </div>
                </div>

                <div class="divLinhaCadastro" id="divPeriodo">
                
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Período:</p> 

                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" /> 
					</div>
					<div class="divItemGrupo" id="spanDataFinal" style="width:150px;display:none;">
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