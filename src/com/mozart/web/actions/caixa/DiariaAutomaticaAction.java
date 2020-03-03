package com.mozart.web.actions.caixa;

import java.util.List;

import com.mozart.model.delegate.CaixaGeralDelegate;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.web.actions.BaseAction;

public class DiariaAutomaticaAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 9073878535087923947L;

	private String checkinVencidos;
	private String diariaAutomaticaJaEfetuada;
	
	public String preparar(){
		info("Preparando diárias automáticas");
		try {
			List<String> validacaoAuditoria = CaixaGeralDelegate.instance().obterValidacaoLancamentoDiaria( getIdHoteis()[0] );
			checkinVencidos = validacaoAuditoria.get(0);
			diariaAutomaticaJaEfetuada = validacaoAuditoria.get(1);

		} catch (Exception ex) {
			error(ex.getMessage());
			addActionError(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}
	
	
	public String lancar(){
		info("Lançando diárias automáticas");
		try {
			ControlaDataEJB controlaData = getControlaData();
			controlaData.setUsuario( getUserSession().getUsuarioEJB() );
			CaixaGeralDelegate.instance().lancarDiariaAutomatica( controlaData );
			addMensagemSucesso(MSG_SUCESSO);
			return preparar();
		} catch (Exception ex) {
			error(ex.getMessage());
			if (ex.getMessage().indexOf("-20001") > 0){
				addMensagemSucesso( ex.getMessage() );
			}else{
				addActionError(MSG_ERRO);
			}
			return SUCESSO_FORWARD;
		}		
	}


	public String getCheckinVencidos() {
		return checkinVencidos;
	}


	public void setCheckinVencidos(String checkinVencidos) {
		this.checkinVencidos = checkinVencidos;
	}


	public String getDiariaAutomaticaJaEfetuada() {
		return diariaAutomaticaJaEfetuada;
	}


	public void setDiariaAutomaticaJaEfetuada(String diariaAutomaticaJaEfetuada) {
		this.diariaAutomaticaJaEfetuada = diariaAutomaticaJaEfetuada;
	}

}
