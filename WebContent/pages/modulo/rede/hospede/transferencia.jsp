<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

	window.onload = function() {
		
		addPlaceHolder('nomeHospede');
		addPlaceHolder('paramHospedeDe');
	};
	
	function addPlaceHolder(classe) {
		document.getElementById(classe).setAttribute("placeholder",
				"Ex. Digitar nome ou sobrenome ou CPF ou passaporte");
	}
	
	function getHospedeLookup(elemento) {
		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarHospedePorNomeSobrenomeCpfPassaporte?OBJ_NAME='
				+ elemento.name
				+ '&OBJ_VALUE='
				+ elemento.value
				+ '&OBJ_HIDDEN=idHospede';
		getDataLookup(elemento, url, 'Hospede', 'TABLE');
	}

    function pesquisarHospedes(){
    	vForm = document.forms[0];
		vForm.action = '<s:url action="TransferenciaHospede!pesquisarHospedes.action" namespace="/app/rede" />';
		submitForm(vForm);
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

<s:form namespace="/app/rede" action="TransferenciaHospede!transferir.action" theme="simple">
<s:hidden name="idsHospedesSelecionadosString" id="idsHospedesSelecionadosString" />
<div class="divFiltroPaiTop">Transferência de Hóspede</div>
<div class="divFiltroPai" >
        
       <div class="divCadastro" style="overflow:auto;" >
            <div class="divGrupo" style="height:50px;">
              <div class="divGrupoTitulo">Para</div>
              
              <div class="divLinhaCadastro">
                  <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Hóspede:</p>
                      <s:textfield name="nomeHospede" id="nomeHospede" size="50" maxlength="50" onblur="getHospedeLookup(this)" />
                      <s:hidden name="idHospede" id="idHospede" />
                  </div>
              </div>												
            </div>
            
			<div class="divGrupo" style="height:400px;">
               <div class="divGrupoTitulo">De</div>
               
               	<div class="divLinhaCadastro">
                  <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Hóspede:</p>
                      <s:textfield onkeypress="toUpperCase(this)" maxlength="20"  name="paramHospedeDe"  id="paramHospedeDe" size="40" />
                  </div>
                  <div class="divItemGrupo" style="width:30px;" >
                      <img width="30px" height="30px" src="imagens/iconic/png/magnifying-glass-3x.png" title="Pesquisar" style="margin:0px;" onclick="pesquisarHospedes();"/>
				  </div>
              	</div>
		        <div class="divGrupo"
					style="overflow: auto; margin-top: 0px; width: 950px; height: 320px; border: 0px;">
			        <div class="divLinhaCadastroPrincipal"
						style="width: 99%; float: left; height: 20px; text-align: center">
						<div class="divItemGrupo" style="width: 25px;"></div>
						<div class="divItemGrupo" style="width: 400px;">
							<p style="color: white; width: 100px;">Nome Completo</p>
						</div>
						<div class="divItemGrupo" style="width: 100px;">
							<p style="color: white; width: 60px;">CPF</p>
						</div>
						<div class="divItemGrupo" style="width: 100px;">
							<p style="color: white; width: 60px;">Passaporte</p>
						</div>		
					</div>
			
					<s:iterator value="#session.listaPesquisa" var="hospedes" status="row">
			
						<div class="divLinhaCadastro" id='divDup<s:property value="gracIdNota" />'
							style="width: 99%; float: left; height: 20px;">
							<div class="divItemGrupo" style="width: 25px;">
								<input type="checkbox" 
									name="idHospedePara" value='<s:property value="bcIdHospede" />' class="chk" />
							</div>
							<div class="divItemGrupo" style="width: 400px;">
								<p style="width: 390px;">
									<s:property value="bcNomeHospede" />
								</p>
							</div>
							<div class="divItemGrupo" style="width: 100px;">
								<p style="width: 90px;">
									<s:property value="bcCpf" />
								</p>
							</div>
							<div class="divItemGrupo" style="width: 100px;">
								<p style="width: 90px;">
									<s:property value="bcPassaporte" />
								</p>
							</div>
						</div>
					</s:iterator>
	        	</div>
	        	<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 400px; float: left;">
						<input type="checkbox" class="chkTodos"
							id="chkTodos" />
						Selecionar Todos
					</div>
					<div class="divItemGrupo" style="width: 320pt; float: left;">
					</div>
				</div>
	        </div>
		

         	<div class="divCadastroBotoes">
                <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
          	</div>
        </div>
</div>
</s:form>