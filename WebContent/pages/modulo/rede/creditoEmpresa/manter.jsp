<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
            function cancelar(){
            	vForm = document.forms[0];
           		vForm.action = '<s:url action="pesquisarCreditoEmpresa!prepararPesquisa.action" namespace="/app/rede" />';
        		submitForm(vForm);
            }
            
            
            function gravar(){

            	if ($("input[name='entidade.credito']").val() == 'S' && $("input[name='entidade.valorCredito']").val() == ''){
                    alerta('Campo "Valor crédito" é obrigatório.');
                    return false;
                }
                vForm = document.forms[0];
                submitForm(vForm);                
            }


            function setUpValorCredito( valor ){
            	$("input[name='entidade.valorCredito']").val('');
				$("input[name='entidade.valorCredito']").attr('readonly','');
				if (valor == 'N'){
					$("input[name='entidade.valorCredito']").attr('readonly','readonly');
				}
            }
        </script>




<s:form namespace="/app/rede" action="manterCreditoEmpresa!gravar.action" theme="simple">

<div class="divFiltroPaiTop">Empresa</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style="height:140px;">
                <div class="divGrupoTitulo">Dados da empresa</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">Razão social:</p>
                    	<s:property value="entidade.empresaEJB.razaoSocial"/>
                    </div>
                </div>
                
                <div class="divLinhaCadastro">    
                    <div class="divItemGrupo" ><p style="width:100px;">Nome fantasia:</p>
                    	<s:property value="entidade.nomeFantasia"/>
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">CNPJ:</p>
						<s:property value="entidade.empresaEJB.cgc"/>                        	
                    </div>
                </div>

				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">Data cadastro:</p>
						<s:property value="entidade.empresaEJB.dataCadastro"/>                        	
                    </div>
                </div>
              </div>

              <div class="divGrupo" style="height:100px;">
                <div class="divGrupoTitulo">Inclusão</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">Hotel:</p>
                    	<s:property value="#session.logAlteracao.nomeHotel"/>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">Usuário:</p>
                    	<s:property value="#session.logAlteracao.nick"/>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">Operação:</p>
                    	<s:property value="#session.logAlteracao.operacao"/>
                    </div>
                </div>
                
              </div>

			<div class="divGrupo" style="height:130px;">
                <div class="divGrupoTitulo">Crédito</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">Possui crédito?:</p>
						<s:select list="#session.LISTA_CONFIRMACAO" onchange="setUpValorCredito(this.value)"
								cssStyle="width:80px;"
								listKey="id"
								listValue="value" 
								name="entidade.credito"/>                        	

                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">Valor crédito:</p>
                    	<s:textfield name="entidade.valorCredito" onkeypress="mascara(this, moeda)" maxlength="10" size="12"/>
                    </div>
                </div>
                
                <div class="divLinhaCadastro" style="height:50px;" >
					<div class="divItemGrupo" style="height:49px;width: 500px;">
					<p style="width: 100px;">Observação:</p>
						<s:textarea cols="40" rows="2" name="entidade.observacao">  </s:textarea>
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