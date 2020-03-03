<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

			function getCidadeOrigemLookup(elemento){
				url = 'app/ajax/ajax!selecionarCidade?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idCidadeOrigem';
				getDataLookup(elemento, url,'divOrigem','TABLE');
			}

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarRedeHotel!prepararPesquisa.action" namespace="/app/sistema" />';
        		submitForm(vForm);
            }
            
            function gravar(){

            	if ($("input[name='entidade.idRedeHotel']").val() == ''){
                    alerta('Campo "Id Rede Hotel" é obrigatório.');
                    return false;
                }
                        
                if ($("input[name='entidade.nomeFantasia']").val() == ''){
                    alerta('Campo "Nome Fantasia" é obrigatório.');
                    return false;
           		}

                if ($("input[name='entidade.razaoSocial']").val() == ''){
                    alerta('Campo "Razão Social" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.formatoConta']").val() == ''){
                    alerta('Campo "Fmto Conta" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.cgc']").val() == ''){
                    alerta('Campo "CNPJ" é obrigatório.');
                    return false;
                }
                   submitForm(document.forms[0]);
                
            }
            
</script>

<s:form namespace="/app/sistema" action="manterRedeHotel!gravarRedeHotel.action" theme="simple">
<s:hidden name="operacao"/>
<div class="divFiltroPaiTop">Rede Hotel</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:380px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Id Rede Hotel:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="7"  name="entidade.idRedeHotel"  id="idRedeHotel" size="10" />
                    </div>
					
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Sigla:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="5"  name="entidade.sigla"  id="" size="10" />
                    </div>
                </div>
					
					
               <div class="divLinhaCadastro">
                	<div class="divItemGrupo" style="width:350px;" ><p style="width:100px;">Razão Social:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="30"  name="entidade.razaoSocial"  id="razaoSocial" size="40" />
                    </div>
					
					<div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Nome Fantasia:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="30"  name="entidade.nomeFantasia"  id="nomeFantasia" size="40" />
                    </div>
                </div>
                
				<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Endereço:</p>
						<s:textfield onblur="toUpperCase(this)" maxlength="40"  name="entidade.endereco"  id="nome" size="20" />
                    </div>
					
					<div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Bairro:</p>
						<s:textfield onblur="toUpperCase(this)" maxlength="20"  name="entidade.bairro"  id="nome" size="15" />
                    </div>
					
					<div class="divItemGrupo" style="width: 230px;"><p style="width:100px;">Cidade:</p>
						<input type ="text" name="cidadeOrigem" id="cidadeOrigem" maxlength="50" size="15" 
						onblur="getCidadeOrigemLookup(this)" /> <s:hidden name="entidade.idCidade" id="idCidadeOrigem" /> 
						<input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"  />
				
					</div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:60px;">  CEP:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"  name="entidade.cep"  id="" size="15" />
						</div>
				
                </div>
				
					
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Telefone:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="9"  name="entidade.telefone"  id="" size="20" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">  Fax:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="9"  name="entidade.fax"  id="" size="20" />
                    </div>
					
					<div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Fmto Conta:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="21"  name="entidade.formatoConta"  id="" size="20" />
                    </div>
                 
                </div>
             	
				<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Email:</p>
								<s:textfield onblur="toUpperCase(this)" maxlength="40"  name="entidade.email"  id="nome" size="40" />
							</div>
				</div>				
				  
				<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">CNPJ:</p>
								<s:textfield onblur="toUpperCase(this)" maxlength="14"  name="entidade.cgc"  id="cnpj" size="40" />
							</div>
				</div>  

				<div class="divLinhaCadastro">
					 <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">  Insc. Estadual:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="14"  name="entidade.inscEstadual"  id="" size="20" />
                    </div>	

				   <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Insc. Municipal:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="14"  name="entidade.inscMunicipal"  id="" size="20" />
                    </div>
                   
					<div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">  Insc. Embratur:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="14"  name="entidade.inscEmbratur"  id="" size="20" />
                    </div>
                 
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Automático:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.automatico"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
                    <div class="divItemGrupo" style="width:250px;"><p style="width:100px;">Fora Ano:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.foraAno"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					<div class="divItemGrupo" style="width:250px;"><p style="width:100px;">Ativo:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.ativo"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
                </div>
				
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Valor Inscrição:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="14"  name="entidade.valorInscricao"  id="" size="20" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">  Qtde Valor:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="1"  name="entidade.qtdValor"  id="" size="20" />
                    </div>
					
					<div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">  Expirar:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="2"  name="entidade.expirar"  id="" size="20" />
                    </div>
                 
                </div>
				
				
				<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">End. Logo Tipo:</p>
								<s:textfield onblur="toUpperCase(this)" maxlength="40"  name="entidade.enderecoLogotipo"  id="nome" size="40" />
							</div>
				</div>
				
				<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Link Voucher:</p>
								<s:textfield onblur="toUpperCase(this)" maxlength="40"  name="entidade.linkVoucher"  id="nome" size="40" />
							</div>
				</div>
				
				
              </div>  
			
			 <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
             </div>
			</div>
		 </div>	

</s:form>