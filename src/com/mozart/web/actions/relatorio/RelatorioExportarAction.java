package com.mozart.web.actions.relatorio;

import com.mozart.model.exception.MozartSessionException;
import com.mozart.web.actions.BaseAction;

public class RelatorioExportarAction extends BaseAction {

private static final long serialVersionUID = -4797381933648578239L;
	
	public RelatorioExportarAction (){
	}
	
	public String prepararPesquisa() throws MozartSessionException{
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}	
}
