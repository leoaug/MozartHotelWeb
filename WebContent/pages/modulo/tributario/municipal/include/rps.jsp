<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<jsp:scriptlet>String base = request
					.getRequestURL()
					.toString()
					.substring(
							0,
							request.getRequestURL().toString()
									.indexOf(request.getContextPath())
									+ request.getContextPath().length() + 1);
			session.setAttribute("URL_BASE", base);
			response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
			response.setHeader("Cache-Control",
					"no-store, no-cache, must-revalidate");
			response.addHeader("Cache-Control", "post-check=0, pre-check=0");
			response.setHeader("Pragma", "no-cache");</jsp:scriptlet>

<html>
<head>
<base href="<%=base%>" />
<%@ include file="/pages/modulo/includes/headPage.jsp"%>
</head>
<script type="text/javascript">
function atualizar() {
	preencherValoresPai();
	document.forms[0].submit();
}

function validarObrigatoriedadeRps(){
	var tot = $("input:checkbox[class='chk'][checked='true']").length;
	
	if(tot == 0){
		return false;	
	}
	return true;
}

function preencherIdsRps(){
	var tot = $("input:checkbox[class='chk'][checked='true']").length;
		
	var idsRps = [];
	var numRps = [];

	for(var idx=0; idx < tot; idx++ ){
		idChk = $("input:checkbox[class='chk'][checked='true']")[idx].value;
		idsRps[idx] = idChk;
		numRps[idx] = Trim($($("div[id='divDup"+idChk+"'] .divItemGrupo")[1]).text()); 
	}
	parent.document.forms[0].rpsSelecionadasString.value = idsRps;
	parent.document.forms[0].numRpsSelecionadasString.value = numRps;
}

function preencherValoresPai(){
	$('#nomeArquivo').val(parent.document.forms[0].nomeArquivo.value);
}

window.onload = function() {
	killModalPai();
	killModal();
};

function killModalPai(){
	parent.killModal();
}

</script>
<body>
<div class="divGrupo"
	style="overflow: auto; margin-top: 0px; width: 965px; height: 98%; border: 0px;">
	<s:form namespace="/app/sistema"
		action="gerarLoteIss!gerarLote.action" theme="simple">
		
		<s:hidden name="nomeArquivo" id="nomeArquivo" />
		
		<div class="divLinhaCadastroPrincipal"
			style="width: 99%; float: left; height: 20px; text-align: center">
			<div class="divItemGrupo" style="width: 25px;"></div>
			<div class="divItemGrupo" style="width: 50px;">
				<p style="color: white; width: 50px;">Num.RPS</p>
			</div>
			<div class="divItemGrupo" style="width: 60px;">
				<p style="color: white; width: 60px;">Data</p>
			</div>
			<div class="divItemGrupo" style="width: 60px;">
				<p style="color: white; width: 60px;">Vr.Serviço</p>
			</div>
			<div class="divItemGrupo" style="width: 60px;">
				<p style="color: white; width: 60px;">Aliq.</p>
			</div>
			<div class="divItemGrupo" style="width: 60px;">
				<p style="color: white; width: 60px;">Vr.ISS</p>
			</div>
			<div class="divItemGrupo" style="width: 60px;">
				<p style="color: white; width: 60px;">Vr.PIS</p>
			</div>
			<div class="divItemGrupo" style="width: 50px;">
				<p style="color: white; width: 50px;">Vr.COFINS</p>
			</div>
			<div class="divItemGrupo" style="width: 50px;">
				<p style="color: white; width: 50px;">Vr.INSS</p>
			</div>
			<div class="divItemGrupo" style="width: 60px;">
				<p style="color: white; width: 60px;">Vr.CSLL</p>
			</div>
			<div class="divItemGrupo" style="width: 60px;">
				<p style="color: white; width: 60px;">Vr.ISS Ret.</p>
			</div>
			<div class="divItemGrupo" style="width: 60px;">
				<p style="color: white; width: 60px;">Outras Ret.</p>
			</div>
			<div class="divItemGrupo" style="width: 200px; text-align: left;">
				<p style="color: white; width: 200px;">Nome Fantasia</p>
			</div>

		</div>

		<s:iterator value="#session.listaPesquisa" var="rps" status="row">

			<div class="divLinhaCadastro" id='divDup<s:property value="gracIdNota" />'
				style="width: 99%; float: left; height: 20px;">
				<div class="divItemGrupo" style="width: 25px;">
					<input type="checkbox" 
						name="rpsSelecionadas" value='<s:property value="gracIdNota" />' class="chk" />
				</div>
				<div class="divItemGrupo" style="width: 50px;">
					<p style="width: 50px;">
						<s:property value="gracNotaInicial" />
					</p>
				</div>
				<div class="divItemGrupo" style="width: 60px;">
					<p style="width: 60px;">
						<s:property value="gracDataEmissao" />
					</p>
				</div>
				<div class="divItemGrupo" style="width: 60px; text-align: right;">
					<p style="width: 60px;">
						<s:property value="gracValorServico" />
					</p>
				</div>
				<div class="divItemGrupo" style="width: 60px; text-align: right;">
					<p style="width: 60px;">
						<s:property value="gracAliquota" />
					</p>
				</div>
				<div class="divItemGrupo" style="width: 60px; text-align: right;">
					<p style="width: 60px;">
						<s:property value="gracValorISS" />
					</p>
				</div>
				<div class="divItemGrupo" style="width: 60px; text-align: right;">
					<p style="width: 60px;">
						<s:property value="gracValorPIS" />
					</p>
				</div>
				<div class="divItemGrupo" style="width: 50px; text-align: right;">
					<p style="width: 50px;">
						<s:property value="gracValorCOFINS" />
					</p>
				</div>
				<div class="divItemGrupo" style="width: 50px; text-align: right;">
					<p style="width: 50px;">
						<s:property value="gracValorINSS" />
					</p>
				</div>
				<div class="divItemGrupo" style="width: 60px; text-align: right;">
					<p style="width: 60px;">
						<s:property value="gracValorCSLL" />
					</p>
				</div>
				<div class="divItemGrupo" style="width: 60px; text-align: right;">
					<p style="width: 60px;">
						<s:property value="gracISSRetido" />
					</p>
				</div>
				<div class="divItemGrupo" style="width: 60px; text-align: right;">
					<p style="">
						<s:property value="gracOutrasRetencoes" />
					</p>
				</div>
				<div class="divItemGrupo" style="width: 200px; text-align: left;">
					<p style="width: 200px;">
						<s:property value="gracRazaoSocial" />
					</p>
				</div>

			</div>
		</s:iterator>
	</s:form>
</div>
</body>

<s:if test="%{#session.ID_RPS != null && #session.ID_RPS != ''}">
	<script>
	
	vForm = parent.document.forms[0];
	vForm.action = '<s:url action="gerarLoteIss!downloadLote.action" namespace="/app/sistema" />';
	vForm.submit();
	
	</script>
</s:if>
<script>
	KillModal();
	killModalPai();
</script>

</html>