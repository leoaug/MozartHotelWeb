package com.mozart.web.actions.rede;

import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.PromotorEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.PromotorVO;
import com.mozart.web.actions.BaseAction;

public class PromotorAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	
	private PromotorVO filtro;
	private PromotorEJB entidade;
	

	public PromotorAction (){
		
		filtro = new PromotorVO();
		entidade = new PromotorEJB();
		
	}

	public String prepararInclusao(){
		
		
		return SUCESSO_FORWARD;
		
		
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	
	public String prepararAlteracao() {
		try { 
			entidade=(PromotorEJB) CheckinDelegate.instance().obter(PromotorEJB.class, entidade.getIdPromotor());
			
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
		
	

	public String gravarPromotor() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			
			if (MozartUtil.isNull(entidade.getIdPromotor())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new PromotorEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	
	
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis( getIdHoteis() );
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			List<PromotorVO> lista = RedeDelegate.instance().pesquisarPromotor(filtro);
			if (MozartUtil.isNull(lista)){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			request.getSession().setAttribute(LISTA_PESQUISA, lista);
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}

	
	
	//GETTERS AND SETTERS
	public void setFiltro(PromotorVO filtro) {
		this.filtro = filtro;
	}


	public PromotorVO getFiltro() {
		return filtro;
	}


	public void setEntidade(PromotorEJB entidade) {
		this.entidade = entidade;
	}


	public PromotorEJB getEntidade() {
		return entidade;
	}
}



