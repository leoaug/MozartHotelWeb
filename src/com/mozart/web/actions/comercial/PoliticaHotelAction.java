package com.mozart.web.actions.comercial;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.ejb.entity.PoliticaHotelEJB;
import com.mozart.web.actions.BaseAction;
public class PoliticaHotelAction extends BaseAction{
	/**
	 * 
	 */
	private static final long serialVersionUID = -75928571429384561L;
	
	private PoliticaHotelEJB entidade;

	public PoliticaHotelAction(){
		entidade = new PoliticaHotelEJB();
		
	}
	
	public String prepararManter(){
		try{
			
			entidade.setIdHotel(getHotelCorrente().getIdHotel());
			entidade= ComercialDelegate.instance().obterPoliticaHotel(entidade);
			
		}catch(Exception ex){
			error(ex.getMessage());
			entidade = new PoliticaHotelEJB();
			
		}
		
		return SUCESSO_FORWARD;
	}
	
	public String gravar(){
		try{
			entidade.setTipoPagamento("T");
			entidade.setIdHotel(getHotelCorrente().getIdHotel());					
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			if (
				entidade.getIdPoliticaHotel() == null){
				entidade = (PoliticaHotelEJB)CheckinDelegate.instance().incluir( entidade );
			}else{
				entidade = (PoliticaHotelEJB)CheckinDelegate.instance().alterar( entidade );
			}

			
			addMensagemSucesso(MSG_SUCESSO);
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}

	public PoliticaHotelEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(PoliticaHotelEJB entidade) {
		this.entidade = entidade;
	}
}