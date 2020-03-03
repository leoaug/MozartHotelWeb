<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
			$('#linhaContasPagar').css('display','block');           
			
			function cancelar(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="pesquisarContasPagar!prepararPesquisa.action" namespace="/app/financeiro" />';
				submitForm( vForm );
			}

            
            
            function gravar(){

                if( $("input:checkbox[class='chk'][checked='true']").length == 0){
					alerta("Selecione pelo menos UM título a pagar.");
					return false;
				}

                submitForm(document.forms[0]);
		               
            }


            function getFornecedor(elemento){
                url = 'app/ajax/ajax!selecionarFornecedor?OBJ_NAME='+elemento.id+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idFornecedor';
                getDataLookup(elemento, url,'Fornecedor','TABLE');
            }
            
            function complementoFornecedor( prazo ){
					$('#portador').val( $('#fornecedor').val()  );
					dt = $('#dataLancamento').val(); 
					var data = new Date(dt.split('/')[2],parseInt(dt.split('/')[1],10)-1,dt.split('/')[0] );
					data.addDays(parseInt(prazo,10));
					$('#dataVencimento').val( formatDate(data,'d/m/Y') ); 
					
            }
			
        	function ajustaPC( value ){
				$('#pc1').val( value );
				$('#pc2').val( value );
			}

			
            function verificarDesconto(){

            		
                	if ($('#ajustes').val() == ''||parseFloat(  $('#ajustes').val().replace(".","").replace(",",".") ) == 0){
                		$('#pc1').val('');
                		$('#pc2').val('');
                		$('#pc3').val('');
						$('#justificaAjuste').val('');
						
                		$('#pc1').attr('disabled','disabled');
                		$('#pc2').attr('disabled','disabled');
                		$('#pc3').attr('disabled','disabled');
						$('#justificaAjuste').attr('disabled','disabled');
						
                    }else{
                		$('#pc1').attr('disabled','');
                		$('#pc2').attr('disabled','');
                		$('#pc3').attr('disabled','');
						$('#justificaAjuste').attr('disabled','');
                    }
					
             }
			 
            $(function() {
	            $(".chkTodos").click(
	                    function() { 
	                        newValue = this.checked;
	                        $(".chk").attr('checked',newValue);
							calcularValorPagamento();
	                    }
	            );
				$(".chk").click(
	                    function() { 
	                    	calcularValorPagamento();
	                    }
	            );
				
				
	        });

			 function calcularValorPagamento(){
					var tot = $("input:checkbox[class='chk'][checked='true']").length
					var valorTotal = 0;
					for(idx=0; idx < tot; idx++ ){
						idChk = $("input:checkbox[class='chk'][checked='true']")[idx].value;
						valorTotal += 
								Math.round( 
									parseFloat(Trim( $($("div[id='divDup"+idChk+"'] .divItemGrupo")[10]).text() ).replace(".","").replace(",",".") )
									* 100)/100;
					}
					$('#divTotal').html(arredondaFloat(Math.round( valorTotal* 100)/100).toString().replace(".",","));
					$('#divQtdeTotal').html(tot);
					
				 }
				
			
			function editarTitulo( idContasPagar, idFornecedor, idPlanoContas, idCentroCusto, idContaCorrente ){
				
				$("#idContasPagar").val( idContasPagar ) ;
				colunas = $("div[id='divDup"+idContasPagar+"'] .divItemGrupo");
				$("#edNumDuplicata").text( Trim($(colunas[3]).text())) ;
				$("#fornecedor").val( Trim($(colunas[2]).text() ));
				$("#idFornecedor").val( Trim(idFornecedor ));
				//$("#contaCorrente").val( Trim($(colunas[11]).text() ));
				$("#edDataLancamento").text( Trim($(colunas[4]).text() ));
				$("#edDataVencimento").text( Trim($(colunas[5]).text()) );
				$("#edValorBruto").text( Trim($(colunas[7]).text() ));
				$("#jurosRecebimento").val( Trim($(colunas[8]).text() ));
				$("#ajustes").val( Trim($(colunas[9]).text() ));
				$("#edValorPago").text( Trim($(colunas[10]).text() ));
				$("#pc1").val( idPlanoContas );
				$("#pc2").val( idPlanoContas );
				$("#pc3").val( idCentroCusto );
				$("#justificaAjuste").val( Trim($(colunas[12]).text()) );
				$("#contaCorrente").val( idContaCorrente );
				showModal('#divEditarDuplicata');
				verificarDesconto();
				calcularValorTitulo();
				
			}
            
			
			function gravarTitulo(){
			
			    if ($("#idFornecedor").val() == ''){
                    alerta('Campo "Fornecedor" é obrigatório.');
                    return false;
                }
				
                if ($('#ajustes').val() != '' && parseFloat(  $('#ajustes').val().replace(".","").replace(",",".") ) > 0){
            		if ($('#pc1').val()==''||$('#pc2').val()==''||$('#pc3').val()==''|| $('#justificaAjuste').val()==''){
						alerta("O bloco 'Descontos' é obrigatório, quando o valor do desconto é informado.");
						return false;
                	}
                }

				qry =   "idContasPagar="+$("#idContasPagar").val()+
						"&contaCorrente="+$("#contaCorrente").val()+
						"&idFornecedor="+$("#idFornecedor").val()+
						"&fornecedor="+$("#fornecedor").val()+
						"&juros="+$("#jurosRecebimento").val()+
						"&desconto="+$("#ajustes").val()+
						"&idPlanoContas="+$("#pc1").val()+
						"&idCentroCusto="+$("#pc3").val()+
						"&justificaAjuste="+$("#justificaAjuste").val();
				killModal();
				loading();
				submitFormAjax('atualizarContasPagarNaSessao?'+qry,true);
			}

			function atualizar(){
				
				vForm = document.forms[0];
				vForm.action = '<s:url action="pagarContasPagar!prepararPagamento.action" namespace="/app/financeiro" />';
				submitForm( vForm );
				
			}

			function calcularValorTitulo(){
				vlStr = $("#edValorBruto").text();
				var tot	 = Math.round(parseFloat(vlStr.replace(".","").replace(",",".") ) * 100)/100;

				if ($("#jurosRecebimento").val() != ''){
					vlStr = $("#jurosRecebimento").val();
					tot	 += Math.round(parseFloat(vlStr.replace(".","").replace(",",".") ) * 100)/100;
				}
				if ($("#ajustes").val() != ''){
					vlStr = $("#ajustes").val();
					tot	 -= Math.round(parseFloat(vlStr.replace(".","").replace(",",".") ) * 100)/100;
				}
				$("#edValorPago").text(arredondaFloat(Math.round( tot * 100)/100).toString().replace(".",","));
			}

			
			
        </script>

