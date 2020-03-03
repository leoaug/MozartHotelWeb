package com.mozart.web.actions.sistema;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
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

public class TributarioMunicipalAction extends BaseAction {
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
	private ArrayList<MozartComboWeb> quemPagaList = new ArrayList<MozartComboWeb>();
	private ArrayList<MozartComboWeb> rpsStatusList = new ArrayList<MozartComboWeb>();

	public TributarioMunicipalAction() {

		filtro = new NotaFiscalVO();
		entidade = new StatusNotaEJB();
		hospedeAPList = Collections.emptyList();
		statusList.add(new MozartComboWeb("OK", "OK"));
		statusList.add(new MozartComboWeb("NOTA CANC", "Nota Canc."));
		
		quemPagaList.add(new MozartComboWeb("H", "H"));
		quemPagaList.add(new MozartComboWeb("E", "E"));
		
		rpsStatusList.add(new MozartComboWeb("A", "A transmitir"));
		rpsStatusList.add(new MozartComboWeb("T", "Transmitida"));
		rpsStatusList.add(new MozartComboWeb("E", "Erro"));
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
	
	public String prepararAlteracaoDiscriminacao() {
		try {
			entidade = (StatusNotaEJB) CheckinDelegate.instance().obter(
					StatusNotaEJB.class, entidade.getIdNota());
		} catch (MozartSessionException e) {
			error(e.getMessage());
			addMensagemErro(MSG_ERRO);
			return ERRO_FORWARD;
		}

		return "discriminacao";

	}

	
	
	public String prepararRPS() {

		return SUCESSO_FORWARD;

	}
	
	public String gravarDiscriminacao() {
		try {

			entidade.setIdHotel(getHotelCorrente().getIdHotel());

			StatusNotaEJB oldEntity = (StatusNotaEJB) CheckinDelegate
						.instance().obter(StatusNotaEJB.class,
								entidade.getIdNota());
			oldEntity.setDiscriminacao(entidade.getDiscriminacao());
				
			CheckinDelegate.instance().alterar(oldEntity);
			
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new StatusNotaEJB();

		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);

		}
		prepararPesquisa();
		return PESQUISA_FORWARD;

	}
	
