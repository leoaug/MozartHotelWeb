<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

			jQuery(function($){
				$("#contaContabil").mask('?<s:property value="#session.HOTEL_SESSION.redeHotelEJB.formatoConta"/>'); 
			});

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarPlanoConta!prepararPesquisa.action" namespace="/app/rede" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.contaContabil']").val() == ''){
                    alerta('O campo "Conta cont�bil" � obrigat�rio.');
                    return false;
                }

                if ($("input[name='entidade.nomeConta']").val() == ''){
                    alerta('O campo "Nome conta" � obrigat�rio.');
                    return false;
                }

				if ($("#depreciacao").val()=="S"){



					if ($("#contaDevedora").val()==""){
						
						alerta('O campo "Conta devedora" � obrigat�rio para deprecia��o');
	
						return false;
					  	
					}	
					
					
					if ($("#contaCredora").val()==""){
	
						alerta('O campo "Conta credora" � obrigat�rio para deprecia��o');
	
						return false;
					  	
					}
			}

				
				if ($("#mutuo").val()=="S" && $("#hotelMutuo").val()==""){

						alerta('O campo "Hotel" � obrigat�rio quando m�tuo');
	
						return false;
					  	
				}

                
                   submitForm(document.forms[0]);
                
            }

            function verificaDepreciacao(obj){

    			if (obj=='S'){
					$("#linhaDepreciacao").css("display", "block");
    			
    			}else {	
    				$("#linhaDepreciacao").css("display", "none");
					$("#contaCredora").val("");
					$("#contaDevedora").val("");
					$("#percentual").val("");
        		}
       }


            function verificaMutuo(obj){

    			if (obj=='S'){
					$("#linhaMutuo").css("display", "block");
    			
    			}else {	
    				$("#linhaMutuo").css("display", "none");
    				$("#hotelMutuo").val("");

        		}
       } 

</script>

<s:form namespace="/app/rede" action="manterPlanoConta!gravarPlanoConta.action" theme="simple">

