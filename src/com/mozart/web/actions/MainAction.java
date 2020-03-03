package com.mozart.web.actions;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.codec.binary.Base64;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.PdvDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.delegate.TelefoniaDelegate;
import com.mozart.model.delegate.UsuarioDelegate;
import com.mozart.model.ejb.entity.ApartamentoEJB;
import com.mozart.model.ejb.entity.CheckinEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.MensagemWebUsuarioEJB;
import com.mozart.model.ejb.entity.MensagemWebUsuarioEJBPK;
import com.mozart.model.ejb.entity.PartnerDominioEJB;
import com.mozart.model.ejb.entity.UsuarioSessionEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.util.MozartConstantesWeb;

public class MainAction extends BaseAction{

    /**
	 * 
	 */
	private static final long serialVersionUID = 4070417881703411521L;
	private String idHotelCorrente;
	private String arquivoTelefonia;
	private String podeFechar;
	private String erroGravacao;
	private Long idMensagem;
	private String abrirMensagem;
	private String respostaMensagem;
	private String imgBase;
	
	
    public MainAction() {
    }
    
    public String prepararMensagem(){
    	abrirMensagem = "S";
    	return SUCESSO_FORWARD;
    }
    
    public String lerMensagem(){
    	
        warn("Marcando mensagem como lida:" + idMensagem);
        try {
        	
        	MensagemWebUsuarioEJB mensagem = new MensagemWebUsuarioEJB();
        	mensagem.setUsuario( getUserSession().getUsuarioEJB() );
        	mensagem.setId( new MensagemWebUsuarioEJBPK( idMensagem, getUserSession().getUsuarioEJB().getIdUsuario() ) );
        	mensagem.setDataResposta( new Timestamp(new Date().getTime()));
        	mensagem.setUsuarioEJB( null );
        	mensagem.setResposta( respostaMensagem );
        	CheckinDelegate.instance().alterar(mensagem);
        	
        	 /*Consulta as mensagens do usuário*/
            List<MensagemWebUsuarioEJB> mensagens = SistemaDelegate.instance().pesquisarMensagens(getUserSession().getUsuarioEJB());
            request.getSession().setAttribute(MozartConstantesWeb.LISTA_MENSAGEM, mensagens);
            request.getSession().setAttribute(MozartConstantesWeb.POSSUI_MENSAGEM_URGENTE, "N");
            for (MensagemWebUsuarioEJB msg: mensagens){
            	if (new Long(3).equals( msg.getMensagemWeb().getNivel())){
            		request.getSession().setAttribute(MozartConstantesWeb.POSSUI_MENSAGEM_URGENTE, "S");
            		break;
            	}
            }

            /*Fim consulta as mensagens do usuário*/

            // so abrir se ainda existir mensagem
            if (MozartUtil.isNull( mensagens )){
            	abrirMensagem = "N";
            }else{
            	abrirMensagem = "S";	
            }
            
         }
         catch (Exception e) {
             error( e.getMessage() );
             addMensagemErro(MSG_ERRO);
         }
         return SUCESSO_FORWARD;
    	
    }
    
    
    public String preparar(){
        warn("Preparando main.");
        //verifica se tem checkin na sessao travando o apto
         try {
             CheckinEJB checkinCorrente = (CheckinEJB)request.getSession().getAttribute("checkinCorrente");
             request.getSession().removeAttribute("checkinCorrente");
             if ( !isNull(checkinCorrente) && !isNull(checkinCorrente.getApartamentoEJB())&& "S".equals( checkinCorrente.getApartamentoEJB().getCheckout())){
            	ApartamentoEJB apto =  (ApartamentoEJB)CheckinDelegate.instance().obter(ApartamentoEJB.class, checkinCorrente.getApartamentoEJB().getIdApartamento());
                apto.setCheckout("N");
                apto.setUsuario( getUserSession().getUsuarioEJB() );
                apto = (ApartamentoEJB)CheckinDelegate.instance().alterar (apto);
                checkinCorrente.setApartamentoEJB( apto );
             }
             
             List<MensagemWebUsuarioEJB> mensagens = SistemaDelegate.instance().pesquisarMensagens(getUserSession().getUsuarioEJB());
             request.getSession().setAttribute(MozartConstantesWeb.LISTA_MENSAGEM, mensagens);
             request.getSession().setAttribute(MozartConstantesWeb.POSSUI_MENSAGEM_URGENTE, "N");
             for (MensagemWebUsuarioEJB msg: mensagens){
             	if (new Long(3).equals( msg.getMensagemWeb().getNivel())){
             		request.getSession().setAttribute(MozartConstantesWeb.POSSUI_MENSAGEM_URGENTE, "S");
             		break;
             	}
             }

            String url = request.getServerName();
            if(url.contains("localhost"))
            { 
            	url = "dev1.mozart.com.br";
            }
            
            PartnerDominioEJB partner = PdvDelegate.instance().getDesignHotel(url);
 			
 			if(partner != null){
 				String logoStr = new String(Base64.encodeBase64(partner.getLogotipo()));
 				imgBase = logoStr;
 				request.getSession().setAttribute( MozartConstantesWeb.IMG_LOGO_MOZART, imgBase);
 			}
         }
         catch (MozartSessionException e) {
             error( e.getMessage() );
         }
        return SUCESSO_FORWARD;
    }
    
    
    public String selecionarHotel(){
        
        try{
        UsuarioSessionEJB sessao = getUserSession();
        Integer idHotel = new Integer((String)idHotelCorrente);
        HotelEJB hotel = sessao.getUsuarioEJB().getRedeHotelEJB().getHoteis().get( idHotel );
        Long idProgramaHotel = hotel.getIdPrograma();
        Long idProgramaRede = hotel.getIdPrograma() + 1;
        
        List<Long> idProgramaList = new ArrayList<Long>();
        idProgramaList.add(idProgramaHotel);
        idProgramaList.add(idProgramaRede);
        if(sessao.getUsuarioEJB().getIdUsuario() == 2)
        	idProgramaList.add(3L);
       
        info("Selcionando hotel: " + hotel.getIdHotel() );
        
            request.getSession().setAttribute( MozartConstantesWeb.HOTEL_SESSION, hotel);
            request.getSession().setAttribute( MozartConstantesWeb.ID_PROGRAMA_LIST, idProgramaList);
            
            HotelEJB hotelRestaurante = PdvDelegate.instance().getHotelPorRestaurante(hotel.getIdHotel());
            
            request.getSession().setAttribute( MozartConstantesWeb.HOTEL_RESTAURANTE_SESSION, hotelRestaurante);
            
            ControlaDataEJB controladata = UsuarioDelegate.instance().obterControlaData( hotel.getIdHotel() );
            request.getSession().setAttribute( MozartConstantesWeb.CONTROLA_DATA_SESSION, controladata);
            
        request.getSession().setAttribute( MozartConstantesWeb.HOTEL_SESSION_IMG, hotel.getEnderecoLogotipo());
            request.getSession().setAttribute( MozartConstantesWeb.HOTEL_SESSION_NAME, hotel.getNomeFantasia());
        
        }catch(Exception ex){
        error(ex.getMessage());
        
        }
        return SUCESSO_FORWARD;
    }

