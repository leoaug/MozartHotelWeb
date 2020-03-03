<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarTipoDiaria!prepararPesquisa.action" namespace="/app/rede" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.descricao']").val() == ''){
                    alerta('Campo "Tipo Di�ria" � obrigat�rio.');
                    return false;
                }
                    submitForm(document.forms[0]);
                
            }
            
</script>

<s:form namespace="/app/rede" action="manterTipoDiaria!gravarTipoDiaria.action" theme="simple">

<s:hidden name="entidade.idTipoDiaria" />
<div class="divFiltroPaiTop">Tipo Di�ria</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Tipo di�ria:</p>
                        	<s:textfield onkeypress="toUpperCase(this)" maxlength="30"  name="entidade.descricao"  id="nome" size="40" />
                    </div>
                </div>

                
                
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" ><p style="width:100px;">Padr�o?:</p>
						<s:select list="#session.LISTA_CONFIRMACAO" 
								cssStyle="width:80px;"
								listKey="id"
								listValue="value" 
								name="entidade.padrao"/>                        	

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