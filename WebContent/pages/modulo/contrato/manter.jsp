<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

window.onload = function() {
	calcularValorTotal();
};

function cancelar(){
  	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisar!prepararCadastroContratos.action" namespace="/App/contrato" />';
	submitForm(vForm);
}

function getEmpresa(elemento){
    url = 'app/ajax/ajax!selecionarEmpresa?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idEmpresa';
    getDataLookup(elemento, url,'Empresa','TABLE');
}

function obterComplementoEmpresa(){
}

function exibePagamento(valorContaFaturamento){
	if(valorContaFaturamento == 'F')
		$("#tipoLancamentoPagamentoDiv").show();
	else
		$("#tipoLancamentoPagamentoDiv").hide();
}


function calcularValorTotal() {
	if($('#quantidade').val() != '' 
			&& $('#valorUnitario').val() != ''){
		var valor = $('#valorUnitario').val();
		var valorFormatado = valor.replace('.','').replace(',','.');
		var qtdFormatado = $('#quantidade').val().replace(',','.');
		$('#valorTotal').val(moeda(numeros(arredondaFloat(valorFormatado*qtdFormatado).toString().replace(".",","))));
	}
}

function gravar(){

	if ($("input[name='entidade.empresa.id']").val() == ''){
              alerta('Campo "Cliente" é obrigatório.');
              return false;
          }

	if ($("input[name='entidade.dataInicio']").val() == ''){
              alerta('Campo "Data Início" é obrigatório.');
              return false;
          }
	
	if ($("input[name='entidade.dataFim']").val() == ''){
        alerta('Campo "Data Fim" é obrigatório.');
        return false;
    }
	
	if ($("input[name='entidade.tipoLancamentoEJB.idTipoLancamento']").val() == ''){
		alerta('Campo "Tipo Lançamento" é obrigatório.');
		return false;
	}

	if ($("input[name='entidade.diaFaturamento']").val() == ''){
		alerta('Campo "Dia do Faturamento" é obrigatório.');
		return false;
	}
	
	if ($("input[name='entidade.diaFaturamento']").val() > 31 && $("input[name='entidade.diaFaturamento']").val() < 1){
		alerta('Campo "Dia do Faturamento" deve estar entre 1 e 31.');
		return false;
	}
	
	if ($("input[name='entidade.quantidade']").val() == ''){
		alerta('Campo "Quantidade" é obrigatório.');
		return false;
	}
	
	if (toFloat($("input[name='entidade.quantidade']").val()) == 0.0){
		alerta('Campo "Quantidade" de ser maior que 0.');
		return false;
	}
	
	if ($("input[name='entidade.valorUnitario']").val() == ''){
		alerta('Campo "Quantidade" é obrigatório.');
		return false;
	}
	
	if (toFloat($("input[name='entidade.valorUnitario']").val()) == 0.0){
		alerta('Campo "Quantidade" de ser maior que 0.');
		return false;
	}

	if ($("input[name='entidade.iss']").val() == ''){
		alerta('Campo "ISS" é obrigatório.');
		return false;
	}

	if ($("input[name='entidade.taxaServico']").val() == ''){
		alerta('Campo "Taxa de Serviço" é obrigatório.');
		return false;
	}
	
	if ($("input[name='entidade.formaReajuste']").val() == ''){
		alerta('Campo "Forma de Reajuste" é obrigatório.');
		return false;
	}
	
	if ($("input[name='entidade.descricao']").val() == ''){
		alerta('Campo "Descrição do Serviço" é obrigatório.');
		return false;
	}
	
    submitForm(document.forms[0]);
}

</script>


<s:form namespace="/App/contrato" action="manter!gravarContrato.action" theme="simple">

<s:hidden name="entidade.id" />
<s:set value="%{#session.HOTEL_SESSION.idPrograma == 21}" var="isPrograma21" />

