<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarBanco!prepararPesquisa.action" namespace="/app/sistema" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.numeroBanco']").val() == ''){
                    alerta('Campo "Número do banco" é obrigatório.');
                    return false;
                }
                
                if ($("input[name='entidade.banco']").val() == ''){
                    alerta('Campo "Banco" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.nomeFantasia']").val() == ''){
                    alerta('Campo "Nome do banco" é obrigatório.');
                    return false;
                }

                    submitForm(document.forms[0]);
                
            }

</script>


<s:form namespace="/app/sistema" action="manterBanco!gravarBanco.action" theme="simple">

<s:hidden name="entidade.idBanco" />
<div class="divFiltroPaiTop">Banco </div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados do Banco</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Número Banco:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="10"  name="entidade.numeroBanco"  id="nome" size="10" />
                    </div>
                </div>

                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Banco:</p> 
                        	<s:textfield maxlength="25" onkeypress="toUpperCase(this)" name="entidade.banco"  id="central" size="40" />

                    </div>
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Nome Banco:</p> 
                        	<s:textfield maxlength="10" onkeypress="toUpperCase(this)" name="entidade.nomeFantasia"  id="central" size="40" />

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