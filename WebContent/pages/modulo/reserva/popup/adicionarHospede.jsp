<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>



<html>
<script type="text/javascript">
  
        function adicionarHospede(){
            window.opener.adicionarHospede(document.getElementById('nomeHospede').value);      
             $('#divCentral').removeClass("divCentralOpaco");
             $('#divCentral').addClass("divCentral");
        }
  
</script>
<div id="divFiltroPai" class="divFiltroPai" style="width: 580px;">
<div class="divFiltroPaiTop">
<h1>Hóspedes</h1>
</div>
<div id="divFiltro" class="divCadastro" style="height: 200px;">

<div class="divGrupo" style="width: 98%; height: 110px"><img
	src="imagens/tituloGrupo.jpg" />
<h1>Dados do hóspede</h1>

<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 50pt;">
<p style="width: 99%;">Nome</p>
</div>
<div class="divItemGrupo" style="width: 150pt;"><input
	type="text" name="nomeHospede" id="nomeHospede" maxlength="50"
	size="50" /></div>
</div>
</div>

<div class="divCadastroBotoes" style="width: 98%;"><duques:botao
	label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="window.close();" />
<duques:botao label="Adicionar" style="width:120px;"
	imagem="imagens/iconic/png/check-2x.png" onClick="adicionarHospede();" /></div>
</div>
</div>



</html>