package com.mozart.web.actions.caixa;

import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.ejb.entity.TipoLancamentoEJB;
import com.mozart.web.actions.BaseAction;

public class CaixaAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8011517695497407482L;

	
	private List<TipoLancamentoEJB> grupoLancamentoList;
	
	public CaixaAction(){
		grupoLancamentoList = Collections.emptyList();
	}
	
	
	public String prepararRelatorio(){
		
		try{
			TipoLancamentoEJB pFiltro = new TipoLancamentoEJB();
			pFiltro.setIdHotel( getIdHoteis()[0] );
			grupoLancamentoList = CheckinDelegate.instance().pesquisarGrupoLancamento(pFiltro);	
		}catch(Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}

	public List<TipoLancamentoEJB> getGrupoLancamentoList() {
		return grupoLancamentoList;
	}

	public void setGrupoLancamentoList(List<TipoLancamentoEJB> grupoLancamentoList) {
		this.grupoLancamentoList = grupoLancamentoList;
	}
	
	
}
