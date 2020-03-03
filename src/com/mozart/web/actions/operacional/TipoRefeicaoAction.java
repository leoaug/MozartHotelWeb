package com.mozart.web.actions.operacional;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.TipoRefeicaoEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;


public class TipoRefeicaoAction extends BaseAction{

	/**
	 * 
	 */

	private static final long serialVersionUID = 1L;

	
	private TipoRefeicaoEJB entidade;
			

	public TipoRefeicaoAction (){
		
		entidade = new TipoRefeicaoEJB();
		
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
		
			entidade=(TipoRefeicaoEJB) CheckinDelegate.instance().obter(TipoRefeicaoEJB.class, entidade.getIdTipoRefeicao());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarTipoRefeicao() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			
			if (MozartUtil.isNull(entidade.getIdTipoRefeicao())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new TipoRefeicaoEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
		
	public String pesquisar(){
		
		try{
			TipoRefeicaoEJB filtro = new TipoRefeicaoEJB();
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			java.util.List<TipoRefeicaoEJB> lista = OperacionalDelegate.instance().pesquisarTipoRefeicao(filtro);
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

	public TipoRefeicaoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(TipoRefeicaoEJB entidade) {
		this.entidade = entidade;
	}
	
	
	

}