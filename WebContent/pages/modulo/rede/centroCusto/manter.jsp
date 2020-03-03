<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarCentroCusto!prepararPesquisa.action" namespace="/app/rede" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.descricaoCentroCusto']").val() == ''){
                    alerta('Campo "Descrição" é obrigatório.');
                    return false;
            }

                if ($("input[name='entidade.idDepartamento']").val() == ''){
                    alerta('Campo "Departamento" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.tipoPessoa']").val() == ''){
                    alerta('Campo "Tipo Pessoa" é obrigatório.');
                    return false;
                }
                
                   submitForm(document.forms[0]);
                
            }
            
</script>

<s:form namespace="/app/rede" action="manterCentroCusto!gravar.action" theme="simple">

<s:hidden name="entidade.idCentroCustoContabil" />
<div class="divFiltroPaiTop">Procedência</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
	                <div class="divLinhaCadastro">
	                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Descrição:</p>
	                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="20"  name="entidade.descricaoCentroCusto"  id="nome" size="40" />
	                    </div>
	                </div>
	             
	             	
	             	<div class="divLinhaCadastro">
		                <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Departamento:</p>
									 <s:select list="departamentoList" 
									  cssStyle="width:200px"  
									  name="entidade.idDepartamento"
									  listKey="idDepartamento"
									  listValue="descricao"
									  headerKey=""
									  headerValue="Selecione"> </s:select>
								
						</div>
					</div>
					
					<div class="divLinhaCadastro">
					 	<div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Controlado:</p>
							<s:select list="#session.LISTA_CONFIRMACAO" 
									  cssStyle="width:80px"  
									  name="entidade.controlado"
									  listKey="id"
									  listValue="value"> </s:select>
								
						</div>
						
						<div class="divItemGrupo" style="width:510px;" ><p style="width:80px;">Créd. Pensão:</p>
							<s:select list="#session.LISTA_CONFIRMACAO" 
									  cssStyle="width:80px"  
									  name="entidade.creditoPensao"
									  listKey="id"
									  listValue="value"> </s:select>
								
						</div>
             		</div>
             		
             		<div class="divLinhaCadastro">
					 	<div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Tipo Pessoa:</p>
							<s:select list="tipoPessoaList" 
									  cssStyle="width:100px"  
									  name="entidade.tipoPessoa"
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