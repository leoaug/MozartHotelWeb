<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<link rel="stylesheet" type="text/css" href="js/autocomplete/jquery.autocomplete.css" />
<script src="js/autocomplete/jquery.autocomplete.js" type='text/javascript'></script>

<script type="text/javascript"> 

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarMiniPDV!prepararPesquisa.action" namespace="/app/caixa" />';
	submitForm(vForm);
}

$(document).ready(function() {
	$("#idChekin").autocomplete("${sessionScope.URL_BASE}app/ajax/ajax!pesquisarChekinPorApartamentoOuHospedeLike");
});

var reportAddress = '';
var logoHotel = '';
var logoMozart = '';
var subReportDir = '';
var idHotel = '';
function imprimir(){


	if ( $("input[name='checkin']").val() == '') {
		alerta('Campo "Hóspede" é obrigatório.');
		return false;
	}
	
	var idRel = $("input[name='TIPO']").val();
	var checkin = $("input[name='checkin']").val();
	reportAddress = '<s:property value="#session.URL_REPORT"/>';
	logoHotel = '<s:property value="#session.LOGO_HOTEL"/>';
	logoMozart = '<s:property value="#session.LOGO_MOZART"/>';
	subReportDir = '<s:property value="#session.SUBREPORT_DIR"/>';
	var formato=$("input[name='FORMATO']:checked").val();
	if (1 == idRel){

		var idCheckin = checkin.substring(0, checkin.indexOf('-'))

		
		reportAddress += '/index.jsp?REPORT=cxExtratoPdvReport';
		reportAddress += '&FORMAT='+ formato;
		params =  'ID_CHECKIN@' + idCheckin;
		params += ';IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
		params += ';LOGO_HOTEL@' + logoHotel ;
		params += ';LOGO_MOZART@' + logoMozart;
		params += ';SUBREPORT_DIR@' + subReportDir;
		params += ';NOME_HOTEL@<s:property value="#session.NOME_HOTEL_SESSION.nomeFantasia"/>';

		reportAddress += '&PARAMS='+params;	
		
		showPopupGrande(reportAddress);
	}
}



	
</script>



<s:form action="pesquisar!prepararPesquisa.action" namespace="/app/pdv" theme="simple">
<s:hidden id="origemCrs" name="origemCrs" />
<div class="divFiltroPaiTop">Relatório</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:280px;">
                <div class="divGrupoTitulo">Tipos de relatório</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" />Nota de simples conferência<br/>		
                    </div>
                   
                </div>

                <div class="divLinhaCadastro" id="divPeriodo">
                
                    <div class="divItemGrupo" style="width:600px;" >
                    	<p style="width:80px;">Hóspede:</p> 

						<s:textfield name="checkin" placeholder="Ex: Digitar Apartamento ou nome do hóspede"
	                        				 id="idChekin"  
	                        				 size="65"   
	                        				 />					
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