<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
        
    function mudarHotel(){
        
        document.forms[0].submit();
    }
    function setHotelCorrente(valor){
        
        document.forms[0].idHotelCorrente.value = valor;
    }


    function fecharPopupHotel(){

			if ($('#idHotelCorrente').val()=='' || $('#idHotelCorrente').val()==null){
				alerta("O campo 'Hotel' é obrigatório.");
				return false;
			}
			killModal();
      }


    function erroLancamentoTelefonia(){
		alerta("Aconteceu um erro ao lançar a telefonia");
    }
    
    function enviarArquivo(){
        valor = $('#divTelefonia').text();
        if (valor != null && valor != ''){ 
            loadingTelefonia();
        	document.getElementById("iframeLancamentoTelefonia").contentWindow.lerArquivo(valor);
        }else{
			killModal();
        }
	}  

    
    function addLinha(valor){
        if (valor != null && valor != ''){ 
        	txt = $('#divTelefonia').text(); 
        	$('#divTelefonia').text( txt + valor );
        }
	}  



    
	function showHideDetalhes( imagem ){
		var nomeBody = imagem.id+'Body';
		var nomeBodyResposta = imagem.id+'BodyResposta';
        if ($("div[id='"+nomeBody+"']").css('display')=='none' ){
			$("img[id='"+imagem.id+"']").attr('src','imagens/menos.png'); 
			$("img[id='"+imagem.id+"']").attr('title','Ocultar detalhes.'); 
			$("div[id='"+nomeBody+"']").css("display","block");
			$("div[id='"+nomeBodyResposta+"']").css("display","block");
        }else{
			$("img[id='"+imagem.id+"']").attr('src','imagens/mais.png'); 
			$("img[id='"+imagem.id+"']").attr('title','Ver detalhes.'); 
			$("div[id='"+nomeBody+"']").css("display","none");
			$("div[id='"+nomeBodyResposta+"']").css("display","none");
        }
        return false;
	}


	function marcarMensagemLida(idMensagem){
		vForm = document.forms[0];
		vForm.action = '<s:url action="selecionar!lerMensagem.action" namespace="/app" />';
		$("#idMensagem").val(idMensagem);
		$("#respostaMensagem").val(  $('#'+idMensagem+'BodyRespostaTxt').val()  );
		submitForm( vForm );
	}
    
  </script>

<div class="divBtnShortCutGroup">
<!-- <h1>.:: Atalhos ::.</h1> -->
<div>
	<ul>
	<s:iterator
	value="#session.USER_SESSION.usuarioEJB.menuIcone" var="icone"
	status="idx">
	<li>
	<s:if test="%{dsAcao.startsWith('app/') || dsAcao.startsWith('pages') }">
		<img class="imgBotao" src="<s:property value="dsImagem"/>"
			title="<s:property value="dsMenu"/>"
			onclick="window.location.href= '<%=session.getAttribute("URL_BASE")%><s:property value="dsAcao"/>'" />
	</s:if>
	<s:else>
		<img class="imgBotao" src="<s:property value="dsImagem"/>"
			title="<s:property value="dsMenu"/>"
			onclick="<s:property value="dsAcao"/>" />
	</s:else>
	</li>
</s:iterator>
</ul>	 
</div>
</div>

