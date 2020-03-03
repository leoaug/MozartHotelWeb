<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">

           
    
            function cancelar(){
                vForm = document.forms[0];
                vForm.action = '<s:url action="pesquisar!preparaPesquisa.action" namespace="/app/alfa" />';
                vForm.submit();
            }
            
            function gravar(){
            
            
                if ($("input[name='arquivo']").val() == ''){
                    alerta('Campo "Arquivo" é obrigatório.');
                    return false;
                }            
                document.forms[0].submit();
            }

        </script>






<s:form namespace="/app/alfa" action="manter!upload.action"
	theme="simple" enctype="multipart/form-data">

	<div class="divFiltroPaiTop">Upload de chaves</div>
	<div class="divFiltroPai">
	<div class="divCadastro" style="overflow: auto;">
	<div class="divGrupo" style="height: 80px;">
	<div class="divGrupoTitulo">Arquivo</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 90%;">
	<p>Arquivo:</p>
	<s:file name="arquivo" size="80" /></div>
	</div>
	</div>


	<s:if test="conteudo != null">
		<div class="divGrupo" style="height: 320px;">
		<div class="divGrupoTitulo">Conteúdo</div>

		<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width: 30%;">
		<p>Nome:</p>
		<s:property value="arquivoFileName" /></div>
		<div class="divItemGrupo" style="width: 30%;">
		<p>Qtde. linhas:</p>
		<s:property value="conteudo.size" /></div>
		</div>

		<div class="divGrupoBody" style="height: 82%; border: 1px solid red;">
		<ul>
			<s:iterator value="conteudo">
				<li><s:property /></li>
			</s:iterator>
		</ul>
		</div>

		</div>



	</s:if>


	<div class="divCadastroBotoes"><duques:botao label="Voltar"
		imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" /> <duques:botao
		label="Upload" imagem="imagens/upload.png" onClick="gravar()" /></div>

	</div>
	</div>
</s:form>