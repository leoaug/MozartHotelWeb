package com.mozart.web.actions.financeiro;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ControladoriaDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.DuplicataEJB;
import com.mozart.model.ejb.entity.DuplicataTempEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJBPK;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ContaCorrenteVO;
import com.mozart.model.vo.DuplicataVO;
import com.mozart.web.actions.BaseAction;

@SuppressWarnings("unchecked")
public class FaturamentoAction extends BaseAction {
	private String origemParcelamento;
	private boolean bClassificacaoContabil = true;
	private boolean bDuplicataAFaturar = true;
	private boolean bDataFaturamento = true;
	private Double[] valorDuplicata;
	private Double[] encargos;
	private Double[] comissao;
	private Double[] ir;
	private Double[] ajustes;
	private Timestamp[] dataVencimento;
	private List<DuplicataEJB> parcelas;
	private Long qtdeParcela;
	private Long[] idDuplicata;
	private List<ContaCorrenteVO> contaCorrenteList;
	private DuplicataTempEJB entidadeTemp;
	protected DuplicataEJB entidade;
	protected DuplicataVO filtro;
	private static final long serialVersionUID = -1537519603116944983L;

	public FaturamentoAction() {
		this.filtro = new DuplicataVO();
	}

	public String prepararRelatorio() {
		return "sucesso";
	}

