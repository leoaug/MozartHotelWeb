<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

			$('#linhaTesouraria').css('display','block');           
    
			function cancelar(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="pesquisarTesouraria!prepararPesquisa.action" namespace="/app/financeiro" />';
				submitForm( vForm );
			}

            
            function gravar(){
				if (toFloat($('#totalGeral').text()) != 0.0 ){
					alerta("Os valores de 'Débito' e 'Crédito' não conferem");
					return false;	
				}
				
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

<s:form  action="manterTesouraria!gravar.action" theme="simple" namespace="/app/financeiro">
<s:hidden name="origemMovimento" value="TESOURARIA"/>
<div class="divFiltroPaiTop">Tesouraria</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;height:200%;" >

		<!--Inicio padrao-->
           <div id="divReservaApartamento" class="divGrupo" style="width:99%; height:50px;">
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
			</div>
		
          <!--Inicio dados lancamento-->
           <div id="divReservaApartamento" class="divGrupo" style="width:99%; height:350px;">
             <div class="divGrupoTitulo" style="float:left;">Lançamentos</div>
              
             <iframe width="100%" height="300" id="idLancamentoFrame" scrolling="no" frameborder="0" marginheight="0" marginwidth="0" 
             		 src="<s:url value="app/financeiro/includeTesouraria!prepararLancamento.action"/>?time=<%=new java.util.Date()%>"  ></iframe> 

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
              
           <div class="divCadastroBotoes">
                  <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                  <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
           </div>
              
        </div>
</div>
</s:form>
