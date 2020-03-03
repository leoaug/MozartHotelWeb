<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarGrupoPrato!prepararPesquisa.action" namespace="/app/rede" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.nomeGrupoPrato']").val() == ''){
                	alerta('Campo "Grupo de prato" é obrigatório.');
                     return false;
                }
                    submitForm(document.forms[0]);
                }
            
</script>

<s:form namespace="/app/rede" action="manterGrupoPrato!gravarGrupoPrato.action" theme="simple">

<s:hidden name="entidade.idGrupoPrato" />
<div class="divFiltroPaiTop">Grupo de prato</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Grupo de prato</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Grupo de prato:</p>
                        	<s:textfield onkeyup="toUpperCase(this)" maxlength="20"  name="entidade.nomeGrupoPrato"  id="nome" size="40" />
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