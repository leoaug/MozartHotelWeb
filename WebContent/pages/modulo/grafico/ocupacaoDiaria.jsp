<!--OcupacaoPopup.jsp-->
<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>


<script type="text/javascript">

    function init(){
        
    }
$(document).ready(

        

	function()
	{
    var iniciou = false;
     $("div.divOcuDiariaAptoDispo").click(function() { 
            iniciou  = true;
            $(this).css('border','1px solid blue');
            return false;
     } );

     $("div.divOcuDiariaAptoDispo").mouseover(function() { 
            if (iniciou){
                if ( $(this).css('border') != null ){
                    $(this).css('border','');
                }else{
                    $(this).css('border','1px solid blue');
                }
                return false;
            }
     } );
     
     $("div.divOcuDiariaAptoAtencao").mouseover(function() { 
            if (iniciou){
                if ( $(this).css('border') != null ){
                    $(this).css('border','');
                }else{
                    $(this).css('border','1px solid blue');
                }
                return false;
            }
     } );
     
     $("div.divOcuDiariaAptoOcupado").mouseover(function() { 
            if (iniciou){
                if ( $(this).css('border') != null ){
                    $(this).css('border','');
                }else{
                    $(this).css('border','1px solid blue');
                }
                return false;
            }
     } );
     
     $("div.divOcuDiariaApto").mouseout(function() { 
            if (iniciou){
                iniciou = false;
                return false;
            }
     } );
     
     
     
  }
);
    
</script>

<form action="pages/modulo/grafico/ocupacaoDiaria.jsp"><input
	type="hidden" name="id" />

<div class="divFiltroPaiTop">Ocupação Diária</div>
<div id="divFiltroPai" class="divFiltroPai">
<div id="divFiltro" class="divCadastro"
	style="overflow: auto; height: 540px; width: 940px;"><!--Início dados da ocupacao -->
<div class="divGrupo" style="width: 720px; height: 50px;">
<div class="divGrupoTitulo">Informe o período</div>

<div class="divLinhaCadastro">
<div class="divItemGrupo" style="width: 80%;">
<p>Período:</p>
<input class="dp" type="text" name="dataInicial" id="dataInicial" size="10" />
à <input class="dp" type="text" name="dataFinal"
	id="dataFinal" size="10" /></div>
</div>
</div>
<div class="divCadastroBotoes"
	style="width: 120px; margin-top: 20px; float: left;"><duques:botao
	label="Pesquisar" imagem="imagens/pesquisar.png"
	onClick="document.forms[0].submit()" /></div>
<!--Fim dados da ocupacao-->
<div class="divGrupo" style="height: 350px;">
<div class="divGrupoTitulo">Hospedagens</div>
<div class="divGrupoBody">
<div class="divOcuDiariaApto" style="height: 22px;">
<p
	style="height: 17px; padding-top: 5px; background-color: rgb(0, 148, 231);">Aptos/Dia</p>
<ul>
	<li>10</li>
	<li>11</li>
	<li>12</li>
	<li>13</li>
	<li>14</li>
	<li>15</li>
	<li>16</li>
	<li>17</li>
	<li>18</li>
</ul>
</div>


<div class="divOcuDiariaApto">
<p>101</p>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
</div>
<div class="divOcuDiariaApto">
<p>102</p>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
</div>
<div class="divOcuDiariaApto">
<p>103</p>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
</div>
<div class="divOcuDiariaApto">
<p>104</p>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
</div>
<div class="divOcuDiariaApto">
<p>105</p>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
</div>
<div class="divOcuDiariaApto">
<p>106</p>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
</div>
<div class="divOcuDiariaApto">
<p>107</p>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
</div>
<div class="divOcuDiariaApto">
<p>108</p>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
</div>
<div class="divOcuDiariaApto">
<p>109</p>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
</div>
<div class="divOcuDiariaApto">
<p>110</p>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
</div>
<div class="divOcuDiariaApto">
<p>111</p>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoOcupado">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoAtencao">1</div>
<div class="divOcuDiariaAptoDispo">1</div>
</div>
</div>

</div>

</div>
</div>
</form>