<s:form  action="pagarContasPagar!pagarContasPagar.action" theme="simple" namespace="/app/financeiro">
<s:hidden name="entidadeCP.idContasPagar" id="idContasPagar" />

<input type="hidden" id="comissao" name="comissao" />
<input type="hidden" id="encargos" name="encargos" />

<div class="divFiltroPaiTop">Contas a pagar</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;" >
            <div class="divGrupo" style="height:460px;">
                
                <div class="divGrupoTitulo">
                		Pagamento de títulos
                </div>
             
                <div class="divLinhaCadastro" style="height:400px;overflow: auto;">
				
                <div style="width:150%; height:250%; border: 0px solid black; ">
				<div class="divLinhaCadastro" style="background-color:white;">
                        <div class="divItemGrupo" style="border-right:1px solid white;width:50px;background-color:  #06F; color:  #FFF;">
                        	<input type="checkbox" class="chkTodos"/>
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:50px;background-color:  #06F; color:  #FFF;">
                        	Hotel
                    	</div>

                        <div class="divItemGrupo" style="border-right:1px solid white;width:170px;background-color:  #06F; color:  #FFF;">
                        	Fornecedor
                    	</div>
                		<div class="divItemGrupo" style="border-right:1px solid white;width:80px;background-color:  #06F; color:  #FFF;">
                        	Título
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:70px; text-align:center;background-color:  #06F; color:  #FFF;">
                        	Dt.lçto
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:70px; text-align:center;background-color:  #06F; color:  #FFF;">
                        	Dt.vcto
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:70px; text-align:center;background-color:  #06F; color:  #FFF;">
                        	Prorrog.
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:70px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Valor Bruto
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Juros
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Descontos
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:80px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Valor a pagar
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:80px;text-align:center;background-color:  #06F; color:  #FFF;">
                        	CC
                    	</div>
				    	<div class="divItemGrupo" style="border-right:1px solid white;width:100px;text-align:center;background-color:  #06F; color:  #FFF;">
                        	Justificativa 
                    	</div>

                </div>
                <s:iterator value="#session.listaPesquisa" status="row">
                	<div class="divLinhaCadastro" style="background-color:white;" id='divDup<s:property value="idContasPagar"/>'>
						<div class="divItemGrupo" style="width:50px;border-right:1px solid black;">
							<input type="checkbox" value='<s:property value="idContasPagar" />' name="idContasPagar" class="chk"/>
							<img src="imagens/btnAlterar.png" title="Editar título" onclick="editarTitulo('<s:property value="idContasPagar"/>','<s:property value="idFornecedor"/>','<s:property value="idPlanoContasDesc"/>','<s:property value="idCentroCustoDesc"/>', '<s:property value="idContaCorrente"/>')" />		
						</div>
						<div class="divItemGrupo" style="width:50px;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="sigla" /></p>
						</div>
						<div class="divItemGrupo" style="width:170px;border-right:1px solid black;"><p style="width:100%;" title='<s:property value="empresa" />'>
							<s:property value="empresa.length()>20?empresa.substring(0,20)+\"...\":empresa" /></p>
						</div>
						<div class="divItemGrupo" style="width:80px;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="documento"/></p>
						</div>
						<div class="divItemGrupo" style="width:70px;text-align:center;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="dataLancamento"/></p>
						</div>
						<div class="divItemGrupo" style="width:70px;text-align:center;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="dataVencimento"/></p>
						</div>
						<div class="divItemGrupo" style="width:70px;text-align:center;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="dataProrrogado"/></p>
						</div>
						<div class="divItemGrupo" style="width:70px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="valorBruto"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="juros"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="desconto"/></p>
						</div>
						<div class="divItemGrupo" style="width:80px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="valorLiquido"/></p>
						</div>
						<div class="divItemGrupo" style="width:80px;text-align:center;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="contaCorrente"/></p>
						</div>
						<div class="divItemGrupo" style="width:100px;text-align:left;border-right:1px solid black;">
                        	<s:property value="justificativaDesc"/></p>
                    	</div>
                
                	</div>
                </s:iterator>
				</div>
                </div>
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width:200px;" >
							<p style="width:100px;">Num Cheque:</p>
                        	<s:textfield maxlength="10"  name="numCheque"  id="numCheque" size="10"  onblur="toUpperCase(this)" />
                    </div>					
					<div class="divItemGrupo" style="width:330px;" >
							<p style="width:80px;">Portador:</p>
                        	<s:textfield maxlength="30"  name="portador"  id="portador" size="30"  onblur="toUpperCase(this)" />
                    </div>
                    <div class="divItemGrupo" style="width:370px;" >
                    		<p style="width:100px;">Conta corrente:</p>
							<s:select list="contaCorrenteList" headerKey="" headerValue="[Selecione]"
									  listKey="idContaCorrente"
									  cssStyle="width:250px;" 
									  name="contaCorrente"
									  id="cc" />
                    </div>	
						
                </div>
		   </div>
		   <div class="divCadastroBotoes" style="width:47%;float:left">
				<div class="divLinhaCadastro" style="background-color:transparent; border:0;">
					<div class="divItemGrupo" style="width:100px;font-size:12pt;">
						Qtde Total:
					</div>
					<div class="divItemGrupo" style="text-align:left; width:50px;font-size:12pt;color:green">
						<s:property value="#session.listaPesquisa.size()" />
					</div>
					<div class="divItemGrupo" style="width:100px;font-size:12pt;">
						Qtde Sel.:
					</div>
					<div class="divItemGrupo" id="divQtdeTotal" style="text-align:left; width:50px;font-size:12pt;color:green">
						0
					</div>
				</div>

				<div class="divLinhaCadastro" style="background-color:transparent; border:0;">
					<div class="divItemGrupo" style="width:190px;font-size:12pt;">
						Valor do pagamento:
					</div>
					<div class="divItemGrupo" id="divTotal" style="text-align:left; width:250px;font-size:12pt;color:green">
						0,00
					</div>
				</div>
		   </div>
           <div class="divCadastroBotoes" style="width:50%;float:left">
                  <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                  <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
           </div>
              
        </div>
