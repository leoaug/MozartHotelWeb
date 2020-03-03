<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarUsuarioConsumoInterno!prepararPesquisa.action" namespace="/app/custo" />';
        		submitForm(vForm);
            }
            
            function gravar(){
                        
                if ($("input[name='entidade.nome']").val() == ''){
                  alerta('Campo "Nome" é obrigatório.');
                    return false;
                }

				if ($("select[name='entidade.centroCustoContabilEJB.idCentroCustoContabil']").val() == ''){
                  alerta('Campo "Centro de Custo" é obrigatório.');
                    return false;
                }
				
				if ($("input[name='entidade.dataInicial']").val() == ''){
                  alerta('Campo "Data Inicial" é obrigatório.');
                    return false;
	            }
				
				if ($("input[name='entidade.dataFinal']").val() == ''){
                  alerta('Campo "Data Final" é obrigatório.');
                    return false;
	            }
				
				if ($("select[name='entidade.tipoPensao']").val() == ''){
                  alerta('Campo "Pensão" é obrigatório.');
                    return false;
	            }
				
                submitForm(document.forms[0]);
            }

            function adicionar( obj ){
        		arr = obj.id.split(';');
        		loading();
        		submitFormAjax('usuarioWebIncluirHotel?lote=N&idHotel='+arr[0]+'&nomeHotel='+arr[1],true);
        	}

        	function adicionarLote(){
        		vForm = document.forms[0];
				vForm.action = '<s:url action="manterUsuarioConsumoInterno!adicionarHotelLote.action" namespace="/app/custo" />';
				submitForm( vForm );
        	}
			
			function podeAdicionar(nome){
				qtde = $("#hotelDestino li").length;
        		qtde = (qtde ==0?1:qtde);
        		linha = "<li style='height:15px; width: 100%;cursor: pointer; margin-bottom:2px;' ondblclick='remover(this);' id='"+(qtde-1)+"'><p style='width:100%;float:left'>&nbsp;"+nome+"</p></li>";
        		$("#hotelDestino").append(linha);
			}

        	function remover( obj ){
        		arr = obj.id;
        		loading();
        		$(obj).remove();
        		submitFormAjax('usuarioWebExcluirHotel?lote=N&indice='+arr[0],true);
        	}

        	function removerLote(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="manterUsuarioConsumoInterno!removerHotelLote.action" namespace="/app/custo" />';
				submitForm( vForm );
        	}                   
</script>

<s:form namespace="/app/custo" action="manterUsuarioConsumoInterno!gravarUsuarioConsumo.action" theme="simple">

