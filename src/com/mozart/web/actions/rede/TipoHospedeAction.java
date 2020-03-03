package com.mozart.web.actions.rede;

import java.util.ArrayList;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.TipoHospedeEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class TipoHospedeAction extends BaseAction{

	/**
	 * 
	 */

	private static final long serialVersionUID = 1L;

	
	private TipoHospedeEJB entidade;
	private List<MozartComboWeb> listaPadrao;
		

	public TipoHospedeAction (){
		
		entidade = new TipoHospedeEJB();
		
	}

	public String prepararInclusao(){
		initCombo();
		return SUCESSO_FORWARD;
		
	}
	
	private void initCombo(){
		
		listaPadrao = new ArrayList<MozartComboWeb>();
        listaPadrao.add(new MozartComboWeb("1","Sim"));
        listaPadrao.add(new MozartComboWeb("0","Não"));
        		
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() {
		
		try { 
			initCombo();
			entidade=(TipoHospedeEJB) CheckinDelegate.instance().obter(TipoHospedeEJB.class, entidade.getIdTipoHospede());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarTipoHospede() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			
			if (MozartUtil.isNull(entidade.getIdTipoHospede())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new TipoHospedeEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			initCombo();
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	
	public String pesquisar(){
		
		try{
			TipoHospedeEJB filtro = new TipoHospedeEJB();
			filtro.setIdHotel(getIdHoteis()[0]);
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			java.util.List<TipoHospedeEJB> lista = RedeDelegate.instance().pesquisarTipoHospede(filtro);
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

	public TipoHospedeEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(TipoHospedeEJB entidade) {
		this.entidade = entidade;
	}

	public List<MozartComboWeb> getListaPadrao() {
		return listaPadrao;
	}

	public void setListaPadrao(List<MozartComboWeb> listaPadrao) {
		this.listaPadrao = listaPadrao;
	}

}