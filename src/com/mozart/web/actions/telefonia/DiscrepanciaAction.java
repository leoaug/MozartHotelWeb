package com.mozart.web.actions.telefonia;

import java.util.List;

import com.mozart.model.delegate.TelefoniaDelegate;
import com.mozart.model.ejb.entity.TelefoniaDiscrepanciaEJB;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.DiscrepanciaVO;
import com.mozart.web.actions.BaseAction;

public class DiscrepanciaAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private DiscrepanciaVO filtro;
	private TelefoniaDiscrepanciaEJB entidade;
	

	public DiscrepanciaAction(){
		filtro = new DiscrepanciaVO(); 
		entidade = new TelefoniaDiscrepanciaEJB();
	}
	
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String lancarMovimento(){
		
		try{
			
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			entidade.setIdHotel( getIdHoteis()[0] );
			TelefoniaDelegate.instance().lancarMovimentoDiscrepancia( entidade );
			addMensagemSucesso( MSG_SUCESSO );
			
		}catch(MozartValidateException ex){
			error( ex.getMessage() );
			addMensagemSucesso( ex.getMessage() );
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		
		return pesquisar();
	}
	
	
	
	
	
	
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis( getIdHoteis() );
			List<DiscrepanciaVO> lista = TelefoniaDelegate.instance().pesquisarDiscrepancia(filtro);
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


	public DiscrepanciaVO getFiltro() {
		return filtro;
	}


	public void setFiltro(DiscrepanciaVO filtro) {
		this.filtro = filtro;
	}


	public TelefoniaDiscrepanciaEJB getEntidade() {
		return entidade;
	}


	public void setEntidade(TelefoniaDiscrepanciaEJB entidade) {
		this.entidade = entidade;
	}
	
}

	

