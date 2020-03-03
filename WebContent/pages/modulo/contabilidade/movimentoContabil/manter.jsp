<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

$('#linhaMovimentoContabil').css('display','block');       
    
			function cancelar(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="pesquisarMovimentoContabil!prepararPesquisa.action" namespace="/app/contabilidade" />';
				submitForm( vForm );
			}

            
            function gravar(){

            	<s:if test="%{status != \"alteracao\"}">
					if (toFloat($('#totalGeral').text()) != 0.0 ){
						alerta("Os valores de 'Débito' e 'Crédito' não conferem");
						return false;	
					}
				</s:if>

            	document.getElementById('idLancamentoFrame').contentWindow.setPlanoContaFinanceiro( $('#idPlanoContasFinanceiro').val() );
            	document.getElementById('idLancamentoFrame').contentWindow.gravar();
            }

			function atualizarDadosDefault( idClassificacaoPadrao ){
				if (idClassificacaoPadrao != ''){
					if ($('#valorLancamento').val()==''){
						alerta("O campo 'Valor' é obrigatório.");
						return false;
					}
					loading();
					document.getElementById('idLancamentoFrame').contentWindow.atualizarDadosDefault( $('#diaLancamento').val(), idClassificacaoPadrao,  $('#valorLancamento').val());
				}
			}
			
			function setSeqContabil(){
				document.getElementById('idLancamentoFrame').contentWindow.setSeqContabil($('#seqContabil').val());
			}

			function atualizarTotal( valorD, valorC ){
				$('#totalCredito').html(valorC);
				$('#totalDebito').html(valorD);
				
				var unitario = parseFloat(  valorC.replace(".","").replace(",",".") ) -  
						   parseFloat(  valorD.replace(".","").replace(",",".") );
							
				$('#totalGeral').html(moeda(numeros(arredondaFloat(unitario).toString())));
				$('#totalGeral').css('color',unitario==0.0?'green':'red');
				
			}

			function reset(){
				$('#valorLancamento').val('');
				$('#idClassificacaoContabil').val('');
				$('#idPlanoContasFinanceiro').val('');
			}

        </script>

<s:form  action="manterMovimentoContabil!gravar.action" theme="simple" namespace="/app/contabilidade">
<s:hidden name="saldoMovimento.totalCredito"/>
<s:hidden name="saldoMovimento.totalDebito"/>
<s:hidden name="saldoMovimento.diferenca"/>
<s:hidden name="status" id="status" />
<s:hidden name="origemMovimento" value="CONTABILIDADE"/>
<div class="divFiltroPaiTop">Movimento Contábil</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;height:200%;" >

		<!--Inicio padrao-->
           <div id="divReservaApartamento" class="divGrupo" style="width:99%; height:100px;">
             <div class="divGrupoTitulo" style="float:left;">Classificação padrão</div>
          
				<div class="divLinhaCadastro" style="width:99%; float:left;  height: 20px;">
				 	
				 	<div class="divItemGrupo" style="width:110px;" ><p style="width:40px;">Dia:</p>
                    
                   		 <s:select name="diaLancamento"
                   		 		   id="diaLancamento" 
								   cssStyle="width:60px;" 
								   list="diaLancamentoList"
								   listKey="id"
								   listValue="value"
						/>
                    
                    </div>
                    
                   <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Valor lçto:</p>
              			<s:textfield name="valorLancamento" id="valorLancamento" onkeypress="mascara(this, moeda)" maxlength="10" size="10" />
                    </div>
              
                    <div class="divItemGrupo" style="width:260px;" ><p style="width:100px;">Class. Padrão:</p>
                    
                   		 <s:select name="classificacaoPadrao" onchange="atualizarDadosDefault(this.value);"
                   		 		   id="idClassificacaoContabil" 
								   cssStyle="width:150px;" 
								   list="classificacaoPadraoList"
								   listKey="descricao"
								   listValue="descricao"
								   headerKey=""
								   headerValue="Selecione"/>
                    
                    </div>
                    <div class="divItemGrupo" style="width:395px;" ><p style="width:100px;">Conta. Finan.:</p>
						<s:select name="idPlanoContasFinanceiro" 
								  id="idPlanoContasFinanceiro"
								  cssStyle="width:280px;" 
								  list="planoContaFinanceiroList"
								  listKey="idPlanoContas"
								  headerKey=""
								  headerValue="Selecione"
						 />
                    </div>
                    
                </div>
                <div class="divLinhaCadastro" style="width:99%; float:left;  height: 20px;">
                	<s:if test="%{status == \"alteracao\"}">
						<div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Seq Contabil:</p>
 	              			<s:textfield name="seqContabil" id="seqContabil" onchange="setSeqContabil();" onkeypress="mascara(this, numeros)" maxlength="10" size="10" />
	                    </div>
					</s:if>
                </div>
			</div>
		
          <!--Inicio dados lancamento-->
           <div id="divReservaApartamento" class="divGrupo" style="width:99%; height:350px;">
             <div class="divGrupoTitulo" style="float:left;">Lançamentos</div>
              
             <iframe width="100%" height="300" id="idLancamentoFrame" scrolling="no" frameborder="0" marginheight="0" marginwidth="0" 
             		 src="<s:url value="app/contabilidade/includeMovimentoContabil!prepararLancamento.action"/>?time=<%=new java.util.Date()%>"  ></iframe> 

				<div class="divLinhaCadastro" style="width:99%; float:left;  height: 20px; text-align:center;">
                    <div class="divItemGrupo" style="width:220px;" >
						<div style="float:left; width:100px;">Crédito:</div>
						<div id="totalCredito" style="text-align:right;width:100px;float:left;color:<s:property value="saldoMovimento.diferenca.doubleValue()!=0.0?\"red\":\"green\""/>"><s:property value="saldoMovimento.totalCredito"/> </div>
                    </div>
                    <div class="divItemGrupo" style="width:220px;" >
						<div style="float:left; width:100px;">Débito:</div>
						<div id="totalDebito" style="text-align:right;width:100px;float:left;color:<s:property value="saldoMovimento.diferenca.doubleValue()!=0.0?\"red\":\"green\""/>"><s:property value="saldoMovimento.totalDebito"/> </div>
                    </div>
					<div class="divItemGrupo" style="width:220px;" >
						<div style="float:left; width:100px;">Diferença:</div>
						<div id="totalGeral" style="text-align:right;width:100px;float:left;color:<s:property value="saldoMovimento.diferenca.doubleValue()!=0.0?\"red\":\"green\""/>"><s:property value="saldoMovimento.diferenca"/> </div>
                    </div>
                </div>
                
           </div>
           <!--Fim dados lancamento-->
              
           <div class="divCadastroBotoes">
                  <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                  <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
           </div>
              
        </div>
</div>
</s:form>
