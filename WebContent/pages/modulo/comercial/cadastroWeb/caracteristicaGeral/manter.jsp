<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">


			$(document).ready(function()	{
			   //$('#idResumo').markItUp(myHtmlSettings);
			   //$('#idCaracteristica').markItUp(myHtmlSettings);
				  $('#idCaracteristica').wysiwyg();
				  $('#idResumo').wysiwyg();
				  
			});

    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarCaracteristicaGeral!prepararPesquisa.action" namespace="/app/comercial" />';
        		submitForm(vForm);
            }
            
            
            function gravar(){
                        
                submitForm(document.forms[0]);                
            }

        </script>


<s:form namespace="/app/comercial" action="manterCaracteristicaGeral!gravar.action" theme="simple">

<s:hidden name="entidade.idCaracteristicasGerais" />
<div class="divFiltroPaiTop">Característica Geral</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:250px;">
                <div class="divGrupoTitulo">Resumo</div>
                <div class="divLinhaCadastro" style="height:220px;">
                    <div class="divItemGrupo" style="width:500px; height:220px;" >
						<s:textarea name="entidade.descricao" cols="80" rows="5" id="idResumo" ></s:textarea> 
		              </div>
                </div>
              </div>
              <div class="divGrupo" style="height:250px;">
                <div class="divGrupoTitulo">Características</div>
                <div class="divLinhaCadastro" style="height:220px;">
                    <div class="divItemGrupo" style="width:500px; height:220px;" >
						<s:textarea name="entidade.descricaoHotel" cols="80" rows="5" id="idCaracteristica" ></s:textarea> 
		              </div>
                </div>
              </div>
              <div class="divGrupo" style="height:160px;">
                <div class="divGrupoTitulo">Complemento</div>
                
                <div class="divLinhaCadastro">
                   <div class="divItemGrupo" style="width:250px;" >
                    	<p style="width:100px;">Idioma</p>
                    	<s:select list="idiomaList"
                    			  cssStyle="width:80px"	
                    			  listKey="idIdioma"
                    			  listValue="descricao"
                    			  name="entidade.idioma.idIdioma" />	
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Localização</p>
						<s:textfield name="entidade.localizacao" id="localizacao" maxlength="32" size="20" onkeyup="toUpperCase(this)"></s:textfield>                    	
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Estab.</p>
						<s:textfield name="entidade.estabelecimento" id="estabelecimento" maxlength="32" size="20" onkeyup="toUpperCase(this)"></s:textfield>                    	
	               </div>
                   <div class="divItemGrupo" style="width:200px;" >
                    	<p style="width:80px;">Unidade habi.</p>
						<s:textfield name="entidade.unidadesHabitacionais" id="unidade" maxlength="4" size="5" onkeyup="mascara(this, numeros)"></s:textfield>                    	
	               </div>
	              
	              
                </div>

                <div class="divLinhaCadastro">

                   <div class="divItemGrupo" style="width:250px;" >
                    	<p style="width:100px;">Ano construção</p>
						<s:textfield name="entidade.anoConstrucao" id="anoConstrucao" maxlength="4" size="5" onkeyup="mascara(this, numeros)"></s:textfield>                    	
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Últ. reforma</p>
						<s:textfield name="entidade.anoUltimaReforma" id="anoUltimaReforma" maxlength="4" size="5" onkeyup="mascara(this, numeros)"></s:textfield>                    	
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Qtde andares</p>
						<s:textfield name="entidade.qtdeAndares" id="qtdeAndares" maxlength="2" size="5" onkeyup="mascara(this, numeros)"></s:textfield>                    	
	               </div>
                   <div class="divItemGrupo" style="width:200px;" >
                    	<p style="width:80px;">Qtde elev.</p>
						<s:textfield name="entidade.qtdeElevadores" id="qtdeElevadores" maxlength="2" size="5" onkeyup="mascara(this, numeros)"></s:textfield>                    	
	               </div>

                </div>

                <div class="divLinhaCadastro">

                   <div class="divItemGrupo" style="width:250px;" >
                    	<p style="width:100px;">Aeroporto</p>
						<s:textfield name="entidade.nomeAeroporto" id="nomeAeroporto" maxlength="30" size="20" onkeyup="toUpperCase(this)"></s:textfield>                    	
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Rodoviária</p>
						<s:textfield name="entidade.nomeRodoviaria" id="nomeRodoviaria" maxlength="30" size="20" onkeyup="toUpperCase(this)"></s:textfield>                    	
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Nome centro</p>
						<s:textfield name="entidade.nomeCentro" id="nomeCentro" maxlength="30" size="20" onkeyup="toUpperCase(this)"></s:textfield>                    	
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Centro conv.</p>
						<s:textfield name="entidade.nomeCconvencoes" id="nomeConvencoes" maxlength="30" size="20" onkeyup="toUpperCase(this)"></s:textfield>                    	
	               </div>

                </div>
                 <div class="divLinhaCadastro">

                   <div class="divItemGrupo" style="width:250px;" >
                    	<p style="width:100px;">Dist aero</p>
						<s:textfield name="entidade.distanciaAeroporto" id="distanciaAero" maxlength="3" size="5" onkeypress="mascara(this, numeros)"></s:textfield>Km
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Dist rodov.</p>
						<s:textfield name="entidade.distanciaRodoviaria" id="distanciaRodo" maxlength="3" size="5" onkeypress="mascara(this, numeros)"></s:textfield>Km
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Dist centro</p>
						<s:textfield name="entidade.distanciaCentro" id="distanciaCentro" maxlength="3" size="5" onkeypress="mascara(this, numeros)"></s:textfield>Km
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Dist. ctr. conv.</p>
						<s:textfield name="entidade.distanciaCconvencoes" id="distanciaConvencoes" maxlength="3" size="5" onkeypress="mascara(this, numeros)"></s:textfield>Km
	               </div>

                </div>
                 <div class="divLinhaCadastro">

                   <div class="divItemGrupo" style="width:250px;" >
                    	<p style="width:100px;">Tempo aero</p>
						<s:textfield name="entidade.tempoAeroporto" id="tempoAero" maxlength="5" size="5" onkeypress="mascara(this, numeros)"></s:textfield>min                    	
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Dist rodov.</p>
						<s:textfield name="entidade.tempoRodoviaria" id="tempoRodo" maxlength="5" size="5" onkeypress="mascara(this, numeros)"></s:textfield>min                    	
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Dist centro</p>
						<s:textfield name="entidade.tempoCentro" id="tempoCentro" maxlength="5" size="5" onkeypress="mascara(this, numeros)"></s:textfield>min                    	
	               </div>
                   <div class="divItemGrupo" style="width:230px;" >
                    	<p style="width:80px;">Dist. ctr. conv.</p>
						<s:textfield name="entidade.tempoCconvencoes" id="tempoConvencoes" maxlength="5" size="5" onkeypress="mascara(this, numeros)"></s:textfield>min                    	
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