<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarMensagem!prepararPesquisa.action" namespace="/app/sistema" />';
        		submitForm(vForm);
            }
            
            function gravar(){
				
				if ($("#titulo").val() == ''){
                    alerta('Campo "Título" é obrigatório.');
                    return false;
            	}
				
                if ($("#descricao").val() == ''){
                    alerta('Campo "Descrição" é obrigatório.');
                    return false;
                }
				
				qtde = $("#usuarioDestino li").length;
        		if (qtde == 0){
                    alerta('Você deve associar pelo menos um usuário.');
                    return false;
				}
				

                submitForm(document.forms[0]);
            }

            function pesquisarUsuario(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="manterMensagem!pesquisarUsuario.action" namespace="/app/sistema" />';
				submitForm( vForm );
             }


        	function adicionarUsuario( obj ){
        		arr = obj.id.split(';');
        		loading();
        		submitFormAjax('mensagemUsuarioWebIncluir?lote=N&idUsuario='+arr[0]+'&nomeUsuario='+arr[1],true);
        	}

        	function adicionarUsuarioLote(){
        		vForm = document.forms[0];
				vForm.action = '<s:url action="manterMensagem!adicionarUsuarioLote.action" namespace="/app/sistema" />';
				submitForm( vForm );
        	}
			
			function podeAdicionarUsuario(nome){
				qtde = $("#usuarioDestino li").length;
        		qtde = (qtde ==0?1:qtde);
        		linha = "<li style='height:15px; width: 100%;cursor: pointer; margin-bottom:2px;' ondblclick='removerUsuario(this);' id='"+(qtde-1)+"'><p style='width:100%;float:left'>&nbsp;"+nome+"</p></li>";
        		$("#usuarioDestino").append(linha);
			}

        	function removerUsuario( obj ){
        		arr = obj.id;
        		loading();
        		$(obj).remove();
        		submitFormAjax('mensagemUsuarioWebExcluir?lote=N&indice='+arr[0],true);
        	}


        	function removerUsuarioLote(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="manterMensagem!removerUsuarioLote.action" namespace="/app/sistema" />';
				submitForm( vForm );
        	}

        	
        	
            
</script>

<s:form namespace="/app/sistema" action="manterMensagem!gravar.action" theme="simple">

<s:hidden name="entidade.idMensagem" />
<s:hidden name="entidade.dataCriacao" />

<s:hidden name="bloqRede" />
<s:hidden name="bloqAdm" />

