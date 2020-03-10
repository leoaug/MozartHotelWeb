<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<link rel="stylesheet" type="text/css" href="js/autocomplete/jquery.autocomplete.css" />
<script src="js/autocomplete/jquery.autocomplete.js" type='text/javascript'></script>
 
<script type="text/javascript">


	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarApiGeral!prepararPesquisa.action" namespace="/app/sistema" />';
		submitForm(vForm);
	}


	function gerarToken(elemento){

		$.ajax({
			type : "GET",
			url : "${sessionScope.URL_BASE}app/ajax/ajax!gerarToken?OBJ_VALUE="+elemento.value,
			success : function(retorno) {
				$("#idTokenEntidade").val (retorno);	
			},
			error : function(retorno) {
				alert("Erro ao gerar token!!");
			}
		});
		
	}

	function getTipoLancamentoReceitaERecebimento(elemento) {

		$.ajax({
			type : "GET",
			url : "${sessionScope.URL_BASE}app/ajax/ajax!getTipoLancamentoReceitaERecebimento?OBJ_VALUE="+elemento.value,
			success : function(retorno) {
				killLoading();
				$("#idDivLancamentoReceitaRecebimento").html(retorno);
				
			},
			error : function(retorno) {
				//alert("Erro ao gerar token!!");
			}
		});

		
		
	}

	
	function selecionarComboReceita(elemento){

		$.ajax({
			type : "GET",
			url : "${sessionScope.URL_BASE}app/ajax/ajax!selecionarComboReceita?OBJ_VALUE="+elemento.value,
			success : function(retorno) {
				killLoading();	
				$("#idDivSelectReceita").html(retorno);
				
			},
			error : function(retorno) {
				//alert("Erro ao gerar token!!");
			}
		});
		
	}

	function selecionarComboRecebimento(elemento){

		$.ajax({
			type : "GET",
			url : "${sessionScope.URL_BASE}app/ajax/ajax!selecionarComboRecebimento?OBJ_VALUE="+elemento.value,
			success : function(retorno) {
				killLoading();	
				$("#idDivSelectRecebimento").html(retorno);
				
			},
			error : function(retorno) {
				//alert("Erro ao gerar token!!");
			}
		});
	}

	
	$(document).ready(function() {
		//$("#nomeEmpresaSite").autocomplete("${sessionScope.URL_BASE}app/ajax/ajax!consultarEmpresaPorRazaoSocialLike");

		$("#nomeEmpresaSite").autocomplete("${sessionScope.URL_BASE}app/ajax/ajax!consultarEmpresaPorRazaoSocialLike", {
			width: 240,
			minLength: 4,
			autoFocus: true, 
			open: function( event, ui ) {
				killLoading();
			},			
			search : function( event, ui ) {
				loading();
			},
			selectFirst: true
		});
	});


	function gravar() {

		
		if ( $("input[name='entidade.empresa.razaoSocialCGC']").val() == '') {
			alerta('Campo "Empresa Site" é obrigatório.');
			return false;
		}
		if ( $("input[name='entidade.nome']").val() == '') {
			alerta('Campo "Nome" é obrigatório.');
			return false;
		}
		if ( $("input[name='entidade.token']").val() == '') {
			alerta('Campo "Token" é obrigatório.');
			return false;
		}
		if ( $("input[name='entidade.url']").val() == '') {
			alerta('Campo "Url" é obrigatório.');
			return false;
		}
		
		

		vForm = document.forms[0];
		vForm.action = '<s:url action="manterApiGeral!gravarApiGeral.action" namespace="/app/sistema" />';
		submitForm(vForm);

	}

	function setValue(name, valor) {
		$("input[name='" + name + "']").val(valor);
	}
</script>


