package com.mozart.web.actions.caixa;

import java.util.List;

import com.mozart.model.delegate.CaixaGeralDelegate;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.MovimentoObjetoVO;
import com.mozart.web.actions.BaseAction;

public class ObjetoEmprestadoAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7648425531289512055L;

	private MovimentoObjetoVO filtro;
	
	public ObjetoEmprestadoAction(){
		filtro = new MovimentoObjetoVO();
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis( getIdHoteis() );
			List<MovimentoObjetoVO> lista = CaixaGeralDelegate.instance().pesquisarMovimentoObjeto(filtro);
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

	public MovimentoObjetoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(MovimentoObjetoVO filtro) {
		this.filtro = filtro;
	}
	
	
	
}
