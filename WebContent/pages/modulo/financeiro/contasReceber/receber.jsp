<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
			$('#linhaContasReceber').css('display','block');
           
    
			function cancelar(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="pesquisarContasReceber!prepararPesquisa.action" namespace="/app/financeiro" />';
				submitForm( vForm );
			}

            
            
            function gravar(){

            	<s:if test="%{origemRecebimento == \"DESCONTAR\"}">
	                if( $("input:checkbox[class='chk'][checked='true']").length == 0){
						alerta("Selecione pelo menos UMA duplicata para descontar.");
						return false;
					}

	                var tot = $("input:checkbox[class='chk'][checked='true']").length
					var valorTotal = 0;
					var nomeBanco = '';
					for(idx=0; idx < tot; idx++ ){
						idChk = $("input:checkbox[class='chk'][checked='true']")[idx].value;
						if (idx == 0){
							nomeBanco = Trim($($("div[id='divDup"+idChk+"'] .divItemGrupo")[15]).text());
						}else{
							if (nomeBanco != Trim($($("div[id='divDup"+idChk+"'] .divItemGrupo")[15]).text())){
								alerta('As duplicatas devem ser do mesmo banco para realizar o desconto.');
								return false;
							}
						}
							
					}


					
	                vForm = document.forms[0];
					vForm.action = '<s:url action="receberContasReceber!descontarDuplicata.action" namespace="/app/financeiro" />';
					submitForm( vForm );
					
	                
   		       	</s:if>
		       	<s:else>
	                if( $("input:checkbox[class='chk'][checked='true']").length == 0){
						alerta("Selecione pelo menos UMA duplicata para receber.");
						return false;
					}
	
	                submitForm(document.forms[0]);
				</s:else>
		               
            }



            function getEmpresa(elemento){
                url = 'app/ajax/ajax!selecionarEmpresa?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idEmpresa';
                getDataLookup(elemento, url,'Empresa','TABLE');
            }
            
            function obterComplementoEmpresa(){
            }

			
			function ajustaPC( value ){
				$('#pc1').val( value );
				$('#pc2').val( value );
			}

            function verificarAjuste(){

					var ajuste = $('#ajustes').val();
					
                	if (ajuste == '' || toFloat(ajuste) == 0){
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
			 function calcularValorRecebimento(){
				var tot = $("input:checkbox[class='chk'][checked='true']").length
				var valorTotal = 0;
				for(idx=0; idx < tot; idx++ ){
					idChk = $("input:checkbox[class='chk'][checked='true']")[idx].value;
					valor = Trim( $($("div[id='divDup"+idChk+"'] .divItemGrupo")[23]).text().replace(".","").replace(",","."));
					valorTotal += 
							Math.round( 
								parseFloat( valor ) * 100)/100;
				}
				$('#divTotal').html(arredondaFloat(Math.round( valorTotal* 100)/100).toString().replace(".",","));
				$('#divQtdeTotal').html(tot);
				
			 }

            $(function() {
	            $(".chkTodos").click(
	                    function() { 
	                        newValue = this.checked;
	                        $(".chk").attr('checked',newValue);
							calcularValorRecebimento();
	                    }
	            );
				$(".chk").click(
	                    function() { 
							calcularValorRecebimento();
	                    }
	            );
				
				
	        });
			
			
			function editarDuplicata( idDuplicata, idEmpresa, idPlanoContas, idCentroCusto, idContaCorrente ){
				
				$("#idDuplicata").val( idDuplicata ) ;
				colunas = $("div[id='divDup"+idDuplicata+"'] .divItemGrupo");
				$("#edNumDuplicata").text( Trim($(colunas[3]).text())) ;
				$("#empresa").val( Trim($(colunas[2]).text() ));
				$("#idEmpresa").val( Trim(idEmpresa ));
				//$("#contaCorrente").val( Trim($(colunas[14]).text() ));
				$("#edDataLancamento").text( Trim($(colunas[4]).text() ));
				$("#edDataVencimento").text( Trim($(colunas[5]).text()) );
				$("#dataProrrogacao").val( Trim($(colunas[6]).text()) );
				$("#edAgrupar").val( 'S' == Trim($(colunas[24]).text() )?'S':'N');
				$("#edValorLiquido").text( Trim($(colunas[13]).text() ));
				$("#valorDuplicata").val( Trim($(colunas[7]).text() ));
				$("#retencao").val( Trim($(colunas[17]).text() ));
				$("#edDespesaFinanceira").text( Trim($(colunas[25]).text() ));
				$("#cofins").val( Trim($(colunas[18]).text() ));
				$("#jurosRecebimento").val( Trim($(colunas[16]).text() ));
				$("#pis").val( Trim($(colunas[19]).text() ));
				$("#ajustes").val( Trim($(colunas[12]).text() ));
				$("#cssl").val( Trim($(colunas[20]).text() ));
				$("#edValorRecebido").text( Trim($(colunas[23]).text() ));
				$("#iss").val( Trim($(colunas[21]).text() ));
				$("#pc1").val( idPlanoContas );
				$("#pc2").val( idPlanoContas );
				$("#pc3").val( idCentroCusto );
				$("#justificaAjuste").val( Trim($(colunas[22]).text()) );
				$("#comissao").val( Trim($(colunas[8]).text()) );
				$("#encargos").val( Trim($(colunas[10]).text()) );
				$("#contaCorrente").val( idContaCorrente );
				
				
				showModal('#divEditarDuplicata');
				verificarAjuste();
				calcularValorDuplicata();
				
			}
            
			
			function gravarDuplicata(){
			
			    if ($("#idEmpresa").val() == ''){
                    alerta('Campo "Empresa" é obrigatório.');
                    return false;
                }
				
                if ($('#ajustes').val() != '' && parseInt($('#ajustes').val(),10) > 0){
            		if ($('#pc1').val()==''||$('#pc2').val()==''||$('#pc3').val()==''|| $('#justificaAjuste').val()==''){
						alerta("O bloco 'Ajustes' é obrigatório, quando o valor do ajuste é informado.");
						return false;
                	}
                }

				qry =   "idDuplicata="+$("#idDuplicata").val()+
						"&contaCorrente="+$("#contaCorrente").val()+
						"&idEmpresa="+$("#idEmpresa").val()+
						"&empresa="+$("#empresa").val()+
						"&jurosRecebimento="+$("#jurosRecebimento").val()+
						"&descontoRecebimento="+$("#ajustes").val()+
						"&retencao="+$("#retencao").val()+
						"&cofins="+$("#cofins").val()+
						"&pis="+$("#pis").val()+
						"&cssl="+$("#cssl").val()+
						"&iss="+$("#iss").val()+
						"&idPlanoContas="+$("#pc1").val()+
						"&idCentroCusto="+$("#pc3").val()+
						"&agrupar="+$("#edAgrupar").val()+
						"&dataProrrogacao="+$("#dataProrrogacao").val()+
						"&justificaAjuste="+$("#justificaAjuste").val();
				killModal();
				loading();
				submitFormAjax('atualizarDuplicataNaSessao?'+qry,true);
			}

			function atualizar(){
				
				vForm = document.forms[0];
				vForm.action = '<s:url action="receberContasReceber!prepararRecebimento.action" namespace="/app/financeiro" />';
				submitForm( vForm );
				
			}

			function calcularValorDuplicata(){
				vlStr = $("#edValorLiquido").text();
				var tot	 = Math.round(parseFloat(vlStr.replace(".","").replace(",",".") ) * 100)/100;
				if ($("#jurosRecebimento").val() != ''){
					vlStr = $("#jurosRecebimento").val();
					tot	 += Math.round(parseFloat(vlStr.replace(".","").replace(",",".") ) * 100)/100;
				}
				if ($("#ajustes").val() != ''){
					vlStr = $("#ajustes").val();
					tot	 -= Math.round(parseFloat(vlStr.replace(".","").replace(",",".") ) * 100)/100;
				}
				if ($("#retencao").val() != ''){
					vlStr = $("#retencao").val();
					tot	 -= Math.round(parseFloat(vlStr.replace(".","").replace(",",".") ) * 100)/100;
				}
				if ($("#cofins").val() != ''){
					vlStr = $("#cofins").val();
					tot	 -= Math.round(parseFloat(vlStr.replace(".","").replace(",",".") ) * 100)/100;
				}
				if ($("#pis").val() != ''){
					vlStr = $("#pis").val();
					tot	 -= Math.round(parseFloat(vlStr.replace(".","").replace(",",".") ) * 100)/100;
				}
				if ($("#cssl").val() != ''){
					vlStr = $("#cssl").val();
					tot	 -= Math.round(parseFloat(vlStr.replace(".","").replace(",",".") ) * 100)/100;
				}
				if ($("#iss").val() != ''){
					vlStr = $("#iss").val();
					tot	 -= Math.round(parseFloat(vlStr.replace(".","").replace(",",".") ) * 100)/100;
				}

				$("#edValorRecebido").text(arredondaFloat(Math.round( tot * 100)/100).toString().replace(".",","));
			}

			
			
        </script>

<s:form  action="receberContasReceber!receberDuplicata.action" theme="simple" namespace="/app/financeiro">
<s:hidden name="entidade.idDuplicata" id="idDuplicata" />
<s:hidden name="origemRecebimento" id="origemRecebimento" />

<input type="hidden" id="comissao" name="comissao" />
<input type="hidden" id="encargos" name="encargos" />
<input type="hidden" id="valorDuplicata" name="valorDuplicata" />
<div class="divFiltroPaiTop">Contas a receber</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;" >
            <div class="divGrupo" style="height:460px;">
                
                <div class="divGrupoTitulo">
                
                	<s:if test="%{origemRecebimento == \"DESCONTAR\"}">
                		Desconto de duplicatas
                	</s:if>
                	<s:else>
                		Recebimento de duplicatas
                	</s:else>
                	
                </div>
                <s:if test="%{origemRecebimento == \"DESCONTAR\"}">
                	<s:hidden name="filtro.filtroTipoPesquisa" value="1" />
                	<s:hidden name="filtro.filtroBanco.tipo" value="I" />
                	<s:hidden name="filtro.filtroBanco.tipoIntervalo" value="2" />
                	
                	
                	<div class="divLinhaCadastro">
                		<div class="divItemGrupo" style="width:360px;" >
                		<p style="width:100px;">Banco:</p>
							<s:select list="bancoList" 
									  listKey="idBanco"
									  cssStyle="width:250px;" 
									  name="filtro.filtroBanco.valorInicial"
									  id="idBanco"
									  headerKey=""
									  headerValue="Selecione" />
						</div>
						<div class="divItemGrupo" style="width:30px;" >
                   			<img  src="imagens/iconic/png/magnifying-glass-3x.png" title="Pesquisar"  onclick="alert('sss');" />
                    	</div>
                
                	</div>
                </s:if>
                <div class="divLinhaCadastro" style="height:400px;overflow: auto;">
				
                <div style="width:225%; height:300%; border: 0px solid black; ">
				<div class="divLinhaCadastro" style="background-color:white;">
                        <div class="divItemGrupo" style="border-right:1px solid white;width:50px;background-color:  #06F; color:  #FFF;">
                        	<input type="checkbox" class="chkTodos"/>
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:50px;background-color:  #06F; color:  #FFF;">
                        	Hotel
                    	</div>

                        <div class="divItemGrupo" style="border-right:1px solid white;width:170px;background-color:  #06F; color:  #FFF;">
                        	Empresa
                    	</div>
                		<div class="divItemGrupo" style="border-right:1px solid white;width:80px;background-color:  #06F; color:  #FFF;">
                        	Duplicata
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
                        	Valor dup.
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Comissão
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Ajuste
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Encargos
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Retenções
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Desc.Receb.
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Valor líq.
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:80px;text-align:center;background-color:  #06F; color:  #FFF;">
                        	CC
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:250px;background-color:  #06F; color:  #FFF;">
                        	Banco
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Juros
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	IRRF
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Cofins
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	PIS
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	CSSL
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	ISS
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:150px; background-color:  #06F; color:  #FFF;">
                        	Justificativa
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Vl.Rec.
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:center;background-color:  #06F; color:  #FFF;">
                        	Agrupar
                    	</div>
						<div class="divItemGrupo" style="border-right:1px solid white;width:60px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Desp.Fin.
                    	</div>

                </div>
                <s:iterator value="#session.listaPesquisa" status="row">
                	<div class="divLinhaCadastro" style="background-color:white;" id='divDup<s:property value="idDuplicata"/>'>
						<div class="divItemGrupo" style="width:50px;border-right:1px solid black;">
							<input type="checkbox" value='<s:property value="idDuplicata" />' name="idDuplicatas" class="chk"/>
							<img src="imagens/btnAlterar.png" title="Editar duplicata" onclick="editarDuplicata('<s:property value="idDuplicata"/>','<s:property value="idEmpresa"/>','<s:property value="idPlanoContas"/>', '<s:property value="idCentroCusto"/>', '<s:property value="idContaCorrente"/>' )" />		
						</div>
						<div class="divItemGrupo" style="width:50px;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="sigla" /></p>
						</div>
						<div class="divItemGrupo" style="width:170px;border-right:1px solid black;"><p style="width:100%;" title='<s:property value="empresa" />'>
							<s:property value="empresa.length()>20?empresa.substring(0,20)+\"...\":empresa" /></p>
						</div>
						<div class="divItemGrupo" style="width:80px;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="numDuplicata"/></p>
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
							<s:property value="valorDuplicata"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="comissao"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="ajuste"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="encargos"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="retencao"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="descontoRecebimento"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="valorLiquido"/></p>
						</div>
						<div class="divItemGrupo" style="width:80px;text-align:center;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="contaCorrente"/></p>
						</div>
						<div class="divItemGrupo" style="width:250px;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="nomeBanco"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="juros"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="irRetencao"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="cofins"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="pis"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="cssl"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="iss"/></p>
						</div>
						<div class="divItemGrupo" style="width:150px;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="justificativa"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="valorRecebidoCalculado"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:center;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="agrupar"/></p>
						</div>
						<div class="divItemGrupo" style="width:60px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="despesaFinanceira"/></p>
						</div>
                
                	</div>
                </s:iterator>
				</div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:370px;" >
                    		<p style="width:100px;">Conta corrente:</p>
							<s:select list="contaCorrenteList" headerKey="" headerValue="[Selecione]"
									  listKey="idContaCorrente"
									  cssStyle="width:250px;" 
									  name="contaCorrente"
									  id="cc" />
                    </div>	
                    
                    <div class="divItemGrupo" style="width:370px;" >
                    		<p style="width:100px;">Num doc:</p>
							<s:textfield name="numDocumentoRecebimento" maxlength="20" size="20" id="numDoc" />
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
						Valor do recebimento:
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
                <div class="divGrupoTitulo">Dados da duplicata</div>
                
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:400px;">
                        	<p style="width:100px;">Num duplicata:</p>
                        	<label id="edNumDuplicata"> </label>
                    	</div>
                </div>

				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" >
                    		<p style="width:100px;">Conta corrente:</p>
							<s:select list="contaCorrenteList" 
									  listKey="idContaCorrente"
									  cssStyle="width:250px;" 
									  name="entidade.contaCorrente"
									  id="contaCorrente" />
                    </div>
                    
                </div>
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:400px;">
                        	<p style="width:100px;">Empresa:</p>
							<input type="text" value='' name="empresa" id="empresa" size="50" maxlength="50"  onblur="getEmpresa(this)"/> 
							<s:hidden name="idEmpresa" id="idEmpresa" />
							<input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"  />
                    	</div>
                </div>

				
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:200px;" ><p style="width:100px;">Dt. Emissão:</p>
						<label id="edDataLancamento"> </label>
                    </div>
					<div class="divItemGrupo" style="width: 200px;">
					<p style="width: 100px;">Data vencimento:</p>
							<label id="edDataVencimento"> </label>
				    </div>
					<div class="divItemGrupo" style="width: 200px;">
							<p style="width: 80px;">Data prorrog.:</p>
							<s:textfield cssClass="dp" name="dataProrrogacao" id="dataProrrogacao" size="10" maxlength="10" onkeypress="mascara(this, data)"  onblur="dataValida(this)"/>
				    </div>
					<div class="divItemGrupo" style="width: 110px;">
					<p style="width: 50px;">Agrupar:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" id="edAgrupar" listKey="id"
							listValue="value" cssStyle="width:50px;" name="entidade.agrupar" value="entidade.agrupar"/>
				    </div>
				</div>

          </div>
          <div class="divGrupo" style="height:160px;width:59%;">
                <div class="divGrupoTitulo">Valores/Taxas</div>
                
				<div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Valor líquido:</p>
							<label id="edValorLiquido"> </label>
                    	</div>
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:80px;">IRRF:</p>
							<s:textfield name="entidade.irRetencao" id="retencao" size="10" maxlength="10" onkeypress="mascara(this, moeda)" onblur="calcularValorDuplicata()" />                        	
                    	</div>
				</div>
				
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Desp. Financ.:</p>
							<label id="edDespesaFinanceira"> </label>
                    	</div>
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:80px;">COFINS:</p>
							<s:textfield name="entidade.cofins" id="cofins" size="10" maxlength="10" onkeypress="mascara(this, moeda)" onblur="calcularValorDuplicata()" />                        	
                    	</div>
				</div>

				<div class="divLinhaCadastro">
				
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Juros:</p>
							<s:textfield name="entidade.jurosRecebimento" id="jurosRecebimento" size="10" maxlength="10" onkeypress="mascara(this, moeda)" onblur="calcularValorDuplicata()" />                        	
                    	</div>
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:80px;">PIS:</p>
							<s:textfield name="entidade.pis" id="pis" size="10" maxlength="10" onkeypress="mascara(this, moeda)"  onblur="calcularValorDuplicata()"/>                        	
                    	</div>
                    	
                </div>
				
				
				<div class="divLinhaCadastro">
				
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Ajustes:</p>
							<s:textfield name="entidade.descontoRecebimento" id="ajustes" size="10" maxlength="10" onkeypress="mascara(this, moeda)" onblur="verificarAjuste();calcularValorDuplicata();" />                        	
                    	</div>
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:80px;">CSSL:</p>
							<s:textfield name="entidade.cssl" id="cssl" size="10" maxlength="10" onkeypress="mascara(this, moeda)"  onblur="calcularValorDuplicata()"/>                        	
                    	</div>
                    	
                </div>
                
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Recebido:</p>
							<label id="edValorRecebido"> </label>
                    	</div>
                       <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:80px;">ISS:</p>
							<s:textfield name="entidade.iss" id="iss" size="10" maxlength="10" onkeypress="mascara(this, moeda)"  onblur="calcularValorDuplicata()"/>                        	
                    	</div>
				</div>
                
          </div>

			<div class="divGrupo" style="height:160px;width:39%;">
                <div class="divGrupoTitulo">Ajustes</div>
	                <div class="divLinhaCadastro">
	                        <div class="divItemGrupo" style="width:170px;">
	                        	<p style="width:80px;">Numero:</p>
	                        	<s:select   list="planoContaList" id="pc1" onchange="ajustaPC(this.value)"
		                        			cssStyle="width:80px;"
		                        			headerKey=""
		                        			headerValue="Selecione"
		                        			name="entidade.idPlanoContas"
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
		                        			name="entidade.idCentroCustoContabil"
		                        			listKey="idCentroCustoContabil"
		                        			listValue="descricaoCentroCusto"/>
	                    	</div>
					</div>
					<div class="divLinhaCadastro">
	                        <div class="divItemGrupo" style="width:100%;">
	                        	<p style="width:80px;">Justificativa:</p>
								<s:textfield name="entidade.justificaAjuste" cssStyle="width:170px" id="justificaAjuste" maxlength="50" onblur="toUpperCase(this)"  />                        	
	                    	</div>
	                </div>
			</div>
			
           <div class="divCadastroBotoes">
                  <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="killModal()" />
                  <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravarDuplicata()" />
           </div>
              
        </div>
</div>
<!-- divEditarDuplicata-->
