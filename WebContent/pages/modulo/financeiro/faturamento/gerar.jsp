<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
			$('#linhaFaturamento').css('display','block');
           
			function cancelar(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="pesquisarFaturamento!prepararPesquisa.action" namespace="/app/financeiro" />';
				submitForm( vForm );
			}

			function unificarDuplicata(){

				var total = $("input:checkbox[id='ids'][checked='true']").length;
				if (total <= 1){
					alerta('Selecione ao menos DUAS notas.');
					return false;
				}
		
				//nomeEmpresa = '';
				//tot = $("input:checkbox[id='ids']").length;
				//for(idx=0; idx < tot; idx++ ){
				//	if ($("input:checkbox[id='ids']")[idx].checked ){
				//		if (nomeEmpresa == ''){
				//			nomeEmpresa = Trim($("div[id='nomeEmpresa"+idx+"']").text());
				//		}else{
				//			if (nomeEmpresa != Trim($("div[id='nomeEmpresa"+idx+"']").text())){
				//				alerta('Não é possível unificar notas de empresas diferentes.');
				//				return false;
				//			}						
				//		}
				//	}
				//}
				if (confirm('Confirma a unificação?')){
					vForm = document.forms[0];
					vForm.action = '<s:url action="gerarDuplicata!unificarDuplicata.action" namespace="/app/financeiro" />';
					submitForm( vForm );
				}
			}

			function gerar(){
				var total = $("input:checkbox[id='ids'][checked='true']").length;
				if (total == 0){
					alerta('Selecione ao menos UMA nota.');
					return false;
				}

				if (confirm('Confirma a geração?')){
					vForm = document.forms[0];
					submitForm( vForm );
				}
			}


	        $(function() {
	            $(".chkTodos").click(
	                    function() { 
	                        newValue = this.checked;
	                        $("div[id='divDup'] input:checkbox").attr('checked',newValue);
	                    }
	            );
	        });
            
        </script>


<s:form  action="gerarDuplicata!gerarDuplicata.action" theme="simple" namespace="/app/financeiro">

<div class="divFiltroPaiTop">Gerar duplicatas</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;" >
            <div class="divGrupo" style="height:450px;" id="divDup">
                <div class="divGrupoTitulo">Dados da nota</div>
            
                <div class="divLinhaCadastro" style="height:400px;overflow: auto;">
				
                <div style="width:100%; height:300%; border: 0px solid black; ">
            
            
                <div class="divLinhaCadastro">
                        <div class="divItemGrupo" style="width:15px;background-color:  #06F;">
                        	<input type="checkbox" class="chkTodos" />
                    	</div>

                        <div class="divItemGrupo" style="width:250px;background-color:  #06F; color:  #FFF;">
                        	Empresa
                    	</div>
                    	
                        <div class="divItemGrupo" style="width:100px;background-color:  #06F; color:  #FFF;">
                        	Nota
                    	</div>
                        <div class="divItemGrupo" style="width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Valor
                    	</div>
                		<div class="divItemGrupo" style="width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Comissão
                    	</div>
                    	<div class="divItemGrupo" style="width:100px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Encargos
                    	</div>
                </div>
            
            	<s:iterator value="#session.listaPesquisa"  status="row" >    
                
	                <div class="divLinhaCadastro" style="background-color:white;">
	                        <div class="divItemGrupo" style="width:15px;">
	                        	<input type="checkbox" class="chkDuplicata" name="idDuplicata" id="ids" value='<s:property value="idDuplicata"/>' />
	                    	</div>

	                        <div class="divItemGrupo" style="width:250px;" id="nomeEmpresa${row.index}">
	                        	<s:property value="empresa"/>
	                    	</div>
	                    	
	                        <div class="divItemGrupo" style="width:100px;">
	                        	<s:property value="numNota"/>
	                    	</div>
	                        <div class="divItemGrupo" style="width:100px; text-align:right;">
	                        	<s:property value="valorDuplicata"/>
	                    	</div>
	                		<div class="divItemGrupo" style="width:100px; text-align:right;">
	                        	<s:property value="comissao"/>
	                    	</div>
	                    	<div class="divItemGrupo" style="width:100px; text-align:right;">
	                        	<s:property value="encargos"/>
	                    	</div>
	                </div>

				</s:iterator>
                
                </div>
                </div>

                
          	</div>


            <div class="divCadastroBotoes">
                  <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                  <duques:botao label="Gerar" 	 imagem="imagens/iconic/png/check-4x.png" onClick="gerar()" />
				  <duques:botao label="Unificar" imagem="imagens/iconic/png/check-4x.png" onClick="unificarDuplicata()" />
            </div>
              
        </div>
</div>
</s:form>