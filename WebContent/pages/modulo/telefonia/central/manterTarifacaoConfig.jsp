<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
			function cancelar(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="manterTarifacaoConfig!cancelar.action" namespace="/app/telefonia" />';
				submitForm( vForm );
			}

            
            
            function gravar(){
                        
                if ($("input[name='entidade.idTelefonia']").val() == ''){
                    alerta('Campo "Central" é obrigatório.');
                    return false;
                }
                
                if ($("input[name='entidade.ramalini']").val() == '' || $("input[name='entidade.ramalfim']").val() == ''){
                    alerta('Campo "Ramal" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.dataini']").val() == '' || $("input[name='entidade.datafim']").val() == ''){
                    alerta('Campo "Data" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.horaini']").val() == '' || $("input[name='entidade.horafim']").val() == ''){
                    alerta('Campo "Hora" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.ndiscini']").val() == '' || $("input[name='entidade.ndiscfim']").val() == ''){
                    alerta('Campo "N. Disc" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.tempoini']").val() == '' || $("input[name='entidade.tempofim']").val() == ''){
                    alerta('Campo "Tempo" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.custoini']").val() == '' || $("input[name='entidade.custofim']").val() == ''){
                    alerta('Campo "Custo" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.taxaini']").val() == '' || $("input[name='entidade.taxafim']").val() == ''){
                    alerta('Campo "Taxa" é obrigatório.');
                    return false;
                }

				if ($("#tarifaTaxa").val() == 'S' && $("input[name='entidade.taxa']").val() == ''){
                    alerta('Campo "% Acréscimo" é obrigatório.');
                    return false;
                }

				
                if ($("input[name='entidade.acobrar']").val() == ''){
                    alerta('Campo "Valor a cobrar" é obrigatório.');
                    return false;
                }
                
                if ($("input[name='entidade.caminho']").val() == ''){
                    alerta('Campo "Pasta telefonia" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.tipoLancamentoTelefonia.idTipoLancamento']").val() == ''){
                    alerta('Campo "Conta telefonia" é obrigatório.');
                    return false;
                }

				var caminho = $("input[name='entidade.caminho']").val();
				if (caminho.indexOf('\\Mozart\\<s:property value="#session.HOTEL_SESSION.idHotel"/>\\Telefonia') <= 0 ||
					 caminho.indexOf('.') >= 0 ){
                    alerta('Campo "Pasta telefonia" é inválido.');
                    return false;
				}

				caminho = $("input[name='entidade.caminhoInternet']").val();
				if (caminho != ''){

	                if ($("input[name='entidade.tipoLancamentoInternet.idTipoLancamento']").val() == ''){
	                    alerta('Campo "Conta internet" é obrigatório.');
	                    return false;
	                }

					if (caminho.indexOf('\\Mozart\\<s:property value="#session.HOTEL_SESSION.idHotel"/>\\Internet') <= 0 ||
							 caminho.indexOf('.') >= 0 ){
		                    alerta('Campo "Pasta internet" é inválido.');
		                    return false;
					}
				}

                
				
				
				
                submitForm(document.forms[0]);
            }


			function habilitaDivTaxa(valor){
				$('#taxa').val('');
				if ("S" == valor){
					$('#divTaxa').css('display','block');
				}else{
					$('#divTaxa').css('display','none');
				}
			}
            
        </script>






<s:form namespace="/app/telefonia" action="manterTarifacaoConfig!gravarTarifacaoConfig.action" theme="simple">

<s:hidden name="entidade.idTelefoniasConfig" />


