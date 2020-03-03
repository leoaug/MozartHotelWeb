<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarCidade!prepararPesquisa.action" namespace="/app/sistema" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.cidade']").val() == ''){
                    alerta('Campo "Cidade" é obrigatório.');
                    return false;
            }

                if ($("input[name='entidade.estado']").val() == ''){
                    alerta('Campo "Estado" é obrigatório.');
                    return false;
                }
                
                   submitForm(document.forms[0]);
                
            }
            
</script>

<s:form namespace="/app/sistema" action="manterCidade!gravarCidade.action" theme="simple">

<s:hidden name="entidade.idCidade" />
<div class="divFiltroPaiTop">Procedência</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Cidade:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="20"  name="entidade.cidade"  id="nome" size="40" />
                    </div>
                </div>
             
             	<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">DDD:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="2"  name="entidade.ddd"  id="nome" size="5" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
                <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Estado:</p>
									<s:select list="estadoList" 
							  cssStyle="width:200px"  
							  name="entidade.estado.idEstado"
							  listKey="idEstado"
							  listValue="estado"
							  headerKey=""
							  headerValue="Selecione"> </s:select>
						
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