<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

						function cancelar(){
							vForm = document.forms[0];
							vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
							submitForm( vForm );
						}

            
            function gravar(){
                        
                            
               

                    submitForm(document.forms[0]);
                
            }

</script>


<s:form namespace="/app/operacional" action="manterReservaCondicoes!gravar.action" theme="simple">

<s:hidden name="entidade.idHotel" />
<div class="divFiltroPaiTop">Configuração da reserva </div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:500px;">
                <div class="divGrupoTitulo">Configuração da reserva</div>
                
              
              <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 1:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha1"  size="150" />
                    </div>
               </div>
              
              <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 2:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha2"  size="150" />
                    </div>
               </div>
             
             <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 3:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha3"  size="150" />
                    </div>
               </div>
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 4:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha4"  size="150" />
                    </div>
               </div>
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 5:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha5"  size="150" />
                    </div>
               </div>
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 6:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha6"  size="150" />
                    </div>
               </div>
              
              <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 7:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha7"  size="150" />
                    </div>
               </div>
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 8:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha8"  size="150" />
                    </div>
               </div>
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 9:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha9"  size="150" />
                    </div>
               </div>
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 10:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha10"  size="150" />
                    </div>
               </div>
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 11:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha11"  size="150" />
                    </div>
               </div>
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 12:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha12"  size="150" />
                    </div>
               </div>
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 13:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha13"  size="150" />
                    </div>
               </div>
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 14:</p></div>
                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha14"  size="150" />
                    </div>
               </div>
               
               <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:55px;" ><p style="width:100px;">Linha 15:</p></div>

                    <div class="divItemGrupo" style="width:55px;" > 
                        <s:textfield style="width:850px;" cssStyle="text-transform:none;" maxlength="250" name="entidade.linha15"  size="150" />
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