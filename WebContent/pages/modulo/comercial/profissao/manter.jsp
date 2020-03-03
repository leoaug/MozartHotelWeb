<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarProfissao!prepararPesquisa.action" namespace="/app/comercial" />';
        		submitForm(vForm);
            }
            
            
            function gravar(){
                        
                if ($("input[name='entidade.profissao']").val() == ''){
                    alerta('Campo "Profissão" é obrigatório.');
                    return false;
                }
                
                submitForm(document.forms[0]);                
            }

        </script>


<s:form namespace="/app/comercial" action="manterProfissao!gravar.action" theme="simple">

<s:hidden name="entidade.idProfissao" />
<div class="divFiltroPaiTop">Profissão</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados da profissão</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Profissão:</p>
                        	<s:textfield maxlength="20"  name="entidade.profissao"  id="entidade.profissao" size="40" onblur="toUpperCase(this)" />
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