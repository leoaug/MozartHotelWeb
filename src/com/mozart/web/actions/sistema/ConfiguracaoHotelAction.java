package com.mozart.web.actions.sistema;

import java.util.ArrayList;
import java.util.List;

import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.vo.ConfiguracaoTributarioVO;
import com.mozart.model.vo.ExigibilidadeVO;
import com.mozart.model.vo.RegimeTributarioVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class ConfiguracaoHotelAction extends BaseAction {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private ConfiguracaoTributarioVO entidade;
	private ArrayList<MozartComboWeb> producaoList = new ArrayList<MozartComboWeb>();
	private ArrayList<MozartComboWeb> incentivoFiscalList = new ArrayList<MozartComboWeb>();
	private ArrayList<MozartComboWeb> exibilidadeList = new ArrayList<MozartComboWeb>();
	private ArrayList<MozartComboWeb> regimeTributarioList = new ArrayList<MozartComboWeb>();
	private Long idPrefeitura;
	private Long idTabServ;

	public ConfiguracaoHotelAction() {
		try {
			entidade = new ConfiguracaoTributarioVO();
			
			producaoList.add(new MozartComboWeb("N", "N"));
			producaoList.add(new MozartComboWeb("S", "S"));
			
			incentivoFiscalList.add(new MozartComboWeb("N", "N"));
			incentivoFiscalList.add(new MozartComboWeb("S", "S"));
			
			List<ExigibilidadeVO> listExigibilidade = SistemaDelegate.instance().obterExigibilidade();
			
			for (ExigibilidadeVO exibilidadeVO : listExigibilidade) {
				exibilidadeList.add(new MozartComboWeb(exibilidadeVO.getId().toString(), exibilidadeVO.getDescricao()));
			}
			
			List<RegimeTributarioVO> listRegimeTributario = SistemaDelegate.instance().obterRegimeTributario();
			
			for (RegimeTributarioVO regimeTributarioVO : listRegimeTributario) {
				regimeTributarioList.add(new MozartComboWeb(regimeTributarioVO.getId().toString(), regimeTributarioVO.getRegime()));
			}
			
		} catch (MozartSessionException e) {
			error(e.getMessage());
			addMensagemErro(MSG_ERRO);
		}
	}

	public String prepararManter() {
		try {
			ConfiguracaoTributarioVO filtro = new ConfiguracaoTributarioVO();
			filtro.setIdHotel(getHotelCorrente().getIdHotel());
			entidade = SistemaDelegate.instance().pesquisarConfiguracaoTributaria(filtro);
			
		} catch (MozartSessionException e) {
			error(e.getMessage());
			addMensagemErro(MSG_ERRO);
			return ERRO_FORWARD;
		}

		return SUCESSO_FORWARD;
	}

	public String gravar() {
//		try {
//
//			entidade.setIdHotel(getHotelCorrente().getIdHotel());
//
//			if (MozartUtil.isNull(entidade.getIdNota())) {
//				CheckinDelegate.instance().incluir(entidade);
//			} else {
//
//				StatusNotaEJB oldEntity = (StatusNotaEJB) CheckinDelegate
//						.instance().obter(StatusNotaEJB.class,
//								entidade.getIdNota());
//				oldEntity.setSerie(entidade.getSerie());
//				oldEntity.setSubSerie(entidade.getSubSerie());
//				oldEntity.setAliquotaIss(entidade.getAliquotaIss());
//				oldEntity.setIdEmpresa(entidade.getIdEmpresa());
//				oldEntity.setIdHospede(entidade.getIdHospede());
//				oldEntity.setStatus(entidade.getStatus());
//				oldEntity.setMotivoCancelamento(entidade
//						.getMotivoCancelamento());
//				oldEntity.setBaseCalculo(entidade.getBaseCalculo());
//				if(entidade.getAliquotaIss() != null && entidade.getBaseCalculo() !=null){
//					Double issConvert = (entidade.getAliquotaIss() / 100) * entidade.getBaseCalculo();
//					entidade.setIss(issConvert);
//				}
//				
//				oldEntity.setIss(entidade.getIss());
//				oldEntity.setPis(entidade.getPis());
//				oldEntity.setCofins(entidade.getCofins());
//				oldEntity.setInss(entidade.getInss());
//				oldEntity.setIrRetencao(entidade.getIrRetencao());
//				oldEntity.setCsll(entidade.getCsll());
//				oldEntity.setIssRetido(entidade.getIssRetido());
//				oldEntity.setDataEmissao(entidade.getDataEmissao());
//				oldEntity.setNotaInicial(entidade.getNotaInicial());
//
//				oldEntity.setRpsStatus(entidade.getRpsStatus());
//				oldEntity.setQuemPaga(entidade.getQuemPaga());
//				oldEntity.setNotaSubstituta(entidade.getNotaSubstituta());
//				oldEntity.setDataSubstituta(entidade.getDataSubstituta());
//				oldEntity.setSerieSubstituta(entidade.getSerieSubstituta());
//				oldEntity.setDiscriminacao(entidade.getDiscriminacao());
//				
//				CheckinDelegate.instance().alterar(oldEntity);
//			}
//			addMensagemSucesso(MSG_SUCESSO);
//			entidade = new StatusNotaEJB();
//
//		} catch (MozartValidateException ex) {
//			error(ex.getMessage());
//			addMensagemSucesso(ex.getMessage());
//
//		} catch (Exception ex) {
//			error(ex.getMessage());
//			addMensagemErro(MSG_ERRO);
//
//		}
//		prepararPesquisa();
		return PESQUISA_FORWARD;

	}

	public ConfiguracaoTributarioVO getEntidade() {
		return entidade;
	}

	public void setEntidade(ConfiguracaoTributarioVO entidade) {
		this.entidade = entidade;
	}

	public ArrayList<MozartComboWeb> getProducaoList() {
		return producaoList;
	}

	public void setProducaoList(ArrayList<MozartComboWeb> producaoList) {
		this.producaoList = producaoList;
	}

	public ArrayList<MozartComboWeb> getExibilidadeList() {
		return exibilidadeList;
	}

	public void setExibilidadeList(ArrayList<MozartComboWeb> exibilidadeList) {
		this.exibilidadeList = exibilidadeList;
	}

	public ArrayList<MozartComboWeb> getRegimeTributarioList() {
		return regimeTributarioList;
	}

	public void setRegimeTributarioList(
			ArrayList<MozartComboWeb> regimeTributarioList) {
		this.regimeTributarioList = regimeTributarioList;
	}

	public ArrayList<MozartComboWeb> getIncentivoFiscalList() {
		return incentivoFiscalList;
	}

	public void setIncentivoFiscalList(ArrayList<MozartComboWeb> incentivoFiscalList) {
		this.incentivoFiscalList = incentivoFiscalList;
	}

	public Long getIdPrefeitura() {
		return idPrefeitura;
	}

	public void setIdPrefeitura(Long idPrefeitura) {
		this.idPrefeitura = idPrefeitura;
	}

	public Long getIdTabServ() {
		return idTabServ;
	}

	public void setIdTabServ(Long idTabServ) {
		this.idTabServ = idTabServ;
	}
	
}