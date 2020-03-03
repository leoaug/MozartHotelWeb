package com.mozart.web.actions.caixa;

import java.util.List;

import com.mozart.model.delegate.BraspagDelegate;
import com.mozart.model.delegate.CaixaGeralDelegate;
import com.mozart.model.ejb.entity.TransacaoWebEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.TransacaoWebVO;
import com.mozart.web.actions.BaseAction;

public class TransacoesWebAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8515872786532368082L;
	
	
	private TransacaoWebVO filtro;
	private TransacaoWebEJB entidade;
	
	
	public TransacoesWebAction(){
		filtro = new TransacaoWebVO();
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute( LISTA_PESQUISA );
		return SUCESSO_FORWARD;
	}

	public String pesquisar(){
		
		try{

			filtro.setIdHoteis( getIdHoteis() );
			List<TransacaoWebVO> lista = CaixaGeralDelegate.instance().pesquisarTransacaoWeb( filtro );
			request.getSession().setAttribute( LISTA_PESQUISA , lista);
			if (MozartUtil.isNull( lista )){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}
	

	public String estornar(){
		
		try{

			entidade.setHotelEJB(getHotelCorrente());
			entidade.setUsuario(getUsuario());
			BraspagDelegate.instance().estornarTransacaoWeb( entidade );
			addMensagemSucesso( MSG_SUCESSO );
			pesquisar();
			
		}catch(MozartValidateException ex){			
			error( ex.getMessage() );
			addMensagemSucesso(ex.getMessage() );
			
		}catch(MozartSessionException ex){
			error( ex.getMessage() );
			addMensagemErro( ex.getMessage() );

		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}

	public TransacaoWebVO getFiltro() {
		return filtro;
	}

	public void setFiltro(TransacaoWebVO filtro) {
		this.filtro = filtro;
	}

	public TransacaoWebEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(TransacaoWebEJB entidade) {
		this.entidade = entidade;
	}


}
