<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

			function getCidadeOrigemLookup(elemento){
	
					url = 'app/ajax/ajax!selecionarCidade?OBJ_NAME='+elemento.id+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idCidadeOrigem';
					getDataLookup(elemento, url,'divOrigem','TABLE');
			}

			function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarHotel!prepararPesquisa.action" namespace="/app/sistema" />';
        		submitForm(vForm);
            }
            
            function gravar(){

            	if ($("input[name='entidade.idHotel']").val() == ''){
                    alerta('Campo "Id Hotel" é obrigatório.');
                    return false;
                }

            	if ($("input[name='entidade.cidadeEJB.idCidade']").val() == ''){
                    alerta('Campo "Id Cidade" é obrigatório.');
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

                if ($("input[name='entidade.endereco']").val() == ''){
                    alerta('Campo "Endereço" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.classificacao']").val() == ''){
                    alerta('Campo "Classificação" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.titular']").val() == ''){
                    alerta('Campo "Titular" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.cpfTitular']").val() == ''){
                    alerta('Campo "CPF Titular" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.dataFundacao']").val() == ''){
                    alerta('Campo "Data Fundação" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.sede']").val() == ''){
                    alerta('Campo "Sede" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.sigla']").val() == ''){
                    alerta('Campo "Sigla" é obrigatório.');
                    return false;
                }
                
                if ($("input[name='entidade.ativo']").val() == ''){
                    alerta('Campo "Ativo" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.paginasNota']").val() == ''){
                    alerta('Campo "Páginas Nota" é obrigatório.');
                    return false;
                }
                
                   submitForm(document.forms[0]);
                
            }


            function atualizarPorRede(){

            	vForm = document.forms[0];
        		vForm.action = '<s:url action="manterHotel!atualizarPorRede.action" namespace="/app/sistema" />';

            	submitForm(vForm);
            }
            
            
</script>

<s:form namespace="/app/sistema" action="manterHotel!gravarHotel.action" theme="simple">
<s:hidden name="operacao"/>
<s:hidden name="idPrograma"/>
<div class="divFiltroPaiTop">Hotel</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:730px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    
                   <div class="divItemGrupo" style="width:420px;" ><p style="width:100px;">Rede:</p>
							  <s:select list="redeHotelList" 
							  cssStyle="width:250px"  
							  name="entidade.redeHotelEJB.idRedeHotel"
							  listKey="idRedeHotel"
							  listValue="nomeFantasia"
							  headerKey=""
							  headerValue="Selecione"
							  onchange="atualizarPorRede()"> </s:select>
						
				</div>
				
				<div class="divItemGrupo" style="width:420px;" ><p style="width:80px;">Id Hotel:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"  name="entidade.idHotel"  id="" size="20" />
                    </div>
				
				</div>	
				
				<div class="divLinhaCadastro">
                	<div class="divItemGrupo" style="width:420px;" ><p style="width:100px;">Razão Social:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="70"  name="entidade.razaoSocial"  id="razaoSocial" size="50" />
                    </div>
					
					<div class="divItemGrupo" style="width:420px;" ><p style="width:80px;">Fantasia:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="30"  name="entidade.nomeFantasia"  id="razaoSocial" size="50" />
                    </div>
					
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Sigla:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="5"  name="entidade.sigla"  id="" size="10" />
                    </div>
                    
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Pensão:</p>
							  <s:select list="pensaoList" 
							  cssStyle="width:100px"  
							  name="entidade.pensao"
							  listKey="id"
							  listValue="value"
							  headerKey=""
							  headerValue="Selecione"> </s:select>
					</div>
					
					 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">FNRH:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:100px"  
							  name="entidade.fnrh"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
                    <div class="divItemGrupo" style="width:210px;"><p style="width:80px;">Tx CheckOut:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:100px"  
							  name="entidade.taxaCheckout"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
				</div>
				
				<div class="divLinhaCadastro">
                	<div class="divItemGrupo" style="width:420px;" ><p style="width:100px;">Endereço:</p>
                        	<s:textfield cssStyle="text-transform:none;" maxlength="40"  name="entidade.endereco"  id="" size="50" />
                    </div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Bairro:</p>
                        	<s:textfield cssStyle="text-transform:none;" maxlength="30"  name="entidade.bairro"  id="" size="15" />
					</div>
					
                </div>
				
				<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 420px;"><p style="width: 100px;">Cidade:</p>
						<s:textfield name="entidade.cidadeEJB.cidade" id="nomeCidade" maxlength="50" size="40" 
						onblur="getCidadeOrigemLookup(this)" /> <s:hidden name="entidade.cidadeEJB.idCidade" id="idCidadeOrigem" /> 
						<input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"  />
						</div>
						
						<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">  CEP:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"  name="entidade.cep"  id="" size="10" />
						</div>
						
						<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">CNPJ:</p>
								<s:textfield onkeypress="mascara(this, numeros)" maxlength="14"  name="entidade.cgc"  id="cnpj" size="15" />
							</div>
				</div>
                
				<div class="divLinhaCadastro">
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">  Insc. Est:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="14"  name="entidade.inscEstadual"  id="" size="15" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Insc. Municip.:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="14"  name="entidade.inscMunicipal"  id="" size="15" />
                    </div>
                    
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">  Insc. Emb:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="14"  name="entidade.inscEmbratur"  id="" size="15" />
                    </div>
					
                </div>
				
				<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:420px;" ><p style="width:100px;">Site:</p>
								<s:textfield cssStyle="text-transform:none;" maxlength="50"  name="entidade.site"  id="" size="40" />
							</div>
							
							<div class="divItemGrupo" style="width:420px;" ><p style="width:80px;">Email:</p>
								<s:textfield cssStyle="text-transform:none;" maxlength="150"  name="entidade.email"  id="" size="40" />
							</div>
							
				</div> 
				
				 <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Telefone:</p>
                        	<s:textfield maxlength="9"  name="entidade.telefone"  id="" size="15" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">  Fax:</p>
                        	<s:textfield maxlength="9"  name="entidade.fax"  id="" size="15" />
                    </div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Telex:</p>
                        	<s:textfield maxlength="9"  name="entidade.telex"  id="" size="10" />
                    </div>
					
					
                </div>

				 <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:420px;" ><p style="width:100px;">Titular:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="30"  name="entidade.titular"  id="" size="50" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:420px;" ><p style="width:80px;">  CPF Titular:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="11"  name="entidade.cpfTitular"  id="" size="20" />
                    </div>
			    </div>	

				<div class="divLinhaCadastro">              						
					<div class="divItemGrupo" style="width:420px;" ><p style="width:100px;">Contador:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="30"  name="entidade.nomeContador"  id="" size="50" />
                    </div>
				            						
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">CRC:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="14"  name="entidade.crcContador"  id="" size="15" />
                    </div>
					              						
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">CPF:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="11"  name="entidade.cpfContador"  id="" size="15" />
                    </div>
				</div>			
				
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Junta Comercial:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="15"  name="entidade.juntaComercial"  id="" size="10" />
                    </div>
					
					 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Fmto Conta:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="40"  name="entidade.formatoconta"  id="" size="10" />
                    </div>
					
					 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Dt Fundação:</p>
                    
                     <s:textfield cssClass="dp" name="entidade.dataFundacao" onkeypress="mascara(this,data);" onblur="dataValida(this);" id="entidade.dataFundacao" size="8" maxlength="10" /> 
                     </div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Pg Nota:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"  name="entidade.paginasNota"  id="" size="10" />
                    </div>
				</div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Sede:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.sede"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Nota Fiscal:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.notaFiscal"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Res Fiscal:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.resumoFiscal"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Nota Hósp:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.notaHosp"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
				</div>
				
              <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">  ISS:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="10"  name="entidade.iss"  id="" size="10" />
                    </div>

                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">  ISS NF:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="10"  name="entidade.issNf"  id="" size="10" />
                    </div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">  Taxa Serviço:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="10"  name="entidade.taxaServico"  id="" size="10" />
                    </div>
					
					<div class="divItemGrupo" style="width:160px;" ><p style="width:80px;"> Room Taxa:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="10"  name="entidade.roomtax"  id="" size="5" />
                    </div>
					
					<div class="divItemGrupo" style="width:150px;" ><p style="width:60px;">Seguro:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="10"  name="entidade.seguro"  id="" size="5" />
                    </div>
                 
                </div>

				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">IR Duplicatas:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="14"  name="entidade.irDuplicatas"  id="" size="10" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Isenção IRD:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="14"  name="entidade.isencaoIrDuplicatas"  id="" size="10" />
                    </div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Class:</p>
								<s:textfield onkeypress="mascara(this, numeros)" maxlength="1"  name="entidade.classificacao"  id="nome" size="10" />
							</div>
				</div>
								
								
				<div class="divLinhaCadastro" style="height: 53px;">
					<div class="divItemGrupo" style="width: 99%">
					<p style="width: 100px;">Nota Termo:</p>
					<s:textarea name="entidade.notaTermo" cols="60" rows="2"></s:textarea></div>
				</div>
			
			<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Tipo Hotel:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="40"  name="entidade.tipoHotel"  id="" size="10" />
                    </div>
                   
				   <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Razão:</p>
							  <s:select list="simNaoList" 
							  cssStyle="width:100px"  
							  name="entidade.razao"
							  listKey="id"
							  listValue="value"> </s:select>
					</div>
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Diário:</p>
							  <s:select list="simNaoList" 
							  cssStyle="width:100px"  
							  name="entidade.diario"
							  listKey="id"
							  listValue="value"> </s:select>
					</div>
	
			</div>
			
			<div class="divLinhaCadastro">
                	<div class="divItemGrupo" style="width:550px;" ><p style="width:100px;">Texto Promo:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="50"  name="entidade.textoPromocional"  id="razaoSocial" size="80" />
                    </div>
            </div>
			
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Nota Hósp. Tipo:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="1"  name="entidade.notaHospTipo"  id="" size="10" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">NF Tipo:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="1"  name="entidade.notaFiscalTipo"  id="" size="10" />
                    </div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Toll Free:</p>
                        	<s:textfield maxlength="15"  name="entidade.tollFree"  id="" size="12" />
                    </div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">CC DUP:</p>
								<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"  name="entidade.contaCorrenteDuplicatas"  id="nome" size="10" />
					</div>
				</div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Ativo Fixo:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"  name="entidade.ativoFixo"  id="" size="10" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">ISS Retenção:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="14"  name="entidade.issRetencao"  id="" size="10" />
                    </div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Logo Web:</p>
                        	<s:textfield cssStyle="text-transform:none;" maxlength="100"  name="entidade.enderecoLogotipo"  id="" size="12" />
                    </div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">NF Código:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="5"  name="entidade.notaFiscalCodigo"  id="" size="10" />
                    </div>
				</div>
				
					<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Ativo:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.ativo"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Ativo Web:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.ativoWeb"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">TEF:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.tef"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Internet:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.internet"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
				</div>
				
				<div class="divLinhaCadastro">
                    
                    <div class="divItemGrupo" style="width:210px"><p style="width:100px;">Dados Hosp.:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.obrigaDadosHosp"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					<div class="divItemGrupo" style="width:210px"><p style="width:80px;">Cupom Fiscal:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.cupomfiscal"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Juros %:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="14"  name="entidade.percentualJuros"  id="" size="10" />
                    </div>
					
					<div class="divItemGrupo" style="width:210px"><p style="width:80px;">MAPFRE:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.mapfre"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
														
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:210px"><p style="width:100px;">Believer:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.believer"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					 <div class="divItemGrupo" style="width:210px"><p style="width:80px;">E. Reserva:</p>
							  <s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.eReserva"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Fundo Res:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="14"  name="entidade.fundoReserva"  id="" size="10" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Fonte Nota:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="12"  name="entidade.fonteNota"  id="" size="10" />
                    </div>
				</div>
			
			<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Mini PDV:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.miniPdv"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">RPS:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="1"  name="entidade.rps"  id="" size="10" />
                    </div>
					
			</div>
			
			<div class="divLinhaCadastro">
            		
					<div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Seguradora:</p>
					<s:select list="seguradoraList" 
							  cssStyle="width:80px"  
							  name="entidade.idSeguradora"
							  listKey="id"
							  listValue="value"
							  headerKey=""
							  headerValue="Selecione"> </s:select>
						
					</div>
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Dia Vcto:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="2"  name="seguradora.diaVencimento"  id="" size="10" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Dt Início:</p>
                     		<s:textfield cssClass="dp" name="seguradora.dtInicioSeguro" onkeypress="mascara(this,data);" onblur="dataValida(this);" size="8" maxlength="10" /> 
                     </div>
					
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Num Apólice:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"  name="seguradora.numContratoApolice"  id="" size="10" />
                    </div>
					
			</div>
			<div class="divLinhaCadastro">
				<div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Plano Aplc:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"  name="seguradora.numPlanoApolice"  id="" size="10" />
                    </div>
			
			<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">SubC Aplc:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"  name="seguradora.numSubContratoApolice"  id="" size="10" />
                    </div>
			
			</div>
					
			<div class="divLinhaCadastro">
				<div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Vl DC.:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="10"  name="seguradora.vlDatacenter"  id="" size="10" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Vl Manut.:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="10"  name="seguradora.vlManutencao"  id="" size="10" />
                    </div>
			
					<div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Vl Seg.:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="10"  name="seguradora.vlSeguro"  id="" size="10" />
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