package com.mozart.web.actions.rede;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.HistoricoContabilEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;


public class HistoricoContabilAction extends BaseAction{

	/**
	 * 
	 */

	private static final long serialVersionUID = 1L;

	
	private HistoricoContabilEJB entidade;
			

	public HistoricoContabilAction (){
		
		entidade = new HistoricoContabilEJB();
		
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
		
			entidade=(HistoricoContabilEJB) CheckinDelegate.instance().obter(HistoricoContabilEJB.class, entidade.getIdHistorico());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarHistoricoContabil() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			
			if (MozartUtil.isNull(entidade.getIdHistorico())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new HistoricoContabilEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
		
	public String pesquisar(){
		
		try{
			HistoricoContabilEJB filtro = new HistoricoContabilEJB();
			filtro.setIdHotel(getIdHoteis()[0]);
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			java.util.List<HistoricoContabilEJB> lista = RedeDelegate.instance().pesquisarHistoricoContabil(filtro);
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
	
	
	public HistoricoContabilEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(HistoricoContabilEJB entidade) {
		this.entidade = entidade;
	}

}