<s:hidden name="entidade.id" />
<div class="divFiltroPaiTop">Usuários Consumo Interno</div>
<div class="divFiltroPai" >
   <div class="divCadastro" style="overflow:auto;" >
   		<div class="divGrupo" style="height:170px;">
        	<div class="divGrupoTitulo">Usuários</div>
            <div class="divLinhaCadastro">
            	<div class="divItemGrupo" style="width: 540px;">
					<p style="width: 100px;">Usuário</p>
					<s:textfield 
						name="entidade.nome" 
						id="nomeUsuario" 
						size="50"
						maxlength="30" 
						onblur="toUpperCase(this)" 
						required="required" />
				</div>
						
				<!-- Do Centro de Custo -->
				<div id="divDoCentroCusto" class="divItemGrupo" style="width:360px;" >
					<p style="width:120px;">Centro de Custo</p>
					<s:select list="centroCustoList" 
							cssStyle="width:230px;height:18px;"
							name="entidade.centroCustoContabilEJB.idCentroCustoContabil" 
							id="idCentroCustoContabil" 
							listKey="idCentroCustoContabil" 
							listValue="descricaoCentroCusto" 
							headerKey="" 
							headerValue="Selecione" /> 
				</div>
			</div>

			<div class="divLinhaCadastro">	
				<!-- Data Inicial -->
				<div class="divItemGrupo" style="width: 230px;">
					<p style="width: 100px;">Validade Inicial</p>
					<s:textfield 
						name="entidade.dataInicial"
						cssClass="dp"
						onblur="dataValida(this)"
						id="validadeInicial"   
						onkeypress="mascara(this, data);" 
						size="12" 
						maxlength="10"
						cssStyle="text-align: right;" /> 
				</div>
					
				<!-- Data Final -->
				<div class="divItemGrupo" style="width: 230px;">
					<p style="width: 100px;">Validade Final</p>
					<s:textfield 
						name="entidade.dataFinal"
						cssClass="dp"
						onblur="dataValida(this)"
						id="validadeFinal"   
						onkeypress="mascara(this, data);" 
						size="12" 
						maxlength="10"  
						cssStyle="text-align: right;" /> 
				</div>
									
				<div class="divItemGrupo" style="width:140px;" ><p style="width:50px;">Ativo:</p> 
					<s:select list="ativoList" 
							cssStyle="width:80px;height:18px;"
							name="entidade.ativo" 
							id="ativoUsuario" 
							listKey="id" 
							listValue="value" /> 
                </div>
						
				<div class="divItemGrupo" style="width:160px;" ><p style="width:60px;">Alcoólica:</p> 
					<s:select list="alcoolicoList" 
							cssStyle="width:80px;height:18px;"
							name="entidade.alcoolica" 
							id="alcoolica" 
							listKey="id" 
							listValue="value" /> 
                </div>
					
				<div class="divItemGrupo" style="width:190px;" ><p style="width:60px;">Pensão:</p> 
					<s:select list="pensaoList" 
							cssStyle="width:100px;height:18px;"
							name="entidade.tipoPensao" 
							id="pensao" 
							listKey="id" 
							listValue="value" 
							headerKey="" 
							headerValue="Selecione" /> 
                 </div>
			</div>
		</div>
				
        <div class="divGrupo" style="height:260px;">
	        <div class="divGrupoTitulo">Hotéis</div>
	                
	        <div class="divLinhaCadastro">
	            <div class="divItemGrupo" style="width:44%;text-align:center;background-color:rgb(49, 115, 255)">
					<p style="width:100%; color:white; font-weight:bold;">Hotéis</p>
	            </div>
	            <div class="divItemGrupo" style="width:10%; text-align:center;background-color:rgb(49, 115, 255)">
	                <p style="width:100%; color:white;font-weight:bold;">Ações</p>
	            </div>
	            <div class="divItemGrupo" style="width:44%;text-align:center;background-color:rgb(49, 115, 255)">
	                <p style="width:100%; color:white;font-weight:bold;">Hotéis adicionados</p>
	            </div>
	        </div>
	        <div class="divLinhaCadastro" style="height:205px">
	            <div class="divItemGrupo" style="height:200px; width:44%;overflow:auto;border: 1px solid black;">
	                <ul style="margin:0px; padding:0px; width:98%; " id="hotelOrigem">
	                	<s:iterator value="hoteisList">
	                		<li ondblclick="adicionar(this);" style="height:15px; width: 100%;cursor: pointer; margin-bottom:2px;" class="linhaUsuario" id='<s:property value="idHotel"/>;<s:property value="nomeFantasia"/>' >
	                			<p style="width:100%;float:left">&nbsp;<s:property value="nomeFantasia"/> </p>
	                		</li>
	                	</s:iterator>
	                </ul>
	            </div>
	            
	            <div class="divItemGrupo" style="height:200px; width:10%; text-align:center;">
	                <img  src="imagens/iconic/png/plus-3x.png" title="Adicionar todos os pontos de venda"  onclick="adicionarLote();" /> <br/><br/>
					<img  src="imagens/iconic/png/x-3x.png" title="Remover todos os pontos de venda"  onclick="removerLote();" />
	            </div>
	
	            <div class="divItemGrupo" style="height:200px; width:44%; overflow:auto;border: 1px solid black;">
	                <ul  style="margin:0px; padding:0px; width:98%;" id="hotelDestino">
	                	<s:iterator value="#session.entidadeSession.hotelEJBList"  status="linhaUsuario" var="obj">
	                		<li ondblclick="remover(this);" style="height:15px; width: 100%;cursor: pointer; margin-bottom:2px;"  class="linhaUsuario" id='<s:property value="#linhaUsuario.index"/>' > 
								<p style="width:100%;float:left">&nbsp;<s:property value='hotel.nomeFantasia'/> 
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