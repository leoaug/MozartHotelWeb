<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarMiniPDV!prepararPesquisa.action" namespace="/app/caixa" />';
        		submitForm(vForm);
            }
			
			function pesquisarPrato(){

			url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarPrato?idPontoVenda='+$('#idPontoVenda1').val();
			preencherCombo('idPrato1', url);        

			}
			
			
			function gravarMiniPDV(){

			    vForm = document.forms[0];				
		        submitForm( vForm );
		    }

			
			function obterValorPrato( idPrato ){
			$('#qtde').val('');
			$('#vlTotal').val('');
			submitFormAjax('obterValorPrato?idPrato='+idPrato,true);
						
			}

			function adicionarItem(){
				vForm = document.forms[0];


				
			    if ($('#apto').val() == ''){
		            alerta ("O campo 'Cliente' é obrigatório");
		            return false;
		        }
			    
			    if ($('#idPontoVenda1').val() == ''){
		            alerta ("O campo 'Ponto de Venda' é obrigatório");
		            return false;
		        }

			    if ($('#idPrato1').val() == ''){
		            alerta ("O campo 'Item' é obrigatório");
		            return false;
		        }

			    if ($('#comanda').val() == ''){
		            alerta ("O campo 'Comanda' é obrigatório");
		            return false;
		        }
		        
			    if ($('#qtde').val() == ''){
		            alerta ("O campo 'Qtde' é obrigatório");
		            return false;
		        }
			    if ($('#valor1').val() == ''){
		            alerta ("O campo 'Valor' é obrigatório");
		            return false;
		        }
			    if ($('#vlTotal').val() == ''){
		            alerta ("O campo 'Total' é obrigatório");
		            return false;
		        }
			    
				
				if ($('#numApartamento').val()==""){
					var selected = $("#apto option:selected");    
					cc = selected.text();
					$('#numApartamento').val(cc);
				}

				if ($('#nomePDV').val()==""){
					var selectedPDV = $("#idPontoVenda1 option:selected");    
					cc = selectedPDV.text();
					$('#nomePDV').val(cc);
				}
				
		        vForm.action = '<s:url action="manterMiniPDV!incluirMiniPDV.action" namespace="/app/caixa" />';
		        
		        submitForm( vForm );
		    
				
			}
			

			function excluirMiniPDV( idx ) {
		        vForm = document.forms[0];
		        if (confirm('Deseja realmente excluir esse lançamento?')){        
		            $('#id').val(idx);
		        	vForm.action = '<s:url action="manterMiniPDV!excluirMiniPDV.action" namespace="/app/caixa" />';
		        	submitForm( vForm );
		        }
			}

			
			function gravar(){

				  if ($('#apto').val() == ''){
			            alerta ("O campo 'Cliente' é obrigatório");
			            return false;
			        }
				    
				    if ($('#idPontoVenda1').val() == ''){
			            alerta ("O campo 'Ponto de Venda' é obrigatório");
			            return false;
			        }

				    if ($('#comanda').val() == ''){
			            alerta ("O campo 'Comanda' é obrigatório");
			            return false;
			        }
			        
                    submitForm(document.forms[0]);
					
                
            }
			
			$(function() {

				$("#qtde").keyup(function() {
                            total = 0.0;
                            unitario = toFloat($('#valor1').val()); 
							qtde 	 = toFloat(this.value); 
                            total = unitario * qtde;
                            $('#vlTotal').val(arredondaFloatDecimal(total).toString().replace(".",",") );
                        }
                );
				
});				

			

</script>


