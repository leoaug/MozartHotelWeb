<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
            function cancelar(){
            	vForm = document.forms[0];
            	<s:if test="origemHospede"> 
            		vForm.action = '<s:url action="pesquisarHospede!prepararPesquisa.action" namespace="/app/recepcao" />';
    			</s:if>
    			<s:else>
    				vForm.action = '<s:url action="pesquisarHospede!prepararPesquisa.action" namespace="/app/comercial" />';
    			</s:else>
        		
        		submitForm(vForm);
            }
            
            
            function gravar(){

                if ($("#idTipoHospede").val() == ''){
                    alerta('Campo "Tipo de Hóspede" é obrigatório.');
                    return false;
                }
            	
                if ($("input[name='entidade.nomeHospede']").val() == ''){
                    alerta('Campo "Nome" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.sobrenomeHospede']").val() == ''){
                    alerta('Campo "Sobrenome" é obrigatório.');
                    return false;
                }
                vForm = document.forms[0];
            	<s:if test="origemHospede"> 
    	    		vForm.action = '<s:url action="manterHospede!gravar.action" namespace="/app/recepcao" />';
				</s:if>
				<s:else>
					vForm.action = '<s:url action="manterHospede!gravar.action" namespace="/app/comercial" />';
				</s:else>

                
                submitForm(vForm);                
            }


        	function getCidadeLookup(elemento) {
        		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarCidade?OBJ_NAME='+ elemento.id + '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idCidade';
        		getDataLookup(elemento, url, 'divCidade', 'TABLE');
        	}

        	function validaCPF(obj){
				if (!validarCPF(obj.value)){
					alerta("O campo 'CPF' é inválido");
					obj.value = '';
				}

           }

        	function validaEmail(obj){
				if (!validarEmail(obj.value)){
					alerta("O campo 'E-mail' é inválido");
					obj.value = '';
				}
           }

            
        </script>




<s:form namespace="/app/comercial" action="manterHospede!gravar.action" theme="simple">

