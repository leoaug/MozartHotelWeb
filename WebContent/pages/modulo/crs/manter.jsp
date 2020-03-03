<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">


			$(function() {
			
				$.datepicker.setDefaults($.datepicker.regional['pt-BR']);
				
				$(".dp").datepicker({
					showOn: 'button',
					buttonImage: 'imagens/iconic/png/calendar-2x.png',
					buttonImageOnly: true,
					dateFormat: 'dd/mm/yy',
					numberOfMonths: [1,2]
					         		
				});
				
				
			});
			
            function cancelar(){

            }
            
            
            function pesquisar(){

            	if ($('#dataIn').val()=='' || $('#dataOut').val()==''){
					alerta("O campo 'Período' inválido");
					return false;
                }
            	if ($('#qtdePessoa').val()==''){
					alerta("O campo 'Qtde Pessoa' é obrigatório");
					return false;
                }

                submitForm(document.forms[0]);
                
            }

            function reservar(idHotel, idTarifa, tipoApto){

				if (idHotel == ''){
					alerta('Informe o Hotel');
					return false;
				} 

				if (idTarifa == ''){
					alerta('Informe a tarifa');
					return false;
				} 

				if (tipoApto == ''){
					alerta('Informe o tipo de apartamento');
					return false;
				} 

				
				vForm = document.forms[0];
				vForm.action = '<s:url action="manter!preparaManterCRS.action" namespace="/app/reserva" />';
				vForm.idHotelCRS.value = idHotel;
				vForm.idTarifaCRS.value = idTarifa;
				vForm.idTipoAptoCRS.value = tipoApto;
            	submitForm(vForm);
                
            }


            function mudarHotelCRS(objeto) {
                if(objeto.options[objeto.selectedIndex].value != ""){
	        		document.forms[0].action = '<s:url namespace="/app/crs" action="pesquisarCRS" method="prepararPesquisa" />';
	        		submitForm(document.forms[0]);
                }
        	}
			
            function pesquisarReserva(idHotel){

				if (idHotel == ''){
					alerta('Informe o Hotel');
					return false;
				} 

				vForm = document.forms[0];
				vForm.action = '<s:url action="pesquisar!prepararPesquisaCRS.action" namespace="/app/reserva" />';
				vForm.idHotelCRS.value = idHotel;
            	submitForm(vForm);
            }

	
        </script>


<s:form namespace="/app/crs" action="pesquisarCRS!pesquisar.action" theme="simple">
<s:hidden name="idHotelCRS" id="idHotelCRS" />
<s:hidden name="idTarifaCRS" id="idTarifaCRS" />
<s:hidden name="idTipoAptoCRS" id="idTipoAptoCRS" />

