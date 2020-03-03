<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@ taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>




<script type="text/javascript">

    function init(){
        
    }
    
</script>

<jsp:scriptlet>

    request.setAttribute("mensagemErro1","Teste marcio");

    String nomeLogado = (String)pageContext.getAttribute("NOME", PageContext.APPLICATION_SCOPE );

    if(nomeLogado==null){
        pageContext.setAttribute("NOME", request.getParameter("nome"), PageContext.APPLICATION_SCOPE);
    
    }else if (nomeLogado.equals(request.getParameter("nome"))){
        request.setAttribute("mensagemErro","O seguinte usuário já foi solicitado: " + nomeLogado);
    }else{
        request.setAttribute("mensagemErro","O seguinte usuário não foi solicitado: " + request.getParameter("nome"));
    }
    


</jsp:scriptlet>


<form><input type="hidden" name="id" />

<div id="divFiltroPai" class="divFiltroPai">
<h1>Cadastro de Reservas</h1>
<div class="divFiltroPaiTop">
<div class="divFiltroPaiLeft" id="divFiltroPaiLeft"><img
	src="imagens/abaPrata.png" onclick="alert('titulo')" title="Título" /></div>

</div>
<div id="divFiltro" class="divCadastro">

<div class="divGrupo" style="width: 600px; height: 235px"><img
	src="imagens/tituloGrupo.jpg" />
<h1>Dados Pessoais</h1>
<table border="0">
	<tr>
		<td>Nome:</td>
		<td><input type="text" name="nome"></td>
	</tr>
	<tr>
		<td>Nome digitado:</td>
		<td>
		<jsp:scriptlet>out.println(request.getParameter("nome"));</jsp:scriptlet>
		</td>
	</tr>


</table>
</div>

<div class="divGrupo"><img src="imagens/tituloGrupo.jpg" />
<h1>Forma da Reserva</h1>
<table border="0">
	<tr>
		<td><input type="radio" name=""></td>
		<td>Nome</td>
	</tr>
	<tr>
		<td><input type="radio" name=""></td>
		<td>Endereço</td>
	</tr>
	<tr>
		<td><input type="radio" name=""></td>
		<td>Telefone</td>
	</tr>
</table>
</div>
<div class="divGrupo"><img src="imagens/tituloGrupo.jpg" />
<h1>Contato</h1>
<table border="0">
	<tr>
		<td><input type="radio" name=""></td>
		<td>Nome</td>
	</tr>
	<tr>
		<td><input type="radio" name=""></td>
		<td>Endereço</td>
	</tr>
	<tr>
		<td><input type="radio" name=""></td>
		<td>Telefone</td>
	</tr>
</table>
</div>

<div class="divGrupo"><img src="imagens/tituloGrupo.jpg" />
<h1>Forma de pagamento</h1>
<table border="0">
	<tr>
		<td><input type="radio" name=""></td>
		<td>Nome</td>
	</tr>
	<tr>
		<td><input type="radio" name=""></td>
		<td>Endereço</td>
	</tr>
	<tr>
		<td><input type="radio" name=""></td>
		<td>Telefone</td>
	</tr>
</table>
</div>
<div class="divGrupo"><img src="imagens/tituloGrupo.jpg" />
<h1>Outros dados</h1>
<table border="0">
	<tr>
		<td><input type="radio" name=""></td>
		<td>Nome</td>
	</tr>
	<tr>
		<td><input type="radio" name=""></td>
		<td>Endereço</td>
	</tr>
	<tr>
		<td><input type="radio" name=""></td>
		<td>Telefone</td>
	</tr>
</table>
</div>

<div class="divCadastroBotoes"><duques:botao label="Voltar"
	imagem="imagens/exportarPDF.jpg" onClick="alerta('clique')" /> <duques:botao
	label="Gravar" imagem="imagens/exportarPDF.jpg"
	onClick="document.forms[0].submit()" /></div>
</div>
</div>
</form>