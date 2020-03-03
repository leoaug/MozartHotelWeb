<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	
	function gravar(){
		submitForm(document.forms[0]);
	}

</script>
	
<s:form namespace="/app/sistema"
	action="manterFcp!gravar.action" theme="simple">

	<div class="divFiltroPaiTop">FCP - Fundo de Combate a Pobreza</div>
	<div class="divFiltroPai">
		<div class="divCadastro" style="overflow: auto;">
			<div class="divGrupo" style="height: 100%;">
				<div class="divLinhaCadastro">
					<div class="divItemGrupo" style="width: 210px;">
						<p style="width: 200px;">UF - Estado:</p>
					</div>
					<div class="divItemGrupo" style="width: 210px;">
						<p style="width: 200px;">Alíquota:</p>
					</div>
				</div>
				
				<s:iterator value="#session.estadosNfeSession" status="linha" var="mov">
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width: 800px;">
							<p style="width: 200px;"><s:property value="#mov.descricao"/></p>
							<s:textfield 
								name="valorPreenchido"
								id="estado%{#linha.index}"
								onkeypress="mascara(this, moeda)" 
								size="6" 
								maxlength="5" 
								cssStyle="text-align: right;" 
								value="%{#mov.valor}"/>
						</div>
					</div>
               	</s:iterator>
			</div>
		</div>
		
        <div class="divCadastroBotoes">
             <!--<duques:botao label="Voltar" imagem="imagens/iconic/png/arrow-thick-left-3x.png" onClick="cancelar()" />-->
             <duques:botao label="Gravar" imagem="imagens/iconic/png/check-4x.png" onClick="gravar()" />
        </div>
	</div>
</s:form>