<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
			$('#linhaTesouraria').css('display','block');           
			
			function cancelar(){
				vForm = document.forms[0];
				vForm.action = '<s:url action="pesquisarTesouraria!prepararPesquisa.action" namespace="/app/financeiro" />';
				submitForm( vForm );
			}

            
            
            function gravar(){

                if( $("input:checkbox[class='chk'][checked='true']").length == 0){
					alerta("Selecione pelo menos UM título efetuar a conciliação.");
					return false;
				}

				var qtde = $("input:checkbox[class='chk'][checked='true']").length;
				for (x=0;x<qtde;x++){
					objChk = $("input:checkbox[class='chk'][checked='true']").get(x);
					idxObjChk = $(".chk").index(objChk);
					if ( $(".dp").get(idxObjChk).value == ''){
						alerta("Você deve informar a Data de Conciliação para UM título marcado para conciliar.");
						return false;
					} 
				}
                submitForm(document.forms[0]);
		               
            }


            $(function() {
	            $(".chkTodos").click(
	                    function() { 
	                        newValue = this.checked;
	                        $(".chk").attr('checked',newValue);
							calcularValorPagamento();
	                    }
	            );
				$(".chk").click(
	                    function() { 
	                    	calcularValorPagamento();
	                    }
	            );
				
				
	        });

			 function calcularValorPagamento(){
					var tot = $("input:checkbox[class='chk'][checked='true']").length;
					var valorTotal = 0;
					for(idx=0; idx < tot; idx++ ){
						idChk = $("input:checkbox[class='chk'][checked='true']")[idx].value;
						valorTotal += 
								Math.round( 
									parseFloat(Trim( $($("div[id='divDup"+idChk+"'] .divItemGrupo")[5]).text() ).replace(".","").replace(",",".") )
									* 100)/100;
					}
					$('#divTotal').html(arredondaFloat(Math.round( valorTotal* 100)/100).toString().replace(".",","));
					$('#divQtdeTotal').html(tot);
					
			 }
				
            
			function atualizar(){
				
				vForm = document.forms[0];
				vForm.action = '<s:url action="conciliarTesouraria!prepararConciliacao.action" namespace="/app/financeiro" />';
				submitForm( vForm );
				
			}

        </script>

<s:form  action="conciliarTesouraria!conciliarTesouraria.action" theme="simple" namespace="/app/financeiro">


<div class="divFiltroPaiTop">Tesouraria</div>
<div class="divFiltroPai" >
        
        <div class="divCadastro" style="overflow:auto;" >
            <div class="divGrupo" style="height:460px;">
                
                <div class="divGrupoTitulo">
                		Conciliação
                </div>
             
                <div class="divLinhaCadastro" style="height:400px;overflow: auto;">
				
                <div style="width:100%; height:300%; border: 0px solid black; ">
				<div class="divLinhaCadastro" style="background-color:white;">
                        <div class="divItemGrupo" style="border-right:1px solid white;width:50px;background-color:  #06F; color:  #FFF;">
                        	<input type="checkbox" class="chkTodos"/>
                    	</div>
			<div class="divItemGrupo" style="border-right:1px solid white;width:50px;background-color:  #06F; color:  #FFF;">
                        	Hotel
                    	</div>

                        <div class="divItemGrupo" style="border-right:1px solid white;width:170px;background-color:  #06F; color:  #FFF;">
                        	Banco
                    	</div>
                		<div class="divItemGrupo" style="border-right:1px solid white;width:80px;background-color:  #06F; color:  #FFF;">
                        	CC
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:160px; text-align:center;background-color:  #06F; color:  #FFF;">
                        	Dt.lçto
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:70px; text-align:right;background-color:  #06F; color:  #FFF;">
                        	Valor
                    	</div>
                    	<div class="divItemGrupo" style="border-right:1px solid white;width:180px;text-align:center;background-color:  #06F; color:  #FFF;">
                        	Documento
                    	</div>
				    	<div class="divItemGrupo" style="border-right:1px solid white;width:120px;text-align:center;background-color:  #06F; color:  #FFF;">
                        	Dt Conciliação 
                    	</div>

                </div>
                <s:iterator value="#session.listaPesquisa" status="row">
                	<div class="divLinhaCadastro" style="background-color:white;" id='divDup<s:property value="idTesouraria"/>'>
                		<input type="hidden" name="idTesouraria" value='<s:property value="idTesouraria" />' />
                		
						<div class="divItemGrupo" style="width:50px;border-right:1px solid black;">
							<input type="checkbox" value='${row.index}' name="indiceIdTesouraria" class="chk"/>
						</div>
						<div class="divItemGrupo" style="width:50px;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="sigla" /></p>
						</div>
						<div class="divItemGrupo" style="width:170px;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="nomeContaCorrente" /></p>
						</div>
						<div class="divItemGrupo" style="width:80px;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="contaCorrente"/></p>
						</div>
						<div class="divItemGrupo" style="width:170px;text-align:center;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="data"/></p>
						</div>
						<div class="divItemGrupo" style="width:70px;text-align:right;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="valor"/></p>
						</div>
						<div class="divItemGrupo" style="width:180px;text-align:left;border-right:1px solid black;"><p style="width:100%;">
							<s:property value="numDocumento"/></p>
						</div>
						<div class="divItemGrupo" style="width:120px;text-align:left;border-right:1px solid black;">
                        	<input type="text" class="dp" value='<s:property value="#session.CONTROLA_DATA_SESSION.tesouraria" />' name="dataConciliacao" maxlength="10" size="10" onblur="dataValida(this)" onkeypress="mascara(this, data)" />
                    	</div>
                	</div>
                </s:iterator>
				</div>
                </div>
		   </div>
		   <div class="divCadastroBotoes" style="width:47%;float:left">
				<div class="divLinhaCadastro" style="background-color:transparent; border:0;">
					<div class="divItemGrupo" style="width:100px;font-size:12pt;">
						Qtde Total:
					</div>
					<div class="divItemGrupo" style="text-align:left; width:50px;font-size:12pt;color:green">
						<s:property value="#session.listaPesquisa.size()" />
					</div>
					<div class="divItemGrupo" style="width:100px;font-size:12pt;">
						Qtde Sel.:
					</div>
					<div class="divItemGrupo" id="divQtdeTotal" style="text-align:left; width:50px;font-size:12pt;color:green">
						0
					</div>
				</div>

				<div class="divLinhaCadastro" style="background-color:transparent; border:0;">
					<div class="divItemGrupo" style="width:190px;font-size:12pt;">
						Valor conciliação:
					</div>
					<div class="divItemGrupo" id="divTotal" style="text-align:left; width:250px;font-size:12pt;color:green">
						0,00
					</div>
				</div>
		   </div>
           <div class="divCadastroBotoes" style="width:50%;float:left">
                  <duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />
                  <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
           </div>
              
        </div>
</div>
</s:form>