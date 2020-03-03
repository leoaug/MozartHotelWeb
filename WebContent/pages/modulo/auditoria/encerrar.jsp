<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarAuditoria!prepararPesquisa.action" namespace="/app/auditoria" />';
        		submitForm(vForm);
            }
            
            
            
            function gravar(){
                submitForm(document.forms[0]);
            }


            function getCidadeOrigemLookup(elemento, idx){
                url = 'app/ajax/ajax!selecionarCidade?OBJ_NAME='+elemento.id+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idCidadeOrigem'+idx;
                getDataLookup(elemento, url,'divOrigem','TABLE');
            }

            function getCidadeDestinoLookup(elemento, idx){
                url = 'app/ajax/ajax!selecionarCidade?OBJ_NAME='+elemento.id+'&OBJ_VALUE='+elemento.value+'&OBJ_HIDDEN=idCidadeDestino'+idx;
                getDataLookup(elemento, url,'divDestino','TABLE');
            }

            function alterarCheckins(){

				var qtde = $("input:hidden[class='idCidadeOrigem'][value='']").length;
				if ( qtde  > 0){
					alerta("Cada campo 'Origem' é obrigatório.");
					return false;
				}

           		qtde = $("input:hidden[class='idCidadeDestino'][value='']").length;
				if ( qtde  > 0){
					alerta("Cada campo 'Destino' é obrigatório.");
					return false;
				}
					
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="encerrarAuditoria!gravarCheckin.action" namespace="/app/auditoria" />';
        		submitForm(vForm);

			}

            

</script>


<s:form namespace="/app/auditoria" action="encerrarAuditoria!encerrar.action" theme="simple">

