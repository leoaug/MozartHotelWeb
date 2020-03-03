package com.mozart.web.actions.financeiro;

import java.util.ArrayList;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.DuplicataEJB;
import com.mozart.model.ejb.entity.DuplicataHistoricoEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJBPK;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.BancoVO;
import com.mozart.model.vo.DuplicataVO;
import com.mozart.model.vo.PlanoContaVO;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings("unchecked")
public class ContasReceberAction extends FaturamentoAction {
	private static final long serialVersionUID = -5798570769409050745L;
	protected DuplicataHistoricoEJB entidadeHistorico;
	private List<MozartComboWeb> formaHistoricoList;
	private List<MozartComboWeb> listConfirmacao;
	private Long idPlanoContasNome;
	private List<PlanoContaVO> planoContaList;
	private List<CentroCustoContabilEJB> centroCustoList;
	private List<BancoVO> bancoList;
	private Long[] idDuplicatas;
	private String origemRecebimento;
	private Long contaCorrente;
	private String numDocumentoRecebimento;

	public ContasReceberAction() {
		this.filtro = new DuplicataVO();
		this.entidade = new DuplicataEJB();
		this.entidadeHistorico = new DuplicataHistoricoEJB();
	}

	public String prepararEncerramento() {
		return "sucesso";
	}

	public String encerrar() {
		try {
			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUserSession().getUsuarioEJB());
			FinanceiroDelegate.instance().encerrarContasReceber(hotel);
			ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
					.obter(ControlaDataEJB.class, getIdHoteis()[0]);
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);
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

