<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

	window.onload = function() {
		addPlaceHolder('entidade.prefeitura');
	};
	
	function addPlaceHolder(classe) {
		document.getElementById(classe).setAttribute("placeholder",
				"Ex. Digitar o nome de fantasia ou CNPJ");
	}
	
	function getPrefeituraLookup(elemento) {
		url = 'app/ajax/ajax!obterFornecedoresPorNomeOuCNPJ?OBJ_NAME=' + elemento.id
		+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idPrefeitura';
		getDataLookup(elemento, url, 'Prefeitura', 'TABLE');
	}

	function getListaFiscalServicoLookup(elemento) {
		url = 'app/ajax/ajax!selecionarListaFiscalServico?OBJ_NAME=' + elemento.id
		+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idTabServ';
		getDataLookup(elemento, url, 'FiscalServico', 'TABLE');
	}
	
	function complementoFornecedor(prazo) {
		
	}
	
    function gravar(){
    	var tot = $("input:checkbox[class='chk'][checked='true']").length;
    	
    	if ($("input[name='nomeHospede']").val() == '') {
			alerta('Campo "Hóspede Para" é obrigatório.');
			return false;
		}
    	
    	if(tot == 0){
    		alerta('Deve ser selecionado ao menos 1 "Hóspede De".');
	        return false;	
    	}
	   	
       	preencherIdsHospedes();
       
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
    
    function preencherIdsHospedes(){
    	var tot = $("input:checkbox[class='chk'][checked='true']").length;
    		
    	var idsHospedes = [];

    	for(var idx=0; idx < tot; idx++ ){
    		idChk = $("input:checkbox[class='chk'][checked='true']")[idx].value;
    		idsHospedes[idx] = idChk;
    	}
    	document.forms[0].idsHospedesSelecionadosString.value = idsHospedes;
    }
            
</script>

<s:form namespace="/app/rede" action="manterConfiguracaoTributaria!gravar.action" theme="simple">

<div class="divFiltroPaiTop">Configurações</div>
<div class="divFiltroPai" >
        
       <div class="divCadastro" style="overflow:auto;" >
            <div class="divGrupo" style="height:520px;">
              <div class="divGrupoTitulo">Municipal</div>
              
              <div class="divLinhaCadastro">
                  <div class="divItemGrupo" style="width:180px;" >
                  		<p style="width:80px;">Número RPS:</p>
                      	<s:textfield onkeypress="mascara(this, numeros)" maxlength="2"  name="entidade.numeroRps"  id="" size="10" />
                  </div>
                  <div class="divItemGrupo" style="width:100px;">
	              		<p style="width: 40px;">Série:</p>
						<input type="text" id="serieNotaFiscal" name="entidade.serie" maxlength="1" size="5" onblur="toUpperCase(this)" />
				  </div>
				  <div class="divItemGrupo" style="width:130px">
						<p style="width: 60px;">Sub Série:</p>
						<input type="text" id="subSerieNotaFiscal" name="entidade.subSerie" maxlength="5" size="5" onblur="toUpperCase(this)" />
				  </div>
                  <div class="divItemGrupo" style="width:180px;" ><p style="width:50px;">Alíquota:</p>
					<input type="text" id="aliquota" name="entidade.issAliquota" maxlength="14" size="14" onkeypress="mascara(this, numeros)" />
						
				  </div>
				  <div class="divItemGrupo" style="width:180px;" >
                  		<p style="width:85px;">Imp.Incidentes:</p>
                      	<s:textfield onkeypress="mascara(this, numeros)" maxlength="6"  name="entidade.impIncidentesS"  id="" size="10" />
                  </div>
                  <div class="divItemGrupo" style="width:160px;" >
                  		<p style="width:40px;">AIDF:</p>
                      	<input type="text" id="aidf" name="entidade.aidf" maxlength="11" size="12" onblur="toUpperCase(this)" />
                  </div>
              </div>
              <div class="divLinhaCadastro">
              	  <div class="divItemGrupo" style="width:150px;" ><p style="width:80px;">Produção:</p>
					<s:select list="producaoList" 
							  cssStyle="width:60px"  
							  headerKey=""
							  headerValue="Selecione"  
							  name="entidade.producao"
							  listKey="id"
							  listValue="value"> </s:select>
						
				  </div>
                  <div class="divItemGrupo" style="width:140px;" >
                  		<p style="width:60px;">Inc. Fiscal:</p>
                  		<s:select list="incentivoFiscalList" 
							  cssStyle="width:60px"  
							  headerKey=""
							  headerValue="Selecione"  
							  name="entidade.incetivoFiscal"
							  listKey="id"
							  listValue="value"> </s:select>
                  </div>
                  <div class="divItemGrupo" style="width:160px;">
	              		<p style="width: 50px;">No Lote:</p>
						<input type="text" id="numLote" name="entidade.lote" maxlength="10" size="10" onkeypress="mascara(this, numeros)" />
				  </div>
				  <div class="divItemGrupo" style="width:400px;" ><p style="width:80px;">Exigibilidade:</p>
					<s:select list="exibilidadeList" 
							  cssStyle="width:310px"  
							  headerKey=""
							  headerValue="Selecione"  
							  name="entidade.idExibilidade"
							  listKey="id"
							  listValue="value"> </s:select>
						
				  </div>
              </div>	
              <div class="divLinhaCadastro">
              	  <div class="divItemGrupo" style="width:400px;" >
              	  	<p style="width:80px;">Prefeitura:</p>
					<s:textfield style="width:310px;" maxlength="60"  name="entidade.prefeitura" id="entidade.prefeitura" size="60" onblur="getPrefeituraLookup(this)" />
                    <s:hidden name="idPrefeitura" id="idPrefeitura" />	
				  </div>
                  <div class="divItemGrupo" style="width:400px;" >
                  		<p style="width:120px;">Cod. Serv. Municipal:</p>
                      	<s:textfield style="width:270px;" onblur="toUpperCase(this)" maxlength="8"  name="entidade.codigoServico"  id="" size="10" />
                  </div>
              </div>
              <div class="divLinhaCadastro">
              	  <div class="divItemGrupo" style="width:300px;" >
              	  	<p style="width:80px;">Senha:</p>
					<s:textfield style="width:210px;" onblur="toUpperCase(this)" maxlength="10"  name="entidade.senha"  id="" size="10" />	
				  </div>
                  <div class="divItemGrupo" style="width:550px;" >
                  		<p style="width:100px;">Frase Secreta:</p>
                      	<s:textfield onblur="toUpperCase(this)" maxlength="60"  name="entidade.fraseSecreta"  id="" size="60" />
                  </div>
              </div>
              <div class="divLinhaCadastro">
              	  <div class="divItemGrupo" style="width:250px;" >
              	  	<p style="width:100px;">Discriminação:</p>
				  </div>
              </div>	
              <div class="divLinhaCadastro" style="height:340px;">
              	  <div class="divItemGrupo" style="width:250px;" >
              	  	<s:textarea name="entidade.discriminacao" id="discriminacao" cols="100" maxlength="2000" rows="20" ></s:textarea>
				  </div>
              </div>										
            </div>
            
			<div class="divGrupo" style="height:100px;">
               <div class="divGrupoTitulo">Estadual</div>
               
               	<div class="divLinhaCadastro">
              	  <div class="divItemGrupo" style="width:400px;" >
              	  	<p style="width:100px;">Imp. Incidentes:</p>
					<s:textfield onkeypress="mascara(this, numeros)" maxlength="6"  name="entidade.impIncidentesM"  id="" size="10" />	
				  </div>
              	</div>	
              	
              	<div class="divLinhaCadastro">
              	  <div class="divItemGrupo" style="width:400px;" >
              	  	<p style="width:180px;">CNPJ autorizada a acessar XML:</p>
					<s:textfield maxlength="14" onblur="toUpperCase(this)" name="entidade.cnpjAutorizado"  id="" size="14" />	
				  </div>
				  <div class="divItemGrupo" style="width:400px;" >
              	  	<p style="width:180px;">CPF autorizado a acessar XML:</p>
					<s:textfield maxlength="11" onblur="toUpperCase(this)" name="entidade.cpfAutorizado"  id="" size="11" />	
				  </div>
              	</div>	
	        </div>
	        
			<div class="divGrupo" style="height:100px;">
               <div class="divGrupoTitulo">Federal</div>
               
               	<div class="divLinhaCadastro">
               	  <div class="divItemGrupo" style="width:350px;" ><p style="width:120px;">Regime Tributário:</p>
					<s:select list="regimeTributarioList" 
							  cssStyle="width:200px"  
							  headerKey=""
							  headerValue="Selecione"  
							  name="entidade.idRegimeTributario"
							  listKey="id"
							  listValue="value"> </s:select>
						
				  </div>
              	  <div class="divItemGrupo" style="width:500px;" >
              	  	<p style="width:130px;">Tabela Serv. Lei 116:</p>
					<s:textfield name="entidade.tabelaServico" id="entidade.tabelaServico" size="50" onblur="getListaFiscalServicoLookup(this)" />	
					<s:hidden name="idTabServ" id="idTabServ" />
				  </div>
              	</div>	
              	<div class="divLinhaCadastro">
              	  <div class="divItemGrupo" style="width:400px;" >
              	  	<p style="width:120px;">CNAE principal:</p>
					<s:textfield onkeypress="mascara(this, numeros)" maxlength="1"  name="entidade.cnae"  id="" size="10" />	
				  </div>
				  <div class="divItemGrupo" style="width:400px;" >
              	  	<p style="width:60px;">Sigla:</p>
					<s:textfield onkeypress="mascara(this, numeros)" maxlength="1"  name="entidade.sigla"  id="" size="10" />	
				  </div>
              	</div>
	        </div>
			
         	<div class="divCadastroBotoes">
                <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
          	</div>
        </div>
</div>
</s:form>