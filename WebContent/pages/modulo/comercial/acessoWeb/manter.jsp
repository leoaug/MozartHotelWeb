<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarAcessoWeb!prepararPesquisa.action" namespace="/app/comercial" />';
        		submitForm(vForm);
            }
            
            
            function gravar(){
                        
                if ($("input[name='entidade.empresaEJB.idEmpresa']").val() == ''){
                    alerta('Campo "Empresa" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.nome']").val() == ''){
                    alerta('Campo "Nome" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.email']").val() == ''){
                    alerta('Campo "E-mail" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.password']").val() == ''){
                    alerta('Campo "Senha" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.dataValidade']").val() == ''){
                    alerta('Campo "Data validade" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.password']").val() != 
                	$("input[name='confirmacao']").val()){
                    alerta('Campo "Confirmação" é diferente da senha.');
                    return false;
                }

                
                submitForm(document.forms[0]);                
            }

            function getEmpresa(elemento) {
        		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarEmpresa?OBJ_NAME='+ elemento.id + '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idEmpresa';
        		getDataLookup(elemento, url, 'Empresa', 'TABLE');
        	}

        </script>


<s:form namespace="/app/comercial" action="manterAcessoWeb!gravar.action" theme="simple">

<s:hidden name="entidade.idUser" />
<div class="divFiltroPaiTop">Acesso web para empresa</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados do acesso</div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Empresa:</p>
						<s:textfield onblur="getEmpresa(this)" name="entidade.empresaEJB.nomeFantasia" size="40" maxlength="50" id="empresa" /> 
						<s:hidden name="entidade.empresaEJB.idEmpresa" id="idEmpresa" />
		              </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Nome:</p>
                        	<s:textfield maxlength="40"  name="entidade.nome"  id="entidade.nome" size="40" onblur="toUpperCase(this)" />
                    </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">E-mail:</p>
                        	<s:textfield maxlength="50"  name="entidade.email"  id="entidade.email" size="40" onblur="toUpperCase(this)" />
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Senha:</p>
                        	<s:password maxlength="10"  name="entidade.password"  id="entidade.password" size="15" />
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Confirmação:</p>
                        	<input type="password" maxlength="10"  name="confirmacao"  id="confirmacao" size="15" />
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Data validade:</p>

<s:textfield cssClass="dp" id="dataIni" name="entidade.dataValidade" size="15" onblur="dataValida(this)" maxlength="10" onkeypress="mascara(this,data)" /> 
                    </div>
                </div>
      
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Master:</p>
								<s:select list="#session.LISTA_CONFIRMACAO"
								cssStyle="width:80px;"
								listKey="id"
								listValue="value" 
								name="entidade.master"/>                        	
                     </div>
                </div>
      
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Ativo:</p>
								<s:select list="#session.LISTA_CONFIRMACAO"
								cssStyle="width:80px;"
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