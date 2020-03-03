<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarAuditoria!prepararPesquisa.action" namespace="/app/auditoria" />';
        		submitForm(vForm);
            }
            
            function atualizar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="reabrirConta!prepararReaberturaConta.action" namespace="/app/auditoria" />';
        		submitForm(vForm);
            }
            
            
            
            function gravar(idNota){

				if (confirm('Confirma a reabertura desta nota?')){
					if (idNota == '' || idNota == null){
						alerta("O campo 'Nota' é obrigatório.");
						return false;
					 }
					document.forms[0].idNota.value = idNota;
					submitForm(document.forms[0]);
				}
            }

        </script>






<s:form namespace="/app/auditoria" action="reabrirConta!reabrirConta.action" theme="simple">
<s:hidden name="idNota" id="idNota" />
<s:hidden name="entidade.idMovimentoApartamento" />
<div class="divFiltroPaiTop">Reabertura de conta</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:470px;">
                <div class="divGrupoTitulo">Saída do dia</div>

					<div class="divLinhaCadastro" style="background: white;">
						<div class="divItemGrupo" style="heignt:15px; width: 70px;color: white;background: rgb(49, 115, 255);">
							Apto
						</div>
						<div class="divItemGrupo" style="heignt:15px; width: 70px;color: white;background: rgb(49, 115, 255);">
							Num nota
						</div>
						<div class="divItemGrupo" style="heignt:15px; width: 250px;color: white;background: rgb(49, 115, 255);">
							Hóspede
						</div>
						<div class="divItemGrupo" style="heignt:15px; width: 350px;color: white;background: rgb(49, 115, 255);">
							Empresa
						</div>
						<div class="divItemGrupo" style="heignt:15px; width: 210px;color: white;background: rgb(49, 115, 255);">
							&nbsp;
						</div>
						
					</div>


                	<div class="divGrupoBody" style="margin-top:17px; height:90%;">
                	
	                	<s:iterator value="saidaDiaList" var="row">
			                <div class="divLinhaCadastro">
			                    <div class="divItemGrupo" style="width:70px;" >
			                    	<s:property value="numApartamento" /> - <s:property value="tipoApartamento" /> 
			                    </div>
			                    
			                    <div class="divItemGrupo" style="width:70px;" >
			                    	<s:property value="numNota" /> 
			                    </div>
			                    
			                    <div class="divItemGrupo" style="width:250px;" >
			                    	<s:property value="nomeHospede" /> 
			                    </div>
			                    
			                    <div class="divItemGrupo" style="width:350px;" >
			                    	<s:property value="nomeEmpresa" /> 
			                    </div>

			                    <div class="divItemGrupo" style="width:40px;" >
			                    	<img src="imagens/iconic/png/lock-unlocked-4x.png" title="Reabrir conta" onclick="gravar('<s:property value="idNota" />');"/>  
			                    </div>
			                    
			                </div>
		                </s:iterator>

					</div>


              </div>


             <div class="divCadastroBotoes">
                    <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
					<duques:botao label="Atualizar" imagem="imagens/iconic/png/loop-circular-3x.png" onClick="atualizar()" />
             </div>
              
        </div>
</div>
</s:form>