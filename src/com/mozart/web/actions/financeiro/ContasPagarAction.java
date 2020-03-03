package com.mozart.web.actions.financeiro;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.io.FileUtils;

import com.mozart.model.delegate.AlfaDelegate;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.ClassificacaoContabilEJB;
import com.mozart.model.ejb.entity.ContasPagarEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HistoricoContabilEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.MovimentoContabilEJB;
import com.mozart.model.ejb.entity.PlanoContaEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ClassificacaoContabilVO;
import com.mozart.model.vo.ContaCorrenteVO;
import com.mozart.model.vo.ContasPagarVO;
import com.mozart.model.vo.DuplicataVO;
import com.mozart.model.vo.PlanoContaVO;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings("unchecked")
public class ContasPagarAction extends ContasReceberAction {
	private static final long serialVersionUID = -8978837298285732383L;
	private ContasPagarEJB entidadeCP;
	private ContasPagarVO filtro;
	private Long indice;
	private Long idClassificacaoPadrao;
	private Long idContaFinanceira;
	private Long idContaCredito;
	private String[] debitoCredito;
	private String[] pis;
	private String[] complementoHistorico;
	private String[] lancarContasPagarCredito;
	private Long[] idPlanoContas;
	private Long[] idPlanoContas2;
	private Long[] controleAtivo;
	private Long[] idHistoricoContabil;
	private Long[] idCentroCusto;
	private Double[] valorLancamento;
	private List<MozartComboWeb> debitoCreditoList;
	private List<HistoricoContabilEJB> historicoList;
	private List<PlanoContaVO> planoContaFinanceiroList;
	private List<PlanoContaVO> planoContaCreditoList;
	private List<ClassificacaoContabilVO> classificacaoPadraoList;
	private String classificacaoPadrao;
	private Long[] idContasPagar;
	private List<ContasPagarEJB> parcelasCP;
	private boolean possuiClassificacaoContabil;
	protected boolean operacaoRealizada;
	protected boolean podeGravar;
	protected String mensagemPai;
	private String numCheque;
	private String portador;
	private Long contaCorrente;
	private File documento;
    private String contentType;
    private String documentoFileName;
    private InputStream documentoStream;

	public ContasPagarAction() {
		this.filtro = new ContasPagarVO();
		this.entidadeCP = new ContasPagarEJB();

		this.debitoCreditoList = Collections.emptyList();
		this.historicoList = Collections.emptyList();
		this.planoContaFinanceiroList = Collections.emptyList();
		this.planoContaCreditoList = Collections.emptyList();
		this.classificacaoPadraoList = Collections.emptyList();
	}