	public String prepararEncerramento() {
		try {
			List listaValidacao = FinanceiroDelegate.instance().obterValidacao(
					getHotelCorrente().getIdHotel());
			this.bDataFaturamento = (((BigDecimal) listaValidacao.get(0))
					.longValue() > 0L);
			this.bDuplicataAFaturar = (((BigDecimal) listaValidacao.get(1))
					.longValue() == 0L);
			this.bClassificacaoContabil = (((BigDecimal) listaValidacao.get(2))
					.longValue() > 0L);
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String encerrar() {
		try {
			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUserSession().getUsuarioEJB());
			FinanceiroDelegate.instance().encerrarFaturamento(hotel);
			ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
					.obter(ControlaDataEJB.class, getIdHoteis()[0]);
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
			return prepararEncerramento();
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			return prepararEncerramento();
		}
		return "pesquisa";
	}

	public String gravarParcelamento() {
		try {
			dividirDuplicata();
			this.entidade.setUsuario(getUserSession().getUsuarioEJB());
			FinanceiroDelegate.instance().gravarParcelamento(this.entidade,
					this.parcelas);
			prepararPesquisa();
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			return "sucesso";
		}
		return "pesquisa";
	}

	public String dividirDuplicata() {
		try {
			if ((this.dataVencimento != null)
					&& (this.dataVencimento.length != this.qtdeParcela
							.longValue())) {
				this.dataVencimento = null;
				this.ajustes = null;
				this.ir = null;
				this.comissao = null;
				this.encargos = null;
				this.valorDuplicata = null;
			}
			this.entidade = ((DuplicataEJB) CheckinDelegate.instance().obter(
					DuplicataEJB.class, this.entidade.getIdDuplicata()));
			if (MozartUtil.isNull(this.entidade.getAjustes())) {
				this.entidade.setAjustes(new Double(0.0D));
			}
			if (MozartUtil.isNull(this.entidade.getComissao())) {
				this.entidade.setComissao(new Double(0.0D));
			}
			if (MozartUtil.isNull(this.entidade.getEncargos())) {
				this.entidade.setEncargos(new Double(0.0D));
			}
			if (MozartUtil.isNull(this.entidade.getIr())) {
				this.entidade.setIr(new Double(0.0D));
			}
			this.parcelas = new ArrayList(this.qtdeParcela.intValue());

			Double comissaoParcela = Double.valueOf(0.0D);
			if ((this.entidade.getComissao() != null)
					&& (this.entidade.getComissao().doubleValue() > 0.0D)) {
				comissaoParcela = MozartUtil.round(Double.valueOf(this.entidade
						.getComissao().doubleValue()
						/ this.qtdeParcela.intValue()));
			}
			Double encargosParcela = Double.valueOf(0.0D);
			if ((this.entidade.getEncargos() != null)
					&& (this.entidade.getEncargos().doubleValue() > 0.0D)) {
				encargosParcela = MozartUtil.round(Double.valueOf(this.entidade
						.getEncargos().doubleValue()
						/ this.qtdeParcela.intValue()));
			}
			Double valorParcela = Double.valueOf(0.0D);
			if ((this.entidade.getValorDuplicata() != null)
					&& (this.entidade.getValorDuplicata().doubleValue() > 0.0D)) {
				valorParcela = MozartUtil.round(Double.valueOf(this.entidade
						.getValorDuplicata().doubleValue()
						/ this.qtdeParcela.intValue()));
			}
			Double ajusteParcela = Double.valueOf(0.0D);
			if ((this.entidade.getAjustes() != null)
					&& (this.entidade.getAjustes().doubleValue() > 0.0D)) {
				ajusteParcela = MozartUtil.round(Double.valueOf(this.entidade
						.getAjustes().doubleValue()
						/ this.qtdeParcela.intValue()));
			}
			Double irParcela = Double.valueOf(0.0D);
			if ((this.entidade.getIr() != null)
					&& (this.entidade.getIr().doubleValue() > 0.0D)) {
				irParcela = MozartUtil.round(Double.valueOf(this.entidade
						.getIr().doubleValue()
						/ this.qtdeParcela.intValue()));
			}
			Long idRede = getHotelCorrente().getRedeHotelEJB().getIdRedeHotel();
			for (int x = 0; x < this.qtdeParcela.intValue(); x++) {
				DuplicataEJB parcela = this.entidade.clone();
				parcela.setIdDuplicata(null);
				parcela
						.setDataVencimento(this.dataVencimento != null ? this.dataVencimento[x]
								: MozartUtil.incrementarMes(this.entidade
										.getDataVencimento(), x));
				parcela.setComissao(this.comissao != null ? this.comissao[x]
						: comissaoParcela);
				parcela.setEncargos(this.encargos != null ? this.encargos[x]
						: encargosParcela);
				parcela
						.setValorDuplicata(this.valorDuplicata != null ? this.valorDuplicata[x]
								: valorParcela);
				parcela.setAjustes(this.ajustes != null ? this.ajustes[x]
						: ajusteParcela);
				parcela.setIr(this.ir != null ? this.ir[x] : irParcela);
				parcela.setIdRedeHotel(idRede);
				this.parcelas.add(parcela);
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararParcelamento() {
		try {
			this.entidade = ((DuplicataEJB) CheckinDelegate.instance().obter(
					DuplicataEJB.class, this.entidade.getIdDuplicata()));
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String unificarDuplicata() {
		try {
			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUserSession().getUsuarioEJB());
			FinanceiroDelegate.instance().unificarDuplicata(hotel,
					this.idDuplicata);
			prepararDuplicata();
			removeMensagemSucesso();
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String gerarDuplicata() {
		try {
			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUserSession().getUsuarioEJB());
			FinanceiroDelegate.instance().gerarDuplicata(hotel,
					this.idDuplicata);
			prepararDuplicata();
			removeMensagemSucesso();
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararDuplicata() {
		try {
			this.filtro = new DuplicataVO();
			this.filtro.setFiltroTipoPesquisa("1");
			pesquisar();
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararPesquisa() {
		this.request.getSession().removeAttribute("listaPesquisa");
		return "sucesso";
	}

	protected void initCombo() throws MozartSessionException {
		ContaCorrenteVO filtro = new ContaCorrenteVO();
		filtro.setIdHoteis(getIdHoteis());
		this.contaCorrenteList = ControladoriaDelegate.instance()
				.pesquisarContaCorrente(filtro);
	}

	public String prepararAlteracao() {
		try {
			info("Iniciando a alteracao da duplicata");
			initCombo();
			this.entidade = ((DuplicataEJB) CheckinDelegate.instance().obter(
					DuplicataEJB.class, this.entidade.getIdDuplicata()));
			this.request.getSession().setAttribute("entidadeSession",
					this.entidade);
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return "sucesso";
	}

	public String prepararInclusao() {
		try {
			info("Iniciando a alteracao da duplicata");
			initCombo();
			this.entidadeTemp = new DuplicataTempEJB();
			this.request.getSession().setAttribute("entidadeSession",
					this.entidadeTemp);
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return "sucesso";
	}

	public String gravar() {
		try {
			initCombo();

			this.entidade.setUsuario(getUserSession().getUsuarioEJB());
			this.entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			if (MozartUtil.isNull(this.entidade.getIdDuplicata())) {
				CheckinDelegate.instance().incluir(this.entidade);
			} else {
				DuplicataEJB dupSession = (DuplicataEJB) this.request
						.getSession().getAttribute("entidadeSession");
				this.entidade.setAgrupar(dupSession.getAgrupar());
				this.entidade.setAno(dupSession.getAno());

				this.entidade.setDataDesconto(dupSession.getDataDesconto());

				this.entidade.setDataLancamento(dupSession.getDataLancamento());
				this.entidade.setDataLiquidacao(dupSession.getDataLiquidacao());
				this.entidade.setDataRecebimento(dupSession
						.getDataRecebimento());
				this.entidade.setDataRecompra(dupSession.getDataRecompra());
				this.entidade.setDescontoRecebimento(dupSession
						.getDescontoRecebimento());
				this.entidade.setDespFinanceira(dupSession.getDespFinanceira());
				EmpresaHotelEJBPK idEmpresa = new EmpresaHotelEJBPK();
				idEmpresa.idHotel = getIdHoteis()[0];
				idEmpresa.idEmpresa = this.entidade.getEmpresaHotelEJB()
						.getEmpresaRedeEJB().getEmpresaEJB().getIdEmpresa();
				this.entidade
						.setEmpresaHotelEJB((EmpresaHotelEJB) CheckinDelegate
								.instance().obter(EmpresaHotelEJB.class,
										idEmpresa));
				this.entidade.setHistoricoComplementar(dupSession
						.getHistoricoComplementar());
				this.entidade.setIdCentroCustoContabil(dupSession
						.getIdCentroCustoContabil());
				this.entidade.setIdDuplicataDescontada(dupSession
						.getIdDuplicataDescontada());
				this.entidade.setIdHospede(dupSession.getIdHospede());
				this.entidade.setIdHotelMutuo(dupSession.getIdHotelMutuo());
				this.entidade.setIdNota(dupSession.getIdNota());
				this.entidade.setIdPlanoContas(dupSession.getIdPlanoContas());
				this.entidade.setIdPlanoContasFinanceiro(dupSession
						.getIdPlanoContasFinanceiro());
				this.entidade.setIdRedeHotel(dupSession.getIdRedeHotel());
				this.entidade.setImprimir(dupSession.getImprimir());
				this.entidade.setJurosRecebimento(dupSession
						.getJurosRecebimento());
				this.entidade.setNumDuplicata(dupSession.getNumDuplicata());
				this.entidade.setProrrogado(dupSession.getProrrogado());
				this.entidade.setRecebimento(dupSession.getRecebimento());
				this.entidade.setSequenciaBancaria(dupSession
						.getSequenciaBancaria());
				this.entidade.setSituacao(dupSession.getSituacao());
				this.entidade.setStatusBanco(dupSession.getStatusBanco());
				this.entidade.setValorDuplicata(dupSession.getValorDuplicata());
				this.entidade.setValorRecebido(dupSession.getValorRecebido());

				CheckinDelegate.instance().alterar(this.entidade);
			}
			addMensagemSucesso("Operação realizada com sucesso.");
			this.entidade = new DuplicataEJB();
			this.request.getSession().setAttribute("entidadeSession",
					this.entidade);
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String pesquisar() {
		info("Pesquisar duplicatas");
		try {
			this.filtro.setIdHoteis(getIdHoteis());
			List<DuplicataVO> listaPesquisa = FinanceiroDelegate.instance()
					.pesquisarDuplicata(this.filtro);
			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}
			this.request.getSession().setAttribute("listaPesquisa",
					listaPesquisa);
		} catch (Exception exc) {
			error(exc.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public DuplicataVO getFiltro() {
		return this.filtro;
	}

	public void setFiltro(DuplicataVO filtro) {
		this.filtro = filtro;
	}

	public DuplicataEJB getEntidade() {
		return this.entidade;
	}

	public void setEntidade(DuplicataEJB entidade) {
		this.entidade = entidade;
	}

	public DuplicataTempEJB getEntidadeTemp() {
		return this.entidadeTemp;
	}

	public void setEntidadeTemp(DuplicataTempEJB entidadeTemp) {
		this.entidadeTemp = entidadeTemp;
	}

	public List<ContaCorrenteVO> getContaCorrenteList() {
		return this.contaCorrenteList;
	}

	public void setContaCorrenteList(List<ContaCorrenteVO> contaCorrenteList) {
		this.contaCorrenteList = contaCorrenteList;
	}

	public Long[] getIdDuplicata() {
		return this.idDuplicata;
	}

	public void setIdDuplicata(Long[] idDuplicata) {
		this.idDuplicata = idDuplicata;
	}

	public Long getQtdeParcela() {
		return this.qtdeParcela;
	}

	public void setQtdeParcela(Long qtdeParcela) {
		this.qtdeParcela = qtdeParcela;
	}

	public List<DuplicataEJB> getParcelas() {
		return this.parcelas;
	}

	public void setParcelas(List<DuplicataEJB> parcelas) {
		this.parcelas = parcelas;
	}

	public Timestamp[] getDataVencimento() {
		return this.dataVencimento;
	}

	public void setDataVencimento(Timestamp[] dataVencimento) {
		this.dataVencimento = dataVencimento;
	}

	public Double[] getComissao() {
		return this.comissao;
	}

	public void setComissao(Double[] comissao) {
		this.comissao = comissao;
	}

	public Double[] getEncargos() {
		return this.encargos;
	}

	public void setEncargos(Double[] encargos) {
		this.encargos = encargos;
	}

	public Double[] getValorDuplicata() {
		return this.valorDuplicata;
	}

	public void setValorDuplicata(Double[] valorDuplicata) {
		this.valorDuplicata = valorDuplicata;
	}

	public Double[] getAjustes() {
		return this.ajustes;
	}

	public void setAjustes(Double[] ajustes) {
		this.ajustes = ajustes;
	}

	public Double[] getIr() {
		return this.ir;
	}

	public void setIr(Double[] ir) {
		this.ir = ir;
	}

	public boolean isbDataFaturamento() {
		return this.bDataFaturamento;
	}

	public void setbDataFaturamento(boolean bDataFaturamento) {
		this.bDataFaturamento = bDataFaturamento;
	}

	public boolean isbDuplicataAFaturar() {
		return this.bDuplicataAFaturar;
	}

	public void setbDuplicataAFaturar(boolean bDuplicataAFaturar) {
		this.bDuplicataAFaturar = bDuplicataAFaturar;
	}

	public boolean isbClassificacaoContabil() {
		return this.bClassificacaoContabil;
	}

	public void setbClassificacaoContabil(boolean bClassificacaoContabil) {
		this.bClassificacaoContabil = bClassificacaoContabil;
	}

	public String getOrigemParcelamento() {
		return this.origemParcelamento;
	}

	public void setOrigemParcelamento(String origemParcelamento) {
		this.origemParcelamento = origemParcelamento;
	}
}