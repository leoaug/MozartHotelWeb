<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarTarifa!prepararPesquisa.action" namespace="/app/comercial" />';
        		submitForm(vForm);
            }



            function verDias(){

				dias = $('#divData').DatePickerGetDate(true);
				dtInicio = dias[0];
				dtFim = dias[1];

				document.forms[0].dataEntrada.value = dtInicio;
				document.forms[0].dataSaida.value = dtFim;

				var dataInicio = new Date(dtInicio.split('/')[2],parseInt(dtInicio.split('/')[1],10)-1,dtInicio.split('/')[0] );
				var dataFim = new Date(dtFim.split('/')[2],parseInt(dtFim.split('/')[1],10)-1,dtFim.split('/')[0] );
				
				dataCorrente = dataInicio;
				var result = "";
				var diasSemanas = getDiasSemanas();
				var tarifaNova = true;
				var dataAnterior;
				while ( dataCorrente <= dataFim){
					 if (diasSemanas.indexOf(";"+dataCorrente.getDay()+";") >= 0){
						if (tarifaNova){
							result += formatDate(dataCorrente,'d/m/Y')+'-';
							tarifaNova = false;
						}
						if (dataCorrente.valueOf() == dataFim.valueOf()){
							result += formatDate(dataCorrente,'d/m/Y')+';';
						}

					 }else{
						if (!tarifaNova){
							result += formatDate(dataAnterior,'d/m/Y')+';';
							tarifaNova = true;
						}
						
					 }
					dataAnterior = new Date(dataCorrente.getFullYear(), dataCorrente.getMonth(), dataCorrente.getDate());
					dataCorrente.addDays(1);	
				}

				if (result.lastIndexOf("-") == result.length -1)
					result += formatDate(dataFim,'d/m/Y')+';';

				return result;

	        }
            
			
            
            function gravar(){


				if ($('#idTipoTarifa').val() == ''){
					alerta("O campo 'Tipo' é obrigatório.");
					return false;
				}

				if ($('#descricao').val() == ''){
					alerta("O campo 'Nome tarifa' é obrigatório.");
					return false;
				}

				if ($('#descricao').val() == ''){
					alerta("O campo 'Nome tarifa' é obrigatório.");
					return false;
				}
				

            	
				var intervalos = verDias();
				if (intervalos == null || intervalos == '' || intervalos.length <= 1){
					alerta("O campo 'Período' é obrigatório.");
					return false;
				}

				if ($("input[id='tarifas'][value!='']").length < $("input[id='tarifas']").length){
					alerta("Os campos 'Valores' são obrigatórios.");
					return false;
				}

				if ($('#idTipoTarifa').val() == 'P'){
					if ( $("input[id='descricaoIdioma0']").val() == '' || 
						 $("input[id='descricaoIdioma1']").val() == '' ||
						 $("input[id='descricaoIdioma2']").val() == ''){

						alerta("Os campos 'Descrição' nos idiomas são obrigatórios.");
						return false;
					}
				}

				document.forms[0].intervalos.value = intervalos;
				
                submitForm(document.forms[0]);                
            }
			
			function marcarTodos(obj){
				newValue = obj.checked;
                $("input:checkbox").attr('checked',newValue);
			}

			
			function getDiasSemanas(){
				var diasSemanas = ";";
				vForm = document.forms[0];
				
				if ( vForm.domingo.checked ){
					diasSemanas += vForm.domingo.value+";";
				}
				if ( vForm.segunda.checked ){
					diasSemanas += vForm.segunda.value+";";
				}
				if ( vForm.terca.checked ){
					diasSemanas += vForm.terca.value+";";
				}
				if ( vForm.quarta.checked ){
					diasSemanas += vForm.quarta.value+";";
				}
				if ( vForm.quinta.checked ){
					diasSemanas += vForm.quinta.value+";";
				}
				if ( vForm.sexta.checked ){
					diasSemanas += vForm.sexta.value+";";
				}
				if ( vForm.sabado.checked ){
					diasSemanas += vForm.sabado.value+";";
				}
				return diasSemanas;
			}
			
			function pesquisar(){
			
				var diasSemanas = getDiasSemanas();
			
				
				var now2 = new Date();
				
				$('#divData').DatePickerHide();
				$('#divData').DatePicker({
					flat: true,
					date: ['<s:property value="entidade.dataEntrada"/>','<s:property value="entidade.dataSaida"/>'],
					current: '<s:property value="entidade.dataEntrada"/>',
					calendars: 5,
					format: 'd/m/Y',
					mode: 'range',
					starts: 0,
					onRender: function(date) {
						return {
							disabled: ( diasSemanas.indexOf(";"+date.getDay()+";") < 0),
							className: date.valueOf() == now2.valueOf() ? 'datepickerSpecial' : false

						}
					}
				});
			
			}	
			
			
			function habilitarLegenda( valor ){
			
				if ( "P" == valor || "W" == valor ){
					$('#legenda').css('display','block');
				}else{
					$('#legenda').css('display','none');
				}
			
			}


			function adicionarTarifaIdioma(idx, valor){

				$("input[id='descricaoIdioma"+idx+"']").val( valor );
			}
        	
			
			function fecharDivTarifaIdioma(){
				killModal();
			}
			function abrirDivTarifaIdioma(){
				$("#descricaoTarifaIdioma0").val( $("input[id='descricaoIdioma0']").val() );
				$("#descricaoTarifaIdioma1").val( $("input[id='descricaoIdioma1']").val() );
				$("#descricaoTarifaIdioma2").val( $("input[id='descricaoIdioma2']").val() );
				showModal('#divTarifaIdioma');
			}
        </script>



