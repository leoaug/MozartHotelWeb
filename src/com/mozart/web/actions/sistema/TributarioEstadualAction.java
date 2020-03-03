package com.mozart.web.actions.sistema;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
import com.mozart.model.delegate.PdvDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.StatusNotaEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.HospedeAchadosPerdidoVO;
import com.mozart.model.vo.NotaFiscalVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.controller.MozartHotelNotaFiscal;
import com.mozart.web.util.MozartComboWeb;

public class TributarioEstadualAction extends BaseAction {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private NotaFiscalVO filtro;
	private StatusNotaEJB entidade;
	private List<HospedeAchadosPerdidoVO> hospedeAPList;
	private Long rpsSelecionadas[];
	private String rpsSelecionadasString;
	private String numRpsSelecionadasString;
	private String nomeArquivo;
	private ArrayList<MozartComboWeb> statusList = new ArrayList<MozartComboWeb>();
	private ArrayList<MozartComboWeb> rpsStatusList = new ArrayList<MozartComboWeb>();

	public TributarioEstadualAction() {

		filtro = new NotaFiscalVO();
		entidade = new StatusNotaEJB();
		hospedeAPList = Collections.emptyList();
		statusList.add(new MozartComboWeb("OK", "OK"));
		statusList.add(new MozartComboWeb("NOTA CANC", "Nota Canc."));
				
		rpsStatusList.add(new MozartComboWeb("A", "A transmitir"));
		rpsStatusList.add(new MozartComboWeb("T", "Transmitida"));
		rpsStatusList.add(new MozartComboWeb("E", "Rejeitada"));
		rpsStatusList.add(new MozartComboWeb("R", "Renegada"));
	}

	private InputStream fileInputStream;
	
	public InputStream getFileInputStream() {
		return fileInputStream;
	}
	
	public String prepararInclusao() {
		return SUCESSO_FORWARD;

	}

	public String prepararAlteracao() {
		try {
			entidade = (StatusNotaEJB) CheckinDelegate.instance().obter(
					StatusNotaEJB.class, entidade.getIdNota());
		} catch (MozartSessionException e) {
			error(e.getMessage());
			addMensagemErro(MSG_ERRO);
			return ERRO_FORWARD;
		}

		return SUCESSO_FORWARD;

	}
		
	public String prepararPesquisa() {
		if(MozartUtil.isNull(filtro))
			filtro = new NotaFiscalVO();

		filtro.getData().setTipo("D");
		filtro.getData().setTipoIntervalo("1");
		
		if (MozartUtil.isNull(filtro.getData().getValorInicial())){
			filtro.getData().setValorInicial(
				MozartUtil.format(getControlaData().getFrontOffice()));
		}
		if (MozartUtil.isNull(filtro.getData().getValorFinal())){
			filtro.getData().setValorFinal(
				MozartUtil.format(getControlaData().getFrontOffice()));
		}
		
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar() {

		try {
			filtro.setBcIdHotel(getHotelCorrente().getIdHotel());
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			List<NotaFiscalVO> lista = PdvDelegate.instance()
					.consultarNotaFiscalNfce(filtro);
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

	public NotaFiscalVO getFiltro() {
		return filtro;
	}

	public void setFiltro(NotaFiscalVO filtro) {
		this.filtro = filtro;
	}

	public StatusNotaEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(StatusNotaEJB entidade) {
		this.entidade = entidade;
	}

	public List<HospedeAchadosPerdidoVO> getHospedeAPList() {
		return hospedeAPList;
	}

	public void setHospedeAPList(List<HospedeAchadosPerdidoVO> hospedeAPList) {
		this.hospedeAPList = hospedeAPList;
	}

	public ArrayList<MozartComboWeb> getStatusList() {
		return statusList;
	}

	public void setStatusList(ArrayList<MozartComboWeb> statusList) {
		this.statusList = statusList;
	}

	public Long[] getRpsSelecionadas() {
		return rpsSelecionadas;
	}

	public void setRpsSelecionadas(Long[] rpsSelecionadas) {
		this.rpsSelecionadas = rpsSelecionadas;
	}

	public String getNomeArquivo() {
		return nomeArquivo;
	}

	public void setNomeArquivo(String nomeArquivo) {
		this.nomeArquivo = nomeArquivo;
	}

	public String getRpsSelecionadasString() {
		return rpsSelecionadasString;
	}

	public void setRpsSelecionadasString(String rpsSelecionadasString) {
		this.rpsSelecionadasString = rpsSelecionadasString;
	}

	public String getNumRpsSelecionadasString() {
		return numRpsSelecionadasString;
	}

	public void setNumRpsSelecionadasString(String numRpsSelecionadasString) {
		this.numRpsSelecionadasString = numRpsSelecionadasString;
	}

	public ArrayList<MozartComboWeb> getRpsStatusList() {
		return rpsStatusList;
	}

	public void setRpsStatusList(ArrayList<MozartComboWeb> rpsStatusList) {
		this.rpsStatusList = rpsStatusList;
	}
}