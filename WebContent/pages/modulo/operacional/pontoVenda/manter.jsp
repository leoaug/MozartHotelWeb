<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarPontoVenda!prepararPesquisa.action" namespace="/app/operacional" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                
                if ($("input[name='entidade.nomePontoVenda']").val() == ''){
                  alerta('Campo "Nome" é obrigatório.');
                    return false;
                }
				
				if ($("input[name='entidade.percTaxaServico']").val() == ''){
                  alerta('Campo "Taxa Serv" é obrigatório.');
                    return false;
                }

                               
                   submitForm(document.forms[0]);
                
            }


            function adicionar( obj ){
        		arr = obj.id.split(';');
        		loading();
        		submitFormAjax('pontoVendaWebIncluirPrato?lote=N&idPrato='+arr[0]+'&nomePrato='+arr[1],true);
        	}

        	function adicionarLote(){
        		vForm = document.forms[0];
				vForm.action = '<s:url action="manterPontoVenda!adicionarPratoLote.action" namespace="/app/operacional" />';
				submitForm( vForm );
        	}
			
			function podeAdicionar(nome){
				qtde = $("#usuarioDestino li").length;
        		qtde = (qtde ==0?1:qtde);
        		linha = "<li style='height:15px; width: 100%;cursor: pointer; margin-bottom:2px;' ondblclick='remover(this);' id='"+(qtde-1)+"'><p style='width:100%;float:left'>&nbsp;"+nome+"</p></li>";
        		$("#usuarioDestino").append(linha);
			}

        	function remover( obj ){
        		arr = obj.id;
        		loading();
        		$(obj).remove();
        		submitFormAjax('pontoVendaWebExcluirPrato?lote=N&indice='+arr[0],true);
        	}


        	function removerLote(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="manterPontoVenda!removerPratoLote.action" namespace="/app/operacional" />';
				submitForm( vForm );
        	}





        	function adicionarUsuario( obj ){
        		arr = obj.id.split(';');
        		loading();
        		submitFormAjax('pontoVendaWebIncluirUsuario?lote=N&idUsuario='+arr[0]+'&nomeUsuario='+arr[1],true);
        	}

        	function adicionarUsuarioLote(){
        		vForm = document.forms[0];
				vForm.action = '<s:url action="manterPontoVenda!adicionarUsuarioLote.action" namespace="/app/operacional" />';
				submitForm( vForm );
        	}
			
			function podeAdicionarUsuario(nome){
				qtde = $("#usuarioPdvDestino li").length;
        		qtde = (qtde ==0?1:qtde);
        		linha = "<li style='height:15px; width: 100%;cursor: pointer; margin-bottom:2px;' ondblclick='removerUsuario(this);' id='"+(qtde-1)+"'><p style='width:100%;float:left'>&nbsp;"+nome+"</p></li>";
        		$("#usuarioPdvDestino").append(linha);
			}

        	function removerUsuario( obj ){
        		arr = obj.id;
        		loading();
        		$(obj).remove();
        		submitFormAjax('pontoVendaWebExcluirUsuario?lote=N&indice='+arr[0],true);
        	}


        	function removerUsuarioLote(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="manterPontoVenda!removerUsuarioLote.action" namespace="/app/operacional" />';
				submitForm( vForm );
        	}
        	
                    
            
            
</script>

<s:form namespace="/app/operacional" action="manterPontoVenda!gravarPontoVenda.action" theme="simple">

