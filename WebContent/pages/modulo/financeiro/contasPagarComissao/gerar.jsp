<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
	$('#linhaContasPagar').css('display','block');           
	
	function cancelar(){
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarContasPagarComissao!prepararPesquisa.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	}

	function gerar(){
    	if( $("input:checkbox[class='chk'][checked='true']").length == 0){
			alerta("Selecione pelo menos UMA Comissão a gerar.");
			return false;
		}
	    submitForm(document.forms[0]);
	}

	function unificar(){

    	if( $("input:checkbox[class='chk'][checked='true']").length == 0){
			alerta("Selecione pelo menos UMA Comissão para unificar.");
			return false;
		}
		
		//checar se os itens selecionados sao do mesmo fornecedor

		var idEmpresa = null;

		var chk = $(".chk");
		for(i = 0; i < chk.length; i++){
			if(chk[i].checked){
				if(idEmpresa == null){
					idEmpresa = $(".idEmpresa")[i].value;
				}else if(idEmpresa != $(".idEmpresa")[i].value){
					alerta("Só é possível unificar Comissões do mesmo Fornecedor!");
					return false;
				}		
			}
		}
		vForm = document.forms[0];
		vForm.action = '<s:url action="unificarContasPagarComissao!unificarContasPagarComissao.action" namespace="/app/financeiro" />';
		submitForm( vForm );
	    submitForm(document.forms[0]);
	}
			 
	$(function() {
    	$(".chkTodos").click(
			function() { 
			    newValue = this.checked;
			    $(".chk").attr('checked',newValue);
			}
    	);
	});	

</script>

<s:form  action="gerarContasPagarComissao!gerarContasPagarComissao.action" theme="simple" namespace="/app/financeiro">
	
	<div class="divFiltroPaiTop">Contas a pagar</div>
	<div class="divFiltroPai" >        
	    <div class="divCadastro" style="overflow:auto;" >
	        <div class="divGrupo" style="height:430px;">	            
	            <div class="divGrupoTitulo">
	            	Comissão a pagar
	            </div>
	         
	            <div class="divLinhaCadastro" style="height:400px;overflow: auto;">
					
	                <div style="width:110%; height:250%; border: 0px solid black; ">
						<div class="divLinhaCadastro" style="background-color:white;">
							<div class="divItemGrupo" style="border-right:1px solid white;width:30px;background-color:  #06F; color:  #FFF;">
		                       	<input type="checkbox" class="chkTodos"/>
		                   	</div>
							<div class="divItemGrupo" style="border-right:1px solid white;width:100px;background-color:  #06F; color:  #FFF;">
		                       	Hotel
		                   	</div>
		                    <div class="divItemGrupo" style="border-right:1px solid white;width:170px;background-color:  #06F; color:  #FFF;">
		                       	Fornecedor
		                   	</div>
		               		<div class="divItemGrupo" style="border-right:1px solid white;width:100px;background-color:  #06F; color:  #FFF;">
		                       	Título
		                   	</div>
		                   	<div class="divItemGrupo" style="border-right:1px solid white;width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
		                       	Dt.Saída
		                   	</div>
		                   	<div class="divItemGrupo" style="border-right:1px solid white;width:100px; text-align:center;background-color:  #06F; color:  #FFF;">
		                       	Vr.Diária
		                   	</div>
		                   	<div class="divItemGrupo" style="border-right:1px solid white;width:100px; text-align:center;background-color:  #06F; color:  #FFF;">
		                       	% Comissão
		                   	</div>
		                   	<div class="divItemGrupo" style="border-right:1px solid white;width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
		                       	Vr.Comiss
		                   	</div>
		                   	<div class="divItemGrupo" style="border-right:1px solid white;width:200px; text-align:right;background-color:  #06F; color:  #FFF;">
		                       	Hospede
		                   	</div>
		                </div>
		                <s:iterator value="#session.listaPesquisa" status="row">
		                	<div class="divLinhaCadastro" style="background-color:white;" id='divDup<s:property value="idNota"/>'>
								<div class="divItemGrupo" style="width:30px;border-right:1px solid black;">
									<input type="checkbox" value='<s:property value="idNota" />' name="idNota" class="chk"/>
									<input type="hidden" value="<s:property value="idEmpresa" />" class="idEmpresa"/>
								</div>
								<div class="divItemGrupo" style="width:100px;border-right:1px solid black;"><p style="width:100%;">
									<s:property value="sigla" /></p>
								</div>
								<div class="divItemGrupo" style="width:170px;border-right:1px solid black;"><p style="width:100%;" title='<s:property value="empresa" />'>
									<s:property value="nomeEmpresa.length()>20?nomeEmpresa.substring(0,20)+\"...\":nomeEmpresa" /></p>
								</div>
								<div class="divItemGrupo" style="width:100px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
									<s:property value="numNota"/></p>
								</div>
								<div class="divItemGrupo" style="width:100px;text-align:center;border-right:1px solid black;"><p style="width:100%;">
									<s:property value="dataSaida"/></p>
								</div>
								<div class="divItemGrupo" style="width:100px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
									<s:property value="valorDiaria"/></p>
								</div>
								<div class="divItemGrupo" style="width:100px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
									<s:property value="comissao"/></p>
								</div>
								<div class="divItemGrupo" style="width:100px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
									<s:property value="valorComissao"/></p>
								</div>
								<div class="divItemGrupo" style="width:200px;border-right:1px solid black;"><p style="width:100%;">
									<s:property value="nomeHospede"/></p>
								</div>		                
		                	</div>
		                </s:iterator>
					</div>
				</div>
			</div>
			<div class="divCadastroBotoes" style="width:50%;float:right;">
				<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
				<duques:botao label="Gerar" imagem="imagens/iconic/png/check-4x.png" onClick="gerar()" />
				<duques:botao label="Unificar" imagem="imagens/iconic/png/check-4x.png" onClick="unificar()" />
			</div>
        </div>
	</div>
</s:form>