	public String gravar() {
		try {

			entidade.setIdHotel(getHotelCorrente().getIdHotel());

			if (MozartUtil.isNull(entidade.getIdNota())) {
				CheckinDelegate.instance().incluir(entidade);
			} else {

				StatusNotaEJB oldEntity = (StatusNotaEJB) CheckinDelegate
						.instance().obter(StatusNotaEJB.class,
								entidade.getIdNota());
				oldEntity.setSerie(entidade.getSerie());
				oldEntity.setSubSerie(entidade.getSubSerie());
				oldEntity.setAliquotaIss(entidade.getAliquotaIss());
				oldEntity.setIdEmpresa(entidade.getIdEmpresa());
				oldEntity.setIdHospede(entidade.getIdHospede());
				oldEntity.setStatus(entidade.getStatus());
				oldEntity.setMotivoCancelamento(entidade
						.getMotivoCancelamento());
				oldEntity.setBaseCalculo(entidade.getBaseCalculo());
				if(entidade.getAliquotaIss() != null && entidade.getBaseCalculo() !=null){
					Double issConvert = (entidade.getAliquotaIss() / 100) * entidade.getBaseCalculo();
					entidade.setIss(issConvert);
				}
				
				oldEntity.setIss(entidade.getIss());
				oldEntity.setPis(entidade.getPis());
				oldEntity.setCofins(entidade.getCofins());
				oldEntity.setInss(entidade.getInss());
				oldEntity.setIrRetencao(entidade.getIrRetencao());
				oldEntity.setCsll(entidade.getCsll());
				oldEntity.setIssRetido(entidade.getIssRetido());
				oldEntity.setDataEmissao(entidade.getDataEmissao());
				oldEntity.setNotaInicial(entidade.getNotaInicial());

				oldEntity.setRpsStatus(entidade.getRpsStatus());
				oldEntity.setQuemPaga(entidade.getQuemPaga());
				oldEntity.setNotaSubstituta(entidade.getNotaSubstituta());
				oldEntity.setDataSubstituta(entidade.getDataSubstituta());
				oldEntity.setSerieSubstituta(entidade.getSerieSubstituta());
				oldEntity.setDiscriminacao(entidade.getDiscriminacao());
				
				CheckinDelegate.instance().alterar(oldEntity);
			}
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new StatusNotaEJB();

		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);

		}
		prepararPesquisa();
		return PESQUISA_FORWARD;

	}

	public String gerarLote(){
		try
		{
			if(!validarEnvioNumeroLotes())
				return SUCESSO_FORWARD;
				
			List<String> idsRpsLote = new ArrayList<String>();
	
			request.getSession().setAttribute("ID_RPS", rpsSelecionadasString);
			request.getSession().setAttribute("CNFS", getControlaData().getUltimaCnfs());
			
			for(String idRps: rpsSelecionadasString.split(",")){
				idsRpsLote.add(idRps);
			}
			log.info(idsRpsLote);
						
			atualizarAposGerarLote(idsRpsLote, "T", getControlaData().getUltimaCnfs());
			prepararLotes();
			
			addMensagemSucesso(MSG_SUCESSO);
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);			
		} 		
		return SUCESSO_FORWARD;

	}

	public String downloadLote(){
		
		List<String> idsRpsLote = new ArrayList<String>();
		Long cnfs = (Long) request.getSession().getAttribute("CNFS");
		
		try
		{
			String idsRps = (String) request.getSession().getAttribute("ID_RPS");
			
			for(String idRps: idsRps.split(",")){
				idsRpsLote.add(idRps);
			}
			log.info(idsRpsLote);
						
			
			String xml = FinanceiroDelegate.instance().gerarXmlNotaFiscalLote(idsRpsLote, getHotelCorrente().getCgc(), getHotelCorrente().getInscMunicipal(), String.valueOf(cnfs), String.valueOf(getHotelCorrente().getCidadeEJB().getIdCidade()));
			
			addMensagemSucesso(MSG_SUCESSO);
			
			request.getSession().removeAttribute("ID_RPS");
					
			MozartHotelNotaFiscal mozartHotelNotaFiscal = new MozartHotelNotaFiscal();
			fileInputStream = mozartHotelNotaFiscal.downloadArquivoLote(request, response, nomeArquivo, xml);

		} catch (MozartValidateException ex){
			atualizarAposGerarLote(idsRpsLote, "A", cnfs-1);
			prepararLotes();
			
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
			return SUCESSO_FORWARD;
		} catch (Exception ex){
			atualizarAposGerarLote(idsRpsLote, "A", cnfs-1);
			prepararLotes();
			
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar a geração do arquivo de Lote.");			
			return SUCESSO_FORWARD;
		}
		finally{
			request.getSession().removeAttribute("ID_RPS");
			request.getSession().removeAttribute("CNFS");
		}
		
		return DOWNLOAD;

	}

	private void atualizarAposGerarLote(List<String> idsRps, String rpsStatus, Long cnfs){
		atualizarStatusNotas(idsRps, rpsStatus);
		atualizarCnfs(cnfs);
	}
	
	private void atualizarStatusNotas(List<String> idsRps, String rpsStatus){
		for (String idRps : idsRps) {
			Long idNota = Long.valueOf(idRps);
			
			StatusNotaEJB statusNota;
			try {
				statusNota = (StatusNotaEJB) CheckinDelegate
						.instance().obter(StatusNotaEJB.class,
								idNota);
				
				statusNota.setRpsStatus(rpsStatus);
				
				CheckinDelegate.instance().alterar(statusNota);
			} catch (MozartSessionException e) {
				error(e.getMessage());
				addMensagemErro(MSG_ERRO);
			}
		}
	}
	
	private void atualizarCnfs(Long cnfs){
		try {
			ControlaDataEJB controladorData = getControlaData();
				
			controladorData.setUltimaCnfs(cnfs+1);
			
			CheckinDelegate.instance().alterar(controladorData);
		} catch (MozartSessionException e) {
				error(e.getMessage());
				addMensagemErro(MSG_ERRO);
		}
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

	public String prepararLotes() {
		request.getSession().removeAttribute(LISTA_PESQUISA);

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
		
		this.pesquisarLotesNaoEnviados();

		return SUCESSO_FORWARD;
	}
	
	public String pesquisar() {

		try {
			filtro.setBcIdHotel(getHotelCorrente().getIdHotel());
			filtro.setBcTipoNota("F");
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			List<NotaFiscalVO> lista = SistemaDelegate.instance()
					.pesquisarNotaFiscal(filtro);
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
	
	private String pesquisarLotesNaoEnviados() {

		try {
			filtro.setBcIdHotel(getHotelCorrente().getIdHotel());
			filtro.setBcTipoNota("F");
			filtro.setGracStatusRPS("T");
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			List<NotaFiscalVO> lista = SistemaDelegate.instance()
					.pesquisarNotaFiscal(filtro);
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
	
	private boolean validarEnvioNumeroLotes() {

		try {
			NotaFiscalVO filtro = new NotaFiscalVO();
			
			filtro.setBcIdHotel(getHotelCorrente().getIdHotel());
			filtro.setBcTipoNota("F");
			filtro.setGracStatusRPS("T");
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			List<String> lista = SistemaDelegate.instance()
					.pesquisarUltimaNotaFiscalEnviada(filtro);
			
			String[] numSelecionados = numRpsSelecionadasString.split(",");
			
			Long numAnterior = 0L;
			for (String numSelecionado : numSelecionados) {
				if(numAnterior == 0){
					numAnterior = Long.valueOf(numSelecionado);
					continue;
				}
				else{
					if(Long.valueOf(numSelecionado) - Long.valueOf(numAnterior) == 1){
						numAnterior = Long.valueOf(numSelecionado);
						continue;
					}
					else
					{
						addMensagemErro("As notas devem ser enviadas na ordem, foi selecionada notas em fora de sequência");
						return false;
					}
				}
			}
			
			String ultimaNota = MozartUtil.isNull(lista) ? "0" : lista.get(0); 
				
			String primeiroNumero = numSelecionados[0];
			if(Long.valueOf(primeiroNumero) - Long.valueOf(ultimaNota) == 1){
				return true;
			}
			else{
				addMensagemErro("As notas devem ser enviadas na ordem, a última nota enviada foi: " + ultimaNota);
				return false;
			}

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		return false;
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

	public ArrayList<MozartComboWeb> getQuemPagaList() {
		return quemPagaList;
	}

	public void setQuemPagaList(ArrayList<MozartComboWeb> quemPagaList) {
		this.quemPagaList = quemPagaList;
	}

	public ArrayList<MozartComboWeb> getRpsStatusList() {
		return rpsStatusList;
	}

	public void setRpsStatusList(ArrayList<MozartComboWeb> rpsStatusList) {
		this.rpsStatusList = rpsStatusList;
	}
}