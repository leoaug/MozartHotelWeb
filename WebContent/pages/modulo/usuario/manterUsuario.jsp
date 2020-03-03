<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">

            var $treeMenu;
            $(function(){
                $treeMenu = $("#treeMenu").checkTree();
                var data = { "ids": ["10","11"] };
            });
            
			function removerDocumento(){
				$("input[name='usuario.nomeFotografia']").val("");
				$("#inputRemoverDocumento").hide();
				$("#inputDocumento").show();	
			}

			function loadingTree(adm, carregaUsuario){
				loading();
				submitFormAjax("obterPermissaoSistema?adm=" + adm + "&carregaUsuario=" +carregaUsuario ,true);
			}

			function updateTree(novasPermissoes){
				$('#ulPermissoes').html(novasPermissoes);
			}

			
			function loadUsr(carregaUsuario){

				load($('#idUsuario').val());
			}

			
            function load(id) {
                if (id==null || id==''){
                    clearAll();
                    return false;
                }
                loading();
                var _url = "app/ajax/ajax!obterMenu?idUsuarioTree="+id+"&data="+<%=new java.util.Date().getTime()%>;
                
                $.getJSON(_url,{},function(json){
                        $treeMenu.clear();
                        $.updateWithJSON(json);
                        $treeMenu.update();
                });
                

                loading();
                _url = "app/ajax/ajax!obterDadosUsuario?idUsuarioTree="+id+"&data="+<%=new java.util.Date().getTime()%>;
                getAjaxValue(_url, ajaxCallback);

				return true;
            }
            
            function ajaxCallback(msg){
                var retorno = msg;
				killModal();
                if (retorno != ''){
                    lista = retorno.split(";");
                    var changeRede = false;
                    for (var x=0;x<lista.length;x++){
                        if ($.trim(lista[x]).length>0){
                            campoId = lista[x].split(':')[0];
                            campoValue = lista[x].split(':')[1];
                            if(campoId == 'idRede' && $('#'+campoId).val() != campoValue){
                            	changeRede = true;
                            }
                            
                            $('#'+campoId).val(campoValue);
                            
                            if(campoId == 'idRede' && changeRede)
                            	$('#'+campoId).change();
                        }
                    }
                }
                killModal();
            }
	

            
            
            function clearAll(){
                    $treeMenu.clear();
                    $treeMenu.update();
                    $('#idUsuario').val('');
                    $('#nome').val('');
                    $('#nivel').val('');
                    $('#dataExpiracao').val('');
                    $('#ativo').val('');
                    $('#login').val('');
                    $('#senha').val('');
                    $('#confirmacaoSenha').val('');
                    $('#turno').val('');
            }
    
            function cancelar(){
                loading();
                cancelarOperacao('<%=session.getAttribute("URL_BASE")%>');
            }
            
            function mostrarUsuario( desativado){
            	
            		
            	if (desativado == 'N'){            		
            		$('#ua').css("display","none");
            		$('#ud').css("display","block");            		
            	} else {            		
            		$('#ua').css("display","block");
            		$('#ud').css("display","none");            		
            	}
            
            }
            
            function gravar(){
            
                if ($('#nome').val() == ''){
                    alerta('Campo "Nome" � obrigat�rio.');
                    return false;
                }
                if ($('#nivel').val() == ''){
                    alerta('Campo "N�vel" � obrigat�rio.');
                    return false;
                }
                if ($('#dataExpiracao').val() == ''){
                    alerta('Campo "Expira��o" � obrigat�rio.');
                    return false;
                }
                if ($('#ativo').val() == ''){
                    alerta('Campo "Ativo" � obrigat�rio.');
                    return false;
                }
                 if ($('#turno').val() == ''){
                    alerta('Campo "Turno" � obrigat�rio.');
                    return false;
                }
                if ($('#login').val() == ''){
                    alerta('Campo "Login" � obrigat�rio.');
                    return false;
                }

                if ($('#idUsuario').val() == '' && $('#senha').val() == ''){
                	alerta('Campo "Senha" � obrigat�rio.');
                    return false;
                 }
                    
                if ($('#senha').val() != '' ){
                    if ($('#senha').val() != $('#confimacaoSenha').val()){
                        alerta('Campo "Confirma��o" est� inv�lido.');
                        return false;
                    }
                }

                 
                
                submitForm(document.forms[0]);
            }

        </script>






