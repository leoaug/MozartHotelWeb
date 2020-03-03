<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

	function getPatrimonioSetor(elemento) {
		url = 'app/ajax/ajax!obterItensPatrimonioSetor?OBJ_NAME=' 
				+ elemento.id
				+ '&OBJ_VALUE=' 
				+ elemento.value 
				+ '&OBJ_HIDDEN=idPatrimonioSetor';
		getDataLookup(elemento, url, 'PatrimonioSetor', 'TABLE');
	}
	
	function selecionarPatrimonioSetor(
			elemento, elementoOculto, 
			valorTextual, idEntidade) {
		window.MozartNS.GoogleSuggest.selecionar(elemento, valorTextual, 
				elementoOculto, idEntidade);
	}
           
    
   function cancelar(){
   	vForm = document.forms[0];
	vForm.action = '<s:url action="pesquisarImobilizadoDepreciacao!prepararPesquisa.action" namespace="/app/contabilidade" />';
	submitForm(vForm);
   }
   
   
   
   function gravar(){
       submitForm(document.forms[0]);
   }

</script>






<s:form namespace="/app/contabilidade" action="manterImobilizadoDepreciacao!gravar.action" theme="simple">

<s:hidden name="entidade.idMovimentoContabil" />
<div class="divFiltroPaiTop">Imobilizado - Depreciação</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Lançamento - Alteração</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:600px;color:blue;" ><p style="width:80px;color:black;">Bem:</p>
                    	<b><s:property value="#session.entidadeSession.numDocumentoDesc" /></b>
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:100px;" ><p style="width:80px;">D/C:</p> 
                        <b><s:property value="#session.entidadeSession.debCred" /></b>
                    </div>
                    <div class="divItemGrupo" style="width:450px;" ><p style="width:80px;">Conta:</p> 
                        <b><s:property value="#session.entidadeSession.numContaContabil" /> - <s:property value="#session.entidadeSession.nomeContaContabil" /></b>
                    </div>
                    <div class="divItemGrupo" style="width:200px;" ><p style="width:80px;">Valor:</p> 
                        <b><s:property value="#session.entidadeSession.valor" /></b>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">C. Ativo:</p> 
                        <s:textfield maxlength="8" name="entidade.controle" size="8" onkeypress="mascara(this, numeros)" />
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div id="divDoCentroCusto" class="divItemGrupo" style="width:360px;" >
					<p style="width:80px;">C. de Custo</p>
					<s:select list="centroCustoList" 
							cssStyle="width:230px;height:18px;"
							name="entidade.idCentroCustoContabil" 
							id="idCentroCustoContabil" 
							listKey="idCentroCustoContabil" 
							listValue="descricaoCentroCusto" 
							headerKey="" 
							headerValue="Selecione" /> 
				</div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width: 300px;">
					<p style="width: 80px;">Setor</p>
					<s:textfield
							cssClass="patrimonioSetor" 
							name="entidade.descPatrimonioSetor"
							id="patrimonioSetor"
							size="30" 
							maxlength="50"
							onblur="getPatrimonioSetor(this);"/>
					<s:hidden name="entidade.idPatrimonioSetor" id="idPatrimonioSetor" />
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