<div id="divApplet" style="float:right;margin-top:30px;display:<s:property value="(#session.LANCA_TELEFONIA == \"true\" && #session.SHOW_LISTA != \"TRUE\" && #session.USER_SESSION.usuarioEJB.redeHotelEJB.idRedeHotel == #session.CONTROLA_DATA_SESSION.idRedeHotel )?\"block\":\"none\" " />;">
<applet code = 'com.mozart.applet.LerTelefonia' 
        archive = '<s:url value="/applet/sMozartHotelTelefonia.jar" />',
        codebase='<s:url value="/applet" />',
        width = '200', 
        height = '20'
        style="display:<s:property value="(#session.LANCA_TELEFONIA == \"true\" && #session.SHOW_LISTA != \"TRUE\" && #session.USER_SESSION.usuarioEJB.redeHotelEJB.idRedeHotel == #session.CONTROLA_DATA_SESSION.idRedeHotel)?\"block\":\"none\" " />;" >
        <param name="TIPO_EXECUCAO" value="1"/>
        <param name="ENDERECO_FILE" value="<s:property value="#session.HOTEL_SESSION.telefoniasConfigEJB.caminho"/>"/>
        <param name="ENDERECO_FILE" value="<s:property value="#session.HOTEL_SESSION.telefoniasConfigEJB.caminho"/>"/>
        <param name="ENDERECO_INTERNET_FILE" value="<s:property value="#session.HOTEL_SESSION.telefoniasConfigEJB.caminhoInternet"/>"/>
</applet>
<iframe id="iframeLancamentoTelefonia" width="0px" height="0px" 
style="border:0px;" scrolling="no" src="<s:url value="/pages/modulo/includes/lancamentoTelefonia.jsp" />"></iframe>
</div>

<s:form action="selecionar!selecionarHotel.action" namespace="/app" theme="simple">
	
	<s:hidden name="idHotelCorrente" id="idHotelCorrente" />
	<s:hidden name="arquivoTelefonia" id="arquivoTelefonia" />
	<s:hidden name="idMensagem" id="idMensagem" />
	<s:hidden name="respostaMensagem" id="respostaMensagem" />
	

	<div id="divTelefonia" style="display:none;"></div>


	<!--Div lookup de Hoteis-->
	<div id="divModal" class="divCadastro"
		style="display: none; height: 350px; width: 600px;">
	<div class="divGrupo" style="width: 98%; height: 265px">
	<div class="divGrupoTitulo">Selecione o hotel</div>
	<div class="divGrupoBody" style="height: 82%">
	<ul>
		<s:if
			test="#session.USER_SESSION.usuarioEJB.redeHotelEJB.hoteis != null">

			<s:iterator
				value="#session.USER_SESSION.usuarioEJB.redeHotelEJB.hoteis"
				var="hotel" status="idx">


				<s:if test="#session.HOTEL_SESSION.idHotel eq idHotel">
					<script>
						document.forms[0].idHotelCorrente.value = '<s:property value="#idx.index" />';
					</script>
					<li style="color: blue;"><input id="idHotel" style="border: 0px;"
						onclick="setHotelCorrente(<s:property value="#idx.index" />)"
						name="idHotel" type="radio"
						value="<s:property value="#idx.index" />" checked="checked" />
					<b><s:property value="#session.USER_SESSION.usuarioEJB.nick.equals(\"MANUTENCAO\")?redeHotelEJB.sigla+\" - \":\"\"" /></b>
						<s:property value="nomeFantasia" />

					</li>
				</s:if> <s:else>
					
				
					<li><input id="idHotel" style="border: 0px;"
						onclick="setHotelCorrente(<s:property value="#idx.index" />)"
						name="idHotel" type="radio"
						value="<s:property value="#idx.index" />" />
						<b><s:property value="#session.USER_SESSION.usuarioEJB.nick.equals(\"MANUTENCAO\")?redeHotelEJB.sigla+\" - \":\"\"" /></b>
						<s:property value="nomeFantasia" />

						</li>
				</s:else> 

			</s:iterator>


		</s:if>
		<s:else>
			<script>
						document.forms[0].idHotelCorrente.value = '0';
			</script>
			<li><input id="idHotel" style="border: 0px;"
				name="idHotel" type="radio"
				value="<s:property value="#session.HOTEL_SESSION.idHotel" />"
				checked="checked" /> <s:property
				value="#session.HOTEL_SESSION.nomeFantasia" /></li>
		</s:else>

	</ul>
	</div>
	</div>
	<div class="divCadastroBotoes" style="width: 98%;"><duques:botao
		label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="fecharPopupHotel()" />
	<s:if test="#session.USER_ADMIN eq 'TRUE'">
		<duques:botao label="Selecionar" style="width:120px;"
			imagem="imagens/iconic/png/check-3x.png" onClick="mudarHotel();" />
	</s:if></div>
	</div>
	<!--final div lookup de Hoteis-->

	<!--Div de mensagens-->


	<div id="divModalMensagem" class="divCadastro"
		style="display: none; height: 550px; width: 900px;">
	<div class="divGrupo" style="width: 98%; height: 465px">
	<div class="divGrupoTitulo">Mensagens</div>
	<div class="divGrupoBody" style="height: 82%">

		<s:iterator value="#session.listMensagem" var="linha">	

			<div class="divLinhaCadastro" style='background-color:<s:property value="mensagemWeb.nivel==2?\"yellow\":mensagemWeb.nivel==3?\"red\":\"\"" />;'>
				<div class="divItemGrupo" style="width:25px"> <img onclick="showHideDetalhes(this)" id="<s:property value="mensagemWeb.idMensagem" />" title="Ver detalhes" src="imagens/mais.png" width="18px" height="18px" /> </div>
				<div class="divItemGrupo" style="width:140px"><p style="width:20px">De:</p><p  style="width:120px;color:blue"><s:property value="mensagemWeb.usuarioEJB.nick.substring(7)" /></p></div>
				<div class="divItemGrupo" style="width:150px"><p style="width:20px">às:</p><p style="width:125px;color:blue"><s:property value="mensagemWeb.dataCriacao" /></p></div>
				<div class="divItemGrupo" style="width:500px"><p style="width:40px">Título:</p><p  style="width:450px;color:blue"> <s:property value="mensagemWeb.titulo" /></p></div>
			</div>
			<div class="divLinhaCadastro" id="<s:property value="mensagemWeb.idMensagem+\"Body\"" />" style="display:none;height:50px;color:black;background:white;">
				<div class="divItemGrupo" style="width:620px;color:black;"> 
					<s:property value="mensagemWeb.descricao" />
				</div>
			</div>
			<div class="divLinhaCadastro" id="<s:property value="mensagemWeb.idMensagem+\"BodyResposta\"" />" style="display:none;height:60px;color:black;background:white;">
				<div class="divItemGrupo" style="width:65px"><p style="width:60px;">Resposta</p></div>
				<div class="divItemGrupo" style="width:550px;color:black;"> 
					<textarea rows="2" cols="60" id="<s:property value="mensagemWeb.idMensagem+\"BodyRespostaTxt\"" />"></textarea>
				</div>
				<div class="divItemGrupo" style="width:30px"> <img title="Marcar como lida" src="imagens/iconic/png/check-4x.png" onclick="marcarMensagemLida('<s:property value="mensagemWeb.idMensagem" />')" /> </div>
			</div>
		
		</s:iterator>

	
	</div>
	</div>
	<div class="divCadastroBotoes" style="width: 98%;">
		<duques:botao label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="$.modal.close()" />
	</div>
	</div>
	<!--fim Div de mensagens-->


	<!--<div id="divCentral" class="divCentralMain"
		style="left: 0px; padding: 0px; background-image: url('imagens/Mozart_centro.png'); background-position: center; background-repeat: no-repeat;"/></div>-->

	<div class="divMainColuna" style="width: 20px; left: 0px;">

	<div onclick="showModal('#divModal')"
		onmouseout="$(this).css('background-color','');"><img
		src="imagens/imgHotelPrata.png" title="Selecione uma Unidade " /></div>
	<div onclick="showModal('#divModalMensagem')"
		onmouseout="$(this).css('background-color','');"><img
		src="imagens/imgMensagemPrata.png" title="Veja suas mensagens" /></div>



	</div> 


	</div>
</s:form>
<s:if test='%{#session.SEM_PERMISSAO == "TRUE"'>
<%session.removeAttribute("SEM_PERMISSAO"); %>
<script type="text/javascript">
alerta('<s:property value="com.mozart.web.util.MozartConstantesWeb.MENSAGEM_USUARIO_CONSULTA" />');
</script>



</s:if> 



<s:if test='%{#session.SHOW_LISTA == "TRUE" || (!#session.USER_SESSION.usuarioEJB.nick.equals("MANUTENCAO") && #session.USER_SESSION.usuarioEJB.redeHotelEJB.idRedeHotel != #session.CONTROLA_DATA_SESSION.idRedeHotel)}'>
<%session.removeAttribute("SHOW_LISTA");%>
<s:if test="%{#session.USER_SESSION.usuarioEJB.redeHotelEJB.hoteis != null && #session.USER_SESSION.usuarioEJB.redeHotelEJB.hoteis.size() > 1}">
<script type="text/javascript">
$(function() {
    
    $(window).load( function () { 
    	showModal('#divModal');

    } );

	
 });
</script>
</s:if>
</s:if>

<s:if test='%{abrirMensagem == \"S\"}'>
<script type="text/javascript">
$(function() {
    $(window).load( function () {
  		showModal('#divModalMensagem');
	} );
});
</script>
</s:if>