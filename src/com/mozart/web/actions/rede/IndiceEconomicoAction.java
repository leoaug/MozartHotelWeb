package com.mozart.web.actions.rede;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.IndiceEconomicoEJB;
import com.mozart.model.ejb.entity.IndiceTipoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;
import java.util.Collections;
import java.util.List;


public class IndiceEconomicoAction extends BaseAction{

	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	private List <IndiceTipoEJB> tipoIndiceList;
	private IndiceEconomicoEJB entidade;
			

	public IndiceEconomicoAction (){
		
		entidade = new IndiceEconomicoEJB();
		tipoIndiceList = Collections.emptyList();
		
	}
	
	private void initCombo() throws MozartSessionException {
		
		tipoIndiceList = RedeDelegate.instance().pesquisarIndiceTipo(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		
		
	}
	
	public String prepararInclusao(){
		
		try {
			initCombo();
		} catch (MozartSessionException e) {
			
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
			
		}
		return SUCESSO_FORWARD;
		
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() {
		
		
		try { 
			initCombo();
			entidade=(IndiceEconomicoEJB) CheckinDelegate.instance().obter(IndiceEconomicoEJB.class, entidade.getIdIndiceEconomico());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarIndiceEconomico() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdHotel(getHotelCorrente().getIdHotel());
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			initCombo();
			
			if (MozartUtil.isNull(entidade.getIdIndiceEconomico())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new IndiceEconomicoEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} 		
		return SUCESSO_FORWARD; 
		
		
	}
		
	public String pesquisar(){
		
		try{
			IndiceEconomicoEJB filtro = new IndiceEconomicoEJB();
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			java.util.List<IndiceEconomicoEJB> lista = RedeDelegate.instance().pesquisarIndiceEconomico(filtro);
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
	
	
	public IndiceEconomicoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(IndiceEconomicoEJB entidade) {
		this.entidade = entidade;
	}

	public List<IndiceTipoEJB> getTipoIndiceList() {
		return tipoIndiceList;
	}

	public void setTipoIndiceList(List<IndiceTipoEJB> tipoIndiceList) {
		this.tipoIndiceList = tipoIndiceList;
	}

}