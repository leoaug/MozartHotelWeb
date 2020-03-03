<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

function cancelar(){
	vForm = document.forms[0];
	vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
	submitForm(vForm);
}

function tratarRetorno( valor ){
	if (valor == '1'){
		alerta ('Operação realizada com sucesso');
	}else{
		alerta ('Erro ao realizar operação');
	}
}


function imprimir(){
	
	var idTipo = $("input[name='TIPO']:checked").val();
	var aCupomFiscal = document.appletCupomFiscal;
	if (idTipo == "1"){

		if ( $("#dataInicial").val() == '' || $("#hora").val() == ''){
			alerta("Os campos 'Data e hora' são obrigatórios.");
			return false;
		}
	
		if (confirm('Confirma a Redução Z para essa data:' + $("#dataInicial").val() + ' e essa hora: ' + $("#hora").val())){
			try{
				var retorno = aCupomFiscal.reducaoZ("'"+$("#dataInicial").val()+"'","'"+$("#hora").val()+"'");
				tratarRetorno (retorno);
			}catch(err){
				alert(err.description);
			}		
		}

		
	}else if (idTipo == "2"){
		try{
			var retorno = aCupomFiscal.leituraX();
			tratarRetorno (retorno);
		}catch(err){
			alert(err.description);
		}		

	}else if (idTipo == "3"){

			try {
				var retorno = aCupomFiscal.verificaImpressoraLigada();
				tratarRetorno(retorno);
			} catch (err) {
				alert(err.description);
			}
		} else if (idTipo == "4") {
			if ($("#dataInicial2").val() == '' || $("#dataFinal2").val() == '') {
				alerta("O campo 'Período' é obrigatório.");
				return false;
			}

			try {
				var retorno = leituraFiscal("'" + $("#dataInicial2").val()
						+ "'", "'" + $("#dataFinal2").val() + "'");
				tratarRetorno(retorno);
			} catch (err) {
				alert(err.description);
			}
		} else if (idTipo == "5") {
			try {
				var retorno = leituraFiscalSerial("'"
						+ $("#dataInicial2").val() + "'", "'"
						+ $("#dataFinal2").val() + "'");
				tratarRetorno(retorno);
			} catch (err) {
				alert(err.description);
			}
		}

	}

	$(document).ready(function() {
		$(".radioTipo").click(function() {
			$('#divPeriodo').css('display', 'none');
			$('#divPeriodo2').css('display', 'none');

			if (this.value == '1') {
				$('#divPeriodo').css('display', 'block');
			} else if (this.value == '4' || this.value == '5') {
				$('#divPeriodo2').css('display', 'block');
			}
		});

	})
</script>

<!--Div applet cupom fiscal-->
<div id="divApplet" style="position: absolute; margin-left: 850px;float:right;margin-top:30px;">
<applet name="appletCupomFiscal" id="appletCupomFiscal" 
		code = 'com.mozart.applet.CupomFiscal' 
        archive = '<s:url value="/applet/sMozartHotelTelefonia.jar" />',
        width = '1', 
        height = '1'
        style="display:<s:property value="#session.HOTEL_SESSION.cupomfiscal == \"S\"?\"block\":\"none\" " />;" >
        <param name="TIPO_EXECUCAO" value="2"/>
</applet>
</div>
<!--Div applet cupom fiscal-->

<form>
<s:hidden id="origemCrs" name="origemCrs" />
<div class="divFiltroPaiTop">Configuração - CF</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:280px;">
                <div class="divGrupoTitulo">Comandos</div>
                
                <div class="divLinhaCadastro" style="height:180px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:250px;color:blue;" >
                    	<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="3" checked="checked" />Verifica comunicação<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="1" />Redução Z<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="2" />Leitura X<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="4" />Leitura Fiscal por Data<br/>
						<input class="radioTipo" type="radio" name="TIPO" id="TIPO" value="5" />Leitura Fiscal Serial por Data<br/>
                    </div>
                    
                </div>

              
              
              <div class="divLinhaCadastro" id="divPeriodo" style="display:none">
                
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Data:</p> 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial" size="8" maxlength="10" /> 
					</div>
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Hora:</p> 
                          <input value='' type="text" name="hora" onkeypress="mascara(this,hms);" id="hora" size="8" maxlength="10" /> 
					</div>
                
              </div>
              <div class="divLinhaCadastro" id="divPeriodo2" style="display:none">
                
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Período:</p> 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataInicial2" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataInicial2" size="8" maxlength="10" /> 
                          à 
                          <input class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>' type="text" name="dataFinal2" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataFinal2" size="8" maxlength="10" />
                    </div>
                    
                
              </div>
                
			</div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Executar" imagem="imagens/iconic/png/print-3x.png" onClick="imprimir()" />
              </div>
              
        </div>
</div>

</form>