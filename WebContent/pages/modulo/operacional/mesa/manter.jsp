<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarMesa!prepararPesquisa.action" namespace="/app/operacional" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.numMesa']").val() == ''){
                    alerta('Campo "Número mesa" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.localizacaoMesa']").val() == ''){
                    alerta('Campo "Localização" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.contatoReserva']").val() == ''){
                    alerta('Campo "Contato" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.numPessoas']").val() == ''){
                    alerta('Campo "Qtde pessoas" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.idGarcon']").val() == ''){
                    alerta('Campo "Garçon" é obrigatório.');
                    return false;
                }                

                if ($("input[name='entidade.entidade.pontoVenda.id.idPontoVenda']").val() == ''){
                    alerta('Campo "Ponto venda" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.statusMesa']").val() == ''){
                    alerta('Campo "Status" é obrigatório.');
                    return false;
                }  
                            
                    submitForm(document.forms[0]);
                
            }
            
</script>

<s:form namespace="/app/operacional" action="manterMesa!gravarMesa.action" theme="simple">

<s:hidden name="entidade.idMesa" />
<div class="divFiltroPaiTop">Mesa</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Mesa</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Nº mesa:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"  name="entidade.numMesa"  id="nome" size="40" />
                    </div>
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Localização:</p>
                        	<s:textfield onkeyup="ToUpperCase(this)" maxlength="30"  name="entidade.localizacaoMesa"  id="nome" size="60" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Contato:</p>
                        	<s:textfield onkeyup="toUpperCase(this)" maxlength="10"  name="entidade.contatoReserva"  id="nome" size="40" />
                    </div>
                </div>              
					
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Qtde pessoas:</p>
                        	<s:textfield onkeyup="mascara(this, numeros)" maxlength="10"  name="entidade.numPessoas"  id="nome" size="10" />
                    </div>
                </div>	
				
				<div class="divLinhaCadastro">
                <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Garçon:</p>
									<s:select list="garconList" 
							  cssStyle="width:200px"  
							  name="entidade.idGarcon"
							  listKey="idGarcon"
							  listValue="nomeGarcon"> </s:select>
						
				</div>
				</div>
				
				<div class="divLinhaCadastro">
                <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Ponto venda:</p>
									<s:select list="pvList" 
							  cssStyle="width:200px"  
							  name="entidade.pontoVenda.id.idPontoVenda"
							  listKey="idPontoVenda"
							  listValue="descricao"
							  headerKey=""
							  headerValue="Selecione"
							  > </s:select>
						
				</div>
				</div>
				
				<div class="divLinhaCadastro">
                <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Status:</p>
									<s:select list="statusList" 
							  cssStyle="width:200px"  
							  name="entidade.statusMesa"
							  listKey="id"
							  listValue="value"> </s:select>
						
				</div>
				</div>
					
			
			
			
		</div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Cancelar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
              </div>
              
        </div>
</div>
</s:form>