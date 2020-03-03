package com.mozart.web.actions.compras;

import java.util.List;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComprasDelegate;
import com.mozart.model.ejb.entity.FornecedorGrupoEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;


public class FornecedorGrupoAction extends BaseAction{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	
		private FornecedorGrupoEJB entidade;
		
		
	
	public FornecedorGrupoAction (){
		
		
		entidade = new FornecedorGrupoEJB();
				
	}
	
	
	
		
	public String prepararInclusao(){
		
		entidade = new FornecedorGrupoEJB();
		
		
		return SUCESSO_FORWARD;
		
	}
	
	
	public String prepararAlteracao()  {
		
		try { 
			
			entidade=(FornecedorGrupoEJB) CheckinDelegate.instance().obter(FornecedorGrupoEJB.class, entidade.getIdFornecedorGrupo());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	
	
	public String gravar() {
		try { 
			
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			if (MozartUtil.isNull(entidade.getIdFornecedorGrupo())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new FornecedorGrupoEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	
	public String pesquisar(){
		
		try{
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			List<FornecedorGrupoEJB> lista = ComprasDelegate.instance().pesquisarFornecedorGrupo(entidade);
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




	public FornecedorGrupoEJB getEntidade() {
		return entidade;
	}




	public void setEntidade(FornecedorGrupoEJB entidade) {
		this.entidade = entidade;
	}
	

	
	
	
	
	
	
}