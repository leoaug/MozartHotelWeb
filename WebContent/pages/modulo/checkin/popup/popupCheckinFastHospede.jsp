<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>


<script language="javaScript">


    function getHospedeLookup(elemento){
        url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarHospede?OBJ_NAME='+elemento.name+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idHospede';
        getDataLookup(elemento, url,'Hospede','TABLE');
    }
    

    function incluirNovoHospede(){
        vForm = document.forms[0];
        vForm.nomeHospedeNovo1.value = vForm.nomeHospede.value;
        showModal('#divHospedeModal', 300, 600);
    }
    
    function alterarHospede(idx, id, nome, sobrenome, cpf, dtNasc, email, sexo){
        vForm = document.forms[0];
        vForm.idxHospede.value = idx;
        vForm.idHospede.value = id;
        vForm.nomeHospedeNovo1.value = nome;
        vForm.sobrenomeHospedeNovo1.value = sobrenome;
        vForm.cpfHospedeNovo1.value = cpf;
        vForm.dataNascimentoHospedeNovo1.value = dtNasc;
        vForm.emailHospedeNovo1.value = email;
        $('#sexoHospedeNovo1').val ( sexo );
        showModal('#divHospedeModal', 300, 550);
    }
    function fecharPopup(){
        
        vForm = document.forms[0];
        vForm.idxHospede.value = '';
        vForm.idHospede.value = '';
        $.modal.close();    
    }


    function gravarNovoHospede(){
        vForm = document.forms[0];

        if ($('input[name=nomeHospedeNovo1]').val() == ''){
            alert ("O campo 'Nome' é obrigatório");
            return false;
        }
        if ($('input[name=sobrenomeHospedeNovo1]').val() == ''){
            alert ("O campo 'Sobrenome' é obrigatório");
            return false;
        }


        <s:if test="%{#session.HOTEL_SESSION.empresaSeguradoraEJB != null}">
	        if ($('input[name=cpfHospedeNovo1]').val() == '' && $('input[name=passaporteHospedeNovo1]').val() == ''){
	            alert ("O campo 'CPF' ou 'Passaporte' é obrigatório");
	            return false;
	        }

	        if ($('input[name=cpfHospedeNovo1]').val() != ''){
	            if (!validarCPF($('input[name=cpfHospedeNovo1]').val())){
	                alert ("O campo 'CPF' é inválido");
	                return false;
	            }
	        }
	        
	        if ($('input[name=dataNascimentoHospedeNovo1]').val() == ''){
	            alert ("O campo 'Dt. Nasc.' é obrigatório");
	            return false;
	        }
	        
	        if ($('input[name=emailHospedeNovo1]').val() == ''){
	            alert ("O campo 'E-mail' é obrigatório");
	            return false;
	        }
	        
	        if ($('input[name=emailHospedeNovo1]').val() != ''){
	            if (!validarEmail($('input[name=emailHospedeNovo1]').val())){
	                alert ("O campo 'E-mail' é inválido");
	                return false;
	            }
	        }
	        if ($('#sexoHospedeNovo1').val() == ''){
	            alert ("O campo 'Sexo' é obrigatório");
	            return false;
	        }

        </s:if>
        $('input[name=nomeHospedeNovo]').val( $('input[name=nomeHospedeNovo1]').val() );
        $('input[name=sobrenomeHospedeNovo]').val( $('input[name=sobrenomeHospedeNovo1]').val() );
        $('input[name=cpfHospedeNovo]').val( $('input[name=cpfHospedeNovo1]').val() );
        $('input[name=passaporteHospedeNovo]').val( $('input[name=passaporteHospedeNovo1]').val() );
        $('input[name=dataNascimentoHospedeNovo]').val( $('input[name=dataNascimentoHospedeNovo1]').val() );
        $('input[name=emailHospedeNovo]').val( $('input[name=emailHospedeNovo1]').val() );
        $('input[name=sexoHospedeNovo]').val( $('#sexoHospedeNovo1').val() );
        vForm.action = '<s:url action="popupHospede!gravarNovoHospede.action" namespace="/app/checkin" />';
        vForm.submit();
    }

    function incluirHospede(){
    
            vForm = document.forms[0];
            
            if (vForm.idHospede.value == ''){
                alerta('Você deve selecionar um hóspede.');
                return false;
            }
            
            vForm.action = '<s:url action="popupHospede!incluirPopupHospede.action" namespace="/app/checkin" />';
            vForm.submit();
    }

    function excluirHospede(pIdxHospede){
        if (confirm('Confirma a exclusão do hóspede?')){
            vForm = document.forms[0];
            vForm.idxHospede.value = pIdxHospede;
            vForm.action = '<s:url action="popupHospede!excluirPopupHospede.action" namespace="/app/checkin" />';
            vForm.submit();
        }
    }
    
    
    function mudarValorPrincipal( obj ){
        valor = obj.value;
        if (valor == 'S'){
            valorOutros = 'N';
            $("select[name='hospedePrincipal']").val(valorOutros);
            $(obj).val(valor);
        }
    }
    
    function atualizar(){

        window.opener.atualizarHospede();
        window.close();
    }
    
    function confirmarAlteracao(){
		
		var qtde = $("select[name='hospedePrincipal']").length;
		var achouPrincipal = false;
		for (var x = 1;x<qtde;x++){
			if ($("select[name='hospedePrincipal']")[x].value=='S'){
				 achouPrincipal = true;
				 break;
			}
		}
		if (!achouPrincipal){
			alert('Pelo menos um hóspede deve ser o principal.');
			return false;
		}
		
                
        vForm = document.forms[0];
        vForm.action = '<s:url action="popupHospede!gravarPopupHospede.action" namespace="/app/checkin" />';
        vForm.submit();
    }