</div>
</s:form>




<!-- divEditarDuplicata-->
<div class="divFiltroPai" id="divEditarDuplicata" style="display:none;width:740px;height:400px;" >
        
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:130px;">
                <div class="divGrupoTitulo">Dados do título</div>
                
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:400px;">
                        	<p style="width:100px;">Num título:</p>
                        	<label id="edNumDuplicata"> </label>
                    	</div>
                </div>

				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" >
                    		<p style="width:100px;">Conta corrente:</p>
							<s:select list="contaCorrenteList" 
									  listKey="idContaCorrente"
									  cssStyle="width:250px;" 
									  name="entidadeCP.contaCorrente"
									  id="contaCorrente" />
                    </div>
                    
                </div>
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:400px;">
                        	<p style="width:100px;">Fornecedor:</p>
                        	
                        	<input type="text" value="" name="fornecedor" id="fornecedor" size="50" maxlength="50"  onblur="getFornecedor(this)"/> 
							<input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"  />
							<input type="hidden" name="idFornecedor" id="idFornecedor" />
							
                    	</div>
                </div>

				
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:200px;" >	
                    	<p style="width:100px;">Dt. Emissão:</p>
						<label id="edDataLancamento"> </label>
                    </div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 100px;">Data vencimento:</p>
						<label id="edDataVencimento"> </label>
				    </div>
					
				</div>

          </div>
          <div class="divGrupo" style="height:160px;width:49%;">
                <div class="divGrupoTitulo">Valores/Taxas</div>
                
				<div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Valor líquido:</p>
							<label id="edValorBruto"> </label>
                    	</div>
				</div>
				
				<div class="divLinhaCadastro">
				
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Juros:</p>
							<s:textfield name="entidadeCP.juros" id="jurosRecebimento" size="10" maxlength="10" onkeypress="mascara(this, moeda)" onblur="calcularValorTitulo()" />
                    	</div>
                    	
                </div>
				
				<div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Desconto:</p>
							<s:textfield name="entidadeCP.desconto" id="ajustes" size="10" maxlength="10" onkeypress="mascara(this, moeda)" onblur="verificarDesconto();calcularValorTitulo();" />
                    	</div>
                </div>
                
               <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Pago:</p>
							<label id="edValorPago"> </label>
                    	</div>
				</div>
                
                
                
          </div>

			<div class="divGrupo" style="height:160px;width:49%;">
                <div class="divGrupoTitulo">Descontos</div>
	                <div class="divLinhaCadastro">
	                        <div class="divItemGrupo" style="width:170px;">
	                        	<p style="width:80px;">Numero:</p>
	                        	<s:select   list="planoContaList" id="pc1" onchange="ajustaPC(this.value)"
		                        			cssStyle="width:80px;"
		                        			headerKey=""
		                        			headerValue="Selecione"
		                        			name="entidadeCP.idPlanoContasDebitoDesc"
		                        			listKey="idPlanoContas"
		                        			listValue="contaReduzida"/>
								

	                    	</div>
					</div>
					<div class="divLinhaCadastro">
	                        <div class="divItemGrupo" style="width:100%;">
	                        	<p style="width:80px;">Conta:</p>
	                        	<s:select   list="planoContaList" id="pc2" onchange="ajustaPC(this.value)"
		                        			cssStyle="width:170px"
		                        			headerKey=""
		                        			headerValue="Selecione"
		                        			name="idPlanoContasNome"
		                        			listKey="idPlanoContas"
		                        			listValue="nomeConta"/>
	                    	</div>
	                </div>
	                <div class="divLinhaCadastro">
	                        <div class="divItemGrupo"  style="width:100%;">
	                        	<p style="width:80px;">Centro custo:</p>
	                        	<s:select   list="centroCustoList" id="pc3"
		                        			cssStyle="width:170px"
		                        			headerKey=""
		                        			headerValue="Selecione"
		                        			name="entidadeCP.idCentroCustoContabilDesc"
		                        			listKey="idCentroCustoContabil"
		                        			listValue="descricaoCentroCusto"/>
	                    	</div>
					</div>
					<div class="divLinhaCadastro">
	                        <div class="divItemGrupo" style="width:100%;">
	                        	<p style="width:80px;">Justificativa:</p>
								<s:textfield name="entidade.justificativaDesc" cssStyle="width:170px" id="justificaAjuste" maxlength="50" onblur="toUpperCase(this)"  />                        	
	                    	</div>
	                </div>
			</div>
			
           <div class="divCadastroBotoes">
                  <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="killModal()" />
                  <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravarTitulo()" />
           </div>
              
        </div>
</div>
<!-- divEditarDuplicata-->
