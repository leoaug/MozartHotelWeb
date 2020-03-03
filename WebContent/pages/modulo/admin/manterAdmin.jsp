<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">

        
         
          function load(id) {

                var _url = "app/ajax/ajax!obterConteudoArquivo?nomeArquivo="+id;
                $('div.divConteudoArquivo').html("<ul><li><img src='imagens/loading.gif' title='Carregando...'/><label>Carregando, por favor aguarde.<//label><//li><//ul>");
                getAjaxValue(_url, ajaxCallback);
            }
            
            function ajaxCallback(msg){
                $('div.divConteudoArquivo').html(msg);
            }
            
            function cancelar(){
                cancelarOperacao('<%=session.getAttribute("URL_BASE")%>');
            }            
            
            function atualizar(){
                window.location.href= '<%=session.getAttribute("URL_BASE")%>app/admin/admin!preparar.action';
            }        
            

        </script>






<s:form action="app/admin/admin.action" theme="simple">


	<div class="divFiltroPaiTop">Administração</div>
	<div class="divFiltroPai">
	<div class="divCadastro" style="overflow: auto;">
	<div class="divGrupo" style="height: 240px;">
	<div class="divGrupoTitulo">Logs</div>

	<div class="divLinhaCadastro" style="height: 210px;">
	<div class="divItemGrupo" style="width: 210px;">
	<p>Arquivos de log:</p>
	<s:select list="listaArquivos" ondblclick="load(this.value)"
		cssStyle="width:150pt;" size="11" /></div>
	<div class="divItemGrupo" style="width: 730px;">
	<p>Conteúdo:</p>
	<div class="divConteudoArquivo"></div>
	</div>

	</div>
	</div>


	<div class="divGrupo" style="height: 150px;">
	<div class="divGrupoTitulo">Sessões on-line</div>
	<div style="height: 120px; width: 100%; overflow-y: auto;"><s:iterator
		value="listaSessoes" var="users" status="row">

		<div class="divLinhaCadastro" style="width: 99%;">
		<div class="divItemGrupo" style="width: 220px;">
		<p style="width: 40px;">Login:</p>
		<s:property value="usuarioEJB.nick" /></div>
		<div class="divItemGrupo" style="width: 200px;">
		<p style="width: 70px;">Data Login:</p>
		<s:property value="dtCriacao" /></div>
		<div class="divItemGrupo" style="width: 520px;">
		<p style="width: 70px;">Sessão ID:</p>
		<s:property value="sessionId" /></div>
		</div>
	</s:iterator></div>

	</div>

	<div class="divCadastroBotoes"><duques:botao label="Voltar"
		imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" /> <duques:botao
		label="Atualizar" imagem="imagens/iconic/png/loop-circular-3x.png"
		onClick="atualizar()" /></div>

	</div>
	</div>


</s:form>