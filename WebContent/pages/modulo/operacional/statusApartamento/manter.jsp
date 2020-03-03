<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<jsp:include page="/pages/modulo/includes/cache.jsp" />

<!--meta http-equiv="refresh" content="15" /-->
<script type="text/javascript">

    function init(){
        
    }
    
</script>

<script>
currentMenu = "divStatus";
with(milonic=new menuname("divStatus")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar status do apartamento;url=javascript:alterarStatusApto();");
drawMenus(); 
}

with(milonic=new menuname("divSemMenu")){
	margin=3;
	style=contextStyle;
	top="offset=2";
}

</script>

<script type="text/javascript">

    
    function mouseOut(id){
    
    
    }

    function validaId(){
        
        if ($('#id').val() == ''){
            alerta('Selecione um apartamento');
            return false;
        }
        return true;
    }




    function filtrar(pTipoFiltro){

	        $("div.divAptoOcupado").css('display','none');
	        $("div.divApto").css('display','none');

			if (pTipoFiltro == 'TODOS'){

		        $("div.divAptoOcupado").css('display','block');
		        $("div.divApto").css('display','block');

			}else{
		        $("div[id$=';"+pTipoFiltro+"']").css('display','block');
		        $("div[id$=';"+pTipoFiltro+"']").css('display','block');
			}

			calcular();	        
    }
    
    function calcular(){
    	$("#qtdeLivreLimpo").text ("- ("+ $("img.qtdeLivreLimpo").size() +")" );
	    $("#qtdeLivreArrumado").text ("- ("+ $("img.qtdeLivreArrumado").size() +")" );
	    $("#qtdeLivreSujo").text ("- ("+ $("img.qtdeLivreSujo").size() +")" );
	    $("#qtdeInterditado").text ("- ("+ $("img.qtdeInterditado").size()+")" );
	    $("#qtdeOcupadoSujo").text ("- ("+ $("img.qtdeOcupadoSujo").size() +")" );
	    $("#qtdeOcupadoArrumado").text ("- ("+ $("img.qtdeOcupadoArrumado").size() +")" );
	    $("#qtdeTodos").text ("- ("+ $("img.qtdeTotal").size()+")" );

	    $("#imgQtdeLivreArrumado").css('display', ($("img.qtdeLivreArrumado").size()==0?'none':'block') );
	    $("#imgQtdeLivreLimpo").css('display', ($("img.qtdeLivreLimpo").size()==0?'none':'block') );
	    $("#imgQtdeLivreSujo").css('display', ($("img.qtdeLivreSujo").size()==0?'none':'block') );
	    $("#imgQtdeInterditado").css('display', ($("img.qtdeInterditado").size()==0?'none':'block') );
	    $("#imgQtdeOcupadoSujo").css('display', ($("img.qtdeOcupadoSujo").size()==0?'none':'block') );
	    $("#imgQtdeOcupadoArrumado").css('display', ($("img.qtdeOcupadoArrumado").size()==0?'none':'block') );

    }


    function alterarStatusApto(){
    	vForm = document.forms[0];
    	antigoStatus = vForm.id.value.split(';')[1];
		showStatus(antigoStatus);
    }

    function showDivStatus(pStatusAntigo){
			$('#id').val ('');
			showStatus( pStatusAntigo );
    }

    function showStatus( pStatusAntigo ){
		vForm = document.forms[0];
		vForm.antigoStatus.value = pStatusAntigo;
		$('#spanStatusOrigem').text ( pStatusAntigo=='LS'?'Livre/Sujo':pStatusAntigo=='LA'?'Livre/Arrumado':pStatusAntigo=='LL'?'Livre/Limpo':pStatusAntigo=='OA'?'Ocupado/Arrumado':pStatusAntigo=='OS'?'Ocupado/Sujo':'Interditado' );
		url = '${sessionScope.URL_BASE}app/ajax/ajax!pesquisarStatusApartamento?idStatusOrigem='+pStatusAntigo;
		preencherCombo('statusPara', url);    
		submitFormAjax('pesquisarApartamentoStatus?idApartamento='+$('#id').val()+'&status='+pStatusAntigo,true);
		showModal('#divStatus');
    }

    function preencherDivApartamento( status, valores ){
		
		if (valores != null && valores != ''){
			imagem = (status=='LS'?'imagens/aptoLivreSujo.png':status=='LL'?'imagens/aptoLivreLimpo.png':status=='LA'?'imagens/aptoLivreArrumado.png':status=='OA'?'imagens/aptoOcupadoArrumado.png':status=='OS'?'imagens/aptoOcupadoSujo.png':'imagens/aptoInter.png');
			lista = "<ul>\n";
			lista += "<li style='width:150px;float:left'><input type='checkbox' value='' class='chkTodos' id='chkTodos' onclick='marcarTodos(this)'/><img src='imagens/btnTodos.png'/><b>TODOS</b></li>";
	        opts = valores.split(';');
	        for (i = 0; i < opts.length; i++)  {           
	        	arr = opts[i].split(',');
	        	lista += "<li style='width:150px;float:left'><input type='checkbox' "+($('#id').val().indexOf(Trim(arr[0])+";")>=0?'checked':'' )+" name='ids' id='ids' value='"+Trim(arr[0])+"'/><img src='"+imagem+"' />"+Trim(arr[1])+"</li>";
	        }
			lista += "</ul>\n";
			$('#divAptoDisponivel').html ( lista );			
		}

    }

    
    function alterarStatus(){
		
    	novoStatus = $('#statusPara').val();


    	if (novoStatus == ''){
			alerta("O campo 'Para' é obrigatório.");
			return false;
        }
        
		if ('IN' == novoStatus){

			if ($('#dataInicio').val() == ''){
				alerta("O campo 'Data início' é obrigatório.");
				return false;
			}
			if ($('#dataFim').val() == ''){
				alerta("O campo 'Data fim' é obrigatório.");
				return false;
			}

			if ($('#observacao').val() == ''){
				alerta("O campo 'Observação' é obrigatório.");
				return false;
			}

			if (pegaDiferencaDiasDatas($('#dataFim').val(), $('#dataInicio').val()) < 0){
				alerta("O campo 'Data Fim' deve ser maior que 'Data Início'.");
				return false;
			}
		}


		

        total = $("input:checkbox[id='ids'][checked='true']").length;
		if (total == 0){
			alerta("Marque ao menos um apartamento.");
			return false;
		}
    	
    	if (confirm('Confirma a alteração do status?')){
    		chkMarcados = ';';
        	tot = $("input:checkbox[id='ids'][checked='true']").length;
        	for(idx=0; idx < tot; idx++ ){
        		chkMarcados += $("input:checkbox[id='ids'][checked='true']")[idx].value + ";";
            }
            
    		vForm = document.forms[0];
    		vForm.idMarcados.value = chkMarcados;
			vForm.novoStatus.value = novoStatus;
			vForm.obs.value = $('#observacao').val();
			vForm.dataInicioIN.value = $('#dataInicio').val();
			vForm.dataFimIN.value = $('#dataFim').val();
    		vForm.action = '<s:url action="manterStatusApartamento!alterarStatus.action" namespace="/app/operacional" />';
			submitForm(vForm);
    	}
    }

    function verificaComplemento(){

		var st = $('#statusPara').val();
		if (st=='IN'){
			$('#divLinhaInterditado').css('display','block');
			$('#observacao').val('');
			$('#dataInicio').val('<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>');
			$('#dataFim').val('');
		}else{
			$('#divLinhaInterditado').css('display','none');
			$('#dataInicio').val('');
		}
    	
    }

     function marcarTodos( obj ) { 
                newValue = obj.checked;
                $("input:checkbox[id='ids']").attr('checked',newValue);
    }
    
     function fecharStatus(){
    	 location.reload(true);
     }

   
