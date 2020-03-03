<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarValorCafe!prepararPesquisa.action" namespace="/app/controladoria" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                
                if ($("input[name='entidade.valorCafe']").val() == ''){
                    alerta('Campo "Valor café" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.tipoPensao']").val() == ''){
                    alerta('Campo "Descrição" é obrigatório.');
                    return false;
                }
                               
                   submitForm(document.forms[0]);
                
            }
            
</script>

<s:form namespace="/app/controladoria" action="manterValorCafe!gravarValorCafe.action" theme="simple">

<s:hidden name="entidade.idValorCafe" />
<div class="divFiltroPaiTop">Valor do café</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Data:</p>
                        	<s:property value="entidade.data" />
                        	<s:hidden  name="entidade.data"  />
                    </div>
                </div>
             
             	<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Valor café:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="10"  name="entidade.valorCafe"  id="" size="10" />
                    </div>
                </div>
                
                               
                <div class="divLinhaCadastro">
                <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Descrição:</p>
							  <s:select list="pensaoList" 
							  cssStyle="width:100px"  
							  name="entidade.tipoPensao.idTipoPensao"
							  listKey="idTipoPensao"
							  listValue="descricao"
							  > </s:select>
						
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