	public String prepararEncerramento() {
		try {
			this.possuiClassificacaoContabil = false;
			List validacaoEncerramento = FinanceiroDelegate.instance()
					.obterValidacaoEncerramentoContasPagar(getIdHoteis()[0]);
			if (((BigDecimal) validacaoEncerramento.get(0)).intValue() > 0) {
				this.possuiClassificacaoContabil = true;
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		
		return SUCESSO_FORWARD;
	}

	public String encerrar() {
		try {
			this.filtro = new ContasPagarVO();
			prepararPesquisa();
			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUserSession().getUsuarioEJB());
			FinanceiroDelegate.instance().encerrarContasPagar(hotel);
			ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
					.obter(ControlaDataEJB.class, getIdHoteis()[0]);
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			prepararEncerramento();
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
			return SUCESSO_FORWARD;
		} catch (Exception ex) {
			prepararEncerramento();
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			return SUCESSO_FORWARD;
		}
		return "pesquisa";
	}

	public String gravarParcelamento() {
		try {
			dividirTitulo();
			this.entidadeCP.setUsuario(getUserSession().getUsuarioEJB());
			FinanceiroDelegate.instance().gravarParcelamento(this.entidadeCP,
					this.parcelasCP);
			prepararPesquisa();
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
			return SUCESSO_FORWARD;
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			return SUCESSO_FORWARD;
		}
		return "pesquisa";
	}

	public String estornarDuplicata() {
		try {
			this.entidadeCP = ((ContasPagarEJB) CheckinDelegate.instance()
					.obter(ContasPagarEJB.class,
							this.entidadeCP.getIdContasPagar()));
			
			if(entidadeCP.getDataPagamento().compareTo(getControlaData().getContasPagar()) == 0){
				this.entidadeCP.setDataPagamento(null);
				this.entidadeCP.setNumCheque(null);
				this.entidadeCP.setPago("N");
				this.entidadeCP.setValorPagamento(null);
				this.entidadeCP.setUsuario(getUsuario());
				CheckinDelegate.instance().alterar(this.entidadeCP);
				addMensagemSucesso("Operação realizada com sucesso.");
			}
			else{
				error("Para realizar o estorno a Data de Pagamento deve ser igual a Data do Contas a Pagar.");
				addMensagemErro("Para realizar o estorno a Data de Pagamento deve ser igual a Data do Contas a Pagar.");
			}
			
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "pesquisa";
	}

	public String prepararParcelamento() {
		try {
			this.entidadeCP = ((ContasPagarEJB) CheckinDelegate.instance()
					.obter(ContasPagarEJB.class,
							this.entidadeCP.getIdContasPagar()));
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD;
	}

	public String dividirTitulo() {
		try {
			if ((getDataVencimento() != null)
					&& (getDataVencimento().length != getQtdeParcela()
							.longValue())) {
				setDataVencimento(null);
				setAjustes(null);
				setValorDuplicata(null);
			}
			this.entidadeCP = ((ContasPagarEJB) CheckinDelegate.instance()
					.obter(ContasPagarEJB.class,
							this.entidadeCP.getIdContasPagar()));
			if (MozartUtil.isNull(this.entidadeCP.getDesconto())) {
				this.entidadeCP.setDesconto(new Double(0.0D));
			}
			this.parcelasCP = new ArrayList(getQtdeParcela().intValue());

			Double valorParcela = Double.valueOf(0.0D);
			if ((this.entidadeCP.getValorBruto() != null)
					&& (this.entidadeCP.getValorBruto().doubleValue() > 0.0D)) {
				valorParcela = MozartUtil.round(Double.valueOf(this.entidadeCP
						.getValorBruto().doubleValue()
						/ getQtdeParcela().intValue()));
			}
			Double ajusteParcela = Double.valueOf(0.0D);
			if ((this.entidadeCP.getDesconto() != null)
					&& (this.entidadeCP.getDesconto().doubleValue() > 0.0D)) {
				ajusteParcela = MozartUtil.round(Double.valueOf(this.entidadeCP
						.getDesconto().doubleValue()
						/ getQtdeParcela().intValue()));
			}
			Double encargoParcela = Double.valueOf(0.0D);
			if ((this.entidadeCP.getJuros() != null)
					&& (this.entidadeCP.getJuros().doubleValue() > 0.0D)) {
				encargoParcela = MozartUtil.round(Double
						.valueOf(this.entidadeCP.getJuros().doubleValue()
								/ getQtdeParcela().intValue()));
			}
			for (int x = 0; x < getQtdeParcela().intValue(); x++) {
				ContasPagarEJB parcela = this.entidadeCP.clone();
				parcela.setIdContasPagar(null);
				parcela
						.setDataVencimento(getDataVencimento() != null ? getDataVencimento()[x]
								: MozartUtil.incrementarMes(this.entidadeCP
										.getDataVencimento(), x));
				parcela
						.setValorBruto(getValorDuplicata() != null ? getValorDuplicata()[x]
								: valorParcela);
				parcela.setDesconto(getAjustes() != null ? getAjustes()[x]
						: ajusteParcela);
				parcela.setJuros(getEncargos() != null ? getEncargos()[x]
						: encargoParcela);
				this.parcelasCP.add(parcela);
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD;
	}

	public String pagarContasPagar() {
		info("Iniciando a gravacao do pagamento do contas a pagar");
		try {
			initCombo();
			if ((this.idContasPagar == null)
					|| (this.idContasPagar.length == 0)) {
				addMensagemSucesso("Informe um título para efetuar o pagamento");
				return SUCESSO_FORWARD;
			}
			List<ContasPagarVO> listaPesquisa = (List) this.request
					.getSession().getAttribute("listaPesquisa");
			List<ContasPagarVO> listaPagamento = new ArrayList();
			ContasPagarVO rec = null;
			for (int x = 0; x < this.idContasPagar.length; x++) {
				rec = new ContasPagarVO();
				rec.setIdContasPagar(this.idContasPagar[x]);
				if (listaPesquisa.contains(rec)) {
					rec = (ContasPagarVO) listaPesquisa.get(listaPesquisa
							.indexOf(rec));
					if (!MozartUtil.isNull(this.contaCorrente)) {
						rec.setContaCorrente(this.contaCorrente);
						rec.setIdContaCorrente(this.contaCorrente);
					}
					if (!MozartUtil.isNull(this.numCheque)) {
						rec.setNumCheque(this.numCheque);
					}
					if (!MozartUtil.isNull(this.portador)) {
						rec.setNomePortador(this.portador);
					}
					listaPagamento.add(rec);
				}
			}
			rec.setUsuario(getUsuario());
			rec.setIdHoteis(getIdHoteis());

			FinanceiroDelegate.instance().pagarTitulos(rec, listaPagamento);
			for (DuplicataVO add : listaPagamento) {
				listaPesquisa.remove(add);
			}
			return SUCESSO_FORWARD;
		} catch (MozartValidateException e) {
			error(e.getMessage());
			addMensagemSucesso(e.getMessage());
			return SUCESSO_FORWARD;
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD;
	}

	public String prepararPagamento() {
		info("Iniciando o pagamento do contas a pagar");
		try {
			initCombo();
			return SUCESSO_FORWARD;
		} catch (MozartSessionException e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			prepararPesquisa();
		}
		return SUCESSO_FORWARD;
	}

	public String prepararAlteracao() {
		try {
			initCombo();
			prepararPesquisa();
			this.entidadeCP = FinanceiroDelegate.instance().obterContasPagar(
					this.entidadeCP);

			this.request.getSession().setAttribute("entidadeSession",
					this.entidadeCP);
		} catch (Exception exc) {
			error(exc.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD;
	}

	public String preGravar() {
		try {
			this.podeGravar = false;
			sincronizarLancamento();
			this.podeGravar = true;
		} catch (Exception ex) {
			this.mensagemPai = "Erro ao realizar operação.";
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			resetLancamento();
		}
		return SUCESSO_FORWARD;
	}

	private void sincronizarLancamento() throws MozartSessionException {
		initCombo();
		initComboLancamento();

		ContasPagarEJB cpSession = (ContasPagarEJB) this.request.getSession()
				.getAttribute("entidadeSession");
		int x = 1;
		if (cpSession.getMovimentoContabilEJBList() != null) {
			Iterator localIterator = cpSession.getMovimentoContabilEJBList()
					.iterator();
			while (localIterator.hasNext()) {
				MovimentoContabilEJB lanc = (MovimentoContabilEJB) localIterator
						.next();

				lanc.setDataDocumento(this.entidadeCP.getDataLancamento());
				lanc.setContaCorrente(this.entidadeCP.getContaCorrente());

				lanc.setIdHotel(getHotelCorrente().getIdHotel());
				lanc.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
						.getIdRedeHotel());
				lanc
						.setLancarContasPagarCredito(this.lancarContasPagarCredito[x]);
				lanc.setControleAtivoFixo(this.controleAtivo[x]);
				lanc.setDebitoCredito(this.debitoCredito[x]);

				PlanoContaVO plano = new PlanoContaVO();
				plano.setIdPlanoContas(this.idPlanoContas[x]);
				PlanoContaEJB planoMov = null;
				int idx = -1;
				if ((idx = getPlanoContaList().indexOf(plano)) >= 0) {
					plano = (PlanoContaVO) getPlanoContaList().get(idx);
					planoMov = new PlanoContaEJB();
					planoMov.setIdPlanoContas(plano.getIdPlanoContas());
					planoMov.setContaContabil(plano.getContaContabil());
					planoMov.setAtivoPassivo(plano.getAtivoPassivo());
					planoMov.setNomeConta(plano.getNomeConta());
				}
				lanc.setPlanoContaEJB(planoMov);
				if (!MozartUtil.isNull(this.idHistoricoContabil[x])) {
					HistoricoContabilEJB historico = new HistoricoContabilEJB();
					historico.setIdHistorico(this.idHistoricoContabil[x]);
					idx = -1;
					if ((idx = this.historicoList.indexOf(historico)) >= 0) {
						historico = (HistoricoContabilEJB) this.historicoList
								.get(idx);
					} else {
						historico = null;
					}
					lanc.setHistoricoContabilEJB(historico);
				}
				if (!MozartUtil.isNull(this.idCentroCusto[x])) {
					CentroCustoContabilEJB ccc = new CentroCustoContabilEJB();
					ccc.setIdCentroCustoContabil(this.idCentroCusto[x]);
					idx = -1;
					if ((idx = super.getCentroCustoList().indexOf(ccc)) >= 0) {
						ccc = (CentroCustoContabilEJB) super
								.getCentroCustoList().get(idx);
					} else {
						ccc = null;
					}
					lanc.setCentroCustoContabilEJB(ccc);
				}
				lanc.setPis(this.pis[x]);
				lanc.setNumDocumento(this.complementoHistorico[x]);
				lanc.setValor(this.valorLancamento[x]);
				lanc.setTipoMovimento("M");

				x++;
			}
		}
	}

	public String gravar() {
		try {
			initCombo();
			initComboLancamento();

			this.entidadeCP.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			this.entidadeCP.setUsuario(getUserSession().getUsuarioEJB());
			this.entidadeCP.getFornecedorHotelEJB().setIdHotel(
					getHotelCorrente().getIdHotel());
			ContasPagarEJB cpSession = (ContasPagarEJB) this.request
					.getSession().getAttribute("entidadeSession");
			
			if(this.entidadeCP.getNomeDocumento().equals("")){
				if(this.documento == null){
					this.entidadeCP.setArquivoDocumento(null);	
				}else{
					if (this.documento.length() > 5242880) {
						addMensagemErro("Somente são aceitos documentos até 5mb.");
						return SUCESSO_FORWARD;
					}
					
					if (this.documentoFileName.length() > 60) {
						addMensagemErro("O nome do documento deve possuir no máximo 60 caracteres");
						return SUCESSO_FORWARD;
					}
					
					if (!this.documentoFileName.toLowerCase().endsWith(".pdf")) {
						addMensagemErro("Somente são aceitos documentos do tipo PDF.");
						return SUCESSO_FORWARD;
					}
					
					this.entidadeCP.setNomeDocumento(this.documentoFileName);
					this.entidadeCP.setArquivoDocumento(FileUtils.readFileToByteArray(this.documento));
				}
			}else{
				this.entidadeCP.setNomeDocumento(cpSession.getNumDocumento());
				this.entidadeCP.setArquivoDocumento(cpSession.getArquivoDocumento());
			}			
			
			if (MozartUtil.isNull(cpSession.getMovimentoContabilEJBList())) {
				addMensagemErro("Você deve informar um lançamento");
				return SUCESSO_FORWARD;
			}
			int x = 1;

			Long seqContabilVal = AlfaDelegate.instance().obterNextSequence("mozart.seq_contabil");
			Iterator localIterator = cpSession.getMovimentoContabilEJBList()
					.iterator();
			while (localIterator.hasNext()) {
				MovimentoContabilEJB lanc = (MovimentoContabilEJB) localIterator
						.next();

				lanc.setIdSeqContabil(seqContabilVal);
				lanc.setIdHotel(getHotelCorrente().getIdHotel());
				lanc.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
						.getIdRedeHotel());
				lanc.setDataDocumento(this.entidadeCP.getDataLancamento());
				lanc.setContaCorrente(this.entidadeCP.getContaCorrente());
				if ("S".equals(lanc.getLancarContasPagarCredito())) {
					this.entidadeCP.setPis(lanc.getPis());
					if (lanc.getPlanoContaEJB() != null) {
						this.entidadeCP.setIdPlanoContasCredito(lanc
								.getPlanoContaEJB().getIdPlanoContas());
					}
					if (lanc.getHistoricoContabilEJB() != null) {
						this.entidadeCP.setIdHistoricoCredito(lanc
								.getHistoricoContabilEJB().getIdHistorico());
					}
				}
				this.entidadeCP.addMovimentoContabilEJBList(lanc);
				x++;
			}
			this.entidadeCP.setSituacao("M");
			
			FinanceiroDelegate.instance().gravarContasPagar(this.entidadeCP,
					getEntidadeHistorico());
			prepararInclusao();
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD;
	}

	public String obterClassificacaoPadrao() {
		try {
			initComboLancamento();

			ClassificacaoContabilEJB filtro = new ClassificacaoContabilEJB();
			filtro.setIdHotel(getIdHoteis()[0]);
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			filtro.setDescricao(getClassificacaoPadrao());
			List<ClassificacaoContabilEJB> classPadrao = FinanceiroDelegate
					.instance().obterClassificacaoContabilPadrao(filtro);

			ContasPagarEJB entidade = (ContasPagarEJB) this.request
					.getSession().getAttribute("entidadeSession");
			for (ClassificacaoContabilEJB lancPadrao : classPadrao) {
				MovimentoContabilEJB lancamento = new MovimentoContabilEJB();
				lancamento.setDebitoCredito(lancPadrao.getDebitoCredito());
				lancamento.setIdHotel(getIdHoteis()[0]);

				PlanoContaVO plano = new PlanoContaVO();
				plano.setIdPlanoContas("D"
						.equals(lancPadrao.getDebitoCredito()) ? lancPadrao
						.getPlanoContasDebito().getIdPlanoContas() : lancPadrao
						.getPlanoContasCredito().getIdPlanoContas());
				PlanoContaEJB planoMov = null;
				int idx = -1;
				if ((idx = getPlanoContaList().indexOf(plano)) >= 0) {
					plano = (PlanoContaVO) getPlanoContaList().get(idx);
					planoMov = new PlanoContaEJB();
					planoMov.setIdPlanoContas(plano.getIdPlanoContas());
					planoMov.setContaContabil(plano.getContaContabil());
					planoMov.setAtivoPassivo(plano.getAtivoPassivo());
					planoMov.setNomeConta(plano.getNomeConta());

					planoMov = (PlanoContaEJB) CheckinDelegate.instance()
							.obter(PlanoContaEJB.class,
									planoMov.getIdPlanoContas());
					HistoricoContabilEJB historico = new HistoricoContabilEJB();
					historico = "D".equals(lancPadrao.getDebitoCredito()) ? planoMov
							.getHistoricoDebito()
							: planoMov.getHistoricoCredito();
					lancamento.setHistoricoContabilEJB(historico);
				}
				lancamento.setPlanoContaEJB(planoMov);

				CentroCustoContabilEJB ccc = new CentroCustoContabilEJB();
				ccc.setIdCentroCustoContabil("D".equals(lancPadrao
						.getDebitoCredito()) ? lancPadrao
						.getCentroCustoDebito().getIdCentroCustoContabil() : lancPadrao
						.getCentroCustoCredito().getIdCentroCustoContabil());
				idx = -1;
				if ((idx = super.getCentroCustoList().indexOf(ccc)) >= 0) {
					ccc = (CentroCustoContabilEJB) super.getCentroCustoList()
							.get(idx);
				} else {
					ccc = null;
				}
				lancamento.setCentroCustoContabilEJB(ccc);

				lancamento.setPis(lancPadrao.getPis() == null ? "N"
						: lancPadrao.getPis());
				lancamento.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
						.getIdRedeHotel());
				lancamento.setNumDocumento("LANC");
				lancamento.setValor(

				Double.valueOf(this.entidadeCP.getValorBruto().doubleValue()
						* lancPadrao.getPercentual().doubleValue() / 100.0D));
				lancamento.setTipoMovimento("M");
				lancamento.setLancarContasPagarCredito("N");

				entidade.addMovimentoContabilEJBList(lancamento);
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			resetLancamento();
		}
		return SUCESSO_FORWARD;
	}

	public String excluirLancamento() {
		try {
			sincronizarLancamento();

			ContasPagarEJB entidadeSession = (ContasPagarEJB) this.request
					.getSession().getAttribute("entidadeSession");
			entidadeSession.getMovimentoContabilEJBList().remove(
					this.indice.intValue());
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			resetLancamento();
		}
		return SUCESSO_FORWARD;
	}

	public String incluirLancamento() {
		try {
			sincronizarLancamento();
			ContasPagarEJB entidadeSession = (ContasPagarEJB) this.request
					.getSession().getAttribute("entidadeSession");
			MovimentoContabilEJB lancamento = new MovimentoContabilEJB();
			lancamento
					.setLancarContasPagarCredito(this.lancarContasPagarCredito[0]);
			lancamento.setControleAtivoFixo(this.controleAtivo[0]);
			lancamento.setDebitoCredito(this.debitoCredito[0]);

			lancamento.setIdHotel(getIdHoteis()[0]);

			PlanoContaVO plano = new PlanoContaVO();
			plano.setIdPlanoContas(this.idPlanoContas[0]);
			PlanoContaEJB planoMov = null;
			int idx = -1;
			if ((idx = getPlanoContaList().indexOf(plano)) >= 0) {
				plano = (PlanoContaVO) getPlanoContaList().get(idx);
				planoMov = new PlanoContaEJB();
				planoMov.setIdPlanoContas(plano.getIdPlanoContas());
				planoMov.setContaContabil(plano.getContaContabil());
				planoMov.setAtivoPassivo(plano.getAtivoPassivo());
				planoMov.setNomeConta(plano.getNomeConta());
			}
			lancamento.setPlanoContaEJB(planoMov);

			HistoricoContabilEJB historico = new HistoricoContabilEJB();
			historico.setIdHistorico(this.idHistoricoContabil[0]);
			idx = -1;
			if ((idx = this.historicoList.indexOf(historico)) >= 0) {
				historico = (HistoricoContabilEJB) this.historicoList.get(idx);
			} else {
				historico = null;
			}
			lancamento.setHistoricoContabilEJB(historico);

			CentroCustoContabilEJB ccc = new CentroCustoContabilEJB();
			ccc.setIdCentroCustoContabil(this.idCentroCusto[0]);
			idx = -1;
			if ((idx = super.getCentroCustoList().indexOf(ccc)) >= 0) {
				ccc = (CentroCustoContabilEJB) super.getCentroCustoList().get(
						idx);
			} else {
				ccc = null;
			}
			lancamento.setCentroCustoContabilEJB(ccc);

			lancamento.setPis(this.pis[0]);
			lancamento.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			lancamento.setNumDocumento(this.complementoHistorico[0]);
			lancamento.setValor(this.valorLancamento[0]);
			lancamento.setTipoMovimento("M");
			entidadeSession.addMovimentoContabilEJBList(lancamento);
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			resetLancamento();
		}
		return SUCESSO_FORWARD;
	}

	private void resetLancamento() {
		this.idClassificacaoPadrao = null;
		this.idContaFinanceira = null;
		this.idContaCredito = null;

		this.debitoCredito[0] = "D";
		this.pis[0] = "S";
		this.idPlanoContas[0] = new Long(-1L);
		this.idPlanoContas2[0] = new Long(-1L);
		this.controleAtivo[0] = new Long(-1L);
		this.idHistoricoContabil[0] = new Long(-1L);
		this.complementoHistorico[0] = "";
		this.valorLancamento[0] = new Double(0.0D);
		this.idCentroCusto[0] = new Long(-1L);
		this.lancarContasPagarCredito[0] = "N";
	}

	public String prepararLancamento() {
		try {
			initComboLancamento();
		} catch (MozartSessionException e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD;
	}

	public String prepararInclusao() {
		try {
			initCombo();
			prepararPesquisa();
			this.entidadeCP = new ContasPagarEJB();
			this.entidadeCP.setPago("N");
			this.entidadeCP.setSituacao("A");
			this.entidadeCP.setInternet("N");
			this.entidadeCP.setNumParcelas(Long.parseLong("1"));
			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUsuario());
			this.entidadeCP.setNumDocumento(FinanceiroDelegate.instance()
					.obterProximoContasPagar(hotel));
			for (ContaCorrenteVO cc : getContaCorrenteList()) {
				if ("S".equals(cc.getPagamento())) {
					this.entidadeCP.setContaCorrente(cc.getIdContaCorrente());
					break;
				}
			}
			this.entidadeCP.setDataEmissao(getControlaData().getContasPagar());
			this.request.getSession().setAttribute("entidadeSession",
					this.entidadeCP);
		} catch (Exception exc) {
			error(exc.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD;
	}

	protected void initComboLancamento() throws MozartSessionException {
		initCombo();
		initComboContasReceber();

		this.debitoCreditoList = new ArrayList();
		this.debitoCreditoList.add(new MozartComboWeb("C", "Crédito"));
		this.debitoCreditoList.add(new MozartComboWeb("D", "Débito"));

		HistoricoContabilEJB filtro = new HistoricoContabilEJB();
		filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
				.getIdRedeHotel());
		this.historicoList = FinanceiroDelegate.instance()
				.obterHistoricoContabil(filtro);
	}

	protected void initCombo() throws MozartSessionException {
		super.initCombo();
		initComboContasReceber();

		ClassificacaoContabilVO filtroCC = new ClassificacaoContabilVO();
		filtroCC.setIdHoteis(getIdHoteis());
		this.classificacaoPadraoList = FinanceiroDelegate.instance()
				.obterClassificacaoContabil(filtroCC);

		PlanoContaVO filtroPlanoConta = new PlanoContaVO();
		filtroPlanoConta.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
				.getIdRedeHotel());
		filtroPlanoConta.getFiltroTipoConta().setTipo("C");
		filtroPlanoConta.getFiltroTipoConta().setTipoIntervalo("2");
		filtroPlanoConta.getFiltroTipoConta().setValorInicial("Analitico");

		filtroPlanoConta.getFiltroAtivoPassivo().setTipo("C");
		filtroPlanoConta.getFiltroAtivoPassivo().setTipoIntervalo("2");
		filtroPlanoConta.getFiltroAtivoPassivo().setValorInicial("O");
		this.planoContaFinanceiroList = RedeDelegate.instance()
				.pesquisarPlanoConta(filtroPlanoConta);

		filtroPlanoConta = new PlanoContaVO();
		filtroPlanoConta.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
				.getIdRedeHotel());
		filtroPlanoConta.getFiltroTipoConta().setTipo("C");
		filtroPlanoConta.getFiltroTipoConta().setTipoIntervalo("2");
		filtroPlanoConta.getFiltroTipoConta().setValorInicial("Analitico");

		filtroPlanoConta.getFiltroAtivoPassivo().setTipo("C");
		filtroPlanoConta.getFiltroAtivoPassivo().setTipoIntervalo("2");
		filtroPlanoConta.getFiltroAtivoPassivo().setValorInicial("P");
		this.planoContaCreditoList = RedeDelegate.instance()
				.pesquisarPlanoConta(filtroPlanoConta);
	}

	public String prepararPesquisa() {
		this.request.setAttribute("filtro.filtroDataLancamento.tipoIntervalo",
				"1");
		this.request.setAttribute("filtro.filtroDataLancamento.valorInicial",
				MozartUtil.format(getControlaData().getContasPagar(),
						"dd/MM/yyyy"));
		this.request.setAttribute("filtro.filtroDataLancamento.valorFinal",
				MozartUtil.format(getControlaData()
						.getContasPagar(), "dd/MM/yyyy"));
		this.request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}

	public String pesquisar() {
		info("Pesquisar contas a receber");
		try {
//			if ((("2".equals(this.filtro.getFiltroTipoPesquisa())) || ("3"
//					.equals(this.filtro.getFiltroTipoPesquisa())))
//					&& (MozartUtil.isNull(this.filtro.getFiltroDataLancamento()
//							.getTipoIntervalo()))) {
//				addMensagemSucesso("O campo 'Dt lançamento' é obrigatório.");
//				return SUCESSO_FORWARD;
//			}
			this.filtro.setIdHoteis(getIdHoteis());
			List<ContasPagarVO> listaPesquisa = FinanceiroDelegate.instance()
					.pesquisarContasPagar(this.filtro);
			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}
			this.request.getSession().setAttribute("listaPesquisa",
					listaPesquisa);
		} catch (Exception exc) {
			error(exc.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD;
	}
	
	public String downloadDocumento() throws Exception {
		this.entidadeCP = ((ContasPagarEJB) CheckinDelegate.instance()
				.obter(ContasPagarEJB.class, this.entidadeCP.getIdContasPagar()));
		
		documentoStream = new ByteArrayInputStream(this.entidadeCP.getArquivoDocumento());
		documentoFileName = this.entidadeCP.getNomeDocumento();
		
	    return SUCCESS;
	}

	public ContasPagarVO getFiltro() {
		return this.filtro;
	}

	public void setFiltro(ContasPagarVO filtro) {
		this.filtro = filtro;
	}

	public ContasPagarEJB getEntidadeCP() {
		return this.entidadeCP;
	}

	public void setEntidadeCP(ContasPagarEJB entidade) {
		this.entidadeCP = entidade;
	}

	public Long getIdClassificacaoPadrao() {
		return this.idClassificacaoPadrao;
	}

	public void setIdClassificacaoPadrao(Long idClassificacaoPadrao) {
		this.idClassificacaoPadrao = idClassificacaoPadrao;
	}

	public Long getIdContaFinanceira() {
		return this.idContaFinanceira;
	}

	public void setIdContaFinanceira(Long idContaFinanceira) {
		this.idContaFinanceira = idContaFinanceira;
	}

	public Long getIdContaCredito() {
		return this.idContaCredito;
	}

	public void setIdContaCredito(Long idContaCredito) {
		this.idContaCredito = idContaCredito;
	}

	public List<MozartComboWeb> getDebitoCreditoList() {
		return this.debitoCreditoList;
	}

	public void setDebitoCreditoList(List<MozartComboWeb> debitoCreditoList) {
		this.debitoCreditoList = debitoCreditoList;
	}

	public List<HistoricoContabilEJB> getHistoricoList() {
		return this.historicoList;
	}

	public void setHistoricoList(List<HistoricoContabilEJB> historicoList) {
		this.historicoList = historicoList;
	}

	public List<PlanoContaVO> getPlanoContaFinanceiroList() {
		return this.planoContaFinanceiroList;
	}

	public void setPlanoContaFinanceiroList(
			List<PlanoContaVO> planoContaFinanceiroList) {
		this.planoContaFinanceiroList = planoContaFinanceiroList;
	}

	public List<PlanoContaVO> getPlanoContaCreditoList() {
		return this.planoContaCreditoList;
	}

	public void setPlanoContaCreditoList(
			List<PlanoContaVO> planoContaCreditoList) {
		this.planoContaCreditoList = planoContaCreditoList;
	}

	public List<ClassificacaoContabilVO> getClassificacaoPadraoList() {
		return this.classificacaoPadraoList;
	}

	public void setClassificacaoPadraoList(
			List<ClassificacaoContabilVO> classificacaoPadraoList) {
		this.classificacaoPadraoList = classificacaoPadraoList;
	}

	public Long getIndice() {
		return this.indice;
	}

	public void setIndice(Long indice) {
		this.indice = indice;
	}

	public Long[] getIdContasPagar() {
		return this.idContasPagar;
	}

	public void setIdContasPagar(Long[] idContasPagar) {
		this.idContasPagar = idContasPagar;
	}

	public List<ContasPagarEJB> getParcelasCP() {
		return this.parcelasCP;
	}

	public void setParcelasCP(List<ContasPagarEJB> parcelasCP) {
		this.parcelasCP = parcelasCP;
	}

	public boolean isPossuiClassificacaoContabil() {
		return this.possuiClassificacaoContabil;
	}

	public void setPossuiClassificacaoContabil(
			boolean possuiClassificacaoContabil) {
		this.possuiClassificacaoContabil = possuiClassificacaoContabil;
	}

	public String getClassificacaoPadrao() {
		return this.classificacaoPadrao;
	}

	public void setClassificacaoPadrao(String classificacaoPadrao) {
		this.classificacaoPadrao = classificacaoPadrao;
	}

	public String[] getDebitoCredito() {
		return this.debitoCredito;
	}

	public void setDebitoCredito(String[] debitoCredito) {
		this.debitoCredito = debitoCredito;
	}

	public String[] getPis() {
		return this.pis;
	}

	public void setPis(String[] pis) {
		this.pis = pis;
	}

	public String[] getComplementoHistorico() {
		return this.complementoHistorico;
	}

	public void setComplementoHistorico(String[] complementoHistorico) {
		this.complementoHistorico = complementoHistorico;
	}

	public String[] getLancarContasPagarCredito() {
		return this.lancarContasPagarCredito;
	}

	public void setLancarContasPagarCredito(String[] lancarContasPagarCredito) {
		this.lancarContasPagarCredito = lancarContasPagarCredito;
	}

	public Long[] getIdPlanoContas() {
		return this.idPlanoContas;
	}

	public void setIdPlanoContas(Long[] idPlanoContas) {
		this.idPlanoContas = idPlanoContas;
	}

	public Long[] getIdPlanoContas2() {
		return this.idPlanoContas2;
	}

	public void setIdPlanoContas2(Long[] idPlanoContasNome) {
		this.idPlanoContas2 = idPlanoContasNome;
	}

	public Long[] getControleAtivo() {
		return this.controleAtivo;
	}

	public void setControleAtivo(Long[] controleAtivo) {
		this.controleAtivo = controleAtivo;
	}

	public Long[] getIdHistoricoContabil() {
		return this.idHistoricoContabil;
	}

	public void setIdHistoricoContabil(Long[] idHistoricoContabil) {
		this.idHistoricoContabil = idHistoricoContabil;
	}

	public Long[] getIdCentroCusto() {
		return this.idCentroCusto;
	}

	public void setIdCentroCusto(Long[] idCentroCusto) {
		this.idCentroCusto = idCentroCusto;
	}

	public Double[] getValorLancamento() {
		return this.valorLancamento;
	}

	public void setValorLancamento(Double[] valorLancamento) {
		this.valorLancamento = valorLancamento;
	}

	public boolean isOperacaoRealizada() {
		return this.operacaoRealizada;
	}

	public void setOperacaoRealizada(boolean operacaoRealizada) {
		this.operacaoRealizada = operacaoRealizada;
	}

	public String getMensagemPai() {
		return this.mensagemPai;
	}

	public void setMensagemPai(String mensagemPai) {
		this.mensagemPai = mensagemPai;
	}

	public boolean isPodeGravar() {
		return this.podeGravar;
	}

	public void setPodeGravar(boolean podeGravar) {
		this.podeGravar = podeGravar;
	}

	public String getNumCheque() {
		return this.numCheque;
	}

	public void setNumCheque(String numCheque) {
		this.numCheque = numCheque;
	}

	public String getPortador() {
		return this.portador;
	}

	public void setPortador(String portador) {
		this.portador = portador;
	}

	public Long getContaCorrente() {
		return this.contaCorrente;
	}

	public void setContaCorrente(Long contaCorrente) {
		this.contaCorrente = contaCorrente;
	}
	
    public void setDocumento(File documento) {
    	this.documento = documento;
    }

	public void setDocumentoContentType(String contentType) {
	    this.contentType = contentType;
	}

	public void setDocumentoFileName(String filename) {
		this.documentoFileName = filename;
	}

	public InputStream getDocumentoStream() {
		return documentoStream;
	}
	
	public String getContentDisposition(){
		return "attachment;filename='" + documentoFileName + "'";
	}
}