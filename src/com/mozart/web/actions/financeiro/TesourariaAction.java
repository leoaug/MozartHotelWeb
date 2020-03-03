package com.mozart.web.actions.financeiro;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import com.mozart.model.delegate.AlfaDelegate;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.ClassificacaoContabilEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HistoricoContabilEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.MovimentoContabilEJB;
import com.mozart.model.ejb.entity.PlanoContaEJB;
import com.mozart.model.ejb.entity.TesourariaEJB;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.PlanoContaVO;
import com.mozart.model.vo.TesourariaVO;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings("unchecked")
public class TesourariaAction extends ContasPagarAction {
	private static final long serialVersionUID = -34901774201468997L;
	protected String status;
	protected long seqContabil;
	protected TesourariaVO filtro;
	private TesourariaEJB entidadeT;
	private Long idPlanoContasFinanceiro;
	private Long indice;
	private String[] debitoCreditoTes;
	private String[] complementoTes;
	private String[] pisTes;
	private Long[] idPlanoContaTes;
	private Long[] idPlanoContaNomeTes;
	private Long[] controleAtivoTes;
	private Long[] contaCorrenteTes;
	private Long[] idHistoricoTes;
	private Long[] idCentroCustoTes;
	private Long[] idMovimento;
	private Double[] valorTes;
	private String contaCorrenteTxt;
	private Double valorPadrao;
	private Integer diaLancamento;
	protected String origemMovimento;
	private Long[] idTesouraria;
	private Timestamp[] dataConciliacao;
	private List<MozartComboWeb> diaLancamentoList;
	private Integer[] indiceIdTesouraria;
	protected Timestamp dataLancamento;

	public TesourariaAction() {
		this.filtro = new TesourariaVO();
		this.entidadeT = new TesourariaEJB();
		this.diaLancamentoList = new ArrayList();
	}

