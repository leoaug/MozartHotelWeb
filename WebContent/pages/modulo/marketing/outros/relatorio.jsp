<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="outros!prepararOutros.action" namespace="/app/marketing" />';
	submitForm(vForm);
}

var reportAddress = '';
function imprimir(){

	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
		if (idRel == "1"){
					if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
				alerta("O campo 'Período' é obrigatório.");
				return false;
					}
				reportAddress += '/index.jsp?REPORT=marketingFormaReservaReport';
				params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
				params += ';P_DATA@'+$('#dataInicial').val();
				params += ';P_DATA_FIM@'+$('#dataFinal').val();
				params += ';FORMA@ALL';
				params += ';ANO@ALL';
				reportAddress += '&PARAMS='+params;
				showPopupGrande(reportAddress);
	
			}else if (2 == idRel){
				if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
					alerta("O campo 'Período' é obrigatório.");
					return false;
						}
				reportAddress += '/index.jsp?REPORT=tipoMidiaReport';
				params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
				params += ';P_DATA@'+$('#dataInicial').val();
				params += ';P_DATA_FIM@'+$('#dataFinal').val();
				params += ';MIDIA@ALL';
				params += ';ANO@ALL';
				reportAddress += '&PARAMS='+params;
				showPopupGrande(reportAddress);
		}else if (3 == idRel){
			if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
				alerta("O campo 'Período' é obrigatório.");
				return false;
					}
			reportAddress += '/index.jsp?REPORT=marketingMeioTransporteReport';
			params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
			params += ';P_DATA@'+$('#dataInicial').val();
			params += ';P_DATA_FIM@'+$('#dataFinal').val();
			params += ';MEIO@ALL';
			params += ';ANO@ALL';
			reportAddress += '&PARAMS='+params;
			showPopupGrande(reportAddress);
		}else if (4 == idRel){
			if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
				alerta("O campo 'Período' é obrigatório.");
				return false;
					}
			reportAddress += '/index.jsp?REPORT=marketingMotivoViagemReport';
			params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
			params += ';P_DATA@'+$('#dataInicial').val();
			params += ';P_DATA_FIM@'+$('#dataFinal').val();
			params += ';MOTIVO@ALL';
			params += ';ANO@ALL';
			reportAddress += '&PARAMS='+params;
			showPopupGrande(reportAddress);
		}

	
	
}

params += ';IDE@'+$('#idEmpresa').val();

$(document).ready(
		function(){
			    $(".radioTipo").click(
			            function() { 
				            	$('#divPeriodo').css('display','none');
				            	$('#divDataFinal').css('display','block');
				        if (this.value == '2'){

								$('#divPeriodo').css('display','block');
								

				        }else if (this.value == '3'){
			                	
			                	$('#divDataFinal').css('display','block');

					    }else if (this.value == '4'){
			                	
			                	$('#divDataFinal').css('display','block');

				       }else if (this.value == '5'){
			                	
			                	$('#divDataFinal').css('display','block');
			            }

			     }
			);
		        
		}
	)
	
</script>

<form>
<s:hidden id="origemCrs" name="origemCrs" />
<div class="divFiltroPaiTop">Relatório</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:280px;">
                <div class="divGrupoTitulo">Tipos de relatório</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" checked="checked" />Forma Reserva<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="2" />Tipo Mídia<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="3" />Meio Transporte<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="4" />Motivo Viagem<br/>
						
                    </div>
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						
                    </div>
                </div>
                
                
                
                <div class="divLinhaCadastro" id="divPeriodo">
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Período:</p> 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" /> 
					</div>
					<div class="divItemGrupo" id="spanDataFinal" style="width:150px;">
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

</form>