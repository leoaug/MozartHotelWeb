<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">

           
    
            function cancelar(){

            	
            	<%if (session.getAttribute("CRS_SESSION_NAME")==null){%>     
                	cancelarOperacao('<%=session.getAttribute("URL_BASE")%>');
                <%}else{%>
                	window.location.href= '<%=session.getAttribute("URL_BASE")%>app/crs/pesquisarCRS!prepararPesquisa.action';
                <%}%>
            }
            
            
            
            function gravar(){
            
            
                if ($("input[name='senhaAtual']").val() == ''){
                    alerta('Campo "Senha" é obrigatório.');
                    return false;
                }
                if ($("input[name='usuario.senha']").val() == ''){
                    alerta('Campo "Senha" é obrigatório.');
                    return false;
                }
                if ($("input[name='confimacaoSenha']").val() == ''){
                    alerta('Campo "Confirmação" é obrigatório.');
                    return false;
                }

               if ($("input[name='usuario.senha']").val() != $("input[name='confimacaoSenha']").val()){
                    alerta('Campo "Confirmação" está inválido.');
                    return false;
                }
            
                document.forms[0].submit();
            }

        </script>






<s:form namespace="/app/usuario" action="trocasenha!trocarSenha.action"
	theme="simple">

	<div class="divFiltroPaiTop">Alteração de senha</div>
	<div class="divFiltroPai">
	<div class="divCadastro" style="overflow: auto;">
	<div class="divGrupo" style="height: 400px;">
	<div class="divGrupoTitulo">Dados do usuário</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 90%;">
	<p>Senha atual:</p>
	<s:password maxlength="20" name="senhaAtual" id="senhaAtual" size="20" />
	</div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 90%;">
	<p>Nova senha:</p>
	<s:password maxlength="20" name="usuario.senha" id="senha" size="20" />
	</div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 90%;">
	<p>Confirmação:</p>
	<s:password maxlength="20" name="confimacaoSenha" id="confimacaoSenha"
		size="20" /></div>
	</div>
	</div>


	<div class="divCadastroBotoes"><duques:botao label="Voltar"
		imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" /> <duques:botao
		label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" /></div>

	</div>
	</div>
</s:form>