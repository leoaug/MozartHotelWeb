<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
			$('#linhaFaturamento').css('display','block');
           
    
			function cancelar(){


				<s:if test="%{origemParcelamento == \"CR\"}">
					vForm = document.forms[0];
					vForm.action = '<s:url action="pesquisarContasReceber!prepararPesquisa.action" namespace="/app/financeiro" />';
					submitForm( vForm );
				</s:if>
				<s:else>
					vForm = document.forms[0];
					vForm.action = '<s:url action="pesquisarFaturamento!prepararPesquisa.action" namespace="/app/financeiro" />';
					submitForm( vForm );
				</s:else>
			}

			function dividirDuplicata(){

				if ($('#qtdeParcela').val()==''){
					alerta('O campo "Dividir em" é obrigatório.');
					return false;
				}
				if (parseInt($('#qtdeParcela').val(),10) <= 1){
					alerta('O campo "Dividir em" deve ser maior que 1.');
					return false;
				}

				
				vForm = document.forms[0];
				vForm.action = '<s:url action="parcelarFaturamento!dividirDuplicata.action" namespace="/app/financeiro" />';
				submitForm( vForm );
			}
		
			function atualizaValores(tipo){
			
				if (tipo == 'COMISSAO' || tipo == 'ALL'){
					var varTotal = 0;
					var valor;
					for(var x=0;x<$("input[name='comissao']").length;x++){
						valor = $("input[name='comissao']")[x].value;
						if (valor != '' && valor != null){
							varTotal += parseFloat( valor.replace(".","").replace(",",".") ); 
						}
					}
					var strValor = arredondaFloat(varTotal).toString().replace(".",",");
					$('#divTotalComissao').text( strValor );
					var comissao = $('#pComissao').text().replace(".","");
					if (comissao != strValor)
						$('#divTotalComissao').css('color','red' );
					else
						$('#divTotalComissao').css('color','green' );
				}
				if (tipo == 'ENCARGO' || tipo == 'ALL'){
					var varTotal = 0;
					var valor;
					for(var x=0;x<$("input[name='encargos']").length;x++){
						valor = $("input[name='encargos']")[x].value;
						if (valor != '' && valor != null){
							varTotal += parseFloat( valor.replace(".","").replace(",",".") ); 
						}
					}
					var strValor = arredondaFloat(varTotal).toString().replace(".",",");
					$('#divTotalEncargo').text( strValor );
					var comissao = $('#pEncargo').text().replace(".","");
					if (comissao != strValor)
						$('#divTotalEncargo').css('color','red' );
					else
						$('#divTotalEncargo').css('color','green' );
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
				if (tipo == 'IR' || tipo == 'ALL'){
					var varTotal = 0;
					var valor;
					for(var x=0;x<$("input[name='ir']").length;x++){
						valor = $("input[name='ir']")[x].value;
						if (valor != '' && valor != null){
							varTotal += parseFloat( valor.replace(".","").replace(",",".") ); 
						}
					}
					var strValor = arredondaFloat(varTotal).toString().replace(".",",");
					$('#divTotalIR').text( strValor );
					var comissao = $('#pIR').text().replace(".","");
					if (comissao != strValor)
						$('#divTotalIR').css('color','red' );
					else
						$('#divTotalIR').css('color','green' );
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
				
				
				if (Trim($('#pComissao').text()) != Trim($('#divTotalComissao').text())){
					alerta('Os valores das comissões não conferem');
					return false;
				}
				if (Trim($('#pEncargo').text()) != Trim($('#divTotalEncargo').text())){
					alerta('Os valores dos encargos não conferem');
					return false;
				}
				if (Trim($('#pAjuste').text()) != Trim($('#divTotalAjuste').text())){
					alerta('Os valores dos encargos não conferem');
					return false;
				}
				if (Trim($('#pIR').text()) != Trim($('#divTotalIR').text())){
					alerta('Os valores dos IRs não conferem');
					return false;
				}
				if (Trim($('#pValor').text().replace(".","")) != Trim($('#divTotal').text().replace(".",""))){
					alerta('Os valores das parcelas não conferem');
					return false;
				}
						
				<s:if test="%{origemParcelamento == \"CR\"}">
					vForm = document.forms[0];
					vForm.action = '<s:url action="manterContasReceber!gravarParcelamento.action" namespace="/app/financeiro" />';
					submitForm( vForm );
				</s:if>
				<s:else>
					vForm = document.forms[0];
					vForm.action = '<s:url action="parcelarFaturamento!gravarParcelamento.action" namespace="/app/financeiro" />';
					submitForm( vForm );
				</s:else>
            }



</script>


<s:form  action="parcelarFaturamento!gravarParcelamento.action" theme="simple" namespace="/app/financeiro">
<s:hidden name="origemParcelamento"/>
<s:hidden name="entidade.idDuplicata" />


<div class="divFiltroPaiTop">
				<s:if test="%{origemParcelamento == \"CR\"}">
					Contas a receber
				</s:if>
				<s:else>
					Faturamento
				</s:else>
				
</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:90px;">
                <div class="divGrupoTitulo">Dados da duplicata</div>
                
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Num Duplicata:</p>
                        	<s:property value="entidade.numDuplicata"/>
                    	</div>
                        
                        <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;">Dt. Emissão:</p>
							<s:property value="entidade.dataLancamento"/>
	                    </div>

                        <div class="divItemGrupo" style="width:350px;">
                        	<p style="width:80px;">Empresa:</p>
							<s:property value="entidade.empresaHotelEJB.empresaRedeEJB.nomeFantasia" /> 
                    	</div>
                </div>
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:200px;">
                        	<p style="width:100px;">Dt vcto:</p>
                        	<s:property value="entidade.dataVencimento"/>
                    	</div>
                        
                        <div class="divItemGrupo" style="width:180px;" ><p style="width:80px;" >Comissão:</p>
							<label id="pComissao"><s:property value="entidade.comissao"/></label>
	                    </div>

                        <div class="divItemGrupo" style="width:160px;" ><p style="width:80px;">Encargos:</p>
							<label id="pEncargo"><s:property value="entidade.encargos"/></label>
	                    </div>
                        <div class="divItemGrupo" style="width:120px;" ><p style="width:60px;">Ajustes:</p>
							<label id="pAjuste"><s:property value="entidade.ajustes"/></label>
	                    </div>
                        <div class="divItemGrupo" style="width:100px;" ><p style="width:50px;">IR:</p>
							<label id="pIR"><s:property value="entidade.ir"/></label>
	                    </div>
	                    
                        <div class="divItemGrupo" style="width:140px;" ><p style="width:60px;">Valor:</p>
							<label id="pValor"><s:property value="entidade.valorDuplicata"/></label>
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
                   			<img  src="imagens/iconic/png/check-4x.png" title="Dividir duplicata"  onclick="dividirDuplicata();" />
                    	</div>
                </div>

               <div class="divLinhaCadastro" style="background-color:white;">
                        <div class="divItemGrupo" style="width:70px;background-color:  #06F; color:  #FFF;">
                        	Parcela
                    	</div>
                        <div class="divItemGrupo" style="width:140px;background-color:  #06F; color:  #FFF;">
                        	Dt. vcto.
                    	</div>
                		<div class="divItemGrupo" style="width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Comissão
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Encargos
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Ajustes
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	I.R.
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Valor
                    	</div>
                </div>
                <div style="width:99%; height:230px; border: 0px solid black; overflow: auto;">
				
					<s:set name="totalComissao" value="%{0.0}" />
					<s:set name="totalEncargo" value="%{0.0}" />
					<s:set name="totalAjuste" value="%{0.0}" />
					<s:set name="totalIR" value="%{0.0}" />
					<s:set name="total" value="%{0.0}" />
					
					<s:iterator value="parcelas"  status="row" var="mov" > 
						
						<s:set name="totalComissao" value="%{#totalComissao + #mov.comissao }" />
						<s:set name="totalEncargo" value="%{#totalEncargo + #mov.encargos }" />
						<s:set name="totalAjuste" value="%{#totalAjuste + #mov.ajustes }" />
						<s:set name="totalIR" value="%{#totalIR + #mov.ir }" />
						<s:set name="total" value="%{#total + #mov.valorDuplicata }" />
						
		                <div class="divLinhaCadastro" style="background-color:white;">
		                        <div class="divItemGrupo" style="width:70px; text-align: center;" >
		                        	${row.index + 1}
		                    	</div>
		                        <div class="divItemGrupo" style="width:140px;">
		                        	<input class="dp" type="text" name="dataVencimento" id="dataVencimento${row.index}" value='<s:property value="dataVencimento"/>' maxlength="10" size="8" onkeypress="mascara(this, data)" onblur="dataValida(this)" />
		                    	</div>
		                        <div class="divItemGrupo" style="width:100px; text-align:right;">
		                        	<input type="text" name="comissao" id="comissao" value='<s:property value="comissao"/>' maxlength="10" size="8" onkeypress="mascara(this, moeda);" onkeyup="atualizaValores('COMISSAO');"  />
		                    	</div>
		                		<div class="divItemGrupo" style="width:100px; text-align:right;">
		                        	<input type="text" name="encargos" id="encargos" value='<s:property value="encargos"/>' maxlength="10" size="8" onkeypress="mascara(this, moeda)" onkeyup="atualizaValores('ENCARGO');" />
		                    	</div>
		                		<div class="divItemGrupo" style="width:100px; text-align:right;">
		                        	<input type="text" name="ajustes" id="ajustes" value='<s:property value="ajustes"/>' maxlength="10" size="8" onkeypress="mascara(this, moeda)"   onkeyup="atualizaValores('AJUSTE');"/>
		                    	</div>
		                		<div class="divItemGrupo" style="width:100px; text-align:right;">
		                        	<input type="text" name="ir" id="ir" value='<s:property value="ir"/>' maxlength="10" size="8" onkeypress="mascara(this, moeda)"   onkeyup="atualizaValores('IR');"/>
		                    	</div>
		                    	<div class="divItemGrupo" style="width:100px; text-align:right;">
		                        	<input type="text" name="valorDuplicata" id="valorDuplicata" value='<s:property value="valorDuplicata"/>' maxlength="10" size="8" onkeypress="mascara(this, moeda)"  onkeyup="atualizaValores('VALOR');" />
		                    	</div>
		                </div>
					</s:iterator>
				</div>
				
				<div class="divLinhaCadastro" >
                        <div class="divItemGrupo" style="width:210px; text-align:right;">
                        	Total:
                    	</div>
                		<div class="divItemGrupo" style="width:100px; text-align:right; color=<s:property value="#totalComissao != entidade.comissao?\"red\":\"green\"" />" id="divTotalComissao">
                        	<s:property value="#totalComissao" />
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;" id="divTotalEncargo">
                        	<s:property value="#totalEncargo" />
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;" id="divTotalAjuste">
                        	<s:property value="#totalAjuste" />
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;" id="divTotalIR">
                        	<s:property value="#totalIR" />
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