<s:hidden name="entidade.idPlanoContas" />
<div class="divFiltroPaiTop">Plano Contas</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:300px;">
                <div class="divGrupoTitulo">Dados</div>
                
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:100px;">Ativo/Passivo:</p>
					<s:select list="tipoList" 
							  cssStyle="width:100px"  
							  name="entidade.ativoPassivo"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
                    <div class="divItemGrupo" ><p style="width:90px;">Tipo:</p>
					<s:select list="tipoContaList" 
							  cssStyle="width:100px"  
							  name="entidade.tipoConta"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
                </div>
               
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px"><p style="width:100px;">Conta Cont�bil:</p>
						<input type="text" id="contaContabil"
								name="entidade.contaContabil" onkeypress="mascara(this, contaContabil)"
								value="<s:property value='entidade.contaContabil' />" 
								maxlength="<s:property value='#session.HOTEL_SESSION.redeHotelEJB.formatoConta.length()'/>" size="15" />
					</div>
					
					 <div class="divItemGrupo" style="width:250px"><p style="width:90px;">Conta reduzida:</p>
					<s:textfield name="entidade.contaReduzida" maxlength="5" size="10" onkeypress="mascara(this, numeros)"/>
					
					</div>
					
                </div>
               
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px"><p style="width:100px;">Nome conta:</p>
						<s:textfield name="entidade.nomeConta" maxlength="30" size="25" onkeydown="toUpperCase(this)" 
						onkeypress="toUpperCase(this)"/>
					</div>
					
					<div class="divItemGrupo"  style="width:200px"><p style="width:90px;">Raz�o aux.:</p>
					<s:select list="#session.LISTA_CONFIRMACAO"
							  cssStyle="width:60px"  
							  name="entidade.razaoAuxiliar"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					<div class="divItemGrupo"  style="width:200px"><p style="width:80px;">Corr. Mont.:</p>
					<s:select list="#session.LISTA_CONFIRMACAO"
							  cssStyle="width:60px"  
							  name="entidade.correcaoMonetaria"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					<div class="divItemGrupo"  style="width:200px"><p style="width:80px;">COFINS:</p>
					<s:select list="#session.LISTA_CONFIRMACAO"
							  cssStyle="width:60px"  
							  name="entidade.cofins"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
			  </div>
                      
                      
                      <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px" ><p style="width:100px;">Hist. d�bito:</p>
					<s:select list="historicoContabilList" 
							  cssStyle="width:250px"  
							  name="entidade.historicoDebito.idHistorico"
							  listKey="idHistorico"
							  listValue="historico"
							  headerKey=""
							  headerValue="Selecione"> </s:select>
						
					</div>
					
					<div class="divItemGrupo" ><p style="width:80px;">Hist. cr�dito:</p>
					<s:select list="historicoContabilList" 
							  cssStyle="width:250px"  
							  name="entidade.historicoCredito.idHistorico"
							  listKey="idHistorico"
							  listValue="historico"
							  headerKey=""
							  headerValue="Selecione"
							  > </s:select>
						
					</div>
					
                </div>
                      
                      <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px" ><p style="width:100px;">P.C. SPED:</p>
					<s:select list="planoContasSpedList" 
							  cssStyle="width:250px"  
							  name="entidade.planoContasSpedEJB.idPlanoContasSped"
							  listKey="idPlanoContasSped"
							  headerKey=""
							  headerValue="Selecione"
							  > </s:select>
						
					</div>
                    </div>	
                    
                    	<div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">Deprecia��o:</p>
					<s:select list="#session.LISTA_CONFIRMACAO"
							  onchange="verificaDepreciacao(this.value)"	  
							  cssStyle="width:100px"  
							  id="depreciacao"
							  name="entidade.depreciacao"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					
                </div>
                      
                	<div class="divLinhaCadastro" id="linhaDepreciacao" style="display:none;">
                
                    <div class="divItemGrupo" style="width:320px" ><p style="width:100px;">Conta devedora:</p>
					<s:select list="planoContaList" 
							  cssStyle="width:180px"  
							  name="entidade.planoConta1.idPlanoContas"
							  listKey="idPlanoContas"
							  id="contaDevedora"
							  headerKey=""
							  headerValue="Selecione"> </s:select>
						
					</div>
					
					<div class="divItemGrupo" ><p style="width:90px;">Conta credora:</p>
					<s:select list="planoContaList" 
							  cssStyle="width:180px"  
							  name="entidade.planoConta2.idPlanoContas"
							  listKey="idPlanoContas"
							  id="contaCredora"
							  headerKey=""
							  headerValue="Selecione"> </s:select>
							
					</div>
					
					<div class="divItemGrupo" style="width:250px"><p style="width:50px;">% Dep.</p>
					<s:textfield name="entidade.percentual" id="percentual" maxlength="6" size="6" onkeypress="mascara(this, moeda)"/>
					
					</div>	
					
                </div>
                
                
                
                
                
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">M�tuo:</p>
					<s:select list="#session.LISTA_CONFIRMACAO"
							  onchange="verificaMutuo(this.value)"	  
							  cssStyle="width:100px"  
							  name="entidade.mutuo"
							  id="mutuo"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					
                </div>
                      
                	<div class="divLinhaCadastro" id="linhaMutuo" style='display:<s:property value="entidade.mutuo==\"S\"?\"block\":\"none\""/>;'>
                
                    <div class="divItemGrupo" style="width:320px" ><p style="width:100px;">Hotel:</p>
					<s:select list="#session.USER_SESSION.usuarioEJB.redeHotelEJB.hoteis" 
							  cssStyle="width:180px"  
							  name="entidade.idHotelMutuo"
							  listKey="idHotel"
							  listValue="nomeFantasia"
							  id="hotelMutuo"
							  headerKey=""
							  headerValue="Selecione"> </s:select>
						
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
	verificaDepreciacao('<s:property value="entidade.depreciacao"/>');
	verificaMutuo('<s:property value="entidade.mutuo" />');
</script>