<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarIndiceEconomico!prepararPesquisa.action" namespace="/app/rede" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.data']").val() == ''){
                    alerta('Campo "Data" � obrigat�rio.');
                    return false;
                }

                if ($("input[name='entidade.indiceTipo.nomeIndice']").val() == ''){
                    alerta('Campo "Tipo �ndice" � obrigat�rio.');
                    return false;
                }

                if ($("input[name='entidade.indiceMes']").val() == ''){
                    alerta('Campo "�ndice m�s" � obrigat�rio.');
                    return false;
                }

                if ($("input[name='entidade.indiceAnual']").val() == ''){
                    alerta('Campo "�ndice Anual" � obrigat�rio.');
                    return false;
                }               

                if ($("input[name='entidade.indiceDoAno']").val() == ''){
                    alerta('Campo "�ndice do ano" � obrigat�rio.');
                    return false;
                }
                   submitForm(document.forms[0]);
                
            }
            
</script>

<s:form namespace="/app/rede" action="manterIndiceEconomico!gravarIndiceEconomico.action" theme="simple">

<s:hidden name="entidade.idIndiceEconomico" />
<div class="divFiltroPaiTop">�ndice Econ�mico</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Data:</p>
                    
                     <s:textfield cssClass="dp" name="entidade.data" onkeypress="mascara(this,data);" id="entidade.data" size="8" maxlength="10" /> 
                    </div>
                </div>
                         	   
	  			  
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">Tipo �ndice:</p>
						<s:select list="tipoIndiceList" 
								cssStyle="width:100px;"
								listKey="idIndiceTipo"
								listValue="nomeIndice" 
								name="entidade.indiceTipo.idIndiceTipo"/>                        	
                    </div>
                </div>
				
		<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">�ndice m�s:</p>
                        	<s:textfield onkeypress="mascara(this,moeda)" maxlength="6" name="entidade.indiceMes"  size="10" />
                    </div>
                </div>
             
		
		<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">�ndice Anual:</p>
                        	<s:textfield onkeypress="mascara(this,moeda)" maxlength="6" name="entidade.indiceAnual"   size="10" />
                    </div>
                </div>
		
		<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">�ndice do ano:</p>
                        	<s:textfield onkeypress="mascara(this,moeda)" maxlength="6" name="entidade.indiceDoAno"   size="10" />
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