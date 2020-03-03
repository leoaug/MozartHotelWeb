package com.mozart.web.actions.operacional;

import java.util.List;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.UnidadeEstoqueEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;


public class UnidadeEstoqueAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	
	private UnidadeEstoqueEJB entidade;
	
	

	public UnidadeEstoqueAction (){
		
		entidade = new UnidadeEstoqueEJB();
	
		

	}
	
	public String prepararInclusao() throws MozartSessionException{
		
		return SUCESSO_FORWARD;
		
	}
	

	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	
	public String prepararAlteracao() {
		
		try { 
			
			entidade=(UnidadeEstoqueEJB) CheckinDelegate.instance().obter(UnidadeEstoqueEJB.class, entidade.getIdUnidadeEstoque());
			
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarUnidadeEstoque() {
		try { 
			
			entidade.setIdHotel(getHotelCorrente().getIdHotel());
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			
			if (MozartUtil.isNull(entidade.getIdUnidadeEstoque())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new UnidadeEstoqueEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	public String pesquisar(){
		
		try{
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			List<UnidadeEstoqueEJB> lista = ( OperacionalDelegate.instance()).pesquisarUnidadeEstoque(entidade);
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

	public UnidadeEstoqueEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(UnidadeEstoqueEJB entidade) {
		this.entidade = entidade;
	}

	
	
	

}