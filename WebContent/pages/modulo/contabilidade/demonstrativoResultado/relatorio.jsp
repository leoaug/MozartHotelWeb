<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
	$('#linhaMovimentoContabil').css('display','block');
	
	function fecharPopupHotel(){
		killModal();
	}
	

	function configurar(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="manterDemonstrativoResultado.action" namespace="/app/contabilidade" />';
		submitForm( vForm );
	}
	
	function cancelar(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
		submitForm( vForm );
	}
	
	
	function obterHotelSelecionado(){
		var qtde = $("input:checkbox[class='chkHotel'][checked='true']").length;
		var valor = '';
		for (x=0;x<qtde;x++){
				objChk = $("input:checkbox[class='chkHotel'][checked='true']").get(x);
				valor += objChk.value+',';
		}
		return valor==''?',<s:property value="#session.HOTEL_SESSION.idHotel"/>,':','+valor;
	}
	
	var reportAddress = '';

	/*
		ALTERAR AS QUERIES PARA PEGAR O ULTIMO DIA DA DATA FINAL
		LAST_DAY( TO_DATE($P{P_DATA_FINAL},'DD/MM/YYYY') )
	
	*/
	function imprimir(){
	
		var idRel = $("input[name='TIPO']:checked").val();
		var formato=$("input[name='FORMATO']:checked").val();
		reportAddress = '<s:property value="#session.URL_REPORT"/>';
		 if (1 == idRel){
	
		 
			 if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
					alerta("O campo 'Período' é obrigatório.");
					return false;	
			 }

			if ($('#dataFinal').val() == $('#dataInicial').val()){
				//relatorio de uma coluna
				reportAddress += '/index.jsp?REPORT=demoResultadoGeralMensalReport';
				reportAddress += '&FORMAT='+ formato;
			}else{
				//Colocar o crosstab aqui 
				reportAddress += '/index.jsp?REPORT=relDemonstrativoResultadoMesesReport';
				reportAddress += '&FORMAT='+ formato;
			}
			params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
			params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
			params += ';IDHS@'+obterHotelSelecionado();
			params += ';P_CNPJ@'+$('#cnpj').val();
			params += ';P_DATA@01/'+$('#dataInicial').val();
			params += ';P_DATA_FIM@01/'+$('#dataFinal').val();
			reportAddress += '&PARAMS='+params;
			showPopupGrande(reportAddress);

			 
	
		 }else if (2 == idRel){
	
			if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
				alerta("O campo 'Período' é obrigatório.");
				return false;	
			}
	
			reportAddress += '/index.jsp?REPORT=demoResultadoGeralMensalReport';
			reportAddress += '&FORMAT='+ formato;
			params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
			params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
			params += ';IDHS@'+obterHotelSelecionado();
			params += ';P_DATA@01/'+$('#dataInicial').val();
			params += ';P_DATA_FIM@01/'+$('#dataFinal').val();
			params += ';P_CCUSTO@'+$('#idCentroCusto').val();
			reportAddress += '&PARAMS='+params;
			showPopupGrande(reportAddress);
			
		}else if (3 == idRel){
			if ($('#dataInicial').val() == '' || $('#dataFinal').val() == ''){
				alerta("O campo 'Período' é obrigatório.");
				return false;	
			}
			reportAddress += '/index.jsp?REPORT=relDemonstrativoResultadoMesesReport';
			reportAddress += '&FORMAT='+ formato;
			params =  'IDH@<s:property value="#session.HOTEL_SESSION.idHotel"/>';
			params += ';IDRH@<s:property value="#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel"/>';
			params += ';IDHS@'+obterHotelSelecionado();
			params += ';P_DATA@01/'+$('#dataInicial').val();
			params += ';P_DATA_FIM@01/'+$('#dataFinal').val();
			params += ';P_DPTO@'+$('#idDepartamento').val();
			reportAddress += '&PARAMS='+params;
			showPopupGrande(reportAddress);
			return false;
	
		}	
	}



	$(document).ready(
			function(){
				    $(".radioTipo").click(
				            function() { 
				            	$('#divDataFinal').css('display','none');
								$('#divCentroCusto').css('display','none');
				            	$('#divDepartamento').css('display','none');

				            	if(this.value == '1'){

					            	$('#divDataFinal').css('display','block');
									$('#divCentroCusto').css('display','none');
					            	$('#divDepartamento').css('display','none');
				            		
				            	}else if(this.value == '2'){
					            	$('#divDataFinal').css('display','block');
									$('#divCentroCusto').css('display','block');
					            	$('#divDepartamento').css('display','none');

				            	}else if (this.value == '3') {
					            	$('#divDataFinal').css('display','block');
									$('#divCentroCusto').css('display','none');
					            	$('#divDepartamento').css('display','block');
				            	}								
				       }
			    );
		}
)
    
</script>

