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

			function removerDocumento(){
				$("input[name='entidadeCP.nomeDocumento']").val("");
				$("#inputRemoverDocumento").hide();
				$("#inputDocumento").show();	
			}
            
            function gravar(){
                        
                if ($("input[name='entidadeCP.numDocumento']").val() == ''){
                    alerta("Campo 'Num Título' é obrigatório.");
                    return false;
                }
				if ($("input[name='entidadeCP.numParcelas']").val() == ''){
                    alerta("Campo 'Parcela' é obrigatório.");
                    return false;
                }
				if ($("input[name='entidadeCP.serieDocumento']").val() == ''){
                    alerta("Campo 'Série' é obrigatório.");
                    return false;
                }
				if ($("input[name='entidadeCP.tipoDocumento']").val() == ''){
                    alerta("Campo 'Tipo' é obrigatório.");
                    return false;
                }
				if ($("input[name='entidadeCP.fornecedorHotelEJB.fornecedorRedeEJB.idFornecedor']").val() == ''){
                    alerta("Campo 'Fornecedor' é obrigatório.");
                    return false;
                }
				if ($("input[name='entidadeCP.dataEmissao']").val() == ''){
                    alerta("Campo 'Data Emissão' é obrigatório.");
                    return false;
                }
				if ($("input[name='entidadeCP.dataVencimento']").val() == ''){
                    alerta("Campo 'Data vcto' é obrigatório.");
                    return false;
                }

				if (toFloat($('#totalGeral').text()) != 0.0 ){
					alerta("Os valores de 'Débito' e 'Crédito' não conferem");
					return false;	
				}

                if ($('#contatoHistorico').val() != ''|| $('#dataHistorico').val()!= ''){
            		if ($('#numeroForma').val()==''){
						alerta("O campo 'Número' é obrigatório, quando o histórico é informado.");
						return false;
                	}
                }

				document.getElementById('idLancamentoFrame').contentWindow.preGravar();
            }


            function podeGravar(){
				vForm = document.forms[0];
				submitForm( vForm );
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

			
			function atualizarDadosDefault( valor ){
				if (valor != ''){
					if (Trim($('input[name="entidadeCP.valorBruto"]').val()) == '' ){
						alerta("O campo 'Vl título' é obrigatório.");
						return false;
					}
					document.getElementById('idLancamentoFrame').contentWindow.atualizarDadosDefault( valor );
				}
			}

			
			function atualizarTotal( valorD, valorC ){
				$('#totalCredito').html(valorC);
				$('#totalDebito').html(valorD);
				
				var unitario = parseFloat(  valorC.replace(".","").replace(",",".") ) -  
						   parseFloat(  valorD.replace(".","").replace(",",".") );
							
				$('#totalGeral').html(arredondaFloat(unitario).toString().replace(".",","));
				$('#totalGeral').css('color',unitario==0.0?'green':'red');
				
			}



			function validaTipo( value ){

				$('#portador').attr('readonly','readonly');
				if (value == '1'){
					$('#portador').val( $('#fornecedor').val()  );

				}else if (value == '2'){
				
					var selected = $("#contaCorrente option:selected");    
					cc = selected.text();
					$('#portador').val(cc);
					
				}else if (value == '3'){
					$('#portador').val('');
					$('#portador').attr('readonly','');
				}else{
					$('#portador').val('Internet');
				}	
			}
			
			function showData(){
				$('#divData').DatePicker({
						flat: true,
						calendars: 1,
						format: 'd/m/Y',
						mode: 'range',
						starts: 0,
				});
			}
				
			
        </script>






<s:form  action="manterContasPagar!gravar.action" theme="simple" namespace="/app/financeiro" method="post" enctype="multipart/form-data">

<s:hidden name="entidadeCP.idContasPagar" />
<s:hidden name="entidadeCP.idHistoricoCredito" />
<s:hidden name="entidadeCP.idPlanoContasCredito" />
<s:hidden name="entidadeCP.idPlanoContasDebitoDesc" />
<s:hidden name="entidadeCP.idCentroCustoContabilDesc" />
<s:hidden name="entidadeCP.internet" value="N" />
<s:hidden name="entidadeCP.dataPagamento" />
<s:hidden name="entidadeCP.pago" />
<s:hidden name="entidadeCP.situacao" />
<s:hidden name="entidadeCP.justificativaDesc" />
<s:hidden name="entidadeCP.historicoComplementarDesc" />
<s:hidden name="entidadeCP.taxaIcms" />
<s:hidden name="entidadeCP.valorIcms" />
<s:hidden name="entidadeCP.pis" />
<s:hidden name="entidadeCP.valorPagamento" />
<s:hidden name="entidadeCP.idHotelMutuo" />
<s:hidden name="entidadeCP.emitido" />
<s:hidden name="entidadeCP.nomeDocumento" />

<p id="divData" style="display: none; visibility: hidden" ></p>



<!-- divHistorico - MODAL -->
	<div id="divHistorico" class="divCadastro" style="display: none; height: 450px; width: 600px;">

	<div class="divGrupo" style="width: 590px; height: 380px">
	<div class="divGrupoTitulo">Lista de histórico</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 300px;">
	<p style="width: 100px;">Título:</p>
		<div style="color: red;"> <s:property value="#session.entidadeSession.numDocumento" /> - 
		<s:property value="#session.entidadeSession.numParcelas" /> - <s:property value="#session.entidadeSession.dataLancamento" /></div>
	</div>
	</div>



	<div style="width: 99%; height: 200px; overflow-y: auto;">
		<s:iterator value="#session.entidadeSession.historicoList" status="row">
			<div class="divLinhaCadastro" style="background-color: white;">
				<div class="divItemGrupo" style="width: 10px;">
					<p style="width: 100%;"><b><s:property value="#row.index + 1"/></b></p>
				</div>

				<div class="divItemGrupo" style="width: 80px;">
					<p style="width: 100%;"><s:property value="data" /></p>
				</div>
				<div class="divItemGrupo" style="width: 150px;">
				<p style="width: 100%; text-align: right;"><s:property
					value="contato" /></p>
				</div>
				<div class="divItemGrupo" style="width: 130px;">
				<p style="width: 100%; text-align: right;"><s:property
					value="forma" /></p>
				</div>
		
				<div class="divItemGrupo" style="width: 140px;">
				<p style="width: 100%; text-align: right;"><s:property
					value="numeroForma" /></p>
				</div>
			</div>
			<div class="divLinhaCadastro" style="background-color: white;">
				<div class="divItemGrupo" style="width: 90%;">
					<p style="width: 100%;"><s:property value="observacoes" /></p>
				</div>
			</div>
		</s:iterator>
	</div>


	</div>

	<div class="divCadastroBotoes" style="width: 97%;">
		<duques:botao label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="killModal()" /> 
	</div>
</div>
<!-- divHistorico - MODAL - FIM -->

<div class="divFiltroPaiTop">Contas a pagar</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;height:200%;" >
              <div class="divGrupo" style="height:175px;">
                <div class="divGrupoTitulo">Dados do título</div>
                
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Num título:</p>
							<s:if test="%{entidadeCP.idContasPagar == null}">
								<s:textfield name="entidadeCP.numDocumento" id="numDocumento" size="10" maxlength="8" />                        	
							</s:if>
							<s:else>
								<s:property value="entidadeCP.numDocumento" />
								<s:hidden name="entidadeCP.numDocumento" id="numDocumento" />
							</s:else>
                    	</div>
                    	
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Parcela:</p>
							<s:if test="%{entidadeCP.idContasPagar == null}">
								<s:textfield name="entidadeCP.numParcelas" id="numPareclas" size="5" maxlength="2" onkeypress="mascara(this, numeros)" />                        	
							</s:if>
							<s:else>
								<s:property value="entidadeCP.numParcelas" />
								<s:hidden name="entidadeCP.numParcelas" id="numParcelas" />
							</s:else>
                    	</div>
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:80px;">Série:</p>
							<s:textfield name="entidadeCP.serieDocumento" id="serie" size="10" maxlength="5" onblur="toUpperCase(this)" />                        	
                    	</div>

                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:80px;">Tipo doc:</p>
							<s:textfield name="entidadeCP.tipoDocumento" id="tipo" size="5" maxlength="5" onblur="toUpperCase(this)" />                        	
                    	</div>
                </div>

                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:600px;">
                        	<p style="width:100px;">Fornecedor:</p>
							<s:textfield name="entidadeCP.fornecedorHotelEJB.fornecedorRedeEJB.nomeFantasia" id="fornecedor" size="50" maxlength="50"  onblur="getFornecedor(this)"/> 
							<s:hidden name="entidadeCP.fornecedorHotelEJB.fornecedorRedeEJB.idFornecedor" id="idFornecedor" />
							<input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"  />
                    	</div>
                </div>
               
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:200px;" >
                    	<p style="width:100px;">Dt. Lançamento:</p>
                    	<s:property value="#session.CONTROLA_DATA_SESSION.contasPagar" />
						<input type="hidden" name="entidadeCP.dataLancamento" id="dataLancamento" value="<s:property value="#session.entidadeSession.dataLancamento==null?#session.CONTROLA_DATA_SESSION.contasPagar:#session.entidadeSession.dataLancamento"/>" />
                    </div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 100px;">Data emissão:</p>
						<s:textfield name="entidadeCP.dataEmissao" id="entidadeCP.dataEmissao" onblur="dataValida(this);" onkeypress="mascara(this,data);"  size="8" maxlength="10" cssClass="dp" /> 
				    </div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 80px;">Data vcto:</p>
						<s:if test="%{entidadeCP.idContasPagar == null}">
								<s:textfield name="entidadeCP.dataVencimento" id="dataVencimento" onblur="dataValida(this);" onkeypress="mascara(this,data);"  size="8" maxlength="10" cssClass="dp" /> 
						</s:if>
						<s:else>
								<s:property value="entidadeCP.dataVencimento" />
								<s:hidden name="entidadeCP.dataVencimento" id="dataVencimento" />
						</s:else>
						
						
				    </div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 80px;">Prorrogação:</p>
						<s:textfield name="entidadeCP.prorrogacao" id="entidadeCP.prorrogacao" onblur="dataValida(this);" onkeypress="mascara(this,data);"  size="8" maxlength="10" cssClass="dp" /> 
				    </div>
				</div>


                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:200px;" >
                    	<p style="width:100px;">Vl título:</p>
                    	<s:if test="%{entidadeCP.idContasPagar == null}">
								<s:textfield name="entidadeCP.valorBruto" id="entidadeCP.valorBruto" onkeypress="mascara(this,moeda);"  size="8" maxlength="12" />                        	
						</s:if>
						<s:else>
								<s:property value="entidadeCP.valorBruto" />
								<s:hidden name="entidadeCP.valorBruto" id="entidadeCP.valorBruto" />
						</s:else>
                    </div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 100px;">% juros:</p>
						<s:textfield name="entidadeCP.percJuros" id="entidadeCP.percJuros"  onkeypress="mascara(this,moeda);"  size="8" maxlength="12" /> 
				    </div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 80px;">Juros:</p>
						<s:textfield name="entidadeCP.juros" id="entidadeCP.juros"  onkeypress="mascara(this,moeda);"  size="8" maxlength="12"  /> 
				    </div>
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 80px;">Desconto:</p>
						<s:textfield name="entidadeCP.desconto" id="entidadeCP.desconto"  onkeypress="mascara(this,moeda);"  size="8" maxlength="12" /> 
				    </div>
				</div>


				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:400px;" >
                    		<p style="width:100px;">Conta corrente:</p>
							<s:select list="contaCorrenteList" 
									  listKey="idContaCorrente"
									  cssStyle="width:250px;" 
									  name="entidadeCP.contaCorrente"
									  id="contaCorrente" />
                    </div>
                    <div class="divItemGrupo" style="width:500px;" >
                    	<p style="width:100px;">Documento:</p>
                    	
                    	<s:set var="possuiDocumento" value="false"/>
                    	<s:if test="%{entidadeCP.arquivoDocumento != null}">
                    		<s:set var="possuiDocumento"  value="true"/>
                    	</s:if>

                    	<div id="inputRemoverDocumento" style="display: ${possuiDocumento ? 'inline' : 'none'}">
							${entidadeCP.nomeDocumento}&nbsp;&nbsp;&nbsp;
							<img src="imagens/excluir.png" title="Remover documento" 
								onclick="javascript:removerDocumento()" />
                    	</div>
                    	<div id="inputDocumento" style="display: ${possuiDocumento ? 'none' : 'inline'}">
                    		<s:file name="documento" label="File"/>
                    	</div>
                    </div>
                </div>
          </div>
          <!-- TODO: (ID) Não é permitido ter duas divs com mesmo ID. Removi id="divReservaApartamento" da linha abaixo.  -->
          <div class="divGrupo" style="width:99%; height:50px;">
			<div class="divGrupoTitulo" style="float:left;">Classificação padrão</div>
			<div class="divLinhaCadastro" style="width:99%; float:left;  height: 20px;">
                   <div class="divItemGrupo" style="width:310px;" ><p style="width:100px;">Class. Padrão:</p>
                  		<s:select name="idClassificacaoContabil" onchange="atualizarDadosDefault(this.value);" 
							  cssStyle="width:200px;" 
							  list="classificacaoPadraoList"
							  listKey="descricao"
							  listValue="descricao"
							  headerKey=""
							  headerValue="Selecione" />
                   </div>
                   <div class="divItemGrupo" style="width:460px;" ><p style="width:100px;">Conta. Finan.:</p>
	                   <s:select name="entidadeCP.idPlanoContasFinanceiro" 
								  cssStyle="width:350px;" 
								  list="planoContaFinanceiroList"
								  listKey="idPlanoContas"
								  headerKey=""
								  headerValue="Selecione" />
                   </div>
               </div>
          </div>
          
          <!--Inicio dados lancamento-->
          <div id="divReservaApartamento" class="divGrupo" style="width:99%; height:270px;">
             <div class="divGrupoTitulo" style="float:left;">Lançamentos</div>
             <iframe width="100%" height="220" id="idLancamentoFrame" scrolling="no" frameborder="0" marginheight="0" marginwidth="0" 
             		 src="<s:url value="app/financeiro/include!prepararLancamento.action"/>?time=<%=new java.util.Date()%>"  ></iframe> 

				<div class="divLinhaCadastro" style="width:99%; float:left;  height: 20px; text-align:center;">
                    <div class="divItemGrupo" style="width:220px;" >
						<p style="width:100px;">Total Crédito:</p>
						<p id="totalCredito" style="color:green; width:100px;">0,00</p>
                    </div>
                    <div class="divItemGrupo" style="width:220px;" >
						<p style="width:100px;">Total Débito:</p>
						<p id="totalDebito" style="color:green; width:100px;">0,00</p>
                    </div>
					<div class="divItemGrupo" style="width:220px;" >
						<p style="width:100px;">Saldo:</p>
						<p id="totalGeral" style="color:red; width:100px;">0,00</p>
                    </div>
                </div>

           </div>
           <!--Fim dados lancamento-->
              
		  <div class="divGrupo" style="height:120px;">
                <div class="divGrupoTitulo">Dados bancários / obs</div>
	                <div class="divLinhaCadastro">
	                        <div class="divItemGrupo" style="width:220px;">
	                        	<p style="width:100px;">Num cheque:</p>
								<s:textfield name="entidadeCP.numCheque" id="numCheque" size="10" maxlength="10" onkeypress="mascara(this, numeros)"  />
	                    	</div>
	                        <div class="divItemGrupo" style="width:250px;">
	                        	<p style="width:80px;">Tipo:</p>
								<select id="tipoRecebedor" name="tipoRecebedor" onchange="validaTipo(this.value)">
									<option value="1" selected="selected">Fornecedor</option>
									<option value="2">Banco</option>
									<option value="3">Protador</option>
									<option value="4">Web</option>
								</select>
								
	                    	</div>
	                </div>
	                <div class="divLinhaCadastro">
	                        <div class="divItemGrupo">
	                        	<p style="width:100px;">Portador:</p>
								<s:textfield name="entidadeCP.portador" id="portador" size="30" maxlength="30" onblur="toUpperCase(this)"   /> 	
							</div>
					</div>
	                
					<div class="divLinhaCadastro">
	                        <div class="divItemGrupo" style="width:100%;">
	                        	<p style="width:100px;">Observação:</p>
								<s:textfield style="width:800px;" name="entidadeCP.observacao" id="observacao" size="150" maxlength="500" onblur="toUpperCase(this)"   /> 	
							</div>
					</div>

			</div>
			
			<div class="divGrupo" style="height:90px;">
                <div class="divGrupoTitulo">Histórico de títulos</div>
	                <div class="divLinhaCadastro">
	                        <div class="divItemGrupo" style="width:220px;">
	                        	<p style="width:100px;">Data:</p>
								<s:textfield cssClass="dp" name="entidadeHistorico.data" id="dataHistorico" size="10" maxlength="10" onkeypress="mascara(this, data)"  onblur="dataValida(this)"/>
	                    	</div>
	                        <div class="divItemGrupo" style="width:250px;">
	                        	<p style="width:80px;">Contato:</p>
								<s:textfield name="entidadeHistorico.contato" id="contatoHistorico" size="20" maxlength="50" onblur="toUpperCase(this)"/>
								
	                    	</div>
	                        <div class="divItemGrupo" style="width:180px;">
	                        	<p style="width:80px;">Forma:</p>
								<s:select name="entidadeHistorico.forma" 
										  list="formaHistoricoList"
										  listKey="id"
										  listValue="value">
								</s:select>
	                    	</div>

	                        <div class="divItemGrupo" style="width:220px;">
	                        	<p style="width:50px;">Número:</p>
								<s:textfield name="entidadeHistorico.numeroForma" id="numeroForma" size="20" maxlength="50" />
	                    	</div>
	                        <div class="divItemGrupo" style="width:40px;">
								<img src="imagens/iconic/png/magnifying-glass-3x.png" title="Mostrar histórico" onclick="showModal('#divHistorico');" />
	                    	</div>
	                </div>
					<div class="divLinhaCadastro">
	                        <div class="divItemGrupo" style="width:100%;">
	                        	<p style="width:100px;">Observação:</p>
								<s:textfield style="width:800px;" name="entidadeHistorico.observacoes" id="numeroForma" size="150" maxlength="500" onblur="toUpperCase(this)"   /> 	
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
	showData();
</script>
