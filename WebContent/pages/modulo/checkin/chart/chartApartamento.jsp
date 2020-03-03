<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
            	vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
            	submitForm( vForm );
            }

            function pesquisar(){
            	vForm = document.forms[0];
				loading();
				submitForm( vForm );
             }
            
</script>


<s:form namespace="/app/checkin" action="chart!pesquisarChart.action" theme="simple">

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
                <div id="divBodyDisp" style="width: 99%; height: 365px; overflow-y: auto; margin:0px; padding:0px;">
					<div id="divOver" style="width:500%;">	
					
						<s:iterator value="chartDatasList" var="dataCorrente" status="row" >
								<s:if test="#row.first">
									<div class="divLinhaCadastro" style="height:15px;background: white;">
										<div class="divItemGrupo" style="heignt:15px; width: 55px;color: white;background: rgb(49, 115, 255);">
											&nbsp;
										</div>
								</s:if>
								<div class="divItemGrupo" style="width: 40px;text-align:center;color: white;background: rgb(49, 115, 255);">
									<s:property value="top.date"/>/<s:property value="((top.month)+1)"/>
								</div>
								<s:if test="#row.last">
									</div>
								</s:if>
						
						
						</s:iterator>
					
						<s:set name="objetoCorrente" value="" />
						<s:iterator value="chartApartamentoList" var="mapaCorrente" status="row" >
						
								<s:if test="%{#objetoCorrente == null}">
									<div class="divLinhaCadastro" style="background: white;">
										<div class="divItemGrupo" style="width: 55px;color: white;background: rgb(49, 115, 255);">
											<s:property value="numApartamento"/>
										</div>
									
								</s:if>
								<s:elseif test="%{!#objetoCorrente.numApartamento.equals(numApartamento)}">
									</div>
									
									<div class="divLinhaCadastro" style="background: white;">
										<div class="divItemGrupo" style="width: 55px;color:white;background: rgb(49, 115, 255);">
											<s:property value="numApartamento"/>
										</div>
								</s:elseif>
						
									<div class="divItemGrupo" style="width: 40px;text-align:center;">
										<s:if test="%{status == 0}">
											<img src="imagens/imgDisponivel.png" title="Livre" />
										</s:if>
										<s:elseif test="%{status == 1}">
											<img src="imagens/imgAtencao.png" title="Reservado" />
										</s:elseif>
										<s:elseif test="%{status == 2}">
											<img src="imagens/imgOcupado.png" title="Ocupado" />
										</s:elseif>
										<s:elseif test="%{status == 3}">
											<img src="imagens/imgOcupadoReservado.png" title="Saída e reserva no dia" />
										</s:elseif>
										<s:elseif test="%{status == 4}">
											<img src="imagens/imgReservadoReservado.png" title="Reservas de saída e entrada no mesmo dia" />
										</s:elseif>
										<s:elseif test="%{status == 9}">
											<img src="imagens/btnInformacaoCinza.png" title="Interditado" />
										</s:elseif>
									</div>
								<s:set name="objetoCorrente" value="mapaCorrente" />	
								<s:if test="#row.last">
									</div>
									
								</s:if>
						
						</s:iterator>
					</div>
				</div>
              </div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
              </div>
              
        </div>
</div>
</s:form>