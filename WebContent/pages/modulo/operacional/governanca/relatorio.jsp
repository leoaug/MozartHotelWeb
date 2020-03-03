<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
	submitForm(vForm);
}


var reportAddress = '';
function imprimir(){

	var idRel = $("input[name='TIPO']:checked").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
	if (1 == idRel){
		reportAddress += '/index.jsp?REPORT=geralPorAptoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params +=  ';TIPO@1';
		params +=  ';COFAN@' + $('#cofan').val();;
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (2 == idRel){
		reportAddress += '/index.jsp?REPORT=geralPorAptoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params +=  ';TIPO@2';
		params +=  ';COFAN@' + $('#cofan').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (3 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=avisodeEntradaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_TIPO@E';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();

		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}else if (4 == idRel){
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=avisoSaidaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
	
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	}else if (5 == idRel){
		reportAddress += '/index.jsp?REPORT=aptoPorAreaReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_TIPO@'+$('#detalhadoPor').val();
		params += ';AREA@'+($('#detalhadoPor').val() == 'A'?$('#areaCamareira').val():'');
		params += ';CAMAREIRA@'+($('#detalhadoPor').val() == 'C'?$('#areaCamareira').val():'');
		params += ';STATUS@'+$('#status').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);
	}


}

	function obterCamareira(){
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarCamareira';
		preencherCombo('areaCamareira', url); 
	}

	function obterArea(){
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarArea';
		preencherCombo('areaCamareira', url); 
	}

	function carregarCombo(id){
             if (id == 'A'){
				$('#idLabelCombo').text('Área');
				obterArea();
           }else{
           		$('#idLabelCombo').text('Camareira');
           		obterCamareira();
         }
	}

$(document).ready(
		function(){
			    $(".radioTipo").click(
			            function() { 
			            	$('#spanDataFinal').css('display','none');
			            	$('#divCofan').css('display','none');
			            	$('#divPorArea').css('display','none');
			            	$('#divPeriodo').css('display','block');

			                if (this.value == '5'){
								$('#divPorArea').css('display','block');
								$('#divPeriodo').css('display','none');
								$('#divCofan').css('display','none');
								obterArea();

			                }
			                
			                if (this.value == '1' || this.value == '2'){
								$('#divCofan').css('display','block');
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
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" checked="checked"/>Geral por apartamento<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="2" />Geral por hóspede<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="3" />Aviso de entrada<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="4" />Aviso de saída<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="5" />Hóspede por área<br/>
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
                
                <div class="divLinhaCadastro" id="divCofan">
                
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Cofan:</p> 
						<select name="cofan" id="cofan">
							<option value="ALL" >Todos</option>
							<option value="S">Sim</option>
							<option value="N" selected="selected">Não</option>
						</select>	
					</div>
                
                </div>

                <div class="divLinhaCadastro" id="divPorArea" style="display:none;">
                
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Por:</p> 
						<select name="detalhadoPor" id="detalhadoPor" onchange="carregarCombo(this.value)">
							<option value="A" selected="selected">Área</option>
							<option value="C">Camareira</option>
						</select>	
					</div>

                    
                    <div class="divItemGrupo" style="width:350px;" ><p id="idLabelCombo" style="width:80px;">Área:</p> 
						<select name="areaCamareira" id="areaCamareira" style="width:250px;">
						</select>	
					</div>

                    <div class="divItemGrupo" style="width:250px;" ><p id="idLabelCombo" style="width:80px;">Status:</p> 
						<select name="status" id="status" style="width:150px;">
							<option value="ALL" selected="selected">Todos</option>
							<option value="L">Livres</option>
							<option value="O">Ocupados</option>
							<option value="I">Interditados</option>

						</select>	
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