</script>
<div style="display: none"><%=new java.util.Date()%></div>

<s:form action="pesquisarStatusApartamento!pesquisar.action" namespace="/app/operacional" theme="simple">

	<s:hidden name="id" id="id" />
	<s:hidden name="idMarcados" id="idMarcados" />
	<input type="hidden" name="classe" id="classe" />
	<s:hidden name="antigoStatus" id="antigoStatus" />
	<s:hidden name="novoStatus" id="novoStatus" />
	<s:hidden name="obs" id="obs" />
	<s:hidden name="dataInicioIN" id="dataInicioIN" />
	<s:hidden name="dataFimIN" id="dataFimIN" />
	
<!--  inicio div status -->

<div id="divStatus" class="divCadastro" style="display: none; height: 450px; width: 800px;">
<div class="divGrupo" style="width: 98%; height: 380px">
<div class="divGrupoTitulo">Alteração do Status</div>

	<div class="divLinhaCadastro" >
		<div class="divItemGrupo" style="width: 250px;">
			<p style="width: 70px;">De: </p><span id="spanStatusOrigem" style="color:red"></span>  
		</div>
		<div class="divItemGrupo" style="width: 350px;">
			<p style="width: 70px;">Para: </p><select id="statusPara" name="statusPara" style="width:150px" onchange="verificaComplemento()"></select>  
		</div>
	</div>
	<div id="divLinhaInterditado" style="display:none">	
		<div  class="divLinhaCadastro" >
			<div class="divItemGrupo" style="width: 250px;">
				<p style="width: 70px;">Data início:</p>
				      <input style="background-color:silver;" id="dataInicio" type="text" name="dataInicio" size="15" readonly="readonly" maxlength="10" onkeypress="mascara(this,data)" />
			</div>
			<div class="divItemGrupo" style="width: 350px;">
				<p style="width: 70px;">Data fim:</p>
				      <input class="dp" id="dataFim" type="text" name="dataInicio"  size="15" onBlur="dataValida(this)" maxlength="10" onkeypress="mascara(this,data)" />
			</div>
		</div>
		<div class="divLinhaCadastro" style="height:60px;">
			<div class="divItemGrupo" style="width: 500px;">
				<p style="width: 70px;">Observação:</p>
				<textarea id="observacao" rows="2" cols="30"></textarea>      
			</div>
		</div>
	</div>
	<div class="divLinhaCadastro"  style="height:200px; background-color:white; border: 1px solid black; overflow: auto;">
		<div class="divAptoOpcoes" id="divAptoDisponivel" style="width:90%; height:198px;">
		</div>
	</div>	