<s:form action="relatorioDemonstrativoResultado!prepararRelatorio.action" namespace="/app/contabilidade" theme="simple">
<div class="divFiltroPaiTop">Demonstrativo Resultado</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
        <s:if test="#session.USER_ADMIN eq 'TRUE'">
                <div class="divHoteis" id="divHoteis"   >
					<div class="divHoteisMenu" id="divHoteisMenu"> 
					 <img class="divHoteisMenuFiltro" title="Mostrar hotéis" src="imagens/menuHotelPrata.png" />
					</div>
					<div class="divHoteisCorpo" id="divHoteisCorpo">
				<s:iterator value="#session.USER_SESSION.usuarioEJB.redeHotelEJB.hoteis"
				var="hotel" status="idx">
				<s:if test="#session.HOTEL_SESSION.idHotel eq idHotel">
					<li style="color: blue;">
					
					<p style="color: blue;"><input id="idHotel" style="border: 0px;"
						name="idHotel" type="checkbox" class="chkHotel"
						value="<s:property value="idHotel" />" checked="checked" />
						<b><s:property value="#session.USER_SESSION.usuarioEJB.nick.equals(\"MANUTENCAO\")?redeHotelEJB.sigla+\" - \":\"\"" /></b>
						<s:property value="nomeFantasia" />
					</p>

					</li>
				</s:if> <s:else>
							
					<li>
					
					<p style="color: black;"><input id="idHotel" style="border: 0px;"
						name="idHotel" type="checkbox" class="chkHotel"
						value="<s:property value="idHotel" />" />
						<b><s:property value="#session.USER_SESSION.usuarioEJB.nick.equals(\"MANUTENCAO\")?redeHotelEJB.sigla+\" - \":\"\"" /></b>
						<s:property value="nomeFantasia" />
					</p>

					</li>
				</s:else> 

			</s:iterator>
            </div>
			</div>
		</s:if>
        
        
              <div class="divGrupo" style="<s:property value="#session.USER_ADMIN eq 'TRUE'?\"margin-left:25px;width:97%;\":\"\""/>height:200px;">
                <div class="divGrupoTitulo">Relatório</div>
                
                <div class="divLinhaCadastro" style="height:150px; border:1px solid black;">
                
                    <div class="divItemGrupo" style="width:350px;color:blue;" >
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="1" checked="checked"/>Demonstrativo de Resultado Geral<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="2"/>Demonstrativo de Resultado por Centro de Custo<br/>
						<input class="radioTipo"  type="radio" name="TIPO" id="TIPO" value="3"/>Demonstrativo de Resultado por Departamento<br/>
                    </div>
                </div>

              </div>

			 <div class="divGrupo" style="height:200px;">
					<div class="divGrupoTitulo">Opções</div>
				
				<div class="divLinhaCadastro" id="divPeriodo">
                    <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Período:</p> 
                          <input class="dpFMT" value='<s:property value="@com.mozart.model.util.MozartUtil@format(#session.CONTROLA_DATA_SESSION.contabilidade).substring(3)"/>' type="text" name="dataInicial" onblur="dataValida(this);" onkeypress="mascara(this,mesano);" id="dataInicial" size="8" maxlength="7" onchange="verificaRelatorio()" /> 
                   </div>       
                    <div class="divItemGrupo" id="divDataFinal" style="display:block" >
                          à 
                          <input class="dpFMT" value='<s:property value="@com.mozart.model.util.MozartUtil@format(#session.CONTROLA_DATA_SESSION.contabilidade).substring(3)"/>' type="text" name="dataFinal" onblur="dataValida(this);" onkeypress="mascara(this,mesano);" id="dataFinal" size="8" maxlength="7" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro" id="divCentroCusto" style="display:none">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Centro Custo:</p> 
                          <s:select cssStyle="width:200px" id="idCentroCusto" name="centroCusto" list="centroCustoList" headerKey="ALL" headerValue="Todos" listKey="idCentroCustoContabil" listValue="descricaoCentroCusto"/>
                   </div>       
                </div>
                
                
                <div class="divLinhaCadastro" id="divDepartamento" style="display:none">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Departamento:</p> 
                          <s:select cssStyle="width:150px" 
                          	name="idDepartamento" 
                          	id="idDepartamento" 
                            list="departamentoList" 
                            listKey="idDepartamento" 
                            listValue="descricao"/>
                   </div>       
                </div>
                
                <div class="divLinhaCadastro" id="divCnpj" style='display:<s:property value="#session.USER_ADMIN==\"TRUE\"?\"block\":\"none\" "/>'>
                    <div class="divItemGrupo" style="width:500px;"  ><p style="width:80px;">Por CNPJ:</p>
                    	<select name="cnpj" id="cnpj" style="width:200px;">
                    	<option value="ALL">Todos</option>
                    	<s:iterator value="#session.USER_SESSION.usuarioEJB.redeHotelEJB.hoteis" var="obj" status="row" >
                    	  <option value="<s:property value="cgc.substring(0,8)" />"> <s:property value="cgc.substring(0,8)+\"-\"+nomeFantasia" /> </option>  
                        </s:iterator>
                        </select>
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
                    <duques:botao label="Configurar" style="width:110px;" imagem="imagens/iconic/png/check-2x.png" onClick="configurar()" />
              </div>
              
        </div>
</div>

</s:form>