	public String estornarDuplicata() {
		try {
			estornarDuplicata(this.entidade.getIdDuplicata());
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "pesquisa";
	}

	protected void estornarDuplicata(Long idDuplicata)
			throws MozartSessionException {
		this.entidade = ((DuplicataEJB) CheckinDelegate.instance().obter(
				DuplicataEJB.class, idDuplicata));
		this.entidade.setSituacao("A");
		this.entidade.setValorRecebido(null);
		this.entidade.setRecebimento(null);
		this.entidade.setDataRecebimento(null);
		this.entidade.setIrRetencao(null);
		this.entidade.setUsuario(getUsuario());
		CheckinDelegate.instance().alterar(this.entidade);
	}

	public String recomprarDuplicata() {
		try {
			this.entidade = ((DuplicataEJB) CheckinDelegate.instance().obter(
					DuplicataEJB.class, this.entidade.getIdDuplicata()));
			this.entidade.setSituacao("A");
			this.entidade.setValorRecebido(null);
			this.entidade.setRecebimento(null);
			this.entidade.setDataRecompra(getControlaData().getContasReceber());
			CheckinDelegate.instance().alterar(this.entidade);
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "pesquisa";
	}

	public String descontarDuplicata() {
		info("Iniciando a gravacao do desconto do contas a receber");
		try {
			initComboContasReceber();
			initCombo();
			if ((this.idDuplicatas == null) || (this.idDuplicatas.length == 0)) {
				addMensagemSucesso("Informe uma duplicata para efetuar o desconto");
				return "sucesso";
			}
			List<DuplicataVO> listaPesquisa = (List) this.request.getSession()
					.getAttribute("listaPesquisa");
			List<DuplicataVO> listaDesconto = new ArrayList();
			DuplicataVO rec = null;
			for (int x = 0; x < this.idDuplicatas.length; x++) {
				rec = new DuplicataVO();
				rec.setIdDuplicata(this.idDuplicatas[x]);
				if (listaPesquisa.contains(rec)) {
					rec = (DuplicataVO) listaPesquisa.get(listaPesquisa
							.indexOf(rec));
					listaDesconto.add(rec);
				}
			}
			rec.setUsuario(getUserSession().getUsuarioEJB());
			rec.setIdHoteis(getIdHoteis());

			FinanceiroDelegate.instance().descontarDuplicatas(rec,
					listaDesconto);
			for (DuplicataVO add : listaDesconto) {
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

	public String receberDuplicata() {
		info("Iniciando a gravacao do recebimento recebimento do contas a receber");
		try {
			initComboContasReceber();
			initCombo();
			if ((this.idDuplicatas == null) || (this.idDuplicatas.length == 0)) {
				addMensagemSucesso("Informe uma duplicata para efetuar o recebimento");
				return "sucesso";
			}
			List<DuplicataVO> listaPesquisa = (List) this.request.getSession()
					.getAttribute("listaPesquisa");
			List<DuplicataVO> listaRecebimento = new ArrayList();
			DuplicataVO rec = null;
			for (int x = 0; x < this.idDuplicatas.length; x++) {
				rec = new DuplicataVO();
				rec.setIdDuplicata(this.idDuplicatas[x]);
				if (listaPesquisa.contains(rec)) {
					rec = (DuplicataVO) listaPesquisa.get(listaPesquisa
							.indexOf(rec));
					rec.setNumDocTesouraria(this.numDocumentoRecebimento);
					if (!MozartUtil.isNull(this.contaCorrente)) {
						rec.setContaCorrente(this.contaCorrente);
						rec.setIdContaCorrente(this.contaCorrente);
					}
					listaRecebimento.add(rec);
				}
			}
			rec.setUsuario(getUserSession().getUsuarioEJB());
			rec.setIdHoteis(getIdHoteis());

			FinanceiroDelegate.instance().receberDuplicatas(rec,
					listaRecebimento);
			for (DuplicataVO add : listaRecebimento) {
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

	public String prepararRecebimentoDuplicata() {
		info("Iniciando o recebimento do contas a receber");
		try {
			List<DuplicataVO> listaPesquisa = (List) this.request.getSession()
					.getAttribute("listaPesquisa");
			DuplicataVO filtro = new DuplicataVO();
			filtro.setIdDuplicata(this.entidade.getIdDuplicata());
			filtro = (DuplicataVO) listaPesquisa.get(listaPesquisa
					.indexOf(filtro));
			listaPesquisa.clear();
			listaPesquisa.add(filtro);
			return prepararRecebimento();
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			prepararPesquisa();
		}
		return "sucesso";
	}

	public String prepararRecebimento() {
		info("Iniciando o recebimento do contas a receber");
		try {
			initComboContasReceber();
			initCombo();
			return "sucesso";
		} catch (MozartSessionException e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			prepararPesquisa();
		}
		return "sucesso";
	}

	protected void initComboContasReceber() throws MozartSessionException {
		this.formaHistoricoList = new ArrayList();
		this.formaHistoricoList.add(new MozartComboWeb("Telefone", "Telefone"));
		this.formaHistoricoList.add(new MozartComboWeb("Fax", "Fax"));
		this.formaHistoricoList.add(new MozartComboWeb("E-mail", "E-mail"));
		this.formaHistoricoList.add(new MozartComboWeb("Visita", "Visita"));
		this.formaHistoricoList.add(new MozartComboWeb("Outros", "Outros"));
		this.listConfirmacao = new ArrayList<MozartComboWeb>();
		this.listConfirmacao.add(new MozartComboWeb("S", "Sim"));
		this.listConfirmacao.add(new MozartComboWeb("N", "Não"));
		
		request.getSession().setAttribute("LISTA_CONFIRMACAO", listConfirmacao);

		PlanoContaVO filtroPlanoConta = new PlanoContaVO();
		filtroPlanoConta.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
				.getIdRedeHotel());
		filtroPlanoConta.getFiltroTipoConta().setTipo("C");
		filtroPlanoConta.getFiltroTipoConta().setTipoIntervalo("2");
		filtroPlanoConta.getFiltroTipoConta().setValorInicial("Analitico");
		this.planoContaList = RedeDelegate.instance().pesquisarPlanoConta(
				filtroPlanoConta);

		CentroCustoContabilEJB filtroCentroCusto = new CentroCustoContabilEJB();
		filtroCentroCusto.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
				.getIdRedeHotel());
		this.centroCustoList = RedeDelegate.instance().pesquisarCentroCusto(
				filtroCentroCusto);

		this.bancoList = SistemaDelegate.instance().pesquisarBancoUsadoNoHotel(
				getIdHoteis()[0]);
	}

	public String gravar() {
		try {
			initComboContasReceber();

			this.entidade.setUsuario(getUserSession().getUsuarioEJB());
			this.entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			if (MozartUtil.isNull(this.entidade.getIdDuplicata())) {
				CheckinDelegate.instance().incluir(this.entidade);
			} else {
				DuplicataEJB dupSession = (DuplicataEJB) this.request
						.getSession().getAttribute("entidadeSession");
				dupSession.setUsuario(getUserSession().getUsuarioEJB());
				dupSession.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
						.getIdRedeHotel());

				EmpresaHotelEJBPK idEmpresa = new EmpresaHotelEJBPK();
				idEmpresa.idHotel = getIdHoteis()[0];
				idEmpresa.idEmpresa = this.entidade.getEmpresaHotelEJB()
						.getEmpresaRedeEJB().getEmpresaEJB().getIdEmpresa();
				dupSession.setEmpresaHotelEJB((EmpresaHotelEJB) CheckinDelegate
						.instance().obter(EmpresaHotelEJB.class, idEmpresa));
				dupSession.setContaCorrente(this.entidade.getContaCorrente());
				dupSession.setJurosRecebimento(this.entidade
						.getJurosRecebimento());
				dupSession.setDescontoRecebimento(this.entidade
						.getDescontoRecebimento());
				dupSession.setIrRetencao(this.entidade.getIrRetencao());
				dupSession.setCofins(this.entidade.getCofins());
				dupSession.setPis(this.entidade.getPis());
				dupSession.setCssl(this.entidade.getCssl());
				dupSession.setIss(this.entidade.getIss());
				dupSession.setIdPlanoContas(this.entidade.getIdPlanoContas());
				dupSession.setIdCentroCustoContabil(this.entidade
						.getIdCentroCustoContabil());
				dupSession.setHistoricoComplementar(this.entidade
						.getHistoricoComplementar());
				dupSession.setProrrogado(this.entidade.getProrrogado());
				if ((!MozartUtil.isNull(this.entidadeHistorico.getData()))
						|| (!MozartUtil.isNull(this.entidadeHistorico
								.getContato()))
						|| (!MozartUtil.isNull(this.entidadeHistorico
								.getNumeroForma()))
						|| (!MozartUtil.isNull(this.entidadeHistorico
								.getObservacoes()))) {
					this.entidadeHistorico.setIdHotel(getIdHoteis()[0]);
					dupSession.addDuplicataHistoricoEJB(this.entidadeHistorico);
				}
				CheckinDelegate.instance().alterar(dupSession);
			}
			addMensagemSucesso("Operação realizada com sucesso.");
			this.request.getSession().removeAttribute("entidadeSession");
			return "pesquisa";
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararAlteracao() {
		info("Iniciando a alteracao do contas a receber");
		try {
			initComboContasReceber();
			String result = super.prepararAlteracao();
			this.idPlanoContasNome = this.entidade.getIdPlanoContas();
//			this.contaCorrente = !MozartUtil.isNull(this.entidade.getContaCorrente()) ? this.entidade.getContaCorrente().getId() : null;
			return result;
		} catch (MozartSessionException e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararPesquisa() {
		this.request.getSession().removeAttribute("listaPesquisa");
		return "sucesso";
	}

	public String pesquisar() {
		info("Pesquisar contas a receber");
		try {
			this.filtro.setIdHoteis(getIdHoteis());
			List<DuplicataVO> listaPesquisa = FinanceiroDelegate.instance()
					.pesquisarContasReceber(this.filtro);
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

	public DuplicataHistoricoEJB getEntidadeHistorico() {
		return this.entidadeHistorico;
	}

	public void setEntidadeHistorico(DuplicataHistoricoEJB entidadeHistorico) {
		this.entidadeHistorico = entidadeHistorico;
	}

	public List<MozartComboWeb> getFormaHistoricoList() {
		return this.formaHistoricoList;
	}

	public void setFormaHistoricoList(List<MozartComboWeb> formaHistoricoList) {
		this.formaHistoricoList = formaHistoricoList;
	}

	public List<PlanoContaVO> getPlanoContaList() {
		return this.planoContaList;
	}

	public void setPlanoContaList(List<PlanoContaVO> planoContaList) {
		this.planoContaList = planoContaList;
	}

	public Long getIdPlanoContasNome() {
		return this.idPlanoContasNome;
	}

	public void setIdPlanoContasNome(Long idPlanoContasNome) {
		this.idPlanoContasNome = idPlanoContasNome;
	}

	public List<CentroCustoContabilEJB> getCentroCustoList() {
		return this.centroCustoList;
	}

	public void setCentroCustoList(List<CentroCustoContabilEJB> centroCustoList) {
		this.centroCustoList = centroCustoList;
	}

	public Long[] getIdDuplicatas() {
		return this.idDuplicatas;
	}

	public void setIdDuplicatas(Long[] idDuplicatas) {
		this.idDuplicatas = idDuplicatas;
	}

	public String getOrigemRecebimento() {
		return this.origemRecebimento;
	}

	public void setOrigemRecebimento(String origemRecebimento) {
		this.origemRecebimento = origemRecebimento;
	}

	public List<BancoVO> getBancoList() {
		return this.bancoList;
	}

	public void setBancoList(List<BancoVO> bancoList) {
		this.bancoList = bancoList;
	}

	public Long getContaCorrente() {
		return this.contaCorrente;
	}

	public void setContaCorrente(Long contaCorrente) {
		this.contaCorrente = contaCorrente;
	}

	public String getNumDocumentoRecebimento() {
		return this.numDocumentoRecebimento;
	}

	public void setNumDocumentoRecebimento(String numDocumentoRecebimento) {
		this.numDocumentoRecebimento = numDocumentoRecebimento;
	}
}