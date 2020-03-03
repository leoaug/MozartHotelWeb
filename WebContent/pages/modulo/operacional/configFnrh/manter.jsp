<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarConfigFnrh!prepararPesquisa.action" namespace="/app/operacional" />';
        		submitForm(vForm);
            }
			
			
			function gravar(){
			
			if ($("input[name='entidade.titulo']").val() == ''){
                    alerta('Campo "Título" é obrigatório.');
                    return false;
                }
				
				if ($("input[name='entidade.descricao']").val() == ''){
                    alerta('Campo "Descrição" é obrigatório.');
                    return false;
                }
			
                    submitForm(document.forms[0]);
                
            }

</script>


<s:form namespace="/app/operacional" action="manterConfigFnrh!gravarConfigFnrh.action" theme="simple">

<s:hidden name="entidade.idConfig" />
<div class="divFiltroPaiTop">Config Fnrh</div>
<div class="divFiltroPai" >
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:280px;">
                <div class="divGrupoTitulo">Dados</div>
                	
					<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Titulo:</p>
								<s:textfield cssStyle="text-transform:none;" maxlength="50"  name="entidade.titulo"  id="" size="50" />
							</div>
					</div>
					
					<div class="divLinhaCadastro" style="height: 53px;">
							<div class="divItemGrupo" style="width: 99%">
							<p style="width: 100px;">Descrição:</p>
							<s:textarea name="entidade.descricao" cols="60" rows="2"></s:textarea></div>
					</div>
				
					
					
			</div>		

		
			
				 <div class="divCadastroBotoes">
						<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
						<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
				 </div>
			</div>
			</div> 


</s:form>			
			 