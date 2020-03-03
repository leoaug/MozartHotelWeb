<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarTipoItem!prepararPesquisa.action" namespace="/app/operacional" />';
        		submitForm(vForm);
            }
			
			
			function gravar(){
			
			if ($("input[name='entidade.nomeItem']").val() == ''){
                    alerta('Campo "Nome Item" é obrigatório.');
                    return false;
                }
				
				        submitForm(document.forms[0]);
                
            }

</script>


<s:form namespace="/app/operacional" action="manterTipoItem!gravarTipoItem.action" theme="simple">

<s:hidden name="entidade.idTipoItem" />
<div class="divFiltroPaiTop">Tipo Item</div>
<div class="divFiltroPai" >
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:280px;">
                <div class="divGrupoTitulo">Dados</div>
                	
					<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:410px;" ><p style="width:100px;">Nome Tipo:</p>
								<s:textfield onkeypress="toUpperCase(this)" maxlength="40"  name="entidade.nomeTipo"  id="" size="50" />
							</div>
					</div>
					
					<div class="divLinhaCadastro">
               		 <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Apelido:</p>
							  <s:select list="apelidoList" 
							  cssStyle="width:200px"  
							  name="entidade.apelido"
							  listKey="id"
							  listValue="value"> </s:select>
						
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
			 