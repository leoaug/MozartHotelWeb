<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">

	$(document).ready(function() {
		habilitarTela('divDados');
	});

	window.onload = function() {
		addPlaceHolder('cidadeEmpresa');
		addPlaceHolder('cidadeCobranca');
	};
	
	function addPlaceHolder(classe) {
		document.getElementById(classe).setAttribute("placeholder",
				"ex.: Digitar o nome da Cidade");
	}
	
	function habilitarTela(value){
		$("#divDados").hide();
		$("#divDadosLegais").hide();
		
		$("#"+value).show();
	}

	function cancelar() {
		vForm = document.forms[0];
		vForm.action = '<s:url action="pesquisarApiGeral!prepararPesquisa.action" namespace="/app/sistema" />';
		submitForm(vForm);
	}

	function validarEmpresa(cnpj) {

		if (cnpj != '' && cnpj != null) {

			var cnpjcpfformatado = cnpj.replace(/[./-]/g,'');
			if ($("#opcoes").val() == '1'){
				$("input[name='entidade.cgc']").val(cnpjcpfformatado);
				$("input[name='empresaCpf']").val("");
			}
			else if ($("#opcoes").val() == '2')
			{
				$("input[name='entidade.cgc']").val(cnpjcpfformatado);
				$("input[name='empresaCnpj']").val("");
			}
			
			if ($("#opcoes").val() == '1' && !validarCNPJ(cnpjcpfformatado) ){
				alerta('Campo "CNPJ" é inválido.');
				return false;
			}
			else if ($("#opcoes").val() == '2' && !validarCPF(cnpjcpfformatado) ){
				alerta('Campo "CPF" é inválido.');
				return false;
			}

			vForm = document.forms[0];
			vForm.action = '<s:url action="manterEmpresa!validarEmpresa.action" namespace="/app/empresa" />';
			submitForm(vForm);
		}

	}

	function incluirReferencia() {

		if ($("input[name='nomeBanco']").val() == '') {
			alerta('Campo "Nome" é obrigatório.');
			return false;
		}
		if ($("input[name='contatoBanco']").val() == '') {
			alerta('Campo "Contato" é obrigatório.');
			return false;
		}
		if ($("input[name='telefoneBanco']").val() == '') {
			alerta('Campo "Telefone" é obrigatório.');
			return false;
		}

		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEmpresa!incluirReferencia.action" namespace="/app/empresa" />';
		submitForm(vForm);

	}

	function excluirReferencia(idx) {

		vForm = document.forms[0];
		vForm.indice.value = idx;
		vForm.action = '<s:url action="manterEmpresa!excluirReferencia.action" namespace="/app/empresa" />';
		submitForm(vForm);
	}

	function excluirSocio(idx) {

		vForm = document.forms[0];
		vForm.indice.value = idx;
		vForm.action = '<s:url action="manterEmpresa!excluirSocio.action" namespace="/app/empresa" />';
		submitForm(vForm);
	}

	function incluirSocio() {

		if ($("input[name='nomeSocio']").val() == '') {
			alerta('Campo "Nome" é obrigatório.');
			return false;
		}
		if ($("input[name='cpfSocio']").val() == '') {
			alerta('Campo "CPF" é obrigatório.');
			return false;
		}
		if ($("input[name='participacaoSocio']").val() == '') {
			alerta('Campo "Part. %" é obrigatório.');
			return false;
		}

		vForm = document.forms[0];
		vForm.action = '<s:url action="manterEmpresa!incluirSocio.action" namespace="/app/empresa" />';
		submitForm(vForm);
	}

	function getCidadeCobrancaLookup(elemento) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarCidade?OBJ_NAME='
				+ elemento.id
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=idCidadeCobranca';
		getDataLookup(elemento, url, 'divCobranca', 'TABLE');
	}

	function getCidadeEmpresaLookup(elemento) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarCidade?OBJ_NAME='
				+ elemento.id
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=idCidadeEmpresa';
		getDataLookup(elemento, url, 'divEmpresa', 'TABLE');
	}

	function getEmpresa(elemento) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarEmpresa?OBJ_NAME='
				+ elemento.id
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=idEmpresa';
		getDataLookup(elemento, url, 'Empresa', 'TABLE');
	}

	function obterComplementoEmpresa() {

	}

	function inverterDespesas() {
		valor = $("select[name='quemPagaSelecionado']").size();
		for (var x = 0; x < valor; x++) {
			novoValor = $("select[name='quemPagaSelecionado']").get(x).value == "E" ? "H"
					: "E";
			$("select[name='quemPagaSelecionado']").get(x).value = novoValor;
		}
	}

	function selecionarTarifa(idGrupo) {

		$("li.linhaTarifa").css('display', 'none');
		if (idGrupo == null || idGrupo == '') {
			$("li.linhaTarifa").css('display', 'block');
		} else {
			$("li[id$=';" + idGrupo + "']").css('display', 'block');
		}
	}

	function adicionarTarifa(obj) {
		arr = obj.id.split(';');
		//id;dtEntrada;dtSaida;descricao;idgrupo
		//year, month, date
		qtde = $("#tarifaDestino li").length;

		arrDT = arr[1].split('/');
		dataNova = new Date(arrDT[2], parseInt(arrDT[1], 10) - 1, arrDT[0]);
		arrDT = arr[2].split('/');
		dataFimNova = new Date(arrDT[2], parseInt(arrDT[1], 10) - 1, arrDT[0]);

		for (idx = 0; idx < qtde; idx++) {

			objLinha = $("#tarifaDestino li")[idx];
			arrLinha = objLinha.id.split(';');

			if (arrLinha[3] == arr[3]) {
				alerta('Tarifa já cadastrada.');
				return false;
			} else {

				arrDT = arrLinha[1].split('/');
				dataEntradaLinha = new Date(arrDT[2],
						parseInt(arrDT[1], 10) - 1, arrDT[0]);
				arrDT = arrLinha[2].split('/');
				dataSaidaLinha = new Date(arrDT[2], parseInt(arrDT[1], 10) - 1,
						arrDT[0]);

				if (dataNova >= dataEntradaLinha && dataNova <= dataSaidaLinha) {
					alerta('Conflito encontrado.');
					return false;
				}

				if (dataFimNova >= dataEntradaLinha
						&& dataFimNova <= dataSaidaLinha) {
					alerta('Conflito encontrado.');
					return false;
				}

				if (dataEntradaLinha >= dataNova
						&& dataEntradaLinha <= dataFimNova) {
					alerta('Conflito encontrado.');
					return false;
				}

				if (dataSaidaLinha >= dataNova && dataSaidaLinha <= dataFimNova) {
					alerta('Conflito encontrado.');
					return false;
				}

			}

		}

		loading();
		qtde = (qtde == 0 ? 1 : qtde);
		linha = "<li style='width: 100%; cursor: pointer; margin-bottom:2px;' ondblclick='removerTarifa(this);' id='"
				+ (qtde - 1)
				+ ";"
				+ arr[1]
				+ ";"
				+ arr[2]
				+ "'><p style='width:200px;float:left'>"
				+ arr[3]
				+ "</p><p style='width:80px;float:left'>&nbsp;"
				+ arr[1]
				+ "</p><p style='width:80px;float:left'>&nbsp;"
				+ arr[2]
				+ "</p></li>";
		$("#tarifaDestino").append(linha);
		submitFormAjax('empresaIncluirTarifa?indice=' + arr[0], true);

		//<li id="<s:property value="#linhaTarifa.index" />;<s:property value="tarifaEJB.dataEntrada" />;<s:property value="tarifaEJB.dataSaida" />"> 
		//<p style="width:100px;float:left"> <s:property value="tarifaEJB.descricao" /> </p> 
		//<p style="width:60px;float:left"><s:property value="tarifaEJB.dataEntrada" /></p> 
		//<p style="width:60px;float:left"><s:property value="tarifaEJB.dataSaida" /> </p> </li>

		//adicionar na sessao via ajax
	}

	function removerTarifa(obj) {
		arr = obj.id.split(';');
		loading();
		//id;dtEntrada;dtSaida;descricao;idgrupo
		$(obj).remove();

		submitFormAjax('empresaExcluirTarifa?indice=' + arr[0], true);
		//remover na sessao via ajax
	}

	function verificaCNPJCodigo(pNacional) {

		if (pNacional == "1") {
			$('#codEmpresa').val('');
			$('#cpfEmpresa').val('');
			$('#divCodigo').css('display', 'none');
			$('#divCPF').css('display', 'none');
			$('#divCNPJ').css('display', 'block');
		} 
		else if (pNacional == "2"){
			$('#cnpjEmpresa').val('');
			$('#codEmpresa').val('');
			$('#divCPF').css('display', 'block');
			$('#divCNPJ').css('display', 'none');
			$('#divCodigo').css('display', 'none');
		}
		else {
			$('#cnpjEmpresa').val('');
			$('#cpfEmpresa').val('');
			$('#divCodigo').css('display', 'block');
			$('#divCPF').css('display', 'none');
			$('#divCNPJ').css('display', 'none');
		}
	}
	
	function gravar() {

		// validacao da empresa
		if ($("#opcoes").val() == '1'
				&& $("input[name='entidade.cgc']").val() == '') {
			alerta('Campo "CNPJ" é obrigatório.');
			return false;
		}

		if ($("#opcoes").val() == '1'
				&& !validarCNPJ($("input[name='entidade.cgc']").val())) {
			alerta('Campo "CNPJ" é inválido.');
			return false;
		}
		
		if ($("#opcoes").val() == '2'
			&& $("input[name='entidade.cgc']").val() == '') {
			alerta('Campo "CPF" é obrigatório.');
			return false;
		}
	
		if ($("#opcoes").val() == '2'
				&& !validarCPF($("input[name='entidade.cgc']").val())) {
			alerta('Campo "CPF" é inválido.');
			return false;
		}

		if ($("#opcoes").val() == '3'
				&& $("input[name='entidade.codigo']").val() == '') {
			alerta('Campo "Código" é obrigatório.');
			return false;
		}
		if ( $("input[name='empresaRede.deadLine']").val() == '') {
			alerta('Campo "Dead Line" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.razaoSocial']").val() == '') {
			alerta('Campo "Razão Social" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.endereco']").val() == '') {
			alerta('Campo "Endereço" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.bairro']").val() == '') {
			alerta('Campo "Bairro" é obrigatório.');
			return false;
		}
		if ($("input[name='entidade.cep']").val() == '') {
			alerta('Campo "Cep" é obrigatório.');
			return false;
		}
		if (!validaCep($("input[name='entidade.cep']").val())) {
			alerta('"Cep" digitado é inválido');
			return false;
		}

		if ($("input[name='entidade.cidade.cidade']").val() == ''
				|| $("input[name='entidade.cidade.idCidade']").val() == '') {
			alerta('Campo "Cidade" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.inscEstadual']").val() == '') {
			alerta('Campo "Insc. Estadual" é obrigatório.');
			return false;
		}

		if ($("input[name='entidade.inscMunicipal']").val() == '') {
			//alerta('Campo "Insc. Municipal" é obrigatório.');
			//return false;
		}

		if ($("input[name='entidade.tipo']").val() == '') {
			//alerta('Campo "Tipo empresa" é obrigatório.');
			//return false;
		}

		// cobrança
		if ($("input[name='empresaRede.nomeFantasia']").val() == '') {
			alerta('Campo "Nome fantasia" é obrigatório.');
			return false;
		}

		if ($("input[name='empresaRede.enderecoCobranca']").val() == '') {
			alerta('Campo "Endereço de cobrança" é obrigatório.');
			return false;
		}

		if ($("input[name='empresaRede.bairro']").val() == '') {
			alerta('Campo "Bairro de cobrança" é obrigatório.');
			return false;
		}

		if ($("input[name='empresaRede.cep']").val() == '') {
			alerta('Campo "Cep de cobrança" é obrigatório.');
			return false;
		}

		if (!validaCep($("input[name='empresaRede.cep']").val())) {
			alerta('"Cep de cobrança" digitado é inválido');
			return false;
		}
		if ($("input[name='empresaRede.cidade.cidade']").val() == ''
				|| $("input[name='empresaRede.cidade.idCidade']").val() == '') {
			alerta('Campo "Cidade de cobrança" é obrigatório.');
			return false;
		}

		if ($("#empresaHotelidTipoEmpresa").val() == '') {
			alerta('Campo "Tipo empresa de cobrança" é obrigatório.');
			return false;
		}

		if ($("#empresaRedepromotorEJBidPromotor").val() == '') {
			alerta('Campo "Promotor" é obrigatório.');
			return false;
		}

		//contato
		if ($("input[name='empresaRede.contato']").val() == '') {
			alerta('Campo "Nome do contato" é obrigatório.');
			return false;
		}

		if ($("input[name='empresaRede.telefone']").val() == ''
				&& $("input[name='empresaRede.telefone2']").val() == '') {
			alerta('Ao menos um "Telefone" é obrigatório.');
			return false;
		}

		if ($("input[name='empresaRede.email']").val() == ''
				&& $("input[name='empresaRede.email2']").val() == '') {
			alerta('Ao menos um "E-mail" é obrigatório.');
			return false;
		}

		//Despesas
		if ($("input[name='empresaHotel.prazoPagamento']").val() == '') {
			alerta('Campo "Prazo pgto" é obrigatório.');
			return false;
		}

		submitForm(document.forms[0]);

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
              <div class="divGrupo" style="height:120px;">
	                <div class="divGrupoTitulo">API - Geral</div>
	
	
	                <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:300px;" >
	                    		<p style="width:80px;">Nome:</p> 
	                        	<s:textfield  name="entidade.nome" value="GERAL" readonly="true" disabled="true" id="nome" size="45" onkeypress="toUpperCase(this)" />
	                    </div>
	                </div>
	
	
	                <div class="divLinhaCadastro">
	                      <div class="divItemGrupo" style="width:300px;" >  
	                       		<p style="width:80px;">Empresa Site:</p> 
	                        	<s:textfield  name="entidade.nome"  id="nome" size="45"  onkeypress="toUpperCase(this)" />
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
	                    <div class="divItemGrupo" style="width:300px;" >
	                    		<p style="width:80px;">Url:</p> 
	                        	<s:textfield  name="entidade.url"  id="nome" size="45" onkeypress="toUpperCase(this)" />
	                    </div>
	                </div>
	
					 <div class="divLinhaCadastro">
					 		 <div class="divItemGrupo" style="width:300px;" >  
	                       		<p style="width:80px;">Palavra:</p> 
	                        	<s:textfield  name="entidade.nome"  id="nome" size="45"  onkeypress="toUpperCase(this)" />
	                      	</div> 
	                      	
	                      	 <div class="divItemGrupo" style="width:300px;" >  
	                       		<p style="width:80px;">Token Gerado:</p> 
	                        	<s:textfield  name="entidade.token"  id="nome" size="45"  onkeypress="toUpperCase(this)" />
	                      	</div> 
					 </div>
	
				</div>
			
        	 <div class="divGrupo" style="height:120px;">
	                <div class="divGrupoTitulo">API - Contrato</div>
	                
	         </div>
	         
              
              <div class="divGrupo" style="height:120px;">
	                <div class="divGrupoTitulo">API - Vendedor</div>
	                
	         </div> 
              
        </div>
        
        
        <div class="divCadastroBotoes">
               <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
               <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
        </div>
  </div>


</s:form>