</div>

<div class="divCadastroBotoes" style="width: 98%;">
<duques:botao label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="fecharStatus()" />
<duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="alterarStatus()" />
</div>
</div>

<!--  fim div status -->

	<div class="divFiltroPaiTop" style="width: 210px;">Status</div>
	<div class="divFiltroPai">

	<div class="divCadastro" style="overflow: auto;">
	<div class="divGrupo" style="height: 510px; width: 21%;">
	<div class="divGrupoTitulo">Opções</div>
	<div class="divAptoOpcoes">
	<ul>
		<li onclick="filtrar('LL')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');">
		<img src="imagens/aptoLivre.png" title="Livre e limpo" />
		<p>Livre/Limpo</p>
		<p id="qtdeLivreLimpo" style="color: red"></p>
		<img id="imgQtdeLivreLimpo" style="float:right;" alt="Alterar status" src="imagens/iconic/png/loop-circular-3x.png" onclick="showDivStatus('LL')" /> 
		</li>

		<li onclick="filtrar('LA')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');">
		<img src="imagens/aptoLivreArrumado.png" title="Livre e arrumado" />
		<p>Livre/Arrumado</p>
		<p id="qtdeLivreArrumado" style="color: red"></p>
		<img id="imgQtdeLivreArrumado" style="float:right;" alt="Alterar status" src="imagens/iconic/png/loop-circular-3x.png" onclick="showDivStatus('LA')" /> 
		</li>

		<li onclick="filtrar('LS')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');">
		<img src="imagens/aptoLivreSujo.png" title="Livre e sujo" />
		<p>Livre/Sujo</p>
		<p id="qtdeLivreSujo" style="color: red"></p>
		<img id="imgQtdeLivreSujo" style="float:right;" alt="Alterar status" src="imagens/iconic/png/loop-circular-3x.png" onclick="showDivStatus('LS')" /> 
		</li>
		
		<li onclick="filtrar('IN')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');">
			<img src="imagens/aptoInter.png" title="Interditado" />
		<p>Interditado</p>
		<p id="qtdeInterditado" style="color: red"></p>
		<img id="imgQtdeInterditado" style="float:right;" alt="Alterar status" src="imagens/iconic/png/loop-circular-3x.png" onclick="showDivStatus('IN')" />
		</li>

		<li onclick="filtrar('OA')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/aptoOcupadoArrumado.png" title="Ocupado e arrumado" />
		<p>Ocupado/Arrumado</p>
		<p id="qtdeOcupadoArrumado" style="color: red"></p>
		<img id="imgQtdeOcupadoArrumado" style="float:right;" alt="Alterar status" src="imagens/iconic/png/loop-circular-3x.png" onclick="showDivStatus('OA')" />
		</li>

		<li onclick="filtrar('OS')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');"><img
			src="imagens/aptoOcupadoSujo.png" title="Ocupado e Sujo" />
		<p>Ocupado/Sujo</p>
		<p id="qtdeOcupadoSujo" style="color: red"></p>
		<img id="imgQtdeOcupadoSujo" style="float:right;" alt="Alterar status" src="imagens/iconic/png/loop-circular-3x.png" onclick="showDivStatus('OS')" />
		</li>
		
		<li onclick="filtrar('TODOS')"
			onmouseover="$(this).css('background-color','rgb(181,231,255)');"
			onmouseout="$(this).css('background-color','');">
		<img src="imagens/btnTodos.png" title="Todos" />
		<p>Todos</p><p id="qtdeTodos" style="color: red"></p>
		</li>
		
	</ul>
	</div>
	</div>


	<div class="divGrupo" style="height: 98%; width: 72%;">
	<div class="divGrupoTitulo">Apartamentos</div>
	<div style="height: 98%; width: 100%; overflow-y: auto;">
		
	<s:iterator value="#session.listaApartamento" status="row" var="obj">
		<s:if test='%{status == "OS"}'>
			<s:set name="statusSelecionado" value="%{'divAptoOcupado'}" />
			<s:set name="menu" value="%{'divStatus'}" />
		</s:if>
		<s:elseif test='%{status == "OA" }'>
			<s:set name="statusSelecionado" value="%{'divAptoOcupado'}" />
			<s:set name="menu" value="%{'divStatus'}" />
		</s:elseif>
		<s:elseif test='%{status == "LL" || status == "LS" || status == "LA"}'>
			<s:set name="statusSelecionado" value="%{'divApto'}" />
			<s:set name="menu" value="%{'divStatus'}" />
		</s:elseif>
		<s:elseif test='%{status == "IN"}'>
			<s:set name="statusSelecionado" value="%{'divApto'}" />
			<s:set name="menu" value="%{'divStatus'}" />
		</s:elseif>


		<div id='<s:property value="idApartamento"/>;<s:property value="status"/>'
			class='<s:property value="#statusSelecionado"  />'
			onmouseout='this.className="<s:property value="#statusSelecionado"  />"'
			onmouseover="$('#id').val()!=''?  document.getElementById($('#id').val()).className=$('#classe').val() :''; $('#classe').val(this.className);this.className='divAptoOver'"
			onmouseup="$('#id').val(this.id);this.className='divAptoUp';contextDisabled=false;currentMenu='<s:property value="#menu"  />';">

		<h1><s:property value="numApartamento" /></h1>


		<s:if test='%{status == "OA" || status == "OS"}'>

			<div class="divAptoImagem">
				<s:if test='%{status == "OS"}'>
					<img class="qtdeOcupadoSujo" src="imagens/aptoSujo.png" title="Sujo" />
				</s:if>
				<s:else>
					<img class="qtdeOcupadoArrumado" style="display: none" src="imagens/aptoSujo.png" />
				</s:else> 
				 
			</div>
			
			<img class="qtdeTotal" src="imagens/casaOcupada.png" style="height: 48px; width: 48px;" title='Tipo: <s:property value="tipoApartamento" />, Status:  <s:property value="status" />' />

		</s:if> 
		
		<s:elseif test='%{status == "LL" || status == "LS" || status == "LA"}'>
			
			<s:if test='%{status == "LS"}'>
				<div class="divAptoImagem" style="text-align: left;">
					<img class="qtdeLivreSujo" src="imagens/aptoSujo.png" title="Sujo" />
				</div>
				<img class="qtdeTotal" src="imagens/aptoLivre.png" style="height: 48px; width: 48px;" title='Tipo: <s:property value="tipoApartamento" />, Status:  <s:property value="status" />'/>
			</s:if> 
			<s:elseif test='%{status == "LL"}' >
				<div class="divAptoImagem" style="text-align: left;">
					<img class="qtdeLivreLimpo" style="display: none" src="imagens/aptoSujo.png" />
				</div>
				<img class="qtdeTotal" src="imagens/aptoLivre.png" style="height: 48px; width: 48px;" title='Tipo: <s:property value="tipoApartamento" />, Status:  <s:property value="status" />'/>
							
			</s:elseif> 
			<s:elseif test='%{status == "LA"}'>
				<div class="divAptoImagem" style="text-align: left;">
					<img class="qtdeLivreArrumado" style="display: none" src="imagens/aptoSujo.png"  />
				</div>
				<img class="qtdeTotal" src="imagens/aptoLivreArrumado.png" style="height: 48px; width: 48px;" title='Tipo: <s:property value="tipoApartamento" />, Status:  <s:property value="status" />'/>
			</s:elseif> 
			
		</s:elseif> 
		
		<s:elseif test='%{status == "IN"}'>
			<div class="divAptoImagem" style="text-align: left;">
				<img class="qtdeInterditado" src="imagens/aptoInterditado.png" title="Interditado" />
			</div>
			<img  class="qtdeTotal" src="imagens/aptoInter.png" style="height: 48px; width: 48px;" title='Tipo: <s:property value="tipoApartamento" />, Status:  <s:property value="status" />'/>
		</s:elseif>
		
		</div>
		
	</s:iterator>

	<div></div>
	</div>
	</div>
	</div>
	</div>

</s:form>

<script>
	calcular();
</script>

