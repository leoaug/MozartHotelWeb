<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           
    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarPermuta!prepararPesquisa.action" namespace="/app/comercial" />';
        		submitForm(vForm);
            }
            
            
            function gravar(){
                        
                if ($("input[name='entidade.empresaHotel.empresaRedeEJB.empresaEJB.idEmpresa']").val() == ''){
                    alerta('Campo "Empresa" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.descricao']").val() == ''){
                    alerta('Campo "Descrição" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.dataInicio']").val() == ''){
                    alerta('Campo "Data início" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.dataFim']").val() == ''){
                    alerta('Campo "Data fim" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.valorDiaria']").val() != '' && $("input[name='entidade.qtdDiaria']").val() != ''){
                    alerta('Só é permitido escolher a "Qtde diária" ou "Valor diária".');
                    return false;
                }
                
                submitForm(document.forms[0]);                
            }

            function getEmpresa(elemento) {
        		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarEmpresa?OBJ_NAME='
        				+ elemento.id + '&OBJ_VALUE=' + elemento.value
        				+ '&OBJ_HIDDEN=idEmpresa';
        		getDataLookup(elemento, url, 'Empresa', 'TABLE');
        	}

        </script>


<s:form namespace="/app/comercial" action="manterPermuta!gravar.action" theme="simple">

<s:hidden name="entidade.idPermuta" />
<div class="divFiltroPaiTop">Permuta</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados da permuta</div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Empresa:</p>
						<s:textfield onblur="getEmpresa(this)" name="entidade.empresaHotel.empresaRedeEJB.nomeFantasia" size="40" maxlength="50" id="empresa" /> 
						<s:hidden name="entidade.empresaHotel.idEmpresa" id="idEmpresa" />
		              </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Descrição:</p>
                        	<s:textfield maxlength="40"  name="entidade.descricao"  id="entidade.descricao" size="40" onblur="toUpperCase(this)" />
                    </div>
                </div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Data início:</p>

<s:textfield cssClass="dp" id="dataIni" name="entidade.dataInicio" size="15" onblur="dataValida(this)" maxlength="10" onkeypress="mascara(this,data)" /> 
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Data fim:</p>

<s:textfield cssClass="dp" id="dataFim" name="entidade.dataFim" size="15" onblur="dataValida(this)" maxlength="10" onkeypress="mascara(this,data)" /> 
                    </div>
                </div>
      
      
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Qtde diária:</p>
                        	<s:textfield maxlength="4"  name="entidade.qtdDiaria" onkeypress="mascara(this, numeros)"   size="15" />
                    </div>
                </div>
      
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:500px;" ><p style="width:100px;">Valor diária:</p>
                        	<s:textfield maxlength="9"  name="entidade.valorDiaria" onkeypress="mascara(this, moeda)" size="15" />
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