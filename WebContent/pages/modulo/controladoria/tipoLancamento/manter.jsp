<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">


            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarTipoLancamento.action" namespace="/app/controladoria" />';
        		submitForm(vForm);
            }
            function isRepasse(value){
				var excecoes = ["1","10","12","14"];
                if(value!=""){
            	 	 var chaveArray = value.split(";");
	                 idtfLanc = chaveArray[0];
	                 recCheckout = chaveArray[1];
	                 idtfLancPai = chaveArray[2];

	                 if( excecoes.indexOf(idtfLancPai) == -1 && recCheckout == 1 ){
			             $('#repasse').css('display', 'block' );
			         } else {
			             $('#repasse').css('display', 'none' );
					 }
                 }
			         $('#idIdentificaLancamentoHidden').val(idtfLanc);
            }
            
            function isDespFixa(value){
				var excecoes = ["10","12","14"];
				if(value!=""){
            	 	 var chaveArray = value.split(";");
	                 idtfLanc = chaveArray[0];
	                 recCheckout = chaveArray[1];
	                 idtfLancPai = chaveArray[2];
	                 if( excecoes.indexOf(idtfLancPai) == -1 && recCheckout == 1 ){
	                	 $('#despesas').css('display', 'block' );
			         } else{
	                	 $('#despesas').css('display', 'none' );
			         }
			         $('#idIdentificaLancamentoHidden').val(idtfLanc);
                }                
            }
            
            function gravar(){
                        
                
                if ($("input[name='entidade.grupoLancamento']").val() == ''){
                    alerta('Campo "Grupo" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.subGrupoLancamento']").val() == ''){
                    alerta('Campo "Sub-grupo" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.descricaoLancamento']").val() == ''){
                    alerta('Campo "Descrição" é obrigatório.');
                    return false;
                }
                if ($("#idIdentificaLancamento").val() == ''){
                    alerta('Campo "Identificação" é obrigatório.');
                    return false;
                } 
                var chaveArray = $("#idIdentificaLancamento").val().split(";");
                idtfLanc = chaveArray[0];
                if ((idtfLanc == '16' || idtfLanc == '17') && $("#contaCorrente").val() == ''){
                    alerta('Campo "Conta Corrente" é obrigatório.');
                    return false;
                }
                if ($("#repasse").val() == 'S' && $("#idEmpresa").val() == ''){
                    alerta('Campo "Empresa" é obrigatório quando o repasse for "Sim".');
                    return false;
                }

                if ($("#despesaFixa").val() == 'S' && $("#valorDespesaFixa").val() == ''){
                    alerta('Campo "Vl.Desp.Fixa" é obrigatório quando a Desp.Fixa for "Sim".');
                    return false;
                }
                
               submitForm(document.forms[0]);
            }


            function setPlanoContasFin(value, id){
				$('#idPlanoContasFin').val(value);
            }
			function validarEmpresa( repasse ){
				if ('N' == repasse){
					$('#empresa').val('');
					$('#idEmpresa').val('');
				}
			}
	  
            function obterIdentificaLancamento(){
                if ($('#subGrupoLancamento').val()==''){
						return false;
                } 
	            url = '${sessionScope.URL_BASE}app/ajax/ajax!obterIdentificaLancamento?grupo='+$('#grupoLancamento').val()+'&grupoOuSub='+($('#subGrupoLancamento').val()=='000'?'G':'S');
	    		preencherCombo('idIdentificaLancamento', url);     

            }   
	

            function obterSubGrupoLancamento(){
                if ($('#grupoLancamento').val()==''){
					return false;
            	} 
				loading();
	            url = 'obterSubGrupoLancamento?grupo='+$('#grupoLancamento').val();
	            submitFormAjax(url,true);
            }

	        function setSubGrupo(val){
					killModal();
					$('#subGrupoLancamento').val( val );
					if ( val == '000'){
						$('#subGrupoLancamento').attr( 'readonly','true' );
						$('#subGrupoLancamento').css( 'background-color','silver' );
		            	$('#idCartaoCredito1').css('display', 'none' );
		            	$('#idCartaoCredito2').css('display', 'none' );
		            	$('#idCartaoCredito3').css('display', 'none' );
		            	$('#divTipoApto').css('display', 'none' );
		            	$('#despesas').css('display', 'none' );
		            	$('#repasse').css('display', 'none' );
					}
             }

            function validaTipoApto( value ){
            	  var chaveArray = value.split(";");
                  idtfLanc = chaveArray[0];
            	$('#divTipoApto').css('display', (idtfLanc=='26'?'block':'none') );
             }

            function isCartaoCredito ( value ){
                var chaveArray = value.split(";");
                idtfLanc = chaveArray[0];
            	$('#idCartaoCredito1').css('display', (idtfLanc=='19'?'block':'none') );
            	$('#idCartaoCredito2').css('display', ((idtfLanc=='16'||idtfLanc=='17'||idtfLanc=='19')?'block':'none') );
            	$('#idCartaoCredito3').css('display', (idtfLanc=='19'?'block':'none') );
            	$('#divEcommerce').css('display', (idtfLanc=='19'?'block':'none') );
            }
 
            function getEmpresa(elemento,isCartao,idHidden){
                url = 'app/ajax/ajax!selecionarEmpresa?' +
                    'OBJ_NAME='+elemento.id +
                    '&OBJ_VALUE='+elemento.value +
                    '&OBJ_HIDDEN=' + idHidden +
                    '&IS_CARTAO='+isCartao
                    ;
                getDataLookup(elemento, url,'Empresa','TABLE');
            }
            function getContaCorrente(elemento,idHidden){
                url = 'app/ajax/ajax!selecionarContaCorrente?' +
                    'OBJ_NAME='+elemento.id +
                    '&OBJ_VALUE='+elemento.value +
                    '&OBJ_HIDDEN=' + idHidden;
                getDataLookup(elemento, url,'Empresa','TABLE');
            }

            function obterComplementoEmpresa(){}

			function sincronzaConta( obj ){
				clValue = $(obj).attr('class');
				$('.'+clValue).val ( obj.value );
			}
            
			window.onload = function() {
				if($('#idIdentificaLancamento').val() != null && $('#idIdentificaLancamento').val() != ''){
					validaTipoApto($('#idIdentificaLancamento').val()); 
					isCartaoCredito($('#idIdentificaLancamento').val()); 
					isRepasse($('#idIdentificaLancamento').val()); 
					isDespFixa($('#idIdentificaLancamento').val());
				}
			};
            
