package com.mozart.web.actions.sistema;

import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.NfeDelegate;
import com.mozart.model.ejb.entity.MovimentoApartamentoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.EstadoNfeVO;
import com.mozart.web.actions.BaseAction;

public class TributarioEstadualFcpAction extends BaseAction {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private List <EstadoNfeVO> estadosNfeList;
	private Double[] valorPreenchido;

	public TributarioEstadualFcpAction() {
		estadosNfeList = Collections.emptyList();
	}
	
		
	public String gravar() throws MozartSessionException {
		try {

			List<EstadoNfeVO> estadosNfeSession = (List) this.request
					.getSession().getAttribute("estadosNfeSession");
			
			for (int i = 0; i < estadosNfeSession.size(); i++) {
				Double valor = !MozartUtil.isNull(valorPreenchido[i]) ? valorPreenchido[i] : 0; 
				EstadoNfeVO estadoNovo = estadosNfeSession.get(i);
				estadoNovo.setValor(valor);
				NfeDelegate.instance().gravarFcp(estadoNovo);
			}
			
			addMensagemSucesso(MSG_SUCESSO);

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);

		}
		prepararPesquisa();
		return SUCESSO_FORWARD;

	}

	public String prepararPesquisa() throws MozartSessionException {
		
		estadosNfeList = NfeDelegate.instance().obterListaEstadosNfe();

		this.request.getSession().setAttribute("estadosNfeSession", estadosNfeList);
		
		return SUCESSO_FORWARD;
	}

	public List<EstadoNfeVO> getEstadosNfeList() {
		return estadosNfeList;
	}

	public void setEstadosNfeList(List<EstadoNfeVO> estadosNfeList) {
		this.estadosNfeList = estadosNfeList;
	}

	public Double[] getValorPreenchido() {
		return valorPreenchido;
	}

	public void setValorPreenchido(Double[] valorPreenchido) {
		this.valorPreenchido = valorPreenchido;
	}
	
}