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


	if (idRel == "1"){
		reportAddress = '<s:property value="#session.URL_REPORT"/>';
		if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		reportAddress += '/index.jsp?REPORT=percentualDeOcupacaoReport';
		params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
		params += ';P_DATA@'+$('#dataInicial').val();
		params += ';P_DATA_FIM@'+$('#dataFinal').val();
		reportAddress += '&PARAMS='+params;
		showPopupGrande(reportAddress);

	}else if (idRel == "2"){

		if ($('#ateDia').val() == ''){
			alerta("O campo 'Até dia' é obrigatório.");
			return false;	
		}
		if ($('#anoInicial').val() == '' || $('#anoFinal').val() == ''){
			alerta("O campo 'Período' é obrigatório.");
			return false;	
		}
		loading();
		var url_ = 'app/ajax/ajax!prepararRelatorioRDSAnual?ateDia='+$('#ateDia').val()+'&ateMes='+$('#ateMes').val()+'&anoInicial='+$('#anoInicial').val()+'&anoFinal='+$('#anoFinal').val();
        getAjaxValue(url_, abrirRDSAnual);
		//submitFormAjax(url_,true);

	}
}


function abrirRDSAnual(){
	killModal();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
	reportAddress += '/index.jsp?REPORT=rdsAnualReport';
	params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
	params += ';P_ATE_DIA@'+$('#ateDia').val();
	params += ';P_ATE_MES@'+$('#ateMes').val();

	reportAddress += '&PARAMS='+params;
	showPopupGrande(reportAddress);

}


$(document).ready(
		function(){
			    $(".radioTipo").click(
			            function() { 
			            	$('#divPeriodo').css('display','none');
			            	$('#divRDSAnual').css('display','none');
			                if (this.value == '1'){
								$('#divPeriodo').css('display','block');
			                }else if (this.value == '2'){

								$('#divRDSAnual').css('display','block');
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
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" checked="checked" />Percentual de ocupação<br/>
                    </div>
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="2"  />RDS anual<br/>
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

                <div class="divLinhaCadastro" id="divRDSAnual" style="display:none">
                
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Até o dia:</p> 
                          <input type="text" name="ateDia" onkeypress="mascara(this,numeros);" id="ateDia" size="5" maxlength="2" value="31" /> 
					</div>
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Até o mês:</p> 
                          <select name="ateMes" id="ateMes" style="width:95px;">
                          	<option value="1">janeiro</option>
                          	<option value="2">fevereiro</option>
                          	<option value="3">março</option>
                          	<option value="4">abril</option>
                          	<option value="5">maio</option>
                          	<option value="6">junho</option>
                          	<option value="7">julho</option>
                          	<option value="8">agosto</option>
                          	<option value="9">setembro</option>
                          	<option value="10">outubro</option>
                          	<option value="11">novembro</option>
                          	<option value="12" selected="selected">dezembro</option>
                          </select> 
					</div>
                    <div class="divItemGrupo" style="width:250px;" >
                    	<p style="width:80px;">Período:</p> 
                        <input type="text" name="anoInicial" onkeypress="mascara(this,numeros);" id="anoInicial" size="5" maxlength="4" />&nbsp;até&nbsp;
                        <input type="text" name="anoFinal" onkeypress="mascara(this,numeros);" id="anoFinal" size="5" maxlength="4" />  
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