<s:form namespace="/app/usuario" action="usuario!salvar.action"
	theme="simple" method="post" enctype="multipart/form-data">

	<s:hidden name="usuario.nomeFotografia" />

	<!--Div Nivel-->
	<div id="divNivel" class="divCadastro" 	style="display: none; height: 250px; width: 550px;">

	<div class="divGrupo" style="width: 98%; height: 180px">
	<div class="divGrupoTitulo">N�veis</div>
	
	<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width:100%; color: blue">
			<p style="width: 100px;">N�vel 01:</p>
			Requisi��o: Requisitar mercadorias e receber mercadorias;
		</div>
	</div>
	<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width:100%; color: blue">
			<p style="width: 100px;">N�vel 02:</p>
			Almoxarife: Revisar/liberar requisi��es e Executar pedido interno;
		</div>
	</div>
	<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width:100%; color: blue">
			<p style="width: 100px;">N�vel 03:</p>
			Recep��o: Ajustes e descontos;
		</div>
	</div>
	<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width:100%; color: blue">
			<p style="width: 100px;">N�vel 04:</p>
			Autorizar: Requisi��o, pedido interno e compra extra;
		</div>
	</div>
	<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width:100%; color: blue">
			<p style="width: 100px;">N�vel 05:</p>
			Auditoria: Reabertura de conta, ajustes e descontos;
		</div>
	</div>
	<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width:100%; color: blue">
			<p style="width: 100px;">Somente leitura:</p>
			Permiss�o apenas para visualiza��o;
		</div>
	</div>
	
	</div>

	<div class="divCadastroBotoes" style="width: 98%;">
		<duques:botao
		label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="killModal()" />
	</div>
	</div>
	<!--final Div Nivel-->
	


	<div class="divFiltroPaiTop">Usu�rios</div>
	<div class="divFiltroPai">
	<div class="divCadastro" style="overflow: auto;">
	<div class="divGrupo" style="height: 400px; width: 40%">
	<div class="divGrupoTitulo">Dados do usu�rio</div>
	
	<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width: 90%;">
		<p>Usu�rio ativo:</p>
		
		<s:select list="#session.LISTA_CONFIRMACAO"
					cssStyle="width: 80pt;"
					name="usuarioAtivado"
					onchange="mostrarUsuario(this.value)"
					listKey="id"
					listValue="value"></s:select>
	</div>
	</div>
	
	<div class="divLinhaCadastro" id="ua" >
	<div class="divItemGrupo" style="width: 90%;">
	<p>Usu�rio:</p>
	<s:select list="#session.usuarios" listKey="idUsuario" id="idUsuario"
		name="usuario.idUsuario" headerValue=".:Incluir um novo:."
		headerKey="" onchange="load(this.value)" cssStyle="width:230px;" /></div>
	</div>
	<div class="divLinhaCadastro" id="ud" style="display:none;">
	<div class="divItemGrupo" style="width: 90%;">
	<p>Desativados:</p>
	<s:select list="#session.usuariosDesativados" listKey="idUsuario" id="idUsuarioDesativado"
		name="idUsuarioDesativado" headerValue=".:Incluir um novo:."
		headerKey="" onchange="load(this.value)" cssStyle="width:230px;" /></div>
	</div>
	
	<s:if test="%{#session.USER_SESSION.usuarioEJB.redeHotelEJB.idRedeHotel != null}">
		<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width: 90%;">
		<p>Usu�rio de rede:</p>
		
		<s:select list="#session.LISTA_CONFIRMACAO"
					cssStyle="width: 80pt;"
					name="usuarioRede"
					id="idRede"
					onchange="loadingTree(this.value,'S')"
					listKey="id"
					listValue="value"></s:select>