<div class="divFiltroPaiTop">Cadastro de Contrato</div>
<div class="divFiltroPai" >
        
       <div class="divCadastro" style="overflow:auto; height:450PX;" >      
              <div class="divGrupo" style="height:300px;">
                <div class="divGrupoTitulo">Dados</div>
                	
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Cancelado:</p>
						<s:select list="#session.LISTA_CONFIRMACAO" 
								  id="cancelado"
								  cssStyle="width:80px"
								  name="entidade.cancelado"
								  value="%{'N'}"
								  listKey="id"
								  listValue="value"> </s:select>
							
						</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 470px;">
							<p style="width: 100px;">Cliente</p>
							<s:textfield
								name="nomeCliente"
								id="nomeCliente" 
								size="50" 
								cssStyle="width: 350px;"
								maxlength="50"
								onblur="getEmpresa(this)" />
							<s:hidden name="entidade.empresaEJB.idEmpresa" id="idEmpresa" />
						</div>
						
						<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 70px;">Data Início</p>
						<s:textfield 
							name="entidade.dataInicio"
 							id="dataInicio" 
 							onblur="dataValida(this);"  
  							onkeypress="mascara(this, data);" 
  							size="12" 
  							maxlength="10"  
  							cssClass="dp" /> 
						</div>
						
						<div class="divItemGrupo" style="width: 200px;">
							<p style="width: 70px;">Data Fim</p>
							<s:textfield 
								name="entidade.dataFim"
	 							id="dataFim" 
	 							onblur="dataValida(this);"  
	  							onkeypress="mascara(this, data);" 
	  							size="12" 
	  							maxlength="10"  
	  							cssClass="dp" /> 
						</div>
						
						<div class="divItemGrupo" style="width:200px;"><p style="width:100px;">Dia do Faturamento:</p>
						<s:textfield id="diaFaturamento" 
									maxLength="2" 
									size="3"
									onkeypress="mascara(this, number);" 
									name="entidade.diaFaturamento"/>
							
						</div>
					</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:310px;" ><p style="width:100px;"><s:if test="isPrograma21">Receita</s:if><s:else>Tipo Lançamento:</s:else></p>
							  <s:select list="tipoLancamentoList" 
							  cssStyle="width:200px"  
							  name="entidade.tipoLancamentoEJB.idTipoLancamento"
							  listKey="idTipoLancamento"
							  listValue="%{subGrupoLancamento + ' - ' + grupoLancamento + ' - ' + descricaoLancamento}"
							  headerValue="Selecione"
							  headerKey=""> </s:select>
					</div>
					
					<s:if test="isPrograma21">
						<div class="divItemGrupo" style="width:250px;" ><p style="width:150px;">Conta Corrente ou Faturamento:</p>
						<s:select list="contaFaturamentoList" 
								  cssStyle="width:80px"  
								  id="contaFaturamento"
								  onchange="exibePagamento(this.value);"
								  name="contaFaturamento"
								  value="%{'F'}"
								  listKey="id"
								  listValue="value"> </s:select>
							
						</div>
						
						<div id="tipoLancamentoPagamentoDiv" class="divItemGrupo" style="width:310px;" ><p style="width:100px;">Pagamento:</p>
							  <s:select list="tipoLancamentoPagamentoList" 
							  cssStyle="width:200px"  
							  id="tipoLancamentoPagamentoId"
							  name="entidade.tipoLancamentoCkEJB.idTipoLancamento"
							  listKey="idTipoLancamento"
							  listValue="%{subGrupoLancamento + ' - ' + grupoLancamento + ' - ' + descricaoLancamento}"
							  headerValue="Selecione"
							  headerKey=""> </s:select>
						</div>
					</s:if>
			    </div>
			    
			    <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;"><p style="width:100px;">Quantidade:</p>
					<s:textfield id="quantidade" 
								maxLength="5" 
								size="6"
								onblur="calcularValorTotal();"
								onkeypress="mascara(this, number);"
								cssStyle="text-align: right;" 
								name="entidade.quantidade"/>
					</div>
					
					<div class="divItemGrupo" style="width:250px;"><p style="width:100px;">Valor Unitário:</p>
					<s:textfield id="valorUnitario" 
								maxLength="15" 
								onblur="calcularValorTotal();"
								onkeypress="mascara(this, moeda);"
								cssStyle="text-align: right;" 
								name="entidade.valorUnitario"/>
					</div>
					
					<div class="divItemGrupo" style="width:250px;"><p style="width:100px;">Valor Total:</p>
					<s:textfield id="valorTotal" 
								maxLength="15" 
								disabled="true"
							    readonly="true"
							    cssStyle="background-color:silver;"
								onkeypress="mascara(this, number);text-align: right;" 
								name="valorTotal"/>
					</div>
					
			    </div>
			    
			    <div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Cobra ISS:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  id="iss"
							  name="entidade.iss"
							  value="%{'N'}"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					<div class="divItemGrupo" style="width:250px;" ><p style="width:150px;">Taxa de Serviço:</p>
					<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  id="taxaServico"
							  name="entidade.taxaServico"
							  value="%{'N'}"
							  listKey="id"
							  listValue="value"> </s:select>
						
					</div>
					
					<s:if test="isPrograma21">
						<div class="divItemGrupo" style="width:250px;" ><p style="width:150px;">Crédito:</p>
						<s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:80px"  
								  id="empresaCredito"
								  name="empresaCredito"
								  value="%{'S'}"
								  listKey="id"
								  listValue="value"> </s:select>
							
						</div>
					</s:if>
			
				</div>
				
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width:600px;"><p style="width:150px;">Forma de Reajuste:</p>
					<s:textfield id="formaReajuste" 
								maxLength="50" 
								size="50"
								name="entidade.formaReajuste"/>
					</div>
				</div>
				
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width:600px;"><p style="width:150px;">Descrição do Serviço:</p>
					<s:textfield id="descricao" 
								size="50"
								maxLength="50" 
								name="entidade.descricao"/>
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
			 