<s:hidden name="entidade.idHospede" />
<s:hidden name="entidade.ddd" />
<s:hidden name="entidade.ddi" />
<s:hidden name="entidade.idBairro" />
<div class="divFiltroPaiTop">Hóspede</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

		<s:if test="origemHospede"> 
            	
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados do hóspede</div>
                
                <div class="divLinhaCadastro">
                    
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Tipo:</p>
						<s:select list="#session.tipoHospedeList"
								id="idTipoHospede"
								headerKey=""
								headerValue="Selecione"
								cssStyle="width:120px;"
								listKey="idTipoHospede"
								listValue="tipoHospede" name="entidade.tipoHospedeEJB.idTipoHospede"/>                        	
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Possui crédito:</p>
						<s:select list="#session.LISTA_CONFIRMACAO"
								cssStyle="width:80px;"
								listKey="id"
								listValue="value" 
								name="entidade.credito"/>                        	
                    </div>
                    
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Nome:</p>
						<s:textfield name="entidade.nomeHospede" maxlength="50" size="20" onblur="toUpperCase(this);" />                        	
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Sobrenome:</p>
						<s:textfield name="entidade.sobrenomeHospede" maxlength="50" size="20" onblur="toUpperCase(this);" />                        	
                    </div>

                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Dt Nasc.:</p>
                   		<s:textfield id="dataNasc" name="entidade.nascimento"
								size="15" onblur="dataValida(this)" maxlength="10"
								onkeypress="mascara(this,data)" cssClass="dp" /> 
                    </div>
                
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Sexo:</p>
						<s:select list="sexoList" 
								  listKey="id" 
								  listValue="value" 
								  name="entidade.sexo"
								  cssStyle="width:90px;" />                        	
                    </div>
                </div>

				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">CPF:</p>
                   		<s:textfield name="entidade.cpf" size="15" maxlength="11" onkeypress="mascara(this,numeros)" onblur="validaCPF(this)" /> 
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Passaporte:</p>
						<s:textfield name="entidade.passaporte" size="15" maxlength="11" />                        	
                    </div>

                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Identidade:</p>
						<s:textfield name="entidade.identidade" size="15" maxlength="10" />                        	
                    </div>
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Órgão exp.:</p>
						<s:textfield style="width:90px;" name="entidade.orgaoExpedidor" size="15" maxlength="8" onblur="toUpperCase(this)"/>                        	
                    </div>
                
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:355px;" ><p style="width:100px;">Endereço:</p>
						<s:textfield style="width:220px;" name="entidade.endereco" maxlength="50" size="42" onblur="toUpperCase(this);" />                        	
                    </div>
                    <div class="divItemGrupo" style="width:145px;" ><p style="width:40px;">Núm.:</p>
						<s:textfield name="entidade.numero" maxlength="5" size="6" onblur="toUpperCase(this);" />                        	
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Complemento:</p>
						<s:textfield name="entidade.complemento" maxlength="50" size="15" onblur="toUpperCase(this);" />                        	
                    </div>

                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Bairro:</p>
						<s:textfield style="width:90px;" name="entidade.bairro" maxlength="20" size="15" onblur="toUpperCase(this);" />                        	
                    </div>
                   
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Cidade:</p>
						<s:textfield name="entidade.cidadeEJB.cidade" id="cidade" maxlength="50" size="50" onblur="getCidadeLookup(this)" /> 
						<s:hidden name="entidade.cidadeEJB.idCidade" id="idCidade" />
                    </div>
                     <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">CEP:</p>
						<s:textfield name="entidade.cep" maxlength="9" size="15" onkeypress="mascara(this, cep)" />                        	
                    </div>
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Nacionalidade:</p>
						<s:textfield style="width:90px;" name="entidade.nacionalidade" maxlength="10" size="15"  onblur="toUpperCase(this);"  />                        	
                    </div>
                </div>

				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Telefone:</p>
						<s:textfield name="entidade.telefone" maxlength="14" size="15" onkeypress="mascara(this, telefone)" /> 
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Fax:</p>
						<s:textfield name="entidade.fax" maxlength="14" size="15" onkeypress="mascara(this, telefone)" /> 
                    </div>

                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Celular:</p>
						<s:textfield name="entidade.celular" maxlength="15" size="15" onkeypress="mascara(this, celular)" /> 
                    </div>
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Telex:</p>
						<s:textfield style="width:90px;" name="entidade.telex" maxlength="8" size="15" onkeypress="mascara(this, numeros)" /> 
                    </div>
                </div>

				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">E-mail:</p>
						<s:textfield name="entidade.email" maxlength="200" size="35" onblur="validaEmail(this)" /> 
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Início Fidelidade:</p>
                    	<s:property value="entidade.fidelidadeData"/>
                    	<s:hidden value="entidade.fidelidadeData"/>
                    </div>
                </div>

			<div class="divLinhaCadastro" style="height:50px;">
				<div class="divItemGrupo" style="width: 500px;">
				<p style="width: 100px;">Observação:</p>
					<s:textarea cols="40" rows="2" name="entidade.observacao">  </s:textarea>
				</div>
		
			</div>

              </div>