<s:form namespace="/app/caixa" action="manterMiniPDV!gravarMiniPDV.action" theme="simple">
<s:hidden name="numApartamento" id="numApartamento"/>
<s:hidden name="nomePDV" id="nomePDV"/>
<s:hidden name="id" id="id" />
<div class="divFiltroPaiTop">Mini PDV </div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                 <s:if test="%{#session.movimentoMiniPDVList.size()==0}">
		                 <div class="divLinhaCadastro">
		                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Cliente:</p> 
		                        	<s:select list="apartamentoList" id="apto"
									  cssStyle="width:250px"  
									  name="idCheckin"
									  listKey="idCheckin"
									  headerKey=""
									  headerValue="Selecione"> </s:select>
		                    </div>
		                </div>
						
						 <div class="divLinhaCadastro">
		                    <div class="divItemGrupo" style="width:320px;" ><p style="width:100px;">Ponto Venda:</p>
							<s:select list="pontoVendaList" 
									  cssStyle="width:200px"  
									  name="idPontoVenda"
									  id="idPontoVenda1"
									  onchange="pesquisarPrato()"
									  listKey="id.idPontoVenda"
									  listValue="nomePontoVenda"
									  headerKey=""
									  headerValue="Selecione"> </s:select>
								
							</div>
						</div>	
						<div class="divLinhaCadastro">	
							<div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Comanda:</p> 
		                        	<s:textfield maxlength="10"  name="comanda"  id="comanda" size="15" />
									
							</div>
						</div>
				</s:if>
				<s:else>
	
						<div class="divLinhaCadastro">
		                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Cliente:</p>
		                    		<s:hidden name="idCheckin" id="apto" />
		                    		<s:property value="numApartamento"/> 
		                    </div>
		                </div>
						
						 <div class="divLinhaCadastro">
		                    <div class="divItemGrupo" style="width:320px;" ><p style="width:100px;">Ponto Venda:</p>
			                    <s:hidden name="idPontoVenda" id="idPontoVenda1" />
			                    <s:property value="nomePDV"/>
							</div>
						</div>
						<div class="divLinhaCadastro">	
							<div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Comanda:</p> 
		                        <s:hidden name="comanda"  id="comanda" />
		                        <s:property value="comanda"/>
							</div>
						</div>
	
				
				</s:else>
                
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:320px;" ><p style="width:100px;">Item:</p>
					<s:select list="#session.pratoPDVList" 
							  cssStyle="width:200px"  
							  name="idPrato"
							  id="idPrato1"
							  onchange="obterValorPrato(this.value)"
							  listKey="pratoEJB.id.idPrato"
							  listValue="pratoEJB.nomePrato" headerKey="" headerValue="Selecione"> </s:select>
					</div>
					
					
					<div class="divItemGrupo" style="width:200px;" ><p style="width:80px;">Qtde:</p> 
                        	<s:textfield cssStyle="text-align:right;" maxlength="5"  name="qtde"  id="qtde" size="10" />
                    </div>
					
					<div class="divItemGrupo" style="width:200px;" ><p style="width:80px;">Valor:</p> 
                        	<s:textfield cssStyle="background-color:silver; text-align:right;" maxlength="5"  name="vlUnitario"  readonly="true" id="valor1" size="10" />
                    </div>
					
					<div class="divItemGrupo" style="width:200px;" ><p style="width:60px;">Total:</p> 
                        	<s:textfield cssStyle="background-color:silver;text-align:right;" maxlength="5"   name="vlTotal" readonly="true"  id="vlTotal" size="10" />
                    </div>
					
					<div class="divItemGrupo" style="width:35px;" >
							<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png" title="Adicionar Item" style="margin:0px;" onclick="adicionarItem();"/>
					</div>
					
                </div>
                
                
                	<div style="width: 99%; height: 200px; overflow-y: auto;">
                	<s:set name="valorTotal" value="%{0.0}" />
                	<s:iterator var = "obj"
						value="#session.movimentoMiniPDVList" status="row">
						<s:set name="valorTotal" value="%{#valorTotal+#obj.valorTotal}" />
						<div class="divLinhaCadastro" style="background_color: white;">
						<div class="divItemGrupo" style="width: 320px;">
						<p style="width: 100%;"><s:property value="pratoEJB.nomePrato" /></p>
						</div>
						
						<div class="divItemGrupo" style="width: 200px;">
							<p style="width: 160px; text-align: right;"><s:property value="quantidade" /></p>
						</div>
				
						<div class="divItemGrupo" style="width: 200px;">
							<p style="width: 160px; text-align: right;"><s:property value="pratoEJB.valorPrato" /></p>
						</div>
				
						<div class="divItemGrupo" style="width: 200px;">
							<p style="width: 140px; text-align: right;"><s:property value="valorTotal" /></p>
						</div>
						
						<div class="divItemGrupo" style="width:35px;" >
							<img width="30px" height="30px" src="imagens/iconic/png/x-3x.png" title="Excluir" onclick="excluirMiniPDV('${row.index}')" /></div>
						</div>
				
					</s:iterator>
					</div>
					
					
					<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:320px;" >
					
					</div>
					
					
					<div class="divItemGrupo" style="width:200px;" > 
                        	
                    </div>
					
					<div class="divItemGrupo" style="width:200px;" > 
                        	
                    </div>
					
					<div class="divItemGrupo" style="width:200px;" ><p style="width:60px;">Total:</p> 
                        	<s:property value="%{#valorTotal}" />
                    </div>
					
					<div class="divItemGrupo" style="width:35px;" >
							
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