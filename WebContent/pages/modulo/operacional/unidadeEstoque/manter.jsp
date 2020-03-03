<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarUnidadeEstoque!prepararPesquisa.action" namespace="/app/operacional" />';
        		submitForm(vForm);
            }
			
			
			function gravar(){
			
			if ($("input[name='entidade.nomeUnidade']").val() == ''){
                    alerta('Campo "Nome Unidade" é obrigatório.');
                    return false;
                }

			if ($("input[name='entidade.nomeUnidadeReduzido']").val() == ''){
                alerta('Campo "Nome Reduzido" é obrigatório.');
                return false;
            }
				
				        submitForm(document.forms[0]);
                
            }

</script>


<s:form namespace="/app/operacional" action="manterUnidadeEstoque!gravarUnidadeEstoque.action" theme="simple">

<s:hidden name="entidade.idUnidadeEstoque" />
<div class="divFiltroPaiTop">Unidade Estoque</div>
<div class="divFiltroPai" >
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:280px;">
                <div class="divGrupoTitulo">Dados</div>
                	
					<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Nome Unidade:</p>
								<s:textfield onkeypress="toUpperCase(this)" maxlength="25"  name="entidade.nomeUnidade"  id="" size="50" />
							</div>
					</div>
					
					<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Nome Reduzido:</p>
								<s:textfield onkeypress="toUpperCase(this)" maxlength="5"  name="entidade.nomeUnidadeReduzido"  id="" size="20" />
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
			 