<s:hidden name="entidade.idMovimentoApartamento" />
<s:hidden name="restaurante" />
<div class="divFiltroPaiTop">Auditoria</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >

              <div class="divGrupo" style='height:190px; <s:property value="checkinList.size() > 0?\"width:400px;\" :\";\" " />'>
                <div class="divGrupoTitulo">Atenção</div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Esta rotina só poderá ser executada uma única vez por dia;</p> 
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:350px;" ><p style="width:100%;">- Verifique se todos o movimentos estão corretos;</p> 
                    </div>
                </div>
              </div>

			  <div class="divGrupo" id="divVencido" style='height:450px; width:550px; float:right; margin-right:5px; display:<s:property value="checkinList.size() > 0?\"block;\" :\"none;\" " />'>
    		<s:if test="%{!restaurante}" >
				<div class="divGrupoTitulo">Check-ins incompletos</div>
					<div class="divGrupoBody" style="height: 85%;">
						<s:iterator value="checkinList" status="row">
							<input type="hidden" name="idCheckin" value="<s:property value="idCheckin"/>" />
							<div class="divLinhaCadastro" style="margin-bottom:0px; border:0px;">
								<div class="divItemGrupo" style="width:120px;" >
									<p style="width:60px;color:black;">Apto: </p><s:property value="numApartamento"/>
								</div>
								<div class="divItemGrupo" style="width:400px;" >
									<p style="width:60px;color:black;">Hóspede: </p><s:property value="nomeHospede"/>
								</div>
							</div>	
							<div class="divLinhaCadastro" style="margin-bottom:0px; border:0px;">
								<div class="divItemGrupo" style="width:200px;" >
									<p style="width:60px;color:black;">Motivo: </p>
									<s:select cssStyle="width:100px;" 
											  list="motivoViagem"
											  name="motivoDaViagem" />
								</div>
								<div class="divItemGrupo" style="width:200px;" >
									<p style="width:60px;color:black;">Transp: </p>
										<s:select cssStyle="width:100px;" 
												  list="tipoTransporte"
												  name="tipoDoTransporte" />
								</div>
							</div>	
							<div class="divLinhaCadastro">
								<div class="divItemGrupo" style="width: 200px;">
									<p style="width: 60px;color:black;">Origem:</p>
									<input type="text" name="cidadeOrigem" id="cidadeOrigem${row.index}" maxlength="50" size="20" onblur="getCidadeOrigemLookup(this,${row.index})" /> 
									<input type="hidden" class="idCidadeOrigem" name="idCidadeOrigem" id="idCidadeOrigem${row.index}" /> <input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"/>
								</div>
								<div class="divItemGrupo" style="width: 200px;">
									<p style="width: 60px;color:black;">Destino:</p>
									<input type="text" name="cidadeDestino" id="cidadeDestino${row.index}" maxlength="50" size="20" onblur="getCidadeDestinoLookup(this, ${row.index})" /> 
									<input type="hidden" class="idCidadeDestino" name="idCidadeDestino" id="idCidadeDestino${row.index}" /><input type="text" style="width:1px; border:0px; background-color: rgb(247, 247, 247);"/>
								</div>
							</div>
													
						</s:iterator>
					</div>
					<div class="divCadastroBotoes">
                        <duques:botao label="Alterar" imagem="imagens/iconic/png/check-4x.png" onClick="alterarCheckins()" />
	              	</div>
					
					
				</s:if>  
				</div>
	
              <div class="divGrupo" style="height:300px; <s:property value="checkinList.size() > 0?\"width:400px;\" :\";\" " />">
                <div class="divGrupoTitulo">Validações</div>
                <s:if test="%{!restaurante}" >
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Pré-checkins vencidos: </p>
                    	<s:if test="%{preCheckinVencidos !=null && preCheckinVencidos !=''}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes apartamentos estão com pré-checkins vencidos: <s:property value="preCheckinVencidos"/>' >
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Não existem pré-checkins vencidos" ></img>
                    	</s:else>
                    </div>
                </div>
				</s:if>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Encerramento do PDV: </p>
                    	<s:if test="%{pdvEmAberto !=null && pdvEmAberto!=''}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes PDVs estão em aberto: <s:property value="pdvEmAberto"/>' ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Não existem pontos de vendas em aberto" ></img>
                    	</s:else>
                    </div>
                </div>
                <s:if test="%{!restaurante}" >
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Encerramento do PDV restaurante: </p>
                    	<s:if test="%{pdvRestaurante !=null && pdvRestaurante!=''}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes PDVs estão em aberto: <s:property value="pdvRestaurante"/>' ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Não existem pontos de vendas de restaurante em aberto" ></img>
                    	</s:else>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Diárias automáticas:</p>
                    	<s:if test='%{!diariasLancadas.equals("0")}'>
                    		<img src="imagens/msgSucesso.png" title="Diárias automáticas foram lançadas" ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/iconic/png/xRed-3x.png" title="Diárias automáticas NÃO foram lançadas" ></img>
                    	</s:else>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Check-ins incompletos:</p>
                    	<s:if test="%{checkinIncompleto != null && checkinIncompleto != ''}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes apartamentos estão com check-ins incompletos: <s:property value="checkinIncompleto"/>' ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Não existem check-ins incompletos" ></img>
                    	</s:else>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Check-outs vencidos:</p>
                    	<s:if test="%{checkoutVencido != null && checkoutVencido != ''}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes apartamentos estão com check-outs vencidos: <s:property value="checkoutVencido"/>' ></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Não existem check-outs vencidos" ></img>
                    	</s:else>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Reservas No Show: </p>
                    	<s:if test="%{noShow !=null && noShow!=''}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='As seguintes reservas são No-Shows: <s:property value="noShow"/> - Alterar a data da entrada ou cancelar ou cobrar.'></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Não existem reservas No-Shows" ></img>
                    	</s:else>
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:300px;" ><p style="width:250px;color:black;">Apto. Interditados: </p>
                    	<s:if test="%{interditadosVencidos !=null && interditadosVencidos!=''}">
                    		<img src="imagens/iconic/png/xRed-3x.png" title='Os seguintes apartamentos IN - Interditados estão com data fim vencidos. Revisar na rotina de governança: <s:property value="interditadosVencidos"/>'></img>
                    	</s:if>
                    	<s:else>
                    		<img src="imagens/msgSucesso.png" title="Não existem apartamentos Interditados" ></img>
                    	</s:else>
                    </div>
                </div>
				</s:if>
              </div>

             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <s:if test="%{!restaurante}" >
	                    <s:if test='%{preCheckinVencidos ==null && pdvEmAberto == null && pdvRestaurante == null && (!diariasLancadas.equals("0")) && checkinIncompleto == null && checkoutVencido ==null && noShow ==null && interditadosVencidos ==null}'>
		                    <duques:botao label="Encerrar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
	                    </s:if>
                    </s:if>
                    <s:else >
	                    <duques:botao label="Encerrar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
                    </s:else>
              </div>
              
        </div>
</div>
</s:form>