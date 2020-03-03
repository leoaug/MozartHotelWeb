<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

window.onload = function() {

	addPlaceHolder('planoContaFin.contaContabil');
};

function addPlaceHolder(classe) {
	document.getElementById(classe).setAttribute("placeholder",
			"ex.: digite conta reduzida, conta ou nome da conta");
}


$('#linhaClassificacaoContabilPadrao').css('display','block');       
    
			function cancelar(){
				<s:if test="%{#status.equals('alteracao')}">
				if(!validaLancamento()){
					return false;
                }
                </s:if>
				
				vForm = document.forms[0];
				vForm.action = '<s:url action="pesquisarClassificacaoContabilPadrao!prepararPesquisa.action" namespace="/app/contabilidade" />';
				submitForm( vForm );
			}

			function validaLancamento(){
				retorno = true;
				
				if($('#descricao').val() == ''){
					alerta("O campo 'Descrição' é de preenchimento obrigatório");
					return false;	
				}
				if (toFloat($('#totalDebito').text()) != 100.0){
					alerta("O percentual de 'Débito' deve totalizar 100,00 %");
					return false;	
				}
				if (toFloat($('#totalCredito').text()) != 100.0 ){
					alerta("O percentual de 'Crédito' deve totalizar 100,00 %");
					return false;	
				}
				if (toFloat($('#totalGeral').text()) != 0.0 ){
					alerta("Os valores de 'Débito' e 'Crédito' não conferem");
					return false;	
				}

				return retorno;
			}
			
            function gravar(){
            	if(!validaLancamento()){
					return false;
                }
					
            	document.getElementById('idLancamentoFrame').contentWindow.setDescricao( $('#descricao').val() );
            	document.getElementById('idLancamentoFrame').contentWindow.gravar();
            	$('#descricao').val('');
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
				$('#totalCredito').html(valorC +' %');
				$('#totalDebito').html(valorD  +' %');
				
				var unitario = parseFloat(  valorC.replace(".","").replace(",",".") ) -  
						   parseFloat(  valorD.replace(".","").replace(",",".") );
							
				$('#totalGeral').html(moeda(numeros(arredondaFloat(unitario).toString()))+' %');
				$('#totalGeral').css('color',unitario==0.0?'green':'red');
				
			}

			function reset(){
				atualizarTotal(0, 0);
				$('#descricao').val('');
				$('#valorLancamento').val('');
				$('#idClassificacaoContabil').val('');
				$('#planoContaFin.idPlanoContas').val('');
			}

        </script>

<s:form  action="manterClassificacaoContabilPadrao!gravar.action" theme="simple" namespace="/app/contabilidade">
<s:hidden name="totalCredito"/>
<s:hidden name="totalDebito"/>
<s:hidden name="diferenca"/>
<s:hidden name="status" id="status" />
<s:hidden name="origemMovimento" value="CONTABILIDADE"/>
<div class="divFiltroPaiTop">Classificação Padrão</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;height:200%;" >

		<!--Inicio padrao-->
           <div id="divReservaApartamento" class="divGrupo" style="width:99%; height:50px;">
             <div class="divGrupoTitulo" style="float:left;">Classificação Padrão</div>
          
				<div class="divLinhaCadastro" style="width:99%; float:left;  height: 20px;">
				 	
				 	<div class="divItemGrupo" style="width:300px;" ><p style="width: 70px;">Descrição:</p>
                   		<s:textfield name="descricao" id="descricao" onkeypress="" size="32"/>
                    </div>
                </div>
			</div>
		
          <!--Inicio dados lancamento-->
           <div id="divReservaApartamento" class="divGrupo" style="width:99%; height:350px;">
             <div class="divGrupoTitulo" style="float:left;">Lançamentos</div>
              
             <iframe width="100%" height="300" id="idLancamentoFrame" scrolling="no" frameborder="0" marginheight="0" marginwidth="0" 
             		 src="<s:url value="app/contabilidade/includeClassificacaoContabilPadrao!prepararLancamento.action"/>?time=<%=new java.util.Date()%>"  ></iframe> 

				<div class="divLinhaCadastro" style="width:99%; float:left;  height: 20px; text-align:center;">
                    <div class="divItemGrupo" style="width:220px;" >
						<div style="float:left; width:100px;">Débito:</div>
						<div id="totalDebito" style="text-align:right;width:100px;float:left;color:<s:property value="totalDebito.doubleValue()!=100?\"red\":\"green\""/>"><s:property value="totalDebito"/> %</div>
                    </div>
                    <div class="divItemGrupo" style="width:220px;" >
						<div style="float:left; width:100px;">Crédito:</div>
						<div id="totalCredito" style="text-align:right;width:100px;float:left;color:<s:property value="totalCredito.doubleValue()!=100?\"red\":\"green\""/>"><s:property value="totalCredito"/> %</div>
                    </div>
					<div class="divItemGrupo" style="width:220px;" >
						<div style="float:left; width:100px;">Diferença:</div>
						<div id="totalGeral" style="text-align:right;width:100x;float:left;color:<s:property value="diferenca.doubleValue()!=0.0?\"red\":\"green\""/>"><s:property value="diferenca"/> %</div>
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
