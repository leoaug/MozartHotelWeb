<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
			function cancelar(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="pesquisarRamal!prepararPesquisa.action" namespace="/app/telefonia" />';
				submitForm( vForm );
			}

            
            
            function gravar(){
                        
                if ($("input[name='entidade.ramal']").val() == ''){
                    alerta('Campo "Ramal" é obrigatório.');
                    return false;
                }
                
                if ($('#interno').val() == 'N' && $("#idApartamento").val() == ''){
                    alerta('Campo "Num apto" é obrigatório.');
                    return false;
                }

                submitForm(document.forms[0]);
            }

        </script>






<s:form  action="manterRamal!gravar.action" namespace="/app/telefonia" theme="simple">

<s:hidden name="entidade.idRamalTelefonico" />
<div class="divFiltroPaiTop">Ramal </div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:120px;">
                <div class="divGrupoTitulo">Dados do ramal</div>


                <div class="divLinhaCadastro">

                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Ramal:</p> 
                        <s:textfield maxlength="6"  name="entidade.ramal"  id="ramal" size="5" onkeypress="toUpperCase(this)" />
                    </div>
                </div>


                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:300px;"><p style="width:80px;">Num apto:</p>
						<s:select list="apartamentoList" 
                                  cssStyle="width:100px;"
                                  headerKey=""
                                  headerValue="Selecione" 
                                  listKey="idApartamento"
                                  id="idApartamento"
                                  name="entidade.idApartamento"/>	                    
                    </div>
                </div>

				<div class="divLinhaCadastro">
	                <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Interno?:</p>
								<s:select list="#session.LISTA_CONFIRMACAO" 
										  listKey="id"
										  listValue="value" 
										  cssStyle="width:50px;" 
										  name="entidade.interno"
										  id="interno" />
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