</script>

<s:form namespace="/app/controladoria" action="manterTipoLancamento!gravar.action" theme="simple">

<s:hidden name="entidade.idTipoLancamento" id="idTipoLancamento" />
<s:hidden name="entidade.idAliquota" />
<s:hidden name="entidade.classificacaoContabilEJB.idClassificacaoContabil" />

<div class="divFiltroPaiTop">Tipo Lançamento</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:240px; width:627px;">
                <div class="divGrupoTitulo">Tipo Lançamento</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:175px;" ><p style="width:100px;">Grupo:</p>
                    	<s:if test="%{entidade.idTipoLancamento == null}">
                    		<s:textfield onkeypress="mascara(this, numeros);$('#subGrupoLancamento').val('')" 
                    				cssStyle="width:65px" maxlength="2"  
                    				name="entidade.grupoLancamento"  
                    				id="grupoLancamento" size="5" 
                    				onblur="obterSubGrupoLancamento()" />
                    	</s:if>
                    	<s:else>
	                    	<s:property value="entidade.grupoLancamento"/>
	                    	<s:hidden name="entidade.grupoLancamento"   id="grupoLancamento" />
                    	</s:else>
                    </div>
                    <div class="divItemGrupo" style="width:175px;" ><p style="width:100px;">SubGrupo:</p>
                      	<s:if test="%{entidade.idTipoLancamento == null}">
                      		<s:if test="%{entidade.subGrupoLancamento.equals(\"000\")}">
								<s:textfield readonly="true" cssStyle="background-color: silver;width:65px;" onkeypress="mascara(this, numeros)" maxlength="3"  name="entidade.subGrupoLancamento" id="subGrupoLancamento" size="5" onblur="obterIdentificaLancamento()"/>
                      		</s:if>
                      		<s:else>
								<s:textfield onkeypress="mascara(this, numeros)" maxlength="3" cssStyle="width:65px"  name="entidade.subGrupoLancamento" id="subGrupoLancamento" size="5" onblur="obterIdentificaLancamento()"/>
                      		</s:else>
                    	</s:if>
                    	<s:else>
	                    	<s:property value="entidade.subGrupoLancamento"/>
	                    	<s:hidden name="entidade.subGrupoLancamento"   id="subGrupoLancamento" />
                    	</s:else>
                    </div>
			<div class="divItemGrupo" style="width:265px;" ><p style="width:80px;">D/C:</p>
								<s:select list="debitoCreditoList" 
								  cssStyle="width:125px"  
								  name="entidade.debitoCredito"
								  listKey="id"
								  listValue="value"
								  id="debitoCredito"/>
			</div>
                </div>
             
             	<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100px;">Descrição:</p>
                        	<s:textfield onblur="toUpperCase(this)" cssStyle="width:240px"  name="entidade.descricaoLancamento"  id="descricaoLancamento" size="35" />
                    </div>
                    <div class="divItemGrupo" style="width:265px;" ><p style="width:80px;">Fantasia:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="6" cssStyle="width:121px"  name="entidade.fantasia"  id="fantasia" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
	               <div class="divItemGrupo" style="width:350px;" ><p style="width:100px;">Identificação:</p>
				   
						<s:if test="%{entidade.idTipoLancamento == null || !entidade.subGrupoLancamento.equals(\"000\")}">
                      		
                      			<s:select list="#session.identificaLancamentoList" 
								  cssStyle="width:245px"  
								  listKey="chave"
								  listValue="descricaoLancamento"
								  id="idIdentificaLancamento" 
								  name="selectedChave"
								  onchange='validaTipoApto(this.value); isCartaoCredito(this.value); isRepasse(this.value); isDespFixa(this.value);'/>
								  <s:hidden name="entidade.identificaLancamento.idIdentificaLancamento" id="idIdentificaLancamentoHidden" />
								  
                    	</s:if>
                    	<s:else>
	                    	<s:property value="entidade.identificaLancamento.descricaoLancamento"/>
	                    	<s:hidden name="entidade.identificaLancamento.idIdentificaLancamento" />
                    	</s:else>
						
						
					</div>
					
					<div class="divItemGrupo" id="divTipoApto" 
					style='width:265px; display:<s:property value="(new java.lang.Long(26).equals(entidade.identificaLancamento.idIdentificaLancamento)?\"block\":\"none\") "/>' >
								<p style="width:80px;">Tipo Apto:</p>
								<s:select list="tipoApartamentoList" 
								  cssStyle="width:125px"  
								  name="entidade.idTipoApartamento"
								  listKey="idTipoApartamento"
								  listValue="tipoApartamento"
								  id="idTipoApartamento"
								  headerKey=""
								  headerValue="Selecione" />
					</div>

					
				</div>
				<div class="divLinhaCadastro" id="idCartaoCredito1">
					<div class="divItemGrupo" style="width:175px;" ><p style="width:100px;">Bandeira:</p>
                       	<s:textfield onblur="toUpperCase(this)" cssStyle="width:60px"  name="entidade.bandeira"  id="bandeira" />
                   	</div>
                   	<div class="divItemGrupo" style="width:175px;" ><p style="width:100px;">Prazo:</p>
                       	<s:textfield onblur="toUpperCase(this)" cssStyle="width:65px"  name="entidade.prazo"  id="prazo" />
                   	</div>
                   	<div class="divItemGrupo" style="width:265px;" ><p style="width:80px;">Comissão:</p>
                       	<s:textfield onblur="toUpperCase(this)" cssStyle="width:121px"  name="entidade.comissao"  id="comissao"  />
                   	</div>
				</div>
				<div class="divLinhaCadastro" id="idCartaoCredito2">
					<div class="divItemGrupo" style="width:350px;" ><p style="width:100px;">Conta Corrente:</p>
                       	<s:textfield onblur="toUpperCase(this);getContaCorrente(this,'idContaCorrente');" cssStyle="width:240px"  name="contaCorrente"  id="contaCorrente" size="35" />
                       	<s:hidden name="entidade.contaCorrente"  id="idContaCorrente" />
                   	</div>
                   	<div class="divItemGrupo" id="divEcommerce" style="width:265px;" ><p style="width:80px;">E-Commerce:</p>
                   		<s:select list="#session.LISTA_CONFIRMACAO" id="eCommerce"
								  cssStyle="width:125px"  
								  name="entidade.eCommerce"
								  listKey="id"
								  listValue="value"/>
                       
                   	</div>
                </div>
				<div class="divLinhaCadastro" id="idCartaoCredito3">
                   	<div class="divItemGrupo" style="width: 350px;">
						<p style="width: 100px;">Empresa Cartão:</p>
						<s:textfield onblur="getEmpresa(this,'S', 'idCartaoCredito')" name="empresaCartao" cssStyle="width:240px"  maxlength="50" id="empresaCartao" /> 
						<s:hidden name="entidade.idCartaoCredito" id="idCartaoCredito" />
					</div>
                </div>
		<div class="divLinhaCadastro" id="despesas">
					<div class="divItemGrupo" style="width:175px;" ><p style="width:100px;">Desp Fixa:</p>
								<s:select list="#session.LISTA_CONFIRMACAO" id="despesaFixa"
								  cssStyle="width:65px"  
								  name="entidade.despesaFixa"
								  listKey="id"
								  listValue="value"/>
					</div>
					
                    <div class="divItemGrupo" style="width:175px;" ><p style="width:100px;">Vl.Desp.Fixa:</p>
						<s:textfield onkeypress="mascara(this, moeda)" maxlength="10" cssStyle="width:65px" name="entidade.valorDespFixa"   id="valorDespesaFixa" />
                    </div>

                    <div class="divItemGrupo" style="width:236px;" ><p style="width:80px;">TransWeb:</p>
						<s:textfield onkeypress="mascara(this, numeros)" maxlength="5"  cssStyle="width:121px" name="entidade.codTransacaoWeb"   id="codTransacaoWeb" />
                    </div>
					
		</div>


				
				<div class="divLinhaCadastro" id="repasse">
	               <div class="divItemGrupo" style="width:175px;" ><p style="width:100px;">Repasse:</p>
								<s:select list="#session.LISTA_CONFIRMACAO" onchange="validarEmpresa(this.value)"
								  id="repasse"	
								  cssStyle="width:65px"  
								  name="repasse"
								  listKey="id"
								  listValue="value"/>
					</div>
					<div class="divItemGrupo" style="width: 425px;">
						<p style="width: 100px;">Empresa:</p>
						<s:textfield onblur="getEmpresa(this,'','idEmpresa')" name="entidade.empresaHotelEJB.empresaRedeEJB.nomeFantasia" cssStyle="width:277px"  maxlength="50" id="empresa" /> 
						<s:hidden name="entidade.empresaHotelEJB.empresaRedeEJB.empresaEJB.idEmpresa" id="idEmpresa" />
					</div>
				</div>


				
				
			
				
				
				
				
			 </div>

              <div class="divGrupo" style="height:240px; width:35%;">
                <div class="divGrupoTitulo">Taxas</div>

                <div class="divLinhaCadastro">
	               <div class="divItemGrupo" style="width:200px;" >
					<p style="width:135px;">Incide PIS/Cofins:</p>
								<s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:60px"  
								  name="entidade.pis"
								  listKey="id"
								  listValue="value"
								  />
					</div>
		</div>

		<div class="divLinhaCadastro">


	               <div class="divItemGrupo" style="width:200px;" ><p style="width:135px;">Calcula ISS:</p>
								<s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:60px"  
								  name="entidade.iss"
								  listKey="id"
								  listValue="value"/>
					</div>
		</div>

                <div class="divLinhaCadastro">
	               <div class="divItemGrupo" style="width:200px;" ><p style="width:135px;">Calcula Taxa Serviço:</p>
								<s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:60px"  
								  name="entidade.taxaServico"
								  listKey="id"
								  listValue="value"
								  />
					</div>
		</div>

		<div class="divLinhaCadastro">


	               		<div class="divItemGrupo" style="width:200px;" ><p style="width:135px;">Calcula Room Tax:</p>
								<s:select list="#session.LISTA_CONFIRMACAO" 

								  cssStyle="width:60px"  
								  name="entidade.roomtax"
								  listKey="id"
								  listValue="value"/>
					</div>

			</div>

		<div class="divLinhaCadastro">

		
	       	        <div class="divItemGrupo" style="width:200px;" ><p style="width:135px;">Insere na NFS:</p>
								<s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:60px"  
								  name="entidade.notaFiscal"
								  listKey="id"
								  listValue="value"/>
					</div>
		</div>

		<div class="divLinhaCadastro">

				  <div class="divItemGrupo" style="width:200px;" ><p style="width:135px;">Calcula ISS na NFS:</p>
								<s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:60px"  
								  name="entidade.issNota"
								  listKey="id"
								  listValue="value"/>
					</div> 

		</div>



		</div>


              <div class="divGrupo" style="height:200px; width:627px;">
                <div class="divGrupoTitulo">Classificação contábil</div>

					<div class="divLinhaCadastro" >
						<div class="divItemGrupo" style="width:100%; background-color:  #06F;" >
								<p style="color:white;width:60px;">Débito</p>
						</div>
					</div>
					
					<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:365px;" ><p style="width:60px;">Conta:</p>
								<s:select name="entidade.classificacaoContabilEJB.planoContasDebito.idPlanoContas" 
										  cssClass="idPlanoContasDebito" id="idPlanoContas" onchange="sincronzaConta(this)" 
										  cssStyle="width:90px;" 
										  list="planoContasList"
										  listKey="idPlanoContas"
										  listValue="contaReduzida"
										  headerKey=""
										  headerValue="Selecione" />
										  
								<s:select name="idPlanoContaNome" cssClass="idPlanoContasDebito" id="idPlanoContasNome"  onchange="sincronzaConta(this)"
										  cssStyle="width:175px;" 
										  list="planoContasList"
										  listKey="idPlanoContas"
										  listValue="nomeConta" 
										  headerKey=""
										  headerValue="Selecione"/>
				  
		                    </div>
		                    
		                    <div class="divItemGrupo" style="width:250px;" ><p style="width:90px;">C.Custo:</p>
								<s:select name="entidade.classificacaoContabilEJB.centroCustoDebito.idCentroCustoContabil"  
										  cssStyle="width:150px;" 
										  list="centroCustoList"
										  listKey="idCentroCustoContabil"
										  listValue="descricaoCentroCusto" />
		                    </div>
					</div>

					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width:100%; background-color:  #06F;" >
								<p style="color:white;width:60px;">Crédito</p>
						</div>
					</div>
					
					<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:365px;" >
								<p style="width:60px;">Conta:</p>
								<s:select name="entidade.classificacaoContabilEJB.planoContasCredito.idPlanoContas" 
										  cssClass="idPlanoContasCredito" id="idPlanoContas" onchange="sincronzaConta(this)" 
										  cssStyle="width:90px;" 
										  list="planoContasList"
										  listKey="idPlanoContas"
										  listValue="contaReduzida"
										  headerKey=""
										  headerValue="Selecione" />
										  
								<s:select name="idPlanoContaNomeCredito" cssClass="idPlanoContasCredito" id="idPlanoContasNome"  onchange="sincronzaConta(this)"
										  cssStyle="width:175px;" 
										  list="planoContasList"
										  listKey="idPlanoContas"
										  listValue="nomeConta" 
										  headerKey=""
										  headerValue="Selecione"/>
				  
		                    </div>
		                    
		                    <div class="divItemGrupo" style="width:250px;" ><p style="width:90px;">C.Custo:</p>
								<s:select name="entidade.classificacaoContabilEJB.centroCustoCredito.idCentroCustoContabil"  
										  cssStyle="width:150px;" 
										  list="centroCustoList"
										  listKey="idCentroCustoContabil"
										  listValue="descricaoCentroCusto" />
		                    </div>
					</div>


		</div>




              <div class="divGrupo" style="height:200px; width:35%;">
                <div class="divGrupoTitulo">Financeiro</div>

			<div class="divLinhaCadastro">
	               		<div class="divItemGrupo" style="width:305px;" ><p style="width:100px;">PC Financ.:</p>
	               				<s:hidden name="entidade.classificacaoContabilEJB.planoContasFin.idPlanoContas" id="idPlanoContasFin"></s:hidden>
	               				
								<s:select list="planoContaFinanceiroList" 
								  cssStyle="width:200px"  
								  name="entidade.idPlanoContasFinanceiro"
								  listKey="idPlanoContas"
  								  headerKey=""
								  headerValue="Selecione"
								  onChange="setPlanoContasFin(this.value, 'idPlanoContasFin');"
								/>
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