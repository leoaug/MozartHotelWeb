package com.mozart.web.actions.crs;

import java.util.List;

import com.mozart.model.delegate.CrsDelegate;
import com.mozart.model.delegate.UsuarioDelegate;
import com.mozart.model.ejb.entity.CentralReservaEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CrsVO;
import com.mozart.web.actions.BaseAction;

public class CRSAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4181218424838245214L;
	
	private CrsVO filtroCRS;
	
	private Long idHotelCRS;
	
	public CRSAction(){
		
	}
	
	public String prepararPesquisa() throws MozartSessionException{
		
		request.getSession().removeAttribute("listaPesquisa");
		if(MozartUtil.isNull(filtroCRS) || MozartUtil.isNull(filtroCRS.getIdHotel())){
			filtroCRS = new CrsVO();
			filtroCRS.setIdHotel( getIdHoteis()[0]);
		}
		else{
			HotelEJB hotel = new HotelEJB();
			hotel.setIdHotel(filtroCRS.getIdHotel());
			List<HotelEJB> lista = ((CentralReservaEJB) this.request.getSession()
					.getAttribute("CRS_SESSION_NAME")).getHoteisAtivos();
			if(lista.contains(hotel)){
				hotel = (HotelEJB) lista.get(lista.indexOf(hotel));
			}
			this.request.getSession().setAttribute("HOTEL_SESSION", hotel);
			this.request.getSession().setAttribute("imagemHotel",
					hotel.getEnderecoLogotipo());
			this.request.getSession().setAttribute("nomeHotel",
					hotel.getNomeFantasia());
	
			ControlaDataEJB controladata = UsuarioDelegate.instance()
					.obterControlaData(hotel.getIdHotel());
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION",
					controladata);
		}
		ControlaDataEJB controlaDataEJB = getControlaData();
		filtroCRS.setDataEntrada( controlaDataEJB.getFrontOffice() );
		filtroCRS.setDataSaida( MozartUtil.incrementarDia( filtroCRS.getDataEntrada() ) );

		return SUCESSO_FORWARD;
	}
	

	public String pesquisar(){
		info("Pesquisando CRS");
		try{
			request.getSession().removeAttribute("listaPesquisa");
			filtroCRS.setIdCrs( getCentralReservaEJB().getIdCentralReservas() );
			List<HotelEJB> listaHotel = CrsDelegate.instance().pesquisarHotel(filtroCRS);
			request.getSession().setAttribute("listaPesquisa", listaHotel);
			if (MozartUtil.isNull( listaHotel )){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			return SUCESSO_FORWARD;
		}catch(Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			return SUCESSO_FORWARD;
		}
	}



	

	public Long getIdHotelCRS() {
		return idHotelCRS;
	}

	public void setIdHotelCRS(Long idHotelCRS) {
		this.idHotelCRS = idHotelCRS;
	}

	public CrsVO getFiltroCRS() {
		return filtroCRS;
	}

	public void setFiltroCRS(CrsVO filtroCRS) {
		this.filtroCRS = filtroCRS;
	}

}
