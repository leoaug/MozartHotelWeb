<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarTipoApartamento!prepararPesquisa.action" namespace="/app/operacional" />';
        		submitForm(vForm);
            }
            
            
            function gravar(){
                        
                if ($("input[name='entidade.tipoApartamento']").val() == ''){
                    alerta('Campo "Tipo Apto" é obrigatório.');
                    return false;
                }
                
                if ($("input[name='entidade.fantasia']").val() == ''){
                    alerta('Campo "Sigla" é obrigatório.');
                    return false;
                }
                
                submitForm(document.forms[0]);                
            }

        </script>


<s:form namespace="/app/operacional" action="manterTipoApartamento!gravarTipoApartamento.action" theme="simple">

<s:hidden name="entidade.idTipoApartamento" />
<div class="divFiltroPaiTop">Tipo Apartamento </div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados do Tipo Apto</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Tipo Apto:</p>
                        	<s:textfield maxlength="20"  name="entidade.tipoApartamento"  id="entidade.tipoApartamento" size="20" onblur="toUpperCase(this)" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Sigla:</p> 
                        <s:textfield maxlength="4" name="entidade.fantasia"  id="area" size="10" onblur="toUpperCase(this)"/>
                    </div>
                </div>

                <div class="divLinhaCadastro" style="height:50px;">
                    <div class="divItemGrupo" style="width:600px;" ><p style="width:80px;">Descrição:</p> 
						<s:textarea name="entidade.descricaoApartamento" cols="40" rows="2"></s:textarea>                        
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