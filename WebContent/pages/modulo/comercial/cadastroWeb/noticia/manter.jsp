<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script type="text/javascript">

           $(document).ready(function()	{
				  $('.edit').wysiwyg();
			});
    
            function cancelar(){
            	vForm = document.forms[0];
        		vForm.action = '<s:url action="pesquisarNoticia.action" namespace="/app/comercial" />';
        		submitForm(vForm);
            }
            
            
            function gravar(){
                        
                var qtde = $("input:text[name='titulo'][value='']").length;
				if ( qtde  > 0){
					alerta("Cada campo 'Título' é obrigatório.");
					return false;
				}

				qtde = $(".resumo[value='']").length;
				if ( qtde  > 0){
					alerta("Cada campo 'Resumo' é obrigatório.");
					return false;
				}

           		qtde = $(".edit[value='']").length;
				
				if ( qtde  > 0){
					alerta("Cada campo 'Notícia' é obrigatório.");
					return false;
				}
				
                submitForm(document.forms[0]);                
            }

        </script>


<s:form namespace="/app/comercial" action="manterNoticia!gravar.action" theme="simple">

<s:hidden name="entidade.id.idNoticia" />
<s:hidden name="entidade.data" />

<div class="divFiltroPaiTop">Notícia</div>
<div class="divFiltroPai" >
        <div class="divCadastro" style="overflow:auto;" >
              <div class="divGrupo" style="height:465px;">
                <div class="divGrupoTitulo">Dados</div>
                
				<div class="divGrupoBody" style="height: 95%;">
				
				
					<div class="divLinhaCadastro">
						<div class="divItemGrupo" style="width:300px;" ><p style="width:80px;">Ativo:</p>
							<s:select list="#session.LISTA_CONFIRMACAO"
								listKey="id"
								listValue="value"
								cssStyle="width:100px"
								name="entidade.ativo"
							 />                        	

						</div>
					</div>
					
					<s:iterator value="entidades" status="row" var="obj">
					<input type="hidden" name="idioma" value="<s:property value="idioma.idIdioma" />" />
					<div class="divLinhaCadastro" style="height:200px; width:300px; margin-right:0;">
						<div class="divItemGrupo" style="height:22px; width:300px;" >
							<p style="width:80px;"> <img src='<s:property value="idioma.enderecoImagem" />' title='<s:property value="idioma.descricao" />'/> Título</p>
							<input type="text" name="titulo" maxlength="150" style="width:200px;text-transform:none;" value='<s:property value="titulo" />'/>
						</div>
						<div class="divItemGrupo" style="width:300px; height:98px;">
							<p style="width:80px;">Resumo</p>
							<textarea class="resumo" name="resumo" style="width:200px; height:75px;"><s:property value="resumo" /></textarea>
						</div>
					</div>
					
					<div class="divLinhaCadastro" style="height:200px; width:630px; margin-left:0;">
						<div class="divItemGrupo">
							<textarea class="edit" name="noticia" rows="3" style="width:590px; height:40px;"><s:property value="noticia" /></textarea>
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