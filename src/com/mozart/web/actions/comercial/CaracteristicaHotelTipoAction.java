package com.mozart.web.actions.comercial;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.ejb.entity.CaracteristicaEJB;
import com.mozart.model.ejb.entity.HotelApartCaracteristicaEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.TipoApartamentoEJB;
import com.mozart.web.actions.BaseAction;

public class CaracteristicaHotelTipoAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4376609961771760840L;

	private List<CaracteristicaEJB> caracteristicaHotelList;
	private List<CaracteristicaEJB> caracteristicaDoHotelList;
	
	private List<CaracteristicaEJB> caracteristicaTipoApartamentoList;
	private List<TipoApartamentoEJB> tipoApartamentoDoHotelList;
	private Long[] idCaracteristicaHotel;
	private String[] idCaracteristicaTipoApartamento;
	
		
	public CaracteristicaHotelTipoAction(){
		caracteristicaHotelList = Collections.emptyList();
		caracteristicaDoHotelList = Collections.emptyList();
		caracteristicaTipoApartamentoList = Collections.emptyList();
		tipoApartamentoDoHotelList = Collections.emptyList();
	}
	
	public String prepararGravacao(){
		
		try{
			caracteristicaHotelList = ComercialDelegate.instance().obterCaracteristicaHotel();
			caracteristicaDoHotelList = ComercialDelegate.instance().obterCaracteristicaDoHotel( getHotelCorrente() );
			caracteristicaTipoApartamentoList = ComercialDelegate.instance().obterCaracteristicaTipoApartamento();
			tipoApartamentoDoHotelList = ComercialDelegate.instance().obterCaracteristicaDoTipoApartamento(getHotelCorrente());
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		
		
		return SUCESSO_FORWARD;
	}
	
	
	public String gravar(){
		
		try{
			
			List<HotelApartCaracteristicaEJB> hotelApartCaracteristicaEJBList = new ArrayList<HotelApartCaracteristicaEJB>();
		
			HotelEJB hotel = getHotelCorrente();
			if (idCaracteristicaHotel != null){
				for (int x=0;x<idCaracteristicaHotel.length;x++){
					HotelApartCaracteristicaEJB nova = new HotelApartCaracteristicaEJB();
					nova.setIdHotel( hotel.getIdHotel() );
					nova.setOrdem(new Long(x+1));
					nova.setIdCaracteristica( idCaracteristicaHotel[x] );
					hotelApartCaracteristicaEJBList.add(nova);
				}
			}

			if (idCaracteristicaTipoApartamento != null){
				for (int x=0;x<idCaracteristicaTipoApartamento.length;x++){
					String[] par = idCaracteristicaTipoApartamento[x].split(";");
					HotelApartCaracteristicaEJB nova = new HotelApartCaracteristicaEJB();
					nova.setIdHotel( hotel.getIdHotel() );
					nova.setOrdem(new Long(x+1));
					nova.setIdTipoApartamento( new Long(par[0]) );
					nova.setIdCaracteristica( new Long(par[1]) );
					hotelApartCaracteristicaEJBList.add(nova);
				}
			}
	
			hotel.setUsuario( getUsuario() );
			ComercialDelegate.instance().gravarCaracteristicaHotelTipoApartamento(hotel, hotelApartCaracteristicaEJBList);
			addMensagemSucesso( MSG_SUCESSO );
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}finally{
			prepararGravacao();
		}
		return SUCESSO_FORWARD;
	}

	
	public List<CaracteristicaEJB> getCaracteristicaHotelList() {
		return caracteristicaHotelList;
	}

	public void setCaracteristicaHotelList(
			List<CaracteristicaEJB> caracteristicaHotelList) {
		this.caracteristicaHotelList = caracteristicaHotelList;
	}

	public List<CaracteristicaEJB> getCaracteristicaDoHotelList() {
		return caracteristicaDoHotelList;
	}

	public void setCaracteristicaDoHotelList(
			List<CaracteristicaEJB> caracteristicaDoHotelList) {
		this.caracteristicaDoHotelList = caracteristicaDoHotelList;
	}

	public Long[] getIdCaracteristicaHotel() {
		return idCaracteristicaHotel;
	}

	public void setIdCaracteristicaHotel(Long[] idCaracteristicaHotel) {
		this.idCaracteristicaHotel = idCaracteristicaHotel;
	}

	public List<CaracteristicaEJB> getCaracteristicaTipoApartamentoList() {
		return caracteristicaTipoApartamentoList;
	}

	public void setCaracteristicaTipoApartamentoList(
			List<CaracteristicaEJB> caracteristicaTipoApartamentoList) {
		this.caracteristicaTipoApartamentoList = caracteristicaTipoApartamentoList;
	}

	public List<TipoApartamentoEJB> getTipoApartamentoDoHotelList() {
		return tipoApartamentoDoHotelList;
	}

	public void setTipoApartamentoDoHotelList(
			List<TipoApartamentoEJB> tipoApartamentoDoHotelList) {
		this.tipoApartamentoDoHotelList = tipoApartamentoDoHotelList;
	}

	public String[] getIdCaracteristicaTipoApartamento() {
		return idCaracteristicaTipoApartamento;
	}

	public void setIdCaracteristicaTipoApartamento(
			String[] idCaracteristicaTipoApartamento) {
		this.idCaracteristicaTipoApartamento = idCaracteristicaTipoApartamento;
	}


	
	
	
}
