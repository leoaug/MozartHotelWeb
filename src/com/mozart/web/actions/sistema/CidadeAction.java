package com.mozart.web.actions.sistema;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.CidadeEJB;
import com.mozart.model.ejb.entity.EstadoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CidadeVO;
import com.mozart.web.actions.BaseAction;
import java.util.Collections;
import java.util.List;


public class CidadeAction extends BaseAction{
	/**
	 * 
	*/
	private static final long serialVersionUID = 1L;

	private List <EstadoEJB> estadoList;
	private CidadeEJB entidade;
	private CidadeVO filtro;
	
	
	
	public CidadeAction (){
		
		entidade = new CidadeEJB();
		estadoList = Collections.emptyList();
		filtro = new CidadeVO();
		
	}
	
	private void initCombo() throws MozartSessionException {
		
		estadoList = SistemaDelegate.instance().pesquisarEstado();
						
	}
	
	public String prepararInclusao(){
		
		try {
			initCombo();
			
			
		} catch (MozartSessionException e) {
			
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
			
		}
		return SUCESSO_FORWARD;
		
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() {
		
	try { 
			initCombo();
			entidade=(CidadeEJB)CheckinDelegate.instance().obter(CidadeEJB.class, entidade.getIdCidade());
				
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarCidade() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			initCombo();
			
						
			if (MozartUtil.isNull(entidade.getIdCidade())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new CidadeEJB();

		} catch (MozartValidateException ex){
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} 		
		return SUCESSO_FORWARD; 
		
		
	}
		
	public String pesquisar(){
		
		try{
			List<CidadeVO> lista = SistemaDelegate.instance().pesquisarCidade(filtro);
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

	public List<EstadoEJB> getEstadoList() {
		return estadoList;
	}

	public void setEstadoList(List<EstadoEJB> estadoList) {
		this.estadoList = estadoList;
	}

	public CidadeEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(CidadeEJB entidade) {
		this.entidade = entidade;
	}

	public CidadeVO getFiltro() {
		return filtro;
	}

	public void setFiltro(CidadeVO filtro) {
		this.filtro = filtro;
	}

}