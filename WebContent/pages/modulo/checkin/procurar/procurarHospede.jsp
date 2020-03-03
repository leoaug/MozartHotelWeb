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

				if ($('#procurarPor').val() == ''){
					alerta("O campo 'Procurar por:' é obrigatório.");	
					return false;	
				}
                
            	vForm = document.forms[0];
				loading();
				submitForm( vForm );
             }
            
</script>


<s:form namespace="/app/checkin" action="procurarHospede!procurarHospede.action" theme="simple">

<div class="divFiltroPaiTop">Procurar hóspede </div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:50px; width:68%">
                <div class="divGrupoTitulo">Filtro</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Procurar por:</p>                                 
                                <s:textfield name="procurarPor" onblur="toUpperCase(this)" id="procurarPor" size="40" maxlength="50" /> 
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
						<img src="imagens/imgDisponivel.png" title="Check-in efetuado" />
					</div>
					<div class="divItemGrupo" style="width: 30px;text-align:center;">
						<img src="imagens/imgOcupado.png" title="Check-out efetuado" />
					</div>
					<div class="divItemGrupo" style="width: 30px;text-align:center;">
						<img src="imagens/imgLegAmarelo.png" title="Check-in previsto" />
					</div>
                </div>
              </div>
			  
              <div class="divGrupo" style="height:390px;">
                <div class="divGrupoTitulo">Resultado</div>
                <div id="divBodyDisp" style="width: 99%; height: 365px; overflow-y: auto; margin:0px; padding:0px;">
	
					
						
					<div class="divLinhaCadastro" style="height:15px;background: white;">
							<div class="divItemGrupo" style="width: 55px;color: white;background: rgb(49, 115, 255);">
								Status
							</div>
							<div class="divItemGrupo" style="width: 75px;color: white;background: rgb(49, 115, 255);">
								Apto
							</div>

							<div class="divItemGrupo" style="width: 250px;color: white;background: rgb(49, 115, 255);">
								Empresa
							</div>
							<div class="divItemGrupo" style="width: 300px;color: white;background: rgb(49, 115, 255);">
								Hóspede
							</div>
							<div class="divItemGrupo" style="width: 80px;color: white;background: rgb(49, 115, 255);">
								Data Entrada
							</div>
							<div class="divItemGrupo" style="width: 80px;color: white;background: rgb(49, 115, 255);">
								Data Saída
							</div>

					</div>

						<s:iterator value="hospedeList" status="row" >
						
							<div class="divLinhaCadastro" >
								<div class="divItemGrupo" style="width: 55px;">
									<div class="divItemGrupo" style="width: 40px;text-align:center;">
										<s:if test="%{status == 1}">
											<img src="imagens/imgDisponivel.png" title="Check-in efetuado" />
										</s:if>
										<s:elseif test="%{status == 2}">
											<img src="imagens/imgOcupado.png" title="Check-out efetuado" />
										</s:elseif>
										<s:elseif test="%{status == 3}">
											<img src="imagens/imgLegAmarelo.png" title="Check-in previsto" />
										</s:elseif>
									</div>
								</div>
								<div class="divItemGrupo" style="width: 75px;">
									<s:property value="numApartamento"/>
								</div>
								<div class="divItemGrupo" style="width: 250px;">
									<s:property value="nomeEmpresa"/>
								</div>
								<div class="divItemGrupo" style="width: 300px;">
									<s:property value="nomeHospede"/>
								</div>
								<div class="divItemGrupo" style="width: 80px;">
									<s:property value="dataEntrada"/>
								</div>
								<div class="divItemGrupo" style="width: 80px;">
									<s:property value="dataSaida"/>
								</div>
								
							</div>
									
						</s:iterator>

				</div>
              </div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
              </div>
              
        </div>
</div>
</s:form>