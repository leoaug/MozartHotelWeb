package com.mozart.web.actions.sistema;

import java.util.List;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.BancoEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.BancoVO;
import com.mozart.web.actions.BaseAction;

public class BancoAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private BancoVO filtro;
	private BancoEJB entidade;
	

	public BancoAction(){
		filtro = new BancoVO(); 
		entidade = new BancoEJB();
	}
	
	public String prepararInclusao (){
		
		
		return SUCESSO_FORWARD;	
	}
	
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() {
		try { 
			entidade=(BancoEJB) CheckinDelegate.instance().obter(BancoEJB.class, entidade.getIdBanco());
			
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarBanco() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			if (MozartUtil.isNull(entidade.getIdBanco())){
				CheckinDelegate.instance().incluir(entidade);
				} 
			else {
			
				CheckinDelegate.instance().alterar(entidade);
		
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new BancoEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis( getIdHoteis() );
			List<BancoVO> lista = SistemaDelegate.instance().pesquisarBanco (filtro);
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

	public BancoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(BancoVO filtro) {
		this.filtro = filtro;
	}

	public BancoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(BancoEJB entidade) {
		this.entidade = entidade;
	}


	


}