<s:hidden name="entidade.idPontoVenda" />
<s:hidden name="entidade.dataPv" />
<div class="divFiltroPaiTop">Ponto de Venda</div>
<div class="divFiltroPai" >
        
        
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:270px;">
                <div class="divGrupoTitulo">Dados</div>
                
                
                <div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width:310px;" ><p style="width:100px;">Tipo PDV:</p>
								  <s:select list="tipoPdvList" 
								  cssStyle="width:100px"  
								  name="entidade.tipoPontoVenda"
								  listKey="id"
								  listValue="value"
								  > </s:select>
							
					</div>
				
					<div class="divItemGrupo" style="width:300px"><p style="width:80px;">Nome:</p>
						<s:textfield style="width:210px;" onblur="toUpperCase(this)" name="entidade.nomePontoVenda" id="" maxlength="20" size="35"/>
					</div>
					
					<div class="divItemGrupo" style="width: 200px;">
						<p style="width: 60px;">Série</p>
						<s:textfield 
							name="entidade.serie" 
							id="seriePontoVenda" 
							size="5"
 							maxlength="3" 
 							onblur="toUpperCase(this)" 
 							required="required" />
					</div>
				
				</div>
				
				
				
				<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width:310px"><p style="width:100px;">Proprietário</p>
							<s:textfield style="width:200px;" onblur="toUpperCase(this)" name="entidade.nomeProprietario" id="" maxlength="30" size="35"/>
						</div>
						
						<div class="divItemGrupo" style="width:310px;" ><p style="width:150px;">Modelo Impressora:</p>
							  <s:select list="modeloImpressoraList" 
							  cssStyle="width:150px"  
							  name="entidade.modeloImpressora.idNfeImpressora"
							  listKey="idNfeImpressora"
							  listValue="modelo"
							  headerValue="Selecione"
							  headerKey=""
							  > </s:select>
						
						</div>
						
						<div class="divItemGrupo" style="width:200px;" ><p style="width:80px;">Ambiente:</p> 
							<s:select list="ambientePdvList" 
								  cssStyle="width:100px"  
								  name="entidade.ambiente"
								  listKey="id"
								  listValue="value"
								  headerValue="Selecione"
							  	  headerKey=""> </s:select>
                    	</div>
				</div>
				
		
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width:310px"><p style="width:100px;">Taxa Serv.</p>
						<s:textfield onkeypress="mascara(this, moeda)" name="entidade.percTaxaServico" id="" maxlength="10" size="10"/>
					</div>
					
					<div class="divItemGrupo" style="width:240px;" ><p style="width:80px;">Serviço:</p>
							  <s:select list="tipoLancamentoServicoList" 
							  cssStyle="width:150px"  
							  name="entidade.idTipoLancamentoServico"
							  listKey="idTipoLancamento"
							  listValue="descricaoLancamento"
							  headerValue="Selecione"
							  headerKey=""
							  > </s:select>
						
					</div>
                </div>     
                
                <div class="divLinhaCadastro">
                	<div class="divItemGrupo" style="width:310px;" ><p style="width:100px;">Tipo Lançamento:</p>
							  <s:select list="tipoLancamentoList" 
							  cssStyle="width:200px"  
							  name="entidade.tipoLancamentoEJB.idTipoLancamento"
							  listKey="idTipoLancamento"
							  listValue="descricaoLancamento"
							  headerValue="Selecione"
							  headerKey=""
							  > </s:select>
						
					</div>
			
                	<div class="divItemGrupo" style="width:310px;" ><p style="width:80px;">COFAN:</p>
							  <s:select list="apartamentoList" 
							  cssStyle="width:100px"  
							  name="cofan"
							  listKey="idApartamento"
							  listValue="numApartamento"
							  headerValue="Selecione"
							  headerKey=""
							  > </s:select>
						
					</div>
					
					<div class="divItemGrupo" style="width:170px"><p style="width:80px;">Controle</p>
						<s:textfield onkeypress="mascara(this, numeros)" name="entidade.controle" id="" maxlength="10" size="10"/>
					</div>
					
				</div>
				
				<div class="divLinhaCadastro">
                	<div class="divItemGrupo" style="width:310px;" ><p style="width:100px;">Alimentos:</p>
							  <s:select list="planoContaList" 
							  cssStyle="width:200px"  
							  name="entidade.idPlanoContasAlimentos"
							  listKey="idPlanoContas"
							  listValue="nomeConta"
							  headerValue="Selecione"
							  headerKey=""
							  > </s:select>
						
					</div>
				
                	<div class="divItemGrupo" style="width:310px;" ><p style="width:80px;">Bebidas:</p>
							  <s:select list="planoContaList" 
							  cssStyle="width:200px"  
							  name="entidade.idPlanoContasBebidas"
							  listKey="idPlanoContas"
							  listValue="nomeConta"
							  headerValue="Selecione"
							  headerKey=""
							  > </s:select>
						
					</div>
				</div>
				
				<div class="divLinhaCadastro">
                	<div class="divItemGrupo" style="width:310px;" ><p style="width:100px;">Outros:</p>
							  <s:select list="planoContaList" 
							  cssStyle="width:200px"  
							  name="entidade.idPlanoContasOutros"
							  listKey="idPlanoContas"
							  listValue="nomeConta"
							  headerValue="Selecione"
							  headerKey=""
							  > </s:select>
						
					</div>
				
                	<div class="divItemGrupo" style="width:310px;" ><p style="width:80px;">C. Custo:</p>
							  <s:select list="centroCustoList" 
							  cssStyle="width:200px"  
							  name="entidade.idCentroCustoContabil"
							  listKey="idCentroCustoContabil"
							  listValue="descricaoCentroCusto"
							  headerValue="Selecione"
							  headerKey=""
							  > </s:select>
						
					</div>
				</div>
				
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width:810px"><p style="width:110px;">Def.Consumidor 1:</p>
						<s:textfield onblur="toUpperCase(this)" name="entidade.defConsumidor1" id="defConsumidor1" maxlength="100" size="100"/>
					</div>
					
					
				</div>
				
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width:810px"><p style="width:110px;">Def.Consumidor 2:</p>
						<s:textfield onblur="toUpperCase(this)" name="entidade.defConsumidor2" id="defConsumidor2" maxlength="100" size="100"/>
					</div>
				</div>
				
			 </div>
			 
			  
              
              
                
                
                <div class="divGrupo" style="height:260px;">
                <div class="divGrupoTitulo">Prato</div>
                
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:44%;text-align:center;background-color:rgb(49, 115, 255)">
						<p style="width:100%; color:white; font-weight:bold;">Pratos</p>
                    </div>
                    
                    <div class="divItemGrupo" style="width:10%; text-align:center;background-color:rgb(49, 115, 255)">
                        <p style="width:100%; color:white;font-weight:bold;">Ações</p>
                    </div>

                    <div class="divItemGrupo" style="width:44%;text-align:center;background-color:rgb(49, 115, 255)">
                        <p style="width:100%; color:white;font-weight:bold;">Pratos adicionados</p>
                    </div>


                </div>
                                


                <div class="divLinhaCadastro" style="height:205px">
                
                    <div class="divItemGrupo" style="height:200px; width:44%;overflow:auto;border: 1px solid black;">
                        <ul style="margin:0px; padding:0px; width:98%; " id="usuarioOrigem">
                        	<s:iterator value="pratoList">
                        		<li ondblclick="adicionar(this);" style="height:15px; width: 100%;cursor: pointer; margin-bottom:2px;" class="linhaUsuario" id='<s:property value="id.idPrato"/>;<s:property value="nomePrato"/>' >
                        			<p style="width:100%;float:left">&nbsp;<s:property value="nomePrato"/> </p>
                        		</li>
                        	</s:iterator>
                        </ul>
                    </div>
                    
                    <div class="divItemGrupo" style="height:200px; width:10%; text-align:center;">
                        <img  src="imagens/iconic/png/plus-3x.png" title="Adicionar todos os pratos"  onclick="adicionarLote();" /> <br/><br/>
						<img  src="imagens/iconic/png/x-3x.png" title="Remover todos os pratos"  onclick="removerLote();" />
                    </div>

                    <div class="divItemGrupo" style="height:200px; width:44%; overflow:auto;border: 1px solid black;">
                        <ul  style="margin:0px; padding:0px; width:98%;" id="usuarioDestino">
                        	<s:iterator value="#session.entidadeSession.pratoPontoVendaEJBList"  status="linhaUsuario" var="obj">
                        		<li ondblclick="remover(this);" style="height:15px; width: 100%;cursor: pointer; margin-bottom:2px;"  class="linhaUsuario" id='<s:property value="#linhaUsuario.index"/>' > 
										<p style="width:100%;float:left">&nbsp;<s:property value='pratoEJB.nomePrato'/> 
										</p>
                        		</li>
                        	</s:iterator>
                        </ul>
                    </div>


                </div>
                
                
                
                <div class="divGrupo" style="height:260px;">
                <div class="divGrupoTitulo">Usuários</div>
                
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:44%;text-align:center;background-color:rgb(49, 115, 255)">
						<p style="width:100%; color:white; font-weight:bold;">Usuários</p>
                    </div>
                    
                    <div class="divItemGrupo" style="width:10%; text-align:center;background-color:rgb(49, 115, 255)">
                        <p style="width:100%; color:white;font-weight:bold;">Ações</p>
                    </div>

                    <div class="divItemGrupo" style="width:44%;text-align:center;background-color:rgb(49, 115, 255)">
                        <p style="width:100%; color:white;font-weight:bold;">Usuários adicionados</p>
                    </div>


                </div>
                                


                <div class="divLinhaCadastro" style="height:205px">
                
                    <div class="divItemGrupo" style="height:200px; width:44%;overflow:auto;border: 1px solid black;">
                        <ul style="margin:0px; padding:0px; width:98%; " id="usuarioPdvOrigem">
                        	<s:iterator value="usuarioList">
                        		<li ondblclick="adicionarUsuario(this);" style="height:15px; width: 100%;cursor: pointer; margin-bottom:2px;" class="linhaUsuarioPdv" id='<s:property value="idUsuario"/>;<s:property value="nick.substring(7)"/>' >
                        			<p style="width:100%;float:left">&nbsp;<s:property value="nick.substring(7)"/> </p>
                        		</li>
                        	</s:iterator>
                        </ul>
                    </div>
                    
                    <div class="divItemGrupo" style="height:200px; width:10%; text-align:center;">
                        <img  src="imagens/hospede.png" title="Adicionar todos os usuários"  onclick="adicionarUsuarioLote();" /> <br/><br/>
						<img  src="imagens/btnRemoverTodosUsuario.png" title="Remover todos os usuários"  onclick="removerUsuarioLote();" />
                    </div>

                    <div class="divItemGrupo" style="height:200px; width:44%; overflow:auto;border: 1px solid black;">
                        <ul  style="margin:0px; padding:0px; width:98%;" id="usuarioPdvDestino">
                        	<s:iterator value="#session.entidadeSession.usuarioPontoVendaEJBList"  status="linhaUsuarioPdv" var="obj">
                        		<li ondblclick="removerUsuario(this);" style="height:15px; width: 100%;cursor: pointer; margin-bottom:2px;"  class="linhaUsuarioPdv" id='<s:property value="#linhaUsuarioPdv.index"/>' > 
										<p style="width:100%;float:left">&nbsp;<s:property value='usuarioEJB.nick.substring(7)'/> 
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