<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarGarcon!prepararPesquisa.action" namespace="/app/operacional" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.nomeGarcon']").val() == ''){
                    alerta('Campo "Nome Garçon" é obrigatório.');
                    return false;
                }
                
                           

                    submitForm(document.forms[0]);
                
            }

</script>


<s:form namespace="/app/operacional" action="manterGarcon!gravarGarcon.action" theme="simple">

<s:hidden name="entidade.idGarcon" />
<div class="divFiltroPaiTop">Garçon </div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Nome garçon:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="30"  name="entidade.nomeGarcon"  id="nome" size="40" />
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:80px;">Ativo?:</p>
						<s:select list="listaPadrao" 
								cssStyle="width:80px;"
								listKey="id"
								listValue="value" 
								name="entidade.ativo"/>                        	

                    </div>
                </div>
                		
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Comissão:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="2"  name="entidade.comissao"  id="nome" size="10" />
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