	public String obterClassificacaoPadrao() {
		try {
			super.initComboLancamento();
			resetLancamento();
			ClassificacaoContabilEJB filtro = new ClassificacaoContabilEJB();
			filtro.setIdHotel(getIdHoteis()[0]);
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			filtro.setDescricao(getClassificacaoPadrao());
			List<ClassificacaoContabilEJB> classPadrao = FinanceiroDelegate
					.instance().obterClassificacaoContabilPadrao(filtro);

			List<MovimentoContabilEJB> entidade = (List) this.request
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
				lancamento.setValor(Double.valueOf(this.valorPadrao
						.doubleValue()
						* lancPadrao.getPercentual().doubleValue() / 100.0D));
				if ("CONTABILIDADE".equals(this.origemMovimento)) {
					lancamento.setTipoMovimento("M");
				} else {
					lancamento.setTipoMovimento("A");
				}
				if (lancPadrao.getContaCorrente() != null) {
					lancamento.setContaCorrente(lancPadrao.getContaCorrente().getId());
					this.contaCorrenteTxt = lancPadrao.getContaCorrente()
							.toString();
					lancamento.setContaCorrenteTxt(this.contaCorrenteTxt);
				}
				entidade.add(lancamento);
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String gravar() {
		try {
			sincronizarLancamento();
			List<MovimentoContabilEJB> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");
			List<MovimentoContabilEJB> movimentoSemTesourariaList = new ArrayList();
			List<TesourariaEJB> tesourariaList = new ArrayList();

			int mes = MozartUtil.getMes(this.dataLancamento);
			int ano = MozartUtil.getAno(this.dataLancamento);
			Calendar cal = Calendar.getInstance();
			cal.set(5, this.diaLancamento.intValue());
			cal.set(2, mes - 1);
			cal.set(1, ano);
			
			Long seqContabilVal = this.seqContabil > 0 ? this.seqContabil : AlfaDelegate.instance().obterNextSequence("mozart.seq_contabil");
			
			for (MovimentoContabilEJB lancamento : entidade) {
				lancamento.setIdSeqContabil(seqContabilVal);
				lancamento.setDataDocumento(new Timestamp(cal.getTime()
						.getTime()));
				if ((MozartUtil.isNull(lancamento.getContaCorrente()))
						|| (new Long("-1")
								.equals(lancamento.getContaCorrente()))) {
					lancamento.setContaCorrente(null);
					movimentoSemTesourariaList.add(lancamento);
				} else {
					TesourariaEJB novaTesouraria = new TesourariaEJB();
					novaTesouraria.setComplementoHistorico(lancamento
							.getNumDocumento());
					novaTesouraria.setConciliado("N");
					novaTesouraria.setContaCorrente(lancamento
							.getContaCorrente());
					novaTesouraria.setDataConciliado(null);
					novaTesouraria.setDataLancamento(new Timestamp(cal
							.getTime().getTime()));
					novaTesouraria.setDebitoCredito(lancamento
							.getDebitoCredito());
					if (lancamento.getHistoricoContabilEJB() != null) {
						novaTesouraria.setIdHistorico(lancamento
								.getHistoricoContabilEJB().getIdHistorico());
					}
					novaTesouraria.setIdHotel(getHotelCorrente().getIdHotel());
					novaTesouraria.setIdPlanoContas(lancamento
							.getPlanoContaEJB().getIdPlanoContas());
					novaTesouraria
							.setIdPlanoContasFinanceiro(this.idPlanoContasFinanceiro);
					novaTesouraria.setIdRedeHotel(getHotelCorrente()
							.getRedeHotelEJB().getIdRedeHotel());
					novaTesouraria
							.setNumDocumento(lancamento.getNumDocumento());
					novaTesouraria.setTipoMovimentacao("M");
					novaTesouraria.setValor(lancamento.getValor());
					novaTesouraria.addMovimentoContabilEJB(lancamento);
					tesourariaList.add(novaTesouraria);
				}
			}
			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUsuario());
			FinanceiroDelegate.instance().gravarTesouraria(hotel,
					tesourariaList, movimentoSemTesourariaList,
					this.origemMovimento);
			this.operacaoRealizada = true;
			this.mensagemPai = "Operação realizada com sucesso.";
			prepararInclusao();
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			this.mensagemPai = ex.getMessage();
			addMensagemErro("Erro ao realizar operação.");
		} catch (Exception ex) {
			error(ex.getMessage());
			this.mensagemPai = ex.getMessage();
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			resetLancamento();
		}
		return "sucesso";
	}

	private void sincronizarLancamento() throws Exception {
		super.initComboLancamento();
		List<MovimentoContabilEJB> entidade = (List) this.request.getSession()
				.getAttribute("entidadeSession");
		int x = 1;
		for (MovimentoContabilEJB lancamento : entidade) {
			lancamento.setIdMovimentoContabil((this.idMovimento[x] == null)
					|| (this.idMovimento[x].longValue() == -1L) ? null
					: this.idMovimento[x]);
			lancamento.setControleAtivoFixo(this.controleAtivoTes[x]);
			lancamento.setDebitoCredito(this.debitoCreditoTes[x]);
			lancamento.setIdHotel(getIdHoteis()[0]);

			PlanoContaVO plano = new PlanoContaVO();
			plano.setIdPlanoContas(this.idPlanoContaTes[x]);
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
			if (!MozartUtil.isNull(this.idHistoricoTes[x])) {
				HistoricoContabilEJB historico = new HistoricoContabilEJB();
				historico.setIdHistorico(this.idHistoricoTes[x]);
				idx = -1;
				if ((idx = getHistoricoList().indexOf(historico)) >= 0) {
					historico = (HistoricoContabilEJB) getHistoricoList().get(
							idx);
				} else {
					historico = null;
				}
				lancamento.setHistoricoContabilEJB(historico);
			}
			if (!MozartUtil.isNull(this.idCentroCustoTes[x])) {
				CentroCustoContabilEJB ccc = new CentroCustoContabilEJB();
				ccc.setIdCentroCustoContabil(this.idCentroCustoTes[x]);
				idx = -1;
				if ((idx = super.getCentroCustoList().indexOf(ccc)) >= 0) {
					ccc = (CentroCustoContabilEJB) super.getCentroCustoList()
							.get(idx);
				} else {
					ccc = null;
				}
				lancamento.setCentroCustoContabilEJB(ccc);
			}
			lancamento.setPis(this.pisTes[x]);
			lancamento.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			lancamento.setNumDocumento(this.complementoTes[x]);
			lancamento.setValor(this.valorTes[x]);
			if ("CONTABILIDADE".equals(this.origemMovimento)) {
				lancamento.setTipoMovimento("M");
			} else {
				lancamento.setTipoMovimento("A");
			}
			lancamento.setContaCorrente(this.contaCorrenteTes[x]);
			lancamento.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			x++;
		}
	}

	public String pesquisar() {
		warn("Pesquisando tesouraria");
		try {
			prepararPesquisa();
			this.filtro.setIdHoteis(getIdHoteis());
			this.filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			List<TesourariaVO> listaPesquisa = FinanceiroDelegate.instance()
					.pesquisarTesouraria(this.filtro);
			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}
			this.request.getSession().setAttribute("listaPesquisa",
					listaPesquisa);
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararAlteracao() {
		return "sucesso";
	}

	public String prepararInclusao() {
		try {
			this.status = "";
			this.seqContabil = 0L;
			initCombo();
			prepararPesquisa();
			this.dataLancamento = getControlaData().getTesouraria();
			List<MovimentoContabilEJB> entidade = new ArrayList();
			this.request.getSession().setAttribute("entidadeSession", entidade);
			int mes = MozartUtil.getMes(this.dataLancamento);
			int ano = MozartUtil.getAno(this.dataLancamento);
			Calendar cal = Calendar.getInstance();
			cal.set(5, 1);
			cal.set(2, mes - 1);
			cal.set(1, ano);
			int diaFim = cal.getActualMaximum(5);
			int diaInicio = 1;
			while (diaInicio <= diaFim) {
				this.diaLancamentoList.add(new MozartComboWeb(String
						.valueOf(diaInicio), MozartUtil.lpad(String
						.valueOf(diaInicio), "0", 2)));
				diaInicio++;
			}
		} catch (Exception exc) {
			error(exc.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String excluirLancamento() {
		try {
			sincronizarLancamento();
			List<MovimentoContabilEJB> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");
			entidade.remove(this.indice.intValue());
			resetLancamento();
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	private void resetLancamento() {
		this.debitoCreditoTes[0] = "";
		this.complementoTes[0] = "";
		this.pisTes[0] = "";
		this.idPlanoContaTes[0] = new Long(-1L);
		this.idPlanoContaNomeTes[0] = new Long(-1L);
		this.controleAtivoTes[0] = new Long(0L);
		this.contaCorrenteTes[0] = new Long(-1L);
		this.idHistoricoTes[0] = new Long(-1L);
		this.idCentroCustoTes[0] = new Long(-1L);
		this.valorTes[0] = new Double(0.0D);
		this.idMovimento[0] = new Long(-1L);
	}

	public String incluirLancamento() {
		try {
			sincronizarLancamento();

			List<MovimentoContabilEJB> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

			MovimentoContabilEJB lancamento = new MovimentoContabilEJB();

			lancamento.setControleAtivoFixo(this.controleAtivoTes[0]);
			lancamento.setDebitoCredito(this.debitoCreditoTes[0]);
			lancamento.setIdHotel(getIdHoteis()[0]);

			PlanoContaVO plano = new PlanoContaVO();
			plano.setIdPlanoContas(this.idPlanoContaTes[0]);
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
			historico.setIdHistorico(this.idHistoricoTes[0]);
			idx = -1;
			if ((idx = getHistoricoList().indexOf(historico)) >= 0) {
				historico = (HistoricoContabilEJB) getHistoricoList().get(idx);
			} else {
				historico = null;
			}
			lancamento.setHistoricoContabilEJB(historico);

			CentroCustoContabilEJB ccc = new CentroCustoContabilEJB();
			ccc.setIdCentroCustoContabil(this.idCentroCustoTes[0]);
			idx = -1;
			if ((idx = super.getCentroCustoList().indexOf(ccc)) >= 0) {
				ccc = (CentroCustoContabilEJB) super.getCentroCustoList().get(
						idx);
			} else {
				ccc = null;
			}
			lancamento.setCentroCustoContabilEJB(ccc);

			lancamento.setPis(this.pisTes[0]);
			lancamento.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			lancamento.setNumDocumento(this.complementoTes[0]);
			lancamento.setValor(this.valorTes[0]);
			if ("CONTABILIDADE".equals(this.origemMovimento)) {
				lancamento.setTipoMovimento("M");
			} else {
				lancamento.setTipoMovimento("A");
			}
			lancamento.setContaCorrente(this.contaCorrenteTes[0]);
			lancamento.setContaCorrenteTxt(this.contaCorrenteTxt);
			entidade.add(lancamento);

			this.indice = null;
			resetLancamento();
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararPesquisa() {
		this.request.getSession().removeAttribute("listaPesquisa");
		return "sucesso";
	}

	public String prepararConciliacao() {
		return "sucesso";
	}

	public String conciliarTesouraria() {
		info("Iniciando a conciliacao da tesouraria");
		try {
			if ((this.indiceIdTesouraria == null)
					|| (this.indiceIdTesouraria.length == 0)) {
				addMensagemSucesso("Informe um título para efetuar a conciliação");
				return "sucesso";
			}
			List<TesourariaVO> listaPesquisa = (List) this.request.getSession()
					.getAttribute("listaPesquisa");
			List<TesourariaVO> listaConciliacao = new ArrayList();
			TesourariaVO rec = null;
			for (int x = 0; x < this.indiceIdTesouraria.length; x++) {
				rec = new TesourariaVO();
				rec
						.setIdTesouraria(this.idTesouraria[this.indiceIdTesouraria[x]
								.intValue()]);
				if (listaPesquisa.contains(rec)) {
					rec = (TesourariaVO) listaPesquisa.get(listaPesquisa
							.indexOf(rec));
					rec
							.setDataConciliado(this.dataConciliacao[this.indiceIdTesouraria[x]
									.intValue()]);
					listaConciliacao.add(rec);
				}
			}
			rec.setUsuario(getUsuario());
			rec.setIdHoteis(getIdHoteis());
			FinanceiroDelegate.instance().conciliarTesouraria(rec,
					listaConciliacao);
			for (TesourariaVO add : listaConciliacao) {
				listaPesquisa.remove(add);
			}
			return "sucesso";
		} catch (MozartValidateException e) {
			error(e.getMessage());
			addMensagemSucesso(e.getMessage());
			return "sucesso";
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararRelatorio() {
		return "sucesso";
	}

	public String encerrar() {
		try {
			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUserSession().getUsuarioEJB());
			FinanceiroDelegate.instance().encerrarTesouraria(hotel);
			ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
					.obter(ControlaDataEJB.class, getIdHoteis()[0]);
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			prepararEncerramento();
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
			return "sucesso";
		} catch (Exception ex) {
			prepararEncerramento();
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			return "sucesso";
		}
		return "pesquisa";
	}

	public String prepararEncerramento() {
		return "sucesso";
	}

	public String prepararLancamento() {
		this.dataLancamento = getControlaData().getTesouraria();
		super.prepararLancamento();
		return "sucesso";
	}

	public TesourariaVO getFiltro() {
		return this.filtro;
	}

	public void setFiltro(TesourariaVO filtro) {
		this.filtro = filtro;
	}

	public TesourariaEJB getEntidadeT() {
		return this.entidadeT;
	}

	public void setEntidadeT(TesourariaEJB entidade) {
		this.entidadeT = entidade;
	}

	public Long getIdPlanoContasFinanceiro() {
		return this.idPlanoContasFinanceiro;
	}

	public void setIdPlanoContasFinanceiro(Long idPlanoContasFinanceiro) {
		this.idPlanoContasFinanceiro = idPlanoContasFinanceiro;
	}

	public Long getIndice() {
		return this.indice;
	}

	public void setIndice(Long indice) {
		this.indice = indice;
	}

	public String[] getDebitoCreditoTes() {
		return this.debitoCreditoTes;
	}

	public void setDebitoCreditoTes(String[] debitoCreditoTes) {
		this.debitoCreditoTes = debitoCreditoTes;
	}

	public String[] getComplementoTes() {
		return this.complementoTes;
	}

	public void setComplementoTes(String[] complementoTes) {
		this.complementoTes = complementoTes;
	}

	public Long[] getIdPlanoContaTes() {
		return this.idPlanoContaTes;
	}

	public void setIdPlanoContaTes(Long[] idPlanoContaTes) {
		this.idPlanoContaTes = idPlanoContaTes;
	}

	public Long[] getIdPlanoContaNomeTes() {
		return this.idPlanoContaNomeTes;
	}

	public void setIdPlanoContaNomeTes(Long[] idPlanoContaNomeTes) {
		this.idPlanoContaNomeTes = idPlanoContaNomeTes;
	}

	public Long[] getContaCorrenteTes() {
		return this.contaCorrenteTes;
	}

	public void setContaCorrenteTes(Long[] contaCorrenteTes) {
		this.contaCorrenteTes = contaCorrenteTes;
	}

	public Long[] getIdHistoricoTes() {
		return this.idHistoricoTes;
	}

	public void setIdHistoricoTes(Long[] idHistoricoTes) {
		this.idHistoricoTes = idHistoricoTes;
	}

	public Long[] getIdCentroCustoTes() {
		return this.idCentroCustoTes;
	}

	public void setIdCentroCustoTes(Long[] idCentroCustoTes) {
		this.idCentroCustoTes = idCentroCustoTes;
	}

	public Double[] getValorTes() {
		return this.valorTes;
	}

	public void setValorTes(Double[] valorTes) {
		this.valorTes = valorTes;
	}

	public Long[] getControleAtivoTes() {
		return this.controleAtivoTes;
	}

	public void setControleAtivoTes(Long[] controleAtivoTes) {
		this.controleAtivoTes = controleAtivoTes;
	}

	public String getContaCorrenteTxt() {
		return this.contaCorrenteTxt;
	}

	public void setContaCorrenteTxt(String contaCorrenteTxt) {
		this.contaCorrenteTxt = contaCorrenteTxt;
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

	public Double getValorPadrao() {
		return this.valorPadrao;
	}

	public void setValorPadrao(Double valorPadrao) {
		this.valorPadrao = valorPadrao;
	}

	public Long[] getIdTesouraria() {
		return this.idTesouraria;
	}

	public void setIdTesouraria(Long[] idTesouraria) {
		this.idTesouraria = idTesouraria;
	}

	public Timestamp[] getDataConciliacao() {
		return this.dataConciliacao;
	}

	public void setDataConciliacao(Timestamp[] dataConciliacao) {
		this.dataConciliacao = dataConciliacao;
	}

	public List<MozartComboWeb> getDiaLancamentoList() {
		return this.diaLancamentoList;
	}

	public void setDiaLancamentoList(List<MozartComboWeb> diaLancamentoList) {
		this.diaLancamentoList = diaLancamentoList;
	}

	public Integer getDiaLancamento() {
		return this.diaLancamento;
	}

	public void setDiaLancamento(Integer diaLancamento) {
		this.diaLancamento = diaLancamento;
	}

	public Timestamp getDataLancamento() {
		return this.dataLancamento;
	}

	public void setDataLancamento(Timestamp dataLancamento) {
		this.dataLancamento = dataLancamento;
	}

	public String getOrigemMovimento() {
		return this.origemMovimento;
	}

	public void setOrigemMovimento(String origemMovimento) {
		this.origemMovimento = origemMovimento;
	}

	public String[] getPisTes() {
		return this.pisTes;
	}

	public void setPisTes(String[] pisTes) {
		this.pisTes = pisTes;
	}

	public Long[] getIdMovimento() {
		return this.idMovimento;
	}

	public void setIdMovimento(Long[] idMovimento) {
		this.idMovimento = idMovimento;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Integer[] getIndiceIdTesouraria() {
		return this.indiceIdTesouraria;
	}

	public void setIndiceIdTesouraria(Integer[] indiceIdTesouraria) {
		this.indiceIdTesouraria = indiceIdTesouraria;
	}

	public long getSeqContabil() {
		return seqContabil;
	}

	public void setSeqContabil(long seqContabil) {
		this.seqContabil = seqContabil;
	}
}