</s:if>
<s:else>
<!-- fidelidade -->
      <div class="divGrupo" style="height:400px;">
      <div class="divGrupoTitulo">Dados do hóspede</div>
                
                <div class="divLinhaCadastro">
                    
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Fidelidade:</p>
						<s:property value="entidade.idHospede"/>
                    </div>
                    
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Início Fidelidade:</p>
                                  		<s:textfield id="dataFidelidade" name="entidade.fidelidadeData"
								size="15" onblur="dataValida(this)" maxlength="10"
								onkeypress="mascara(this,data)" cssClass="dp" /> 

                    </div>
                    
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Tipo:</p>
                    	<s:property value="entidade.tipoHospedeEJB.tipoHospede"/>
                    	<s:hidden name="entidade.tipoHospedeEJB.tipoHospede"/>
                    	<s:hidden name="entidade.tipoHospedeEJB.idTipoHospede"/>
                    </div>
                    
                    <div class="divItemGrupo" style="width:200px;" ><p style="width:100px;">Possui crédito:</p>
                    	<s:property value="entidade.credito==S?Sim:Não"/>
                    	<s:hidden name="entidade.credito"/>
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Nome:</p>
						<s:property value="entidade.nomeHospede"/>
                    	<s:hidden name="entidade.nomeHospede"/>
						                        	
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Sobrenome:</p>
						<s:property value="entidade.sobrenomeHospede"/>
                    	<s:hidden name="entidade.sobrenomeHospede"/>

                    </div>

                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Dt Nasc.:</p>
						<s:property value="entidade.nascimento"/>
                    	<s:hidden name="entidade.nascimento"/>
                    
                    </div>
                
                    <div class="divItemGrupo" style="width:195px;" ><p style="width:100px;">Sexo:</p>
						<s:property value="entidade.sexo==M?Masculino:Feminino"/>
                    	<s:hidden name="entidade.sexo"/>

                    </div>
                </div>

				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">CPF:</p>
                    
                    	<s:property value="entidade.cpf"/>
                    	<s:hidden name="entidade.cpf"/>
                    
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Passaporte:</p>
                        <s:property value="entidade.passaporte"/>
                    	<s:hidden name="entidade.passaporte"/>
                    </div>

                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Identidade:</p>
                        <s:property value="entidade.identidade"/>
                    	<s:hidden name="entidade.identidade"/>
                    </div>
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Órgão exp.:</p>
                    	<s:property value="entidade.orgaoExpedidor"/>
                    	<s:hidden name="entidade.orgaoExpedidor"/>
                    
                    </div>
                
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Endereço:</p>
                        <s:property value="entidade.endereco"/>
                    	<s:hidden name="entidade.endereco"/>
                    
                    </div>

                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Bairro:</p>
                        <s:property value="entidade.bairro"/>
                    	<s:hidden name="entidade.bairro"/>
                    </div>
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">CEP:</p>
						<s:property value="entidade.cep"/>
                    	<s:hidden name="entidade.cep"/>

                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Cidade:</p>
                    	<s:property value="entidade.cidadeEJB.cidade"/>
                    	<s:hidden name="entidade.cidadeEJB.cidade"/>
                    	<s:hidden name="entidade.cidadeEJB.idCidade"/>
                    	
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Nacionalidade:</p>
                        <s:property value="entidade.nacionalidade"/>
                    	<s:hidden name="entidade.nacionalidade"/>
                    </div>
                </div>

				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Telefone:</p>
                        <s:property value="entidade.telefone"/>
                    	<s:hidden name="entidade.telefone"/>
                    
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Fax:</p>
                        <s:property value="entidade.fax"/>
                    	<s:hidden name="entidade.fax"/>
                    </div>

                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Celular:</p>
                        <s:property value="entidade.celular"/>
                    	<s:hidden name="entidade.celular"/>
                    </div>
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Telex:</p>
                        <s:property value="entidade.telex"/>
                    	<s:hidden name="entidade.telex"/>
                    </div>
                </div>

				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">E-mail:</p>
                        <s:property value="entidade.email"/>
                    	<s:hidden name="entidade.email"/>
                    </div>
                </div>

			<div class="divLinhaCadastro" style="height:50px;">
				<div class="divItemGrupo" style="width: 500px;">
				<p style="width: 100px;">Observação:</p>
                        <s:property value="entidade.observacao"/>
                    	<s:hidden name="entidade.observacao"/>
				
				</div>
		
			</div>

     </div>

</s:else>



             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
              </div>
              
        </div>
</div>
</s:form>