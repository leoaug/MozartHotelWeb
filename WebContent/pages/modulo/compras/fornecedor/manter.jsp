<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

			function verificaCNPJCodigo(pNacional) {
			
				if (pNacional == "1") {
					$('#codEmpresa').val('');
					$('#cpfEmpresa').val('');
					$('#divCodigo').css('display', 'none');
					$('#divCPF').css('display', 'none');
					$('#divCNPJ').css('display', 'block');
				} 
				else if (pNacional == "2"){
					$('#cnpjEmpresa').val('');
					$('#codEmpresa').val('');
					$('#divCPF').css('display', 'block');
					$('#divCNPJ').css('display', 'none');
					$('#divCodigo').css('display', 'none');
				}
				else {
					$('#cnpjEmpresa').val('');
					$('#cpfEmpresa').val('');
					$('#divCodigo').css('display', 'block');
					$('#divCPF').css('display', 'none');
					$('#divCNPJ').css('display', 'none');
				}
			
			}

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarFornecedor!prepararPesquisa.action" namespace="/app/compras" />';
        		submitForm(vForm);
            }


            function validarEmpresa(cnpj){
				
            	if($("#opcoes").val() == '3'){
            		vForm = document.forms[0];
	        		vForm.action = '<s:url action="manterFornecedor!validarEmpresa.action" namespace="/app/compras" />';
	        		submitForm(vForm);
            	}
            	else if (cnpj != '' && cnpj != null){
					var cnpjcpfformatado = cnpj.replace(/[./-]/g,'');
        			if ($("#opcoes").val() == '1'){
        				$("input[name='empresa.cgc']").val(cnpjcpfformatado);
        				$("input[name='empresaCpf']").val("");
        			}
        			else if ($("#opcoes").val() == '2')
        			{
        				$("input[name='empresa.cgc']").val(cnpjcpfformatado);
        				$("input[name='empresaCnpj']").val("");
        			}
        			
        			if ($("#opcoes").val() == '1' && !validarCNPJ(cnpjcpfformatado) ){
        				alerta('Campo "CNPJ" é inválido.');
        				return false;
        			}
        			else if ($("#opcoes").val() == '2' && !validarCPF(cnpjcpfformatado) ){
        				alerta('Campo "CPF" é inválido.');
        				return false;
        			}
        			
	        		vForm = document.forms[0];
	        		vForm.action = '<s:url action="manterFornecedor!validarEmpresa.action" namespace="/app/compras" />';
	        		submitForm(vForm);
        		}

        	}

            
            
            function gravar(){

            	if ($("input[name='entidade.nomeFantasia']").val() == ''){
                    alerta('Campo "Nome" é obrigatório.');
                    return false;
	            }

                submitForm(document.forms[0]);                
            }
            
        	function getCidadeEmpresaLookup(elemento) {
        		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarCidade?OBJ_NAME='
        				+ elemento.id + '&OBJ_VALUE=' + elemento.value
        				+ '&OBJ_HIDDEN=idCidadeEmpresa';
        		getDataLookup(elemento, url, 'divEmpresa', 'TABLE');
        	}

            
</script>

<s:form namespace="/app/compras" action="manterFornecedor!gravar.action" theme="simple">
<s:hidden name="alteracao" />
<s:hidden name="empresa.idEmpresa" />
<s:hidden name="cadastrarEmpresa" />
<s:hidden name="empresa.cgc" />