<div class="divFiltroPaiTop">Central de reservas</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:65px;">
                <div class="divGrupoTitulo">Filtro de pesquisa</div>
                
                <div class="divLinhaCadastro" style="height:40px;">
                    <div class="divItemGrupo" style="width:175px;" ><p style="width:100%;">Hotel:</p>
                        	<s:select list="#session.CRS_SESSION_NAME.hoteisAtivos"
                        			  name="filtroCRS.idHotel"
                        			  headerKey=""
                        			  headerValue="Todos"
                        			  listKey="idHotel"
                        			  listValue="nomeFantasia"
                        			  cssStyle="width:170px;" onchange="mudarHotelCRS(this)"/>
                    </div>
                    
                    <div class="divItemGrupo" style="width:155px;" ><p style="width:100%;">Cidade:</p>
                   		<s:select list="#session.CRS_SESSION_NAME.cidadesAtivas"
                       			  name="filtroCRS.idCidade"
                       			  headerKey=""
                       			  headerValue="Todas"
                       			  listKey="idCidade"
                       			  cssStyle="width:150px;"/>
                    </div>
                    
                    <div class="divItemGrupo" style="width:110px;" ><p style="width:100%;">Bairro:</p>
                   		<s:textfield name="filtroCRS.bairro" id="bairro" onblur="toUpperCase(this)" maxlength="30" size="15"/>
                    </div>
                    
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100%;">Período:</p>                                 
                                <s:textfield cssClass="dp" name="filtroCRS.dataEntrada" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataIn" size="8" maxlength="10" /> 
                                à 
                                <s:textfield cssClass="dp" name="filtroCRS.dataSaida" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataOut" size="8" maxlength="10" />
                    </div>

                    <div class="divItemGrupo" style="width:80px;" ><p style="width:100%;">Qtd Pessoa:</p>
                   		<s:textfield name="filtroCRS.qtdePessoa" id="qtdePessoa" onkeypress="mascara(this,numeros);" maxlength="2" size="3"/>
                    </div>

                    <div class="divItemGrupo" style="width:80px;" ><p style="width:100%;">Qtd Apto:</p>
                   		<s:textfield name="filtroCRS.qtdeApto" id="qtdeApto" onkeypress="mascara(this,numeros);" maxlength="2" size="3"/>
                    </div>

                    <div class="divItemGrupo" style="width:70px;" ><p style="width:100%;">Tarifa até:</p>
                   		<s:textfield name="filtroCRS.tarifaAte" id="tarifaAte" onkeypress="mascara(this,moeda);" maxlength="8" size="8"/>
                    </div>
                    
                    <div class="divItemGrupo" style="width:30px;" ><p style="width:100%;">&nbsp;</p>
                   		<img  src="imagens/iconic/png/magnifying-glass-3x.png" title="Pesquisar"  onclick="pesquisar();" />
                    </div>
                    
                </div>
                
                
              </div>

             <div class="divGrupo" style="height:430px;">
                <div class="divGrupoTitulo">Resultado</div>
				<div id="divMovimento" style="width: 99%; height: 400px; overflow-y: auto; margin:0px; padding:0px;">
					<s:iterator value="#session.listaPesquisa" var="hotelCorrente" >
						<div id="divHotel" style="width:100%; height:150px;">
							<div id="coluna01" class="divCrsHotelGrupo" style="width:58%; height:150px; float:left;">
								<div class="divCrsHotel" style="width:100%;height:18px;">
									<div class="divLinhaCadastro" >
										<div class="divItemGrupo" style="width:100%;" >
											
											<p style="width:100%;"><img src="imagens/iconic/png/magnifying-glass-3x.png" title="Detalhar hotel" /><s:property value="nomeFantasia"/></p>
										</div>
									</div>
												
									
								</div>
								
								<div id="divTarifa" class="divCrsHotel" style="width:100%;height:110px;background-color:white;float:left;margin-right:2px;overflow:auto;">
									<s:set name="objetoCorrente" value="" />
									<s:iterator value="tarifaHeader"  status="row" var="obj" >
									
										<s:if test="%{#objetoCorrente == null || #objetoCorrente.fantasia != fantasia}">
											<div class="divLinhaCadastro" style="height:30px;background-color: rgb(66, 198, 255);">
												<div class="divItemGrupo" style="width: 30px;">
													<p style="width:100%;color:white;">Tipo</p>
												</div>
												
										</s:if>
										
										<div class="divItemGrupo" style="width: 60px; margin:1px; text-align:center;">
											<p style="width:100%;color:white;float:left;"><s:property value="data.substring(0,5)"/></p>
											<p style="width:100%;color:white;float:left;"><s:property value="diaSemana"/></p>
										</div>
									
										<s:set name="objetoCorrente" value="obj" />
										<s:if test="#row.last">
												<div class="divItemGrupo" style="width: 50px; margin:1px; text-align:center;">
													<p style="width:100%;color:white;">&nbsp;</p>
												</div>
											</div>
										</s:if>
									
									</s:iterator>

								<s:set name="objetoCorrente" value="" />
								<s:iterator value="tarifa"  status="row" var="obj" >
									<s:if test="%{#objetoCorrente == null}">
										<div class="divLinhaCadastro">
											<div class="divItemGrupo" style="width: 30px;">
												<s:property value="fantasia"/>
											</div>
											
									</s:if>
									<s:elseif test="%{#objetoCorrente.fantasia != fantasia}">
											<div class="divItemGrupo" style="width: 50px; margin:1px; text-align:center;">
												<img src="imagens/iconic/png/magnifying-glass-3x.png" title="Pesquisar" onclick="pesquisarReserva('<s:property value="#hotelCorrente.idHotel"/>')" />
												<img src="imagens/atendente.png" title="Reservar" onclick="reservar('<s:property value="#hotelCorrente.idHotel"/>','<s:property value="#objetoCorrente.idTarifa"/>','<s:property value="#objetoCorrente.idTipoApto"/>')" />
											</div>
										
									
										</div>
										<div class="divLinhaCadastro">
											<div class="divItemGrupo" style="width: 30px;margin:1px;">
												<s:property value="fantasia"/>
											</div>
									</s:elseif>
									
									<div class="divItemGrupo" style="width: 60px; margin:1px; text-align:right;">
										<s:property value="percentual"/>
									</div>

									<s:set name="objetoCorrente" value="obj" />
									<s:if test="#row.last">
										<div class="divItemGrupo" style="width: 50px; margin:1px; text-align:center;">
												<img src="imagens/iconic/png/magnifying-glass-3x.png" title="Pesquisar" onclick="pesquisarReserva('<s:property value="#hotelCorrente.idHotel"/>')" />
												<img src="imagens/atendente.png" title="Reservar" onclick="reservar('<s:property value="#hotelCorrente.idHotel"/>','<s:property value="idTarifa"/>','<s:property value="idTipoApto"/>')" />
										</div>
										
									
										</div>
									</s:if>
								</s:iterator>
								


								</div>	
									
							</div>

							<div id="coluna02" class="divCrsHotelGrupo" style="width:41%; height:150px; float:left; overflow:auto;">
								<s:set name="objetoCorrente" value="" />
								<s:iterator value="disponibilidadeHeader"  status="row" var="obj" >
								
									<s:if test="%{#objetoCorrente == null || #objetoCorrente.data != data}">
										<div class="divLinhaCadastro" style="background-color: rgb(66, 198, 255);">
											<div class="divItemGrupo" style="width: 65px;">
												<p style="width:100%;color:white;">Data</p>
											</div>
											
									</s:if>
									
									<div class="divItemGrupo" style="width: 30px; margin:1px; text-align:center;">
										<p style="width:100%;color:white;"><s:property value="fantasia"/></p>
									</div>
								
									<s:set name="objetoCorrente" value="obj" />
									<s:if test="#row.last">
										<div class="divItemGrupo" style="width: 40px; margin:1px; text-align:center;">
											<p style="width:100%;color:white;">Total</p>
										</div>

										<div class="divItemGrupo" style="width: 40px; margin:1px; text-align:center;">
											<p style="width:100%;color:white;">%</p>
										</div>
									
									
										</div>
									</s:if>
								
								</s:iterator>

								<s:set name="objetoCorrente" value="" />

								<s:iterator value="disponibilidade"  status="row" var="obj" >
									<s:if test="%{#objetoCorrente == null}">
										<div class="divLinhaCadastro">
											<div class="divItemGrupo" style="width: 65px;">
												<s:property value="data"/>
											</div>
											
									</s:if>
									<s:elseif test="%{#objetoCorrente.data != data}">

										<div class="divItemGrupo" style="width: 40px; margin:1px; text-align:center; <s:property value='#objetoCorrente.totDia<=0?"background-color:red; color:white;": #objetoCorrente.totDia<=10?"background-color:yellow; color:black;":"background-color:green; color:white;"' />">
												<s:property value="#objetoCorrente.totDia"/>
										</div>

										<div class="divItemGrupo" style="width: 40px; margin:1px; text-align:center; <s:property value='#objetoCorrente.percentDia<=0?"background-color:red; color:white;": #objetoCorrente.percentDia<=10?"background-color:yellow; color:black;":"background-color:green; color:white;"' />">
												<s:property value="#objetoCorrente.percentDia"/>
											</div>
										
									
										</div>
										<div class="divLinhaCadastro">
											<div class="divItemGrupo" style="width: 65px;margin:1px;">
												<s:property value="data"/>
											</div>
											
									</s:elseif>
									
									<div class="divItemGrupo" style="width: 30px; margin:1px; text-align:center; <s:property value='valor<=0?"background-color:red; color:white;": valor<=10?"background-color:yellow; color:black;":"background-color:green; color:white;"' />">
										<s:property value="valor"/>
									</div>

									<s:set name="objetoCorrente" value="obj" />
													
									<s:if test="#row.last">
									
										<div class="divItemGrupo" style="width: 40px; margin:1px; text-align:center; <s:property value='#objetoCorrente.totDia<=0?"background-color:red; color:white;": #objetoCorrente.totDia<=10?"background-color:yellow; color:black;":"background-color:green; color:white;"' />">
											<s:property value="#objetoCorrente.totDia"/>
										</div>
									
									
										<div class="divItemGrupo" style="width: 40px; margin:1px; text-align:center; <s:property value='percentDia<=0?"background-color:red; color:white;": percentDia<=10?"background-color:yellow; color:black;":"background-color:green; color:white;"' />">
											<s:property value="percentDia"/>
										</div>
										
									
										</div>
									</s:if>
								</s:iterator>
		
							</div>
					
					
						</div>
					
					
					</s:iterator>
                </div>
              </div>
             
        </div>
</div>
</s:form>