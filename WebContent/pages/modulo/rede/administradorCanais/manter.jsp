<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">
window.onload = function() {
	
	addPlaceHolder('empresa');
};

function addPlaceHolder(classe) {
	document.getElementById(classe).setAttribute("placeholder",
			"ex.: digite o nome da empresa");
}
           
    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarGDS!prepararPesquisa.action" namespace="/app/rede" />';
        		submitForm(vForm);
            }
            
            
            function gravar(){
                        
                if ($("input[name='entidade.empresaEJB.idEmpresa']").val() == ''){
                    alerta('Campo "Empresa" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.nome']").val() == ''){
                    alerta('Campo "Nome" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.email']").val() == ''){
                    alerta('Campo "E-mail" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.password']").val() == ''){
                    alerta('Campo "Senha" é obrigatório.');
                    return false;
                }
                if ($("input[name='entidade.dataValidade']").val() == ''){
                    alerta('Campo "Data validade" é obrigatório.');
                    return false;
                }

                if ($("input[name='entidade.password']").val() != 
                	$("input[name='confirmacao']").val()){
                    alerta('Campo "Confirmação" é diferente da senha.');
                    return false;
                }

                
                submitForm(document.forms[0]);                
            }

            function getEmpresa(elemento) {
        		url = '${sessionScope.URL_BASE}app/ajax/ajax!selecionarEmpresa?OBJ_NAME='+ elemento.id + '&OBJ_VALUE=' + elemento.value + '&OBJ_HIDDEN=idEmpresa';
        		getDataLookup(elemento, url, 'Empresa', 'TABLE');
        	}

        </script>


<s:form namespace="/app/rede" action="manterGDS!gravar.action" theme="simple">

<s:hidden name="entidade.idGds" />
<div class="divFiltroPaiTop">Administrador de Canais</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:400px;">
                <div class="divGrupoTitulo">Dados do Administrador de canal</div>

                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:400px;" ><p style="width:100px;">Nome Fantasia:</p>
						<s:textfield onblur="getEmpresa(this)" name="entidade.empresaRedeEJB.nomeFantasia" size="40" maxlength="50" id="empresa" /> 
						<s:hidden name="entidade.idEmpresa" id="idEmpresa" />
		              </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:125px;">Código:</p>
						<s:textfield name="entidade.codigo" size="15" maxlength="15" id="codigo" /> 
		              </div>
                    <div class="divItemGrupo" style="width:200px;" ><p style="width:100px;">Ativo:</p>
						<s:select list="#session.LISTA_CONFIRMACAO" listKey="id"
							listValue="value" cssStyle="width:50px;" name="entidade.ativo" />
		              </div>
                </div>
                
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:400px;" ><p style="width:150px;">Comissao:</p>
                        	<s:textfield maxlength="5"  name="entidade.comissao" onkeypress="mascara(this, moeda)" id="entidade.comissao" size="5" onblur="toUpperCase(this)" />%
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:125px;">Valor por Reserva:</p>
                        	<s:textfield maxlength="15"  name="entidade.feeReserva"  id="entidade.feeReserva" size="15" onblur="toUpperCase(this)"  onkeypress="mascara(this, moeda)" />
                    </div>
                    <div class="divItemGrupo" style="width:250px;" ><p style="width:100px;">Valor por Mês:</p>
                        	<s:textfield maxlength="15"  name="entidade.feeMensal"  id="entidade.feeMensal" size="15" onblur="toUpperCase(this)"  onkeypress="mascara(this, moeda)" />
                    </div>
                </div>
                <div class="divLinhaCadastro">
                    <div class="divItemGrupo" style="width:400px;" ><p style="width:150px;">Bloqueio/Disponibilidade:</p>
                        	<s:select list="#session.LISTA_DISP_BLOQUEIO" listKey="id"
							listValue="value" cssStyle="width:200px;" name="entidade.disponibilidadeBloqueio" />
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