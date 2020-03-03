package com.mozart.web.actions.rede;

import java.util.List;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.SetorPatrimonioEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class SetorPatrimonioAction extends BaseAction{

	/**
	 * 
	 */

	private static final long serialVersionUID = 1L;

	
	private SetorPatrimonioEJB entidade;
	private List<MozartComboWeb> listaPadrao;
		

	public SetorPatrimonioAction (){
		
		entidade = new SetorPatrimonioEJB();
		
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
		
			entidade=(SetorPatrimonioEJB) CheckinDelegate.instance().obter(SetorPatrimonioEJB.class, entidade.getIdSetorPatrimonio());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarSetorPatrimonio() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			
			if (MozartUtil.isNull(entidade.getIdSetorPatrimonio())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new SetorPatrimonioEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
		
	public String pesquisar(){
		
		try{
			SetorPatrimonioEJB filtro = new SetorPatrimonioEJB();
			filtro.setIdHotel(getIdHoteis()[0]);
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			java.util.List<SetorPatrimonioEJB> lista = RedeDelegate.instance().pesquisarSetorPatrimonio(filtro);
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

	public SetorPatrimonioEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(SetorPatrimonioEJB entidade) {
		this.entidade = entidade;
	}

}