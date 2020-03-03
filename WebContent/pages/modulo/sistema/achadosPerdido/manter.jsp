<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarAchadosPerdido!prepararPesquisa.action" namespace="/app/sistema" />';
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

<s:form namespace="/app/sistema" action="manterAchadosPerdido!gravar.action" theme="simple">

<s:hidden name="entidade.idAchadosPerdidos" />
<div class="divFiltroPaiTop">Procedência</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                   <div class="divItemGrupo" style="width:260px;" ><p style="width:100px;">Data entrada:</p>
		                 <s:textfield cssClass="dp" name="entidade.data" onkeypress="mascara(this,data);" id="entidade.data" size="10" maxlength="10" /> 
		           </div>
		           
		           <div class="divItemGrupo" style="width:500px;" ><p style="width:62px;">Período:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="1"  name="entidade.periodo"  id="nome" size="5" />
                   </div>
		        </div>
             
             	<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Descrição:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="90"  name="entidade.objeto"  id="nome" size="50" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Local Encontrado:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="60"  name="entidade.local"  id="nome" size="50" />
                    </div>
                </div>
                
                 <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Achado Por:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="60"  name="entidade.funcionarioAchou"  id="nome" size="50" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Recebido Por:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="60"  name="entidade.funcionarioRecebe"  id="nome" size="50" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Observações:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="200"  name="entidade.documento"  id="nome" size="50" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
	                <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Hóspede:</p>
								 <s:select list="hospedeAPList" 
								  cssStyle="width:280px"  
								  name="entidade.idHospede"
								  listKey="id"
								  listValue="value"
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