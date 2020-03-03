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
                        
						if ($("input[name='entidade.qtdeChildFree']").val() == ''){
							alerta('Campo "Qtde Chd Free" é obrigatório.');
							return false;
						}
                            
						if ($("input[name='entidade.idadeChildFree']").val() == ''){
							alerta('Campo "Idade Chd Free" é obrigatório.');
							return false;
						}	
						
						if ($("input[name='entidade.tipoPagamento']").val() == ''){
							alerta('Campo "Tipo Pag." é obrigatório.');
							return false;
						}	

                    submitForm(document.forms[0]);
                
            }

</script>


<s:form namespace="/app/comercial" action="manterPoliticaHotel!gravar.action" theme="simple">

<s:hidden name="entidade.idPoliticaHotel" />
<div class="divFiltroPaiTop">Política do Hotel</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:420px;">
                <div class="divGrupoTitulo">Política Hotel</div>
                
              
           <div class="divLinhaCadastro">   
              <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Check In:</p>
                   <s:textfield  name="entidade.horaCheckIn" onkeypress="mascara(this,hora);" size="5" maxlength="5" /> 
              </div>
              
              <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Check Out:</p>
                   <s:textfield  name="entidade.horaCheckOut" onkeypress="mascara(this,hora);"  size="5" maxlength="5" /> 
              </div>
           </div>   
              
           <div class="divLinhaCadastro">
          			<div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Qtde Chd Free:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="1"  name="entidade.qtdeChildFree"  id="" size="5" />
                    </div>  
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Idade Chd Free:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="2"  name="entidade.idadeChildFree"  id="" size="5" />
                    </div>  
           </div>   
           <div class="divLinhaCadastro">
          			<div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Prazo de Cancel:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="2"  name="entidade.prazoCancelamento"  id="" size="5" />
                    </div>  
                    
                    <div class="divItemGrupo" style="width:210px;" ><p style="width:100px;">Dead Line:</p>
                        	<s:textfield onkeypress="mascara(this, numeros)" maxlength="2"  name="entidade.deadLine"  id="" size="5" />
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