<s:form namespace="/app/comercial" action="manterTarifa!gravar.action" theme="simple">

<!--Div TARIFA IDIOMA-->    
            <div id="divTarifaIdioma"  class="divCadastro" style="display:none;height:350px;width:650px;">       
             <div class="divGrupo" style="width:98%; height:250px">
                <div class="divGrupoTitulo">Descrição da tarifa</div>

					<s:iterator value="#session.LISTA_TARIFA_IDIOMA" var="obj" status="row">
	                    <div class="divLinhaCadastro" style="height:55px">
								<div class="divItemGrupo" style="width:40px"><p style="width:100%;">&nbsp;</p>
									<img src='<s:property value="idiomaMozart.enderecoImagem"/>' title='<s:property value="idiomaMozart.descricao"/>'   />

								</div>
								<div class="divItemGrupo" style="width:300px">
									<s:textarea cssClass="divTextArea" name="descricaoTarifaIdioma" id="descricaoTarifaIdioma%{#row.index}" cols="30" rows="2" value="%{#obj.descricaoWeb}" onblur="adicionarTarifaIdioma('%{#row.index}',this.value);"></s:textarea>
								
								</div>
								
	                    </div>
                    </s:iterator>
             </div>          
            
             <div class="divCadastroBotoes" style="width:98%;">
                  <duques:botao label="Fechar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="fecharDivTarifaIdioma()" />
             </div>               
            </div>
