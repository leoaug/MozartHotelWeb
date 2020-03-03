<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarTipoEmpresa!prepararPesquisa.action" namespace="/app/empresa" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.tipoEmpresa']").val() == ''){
                    alerta('Campo "Tipo empresa" é obrigatório.');
                    return false;
                }
                
                if ($("input[name='entidade.comissaoCrs']").val() == ''){
                    alerta('Campo "Comissão CRS" é obrigatório.');
                    return false;
                }

                
                    submitForm(document.forms[0]);
                
            }

</script>


<s:form namespace="/app/empresa" action="manterTipoEmpresa!gravarTipoEmpresa.action" theme="simple">

<s:hidden name="entidade.idTipoEmpresa" />
<div class="divFiltroPaiTop">Tipo Empresa</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Tipo empresa:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="20"  name="entidade.tipoEmpresa"  id="" size="50" />
                    </div>
                </div>

                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Comissão CRS:</p> 
                        	<s:textfield maxlength="10" onkeypress="mascara(this, moeda)" name="entidade.comissaoCrs"  id="" size="20" />

                    </div>
                </div>
				
								
              </div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Cancelar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
              </div>
              
        </div>
</div>
</s:form>