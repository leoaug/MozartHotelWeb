<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@ taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags" %>


<script>
    function init(){

    }
    
    
    function novaReserva(){
        vForm = document.forms[0];
        
		<s:if test="%{origemCrs}">
	        vForm.action = '<s:url action="manter!preparaManterCRS.action" namespace="/app/bloqueio" />';
        </s:if>
        <s:else>
        	vForm.action = '<s:url action="manter!preparaManter.action" namespace="/app/bloqueio" />';
        </s:else>
        submitForm(vForm);
    }
    
    function novoBloqueio(){
        vForm = document.forms[0];
        
		<s:if test="%{origemCrs}">
	        vForm.action = '<s:url action="manter!preparaManterCRSBloqueio.action" namespace="/app/bloqueio" />';
        </s:if>
        <s:else>
        	vForm.action = '<s:url action="manter!preparaManterBloqueio.action" namespace="/app/bloqueio" />';
        </s:else>
        submitForm(vForm);
    }
    
    function efetuarPesquisa() {        
        document.forms[0].action = '<s:url action="pesquisar!pesquisarReservas.action" namespace="/app/bloqueio" />';        
        submitForm(document.forms[0]);
    }

    function relatorio() {        
        document.forms[0].action = '<s:url action="relatorio!prepararRelatorio.action" namespace="/app/bloqueio" />';        
        submitForm(document.forms[0]);
    }
    function gestaoBloqueio() {        
        document.forms[0].action = '<s:url action="relatorio!prepararGestaoBloqueio.action" namespace="/app/bloqueio" />';        
        submitForm(document.forms[0]);
    }
    
    function setaDataEntradaSeNTiverSetada() {
    
        frontOffice = document.getElementById('controlaData').value;
        if (document.getElementById('filtro.dataEntrada.tipoIntervalo').selectedIndex==0) {
            document.getElementById('filtro.dataEntrada.tipoIntervalo').selectedIndex = 1;
            document.getElementById('spandataEntrada1').style.visibility='visible';
            document.getElementById('spandataEntrada2').style.visibility='visible';
            document.getElementById('filtro.dataEntrada.valorInicial').value = frontOffice;
            document.getElementById('filtro.dataEntrada.valorFinal').value = frontOffice;            
        }                
    }
    
    function alterarReserva(){
        document.forms[0].action = '<s:url namespace="/app/bloqueio" action="manter" method="alterarReserva" />';        
        submitForm(document.forms[0]);
    }


    function excluirReserva(){
		if (document.getElementById('idReserva').value == ''){
			alerta("O campo 'Reserva' é obrigatório.");	
			return false;
		}

        
    	if (confirm('Deseja cancelar a reserva '+ document.getElementById('idReserva').value.split(',')[0] + ' e todos os seus apartamentos?')){
            vForm = document.forms[0];
            vForm.action = '<s:url action="pesquisar!excluirReserva.action" namespace="/app/bloqueio" />';
            submitForm(vForm);
        }
     }


	function confirmarReserva(){

		if (document.getElementById('idReserva').value == ''){
			alerta("O campo 'Reserva' é obrigatório.");	
			return false;
		}
		
        vForm = document.forms[0];
        vForm.action = '<s:url action="pesquisar!confirmarReserva.action" namespace="/app/bloqueio" />';
        submitForm(vForm);
	}


	function destravarReserva(){
		if (document.getElementById('idReserva').value == ''){
			alerta("O campo 'Reserva' é obrigatório.");	
			return false;
		}
		
        vForm = document.forms[0];
        vForm.action = '<s:url action="pesquisar!destravarReserva.action" namespace="/app/bloqueio" />';
        submitForm(vForm);

	}
    
    function chart(){
         vForm = document.forms[0];
         vForm.action = '<s:url action="manterMapa!prepararPesquisaMapa.action" namespace="/app/bloqueio" />';
         submitForm(vForm);
     }


    function enviarReservaPorEmail(){
        vForm = document.forms[0];
        vForm.action = '<s:url action="enviarEmail!prepararEnviarReservaPorEmail.action" namespace="/app/bloqueio" />';
        submitForm(vForm);
    }

    function enviarReservaApartamentoPorEmail(){
        vForm = document.forms[0];
        vForm.action = '<s:url action="enviarEmail!prepararEnviarReservaApartamentoPorEmail.action" namespace="/app/bloqueio" />';
        submitForm(vForm);
    }


    function voltarCRS(){
        vForm = document.forms[0];
        vForm.action = '<s:url action="pesquisarCRS.action" namespace="/app/crs" />';
        submitForm(vForm);
    }
