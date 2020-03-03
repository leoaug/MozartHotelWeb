<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
$('#linhaEstoque').css('display','block');


            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarEstoqueItem!prepararPesquisa.action" namespace="/app/compras" />';
        		submitForm(vForm);
            }

            function validarItens(){


            	
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="manterEstoqueItem!validarItens.action" namespace="/app/compras" />';
        		submitForm(vForm);

        	}
			
			function validarCentroCusto(valor){

				if(valor=="S"){
				
					$("#divCentroCusto").attr("display","block");
					
				}else{
				
					$("#divCentroCusto").attr("display","none");
					$("#centroCusto").val("");
				
				}
            	
        	}



            
            function gravar(){

            	if ($("input[name='entidade.estoqueMaximo']").val() == ''){
                    alerta('Campo "Estoque Máx" é obrigatório.');
                    return false;
            }
            	if ($("input[name='entidade.estoqueMinimo']").val() == ''){
                    alerta('Campo "Estoque Mín" é obrigatório.');
                    return false;
            }

            	if ($("input[name='entidadeRede.nomeItem']").val() == ''){
                    alerta('Campo "Descrição" é obrigatório.');
                    return false;
            }
			
				if ($("#centroCusto").val() == '' && $("#direto").val() == 'S'){
                    alerta('Campo "Centro Custo" é obrigatório para o item direto.');
                    return false;
            }
			
			if ($("#centroCusto").val() != '' && $("#direto").val() == 'N'){
                    alerta('Campo "Centro Custo" só é utilizado para item direto igual a Não.');
                    return false;
            }
                
                   submitForm(document.forms[0]);
                
            }
            
</script>

<s:form namespace="/app/compras" action="manterEstoqueItem!gravar.action" theme="simple">

<s:hidden name ="entidadeRede.id.idRedeHotel" value="%{#session.HOTEL_SESSION.redeHotelEJB.idRedeHotel}"/>
<s:hidden name ="entidade.id.idHotel" value="%{#session.HOTEL_SESSION.idHotel}"/>