<div class="divFiltroPaiTop">Mensagem</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:120px;">
                <div class="divGrupoTitulo">Dados</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:50%"><p style="width:100px;">Título:</p>
                        	<s:textfield onblur="toUpperCase(this)" maxlength="100"  name="entidade.titulo"  id="titulo" size="60" />
                    </div>
					
					<div class="divItemGrupo" style="width:200px;" ><p style="width:100px;">Nível:</p>
						<s:select list="nivelList" 
							  cssStyle="width:80px"  
							  name="entidade.nivel"
							  listKey="id"
							  listValue="value"> </s:select>
                    </div>
                    <div class="divItemGrupo" style="width:200px;" ><p style="width:100px;">Aprovada:</p>
						<s:select list="#session.LISTA_CONFIRMACAO" 
							  cssStyle="width:80px"  
							  name="entidade.aprovada"
							  listKey="id"
							  listValue="value"> </s:select>
                    </div>

					
                </div>
             
             	<div class="divLinhaCadastro" style="height:60px;">
                    <div class="divItemGrupo" style="width:100%;height:60px;" ><p style="width:100px;">Descrição:</p>
						<s:textarea name="entidade.descricao" cols="80" rows="2" id="descricao" ></s:textarea> 
                    </div>
                </div>
                
			 </div>
			
			<div class="divGrupo" style="height:320px;">
                <div class="divGrupoTitulo">Usuários</div>
                
                <div class="divLinhaCadastro">
                
                	<s:if test="%{bloqRede != \"S\"}">
	                    <div class="divItemGrupo" style="width:300px;"><p style="width:100px;">Por Rede:</p>
	                        <s:select list="redeHotelList" 
								  cssStyle="width:180px"  
								  name="idRedeHotel"
								  headerKey=""
								  headerValue="Selecione"
								  listKey="idRedeHotel"
								  listValue="nomeFantasia"> </s:select>
	                    </div>
                    </s:if>
                    
                    <div class="divItemGrupo" style="width:300px;"><p style="width:100px;">Por Hotel:</p>
                        <s:select list="hotelList" 
							  cssStyle="width:180px"  
							  name="idHotel"
							  headerKey=""
							  headerValue="Selecione"
							  listKey="idHotel"
							  listValue="nomeFantasia"> </s:select>

                    </div>
                    
                    <s:if test="%{bloqAdm != \"S\"}">
	                    <div class="divItemGrupo" style="width:140px;"><p style="width:50px;">Por ADM:</p>
	                        <s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:80px"  
								  name="usuarioAdm"
								  listKey="id"
								  listValue="value"
								  headerKey=""
								  headerValue="Selecione"> </s:select>
	                    </div>
                	</s:if>
                    <div class="divItemGrupo" style="width:150px;"><p style="width:85px;color:red">Suporte Mozart:</p>
	                        <s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:50px"  
								  name="suporteMozart"
								  listKey="id"
								  listValue="value"
								  > </s:select>
	                 </div>
                     <div class="divItemGrupo" style="width:30px;" >
                   		<img  src="imagens/iconic/png/magnifying-glass-3x.png" title="Pesquisar usuários"  onclick="pesquisarUsuario();" />
                    </div>
                    
                </div>


                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:44%;text-align:center;background-color:rgb(49, 115, 255)">
						<p style="width:100%; color:white; font-weight:bold;">Lista de usuários </p>
                    </div>
                    
                    <div class="divItemGrupo" style="width:10%; text-align:center;background-color:rgb(49, 115, 255)">
                        <p style="width:100%; color:white;font-weight:bold;">Ações</p>
                    </div>

                    <div class="divItemGrupo" style="width:44%;text-align:center;background-color:rgb(49, 115, 255)">
                        <p style="width:100%; color:white;font-weight:bold;">Usuários adicionados</p>
                    </div>


                </div>
                                


                <div class="divLinhaCadastro" style="height:230px">
                
                    <div class="divItemGrupo" style="height:210px; width:44%;overflow:auto;border: 1px solid black;">
                        <ul style="margin:0px; padding:0px; width:98%; " id="usuarioOrigem">
                        	<s:iterator value="usuarioList">
                        		<li ondblclick="adicionarUsuario(this);" style="height:15px; width: 100%;cursor: pointer; margin-bottom:2px;" class="linhaUsuario" id='<s:property value="idUsuario"/>;<s:property value="nomeUsuario"/>' >
                        			<p style="width:100%;float:left">&nbsp;<s:property value="nomeUsuario"/> </p>
                        		</li>
                        	</s:iterator>
                        </ul>
                    </div>
                    
                    <div class="divItemGrupo" style="height:210px; width:10%; text-align:center;">
                        <img  src="imagens/hospede.png" title="Adicionar todos os usuários"  onclick="adicionarUsuarioLote();" /> <br/><br/>
						<img  src="imagens/btnRemoverTodosUsuario.png" title="Remover todos os usuários"  onclick="removerUsuarioLote();" />
                    </div>

                    <div class="divItemGrupo" style="height:210px; width:44%; overflow:auto;border: 1px solid black;">
                        <ul  style="margin:0px; padding:0px; width:98%;" id="usuarioDestino">
                        	<s:iterator value="#session.usuarioAdicionadoList"  status="linhaUsuario" var="obj">
                        		<li ondblclick="removerUsuario(this);" style="height:15px; width: 100%;cursor: pointer; margin-bottom:2px;"  class="linhaUsuario" id='<s:property value="#linhaUsuario.index"/>' > 
										<p style="width:100%;float:left">&nbsp;<s:property value='usuarioEJB.nick != null?usuarioEJB.toString():usuarioEJB.nome'/> 
										</p>
                        		</li>
                        	</s:iterator>
                        </ul>
                    </div>


                </div>


                
                
			 </div>
			 	
  		

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
             </div>
         

</div>
</div>
</s:form>