    public String gravarArquivo(){
        
        try{
        	info("Realizando leitura de arquivo: " + arquivoTelefonia );	

        	if (!MozartUtil.isNull(arquivoTelefonia)){
            	HotelEJB hotel = getHotelCorrente();
            	hotel.setUsuario( getUserSession().getUsuarioEJB() );
        		String[] linhas = arquivoTelefonia.split("#");
        		if (linhas.length > 0){
        			TelefoniaDelegate.instance().gravarLancamentosTelefonia(hotel, linhas);
        		}
        	}
        
        
        }catch(Exception ex){
        	addMensagemErro( MSG_ERRO );
        	error(ex.getMessage());
        	erroGravacao = "sim";
        }finally{
        	podeFechar = "sim";
        }
        return SUCESSO_FORWARD;
    }

    public void setIdHotelCorrente(String idHotel) {
        this.idHotelCorrente = idHotel;
    }

    public String getIdHotelCorrente() {
        return idHotelCorrente;
    }


	public String getArquivoTelefonia() {
		return arquivoTelefonia;
	}


	public void setArquivoTelefonia(String arquivoTelefonia) {
		this.arquivoTelefonia = arquivoTelefonia;
	}


	public String getPodeFechar() {
		return podeFechar;
	}


	public void setPodeFechar(String podeFechar) {
		this.podeFechar = podeFechar;
	}


	public String getErroGravacao() {
		return erroGravacao;
	}


	public void setErroGravacao(String erroGravacao) {
		this.erroGravacao = erroGravacao;
	}


	public Long getIdMensagem() {
		return idMensagem;
	}


	public void setIdMensagem(Long idMensagem) {
		this.idMensagem = idMensagem;
	}

	public String getAbrirMensagem() {
		return abrirMensagem;
	}

	public void setAbrirMensagem(String abrirMensagem) {
		this.abrirMensagem = abrirMensagem;
	}

	public String getRespostaMensagem() {
		return respostaMensagem;
	}

	public void setRespostaMensagem(String respostaMensagem) {
		this.respostaMensagem = respostaMensagem;
	}

	public String getImgBase() {
		return imgBase;
	}

	public void setImgBase(String imgBase) {
		this.imgBase = imgBase;
	}
}
