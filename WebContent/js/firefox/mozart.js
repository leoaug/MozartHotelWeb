var cliqueBotao = "false";
function alerta(mensagem){
    $(document.body).append("<div class=\"divAlerta\"><h1>Alerta</h1><img src=\"imagens/exportarPDF.jpg\"/><p>"+mensagem+"</p><br clear='all'/><input onclick='$(\"div.divAlerta\").remove();ativarControle();' type='button' value='Fechar' /></div>");
}

$(document).ready(
        
	function()
	{
               
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
                
                $('#bodyBemVindo').click(function(){
                          if ($('div.divErro')!=null){
                            if ($('div.divErro').css('display')=='block'){
                                $('div.divErro').remove();
                            }
                        }
                }
                );


                /*desenvolver aqui o div de loading...*/
                $("div.divBotaoAcao").click(function() { 
                        if ($("div.divAlerta").css('display')!='block'){
                            loading();
                        }
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
                    }
		);
  
                //fim
                
	}
);