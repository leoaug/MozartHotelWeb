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

			function dividirTitulo(){

				if ($('#qtdeParcela').val()==''){
					alerta('O campo "Dividir em" é obrigatório.');
					return false;
				}
				if (parseInt($('#qtdeParcela').val(),10) <= 1){
					alerta('O campo "Dividir em" deve ser maior que 1.');
					return false;
				}

				
				vForm = document.forms[0];
				vForm.action = '<s:url action="parcelarContasPagar!dividirTitulo.action" namespace="/app/financeiro" />';
				submitForm( vForm );
			}
		
			function atualizaValores(tipo){

				if (tipo == 'JUROS' || tipo == 'ALL'){
					var varTotal = 0;
					var valor;
					for(var x=0;x<$("input[name='encargos']").length;x++){
						valor = $("input[name='encargos']")[x].value;
						if (valor != '' && valor != null){
							varTotal += parseFloat( valor.replace(".","").replace(",",".") ); 
						}
					}
					var strValor = arredondaFloat(varTotal).toString().replace(".",",");
					$('#divTotalJuros').text( strValor );
					var comissao = $('#pJuros').text().replace(".","");
					if (comissao != strValor)
						$('#divTotalJuros').css('color','red' );
					else
						$('#divTotalJuros').css('color','green' );
				}
				
				if (tipo == 'AJUSTE' || tipo == 'ALL'){
					var varTotal = 0;
					var valor;
					for(var x=0;x<$("input[name='ajustes']").length;x++){
						valor = $("input[name='ajustes']")[x].value;
						if (valor != '' && valor != null){
							varTotal += parseFloat( valor.replace(".","").replace(",",".") ); 
						}
					}
					var strValor = arredondaFloat(varTotal).toString().replace(".",",");
					$('#divTotalAjuste').text( strValor );
					var comissao = $('#pAjuste').text().replace(".","");
					if (comissao != strValor)
						$('#divTotalAjuste').css('color','red' );
					else
						$('#divTotalAjuste').css('color','green' );
				}
				if (tipo == 'VALOR' || tipo == 'ALL'){
					var varTotal = 0;
					var valor;
					for(var x=0;x<$("input[name='valorDuplicata']").length;x++){
						valor = $("input[name='valorDuplicata']")[x].value;
						if (valor != '' && valor != null){
							varTotal += parseFloat( valor.replace(".","").replace(",",".") ); 
						}
					}
					var strValor = arredondaFloat(varTotal).toString().replace(".",",");
					$('#divTotal').text( strValor );
					var comissao = $('#pValor').text().replace(".","");
					if (comissao != strValor)
						$('#divTotal').css('color','red' );
					else
						$('#divTotal').css('color','green' );
				}

			}
		
			
            function gravar(){


            	if ($("input[type='text'][value!='']").length < $("input[type='text']").length){
					alerta("Os campos do 'Parcelamento' são obrigatórios.");
					return false;
				}
				
				if (parseFloat(  Trim($('#pJuros').text()).replace(".","").replace(",",".") ) !=
					parseFloat(  Trim($('#divTotalJuros').text()).replace(".","").replace(",",".") )){
					alerta('Os valores dos juros não conferem');
					return false;
				}
				
				
				if (parseFloat(  Trim($('#pAjuste').text()).replace(".","").replace(",",".") ) !=
					parseFloat(  Trim($('#divTotalAjuste').text()).replace(".","").replace(",",".") )){
					alerta('Os valores dos descontos não conferem');
					return false;
				}

				if (parseFloat(  Trim($('#pValor').text()).replace(".","").replace(",",".") ) !=
					parseFloat(  Trim($('#divTotal').text()).replace(".","").replace(",",".") )){
					
					alerta('Os valores das parcelas não conferem');
					return false;
				}

				vForm = document.forms[0];
				vForm.action = '<s:url action="parcelarContasPagar!gravarParcelamento.action" namespace="/app/financeiro" />';
				submitForm( vForm );
            }



</script>


<s:form  action="parcelarContasPagar!gravarParcelamento.action" theme="simple" namespace="/app/financeiro">
<s:hidden name="entidadeCP.idContasPagar" />


<div class="divFiltroPaiTop">

					Contas a pagar