</script>




<script>
currentMenu = "menu";
with(milonic=new menuname("menu")){
margin=3;
style=contextStyle;
top="offset=2";
aI("image=imagens/btnAlterar.png;text=Alterar;url=javascript:alterarReserva();");
aI("image=imagens/btnImprimir.png;text=Impressão/Confirmação da reserva via e-mail;url=javascript:enviarReservaPorEmail();");
aI("image=imagens/btnImprimir.png;text=Impressão/Confirmação da reserva por Apartamento via e-mail;url=javascript:enviarReservaApartamentoPorEmail();");
aI("image=imagens/iconic/png/check-4x.png;text=Confirmar reserva;url=javascript:confirmarReserva();");
aI("image=imagens/btnCancelar.png;text=Cancelar reserva;url=javascript:excluirReserva();");
aI("image=imagens/iconic/png/lock-unlocked-4x.png;text=Destravar reserva;url=javascript:destravarReserva();");
drawMenus(); 
} 
</script>

 <s:form action="pesquisar!pesquisar.action" namespace="/app/bloqueio" theme="simple" >    
 
 
 	<s:hidden id="idHotelCRS" name="idHotelCRS" value="%{#session.CONTROLA_DATA_SESSION.idHotel}" />
 	<s:hidden id="idTipoAptoCRS" name="idTipoAptoCRS" />
	<s:hidden id="origemCrs" name="origemCrs" />
    <input type="hidden" id="controlaData" value='<s:property value="#session.CONTROLA_DATA_SESSION.frontOffice"/>'/>    
	<s:hidden name="reservaVO.gracIdReservaIdReservaApartamento" id="idReserva"></s:hidden>    
    <div class="divFiltroPaiTop">Pesquisa de Bloqueio</div>    
    <div id="divFiltroPai" class="divFiltroPai">
        <div id="divFiltro" class="divFiltro"  >
            <duques:filtro tableName="BLOQUEIO_WEB" titulo="" />
        </div>
    </div>
    
    
    
    <div id="divMeio" class="divMeio">
        <div id="divOutros" class="divOutros" style="width: 35%;">
               <ul style="width: 90%; padding:0px; margin: 0px; list-style: none; font-size: 8pt; ">
				<li style="font-size: 8pt; float:left; padding-right:5px; width:140px;"><img src="imagens/imgLegAmarelo.png" width="10px" height="10px" />&nbsp;No show</li>
				<li style="font-size: 8pt; float:left; padding-right:5px; "><img src="imagens/imgLegVermelho.png" width="10px" height="10px" />&nbsp;Reserva não confirmada</li>
				<li style="font-size: 8pt; float:left; padding-right:5px;"><img src="imagens/imgLegAzulClaro.png" width="10px" height="10px" />&nbsp;Reserva com check-in</li>
				<li style="font-size: 8pt; float:left; padding-right:5px;"><img src="imagens/imgLegCinza.png" width="10px" height="10px" />&nbsp;Reserva cancelada</li>
				<li style="font-size: 8pt; float:left; padding-right:5px;"><img src="imagens/imgLegOlive.png" width="10px" height="10px" />&nbsp;Reserva com check-out</li>
		</ul>
        </div>
        
        <div id="divBotaoReserva" class="divBotao">
            <duques:botao label="Pesquisar" imagem="imagens/iconic/png/magnifying-glass-3x.png" onClick="efetuarPesquisa();" />
            <duques:botao label="Novo" imagem="imagens/iconic/png/plus-3x.png" onClick="novoBloqueio();" />
            <duques:botao label="Gestão" imagem="imagens/iconic/png/imgChartReserva-4x.png" onClick="gestaoBloqueio();" style="width=112px;" />
	     	<s:if test="%{origemCrs}">
	        	<duques:botao label="CRS" imagem="imagens/iconMozart.png" onClick="voltarCRS();" />
            </s:if>
        </div>
    </div>
    

    <duques:grid titulo="Reserva" 
    			condicao="gracIdApagada;eq;S;corCinza#gracConfirmada;eq;N;corVermelho#gracCheckout;eq;S;corLaranja#gracCheckinSimNao;eq;Sim;corAzul#gracNoshow;eq;Sim;corAmarelo#" 
    			colecao="listaPesquisaReserva" current="obj" idAlteracao="idReserva" idAlteracaoValue="gracIdReservaIdReservaApartamento" 
    			urlRetorno="pages/modulo/reserva/bloqueio/pesquisa.jsp">
    			
        <duques:column labelProperty="Num Reserva" orderBy="gracIdReserva" propertyValue="gracIdReserva" style="text-align:right;width:115px"/>
        <duques:column labelProperty="Empresa" propertyValue="gracNomeEmpresa" style="text-align:left;width:350px"/>
		<duques:column labelProperty="Hóspede" orderBy="gracNomeHospede" propertyValue="gracNomeHospede" style="text-align:left;width:320px"/>
        <duques:column labelProperty="Data Entrada" orderBy="gracDataEntrada" propertyValue="gracDataEntrada" format="dd/MM/yyyy" style="text-align:center;width:120px"/>
		<duques:column labelProperty="Data saída" orderBy="gracDataSaida" propertyValue="gracDataSaida" format="dd/MM/yyyy" style="text-align:center;width:120px"/>
        <duques:column labelProperty="Apto" propertyValue="gracCaracteristica" style="text-align:right;width:100px;"/>  
        <duques:column labelProperty="Tipo Apto" propertyValue="gracFantasia" style="text-align:left;width:100px;"/>
        <duques:column labelProperty="Tipo Hóspede" orderBy="gracTipoHospede" propertyValue="gracTipoHospede" style="text-align:left;width:220px"/>  
        <duques:column labelProperty="Num Bloqueio"  propertyValue="gracIdReservaBloqueio" orderBy="gracIdReservaBloqueio" style="text-align:right;width:120px"/>
        <duques:column labelProperty="Data reserva" orderBy="gracDataReserva" propertyValue="gracDataReserva" format="dd/MM/yyyy" style="text-align:center;width:120px"/>             
        <duques:column labelProperty="Contato" propertyValue="gracContato" orderBy="gracContato" style="width:160px;text-align:left;"  />  
        <duques:column labelProperty="Qtde Apto" propertyValue="gracQtdeApartamento"  style="text-align:right;width:100px"/>              
        <duques:column labelProperty="PAX" propertyValue="gracQtdePax" orderBy="gracQtdePax" style="text-align:right;width:100px" />  
        <duques:column labelProperty="Pensão" propertyValue="gracTipoPensao" style="text-align:left;width:120px" />  
        <duques:column labelProperty="Web" propertyValue="gracCampoWeb" style="text-align:left;width:120px" />  
        <duques:column labelProperty="Central Reserva" propertyValue="gracNomeCentralReservas" style="text-align:left;width:150px" />
        <duques:column labelProperty="Grupo" propertyValue="gracNomeGrupo" style="text-align:left;width:100px" />
        <duques:column labelProperty="Observação" propertyValue="gracObservacao" style="text-align:left;width:700px" />
        <duques:column labelProperty="Unidade" propertyValue="gracSigla"  orderBy="gracSigla" style="text-align:left;width:120px"/>                
    </duques:grid>
                    
</s:form>