<!--FIM TARIFA IDIOMA-->
<s:hidden name="descricaoIdioma0" id="descricaoIdioma0"/>
<s:hidden name="descricaoIdioma1" id="descricaoIdioma1"/>
<s:hidden name="descricaoIdioma2" id="descricaoIdioma2"/>
<s:hidden name="intervalos" id="intervalos" />
<s:hidden name="entidade.idTarifa" />
<s:hidden name="entidade.dataEntrada" id="dataEntrada" />
<s:hidden name="entidade.dataSaida" id="dataSaida"/>
<div class="divFiltroPaiTop">Tarifa</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:310px;">
                <div class="divGrupoTitulo">Dados da tarifa</div>

				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:280px"><p style="width:80px;">Tipo:</p>
						<s:select list="#session.LISTA_TIPO_TARIFA" 
								  cssStyle="width:180px"
								  headerKey="" headerValue="Selecione" 
								  listKey="id"
								  listValue="value" 
								  name="entidade.tipo"
								  id="idTipoTarifa" onchange="habilitarLegenda(this.value)"/>
											
					</div>
					<div class="divItemGrupo" style="width:35px">
							<img style ="display:none;" id="legenda" src="imagens/bandeiraBrasileira.png" title="Descrição da tarifa" onclick="abrirDivTarifaIdioma()" />
											
					</div>
					<div class="divItemGrupo" style="width:250px"><p style="width:80px;">Nome tarifa:</p>
						<s:textfield name="entidade.descricao" id="descricao" maxlength="20" size="20" onblur="toUpperCase(this)" />
					</div>
					
					<div class="divItemGrupo" style="width:170px"><p style="width:80px;">Moeda:</p>
						<s:select list="#session.LISTA_MOEDA" 
								  cssStyle="width:80px"
								  listKey="idMoeda"
								  name="entidade.idMoeda"
								  id="idMoeda" />
					</div>
					
					<div class="divItemGrupo" style="width:170px"><p style="width:80px;">Ativa:</p>
						<s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:80px"
								  listKey="id"
								  listValue="value"
								  name="entidade.ativo"
								  id="ativo" />
					</div>
					
                </div>

				<div class="divLinhaCadastro" style="height:55px">
                    <div class="divItemGrupo" style="width:290px"><p style="width:80px;">Grupo tarifa:</p>
						<s:select list="#session.LISTA_GRUPO_TARIFA" 
								  cssStyle="width:180px"
								  headerKey="" headerValue="Selecione" 
								  listKey="idTarifaGrupo"
								  listValue="descricao" 
								  name="entidade.tarifaGrupo.idTarifaGrupo"
								  id="idTarifaGrupo" />
					
					</div>
					
					<div class="divItemGrupo" style="width:600px;"><p style="width:80px;">Observação:</p>
						<s:textarea name="entidade.observacao" onblur="toUpperCase(this)" cols="50" rows="2" />
					</div>
					
                </div>
                
				<div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:700px"><p style="width:100px;">Período/dias:</p>
						Todos os dias<input type="checkbox" checked="checked" name='todos' value='S' style="border:0px;" onclick="marcarTodos(this)" />
						Domingo<input type="checkbox" checked="checked"  name='domingo' value='0'  style="border:0px;" />
						Segunda<input type="checkbox" checked="checked"  name='segunda' value='1'  style="border:0px;" />
						Terça<input type="checkbox" checked="checked"  name='terca'     value='2'  style="border:0px;" />
						Quarta<input type="checkbox" checked="checked"  name='quarta' value='3'  style="border:0px;" />
						Quinta<input type="checkbox" checked="checked"  name='quinta'  value='4'  style="border:0px;" />
						Sexta<input type="checkbox" checked="checked"  name='sexta' value='5'  style="border:0px;" />
						Sábado<input type="checkbox" checked="checked"  name='sabado' value='6'  style="border:0px;" />
					</div>
                    <div class="divItemGrupo" style="width:10%">
						<img  src="imagens/iconic/png/loop-circular-3x.png" title="Atualizar"  onclick="pesquisar();" />
					</div>
                </div>
				<p id="divData" style="margin-top:110px;margin-left:20px;padding-top:7px;position: fixed" ></p>
               
				


              </div>
              <div class="divGrupo" style="height:210px;">
                <div class="divGrupoTitulo">Valores</div>
				
				 <div id="divBodyDisp" style="width: 900px; height: 180px; overflow-y: auto; margin:0px; margin-left:20px; padding:0px;">
					<div class="divLinhaCadastroPrincipal">
	                    <div class="divItemGrupo" style="width: 70px;background-color:rgb(49, 115, 255);">
	                    	<p style="width:70px;color:white;">Tipo Apto</p>
						</div>
						
	                    <div class="divItemGrupo" style="width: 100px;background-color:rgb(49, 115, 255);text-align:center;">
	                    	<p style="width:100px;color:white;">SGL</p>
						</div>

	                    <div class="divItemGrupo" style="width: 100px;background-color:rgb(49, 115, 255);text-align:center;">
	                    	<p style="width:100px;color:white;">DBL</p>
						</div>

	                    <div class="divItemGrupo" style="width: 100px;background-color:rgb(49, 115, 255);text-align:center;">
	                    	<p style="width:100px;color:white;">TPL</p>
						</div>

	                    <div class="divItemGrupo" style="width: 100px;background-color:rgb(49, 115, 255);text-align:center;">
	                    	<p style="width:100px;color:white;">QDL</p>
						</div>

	                    <div class="divItemGrupo" style="width: 100px;background-color:rgb(49, 115, 255);text-align:center;">
	                    	<p style="width:100px;color:white;">QTL</p>
						</div>

	                    <div class="divItemGrupo" style="width: 100px;background-color:rgb(49, 115, 255);text-align:center;">
	                    	<p style="width:100px;color:white;">SXL</p>
						</div>

	                    <div class="divItemGrupo" style="width: 100px;background-color:rgb(49, 115, 255);text-align:center;">
	                    	<p style="width:100px;color:white;">STL</p>
						</div>
						
	                </div> 
	                	
						<s:iterator value="#session.LISTA_TIPO_APTO" status="row" var="obj">
							<s:hidden name="idTipoApartamento" value="%{#obj.idTipoApartamento}" />
							<div class="divLinhaCadastro">
			                    <div class="divItemGrupo" style="width: 70px;">
			                    	<p style="width:70px;"><s:property value="fantasia"/></p>
								</div>
								
			                    <div class="divItemGrupo" style="width: 100px;text-align:center;">
			                    	<p style="width:100px;"><input type="text" name="tarifas" id="tarifas" value="<s:property value="tarifas[(#row.index*8)+0]"/>" size="10" maxlength="10" onkeypress="mascara(this, moeda)"/></p>
								</div>
		
			                    <div class="divItemGrupo" style="width: 100px;text-align:center;">
			                    	<p style="width:100px;"><input type="text" name="tarifas" id="tarifas" value="<s:property value="tarifas[(#row.index*8)+1]"/>" size="10" maxlength="10" onkeypress="mascara(this, moeda)"/></p>
								</div>
		
			                    <div class="divItemGrupo" style="width: 100px;text-align:center;">
			                    	<p style="width:100px;"><input type="text" name="tarifas" id="tarifas" value="<s:property value="tarifas[(#row.index*8)+2]"/>" size="10" maxlength="10" onkeypress="mascara(this, moeda)"/></p>
								</div>
		
			                    <div class="divItemGrupo" style="width: 100px;text-align:center;">
			                    	<p style="width:100px;"><input type="text"  name="tarifas" id="tarifas" value="<s:property value="tarifas[(#row.index*8)+3]"/>" size="10" maxlength="10" onkeypress="mascara(this, moeda)"/></p>
								</div>
		
			                    <div class="divItemGrupo" style="width: 100px;text-align:center;">
			                    	<p style="width:100px;"><input type="text"  name="tarifas" id="tarifas" value="<s:property value="tarifas[(#row.index*8)+4]"/>" size="10" maxlength="10" onkeypress="mascara(this, moeda)"/></p>
								</div>
		
			                    <div class="divItemGrupo" style="width: 100px;text-align:center;">
			                    	<p style="width:100px;"><input type="text"  name="tarifas" id="tarifas" value="<s:property value="tarifas[(#row.index*8)+5]"/>" size="10" maxlength="10" onkeypress="mascara(this, moeda)"/></p>
								</div>
		
			                    <div class="divItemGrupo" style="width: 100px;text-align:center;">
			                    	<p style="width:100px;"><input type="text"  name="tarifas" id="tarifas" value="<s:property value="tarifas[(#row.index*8)+6]"/>" size="10" maxlength="10" onkeypress="mascara(this, moeda)"/></p>
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
<script type="text/javascript">
	<%=(String)request.getAttribute("scriptCalendario")%>
	pesquisar();
	habilitarLegenda( $('#idTipoTarifa').val() );
	$('#divData').css('position','static');
	$('div.datepicker').css('position','static');
	
</script>