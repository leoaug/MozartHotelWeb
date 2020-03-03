<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	window.close();
            }

            function pesquisar(){
            	vForm = document.forms[0];
				loading();
				submitForm( vForm );
             }
            
            function novaReserva(idApto, dataEntrada, idTipoApartamento){            
				window.opener.novaReserva(idApto, dataEntrada, idTipoApartamento);            
            }
            
            
        	$(document).ready(function() {
				$('.myTable01').fixedHeaderTable({ width: '950', height: '350', themeClass: 'fancyTable', fixedColumn: true });   
				$('.myTable01').fixedHeaderTable('show');
				$('.myTable01').css('visibility','visible');
				window.opener.killModal();
				
			});
            
</script>


<s:form namespace="/app/checkin" action="popupChart!pesquisarChart.action" theme="simple">

<div class="divFiltroPaiTop">Chart Apartamento </div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:50px; width:68%">
                <div class="divGrupoTitulo">Filtro</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:310px;" ><p style="width:80px;">Período:</p>                                 
                                <s:textfield cssClass="dp" name="chartDataEntrada" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="chartDataEntrada" size="8" maxlength="10" /> 
                                à 
                                <s:textfield cssClass="dp" name="chartDataSaida" onblur="dataValida(this);" onkeypress="mascara(this,data);" id="chartDataSaida" size="8" maxlength="10" />
                    </div>
                    <div class="divItemGrupo" style="width:30px;" >
                   		<img  src="imagens/iconic/png/magnifying-glass-3x.png" title="Pesquisar"  onclick="pesquisar();" />
                    </div>
                    
                </div>
              </div>

			  <div class="divGrupo" style="height:50px; width:30%">
                <div class="divGrupoTitulo">Legenda</div>
                <div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 30px;text-align:center;">
						<img src="imagens/imgDisponivel.png" title="Livre" />
					</div>
					<div class="divItemGrupo" style="width: 30px;text-align:center;">
						<img src="imagens/imgAtencao.png" title="Reservado" />
					</div>
					<div class="divItemGrupo" style="width: 30px;text-align:center;">
						<img src="imagens/imgReservadoReservado.png" title="Reservas de saída e entrada no mesmo dia" />
					</div>
					<div class="divItemGrupo" style="width: 30px;text-align:center;">
						<img src="imagens/imgReservadoLivre.png" title="Reservas de saída e livre no mesmo dia" />
					</div>					
					<div class="divItemGrupo" style="width: 30px;text-align:center;">
						<img src="imagens/imgLivreReservado.png" title="Reservas com entrada no dia" />
					</div>					
					<div class="divItemGrupo" style="width: 30px;text-align:center;">
						<img src="imagens/imgOcupado.png" title="Ocupado" />
					</div>
					<div class="divItemGrupo" style="width: 30px;text-align:center;">
						<img src="imagens/imgOcupadoReservado.png" title="Saída e reserva no dia" />
					</div>
					<div class="divItemGrupo" style="width: 30px;text-align:center;">
						<img src="imagens/btnInformacaoCinza.png" title="Interditado" />
					</div> 
                </div>
              </div>
			  
              <div class="divGrupo" style="height:390px;">
                <div class="divGrupoTitulo">Resultado</div>
                <!--div id="divBodyDisp" style="width: 99%; height: 365px; overflow-y: auto; margin:0px; padding:0px;"-->
                 <table class="myTable01" cellpadding="0" cellspacing="0" style="visibility:hidden; marging-left:2px;">
					<thead>
						<s:iterator value="chartDatasList" var="dataCorrente" status="row" >
									<s:if test="#row.first">
										<tr>
											<th style="width: 50px;text-align:center;color: white;background-color: rgb(49, 115, 255);">
												&nbsp;Apto
											</th>
									</s:if>
									<th style="width: 40px;text-align:center;color: white;background-color: rgb(49, 115, 255);">
										<s:property value="top.date"/>/<s:property value="((top.month)+1)"/>
									</th>
									<s:if test="#row.last">
										</tr>									
									</s:if>
							
							
						</s:iterator>
					</thead>
            <tbody>
				
						<s:set name="objetoCorrente" value="" />
						<s:iterator value="chartApartamentoList" var="mapaCorrente" status="row" >
						
								<s:if test="%{#objetoCorrente == null}">
									<tr>
										<td style="color: white;background:rgb(49, 115, 255);">
											<s:property value="numApartamento"/>-<s:property value="tipoApartamento"/> 
										</td>
									
								</s:if>
								<s:elseif test="%{!#objetoCorrente.numApartamento.equals(numApartamento)}">
									</tr>
									
									<tr style="background: white;">
										<td style="color:white;background:rgb(49, 115, 255);">
											<s:property value="numApartamento"/>-<s:property value="tipoApartamento"/>
										</td>
								</s:elseif>
						
									<td style="text-align:center;background-color:<s:property value="#mapaCorrente.finalSemana?\"silver\":\"white\""/>;">
										<s:if test="%{status == 0}">
											<img src="imagens/imgDisponivel.png" title="Livre" onclick="novaReserva('<s:property value="#mapaCorrente.idApartamento"/>','<s:property value="#mapaCorrente.dia"/>','<s:property value="#mapaCorrente.idTipoApartamento"/>');" />
										</s:if>
										<s:elseif test="%{status == 1}">
											<img src="imagens/imgAtencao.png" title="<s:property value="#mapaCorrente.observacao"/>" />
										</s:elseif>
										<s:elseif test="%{status == 2}">
											<img src="imagens/imgOcupado.png" title="<s:property value="#mapaCorrente.observacao"/>" />
										</s:elseif>
										<s:elseif test="%{status == 3}">
											<img src="imagens/imgOcupadoReservado.png" title="<s:property value="#mapaCorrente.observacao"/>" />
										</s:elseif>
										<s:elseif test="%{status == 4}">
											<img src="imagens/imgReservadoReservado.png" title="<s:property value="#mapaCorrente.observacao"/>" />
										</s:elseif>
										<s:elseif test="%{status == 5}">
											<img src="imagens/imgReservadoLivre.png" title="<s:property value="#mapaCorrente.observacao"/>" onclick="novaReserva('<s:property value="#mapaCorrente.idApartamento"/>','<s:property value="#mapaCorrente.dia"/>','<s:property value="#mapaCorrente.idTipoApartamento"/>');" />
										</s:elseif>
										<s:elseif test="%{status == 6}">
											<img src="imagens/imgLivreReservado.png" title="<s:property value="#mapaCorrente.observacao"/>"  />
										</s:elseif>
										<s:elseif test="%{status == 9}">
											<img src="imagens/btnInformacaoCinza.png" title="<s:property value="#mapaCorrente.observacao"/>" />
										</s:elseif>
									</td>
								<s:set name="objetoCorrente" value="mapaCorrente" />	
								<s:if test="#row.last">
									</tr>
								</s:if>						
						</s:iterator>
            </tbody>
        </table>        
					
				<!--/div-->
              </div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
              </div>
              
        </div>
</div>
</s:form>