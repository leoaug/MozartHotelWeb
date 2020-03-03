<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarMoeda!prepararPesquisa.action" namespace="/app/rede" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.nomeMoeda']").val() == ''){
                    alerta('Campo "Nome" � obrigat�rio.');
                    return false;
                }
                
                if ($("input[name='entidade.sigla']").val() == ''){
                    alerta('Campo "Sigla" � obrigat�rio.');
                    return false;
                }
            

                    submitForm(document.forms[0]);
                
            }

</script>


<s:form namespace="/app/rede" action="manterMoeda!gravarMoeda.action" theme="simple">

<s:hidden name="entidade.idMoeda" />
<div class="divFiltroPaiTop">Moeda </div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados da Moeda</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Nome:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="40"  name="entidade.nomeMoeda"  id="nome" size="40" />
                    </div>
                </div>

                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Sigla:</p> 
                        	<s:textfield maxlength="2"  name="entidade.sigla"  id="central" size="10" />

                    </div>
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">S�mbolo:</p> 
                        	<s:textfield maxlength="5"  name="entidade.simbolo"  id="central" size="10" />

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