<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

			function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarControlaData!prepararPesquisa.action" namespace="/app/sistema" />';
        		submitForm(vForm);
            }
            
            function gravar(){

            	   submitForm(document.forms[0]);
                
            }
            
</script>

<s:form namespace="/app/sistema" action="manterControlaData!gravarControlaData.action" theme="simple">


	<div class="divFiltroPaiTop">Controla Data</div>
	<div class="divFiltroPai" >
       <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:280px;">
                <div class="divGrupoTitulo">Dados</div>
                
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width:410px;" ><p style="width:80px;">Hotel:</p>
							  <s:select list="hotelList" 
							  cssStyle="width:250px"  
							  name="entidade.idHotel"
							  listKey="idHotel"
							  listValue="nomeFantasia"
							  headerKey=""
							  headerValue="Selecione"> </s:select>
						</div>		
					</div>
		                <div class="divLinhaCadastro">
		                     
							 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Front Office:</p>
		                     <s:textfield cssClass="dp" name="entidade.frontOffice" onkeypress="mascara(this,data);" onblur="dataValida(this);" id="entidade.frontOffice" size="10" maxlength="10" /> 
		                     </div>
							 
							  <div class="divItemGrupo" style="width:250px;" ><p style="width:80px;">Fat. C. Rec.:</p>
		                     <s:textfield cssClass="dp" name="entidade.faturamentoContasReceber" onkeypress="mascara(this,data);" onblur="dataValida(this);" id="entidade.faturamentoContasReceber" size="10" maxlength="10" /> 
		                     </div>
							 
							 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Contabilidade:</p>
		                     <s:textfield cssClass="dp" name="entidade.contabilidade" onkeypress="mascara(this,data);" onblur="dataValida(this);" id="entidade.contabilidade" size="10" maxlength="10" /> 
		                     </div>
							 
               			</div>
						
						 <div class="divLinhaCadastro">
		                     
							 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Contas Pag:</p>
		                     <s:textfield cssClass="dp" name="entidade.contasPagar" onkeypress="mascara(this,data);" onblur="dataValida(this);" id="entidade.contasPagar" size="10" maxlength="10" /> 
		                     </div>
							 
							 <div class="divItemGrupo" style="width:250px;" ><p style="width:80px;">Contas Rec:</p>
							 <s:textfield cssClass="dp" name="entidade.contasReceber" onkeypress="mascara(this,data);" onblur="dataValida(this);" id="entidade.contasReceber" size="10" maxlength="10" /> 
		                     </div>
							 
							  <div class="divItemGrupo" style="width:250px;" ><p style="width:80px;">Tesouraria:</p>
		                     <s:textfield cssClass="dp" name="entidade.tesouraria" onkeypress="mascara(this,data);" onblur="dataValida(this);" id="entidade.tesouraria" size="10" maxlength="10" /> 
		                     </div>
							 
							 <div class="divItemGrupo" style="width:210px;" ><p style="width:80px;">Estoque:</p>
		                     <s:textfield cssClass="dp" name="entidade.estoque" onkeypress="mascara(this,data);" onblur="dataValida(this);" id="entidade.estoque" size="10" maxlength="10" /> 
		                     </div>
							 
               			</div>
						
					
					<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:310px;" ><p style="width:80px;">Ult Nota Hosp:</p>
								<s:textfield onkeypress="mascara(this, numeros)" maxlength="9"  name="entidade.ultimaNotaHospedagem"  id="" size="15" />
							</div>
                    
							<div class="divItemGrupo" style="width:310px;" ><p style="width:120px;">Ult Nº Dup:</p>
								<s:textfield onkeypress="mascara(this, numeros)" maxlength="9"  name="entidade.ultimoNumDuplicata"  id="" size="15" />
							</div>
					
							<div class="divItemGrupo" style="width:310px;" ><p style="width:120px;">Ult Nº Cot:</p>
								<s:textfield onkeypress="toUpperCase(this)" maxlength="40"  name="entidade.ultimoNumCotacao"  id="" size="15" />
							</div>
					</div>
					
					<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:310px;" ><p style="width:80px;">Ult Nº Pedido:</p>
								<s:textfield onkeypress="mascara(this, numeros)" maxlength="9"  name="entidade.ultimoNumPedido"  id="" size="15" />
							</div>
                    
							<div class="divItemGrupo" style="width:310px;" ><p style="width:120px;">Telefonia:</p>
								<s:textfield onkeypress="toUpperCase(this)" maxlength="40"  name="entidade.telefonia"  id="" size="15" />
							</div>
					</div>
					
					<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:310px;" ><p style="width:80px;">Saldo Elev:</p>
								<s:textfield onkeypress="mascara(this, moeda)" maxlength="9"  name="entidade.saldoElevado"  id="" size="15" />
							</div>
                    
							<div class="divItemGrupo" style="width:310px;" ><p style="width:120px;">Fechadura:</p>
								<s:textfield onkeypress="mascara(this, numeros)" maxlength="9"  name="entidade.fechadura"  id="" size="15" />
							</div>
					
							<div class="divItemGrupo" style="width:310px;" ><p style="width:120px;">Última Req.:</p>
								<s:textfield onkeypress="mascara(this, numeros)" maxlength="40"  name="entidade.ultimaRequisicao"  id="" size="15" />
							</div>
					</div>
					
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width:310px;" ><p style="width:80px;">Central Adv:</p>
						<s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:105px"  
								  name="entidade.centralAdviser"
								  listKey="id"
								  listValue="value"> </s:select>
							
						 </div>
						
						 <div class="divItemGrupo" style="width:310px;" ><p style="width:120px;">Aud. Enc.:</p>
								  <s:select list="#session.LISTA_CONFIRMACAO" 
								  cssStyle="width:105px"  
								  name="entidade.audEncerra"
								  listKey="id"
								  listValue="value"> </s:select>
							
						</div>
					</div>
					
					<div class="divLinhaCadastro">
							<div class="divItemGrupo" style="width:310px;" ><p style="width:80px;">Última NFS:</p>
									<s:textfield onkeypress="toUpperCase(this)" maxlength="1"  name="entidade.ultimaNfs"  id="" size="15" />
							</div>
							
							<div class="divItemGrupo" style="width:310px;" ><p style="width:120px;">Última CNFS:</p>
									<s:textfield onkeypress="toUpperCase(this)" maxlength="1"  name="entidade.UltimaCnfs"  id="" size="15" />
							</div>
							
							<div class="divItemGrupo" style="width:310px;" ><p style="width:120px;">Última Seq. Banc:</p>
									<s:textfield onkeypress="mascara(this, numeros)" maxlength="40"  name="entidade.tollFree"  id="" size="15" />
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