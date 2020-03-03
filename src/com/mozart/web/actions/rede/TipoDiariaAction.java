package com.mozart.web.actions.rede;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.TipoDiariaEJB;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;


public class TipoDiariaAction extends BaseAction{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private TipoDiariaEJB entidade;
		

	public TipoDiariaAction (){
		
		entidade = new TipoDiariaEJB();
		
	}

	public String prepararInclusao(){
		entidade.setPadrao("N");
		
		return SUCESSO_FORWARD;
		
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() {
		
		try { 
		
			entidade=(TipoDiariaEJB) CheckinDelegate.instance().obter(TipoDiariaEJB.class, entidade.getIdTipoDiaria());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarTipoDiaria() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			
			if (MozartUtil.isNull(entidade.getIdTipoDiaria())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new TipoDiariaEJB();
		} catch (MozartValidateException ex){
			
			addMensagemSucesso(ex.getMessage());
				
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
		
	public String pesquisar(){
		
		try{
			TipoDiariaEJB filtro = new TipoDiariaEJB();
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			java.util.List<TipoDiariaEJB> lista = RedeDelegate.instance().pesquisarTipoDiaria(filtro);
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
	
	public TipoDiariaEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(TipoDiariaEJB entidade) {
		this.entidade = entidade;
	}
}