<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarPromotor!prepararPesquisa.action" namespace="/app/rede" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.promotor']").val() == ''){
                    alerta('Campo "Nome" é obrigatório.');
                    return false;
                }
                
                if ($("input[name='entidade.comissao']").val() == ''){
                    alerta('Campo "Comissão" é obrigatório.');
                    return false;
                }
            

                    submitForm(document.forms[0]);
                
            }

</script>


<s:form namespace="/app/rede" action="manterPromotor!gravarPromotor.action" theme="simple">

<s:hidden name="entidade.idPromotor" />
<div class="divFiltroPaiTop">Promotor </div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados da Promotoria</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Nome:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="20"  name="entidade.promotor"  id="nome" size="40" />
                    </div>
                </div>

                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Comissao:</p> 
                        	<s:textfield maxlength="6"  name="entidade.comissao"  onkeypress="mascara(this,moeda)" id="comissao" size="10" />

                    </div>
                </div>
				
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Área:</p> 
                        	<s:textfield maxlength="5"  name="entidade.area"  id="area" size="10" />

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