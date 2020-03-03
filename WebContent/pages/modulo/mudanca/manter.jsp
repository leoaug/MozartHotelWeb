<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">



            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarMudanca.action" namespace="/app/mudanca" />';
        		submitForm(vForm);
            }


            function gravar(){
                   submitForm(document.forms[0]);
            }
            
</script>

<s:form action="manterMudanca!gravar.action" theme="simple" namespace="/app/mudanca" >
<s:hidden name="nivelUsuario" />
<s:hidden name="idCriador" />
<s:hidden name="entidade.idMudanca" />
<s:hidden name="entidadeComplemento.id.idMudanca" />
<s:hidden name="entidadeComplemento.id.dtDataCriacao" />

<div class="divFiltroPaiTop">Solicitação de mudança</div>
<div class="divFiltroPai" >
       
       <div class="divCadastro" style="overflow:auto;" >
              
			  <div class="divGrupo" style="height: 150px; width:380px;">
				<div class="divGrupoTitulo">Dados da mudança</div>

				<s:if test="%{entidade.idMudanca != null}">
					
						<div class="divLinhaCadastro" >
							<div class="divItemGrupo">
							<p style="width: 80px;">Sistema:</p>
								<s:property value="entidade.scmSistema.dsSistema"/>
								<s:hidden name="entidade.scmSistema.dsSistema" />
								<s:hidden name="entidade.scmSistema.idSistema" />
							</div>
						</div>
						<div class="divLinhaCadastro" >
							<div class="divItemGrupo" >
							<p style="width: 80px;">Prioridade:</p>
								<s:property value="entidade.nmPrioridade.intValue() == 3?\"Baixo\":entidade.nmPrioridade.intValue() == 2?\"Médio\":\"Alto\" "/>
								<s:hidden name="entidade.nmPrioridade" />
							</div>
						</div>
						
						<div class="divLinhaCadastro" >
							<div class="divItemGrupo" >
							<p style="width: 80px;">Título:</p>
								<s:property value="entidade.dsTitulo"/>
								<s:hidden name="entidade.dsTitulo" />
							</div>
						</div>
						<div class="divLinhaCadastro" >
							<div class="divItemGrupo">
							<p style="width: 80px;">Caminho:</p>
								<s:property value="entidade.dsCaminho"/>
								<s:hidden name="entidade.dsCaminho" />
							</div>
						</div>

						<div class="divLinhaCadastro" >
							<div class="divItemGrupo">
							<p style="width: 80px;">Criada por:</p>
								<s:property value="entidade.usuarioEJB.nick"/>
								<s:hidden name="entidade.usuarioEJB.nick"/>
								<s:hidden name="entidade.usuarioEJB.idUsuario" />
							</div>
							
						</div>

				</s:if>
				<s:else>

						<div class="divLinhaCadastro" >
							<div class="divItemGrupo">
							<p style="width: 80px;">Sistema:</p>
								<s:select list="sistemaList"
										cssStyle="width:120px"
										listKey="idSistema"
										listValue="dsSistema"
										name="entidade.scmSistema.idSistema"							
								 />
							</div>
						</div>
						<div class="divLinhaCadastro" >
							<div class="divItemGrupo">
							<p style="width: 80px;">Prioridade:</p>
								<s:select list="nivelList"
										cssStyle="width:120px"
										listKey="id"
										listValue="value"
										name="entidade.nmPrioridade"							
								 />
							</div>
						</div>

						<div class="divLinhaCadastro" >
							<div class="divItemGrupo">
							<p style="width: 80px;">Título:</p>
								<s:textfield name="entidade.dsTitulo" onblur="toUpperCase(this)" maxlength="50" size="25" />
								
							</div>
						</div>
						
						<div class="divLinhaCadastro" >
							<div class="divItemGrupo">
							<p style="width: 80px;">Caminho:</p>
								<s:textfield name="entidade.dsCaminho" onblur="toUpperCase(this)" maxlength="250" size="40" />
							</div>
						</div>
				</s:else>	
			</div>
			  
			<div class="divGrupo" style="height:150px; width:592px; margin-right:0px; padding-right:0px;">
				<div class="divGrupoTitulo">Complemento</div>
			
					<div class="divLinhaCadastro" >
								 
						<div class="divItemGrupo" style="width: 200px;" >
						<p style="width:40px;">Para:</p>
							<s:select list="usuarioDestinoList"
										cssStyle="width:150px"
										listKey="idUsuario"
										name="entidadeComplemento.usuarioEJB.idUsuario"							
							/>
						</div>

						<div class="divItemGrupo" style="width: 150px;" >
							<p style="width:40px;">Status:</p>
							<s:select list="statusList"
										cssStyle="width:100px"
										listKey="idStatus"
										listValue="dsStatus"
										name="entidadeComplemento.scmStatusEJB.idStatus"							
							/> 
						</div>
					</div>
					
					 <div class="divLinhaCadastro" style="height:90px;">
						 <div class="divItemGrupo" style="width:592px;" >
						 	<p style="width:40px;">Desc:</p>
						 	<textarea class="edit" name="entidadeComplemento.dsDescricao" rows="3" style="width:530px; height:75px;"><s:property value="entidadeComplemento.dsDescricao" /></textarea>
						</div>
					</div>
			
			</div>
			
			<s:if test="%{entidade.idMudanca != null}">			
				<div class="divGrupo" style="height:295px;">
					<div class="divGrupoTitulo">Histórico</div>
					<div style="width: 99%; height: 270px; overflow-y:auto;">
					<s:iterator value="entidade.scmMudancaComplementos" status="row" var="mov">
							
							<div class="divLinhaCadastro" style="height:70px; width: 300px; background-color:white;">
								<div class="divItemGrupo" style="height:20px; width:290px;" >
									<p title="" style="width:40px;">Para:</p>
									<p style="width:250px; color:blue; cursor: pointer;" title='<s:property value="usuarioEJB" />'><s:property value="usuarioEJB.toString().length() > 35?usuarioEJB.toString().substring(0,32).concat(\"...\"):usuarioEJB.toString()" /></p>
								</div>
								<div class="divItemGrupo" style="height:20px; width:290px;" >
									<p style="width:40px;">Data: </p>
									<s:property value="id.dtDataCriacao" />
								</div>
								<div class="divItemGrupo" style="height:20px; width:290px;" >
									<p style="width:40px;">Status: </p>
									<s:property value="scmStatusEJB.dsStatus" />
								</div>
							</div>
							<div class="divLinhaCadastro" style="margin-left:0px;height:70px; width: 635px; background-color:white;">
								<div class="divItemGrupo" style="width:635px;" >
									<p style="width:80px;">Descricao:</p>
									<div style="width: 550px; height: 68px; overflow-y:auto; border:1px solid black;">
									<s:property value="dsDescricao" />
									</div>
								</div>
							</div>
					</s:iterator>
					</div>
				</div>
			</s:if>
	
             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                    <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
             </div>
         

</div>
</div>
</s:form>