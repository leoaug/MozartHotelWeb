<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarCamareira!prepararPesquisa.action" namespace="/app/operacional" />';
        		submitForm(vForm);
            }
            
            window.onload = function() {
        		addPlaceHolder('nome');
        	};
        	
        	function addPlaceHolder(classe) {
        		document.getElementById(classe).setAttribute("placeholder",
        				"ex.: DIGITAR O LOGIN OU NOME DO USUARIO");
        	}
            
            function gravar(){
                        
                if ($("input[name='entidade.nomeCamareira']").val() == ''){
                    alerta('Campo "Nome" é obrigatório.');
                    return false;
                }
                
                if ($("input[name='idUsuario']").val() == ''){
                    alerta('Campo "Nome" é obrigatório.');
                    return false;
                }
                
                if ($("input[name='entidade.ativo']").val() == ''){
                    alerta('Campo "Ativo" é obrigatório.');
                    return false;
                }
                
                submitForm(document.forms[0]);
                
            }
            
            function getUsuarios(elemento) {
            	url = 'app/ajax/ajax!obterUsuarios?OBJ_NAME=' + elemento.id 
            			+ '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idUsuario';
            	getDataLookup(elemento, url, 'nome', 'TABLE');
            }


</script>


<s:form namespace="/app/operacional" action="manterCamareira!gravarCamareira.action" theme="simple">

<s:hidden name="entidade.idCamareira" />
<div class="divFiltroPaiTop">Camareira </div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados da camareira</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Nome:</p>
                        	<s:textfield maxlength="40"  name="entidade.nomeCamareira"  id="nome" size="40" onblur="getUsuarios(this)" />
                        	<s:hidden name="idUsuario" id="idUsuario" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:80px;">Ativo:</p> 
                        <s:select list="#session.LISTA_CONFIRMACAO" 
                                  cssStyle="width:50px;" 
                                  listKey="id"
                                  listValue="value"
                                  name="entidade.ativo"/>
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