<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
        		submitForm(vForm);
            }

            

            
            function gerarEnviarBoleto(){
                        
            	if ($("input[name='valor']").val() == ''){
                    alerta('Campo "Valor" é obrigatório.');
                    return false;
                }

            	if ($("input[name='vencimento']").val() == ''){
                    alerta('Campo "Vencimento" é obrigatório.');
                    return false;
                }
             

                if ($("input[name='email']").val() == ''){
                    alerta('Campo "E-mail" é obrigatório.');
                    return false;
                }                  

                submitForm(document.forms[0]);
                
            }

</script>


<s:form namespace="/app/sistema" action="gerarBoleto!gerarBoleto.action" theme="simple">

<div class="divFiltroPaiTop">Gerar Boleto </div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Valor:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="10"  name="valor"  id="valor" size="15" />
                    </div>
                </div>

                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:160px;" ><p style="width:100px;">Hoje + :</p> 
                        	<s:textfield maxlength="1" onkeypress="mascara(this,data)" name="vencimento"  id="vencimento" size="5" /> 
                        	
                    </div>
					<div class="divItemGrupo" style="width:120px;" ><p style="width:100px;">dias</p> 
					</div>
                </div>
				
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:700px;" ><p style="width:100px;">E-Mail:</p> 
                        	<s:textfield maxlength="100" cssStyle="text-transform:none;" name="email"  id="nossoNumero" size="80" />

                    </div>
                </div>
                
                  <div class="divLinhaCadastro">
                    
                   <div class="divItemGrupo" style="width:420px;" ><p style="width:100px;">Hotel:</p>
							<select name = "idHotel" style="width:200px;">
								<option value="">Selecione</option>
								<s:iterator value="#session.USER_SESSION.usuarioEJB.redeHotelEJB.hoteis" var="hotel" status="idx">
									<s:if test="empresaSeguradoraEJB!=null">
										<option value="<s:property value="idHotel" />">	<s:property value="nomeFantasia" /> </option>
									</s:if> 
								</s:iterator>
							</select>
					</div>
				</div>	
								
              </div>

	              <div class="divCadastroBotoes">
	                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
	                    <duques:botao label="Enviar" imagem="imagens/iconic/png/check-4x.png" onClick="gerarEnviarBoleto()" />
	              </div>
	              
      		  </div>
</div>
</s:form>