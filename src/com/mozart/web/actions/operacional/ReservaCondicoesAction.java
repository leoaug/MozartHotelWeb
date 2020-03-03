package com.mozart.web.actions.operacional;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.ejb.entity.ReservaCondicoesEJB;
import com.mozart.web.actions.BaseAction;
public class ReservaCondicoesAction extends BaseAction{
	/**
	 * 
	 */
	private static final long serialVersionUID = -75928571429384561L;
	
	private ReservaCondicoesEJB entidade;


	public ReservaCondicoesAction(){
		entidade = new ReservaCondicoesEJB();
		
	}
	
	public String prepararManter(){
		try{
			
			entidade=(ReservaCondicoesEJB)CheckinDelegate.instance().obter(ReservaCondicoesEJB.class, getIdHoteis()[0]);
			
			
		}catch(Exception ex){
			error(ex.getMessage());
			entidade = new ReservaCondicoesEJB();
			
		}
		
		
		return SUCESSO_FORWARD;
	}
	
	
	
	public String gravar(){
		try{
						
			
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			if (entidade.getIdHotel() == null){
				entidade.setIdHotel(getHotelCorrente().getIdHotel());
				entidade = (ReservaCondicoesEJB)CheckinDelegate.instance().incluir( entidade );
			}else{
				entidade = (ReservaCondicoesEJB)CheckinDelegate.instance().alterar( entidade );
			}
			getHotelCorrente().setReservaCondicoesEJB( entidade );
			
			addMensagemSucesso(MSG_SUCESSO);
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}
	

	
	
	public ReservaCondicoesEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(ReservaCondicoesEJB entidade) {
		this.entidade = entidade;
	}
	
	
	
}
