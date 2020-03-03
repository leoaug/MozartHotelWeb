<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
			function cancelar(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="main!preparar.action" namespace="/app" />';
				submitForm( vForm );
			}

            
            
            function gravar(){
                        
                submitForm(document.forms[0]);
            }


            
        </script>






<s:form namespace="/app/operacional" action="manterConfiguracaoNotaFiscal!gravar.action" theme="simple">

<div class="divFiltroPaiTop">Configuração-NF </div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:450px;">
                <div class="divGrupoTitulo">Dados da Nota Fiscal</div>
                
				
				<div class = "divGrupoBody">
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:150px;" >Campo</div>
                    <div class="divItemGrupo" style="width:100px;" >  
                        <p style="width:100px;">Linha</p>
                    </div>
                    <div class="divItemGrupo" style="width:100px;" > 
                        <p style="width:100px;">Coluna</p>
                    </div>
                </div>

               <s:iterator value="configNotaList" status="row">
		<div class="divLinhaCadastro" >
			<input type="hidden" name="campos" value="<s:property value="id.campo" />">
			<div class="divItemGrupo" style="width: 150px;">
				<p style="width: 100%;"><s:property value="id.campo.trim().substring(0,id.campo.trim().length() - 1)" /></p>
			</div>
			
			<div class="divItemGrupo" style="width: 100px;">
				<input type="text" size="4" name="linhas" maxlength="3" onkeypress="mascara(this, numeros)" value="<s:property value="linha" />">
			</div>
			<div class="divItemGrupo" style="width: 100px;">
				<input type="text" size="4" name="colunas" maxlength="3" onkeypress="mascara(this, numeros)" value="<s:property value="coluna" />">
			</div>
		
		</div>
	</s:iterator>
                               
              </div>  

			</div>
			

           <div class="divCadastroBotoes">
                  <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                  <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
           </div>
              
        </div>
</div>
</s:form>