<div class="divFiltroPaiTop">Fornecedor</div>
<div class="divFiltroPai" >       
       <div class="divCadastro" style="overflow:auto;" >
              
			  <s:if test="%{!cadastrarEmpresa}">
			  
					<div class="divGrupo" style="height: 260px;">
					<div class="divGrupoTitulo">Dados do Fornecedor</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 300px;"><p style="width: 100px;">Opções:</p>
							<s:if test="%{alteracao}">
								<s:hidden name="opcoes"/>
								<s:property value="entidade.nacional==\"1\"?\"Pessoa Jurídica\":entidade.nacional==\"2\"?\"Pessoa Física\":\"Outros\""/>
							</s:if>
							
							<s:else>
								<s:select id="opcoes" list="opcoesList" 
								  cssStyle="width:80px"  
								  name="empresa.nacional"
								  listKey="id"
								  listValue="value"
								  onchange="verificaCNPJCodigo(this.value);" > </s:select>
							</s:else>
						</div>		
						<div id="divCNPJ" class="divItemGrupo" style="width: 400px;<s:if test='%{empresa.nacional != null && empresa.nacional != "1"}'>display: none;</s:if>"><p style="width: 80px;">CNPJ:</p>
								 <s:if test="%{alteracao}">
								 	<s:property value ="empresa.cgc"></s:property>
								 </s:if>		
								 <s:else>									 		
								 	<s:textfield id="cnpjEmpresa" name="empresaCnpj" maxlength="18" size="20" onkeypress="mascara(this, cnpj)" onblur="validarEmpresa(this.value)"/>
								 </s:else>
						</div>

						<div id="divCPF" class="divItemGrupo" style="width: 400px; <s:if test='%{empresa.nacional != "2"}'>display: none;</s:if>"><p style="width: 80px; ">CPF:</p>
								 <s:if test="%{alteracao}">
								 	<s:property value ="empresa.cgc"></s:property>
								 </s:if>		
								 <s:else>									 		
								 	<s:textfield id="cpfEmpresa" name="empresaCpf" maxlength="14" size="16" onkeypress="mascara(this, cpf)" onblur="validarEmpresa(this.value)"/>
								 </s:else>
						</div>		
						<div id="divCodigo" class="divItemGrupo"
								style="width: 300px; <s:if test='%{empresa.nacional != "3"}'>display: none;</s:if>">
								<p style="width: 100px;">Código:</p>
								<s:textfield id="codEmpresa" name="empresa.codigo"
									maxlength="14" size="20" onblur="validarEmpresa(this.value)"/>
						</div>
					
					</div>
					
					<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 500px;">
					<p style="width: 100px;">Razão Social:</p>
					<s:property value="empresa.razaoSocial"/>
					<s:hidden name="empresa.razaoSocial" /></div>
					</div>
					
					<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 300px;">
					<p style="width: 100px;">Endereço:</p>
					<s:property value="empresa.endereco"/>
					<s:hidden name="empresa.endereco" /></div>
					
					<div class="divItemGrupo" style="width: 200px;">
					<p style="width: 100px;">Número:</p>
					<s:property value="empresa.numero"/>
					<s:hidden name="empresa.numero" /></div>
					
					<div class="divItemGrupo" style="width: 200px;">
					<p style="width: 100px;">Complemento:</p>
					<s:property value="empresa.complemento"/>
					<s:hidden name="empresa.complemento" /></div>
					
					</div>
					
					
					<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 300px;">
					<p style="width: 100px;">Bairro:</p>
					<s:property value="empresa.bairro"/>
					<s:hidden name="empresa.bairro" /></div>
					
					<div class="divItemGrupo" style="width: 200px;">
					<p style="width: 100px;">Cidade:</p>
					<s:property value="empresa.cidade.cidade"/>
					<s:hidden name="empresa.cidade.cidade" id="cidadeEmpresa"/> <s:hidden
					name="empresa.cidade.idCidade" id="idCidadeEmpresaa" /></div>
					
					<div class="divItemGrupo" style="width: 200px;">
					<p style="width: 100px;">CEP:</p>
					<s:property value="empresa.cep"/>
					<s:hidden name="empresa.cep" /></div>
					</div>
					
					<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 300px;">
					<p style="width: 100px;">Insc. Estadual:</p>
					<s:property value="empresa.inscEstadual"  />
					<s:hidden name="empresa.inscEstadual"  />
					</div>
					
					<div class="divItemGrupo" style="width: 300px;">
					<p style="width: 100px;">Insc. Municipal:</p>
					<s:property value="empresa.inscMunicipal"  />
					<s:hidden name="empresa.inscMunicipal" />
					</div>
					</div>
						
						
					</div>
	</s:if>
	<s:else>	
					<div class="divGrupo" style="height: 260px;">
					<div class="divGrupoTitulo">Dados do Fornecedor</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 300px;"><p style="width: 100px;">Opções:</p>
								<s:select id="opcoes" list="opcoesList" 
								  cssStyle="width:80px"  
								  name="empresa.nacional"
								  listKey="id"
								  listValue="value"
								  onchange="verificaCNPJCodigo(this.value);" > </s:select>
						</div>		
						
						<div id="divCNPJ" class="divItemGrupo" style="width: 400px; <s:if test='%{empresa.nacional != "1"}'>display: none;</s:if>" ><p style="width: 80px;">CNPJ:</p>
								 <s:textfield id="cnpjEmpresa" name="empresaCnpj" maxlength="18" size="20" onkeypress="mascara(this, cnpj)" onblur="validarEmpresa(this.value)" />
						</div>
					
					
						<div id="divCPF" class="divItemGrupo" style="width: 400px; <s:if test='%{empresa.nacional != "2"}'>display: none;</s:if>"><p style="width: 80px;">CPF:</p>
								 <s:textfield id="cpfEmpresa" name="empresaCpf" maxlength="14" size="20" onkeypress="mascara(this, cpf)" onblur="validarEmpresa(this.value)" />
						</div>
						
						<div id="divCodigo" class="divItemGrupo"
							style="width: 300px; <s:if test='%{empresa.nacional != "3"}'>display: none;</s:if>">
							<p style="width: 100px;">Código:</p>
							<s:textfield id="codEmpresa" name="empresa.codigo"
								maxlength="18" size="20" />
						</div>
					</div>
					
					<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 700px;">
					<p style="width: 100px;">Razão Social:</p>
					<s:textfield name="empresa.razaoSocial" required="true" maxlength="80" size="70" onblur="toUpperCase(this);" ></s:textfield>
					</div>
					</div>
					
					<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 600px;">
					<p style="width: 100px;">Endereço:</p>
					<s:textfield name="empresa.endereco" maxlength="60" size="50"  onblur="toUpperCase(this);" />
					</div>
					</div>
					
					<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 200px;">
					<p style="width: 100px;">Número:</p>
					<s:textfield name="empresa.numero" maxlength="10" size="10"  onblur="toUpperCase(this);" />
					</div>
					
					<div class="divItemGrupo" style="width: 500px;">
					<p style="width: 100px;">Complemento:</p>
					<s:textfield name="empresa.complemento" maxlength="60" size="50"  onblur="toUpperCase(this);" />
					</div>
					</div>
					
					<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 400px;">
					<p style="width: 100px;">Bairro:</p>
					<s:textfield name="empresa.bairro" maxlength="30" size="30" onblur="toUpperCase(this);"/></div>
					
					<div class="divItemGrupo" style="width: 300px;">
					<p style="width: 100px;">CEP:</p>
					<s:textfield name="empresa.cep" maxlength="9" size="15" onkeypress="mascara(this, cep)"/></div>
					</div>
					
					<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 500px;">
					<p style="width: 100px;">Cidade:</p>
					<s:textfield name="empresa.cidade.cidade" id="cidadeEmpresa"
					maxlength="50" size="40" onblur="getCidadeEmpresaLookup(this)"  /> <s:hidden
					name="empresa.cidade.idCidade" id="idCidadeEmpresa" /></div>


					</div>
					
					<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 300px;">
					<p style="width: 100px;">Insc. Estadual:</p>
					<s:textfield name="empresa.inscEstadual" maxlength="20" size="20" />
					</div>
					
					<div class="divItemGrupo" style="width: 300px;">
					<p style="width: 100px;">Insc. Municipal:</p>
					<s:textfield name="empresa.inscMunicipal" maxlength="10" size="20" />
					</div>
					</div>
						
					</div>	

	
	</s:else>
			  
			<s:if test="%{#session.USER_ADMIN eq \"TRUE\"}">  
			  <div class="divGrupo" style="height:230px;">
                
                <div class="divGrupoTitulo">Dados da rede</div>
                	
						 <div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 500px;"><p style="width: 100px;">Nome :</p>
								<s:textfield onkeyup="toUpperCase(this);" onblur="toUpperCase(this);" maxlength="60"  name="entidade.nomeFantasia"  id="nome" size="60" />
							</div>
						</div>		
					
			   
			             
              <div class="divLinhaCadastro">
              		<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Banco:</p>
						<s:select list="bancoList" 
								  cssStyle="width:200px"  
								  name="entidade.bancoEJB.idBanco"
								  listKey="idBanco"
								  listValue="banco"
								  headerKey=""
								  headerValue="Selecione"> </s:select>
							
					</div>
					
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Grupo:</p>
					<s:select list="fornecedorGrupoList" 
							  cssStyle="width:110px"  
							  name="entidade.fornecedorGrupo.idFornecedorGrupo"
							  listKey="idFornecedorGrupo"
							  listValue="descricao"
							  headerKey=""
							  headerValue="Selecione"> </s:select>
						
					</div>
					
				</div>
				
				
                <div class="divLinhaCadastro">              						
					<div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Contato:</p>
                        	<s:textfield maxlength="20"  name="entidade.contato"  id="contatoId" size="25" />
                    </div>
				</div>
                
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Tel:</p>
                        	<s:textfield onkeypress="mascara(this, celular)" maxlength="15"  name="entidade.telefone1"  id="" size="15" />
                    </div>
					
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">E-Mail:</p>
                        	<s:textfield cssStyle="text-transform:none;" maxlength="40"  name="entidade.email1"  id="" size="50" />
                    </div>
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Tel 2:</p>
                        	<s:textfield onkeypress="mascara(this, celular)" maxlength="15"  name="entidade.telefone2"  id="" size="15" />
                    </div>
					
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">E-Mail 2:</p>
                        	<s:textfield cssStyle="text-transform:none;" maxlength="40"  name="entidade.email2"  id="" size="50" />
                    </div>
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Tel 3:</p>
                        	<s:textfield onkeypress="mascara(this, celular)" maxlength="15"  name="entidade.telefone3"  id="" size="15" />
                    </div>
					
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">E-Mail 3:</p>
                        	<s:textfield cssStyle="text-transform:none;" maxlength="40"  name="entidade.email3"  id="" size="50" />
                    </div>
                </div>
				
				<div class="divLinhaCadastro">
					 <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Fax :</p>
							 <s:textfield onkeypress="mascara(this, telefone)" maxlength="14"  name="entidade.fax"  id="nome" size="14" />
					 </div>
				</div>
				
				
					</div>
				</s:if>
					
				<s:else>     
							
					   		
					 <div class="divGrupo" style="height:230px;">
                
                <div class="divGrupoTitulo">Dados da rede</div>
                	
						 <div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width: 500px;"><p style="width: 100px;">Nome :</p>
								<s:property value="entidade.nomeFantasia" />
								<s:hidden name="entidade.nomeFantasia" />
							</div>
						</div>		
					     
              <div class="divLinhaCadastro">
              		
              		<div class="divItemGrupo" style="width:410px;"  ><p style="width:100px;">Banco:</p>
						<s:property value="entidade.bancoEJB.nomeFantasia" />
						<s:hidden name="entidade.bancoEJB.nomeFantasia" />
						<s:hidden name="entidade.bancoEJB.idBanco" />
							
					</div>
					
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Grupo:</p>
						<s:property value="entidade.fornecedorGrupo.descricao" />
						<s:hidden name="entidade.fornecedorGrupo.descricao" />
						<s:hidden name="entidade.fornecedorGrupo.idFornecedorGrupo" />
					</div>
					
				</div>
				
				
                <div class="divLinhaCadastro">              						
					<div class="divItemGrupo" style="width:300px;" ><p style="width:100px;">Contato:</p>
                        	<s:property value="entidade.contato" />
							<s:hidden name="entidade.contato" />
					</div>
				</div>
                
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Tel:</p>
                        	<s:property value="entidade.telefone1" />
							<s:hidden name="entidade.telefone1" />
					</div>
					
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">E-Mail:</p>
                        	<s:property value="entidade.email1" />
							<s:hidden name="entidade.email1" />
				    </div>
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Tel 2:</p>
                        	<s:property value="entidade.telefone2" />
							<s:hidden name="entidade.telefone2" />
                    </div>
					
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">E-Mail 2:</p>
                        	<s:property value="entidade.email2" />
							<s:hidden name="entidade.email2" />
                    </div>
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Tel 3:</p>
                        	<s:property value="entidade.telefone3" />
							<s:hidden name="entidade.telefone3" />
                    </div>
					
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">E-Mail 3:</p>
                        	<s:property value="entidade.email3" />
							<s:hidden name="entidade.email3" />
                    </div>
                </div>
				
				<div class="divLinhaCadastro">
					 <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Fax :</p>
							 <s:property value="entidade.fax" />
							<s:hidden name="entidade.fax" />
					 </div>
				</div>
				
				
					</div>		
							

				</s:else>	
		
				
				 <div class="divGrupo" style="height:125px;">
					<div class="divGrupoTitulo">Outros dados</div>
				
						<div class="divLinhaCadastro">
									 
							<div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Prazo Pagamento:</p>
							<s:textfield name="hotel.prazo" onkeypress="mascara(this,numeros);" id="" size="10" maxlength="3" /> 
							</div>
							
							<div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Prazo Entrega:</p>
							<s:textfield name="hotel.prazoEntrega" onkeypress="mascara(this,numeros);" id="" size="10" maxlength="3" /> 
							</div>
							
						</div>
						
						
						 <div class="divLinhaCadastro">
							 
						</div>
				
				</div>
				

	
             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
             </div>
         

</div>
</div>
</s:form>