</div>
		</div>
	</s:if>
	<s:else>
		<s:hidden name="usuarioRede" value="N"></s:hidden>
	</s:else>
	
	
	
	
	

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 100%;">
	<p>Nome:</p>
	<input type="text" size="40" maxlength="50" name="usuario.nome"
		id="nome" onblur="this.value = this.value.toUpperCase();" /></div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 90%;">
	<p>N�vel:</p>
	<select style="width: 120pt;" name="usuario.nivel" id="nivel" >
		<option value="">.:Selecione:.</option>
		<option value="1">N�vel 01</option>
		<option value="2">N�vel 02</option>
		<option value="3">N�vel 03</option>
		<option value="4">N�vel 04</option>
		<option value="5">N�vel 05</option>
		<option value="0">Somente Leitura</option>

	</select>
		<img src="imagens/btnAjuda.png" title="Ajuda" width="16px" height="16px" onclick="showModal('#divNivel')"></img>
	</div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 90%;">
	<p>Expira��o:</p>
	<input class="dp" type="text" name="usuario.dataValidade" id="dataExpiracao"
		size="10"/> 
	</div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 90%;">
	<p>Login ativado:</p>
	<select style="width: 80pt;" name="usuario.ativo" id="ativo">
		<option value="">.:Selecione:.</option>
		<option value="S">Sim</option>
		<option value="N">N�o</option>
	</select></div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 90%;">
	<p>Turno:</p>
	<select style="width: 120pt;" name="usuario.turno" id="turno">
		<option value="">.:Selecione:.</option>
		<option value="M">Manh� [00h/12h]</option>
		<option value="T">Tarde [12h/18h]</option>
		<option value="N">Noite [18h/23:59]</option>
		<option value="MT">Manh� + Tarde</option>
		<option value="MN">Manh� + Noite</option>
		<option value="TN">Tarde + Noite</option>
		<option value="I">Integral [00h/23:59h]</option>
	</select></div>
	</div>
	
	
	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 100%;">
	<p>Login:</p>
	<input type="text" name="usuario.nick" id="login" size="40"
		onblur="this.value = this.value.toUpperCase();" maxlength="20">
	</div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 90%;">
	<p>Senha:</p>
	<input type="password" name="usuario.senha" id="senha" size="20">
	</div>
	</div>

	<div class="divLinhaCadastro">
	<div class="divItemGrupo" style="width: 90%;">
	<p>Confirma��o:</p>
	<input type="password" name="confimacaoSenha" id="confimacaoSenha"
		size="20"></div>
	</div>

	<div class="divLinhaCadastro">
		<div class="divItemGrupo" style="width: 90%;" >
	       	<p style="width:100px;">Foto:</p>
			<s:set var="possuiDocumento" value="false"/>
	        <s:if test="%{usuario.fotografia != null}">
	        	<s:set var="possuiDocumento"  value="true"/>
	       	</s:if>
	       	
	        <div id="inputRemoverDocumento" style="display: ${possuiDocumento ? 'inline' : 'none'}">
				${usuario.nomeFotografia}&nbsp;&nbsp;&nbsp;
				<img src="imagens/excluir.png" title="Remover foto" onclick="javascript:removerDocumento()" />
	        </div>
	        <div id="inputDocumento" style="display: ${possuiDocumento ? 'none' : 'inline'}">
	        	<s:file name="documento" label="File"/>
	        </div>
		</div>
	</div>


	</div>


	<div id="main" class="divGrupo" style="width: 58%; height: 400px;">
	<div class="divGrupoTitulo">Permiss�es</div>


	<ul id="treeMenu" class="tree"
		style="margin-left: 10px; border: 1px solid #ccc; padding: 6px; overflow-y: scroll; height: 90%; width: 95%;">
		<li><input type="checkbox"> <label> <img
			src="imagens/iconMozart.png" /> Iniciarr </label>
		<ul id="ulPermissoes">
			<%=session.getAttribute("menus") %>
		</ul>
		</li>
	</ul>
	<br style="clear: both" />

	</div>
	<div class="divCadastroBotoes"><duques:botao label="Voltar"
		imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" /> <duques:botao
		label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" /></div>

	</div>
	</div>
</s:form>