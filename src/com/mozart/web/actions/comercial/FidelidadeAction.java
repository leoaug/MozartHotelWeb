package com.mozart.web.actions.comercial;


import com.mozart.web.actions.recepcao.HospedeAction;


@SuppressWarnings("serial")
public class FidelidadeAction extends HospedeAction {
	
	public FidelidadeAction(){
		super();		
		origemHospede = Boolean.FALSE;
	}
	

	public String gravar(){
		Long idHospede = entidade.getIdHospede();
		super.gravar();
		addMensagemSucesso( MSG_SUCESSO + " Fidelidade nº: " + idHospede );
		return SUCESSO_FORWARD;
	}

}