<div class="divFiltroPaiTop">Item Estoque</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:130px;">
                <div class="divGrupoTitulo">Rede</div>
                
	              		  
						  
						<div class="divLinhaCadastro">
		                    <div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Itens:</p>
							<s:select list="itemRedeList" 
									  cssStyle="width:300px"
									  onchange="validarItens()"  
									  name="entidadeRede.id.idItem"
									  listKey="id.idItem"
									  listValue="nomeItem"
									  headerKey=""
									  headerValue="Inserir um novo"> </s:select>
								
							</div>
	              		</div>
						
						
						
						
						
						
						
						
					<s:if test="%{#session.USER_ADMIN eq \"TRUE\"}"> 	
						<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width:510px;" ><p style="width:100px;">Descrição:</p>
									<s:textfield maxlength="50"  name="entidadeRede.nomeItem"  id="" size="50" />
								</div>
								
								<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Unidade Compra:</p>
									<s:select list="unidadeEstoqueList" 
											  cssStyle="width:100px"  
											  name="entidadeRede.unidadeEstoqueCompraEJB.idUnidadeEstoque"
											  listKey="idUnidadeEstoque"
											  listValue="nomeUnidade"
											  > </s:select>
								</div>
						</div>
						  
						  
						<div class="divLinhaCadastro">
		                    <div class="divItemGrupo" style="width:510px;" ><p style="width:100px;">Tipo:</p>
							<s:select list="tipoItemList" 
									  cssStyle="width:300px"  
									  name="entidadeRede.tipoItemEJB.idTipoItem"
									  listKey="idTipoItem"
									  listValue="nomeTipo"
									  headerKey=""
									  headerValue="Selecione"> </s:select>
							</div>
							
							<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Uni. Requisição:</p>
									<s:select list="unidadeEstoqueList" 
											  cssStyle="width:100px"  
											  name="entidadeRede.unidadeEstoqueRequisicaoJB.idUnidadeEstoque"
											  listKey="idUnidadeEstoque"
											  listValue="nomeUnidade"
											  > </s:select>
							</div>
	              		</div>

						<div class="divLinhaCadastro">
		                   <div class="divItemGrupo" style="width:510px;" ><p style="width:100px;">Conta Contabil:</p>
							<s:select list="planoContaList" 
									  cssStyle="width:300px"  
									  name="entidadeRede.contaContabilEJB.idPlanoContas"
									  listKey="idPlanoContas"
									  headerKey=""
									  headerValue="Selecione"> </s:select>
								
							</div>
							
							<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Uni. Estoque:</p>
									<s:select list="unidadeEstoqueList" 
											  cssStyle="width:100px"  
											  name="entidadeRede.unidadeEstoqueRedeEJB.idUnidadeEstoque"
											  listKey="idUnidadeEstoque"
											  listValue="nomeUnidade"
											  > </s:select>
							</div>
							
							</div>
						
						</div>
					</s:if>
					
					<s:else>
						<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width:510px;" ><p style="width:100px;">Descrição:</p>
									<s:property value="entidadeRede.nomeItem" />
									<s:hidden name="entidadeRede.nomeItem" />
								</div>
								
								<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Unidade Compra:</p>
											<s:property value="entidadeRede.unidadeEstoqueCompraEJB.nomeUnidade" />
											<s:hidden name="entidadeRede.unidadeEstoqueCompraEJB.nomeUnidade" />
											<s:hidden name="entidadeRede.unidadeEstoqueCompraEJB.idUnidadeEstoque" />
								</div>
						</div>
						  
						  
						<div class="divLinhaCadastro">
		                    <div class="divItemGrupo" style="width:510px;" ><p style="width:100px;">Tipo:</p>
											<s:property value="entidadeRede.tipoItemEJB.nomeTipo" />
											<s:hidden name="entidadeRede.tipoItemEJB.nomeTipo" />
											<s:hidden name="entidadeRede.tipoItemEJB.idTipoItem" />
							</div>
							
							<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Uni. Requisição:</p>
											<s:property value="entidadeRede.unidadeEstoqueRequisicaoJB.nomeUnidade" />
											<s:hidden name="entidadeRede.unidadeEstoqueRequisicaoJB.nomeUnidade" />
											<s:hidden name="entidadeRede.unidadeEstoqueRequisicaoJB.idUnidadeEstoque" />
							</div>
	              		</div>

						<div class="divLinhaCadastro">
		                    <div class="divItemGrupo" style="width:510px;" ><p style="width:100px;">Conta Contabil:</p>
											<s:property value="entidadeRede.contaContabilEJB.contaContabil" />
											<s:hidden name="entidadeRede.contaContabilEJB.contaContabil" />
											<s:hidden name="entidadeRede.contaContabilEJB.idPlanoContas" />
							</div>
							
							<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Uni. Estoque:</p>
											<s:property value="entidadeRede.unidadeEstoqueRedeEJB.nomeUnidade" />
											<s:hidden name="entidadeRede.unidadeEstoqueRedeEJB.nomeUnidade" />
											<s:hidden name="entidadeRede.unidadeEstoqueRedeEJB.idUnidadeEstoque" />
							</div>
							
							</div>
						
						</div>
					</s:else>
			 
			 
			 
			 
			 
			  <div class="divGrupo" style="height:280px;">
                <div class="divGrupoTitulo">Unidade</div>
                
	              	<div class="divLinhaCadastro">
                     <div class="divItemGrupo" style="width:310px;" ><p style="width:120px;">É controlado no PDV:</p>
						<s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:80px"  
								  name="entidade.controlado"
								  listKey="id"
								  listValue="value"> </s:select>
							
						</div>
						
						 <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Compra Direta:</p>
						 <s:select onchange="validarCentroCusto(this.value)" 
								   list="#session.LISTA_CONFIRMACAO" 
								   cssStyle="width:80px"
								   id="direto"		
								   name="entidade.direto"
								   listKey="id"
								   listValue="value"> </s:select>
							
						</div>
						
						
						 <div id="divCentroCusto" class="divItemGrupo" style="width:310px;" ><p style="width:80px;">Centro Custo:</p>
						 <s:select list="centroCustoContabilList" 
								  cssStyle="width:200px"  
								  name="entidade.idCentroCusto"
								  id="centroCusto"
								  listKey="idCentroCustoContabil"
								  listValue="descricaoCentroCusto"
								  headerKey=""
								  headerValue="Selecione"> </s:select>
							
						 </div>
				</div>	 

				<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width:310px;" ><p style="width:120px;">Estoque Mín.:</p>
									<s:textfield maxlength="10"  name="entidade.estoqueMinimo"  id="" size="10" />
								</div>
								
								<div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Estoque Máx.:</p>
									<s:textfield maxlength="10"  name="entidade.estoqueMaximo"  id="" size="10" />
								</div>
				</div>

				
				<div class="divLinhaCadastro">
					    <div class="divItemGrupo" style="width:510px;" ><p style="width:120px;">Código Fiscal:</p>
						<s:select list="fiscalCodigoList" 
								  cssStyle="width:371px"  
								  name="entidade.idFiscalCodigo"
								  listKey="idCodigoFiscal"
								  listValue="descricao"
								  headerKey=""
								  headerValue="Selecione"> </s:select>
									
						</div>
				</div>	
				
					
				<div class="divLinhaCadastro">
					    <div class="divItemGrupo" style="width:510px;" ><p style="width:120px;">Incidência:</p>
						<s:select list="fiscalIncidenciaList" 
								  cssStyle="width:371px"  
								  name="entidade.idFiscalIncidencia"
								  listKey="idFiscalIncidencia"
								  listValue="descricao"
								  headerKey=""
								  headerValue="Selecione"> </s:select>
							
						</div>
				</div>	
				
				<div class="divLinhaCadastro">
					    <div class="divItemGrupo" style="width:510px;" ><p style="width:120px;">Alíquota Dentro Est.:</p>
						<s:select list="aliquotaList" 
								  cssStyle="width:371px"  
								  name="entidade.idAliquotasDentro"
								  listKey="idAliquotas"
								  listValue="descricao"
								  headerKey=""
								  headerValue="Selecione"> </s:select>
							
						</div>
				</div>	
				
				<div class="divLinhaCadastro">
					    <div class="divItemGrupo" style="width:510px;" ><p style="width:120px;">Alíquota Fora Est.:</p>
						<s:select list="aliquotaList" 
								  cssStyle="width:371px"  
								  name="entidade.idAliquotasFora"
								  listKey="idAliquotas"
								  listValue="descricao"
								  headerKey=""
								  headerValue="Selecione"> </s:select>
							
						</div>
				</div>	
				
				<div class="divLinhaCadastro">
                     	 <div class="divItemGrupo" style="width:310px;" ><p style="width:120px;">Imobilizado:</p>
						 <s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:80px"  
								  name="entidade.imobilizado"
								  listKey="id"
								  listValue="value"> </s:select>
							
						 </div>
						
						 <div class="divItemGrupo" style="width:190px;" ><p style="width:100px;">Gera etiqueta:</p>
						 <s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:80px"  
								  name="entidade.geraEtiqueta"
								  listKey="id"
								  listValue="value"> </s:select>
							
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
<script>
validarCentroCusto($("#direto").val());
</script>