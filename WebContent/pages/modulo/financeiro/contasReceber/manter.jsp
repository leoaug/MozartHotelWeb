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
                        
                if ($("input[name='entidade.empresaHotelEJB.empresaRedeEJB.empresaEJB.idEmpresa']").val() == ''){
                    alerta('Campo "Empresa" é obrigatório.');
                    return false;
                }
               if ($('#ajustes').val() != '' && parseInt($('#ajustes').val(),10) > 0){
            		if ($('#pc1').val()==''||$('#pc2').val()==''||$('#pc3').val()==''|| $('#justificaAjuste').val()==''){
						alerta("O bloco 'Ajustes' é obrigatório, quando o valor do ajuste é informado.");
						return false;
                	}
                }

                if ($('#contatoHistorico').val() != ''|| $('#dataHistorico').val()!= ''){
            		if ($('#numeroForma').val()==''){
						alerta("O campo 'Número' é obrigatório, quando o histórico é informado.");
						return false;
                	}
                }

                submitForm(document.forms[0]);
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

                	if ($('#ajustes').val() == ''||parseInt($('#ajustes').val(),10) == 0){
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






<s:form  action="manterContasReceber!gravar.action" theme="simple" namespace="/app/financeiro">

<s:hidden name="entidade.idDuplicata" />
<!-- divHistorico -->
	<div id="divHistorico" class="divCadastro" style="display: none; height: 450px; width: 600px;">

	<div class="divGrupo" style="width: 590px; height: 380px">
	<div class="divGrupoTitulo">Lista de histórico</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 300px;">
	<p style="width: 100px;">Duplicata:</p>
		<div style="color: red;"> <s:property value="#session.entidadeSession.numDuplicata" /> - 
		<s:property value="#session.entidadeSession.numParcelas" /> - <s:property value="#session.entidadeSession.ano" /></div>
	</div>
	</div>



	<div style="width: 99%; height: 200px; overflow-y: auto;">
		<s:iterator value="#session.entidadeSession.duplicataHistoricoEJBList" status="row">
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

<!-- divHistorico -->

<div class="divFiltroPaiTop">Contas a receber</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:130px;">
                <div class="divGrupoTitulo">Dados da duplicata</div>
                
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:400px;">
                        	<p style="width:100px;">Num duplicata:</p>
                        	<s:property value="#session.entidadeSession.numDuplicata"/> -
                        	<s:property value="#session.entidadeSession.numParcelas"/> -  
                        	<s:property value="#session.entidadeSession.ano"/>
                    	</div>
                </div>

                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:400px;">
                        	<p style="width:100px;">Empresa:</p>
							<input type="text" value='<s:property value="entidade.empresaHotelEJB.empresaRedeEJB.nomeFantasia" />' name="empresa" id="empresa" size="50" maxlength="50"  onblur="getEmpresa(this)"/> 
							<s:hidden name="entidade.empresaHotelEJB.empresaRedeEJB.empresaEJB.idEmpresa" id="idEmpresa" />
							<input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"  />
                    	</div>
                </div>

				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" >
                    		<p style="width:100px;">Conta corrente:</p>
							<s:select list="contaCorrenteList" 
									  listKey="idContaCorrente"
									  cssStyle="width:250px;" 
									  name="entidade.contaCorrente.id"
									  id="contaCorrente" />
                    </div>
                    
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:200px;" ><p style="width:100px;">Dt. Emissão:</p>
						<s:property value="#session.entidadeSession.dataLancamento"/>
                    </div>
					<div class="divItemGrupo" style="width: 200px;">
					<p style="width: 100px;">Data vencimento:</p>
							<s:property value="#session.entidadeSession.dataLancamento"/>
							<input type="hidden" name="entidade.dataVencimento" value="<s:property value="#session.entidadeSession.dataLancamento"/>" />
				    </div>
					<div class="divItemGrupo" style="width: 220px;">
						<p style="width: 100px;">Prorrogado:</p>
						<s:textfield cssClass="dp" name="entidade.prorrogado" id="prorrogado" size="10" maxlength="10" onkeypress="mascara(this, data)"  onblur="dataValida(this)"/>
				    </div>
					<div class="divItemGrupo" style="width: 200px;">
					<p style="width: 100px;">Agrupar:</p>
							<s:property value="#session.entidadeSession.agrupar==\"S\"?\"Sim\":\"Não\""/>
							<input type="hidden" name="entidade.agrupar" value="<s:property value="#session.entidadeSession.agrupar"/>" />
				    </div>
				</div>

          </div>
          <div class="divGrupo" style="height:160px;width:49%;">
                <div class="divGrupoTitulo">Valores/Taxas</div>
                
				<div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Valor líquido:</p>
							<label id="edValorLiquido"><s:property value="#session.entidadeSession.valorLiquido"/></label>
							<s:hidden name="entidade.valorDuplicata" id="valorDuplicata"  />                        	
                    	</div>
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:80px;">IRRF:</p>
							<s:textfield name="entidade.irRetencao" id="retencao" size="10" maxlength="10" onkeypress="mascara(this, moeda)" onblur="calcularValorDuplicata()" />                        	
                    	</div>
				</div>
				
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Desp. Financ.:</p>
							<s:property value="#session.entidadeSession.despFinanceira"/>
							<s:hidden name="entidade.despFinanceira" id="despFinanceira"  />                        	
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
							<s:textfield name="entidade.pis" id="pis" size="10" maxlength="10" onkeypress="mascara(this, moeda)" onblur="calcularValorDuplicata()" />                        	
                    	</div>
                    	
                </div>
				
				
				<div class="divLinhaCadastro">
				
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Ajustes:</p>
							<s:textfield name="entidade.descontoRecebimento" id="ajustes" size="10" maxlength="10" onkeypress="mascara(this, moeda)" onblur="verificarAjuste();calcularValorDuplicata();"  />                        	
                    	</div>
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:80px;">CSSL:</p>
							<s:textfield name="entidade.cssl" id="cssl" size="10" maxlength="10" onkeypress="mascara(this, moeda)" onblur="calcularValorDuplicata()"  />                        	
                    	</div>
                    	
                </div>
                
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Recebido:</p>
							<label id="edValorRecebido"></label>
                    	</div>
                       <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:80px;">ISS:</p>
							<s:textfield name="entidade.iss" id="iss" size="10" maxlength="10" onkeypress="mascara(this, moeda)" onblur="calcularValorDuplicata()"  />                        	
                    	</div>
				</div>
                
          </div>

			<div class="divGrupo" style="height:160px;width:49%;">
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
	                        <div class="divItemGrupo" style="width:300px; ">
	                        	<p style="width:50px;">Conta:</p>
	                        	<s:select   list="planoContaList" id="pc2" onchange="ajustaPC(this.value)"
		                        			cssStyle="width:230px"
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
		                        			cssStyle="width:370px"
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
								<s:textfield name="entidade.historicoComplementar" cssStyle="width:370px" id="justificaAjuste" maxlength="50" onblur="toUpperCase(this)"  />                        	
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
	                        	<p style="width:80px;">Número:</p>
								<s:textfield name="entidadeHistorico.numeroForma" id="numeroForma" size="20" maxlength="50" />
	                    	</div>
	                        <div class="divItemGrupo" style="width:40px;">
								<img src="imagens/iconic/png/magnifying-glass-3x.png" title="Mostrar histórico" onclick="showModal('#divHistorico');" />
	                    	</div>
	                </div>
					<div class="divLinhaCadastro">
	                        <div class="divItemGrupo" style="width:100%;">
	                        	<p style="width:100px;">Observação:</p>
								<s:textfield name="entidadeHistorico.observacoes" id="numeroForma" size="150" maxlength="500" onblur="toUpperCase(this)"   /> 	
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
	verificarAjuste();
	 calcularValorDuplicata();
</script>