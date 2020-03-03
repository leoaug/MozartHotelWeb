<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarObjeto!prepararPesquisa.action" namespace="/app/operacional" />';
        		submitForm(vForm);
            }
            
            
            function gravar(){
                        
                if ($("input[name='entidade.fantasia']").val() == ''){
                    alerta("Campo 'Fantasia' é obrigatório.");
                    return false;
                }
                
                if ($("input[name='entidade.descricao']").val() == ''){
                    alerta("Campo 'Descrição' é obrigatório.");
                    return false;
                }

                if ($("input[name='entidade.valor']").val() == ''){
                    alerta("Campo 'Valor' é obrigatório.");
                    return false;
                }
                
                submitForm(document.forms[0]);                
            }

        </script>


<s:form namespace="/app/operacional" action="manterObjeto!gravar.action" theme="simple">

<s:hidden name="entidade.idObjeto" />
<div class="divFiltroPaiTop">Objeto</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Fantasia:</p>
                        <s:textfield maxlength="20"  name="entidade.fantasia"  id="entidade.fantasia" size="20" onblur="toUpperCase(this)" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Descrição:</p> 
                        <s:textfield maxlength="50" name="entidade.descricao"  id="entidade.descricao" size="50" onblur="toUpperCase(this)"/>
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Valor:</p> 
						<s:textfield name="entidade.valor" id="entidade.valor" maxlength="8" onkeypress="mascara(this, moeda)" />                        
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