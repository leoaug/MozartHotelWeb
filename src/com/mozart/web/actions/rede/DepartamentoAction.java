package com.mozart.web.actions.rede;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.DepartamentoEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;


public class DepartamentoAction extends BaseAction{

	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	
	private DepartamentoEJB entidade;
			

	public DepartamentoAction (){
		
		entidade = new DepartamentoEJB();
		
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
		
			entidade=(DepartamentoEJB) CheckinDelegate.instance().obter(DepartamentoEJB.class, entidade.getIdDepartamento());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarDepartamento() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			
			if (MozartUtil.isNull(entidade.getIdDepartamento())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new DepartamentoEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
		
	public String pesquisar(){
		
		try{
			DepartamentoEJB filtro = new DepartamentoEJB();
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			java.util.List<DepartamentoEJB> lista = RedeDelegate.instance().pesquisarDepartamento(filtro);
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
	
	
	public DepartamentoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(DepartamentoEJB entidade) {
		this.entidade = entidade;
	}

}