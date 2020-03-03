<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarValorDolar!prepararPesquisa.action" namespace="/app/controladoria" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                
                if ($("input[name='entidade.valorDolar']").val() == ''){
                    alerta('Campo "Valor dólar" é obrigatório.');
                    return false;
                }

                               
                   submitForm(document.forms[0]);
                
            }
            
</script>

<s:form namespace="/app/controladoria" action="manterValorDolar!gravarValorDolar.action" theme="simple">

<s:hidden name="entidade.idValorDolar" />
<div class="divFiltroPaiTop">Cotação da moeda</div>
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
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Valor dolar:</p>
                        	<s:textfield onkeypress="mascara(this, moeda)" maxlength="10"  name="entidade.valorDolar"  id="nome" size="5" />
                    </div>
                </div>
                
                               
                <div class="divLinhaCadastro">
                <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Moeda:</p>
							  <s:select list="moedaList" 
							  cssStyle="width:200px"  
							  name="entidade.idMoeda"
							  listKey="idMoeda"
							  listValue="nomeMoeda"
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