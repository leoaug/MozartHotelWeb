package com.mozart.web.actions.rede;

import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.HospedeEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.HospedeVO;
import com.mozart.web.actions.BaseAction;

public class TransferenciaHospedeAction extends BaseAction {

	/**
	 * 
	 */

	private static final long serialVersionUID = 1L;

	private String nomeHospede;
	private String idHospede;
	private String idHospedePara;
	private String paramHospedeDe;
	private String idsHospedesSelecionadosString;
	private HospedeEJB entidade;

	public TransferenciaHospedeAction() {
		entidade = new HospedeEJB();
	}

	public String prepararTransferencia() {

		try {

			this.request.getSession().removeAttribute(LISTA_PESQUISA);

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}

		return SUCESSO_FORWARD;
	}

	public String transferir() {
		try {

			for (String idHospedeDe : idsHospedesSelecionadosString.split(",")) {
				
				
				getHotelCorrente().getRedeHotelEJB().setUsuario(getUsuario());
				RedeDelegate.instance().executarProcedureTransferenciaHospede(
						getHotelCorrente().getRedeHotelEJB(),
						getHotelCorrente().getIdHotel(),
						Long.valueOf(idHospedeDe), Long.valueOf(idHospede));
			}

			addMensagemSucesso("Operação realizada com sucesso.");
			prepararTransferencia();

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);

		}

		return SUCESSO_FORWARD;
	}

	public String pesquisarHospedes() {

		try {

			java.util.List<HospedeVO> lista = RedeDelegate.instance()
					.obterHospedePorNomeSobrenomeCpfPassaporte(
							getHotelCorrente().getRedeHotelEJB()
									.getIdRedeHotel(), paramHospedeDe,
							Long.parseLong(idHospede));
			if (MozartUtil.isNull(lista)) {
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			request.getSession().setAttribute(LISTA_PESQUISA, lista);

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}

		return SUCESSO_FORWARD;
	}

	public HospedeEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(HospedeEJB entidade) {
		this.entidade = entidade;
	}

	public String getParamHospedeDe() {
		return paramHospedeDe;
	}

	public void setParamHospedeDe(String paramHospedeDe) {
		this.paramHospedeDe = paramHospedeDe;
	}

	public String getNomeHospede() {
		return nomeHospede;
	}

	public void setNomeHospede(String nomeHospede) {
		this.nomeHospede = nomeHospede;
	}

	public String getIdHospede() {
		return idHospede;
	}

	public void setIdHospede(String idHospede) {
		this.idHospede = idHospede;
	}

	public String getIdsHospedesSelecionadosString() {
		return idsHospedesSelecionadosString;
	}

	public void setIdsHospedesSelecionadosString(
			String idsHospedesSelecionadosString) {
		this.idsHospedesSelecionadosString = idsHospedesSelecionadosString;
	}

	public String getIdHospedePara() {
		return idHospedePara;
	}

	public void setIdHospedePara(String idHospedePara) {
		this.idHospedePara = idHospedePara;
	}

}