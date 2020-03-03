var flgShowPopup = "true";
var host = "";

function submitForm( form ){
	if (form != null){
	    loading();
	    form.submit();
	}
}

function desabilitaLoadingBotao(){
    flgShowPopup = "false";
}
function habilitaLoadingBotao(){
    flgShowPopup = "true";
}
function showModal(div, he, wi){
	killModal();
    if (div.indexOf('#') == 0){
        $(div).modal({close: false});
    }else{
        if ($.modal != null){
        	$.modal(div);
        }
    }
}

function alerta(mensagem){

    divAlerta = "<div id=\"divMsgSucesso\" class=\"divMsgSucesso\" style='position:absolute; top:43%; left:40%; margin-top:0;margin-left:0;'>" + 
                "<h1>Mensagem:</h1>" + 
                "<img src=\"imagens/iconic/png/check-2x.png\" />" +
                "<label>"+mensagem+"</label>" + 
                "<br clear=\"all\"/>" + 
                "<input type=\"button\" value=\"Fechar\" onclick=\"$('div.divMsgSucesso').remove();\" />" + 
                "</div>";
                
    $(document.body).append(divAlerta);
    //showModal ("#divMsgSucesso", 100, 400);
}



function showPopupPadrao(url, w, h){
  win = window.open(url,"PopUp", ',status=yes,resizable=no,location=no,scrollbars=no,width='+w+',height='+h+', left=200, top=50');
}

function showPopupMedio(url){
  win = showPopupPadrao(url, "600", "400");
}

function showPopupGrande(url){
  win = showPopupPadrao(url, "980", "640");
}



function cancelarOperacao(host){
    window.location.href = host+'app/main!preparar.action';
}

function loadingTelefonia(){

    var divLoading = "<div id=\"divLoading\" style=\"height:50px; width:310px;\"class=\"divLoading\">" +
		"<img src=\"imagens/btnTelefonia.png\" width=\"30px\" height=\"30px\" /><p>Lançando a telefonia, por favor aguarde.</p></div>";

  showModal (divLoading);   
	
}

function loading(){

	var divLoading = "<div id=\"divLoading\" style=\"height:50px; width:310px;\"class=\"divLoading\"><img src=\"imagens/loading.gif\" width=\"30px\" height=\"30px\" /><p>Carregando, por favor aguarde.</p></div>";
	showModal (divLoading);   
}

function loadingPesquisa(){
	loading();   
}   

function killLoading(){

	if ($.modal!=null){
	     $.modal.close();
	}
}


function killModal(){

 if ($.modal!=null){
                        $.modal.close();
                        //$.modal = null;;
      }
}

$(document).ready(

        

	function()
	{
        
               $(window).unload( function () {
                    loading();                    
               } );

               $(window).load( function () { 
                       killModal();
               } );

                
                $("img.imgBotao").mouseout(function() { 
                        $(this).css('border','');
                        $(this).css('background-color','');
                        return false;
                } );

                $("img.imgBotao").mouseover(function() { 
                        $(this).css('background-color','rgb(165,231,255)');
                        $(this).css('border','1px solid rgb(0,173,255)');
                        return false;
                } );
                
        

		// Usado nas telas de pesquisas
                $('img.divHoteisMenuFiltro').click(function(){
                                var targetContent = $('#divHoteisCorpo');
                                if (targetContent.css('display') == 'none') {
                                    targetContent.css('display','block');
                                    targetContent.SlideInLeft("slow");
                                } else {
                                    targetContent.css('display','none');
                                    targetContent.SlideOutLeft("slow");
                                }
                               return false;
                    }
		);
                
                 $('img.imgLinha').click(function(){
                        if ($('#divLinhaCadastroPrincipal'+this.id).css('display')=='none' ){
                                    this.src   = "imagens/menos.png"; 
                                    this.title = "Ocultar dados da reserva apartamento.";
                                    $('#divLinhaCadastroPrincipal'+this.id).css("display","block");
                        }else{
                                    this.src   = "imagens/mais.png"; 
                                    this.title = "Visualizar dados da reserva apartamento.";
                                    $('#divLinhaCadastroPrincipal'+this.id).css("display","none");
                        }
                        return false;
                    }
                );
                
                $('img.imgDispoGroup').click(function(){
                               if ($('#divBarDetalhe'+this.id).css('display')=='none' ){
                                    $('#divBarDetalhe'+this.id).slideDown("slow");
                                     this.src = "imagens/menos.png"; 
                                }else{
                                    $('#divBarDetalhe'+this.id).slideUp("slow");
                                     this.src = "imagens/mais.png"; 
                                }
                               return false;
                    }
		);
                $('img.imgOcupacaoGroup').click(function(){
                               if ($('#divOcupacaoDetalhe'+this.id).css('display')=='none' ){
                                    $('#divOcupacaoDetalhe'+this.id).slideDown("slow");
                                     this.src = "imagens/menos.png"; 
                                }else{
                                    $('#divOcupacaoDetalhe'+this.id).slideUp("slow");
                                     this.src = "imagens/mais.png"; 
                                }
                               return false;
                    }
		);
                
        $('img.imgBotao').click(function(){
        	loading();        
            return false;
        });
        
        $('img.orderClass').click(function(){
        	loading();        
            return false;
        });
        
        
        
                //fim
	}
);