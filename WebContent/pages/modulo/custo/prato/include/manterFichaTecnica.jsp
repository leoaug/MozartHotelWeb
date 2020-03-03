<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<jsp:scriptlet>
	String  base = request.getRequestURL().toString().substring(0, request.getRequestURL().toString().indexOf(request.getContextPath())+request.getContextPath().length()+1);
	session.setAttribute("URL_BASE", base);
	response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
	response.setHeader("Cache-Control","no-store, no-cache, must-revalidate");
	response.addHeader("Cache-Control", "post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
</jsp:scriptlet>

<html>
    <head>
    <base href="<%=base%>" /> 
    <%@ include file="/pages/modulo/includes/headPage.jsp" %>
</head>
<script type="text/javascript">

function adicionarItem(){


	if ($('#idItem').val() == ''){
		parent.alerta("O campo 'Item' é obrigatório");
		return false;
	}

	
	if ($('#quantidade').val()==''){
	
		parent.alerta("O campo 'Qtde' é obrigatório");
		return false;
	}
	
	if ($('#vlUnitario').val()==''){
	
		parent.alerta("O campo 'Vl Unit' é obrigatório");
		return false;
	}
	
	
	
    submitForm(document.forms[0]);
    submitForm(document.forms[0]);
}

function excluirItem(idx){
	if (confirm('Confirma a exclusão do item?')){
	    document.forms[0].action = '<s:url namespace="/app/custo" action="include" method="excluirFichaTecnica" />';
	    $('#indice').val( idx );
	    submitForm(document.forms[0]);
	}
}

function obterValorUnitario( valor ){
	loading();
	submitFormAjax('obterValorUnitarioItemFichaTecnica?idItem='+valor,true);
}
function atualizar( valor ){
	killModal();
	$('#vlUnitario').val(valor);
	
}

function killModalPai(){
	parent.killModal();
}

$(function() {

				$("#quantidade").keyup(function() {
                            total = 0.0;
                            unitario = toFloat($('#vlUnitario').val()); 
							qtde 	 = toFloat(this.value); 
                            total = unitario * qtde;
                            $('#vlTotal').val(arredondaFloatDecimal(total).toString().replace(".",",") );
                        }
                );
				
});				
				

</script>
<body>
<div class="divGrupo" style="overflow: auto; margin-top:0px;width:965px; height:98%; border:0px;">
<s:form namespace="/app/custo" action="include!incluirFichaTecnica" theme="simple">

				<s:hidden name="indice" id="indice" />

				<div class="divLinhaCadastro" style="margin-bottom:0px; border: 0px;width:99%; float:left;  height: 20px;">
                    <div class="divItemGrupo" style="width:310px;" ><p style="width:60px;">Item:</p>
						<s:select name="idItem" id="idItem"  onchange="obterValorUnitario(this.value)"
								  cssStyle="width:240px;" 
								  list="itemEstoqueList"
								  headerKey=""
								  headerValue="Selecione"
								  listKey="idItem"
								  listValue="nomeItem" />
		  
                    </div>

                    <div class="divItemGrupo" style="width:150px;" ><p style="width:60px;">Qtde:</p>
						<s:textfield name="quantidade" id="quantidade" onkeypress="mascara(this, quantidadeDecimal)" size="5" maxlength="7" cssStyle="text-align:right;"/>	
                    </div>

                    <div class="divItemGrupo" style="width:180px;" ><p style="width:60px;">Vr Unit:</p>
                    <s:textfield name="vlUnitario" id="vlUnitario" onkeypress="mascara(this, moeda)" size="12" maxlength="10" readonly="true" cssStyle="background-color:silver;text-align:right;" />	
					
                    </div>
					 <div class="divItemGrupo" style="width:160px;" ><p style="width:60px;">Vr Total:</p>
						<s:textfield name="vlTotal" id="vlTotal" onkeypress="mascara(this, moeda)" size="12" maxlength="10" readonly="true" cssStyle="background-color:silver;text-align:right;"/>	
						
                    </div>
                    	<div class="divItemGrupo" style="width:35px;" >
                  		<img width="30px" height="30px" src="imagens/iconic/png/plus-3x.png" title="Adicionar Item" style="margin:0px;" onclick="adicionarItem();"/>
					</div>
				</div>
				
				
					
				
				
            
			<s:set name="valorTotal" value="%{0.0}" />
			<s:iterator value="#session.entidadeSession.fichaTecnicaPratoEJBList" var="obj" status="row" >
            		
					<s:set name="valorTotal" value="%{#valorTotal+#obj.valorTotal}" />
					<div class="divLinhaCadastro" id="divLinha${row.index}" style="margin-bottom:0px; border:0px; width:99%;">
                        <div class="divItemGrupo" style="width:310px;" ><p style="width:100%;"><s:property  value="itemEstoqueEJB.itemRedeEJB.nomeItem" /></p></div>
                        <div class="divItemGrupo" style="width:130px;" ><p style="width:115px;text-align:right;">
                        				<s:property  value="@com.mozart.model.util.MozartUtil@formatDecimal(quantidade)" />
                        				</p></div>
                        <div class="divItemGrupo" style="width:170px;" ><p style="width:100%;text-align:right;">
                        				<s:property  value="@com.mozart.model.util.MozartUtil@formatDecimal(valorUnitario)" />
                        				</p></div>
                        <div class="divItemGrupo" style="width:180px;" ><p style="width:100%;text-align:right;">
                        				<s:property  value="@com.mozart.model.util.MozartUtil@formatDecimal(valorTotal)" />
                        				</p></div>
						<div class="divItemGrupo" style="width:10px;" ></div>
                        <div class="divItemGrupo" style="width:35px;" >
                  			<img width="30px" height="30px" src="imagens/iconic/png/x-3x.png" title="Excluir Item" style="margin:0px;" onclick="excluirItem('${row.index}');"/>
						</div>
                    </div>
                    
            </s:iterator>

                
                
</s:form>                
</div>
</body>

<script>
	//parent.atualizarTotal('<s:property value="%{@com.mozart.model.util.MozartUtil@formatDecimal(#valorTotal)}" />');
	parent.atualizarCusto('<s:property value="%{@com.mozart.model.util.MozartUtil@formatDecimal(#valorTotal,2)}" />');
</script>


</html>