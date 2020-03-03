<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarApartamento!prepararPesquisa.action" namespace="/app/operacional" />';
        		submitForm(vForm);
            }
            
            
            
            function gravar(){
                        
                if ($("input[name='apto.numApartamento']").val() == ''){
                    alerta('Campo "Num Apto" é obrigatório.');
                    return false;
                }
                
                if ($("input[name='apto.tipoApartamentoEJB.idTipoApartamento']").val() == ''){
                    alerta('Campo "Tipo Apto" é obrigatório.');
                    return false;
                }
                submitForm(document.forms[0]);
                
            }

        </script>






<s:form namespace="/app/operacional" action="manterApartamento!gravarApartamento.action" theme="simple">

<s:hidden name="apto.idApartamento" />
<s:set value="%{#session.HOTEL_SESSION.idPrograma == 1}" var="isHotel" />
  	<s:set var="labelTela" >
	  	<s:if test="isHotel">Apartamento</s:if>
	  	<s:else>Conta Corrente</s:else>
  	</s:set>
  	<s:set var="display" >
	  	<s:if test="isHotel">block</s:if>
	  	<s:else>none</s:else>
  	</s:set>
  	
  	
<div class="divFiltroPaiTop"><s:property value="#labelTela" /> </div>    
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Número:</p>
                    	<s:textfield maxlength="10"  name="apto.numApartamento" onkeypress="mascara(this, numeros)" id="numApartamento" size="20" />
                    </div>
                </div>
                <div class="divLinhaCadastro">
                                    <div class="divItemGrupo" style="width:300px;"><p style="width:80px;">Tipo:</p>
						<s:select list="#session.tipoApartamentoList" 
                                              cssStyle="width:150px;" 
                                              listKey="idTipoApartamento"
                                              listValue="fantasia"
                                              id="idTipoApartamento"
                                              name="apto.tipoApartamentoEJB.idTipoApartamento"/>	                    
                    </div>
                </div>
                
                <div class="divLinhaCadastro" style='display: <s:property value="#display" />'>
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Área:</p> 
                        <s:textfield maxlength="20" name="apto.area"  id="area" size="20" />
                    </div>
                </div>

				<s:if test="%{apto.status == 'LL' || apto.status == 'LS'}">
	                <div class="divLinhaCadastro"  style='display: <s:property value="#display" />'>
	                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Cofan:</p> 
	                        <s:select list="#session.LISTA_CONFIRMACAO" 
	                                  cssStyle="width:50px;" 
	                                  listKey="id"
	                                  listValue="value"
	                                  name="apto.cofan"/>
	                    </div>
	                </div>
				</s:if> 
               	<s:else>
               		<div class="divLinhaCadastro"  style='display: <s:property value="#display" />' >
	                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Cofan:</p>
	                    
         		                <s:property value="apto.cofan"/>
     							<s:hidden name="apto.cofan"/>
	                     
	                    </div>
	                </div>
               	</s:else>
               	
                <div class="divLinhaCadastro"  style='display: <s:property value="#display" />'>
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Característica:</p> 
                        <s:textfield maxlength="20" name="apto.caracteristica"  id="caracteristica" size="30" />
                    </div>
                </div>
                

                <div class="divLinhaCadastro" style="display: none">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Bloco:</p> 
                        <s:hidden name="apto.bloco"  id="bloco" />
                    </div>
                </div>
                <div class="divLinhaCadastro"  style='display: <s:property value="#display" />'>
                    <div class="divItemGrupo" style="width:400px;" ><p style="width:80px;">Camareira:</p> 
                        <s:select list="#session.camareiraList" 
                                  cssStyle="width:200px;"
                                  headerKey=""
                                  headerValue="Selecione" 
                                  listKey="idCamareira"
                                  listValue="nomeCamareira"
                                  name="apto.camareira.idCamareira"/>
                    </div>
                </div>                
                
               	<s:if test="%{apto.idApartamento != null}">

		                <div class="divLinhaCadastro"  style='display: <s:property value="#display" />'>
		                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Status:</p>
		                        <s:property value="apto.status"/>
                  				<s:hidden name="apto.status"/>
                  				<s:hidden name="apto.dataEntrada"/>
                  				<s:hidden name="apto.dataSaida"/>
		                     
		                    </div>
		                </div>
		
		                <div class="divLinhaCadastro"  style='display: <s:property value="#display" />' >
		                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Checkout:</p>
		                    
          		                <s:property value="apto.checkout"/>
      							<s:hidden name="apto.checkout"/>
		                     
		                    </div>
		                </div>
		
		                <div class="divLinhaCadastro" style="height:50px;">
		                    <div class="divItemGrupo" style="width:600px;" ><p style="width:80px;">Observação:</p>
		                        <s:property value="apto.observacao"/>
      							<s:hidden name="apto.observacao"/>
		                    </div>
		                </div>

                  		
              	</s:if> 
               	<s:else>

		                <div class="divLinhaCadastro"  style='display: <s:property value="#display" />'>
		                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Status:</p> 
		                        <s:select list="statusList" 
		                                  cssStyle="width:150px;" 
		                                  listKey="id"
		                                  listValue="value"
		                                  name="apto.status"/>
		                    </div>
		                </div>
		
		                <div class="divLinhaCadastro"  style='display: <s:property value="#display" />'>
		                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Checkout:</p> 
		                        <s:select list="#session.LISTA_CONFIRMACAO" 
		                                  cssStyle="width:50px;" 
		                                  listKey="id"
		                                  listValue="value"
		                                  name="apto.checkout"/>
		                    </div>
		                </div>
		
		                <div class="divLinhaCadastro" style="height:50px;">
		                    <div class="divItemGrupo" style="width:600px;" ><p style="width:80px;">Observação:</p> 
								<s:textarea name="apto.observacao" cols="40" rows="2"></s:textarea>                        
		                    </div>
		                </div>

              </s:else>
                
              </div>


             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
              </div>
              
        </div>
</div>
</s:form>