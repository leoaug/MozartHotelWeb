package com.mozart.web.actions.contabilidade;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ContabilidadeDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.ClassificacaoContabilEJB;
import com.mozart.model.ejb.entity.ContaCorrenteEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.PlanoContaEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ClassificacaoContabilCentroCustoVO;
import com.mozart.model.vo.ClassificacaoContabilPadraoVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class ClassificacaoContabilPadraoAction extends BaseAction {

	private static final String PREFIXO_DESCRICAO = "LP_";
	private static final String PREFIXO_LIKE_DESCRICAO = PREFIXO_DESCRICAO
			+ "%";

	private static final long serialVersionUID = -461061668728225444L;

	private List<ClassificacaoContabilCentroCustoVO> listaCentroCusto;
	private ClassificacaoContabilPadraoVO filtro;
	private List<ClassificacaoContabilEJB> listaLancamentos;
	private List<ClassificacaoContabilEJB> listaLancamentosDeletados;

	private Long planoContasFinanceira;
	private PlanoContaEJB planoContaFin;
	private PlanoContaEJB[] planoContaFinArr;
	private String planoContaFinDs[];
	private String descricao;

	private String debitoCreditoTes[];
	private Long idCentroCustoTes[];
	private Long idContaCorrenteTes[];
	private String contaCorrenteDs[];
	private Long idPlanoContasTes[];
	private Long idPlanoContasFin[];
	private Long idClassificacaoContabilTes[];
	private Double percentualTes[];
	private String pisTes[];
	private Long planoContasDebitoCredito;

	private PlanoContaEJB planoContaDebCred;

	private List<MozartComboWeb> debitoCreditoList;
	private List<MozartComboWeb> listaConfirmacao;
	private String status;

	private Double totalCredito;
	private Double totalDebito;
	private Double totalGeral;
	private Double diferenca;

	private String contaContabil;
	private Long idClassificacaoContabil;
	private Long indice;

	private boolean operacaoRealizada;
	private String mensagemPai;

	public ClassificacaoContabilPadraoAction() {

		this.filtro = new ClassificacaoContabilPadraoVO();
		listaLancamentos = new Vector<ClassificacaoContabilEJB>();
		listaLancamentosDeletados = new Vector<ClassificacaoContabilEJB>();
		initComboLancamento();

	}

	public String prepararManter() {
		listaLancamentos = new Vector<ClassificacaoContabilEJB>();
		listaLancamentosDeletados = new Vector<ClassificacaoContabilEJB>();
		
		this.request.getSession().setAttribute("entidadeSession", listaLancamentos);
		this.request.getSession().setAttribute("entidadeDeletadaSession", listaLancamentosDeletados);
		descricao = "";
		return "pesquisa";
	}

	public String encerrar() {
		try {

			ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
					.obter(ControlaDataEJB.class, getIdHoteis()[0]);
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);
			prepararPesquisa();
			addMensagemSucesso("Operação realizada com sucesso.");
			return "pesquisa";
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
			return "sucesso";
		} catch (Exception ex) {
			error("Erro ao realizar operação.");
			addMensagemErro(ex.getMessage());
		}
		return "sucesso";
	}

	public String incluirLancamento() {
		List<ClassificacaoContabilEJB> entidade = (List) this.request
				.getSession().getAttribute("entidadeSession");

		ClassificacaoContabilEJB lancamento = new ClassificacaoContabilEJB();

		PlanoContaEJB planoContaDebCred = new PlanoContaEJB();
		planoContaDebCred.setIdPlanoContas(this.planoContaDebCred
				.getIdPlanoContas());
		String splitDadosConta[] = this.planoContaDebCred.getContaContabil()
				.split(" - ");
		planoContaDebCred.setContaReduzida(splitDadosConta[0]);
		planoContaDebCred.setContaContabil(splitDadosConta[1]);
		planoContaDebCred.setNomeConta(splitDadosConta[2]);

		if (this.planoContaFinDs != null && this.planoContaFinDs[0] != null
				&& !this.planoContaFinDs[0].equals("")) {

			PlanoContaEJB planoContaFin = new PlanoContaEJB();
			planoContaFin.setIdPlanoContas(idPlanoContasFin[0]);
			splitDadosConta = this.planoContaFinDs[0].split(" - ");
			planoContaFin.setContaReduzida(splitDadosConta[0]);
			planoContaFin.setContaContabil(splitDadosConta[1]);
			planoContaFin.setNomeConta(splitDadosConta[2]);

			lancamento.setPlanoContasFin(planoContaFin);
		}

		lancamento.setDebitoCredito(this.debitoCreditoTes[0]);
		lancamento.setIdHotel(getHotelCorrente().getIdHotel());

		lancamento.setPercentual(Double.valueOf(percentualTes[0]));

		CentroCustoContabilEJB centroCustoContabil = new CentroCustoContabilEJB();

		centroCustoContabil.setIdCentroCustoContabil(idCentroCustoTes[0]);

		ContaCorrenteEJB contaCorrente = new ContaCorrenteEJB();

		lancamento.setPis(this.pisTes[0]);
		lancamento.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
				.getIdRedeHotel());

		planoContaDebCred.setIdHotel(lancamento.getIdHotel());

		try {

			centroCustoContabil = ContabilidadeDelegate.instance()
					.buscarCentroCustoContabil(centroCustoContabil);

			if (debitoCreditoTes[0].equalsIgnoreCase("C")) {
				lancamento.setPlanoContasCredito(planoContaDebCred);
				lancamento.setCentroCustoCredito(centroCustoContabil);
			} else if (debitoCreditoTes[0].equalsIgnoreCase("D")) {
				lancamento.setPlanoContasDebito(planoContaDebCred);
				lancamento.setCentroCustoDebito(centroCustoContabil);
			}

			for (ContaCorrenteEJB conta : FinanceiroDelegate.instance()
					.obterContaCorrentePorPlanoContas(planoContaDebCred)) {

				contaCorrente = conta;
				break;
			}
		} catch (MozartSessionException e) {
			error(e.getMessage());
			mensagemPai = ("Erro ao realizar operação.");
			operacaoRealizada = false;

			return "sucesso";
		}

		lancamento.setContaCorrente(contaCorrente);

		entidade.add(lancamento);

		sincronizarTotais(entidade);
		this.request.getSession().setAttribute("entidadeSession", entidade);

		resetLancamento();

		return "sucesso";
	}

	public String prepararLancamento() {
		try {

			List<ClassificacaoContabilEJB> entidade = (List<ClassificacaoContabilEJB>) this.request
					.getSession().getAttribute("entidadeSession");
			if ((entidade.size() > 0)
					&& (((ClassificacaoContabilEJB) entidade.get(0))
							.getIdClassificacaoContabil() != null)) {
				this.status = "alteracao";
				sincronizarTotais(entidade);
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String excluirLancamento() {
		try {
			List<ClassificacaoContabilEJB> entidade = (List<ClassificacaoContabilEJB>) this.request
					.getSession().getAttribute("entidadeSession");
			List<ClassificacaoContabilEJB> entidadeDeletada = (List<ClassificacaoContabilEJB>) this.request
					.getSession().getAttribute("entidadeDeletadaSession");

			int indice = this.indice.intValue();

			ClassificacaoContabilEJB obj = entidade.get(indice);

			obj.setUsuario(getUsuario());

			if (status.equals("alteracao")) {
				entidadeDeletada.add(obj);
			}

			entidade.remove(indice);

			sincronizarTotais(entidade);
			this.request.getSession().setAttribute("entidadeSession", entidade);

			resetLancamento();
		} catch (Exception e) {
			error(e.getMessage());
			operacaoRealizada = false;
			mensagemPai = ("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String atualizarLancamento() {
		try {
			List<ClassificacaoContabilEJB> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

			int indice = this.indice.intValue(), indiceForm = indice + 1;

			ClassificacaoContabilEJB obj = entidade.get(indice);

			String contaFinDs = request
					.getParameter("planoContaFinDs" + indice);
			String contaFinId = request.getParameter("idPlanoContasFin"
					+ indice + ".idPlanoContas");
			String contaDebCredDs = request.getParameter("planoContaDebCredDs"
					+ indice);
			String contaDedCredId = request.getParameter("idPlanoContasTes"
					+ indice + ".idPlanoContas");

			obj.setPercentual(percentualTes[indiceForm]);
			
			obj.setDebitoCredito(this.debitoCreditoTes[indiceForm]);

			CentroCustoContabilEJB centroCustoContabil = new CentroCustoContabilEJB();

			centroCustoContabil.setIdCentroCustoContabil(idCentroCustoTes[indiceForm]);
			
			centroCustoContabil = ContabilidadeDelegate.instance()
					.buscarCentroCustoContabil(centroCustoContabil);
			
			obj.setPis(pisTes[indiceForm]);

			obj.setDescricao(descricao);

			if (contaFinDs == null || contaFinDs.equals("")) {
				obj.setPlanoContasFin(null);
			} else if (contaFinDs != null) {
				PlanoContaEJB planoContaFin = new PlanoContaEJB();
				planoContaFin.setIdPlanoContas(Long.parseLong(contaFinId));
				String[] splitDadosConta = contaFinDs.split(" - ");
				planoContaFin.setContaReduzida(splitDadosConta[0]);
				planoContaFin.setContaContabil(splitDadosConta[1]);
				planoContaFin.setNomeConta(splitDadosConta[2]);

				obj.setPlanoContasFin(planoContaFin);
			}

			PlanoContaEJB planoContaDebCred = new PlanoContaEJB();

			if (contaDebCredDs == null || contaDebCredDs.equals("")) {
				obj.setPlanoContasDebito(null);
				obj.setPlanoContasCredito(null);
			} else if (contaDebCredDs != null) {
				planoContaDebCred.setIdPlanoContas(Long
						.parseLong(contaDedCredId));
				String[] splitDadosConta = contaDebCredDs.split(" - ");
				planoContaDebCred.setContaReduzida(splitDadosConta[0]);
				planoContaDebCred.setContaContabil(splitDadosConta[1]);
				planoContaDebCred.setNomeConta(splitDadosConta[2]);
				planoContaDebCred.setIdHotel(getHotelCorrente().getIdHotel());

				if (obj.getDebitoCredito().equalsIgnoreCase("D")) {
					obj.setPlanoContasDebito(planoContaDebCred);
					obj.setCentroCustoDebito(centroCustoContabil);
				} else if (obj.getDebitoCredito().equalsIgnoreCase("C")) {
					obj.setPlanoContasCredito(planoContaDebCred);
					obj.setCentroCustoCredito(centroCustoContabil);
				}
			}

			ContaCorrenteEJB contaCorrente = new ContaCorrenteEJB();

			for (ContaCorrenteEJB conta : FinanceiroDelegate.instance()
					.obterContaCorrentePorPlanoContas(planoContaDebCred)) {

				contaCorrente = conta;
				break;
			}

			obj.setContaCorrente(contaCorrente);

			entidade.set(indice, obj);

			this.request.getSession().setAttribute("entidadeSession", entidade);
			sincronizarTotais(entidade);
			resetLancamento();
			if (status.equals("alteracao")) {
//				return gravar();
			}
		} catch (Exception e) {
			error(e.getMessage());
			operacaoRealizada = false;
			mensagemPai = ("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	private void resetLancamento() {
		this.debitoCreditoTes[0] = "";
		this.pisTes[0] = "";
		this.idCentroCustoTes[0] = new Long(-1L);

	}

	public String prepararInclusao() {
		HotelEJB hotelEJB = (HotelEJB) this.request.getSession().getAttribute(
				"HOTEL_SESSION");

		try {
			listaCentroCusto = ContabilidadeDelegate.instance()
					.obterComboCentroCusto(hotelEJB.getRedeHotelEJB());

			this.request.getSession().setAttribute("CENTRO_CUSTO",
					listaCentroCusto);

			this.request.getSession().setAttribute("entidadeSession",
					this.listaLancamentos);
			this.request.getSession().setAttribute("entidadeDeletadaSession",
					this.listaLancamentosDeletados);

			this.planoContaDebCred = new PlanoContaEJB();
			this.planoContaFin = new PlanoContaEJB();

			this.status = "";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararAlteracao() {
		try {
			prepararInclusao();
			ClassificacaoContabilEJB classificacaoContabil = ContabilidadeDelegate
					.instance().obterClassificacaoContabilPorId(
							idClassificacaoContabil);

			List<ClassificacaoContabilEJB> entidade = ContabilidadeDelegate
					.instance().obterClassificacaoContabilFaturamento(
							classificacaoContabil);

			descricao = classificacaoContabil.getDescricao().substring(
					PREFIXO_DESCRICAO.length());

			this.request.getSession().setAttribute("entidadeSession", entidade);
			this.request.getSession().setAttribute("entidadeDeletadaSession", new Vector<ClassificacaoContabilEJB>());

			sincronizarTotais(entidade);

			this.status = "alteracao";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararPesquisa() {
		try {
			request.getSession().removeAttribute("listaPesquisa");

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String pesquisar() {
		warn("Pesquisando Classificação contábil Padrão");
		try {
			ClassificacaoContabilPadraoVO filtroPesquisa = (ClassificacaoContabilPadraoVO) this.filtro;

			filtroPesquisa.setIdHoteis(getIdHoteis());
			filtroPesquisa.setDescricao(PREFIXO_LIKE_DESCRICAO);

			List<ClassificacaoContabilPadraoVO> listaPesquisa = ContabilidadeDelegate
					.instance().pesquisarClassificacaoContabilPadrao(
							(ClassificacaoContabilPadraoVO) filtroPesquisa);

			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}

			this.request.getSession().setAttribute("listaPesquisa",
					listaPesquisa);

		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String excluir() {
		warn("Excluindo Classificação contábil Padrão");
		try {
			pesquisar();
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	protected void initComboLancamento() {

		totalCredito = new Double(0);
		totalDebito = new Double(0);
		totalGeral = new Double(0);

		this.debitoCreditoList = new ArrayList<MozartComboWeb>();
		this.debitoCreditoList.add(new MozartComboWeb("C", "Crédito"));
		this.debitoCreditoList.add(new MozartComboWeb("D", "Débito"));

		this.listaConfirmacao = new ArrayList<MozartComboWeb>();
		this.listaConfirmacao.add(new MozartComboWeb("S", "Sim"));
		this.listaConfirmacao.add(new MozartComboWeb("N", "Não"));

	}

	public String gravar() {

		String retorno = "sucesso";

		info("Salvando Classificação Contabil Padrão");

		List<ClassificacaoContabilEJB> entidade = (List) this.request
				.getSession().getAttribute("entidadeSession");
		
		List<ClassificacaoContabilEJB> entidadeDeletada = (List) this.request
				.getSession().getAttribute("entidadeDeletadaSession");

		try {
			ClassificacaoContabilPadraoVO filtroPesquisa = new ClassificacaoContabilPadraoVO();
			
			filtroPesquisa.setIdHoteis(getIdHoteis());
			filtroPesquisa.setDescricao((PREFIXO_DESCRICAO + descricao).toUpperCase());

			List<ClassificacaoContabilPadraoVO> listaPesquisa = ContabilidadeDelegate
					.instance().pesquisarClassificacaoContabilPadrao(
							(ClassificacaoContabilPadraoVO) filtroPesquisa);

			if (! MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Padrão já Cadastrado.");
				mensagemPai = ("Padrão já Cadastrado.");
				operacaoRealizada = true;
			}

			for (ClassificacaoContabilEJB obj : entidadeDeletada) {
				obj.setUsuario(getUsuario());
				ContabilidadeDelegate.instance().removerClassificacaoContabil(
						obj);
			}

			for (ClassificacaoContabilEJB obj : entidade) {

				obj.setDescricao((PREFIXO_DESCRICAO + descricao).toUpperCase());

				if (!MozartUtil.isNull(obj.getCentroCustoDebito())) {
					obj.setCentroCustoDebito(obj.getCentroCustoDebito());
				}
				if (!MozartUtil.isNull(obj.getCentroCustoCredito())) {
					obj.setCentroCustoCredito(obj.getCentroCustoCredito());
				}
				if (!MozartUtil.isNull(obj.getPlanoContasDebito())) {
					obj.setPlanoContasDebito(obj.getPlanoContasDebito());
				}
				if (!MozartUtil.isNull(obj.getPlanoContasCredito())) {
					obj.setPlanoContasCredito(obj.getPlanoContasCredito());
				}
				if (!MozartUtil.isNull(obj.getPlanoContasFin())) {
					obj.setPlanoContasFin(obj.getPlanoContasFin());
				}
				if (!MozartUtil.isNull(obj.getContaCorrente())
						&& (MozartUtil.isNull(obj.getContaCorrente().getId()) || MozartUtil
								.isNull(obj.getContaCorrente().getId()))) {

					obj.setContaCorrente(null);
				}
				obj.setUsuario(getUsuario());
				if (MozartUtil.isNull(obj.getIdClassificacaoContabil())) {

					obj.setIdClassificacaoContabil(ContabilidadeDelegate
							.instance().obterNextVal());
					ContabilidadeDelegate.instance()
							.salvarClassificacaoContabil(obj);
				} else {
					ContabilidadeDelegate.instance()
							.alterarClassificacaoContabil(obj);

				}
				addMensagemSucesso("Operação realizada com sucesso.");
				mensagemPai = ("Operação realizada com sucesso.");
				operacaoRealizada = true;
			}
			
			this.descricao = "";
			prepararManter();
		} catch (MozartSessionException ex) {
			error(ex.getMessage());
			operacaoRealizada = false;
			addMensagemErro("Erro ao realizar operação.");
			mensagemPai = ("Erro ao realizar operação.");
		}

		return retorno;
	}

	private void sincronizarTotais(List<ClassificacaoContabilEJB> entidade) {

		totalCredito = new Double(0);
		totalDebito = new Double(0);

		for (ClassificacaoContabilEJB obj : entidade) {
			if (obj.getDebitoCredito().equalsIgnoreCase("C")) {
				totalCredito = totalCredito + obj.getPercentual();
			} else if (obj.getDebitoCredito().equalsIgnoreCase("D")) {
				totalDebito = totalDebito + obj.getPercentual();
			}

		}

		diferenca = totalCredito - totalDebito;
	}

	public List<ClassificacaoContabilCentroCustoVO> getListaCentroCusto() {
		return listaCentroCusto;
	}

	public void setListaCentroCusto(
			List<ClassificacaoContabilCentroCustoVO> listaCentroCusto) {
		this.listaCentroCusto = listaCentroCusto;
	}

	public ClassificacaoContabilPadraoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ClassificacaoContabilPadraoVO filtro) {
		this.filtro = filtro;
	}

	public List<ClassificacaoContabilEJB> getListaLancamentos() {
		return listaLancamentos;
	}

	public void setListaLancamentos(
			List<ClassificacaoContabilEJB> listaLancamentos) {
		this.listaLancamentos = listaLancamentos;
	}

	public String[] getDebitoCreditoTes() {
		return debitoCreditoTes;
	}

	public void setDebitoCreditoTes(String[] debitoCreditoTes) {
		this.debitoCreditoTes = debitoCreditoTes;
	}

	public Long[] getIdCentroCustoTes() {
		return idCentroCustoTes;
	}

	public void setIdCentroCustoTes(Long[] idCentroCustoTes) {
		this.idCentroCustoTes = idCentroCustoTes;
	}

	public String[] getPisTes() {
		return pisTes;
	}

	public void setPisTes(String[] pisTes) {
		this.pisTes = pisTes;
	}

	public List<MozartComboWeb> getDebitoCreditoList() {
		return debitoCreditoList;
	}

	public void setDebitoCreditoList(List<MozartComboWeb> debitoCreditoList) {
		this.debitoCreditoList = debitoCreditoList;
	}

	public List<MozartComboWeb> getListaConfirmacao() {
		return listaConfirmacao;
	}

	public void setListaConfirmacao(List<MozartComboWeb> listaConfirmacao) {
		this.listaConfirmacao = listaConfirmacao;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Long getIdClassificacaoContabil() {
		return idClassificacaoContabil;
	}

	public void setIdClassificacaoContabil(Long idClassificacaoContabil) {
		this.idClassificacaoContabil = idClassificacaoContabil;
	}

	public Long[] getIdPlanoContasTes() {
		return idPlanoContasTes;
	}

	public void setIdPlanoContasTes(Long[] idPlanoContasTes) {
		this.idPlanoContasTes = idPlanoContasTes;
	}

	public PlanoContaEJB getPlanoContaFin() {
		return planoContaFin;
	}

	public void setPlanoContaFin(PlanoContaEJB planoContaFin) {
		this.planoContaFin = planoContaFin;
	}

	public PlanoContaEJB getPlanoContaDebCred() {
		return planoContaDebCred;
	}

	public void setPlanoContaDebCred(PlanoContaEJB planoContaDebCred) {
		this.planoContaDebCred = planoContaDebCred;
	}

	public String getContaContabil() {
		return contaContabil;
	}

	public void setContaContabil(String contaContabil) {
		this.contaContabil = contaContabil;
	}

	public Double getDiferenca() {
		return diferenca;
	}

	public void setDiferenca(Double diferenca) {
		this.diferenca = diferenca;
	}

	public Long getPlanoContasFinanceira() {
		return planoContasFinanceira;
	}

	public void setPlanoContasFinanceira(Long planoContasFinanceira) {
		this.planoContasFinanceira = planoContasFinanceira;
	}

	public Long getPlanoContasDebitoCredito() {
		return planoContasDebitoCredito;
	}

	public void setPlanoContasDebitoCredito(Long planoContasDebitoCredito) {
		this.planoContasDebitoCredito = planoContasDebitoCredito;
	}

	public String getDescricao() {
		return descricao;
	}

	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}

	public Long getIndice() {
		return indice;
	}

	public void setIndice(Long indice) {
		this.indice = indice;
	}

	public Long[] getIdContaCorrenteTes() {
		return idContaCorrenteTes;
	}

	public void setIdContaCorrenteTes(Long[] idContaCorrenteTes) {
		this.idContaCorrenteTes = idContaCorrenteTes;
	}

	public Double[] getPercentualTes() {
		return percentualTes;
	}

	public void setPercentualTes(Double[] percentualTes) {
		this.percentualTes = percentualTes;
	}

	public Double getTotalCredito() {
		return totalCredito;
	}

	public void setTotalCredito(Double totalCredito) {
		this.totalCredito = totalCredito;
	}

	public Double getTotalDebito() {
		return totalDebito;
	}

	public void setTotalDebito(Double totalDebito) {
		this.totalDebito = totalDebito;
	}

	public Double getTotalGeral() {
		return totalGeral;
	}

	public void setTotalGeral(Double totalGeral) {
		this.totalGeral = totalGeral;
	}

	public Long[] getIdPlanoContasFin() {
		return idPlanoContasFin;
	}

	public void setIdPlanoContasFin(Long[] idPlanoContasFin) {
		this.idPlanoContasFin = idPlanoContasFin;
	}

	public String[] getPlanoContaFinDs() {
		return planoContaFinDs;
	}

	public void setPlanoContaFinDs(String[] planoContaFinDs) {
		this.planoContaFinDs = planoContaFinDs;
	}

	public Long[] getIdClassificacaoContabilTes() {
		return idClassificacaoContabilTes;
	}

	public void setIdClassificacaoContabilTes(Long idClassificacaoContabilTes[]) {
		this.idClassificacaoContabilTes = idClassificacaoContabilTes;
	}

	public boolean isOperacaoRealizada() {
		return operacaoRealizada;
	}

	public void setOperacaoRealizada(boolean operacaoRealizada) {
		this.operacaoRealizada = operacaoRealizada;
	}

	public String getMensagemPai() {
		return mensagemPai;
	}

	public void setMensagemPai(String mensagemPai) {
		this.mensagemPai = mensagemPai;
	}

	public PlanoContaEJB[] getPlanoContaFinArr() {
		return planoContaFinArr;
	}

	public void setPlanoContaFinArr(PlanoContaEJB[] planoContaFinArr) {
		this.planoContaFinArr = planoContaFinArr;
	}

	public String[] getContaCorrenteDs() {
		return contaCorrenteDs;
	}

	public void setContaCorrenteDs(String contaCorrenteDs[]) {
		this.contaCorrenteDs = contaCorrenteDs;
	}

}
