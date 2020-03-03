package com.mozart.web.actions.rede;

import java.util.List;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.MoedaEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.MoedaVO;
import com.mozart.web.actions.BaseAction;

public class MoedaAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private MoedaVO filtro;
	private MoedaEJB entidade;
	

	public MoedaAction(){
		filtro = new MoedaVO(); 
		entidade = new MoedaEJB();
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
			entidade=(MoedaEJB) CheckinDelegate.instance().obter(MoedaEJB.class, entidade.getIdMoeda());
			
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarMoeda() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			if (MozartUtil.isNull(entidade.getIdMoeda())){
				CheckinDelegate.instance().incluir(entidade);
				} 
			else {
			
				CheckinDelegate.instance().alterar(entidade);
		
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new MoedaEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis( getIdHoteis() );
			List<MoedaVO> lista = RedeDelegate.instance().pesquisarMoeda(filtro);
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


	public MoedaVO getFiltro() {
		return filtro;
	}

		
	public void setFiltro(MoedaVO filtro) {
		this.filtro = filtro;
	}


	public MoedaEJB getEntidade() {
		return entidade;
	}


	public void setEntidade(MoedaEJB entidade) {
		this.entidade = entidade;
	}


}