</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:90px;">
                <div class="divGrupoTitulo">Dados do título</div>
                
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Num Título:</p>
                        	<s:property value="entidadeCP.numDocumento"/>
                    	</div>
                        
                        <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Dt. Emissão:</p>
							<s:property value="entidadeCP.dataLancamento"/>
	                    </div>

                        <div class="divItemGrupo" style="width:350px;">
                        	<p style="width:80px;">Fornecedor:</p>
							<s:property value="entidadeCP.fornecedorHotelEJB.fornecedorRedeEJB.nomeFantasia" /> 
                    	</div>
                </div>
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Dt vcto:</p>
                        	<s:property value="entidadeCP.dataVencimento"/>
                    	</div>

                        <div class="divItemGrupo" style="width:120px;" ><p style="width:60px;">Juros:</p>
							<label id="pJuros"><s:property value="entidadeCP.juros"/></label>
	                    </div>

                        <div class="divItemGrupo" style="width:120px;" ><p style="width:60px;">Desconto:</p>
							<label id="pAjuste"><s:property value="entidadeCP.desconto"/></label>
	                    </div>
	                    
                        <div class="divItemGrupo" style="width:140px;" ><p style="width:60px;">Valor:</p>
							<label id="pValor"><s:property value="entidadeCP.valorBruto"/></label>
	                    </div>
                </div>

          </div>
          <div class="divGrupo" style="height:350px;">
                <div class="divGrupoTitulo">Parcelamento</div>
                
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Dividir em:</p>
							<s:textfield name="qtdeParcela" id="qtdeParcela" maxlength="2" size="3" onkeypress="mascara(this, numeros)"  />
							parcelas                        	
                    	</div>
                        <div class="divItemGrupo" style="width:30px;" >
                   			<img  src="imagens/iconic/png/check-4x.png" title="Dividir título"  onclick="dividirTitulo();" />
                    	</div>
                </div>

               <div class="divLinhaCadastro" style="background-color:white;">
                        <div class="divItemGrupo" style="width:70px;background-color:  #06F; color:  #FFF;">
                        	Parcela
                    	</div>
                        <div class="divItemGrupo" style="width:140px;background-color:  #06F; color:  #FFF;">
                        	Dt. vcto.
                    	</div>
                        <div class="divItemGrupo" style="width:140px;background-color:  #06F; color:  #FFF;">
                        	Dt. prorrog.
                    	</div>

                    	<div class="divItemGrupo" style="width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Juros
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Desconto
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Valor
                    	</div>
                </div>
                <div style="width:99%; height:230px; border: 0px solid black; overflow: auto;">
				
					<s:set name="totalAjuste" value="%{0.0}" />
					<s:set name="totalJuros" value="%{0.0}" />
					<s:set name="total" value="%{0.0}" />
					
					<s:iterator value="parcelasCP"  status="row" var="mov" > 
						
						<s:set name="totalAjuste" value="%{#totalAjuste + #mov.desconto }" />
						<s:set name="total" value="%{#total + #mov.valorBruto }" />
						<s:set name="totalJuros" value="%{#totalJuros + #mov.juros }" />
						
						
		                <div class="divLinhaCadastro" style="background-color:white;">
		                        <div class="divItemGrupo" style="width:70px; text-align: center;" >
		                        	${row.index + 1}
		                    	</div>
		                        <div class="divItemGrupo" style="width:140px;">
		                        	<input class="dp" type="text" name="dataVencimento" id="dataVencimento${row.index}" value='<s:property value="dataVencimento"/>' maxlength="10" size="8" onkeypress="mascara(this, data)" onblur="dataValida(this)" />
		                    	</div>
		                        <div class="divItemGrupo" style="width:140px;">
		                        	<input class="dp" type="text" name="prorrogacao" id="prorrogacao${row.index}" value='<s:property value="prorrogacao"/>' maxlength="10" size="8" onkeypress="mascara(this, data)" onblur="dataValida(this)" />
		                    	</div>
		                    	<div class="divItemGrupo" style="width:100px; text-align:right;">
		                        	<input type="text" name="encargos" id="encargos" value='<s:property value="juros"/>' maxlength="10" size="8" onkeypress="mascara(this, moeda)"   onkeyup="atualizaValores('JUROS');"/>
		                    	</div>
		                		<div class="divItemGrupo" style="width:100px; text-align:right;">
		                        	<input type="text" name="ajustes" id="ajustes" value='<s:property value="desconto"/>' maxlength="10" size="8" onkeypress="mascara(this, moeda)"   onkeyup="atualizaValores('AJUSTE');"/>
		                    	</div>
		                    	<div class="divItemGrupo" style="width:100px; text-align:right;">
		                        	<input type="text" name="valorDuplicata" id="valorDuplicata" value='<s:property value="valorBruto"/>' maxlength="10" size="8" onkeypress="mascara(this, moeda)"  onkeyup="atualizaValores('VALOR');" />
		                    	</div>
		                </div>
					</s:iterator>
				</div>
				
				<div class="divLinhaCadastro" >
                        <div class="divItemGrupo" style="width:210px; text-align:right;">
                        	Total:
                    	</div>																 
                    	<div class="divItemGrupo" style="width:100px; text-align:right;" id="divTotalJuros">
                        	<s:property value="#totalJuros" />
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;" id="divTotalAjuste">
                        	<s:property value="#totalAjuste" />
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;" id="divTotal">
                        	<s:property value="#total" />
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
atualizaValores('ALL');
</script>