<s:if test="#request.fecharPopup != null">
    atualizar();
    
</s:if>
    
    
</script>
<div style="display: none"><%=new java.util.Date()%></div>
<s:form namespace="/app/checkin"
	action="popupHospede!popupAdicionarHospede" theme="simple">
	<s:hidden name="idxCheckin" />
	<s:hidden name="idxHospede" />


	<s:hidden name="nomeHospedeNovo" />
	<s:hidden name="sobrenomeHospedeNovo" />
	<s:hidden name="cpfHospedeNovo" />
	<s:hidden name="passaporteHospedeNovo" />
	<s:hidden name="dataNascimentoHospedeNovo" />
	<s:hidden name="emailHospedeNovo" />
	<s:hidden name="sexoHospedeNovo" />


	<!--Div lookup de Hospede-->
	<div id="divHospedeModal" class="divCadastro"
		style="display: none; height: 300px; width: 600px;">

	<div class="divGrupo" style="width: 98%; height: 200px">
	<div class="divGrupoTitulo">Dados do hóspede</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 60px;">Nome:</p>
	<s:textfield name="nomeHospedeNovo1" maxlength="50" size="30"
		onblur="this.value = this.value.toUpperCase();" /></div>
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 75px;">Sobrenome:</p>
	<s:textfield name="sobrenomeHospedeNovo1" maxlength="50" size="30"
		onblur="this.value = this.value.toUpperCase();" /></div>
	</div>
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 60px;">CPF:</p>
	<s:textfield name="cpfHospedeNovo1" maxlength="11" size="15"
		onkeypress="mascara(this, numeros)" onblur="validarCPF(this.value)"/></div>
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 75px;">Passaporte:</p>
	<s:textfield name="passaporteHospedeNovo1" maxlength="50" size="15"
		 /></div>
	</div>
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 60px;">Dt. Nasc.:</p>
	<s:textfield name="dataNascimentoHospedeNovo1" maxlength="10" size="15"
		onkeypress="mascara(this, data)" /></div>
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 75px;">E-mail.:</p>
	<s:textfield name="emailHospedeNovo1" maxlength="200" size="30" /></div>

	</div>
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 200pt;">
	<p style="width: 60px;">Sexo:</p>
	<s:select cssStyle="width:130px;" list="listaSexo" listKey="id"
		listValue="value" name="sexoHospedeNovo1" id="sexoHospedeNovo1" />

	</div>
	</div>
	</div>

	<div class="divCadastroBotoes" style="width: 98%;"><duques:botao
		label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="fecharPopup();" />
	<duques:botao label="Salvar" imagem="imagens/iconic/png/check-4x.png"
		onClick="gravarNovoHospede();" /></div>
	</div>
	<!--final-->

	<div class="divFiltroPaiTop">Hóspedes</div>
	<div id="divFiltroPai" class="divFiltroPai"
		style="height: 100px; width: 590px;">
	<div id="divFiltro" class="divCadastro" style="height: 350px;"><!--Início dados do filtro-->
	<div class="divGrupo" style="height: 70px; width: 580px;">
	<div class="divGrupoTitulo">Pesquisar</div>
	<div class="divGrupoBody">

	<ul>
		<li style="width: 560px;">
		<div style="width: 350px; float: left;">Nome</div>
		<div style="width: 70px; float: left;">Principal</div>
		<div style="width: 60px; float: left;">Chegou?</div>
		<div style="width: 70px; float: left; text-align: center;">Ação
		</div>
		</li>
		<li style="width: 560px;">
		<div style="width: 350px; float: left;"><input type="text"
			id="nomeHospede" name="nomeHospede" size="30"
			onblur="getHospedeLookup(this)" /> <input type="hidden"
			id="idHospede" name="idHospede" /></div>
		<div style="width: 70px; float: left;"><s:select
			list="#session.LISTA_CONFIRMACAO" cssStyle="width:50px;" listKey="id"
			listValue="value" name="hospedePrincipal" />
		</div>
		<div style="width: 60px; float: left;"><s:select
			list="#session.LISTA_CONFIRMACAO" cssStyle="width:50px;" listKey="id"
			listValue="value" name="hospedeChegou" />
		</div>
		<div style="width: 70px; float: left; text-align: right;"><img
			align="middle" width="24px" height="24px"
			src="imagens/iconic/png/plus-3x.png" title="Adicionar hóspede"
			onclick="incluirHospede()"> <img align="middle" width="24px"
			height="24px" src="imagens/hospede.png" title="Incluir novo hóspede"
			onclick="incluirNovoHospede()"></div>
		</li>

	</ul>
	</div>

	</div>
	<div class="divGrupo" style="height: 180px; width: 580px;">
	<div class="divGrupoTitulo">Hóspedes</div>
	<div class="divGrupoBody">

	<ul>


		<s:iterator
			value="#session.checkinCorrente.reservaApartamentoEJB.roomListEJBList"
			status="row">
			<s:if test="%{dataSaida == null}">
				<li style="width: 560px;">
				<div style="width: 350px; float: left;"><s:property
					value="hospede.nomeHospede" /> <s:property
					value="hospede.sobrenomeHospede" /></div>
				<div style="width: 70px; float: left;"><s:select
					list="#session.LISTA_CONFIRMACAO" cssStyle="width:50px;"
					value="principal" name="hospedePrincipal" listKey="id"
					listValue="value" onchange="mudarValorPrincipal(this)" />
				</div>
				<div style="width: 60px; float: left;"><s:if
					test='%{dataEntrada != null && chegou == "S"}'>
                                            &nbsp;Sim<s:hidden
						name="hospedeChegou" value="S" />
				</s:if> <s:else>
					<s:select list="#session.LISTA_CONFIRMACAO" value="chegou"
						listKey="id" listValue="value" cssStyle="width:50px;"
						name="hospedeChegou" />
				</s:else></div>
				<div style="width: 70px; float: left; text-align: right;"><s:if
					test="%{dataEntrada == null}">
					<img align="middle" width="24px" height="24px"
						src="imagens/iconic/png/x-3x.png" title="Excluir hóspede"
						onclick="excluirHospede('${row.index}')">

					<img align="middle" width="24px" height="24px"
						src="imagens/btnAlterar.png" title="Alterar dados do hóspede"
						onclick="alterarHospede('${row.index}', '<s:property value="hospede.idHospede" />', '<s:property value="hospede.nomeHospede" />','<s:property value="hospede.sobrenomeHospede" />','<s:property value="hospede.cpf" />','<s:property value="hospede.nascimento" />', '<s:property value="hospede.email" />', '<s:property value="hospede.sexo" />')">
				</s:if></div>
				</li>
			</s:if>
		</s:iterator>

	</ul>
	</div>

	<div class="divCadastroBotoes" style="width: 98%;"><duques:botao
		label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="atualizar();" />
	<duques:botao label="Confirmar" imagem="imagens/iconic/png/check-4x.png"
		onClick="confirmarAlteracao();" /></div>

	</div>

	</div>
	</div>



</s:form>
