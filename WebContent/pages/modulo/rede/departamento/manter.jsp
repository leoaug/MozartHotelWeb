<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarDepartamento!prepararPesquisa.action" namespace="/app/rede" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.descricao']").val() == ''){
                    alerta('Campo "Nome departamento" é obrigatório.');
                    return false;
                }
                    submitForm(document.forms[0]);
                
            }
            
</script>

<s:form namespace="/app/rede" action="manterDepartamento!gravarDepartamento.action" theme="simple">

<s:hidden name="entidade.IdDepartamento" />
<div class="divFiltroPaiTop">Departamento</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:160px;">Nome do departamento:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="50"  name="entidade.descricao"  id="nome" size="40" />
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