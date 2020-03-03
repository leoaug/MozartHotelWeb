package com.mozart.web.actions.rede;

import java.util.List;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.GrupoPratoEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class GrupoPratoAction extends BaseAction{

	/**
	 * 
	 */

	private static final long serialVersionUID = 1L;

	
	private GrupoPratoEJB entidade;
	private List<MozartComboWeb> listaPadrao;
		

	public GrupoPratoAction (){
		
		entidade = new GrupoPratoEJB();
		
	}

	public String prepararInclusao(){
		entidade = new GrupoPratoEJB();
		return SUCESSO_FORWARD;
		
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() {
		
		try { 
		
			entidade=(GrupoPratoEJB) CheckinDelegate.instance().obter(GrupoPratoEJB.class, entidade.getIdGrupoPrato());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarGrupoPrato() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			
			if (MozartUtil.isNull(entidade.getIdGrupoPrato())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new GrupoPratoEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
		
	public String pesquisar(){
		
		try{
			GrupoPratoEJB filtro = new GrupoPratoEJB();
			filtro.setIdHotel(getIdHoteis()[0]);
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			java.util.List<GrupoPratoEJB> lista = RedeDelegate.instance().pesquisarGrupoPrato(filtro);
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
	
	public List<MozartComboWeb> getListaPadrao() {
		return listaPadrao;
	}

	public void setListaPadrao(List<MozartComboWeb> listaPadrao) {
		this.listaPadrao = listaPadrao;
	}

	public GrupoPratoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(GrupoPratoEJB entidade) {
		this.entidade = entidade;
	}

}