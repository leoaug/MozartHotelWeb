<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarGrupoEconomico!prepararPesquisa.action" namespace="/app/comercial" />';
        		submitForm(vForm);
            }
            
            
            function gravar(){
                        
                if ($("input[name='entidade.nomeGrupo']").val() == ''){
                    alerta('Campo "Nome" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.hotelEmpresa']").val() == ''){
                    alerta('Campo "Tipo" é obrigatório.');
                    return false;
                }
                
                submitForm(document.forms[0]);                
            }

        </script>


<s:form namespace="/app/comercial" action="manterGrupoEconomico!gravar.action" theme="simple">

<s:hidden name="entidade.idGrupoEconomico" />
<div class="divFiltroPaiTop">Grupo econômico </div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados do grupo</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Nome:</p>
                        	<s:textfield maxlength="30"  name="entidade.nomeGrupo"  id="entidade.nomeGrupo" size="20" />
                    </div>
                    
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Tipo:</p>
                    		<s:select list="tipoGrupoList"
                    				  cssStyle="width:150px;"
                    				  listKey="id"
                    				  listValue="value"
                    				  name="entidade.hotelEmpresa"
                    		/>
                    
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