<s:form namespace="/app/sistema"
	action="manterApiGeral!gravarApiGeral.action" theme="simple">
	
	<s:hidden name="entidade.idApiGeral" />
	<div class="divFiltroPaiTop">API </div>
	<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              
              <!-- API - Geral -->
              <div class="divGrupo" style="height:140px;">
	                <div class="divGrupoTitulo">API - Geral</div>
	
	
	                <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:600px;" >
	                    		<p style="width:150px;">Nome:</p> 
	                        	<s:textfield  name="entidade.nome" 
	                        				  cssStyle="background-color: #C3C3C3;color: black;" 
	                        				  value="GERAL" 
	                        				  readonly="true" 
	                        				  disabled="true"
	                        				  size="65" 
	                        				  onkeypress="toUpperCase(this)" />
	                    </div>
	                </div>
	
	
	                <div class="divLinhaCadastro">
	                      <div class="divItemGrupo" style="width:600px;" >  
	                       		<p style="width:150px;">Empresa Site:</p> 
	                        	
	                        	<s:textfield name="entidade.empresa.razaoSocialCGC" placeholder="Ex: Digitar Nome ou CNPJ"
	                        				 id="nomeEmpresaSite"  
	                        				 size="65"   
	                        				 />
	                        				 
	                      </div> 
	                       <div class="divItemGrupo" style="width:300px;">
		                        <p style="width:80px;">Ativo:</p>
		                        
		                        <s:select list="ativoList" 
											cssStyle="width:80px;height:18px;"
											name="entidade.ativo" 
											id="ativo" 
											listKey="id" 
											listValue="value" /> 
								                   
	                    </div>
	                </div>
	
					 <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:600px;" >
	                    		<p style="width:150px;">Url:</p> 
	                        	<s:textfield  name="entidade.url"  
	                        				  size="65" 
	                        				  onkeypress="toUpperCase(this)" 
	                        				  placeholder="Ex: Digitar a url de Acesso" />
	                    </div>
	                </div>
	
					 <div class="divLinhaCadastro">
					 		 <div class="divItemGrupo" style="width:600px;" >  
	                       		<p style="width:150px;">Palavra:</p> 
	                        	<s:textfield  name="entidade.palavra" 
	                        				  size="65" 
	                        				  onblur="gerarToken(this)" />
	                      	</div> 
	                      	
	                      	 <div class="divItemGrupo" style="width:600px;" >  
	                       		<p style="width:80px;">Token Gerado:</p> 
	                        	<s:textfield  name="entidade.token" 
	                        				  id="idTokenEntidade" 
	                        				  cssStyle="background-color: #C3C3C3;color: black;"
	                        				  readonly="true"  
	                        				  size="65" />
	                      	</div> 
					 </div>
	
			 </div>
			
			<!-- API - Contrato -->
        	 <div class="divGrupo" style="height:130px;">
	                <div class="divGrupoTitulo">API - Contrato</div>
	                
	                 <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:600px;" >
	                    		<p style="width:150px;">Nome:</p> 
	                        	<s:textfield  name="apiContrato.nome" 
	                        				  cssStyle="background-color: #C3C3C3;color: black;" 
	                        				  value="CONTRATO" 
	                        				  readonly="true" 
	                        				  disabled="true" 
	                        				  size="65" 
	                        				  onkeypress="toUpperCase(this)" />
	                    </div>
	                    
	                    <div class="divItemGrupo" style="width:300px;" >  
	                    		<p style="width:80px;">Ativo:</p>
		                        
		                        <s:select list="ativoList" 
											cssStyle="width:80px;height:18px;"
											name="apiContrato.ativo" 
											id="ativo" 
											listKey="id" 
											listValue="value" /> 
	                    </div>
	                    
	                 </div>
	                
	                 <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:600px;" >
	                    		<p style="width:150px;">Nome Fantasia:</p> 	                    		
	                        	<s:select list="listaHoteis" headerKey="0" headerValue="Selecione"
									  cssStyle="width:350px"  
									  name="apiContrato.hotel.idHotel"
									  listKey="idHotel"
									  listValue="nomeFantasia" 
									  onchange="getTipoLancamentoReceitaERecebimento(this);loading()" /> 
	                        	
	                    </div>
	                </div>
	                
	                <!-- Sera dinamicamente mudado do nchange getTipoLancamentoReceitaERecebimento() na classe MozartHotelAjax.getTipoLancamentoReceitaERecebimento -->
	                 <div id="idDivLancamentoReceitaRecebimento" style="height:200px;">
	                    
	                    <div id="idDivSelectReceita" class="divLinhaCadastro">
	                    	<div class="divItemGrupo" style="width:600px;" >
	                    		
	                    		<p style="width:150px;">Tipo Lançamento receita:</p>
	                    		<s:select list="listaReceita" id="idSelectReceita" headerKey="-1" headerValue="Selecione"
									  cssStyle="width:350px"  
									  name="apiContrato.idTipoLancamento"
									  listKey="idTipoLancamento"
									  listValue="descricaoLancamento" 
									  onchange="selecionarComboReceita(this);loading()"/> 
	                    	</div>
	                 	 </div>
	                 	 <div id="idDivSelectRecebimento" class="divLinhaCadastro">
		                    <div class="divItemGrupo" style="width:600px;" >
		                    	
		                    	  
		                    	<p style="width:150px;">Tipo Lançamento recebimento </p>
		                    	<s:select list="listaRecebimento" id="idSelectRecebimento" headerKey="-1" headerValue="Selecione"
										  cssStyle="width:350px"  
										  name="apiContrato.idTipoLancamentoCk"
										  listKey="idTipoLancamentoCk"
										  listValue="descricaoLancamento" 
										  onchange="selecionarComboRecebimento(this);"/> 
								
		                    	
		                    </div>
		                 </div>
	                 </div>
	                 
	                 
	                
	          </div>
	         
              <!-- API - Vendedor -->
              <div class="divGrupo" style="height:120px;">
	                <div class="divGrupoTitulo">API - Vendedor</div>
	                
	                  <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:600px;" >
	                    		<p style="width:150px;">Nome:</p> 
	                        	<s:textfield  name="apiVendedor.nome" 
	                        				  cssStyle="background-color: #C3C3C3;color: black;" 
	                        				  value="VENDEDOR" 
	                        				  readonly="true" 
	                        				  disabled="true" 
	                        				  size="65" 
	                        				  onkeypress="toUpperCase(this)" />
	                    </div>
	                    
	                    <div class="divItemGrupo" style="width:300px;" >  
	                    		<p style="width:80px;">Ativo:</p>
		                        
		                        <s:select list="ativoList" 
											cssStyle="width:80px;height:18px;"
											name="apiVendedor.ativo" 
											id="ativo" 
											listKey="id" 
											listValue="value" /> 
	                    </div>
	                    
	                 </div>
	                 
	                  <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:600px;" >
	                    		<p style="width:150px;">Nome Fantasia:</p> 	                    		
	                        	<s:select list="listaHoteis" 
									  cssStyle="width:350px"  
									  name="apiVendedor.hotel.idHotel"
									  listKey="idHotel"
									  listValue="nomeFantasia" /> 
	                        	
	                    </div>
	                </div>
	                
	         </div> 
              
        </div>
        
        
        <div class="divCadastroBotoes">
               <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
               <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
              
        </div>
  </div>


</s:form>