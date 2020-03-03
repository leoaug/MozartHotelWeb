<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">


			$(document).ready(function()	{
			   $('#idResumo').markItUp(myHtmlSettings);
			   $('#idCaracteristica').markItUp(myHtmlSettings);
			});

    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
        		submitForm(vForm);
            }
            
            
            function gravar(){
                        
                submitForm(document.forms[0]);                
            }

			 $(function() {
	            $(".idCaracteristicas").click(
	                    function() { 
	                        newValue = this.value;
							vChecked = this.checked;
							if (vChecked){
								$('.divItemGrupo[id="div'+newValue+'"]').css('background-color','red');
							}else{
								$('.divItemGrupo[id="div'+newValue+'"]').css('background-color','');
							}
	                    }
	            );
				
	        });

			
        </script>


<s:form namespace="/app/comercial" action="manterCaracteristicaHotelTipo!gravar.action" theme="simple">

<div class="divFiltroPaiTop">Características</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              
              <div class="divGrupo" style="height:140px;">
                <div class="divGrupoTitulo">Do Hotel</div>
                
					<div class="divGrupoBody" style="height: 85%;">
                
						<s:set name="objetoCorrente" value="" />
						<s:set name="qtde" value="%{0}" />
						<s:iterator value="caracteristicaHotelList" var="obj" status="row">
							
							
							<s:if test="%{#objetoCorrente == null}">
									<div class="divLinhaCadastro" style="height:50px;">
										<div class="divItemGrupo" style="width:100px; height:22px;" >
											<p style="width:100%;"><s:property value="tipoCaracteristica.equals(\"F\")?\"Facilidades e Serviços\":\"Entretenimento\""/></p>
										</div>							
							</s:if>
							<s:elseif test="%{#objetoCorrente.tipoCaracteristica != tipoCaracteristica}">
								<s:set name="qtde" value="%{0}" />
								</div>
								<div class="divLinhaCadastro" style="height:50px;">
										<div class="divItemGrupo" style="width:100px; height:22px;" >
											<p style="width:100%;"><s:property value="tipoCaracteristica.equals(\"F\")?\"Facilidades e Serviços\":\"Entretenimento\""/></p>
										</div>							
							</s:elseif>
							
							<s:if test="%{#qtde > 0 && #qtde % 15 == 0}">
								<div class="divItemGrupo" style="width:100px; height:22px;" >
											<p style="width:100%;">&nbsp;</p>
								</div>
							</s:if>
							
							
							<div class="divItemGrupo" id='div<s:property value="idCaracteristica"/>' style='width:55px; height:22px; text-align:center;<s:property value="caracteristicaDoHotelList.contains(#obj)?\"background-color:red;\":\"\""/>' >
								<p style="width:15px; float:left;">
									<input type="checkbox" class="idCaracteristicas" name="idCaracteristicaHotel" <s:property value="caracteristicaDoHotelList.contains(#obj)?\"checked\":\"\""/> value="<s:property value="idCaracteristica"/>" />
								</p>
								<p style="width:30px; float:left;">
									<img title='<s:property value="descCaracteristica"/>' src='<s:property value="link"/>' 	/>
								</p>
							</div>							

							<s:set name="qtde" value="%{#qtde + 1}" />
							<s:set name="objetoCorrente" value="obj" />
							
							<s:if test="#row.last">
								</div>
							</s:if>

						</s:iterator>
                
					</div>
                
              </div>

              <div class="divGrupo" style="height:300px;">
                <div class="divGrupoTitulo">Do Tipo de Apartamento</div>
                <div class="divGrupoBody" style="height: 85%;">
				
						<s:iterator value="tipoApartamentoDoHotelList" var="objTA">
								<div class="divLinhaCadastro" style="background-color: rgb(66, 198, 255);">
										<div class="divItemGrupo">
											<p style="width:100%; color:white"><s:property value="fantasia"/></p>
										</div>
								</div>
								
								
								<s:set name="objetoCorrente" value="" />
								<s:set name="qtde" value="%{0}" />
								<s:iterator value="caracteristicaTipoApartamentoList" var="obj" status="row">
									
									
									<s:if test="%{#objetoCorrente == null}">
											<div class="divLinhaCadastro" style="height:50px;">
												<div class="divItemGrupo" style="width:100px; height:22px;" >
													<p style="width:100%;"><s:property value="tipoCaracteristica.equals(\"Q\")?\"Quarto\":tipoCaracteristica.equals(\"C\")?\"Cozinha\":\"Banheiro\""/></p>
												</div>							
									</s:if>
									<s:elseif test="%{#objetoCorrente.tipoCaracteristica != tipoCaracteristica}">
										<s:set name="qtde" value="%{0}" />
										</div>
										<div class="divLinhaCadastro" style="height:50px;">
												<div class="divItemGrupo" style="width:100px; height:22px;" >
													<p style="width:100%;"><s:property value="tipoCaracteristica.equals(\"Q\")?\"Quarto\":tipoCaracteristica.equals(\"C\")?\"Cozinha\":\"Banheiro\""/></p>
												</div>							
									</s:elseif>
									
									<s:if test="%{#qtde > 0 && #qtde % 15 == 0}">
										<div class="divItemGrupo" style="width:100px; height:22px;" >
													<p style="width:100%;">&nbsp;</p>
										</div>
									</s:if>
									
									
									<div class="divItemGrupo" id='div<s:property value="#objTA.idTipoApartamento"/>;<s:property value="idCaracteristica"/>' style='width:55px; height:22px; text-align:center;<s:property value="#objTA.caracteristicaList.contains(#obj)?\"background-color:red;\":\"\""/>' >
										<p style="width:15px; float:left;">
											<input type="checkbox" class="idCaracteristicas" name="idCaracteristicaTipoApartamento" <s:property value="#objTA.caracteristicaList.contains(#obj)?\"checked\":\"\""/> value="<s:property value="#objTA.idTipoApartamento"/>;<s:property value="idCaracteristica"/>" />
										</p>
										<p style="width:30px; float:left;">
											<img title='<s:property value="descCaracteristica"/>' src='<s:property value="link"/>' 	/>
										</p>
									</div>							
		
									<s:set name="qtde" value="%{#qtde + 1}" />
									<s:set name="objetoCorrente" value="obj" />
									
									<s:if test="#row.last">
										</div>
									</s:if>
		
								</s:iterator>
						
						</s:iterator>
				
				</div>
              </div>
              
             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
              </div>
              
        </div>
</div>
</s:form>