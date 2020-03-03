<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarAuditoria!prepararPesquisa.action" namespace="/app/auditoria" />';
        		submitForm(vForm);
            }
            
            
            
            function gravar(){
                submitForm(document.forms[0]);
            }

        </script>






<s:form namespace="/app/auditoria" action="manterAuditoria!gravar.action" theme="simple">

<s:hidden name="entidade.idMovimentoApartamento" />
<div class="divFiltroPaiTop">Movimento </div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados do movimento</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;color:blue;" ><p style="width:80px;color:black;">Num Apto:</p>
                    	<b><s:property value="#session.entidadeSession.checkinEJB.apartamentoEJB.numApartamento" /></b>
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Qtde adultos:</p> 
                        <b><s:property value="#session.entidadeSession.qtdeAdultos" /></b>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Qtde café:</p> 
                        <s:textfield maxlength="2" name="entidade.qtdeCafe" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Qtde MAP:</p> 
                        <s:textfield maxlength="2" name="entidade.map" size="5" onkeypress="mascara(this, numeros)" />
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Qtde FAP:</p> 
                        <s:textfield maxlength="2" name="entidade.fap" size="5" onkeypress="mascara(this, numeros)" />
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