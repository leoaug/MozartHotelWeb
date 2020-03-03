<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){

				vForm = document.forms[0];
				vForm.action = '<s:url action="pesquisar!prepararPesquisa.action" namespace="/app/bloqueio" />';
            	submitForm(vForm);

            	
            }
            
            
            function pesquisar(){

            	if ($('#dataIn').val()=='' || $('#dataOut').val()==''){
					alerta("O campo 'Período' inválido");
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
				vForm.action = '<s:url action="manter!pesquisarMapa.action" namespace="/app/bloqueio" />';
				vForm.idHotelCRS.value = idHotel;
				vForm.idTarifaCRS.value = idTarifa;
				vForm.idTipoAptoCRS.value = tipoApto;
            	submitForm(vForm);
                
            }


	
        </script>


<s:form namespace="/app/bloqueio" action="manterMapa!pesquisarMapa.action" theme="simple">
<s:hidden id="origemCrs" name="origemCrs" />

<div class="divFiltroPaiTop">Chart Reservas</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:45px;">
                <div class="divGrupoTitulo">Filtro de pesquisa</div>
                
                <div class="divLinhaCadastro" >
                    
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100px;">Período:</p>                                 
                                <s:textfield cssClass="dp" name="filtroMapa.dataEntrada" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataIn" size="8" maxlength="10" /> 
                                à 
                                <s:textfield cssClass="dp" name="filtroMapa.dataSaida" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="dataOut" size="8" maxlength="10" />
                    </div>

 					<div class="divItemGrupo" style="width:150px;" ><p style="width:70px;">Bloqueio:</p>
                    	<s:select list="#session.LISTA_CONFIRMACAO" 
                    			  listKey="id"
								  listValue="value" cssStyle="width:50px;"
								  name="filtroMapa.bloqueio" />                               
                    </div>
                                        
                    <div class="divItemGrupo" style="width:30px;" >
                   		<img  src="imagens/iconic/png/magnifying-glass-3x.png" title="Pesquisar"  onclick="pesquisar();" />
                    </div>
                    
                </div>
                
                
              </div>

             <div class="divGrupo" style="height:390px;">
                <div class="divGrupoTitulo">Resultado</div>
				<div id="divMovimento" style="width: 99%; height: 360px; overflow-y: auto; margin:0px; padding:0px; background-color:white;">
				
					<div id="colunaDados" style="width: 970px; height: 359px; margin:0px; padding:0px;  float:left; overflow:auto">					
					<div id="colunaDadosBody" style="width: 250%; height: 350px; margin:0px; padding:0px;  float:left;">		
					
					<s:set name="objetoCorrente" value="" />
					<s:set name="podeEntrar" value="%{'true'}" />
					<s:set name="fantasias" value="%{''}" />
					<s:iterator value="#session.listaPesquisa" var="mapaCorrente" status="row" >
						
							<s:if test="%{#podeEntrar == 'true'}">
								<s:if test="%{#objetoCorrente == null}">
									<div id="coluna00" style="width: 130px; height: 360px; margin:0px; padding:0px; background-color:white; float:left; ">
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
												&nbsp;
											</div>
										</div>
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
												Dia da semana
											</div>
										</div>
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
												Total de aptos
											</div>
										</div>
										
										<div class="divLinhaCadastro" style="height:12px; ">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
												&nbsp;
											</div>
										</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
												% disponível
											</div>
										</div>	
									
								</s:if>
							
								<s:if test="%{#objetoCorrente == null || #objetoCorrente.data == data }">							
									<s:set name="fantasias" value="%{#fantasias + fantasia+ ';'}" />
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											<s:property value="fantasia" />
										</div>
									</div>								
							    </s:if>
								
								
							</s:if>
							<s:if test="%{#objetoCorrente.data != data }">
									<s:set name="podeEntrar" value="%{'false'}" />
							</s:if>
							<s:set name="objetoCorrente" value="mapaCorrente" />		
								
							<s:if test="#row.last">
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
												Qtde disponível
											</div>
									</div>								
									
										<div class="divLinhaCadastro" style="height:12px;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											&nbsp;
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											A confirmar do dia
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											Entradas do dia
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											Bloqueios
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											Total interditados
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											Total no-show
										</div>
									</div>								
									
										<div class="divLinhaCadastro" style="height:12px; ">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											&nbsp;
										</div>
									</div>
									
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											Qtde Hóspede
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											Qtde Crianças
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											Qtde Café
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											Qtde MAP
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											Qtde FAP
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											Qtde ALL
										</div>
									</div>			
									
										<div class="divLinhaCadastro" style="height:12px;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											&nbsp;
										</div>
									</div>
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											% ocupação
										</div>
									</div>			
									
									<s:iterator value="#fantasias.split(';')">
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
												<s:property/>
											</div>
										</div>	
									
									</s:iterator>

									
									
									
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 120px;color: rgb(148, 0, 0);">
											Qtde ocupados
										</div>
									</div>			
							</div>
												
									
								</s:if>
					
					</s:iterator>
					
					<!-- inicio da coluna de dados-->
								
					<s:set name="fantasias" value="%{''}" />
					<s:set name="objetoCorrente" value="" />
					<s:iterator value="#session.listaPesquisa" var="mapaCorrente" status="row" >
						
								<s:if test="%{#objetoCorrente == null}">
									<div id="coluna01" style="width: 50px; height: 830px; margin:0px; padding:0px; float:left">
									
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 100%;color: rgb(148, 0, 0);text-align:center;">
												<s:property value="dia" />
											</div>
										</div>
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
												<s:property value="diaSemana" />
											</div>
										</div>
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
												<s:property value="qtdeApto" />
											</div>
										</div>
										
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
												&nbsp;
											</div>
										</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style='width: 100%;text-align:center;<s:property value="qtdeAptoDisponivelGeralPercentual>=10?'background-color:#99D699;color:green;':qtdeAptoDisponivelGeralPercentual>0?'background-color:#FFFF99;':'background-color:#FF9999;color:red;'" />'>
												<s:property value="qtdeAptoDisponivelGeralPercentual" />
											</div>
										</div>								
									
								</s:if>
								
								
								<s:elseif test="%{data != #objetoCorrente.data}">
									
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style='width: 100%;text-align:center;<s:property value="#objetoCorrente.qtdeAptoDisponivelGeralPercentual<=0?'background-color:#FF9999;color:red;':#objetoCorrente.qtdeAptoDisponivelGeralPercentual<=50?'background-color:#FFFF99;':'background-color:#99D699;color:green;'" />'>
												<s:property value="#objetoCorrente.qtdeAptoDisponivelGeral" /> 
											</div>
									</div>								
									
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											&nbsp;
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeNaoConfirmadas" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeConfirmadas" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeBloqueio" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeInterditado" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeNoShow" />
										</div>
									</div>								
									
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											&nbsp;
										</div>
									</div>
									
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeHospede" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeCrianca" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeCafe" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeMap" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeFap" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeAll" />
										</div>
									</div>			
									
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											&nbsp;
										</div>
									</div>
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style='width: 100%;text-align:center;<s:property value="#objetoCorrente.qtdeAptoOcupadoGeralPercentual>=90?'background-color:#FF9999;color:red;':#objetoCorrente.qtdeAptoOcupadoGeralPercentual>50?'background-color:#FFFF99;':'background-color:#99D699;color:green;'" />'>
											<s:property value="#objetoCorrente.qtdeAptoOcupadoGeralPercentual" />
											
										</div>
									</div>			
									
									<s:iterator value="#fantasias.split(';')" var="ocup">
										<s:set name="ocupado" value="top.substring(0, top.indexOf('*'))" />
										<s:set name="total" value="top.substring(top.indexOf('*')+1)" />
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style='width: 100%;text-align:center;<s:property value="#ocupado*100/#total>=100?'background-color:#FF9999;color:red;':#ocupado*100/#total>=50?'background-color:#FFFF99;':'background-color:#99D699;color:green;'" />'>
												<s:property value="#ocupado"/>
											</div>
										</div>	
									
									</s:iterator>
									<s:set name="fantasias" value="%{''}" />
									
									
									
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeAptoOcupadoGeral" />
										</div>
									</div>			
								</div>
								
								<div id="coluna01" style="width: 50px; height: 830px; margin:0px; padding:0px;float:left">
									
										<div class="divLinhaCadastro" style="height:12px; background-color:silver;">
											<div class="divItemGrupo" style="width: 100%;color: rgb(148, 0, 0);text-align:center;">
												<s:property value="dia" />
											</div>
										</div>
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
												<s:property value="diaSemana" />
											</div>
										</div>
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
												<s:property value="qtdeApto" />
											</div>
										</div>
										
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
												&nbsp;
											</div>
										</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style='width: 100%;text-align:center;<s:property value="qtdeAptoDisponivelGeralPercentual>=50?'background-color:#99D699;color:green;':qtdeAptoDisponivelGeralPercentual>0?'background-color:#FFFF99;':'background-color:#FF9999;color:red;'" />'>
												<s:property value="qtdeAptoDisponivelGeralPercentual" />
											</div>
										</div>		
								
								</s:elseif>
								<s:set name="fantasias" value="%{#fantasias + qtdeAptoOcupado+'*'+qtdeTipoApto+';'}" />
								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
										<div class="divItemGrupo" style='width: 100%;text-align:center;<s:property value="qtdeAptoDisponivel*100/qtdeTipoApto<=0?'background-color:#FF9999;color:red;':qtdeAptoDisponivel*100/qtdeTipoApto<=50?'background-color:#FFFF99;':'background-color:#99D699;color:green;'" />'>
										<s:property value="qtdeAptoDisponivel" />
									</div>
								</div>								
							

								<s:set name="objetoCorrente" value="mapaCorrente" />		
								
								<s:if test="#row.last">
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style='width: 100%;text-align:center;<s:property value="#objetoCorrente.qtdeAptoDisponivelGeralPercentual<=0?'background-color:#FF9999;color:red;':#objetoCorrente.qtdeAptoDisponivelGeralPercentual<=50?'background-color:#FFFF99;':'background-color:#99D699;color:green;'" />'>
												<s:property value="#objetoCorrente.qtdeAptoDisponivelGeral" />
											</div>
									</div>								
									
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											&nbsp;
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeNaoConfirmadas" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeConfirmadas" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeBloqueio" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeInterditado" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeNoShow" />
										</div>
									</div>								
									
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											&nbsp;
										</div>
									</div>
									
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeHospede" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeCrianca" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeCafe" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeMap" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeFap" />
										</div>
									</div>								
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeAll" />
										</div>
									</div>			
									
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											&nbsp;
										</div>
									</div>
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
										<div class="divItemGrupo" style='width: 100%;text-align:center;<s:property value="#objetoCorrente.qtdeAptoOcupadoGeralPercentual>=90?'background-color:#FF9999;color:red;':#objetoCorrente.qtdeAptoOcupadoGeralPercentual>50?'background-color:#FFFF99;':'background-color:#99D699;color:green;'" />'>
											<s:property value="#objetoCorrente.qtdeAptoOcupadoGeralPercentual" />
											
										</div>
									</div>			
									
									<s:iterator value="#fantasias.split(';')" var="ocup">
										<s:set name="ocupado" value="top.substring(0, top.indexOf('*'))" />
										<s:set name="total" value="top.substring(top.indexOf('*')+1)" />
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style='width: 100%;text-align:center;<s:property value="#ocupado*100/#total>=100?'background-color:#FF9999;color:red;':#ocupado*100/#total>=50?'background-color:#FFFF99;':'background-color:#99D699;color:green;'" />'>
												<s:property value="#ocupado"/>
											</div>
										</div>	
									
									</s:iterator>

									<s:set name="fantasias" value="%{''}" />
									
									
									
										<div class="divLinhaCadastro" style="height:12px; background-color:white;">
											<div class="divItemGrupo" style="width: 100%;text-align:center;">
											<s:property value="#objetoCorrente.qtdeAptoOcupadoGeral" />
										</div>
									</div>			
								</div>	
									
								

								</s:if>
							
					</s:iterator>

					
					</div>
					</div>
					<!-- fim da coluna de dados-->
					
                </div>
              </div>
			  
				<div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar();" />
                </div>

             
        </div>
</div>
</s:form>