<div class="divFiltroPaiTop">Configuração </div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:300px;">
                <div class="divGrupoTitulo">Dados da telefonia</div>
                
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:400px;">
                        	<p style="width:100px;">Central:</p>
							<s:select list="telefoniaList" 
                                  cssStyle="width:250px;" 
                                  listKey="idTelefonia"
                                  listValue="nome"
                                  id="idTelefonia"
                            	  name="entidade.idTelefonia"/>	                    
                    	</div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:100px;" >&nbsp;</div>
                    <div class="divItemGrupo" style="width:100px;" > 
                        <p style="width:100px;">Posição</p>
                    </div>
                    <div class="divItemGrupo" style="width:100px;" > 
                        <p style="width:100px;">Tamanho</p>
                    </div>
                </div>

                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:100px;" ><p style="width:100px;">Ramal:</p></div>

                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.ramalini"  id="ramalini" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.ramalfim"  id="ramalfim" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                </div>
                
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:100px;" ><p style="width:100px;">Data:</p></div>

                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.dataini"  id="dataini" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.datafim"  id="ramalfim" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:100px;" ><p style="width:100px;">Hora:</p></div>

                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.horaini"  id="horaini" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.horafim"  id="horafim" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:100px;" ><p style="width:100px;">N.Disc:</p></div>

                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.ndiscini"  id="ndiscini" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.ndiscfim"  id="ndiscfim" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:100px;" ><p style="width:100px;">Tempo:</p></div>

                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.tempoini"  id="tempoini" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.tempofim"  id="tempofim" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:100px;" ><p style="width:100px;">Custo:</p></div>

                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.custoini"  id="custoini" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.custofim"  id="custofim" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:100px;" ><p style="width:100px;">Taxa:</p></div>

                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.taxaini"  id="taxaini" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                    <div class="divItemGrupo" style="width:100px;" > 
                        <s:textfield maxlength="3"  name="entidade.taxafim"  id="taxafim" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                </div>

			</div>
			
            <div class="divGrupo" style="height:150px;">
                <div class="divGrupoTitulo">Complemento</div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:120px;">Tarifa c/ acréscimo:</p>
							<s:select list="#session.LISTA_CONFIRMACAO" 
									  listKey="id"
									  listValue="value" 
									  cssStyle="width:50px;" 
									  name="entidade.tarifaTaxa"
									  id="tarifaTaxa" onchange="habilitaDivTaxa(this.value)" />
                    </div>
                    
                    <div class="divItemGrupo" id="divTaxa" style="width:300px;" ><p style="width:100px;">% Acréscimo:</p>
							<s:textfield maxlength="6"  name="entidade.taxa"  id="taxa" size="5" onkeypress="mascara(this, moeda)" />
                    </div>
                    
                    
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:120px;">Valor a cobrar:</p>
							<s:textfield maxlength="10"  name="entidade.acobrar"  id="acobrar" size="12" onkeypress="mascara(this, moeda)" />
                    </div>
                </div>
                
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:450px;" ><p style="width:120px;">Pasta telefonia:</p>
							<s:textfield maxlength="100"  name="entidade.caminho"  id="caminho" size="50" cssStyle="text-transform:none;" />
                    </div>
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:90px;">Conta telefonia:</p>
							<s:select list="tipoLancamentoList" 
									  listKey="idTipoLancamento"
									  listValue="descricaoLancamento" 
									  cssStyle="width:200px;" 
									  name="entidade.tipoLancamentoTelefonia.idTipoLancamento"
									  id="idTipoLancamentoTelefonia" 
									   />
                    </div>
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:450px;" ><p style="width:120px;">Pasta internet:</p>
							<s:textfield maxlength="100"  name="entidade.caminhoInternet"  id="caminhoInternet" size="50"  cssStyle="text-transform:none;" />
                    </div>

                    <div class="divItemGrupo" style="width:300px;" ><p style="width:90px;">Conta internet:</p>
							<s:select list="tipoLancamentoList" 
									  listKey="idTipoLancamento"
									  listValue="descricaoLancamento" 
									  cssStyle="width:200px;" 
									  name="entidade.tipoLancamentoInternet.idTipoLancamento"
									  id="idTipoLancamentoInternet"/>
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