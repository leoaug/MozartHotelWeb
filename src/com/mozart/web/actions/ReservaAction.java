package com.mozart.web.actions;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.EmailDelegate;
import com.mozart.model.delegate.EmpresaDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
import com.mozart.model.delegate.ReservaDelegate;
import com.mozart.model.delegate.UsuarioDelegate;
import com.mozart.model.ejb.entity.CentralReservaEJB;
import com.mozart.model.ejb.entity.CentralReservasRedeEJB;
import com.mozart.model.ejb.entity.CentralReservasRedeEJBPK;
import com.mozart.model.ejb.entity.CheckinEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJBPK;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.MovimentoApartamentoEJB;
import com.mozart.model.ejb.entity.ReservaMidiaEJB;
import com.mozart.model.ejb.entity.RoomListEJB;
import com.mozart.model.ejb.entity.StatusNotaEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJBPK;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ApartamentoVO;
import com.mozart.model.vo.CrsVO;
import com.mozart.model.vo.EmpresaHotelVO;
import com.mozart.model.vo.OcupDispVO;
import com.mozart.model.vo.PagamentoReservaVO;
import com.mozart.model.vo.ReservaApartamentoDiariaVO;
import com.mozart.model.vo.ReservaApartamentoVO;
import com.mozart.model.vo.ReservaGrupoLancamentoVO;
import com.mozart.model.vo.ReservaMapaOcupacaoVO;
import com.mozart.model.vo.ReservaVO;
import com.mozart.model.vo.RoomListVO;
import com.mozart.model.vo.TarifaVO;
import com.mozart.model.vo.TipoApartamentoVO;
import com.mozart.model.vo.TipoDiariaVO;
import com.mozart.model.vo.TipoPaxVO;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings("unchecked")
public class ReservaAction extends BaseAction {
	private static final long serialVersionUID = 8699554755069029236L;
	private static final String SESSION_EMPRESA_HOTEL = "TELA_RESERVA_EMPRESA_HOTEL";
	private static final String SESSION_RESERVA_APARTAMENTO = "TELA_RESERVA_RESERVA_APARTAMENTO";
	private static final String SESSION_ROOM_LIST_ATUAL = "TELA_RESERVA_ROOM_LIST_ATUAL";
	private static final String SESSION_PAGAMENTO_RESERVA = "TELA_RESERVA_PAGAMENTO_RESERVA";
	private static final String SESSION_MOVIMENTO_APARTAMENTO = "TELA_RESERVA_MOVIMENTO_APARTAMENTO";
	private static final String SESSION_COMBO_COFAN = "TELA_RESERVA_COMBO_COFAN";
	private static final String SESSION_OPERACAO_TELA = "TELA_RESERVA_OPERACAO_TELA";
	private static final String INCLUSAO = "TELA_RESERVA_OPERACAO_TELA_INCLUSAO";
	private static final String ALTERACAO = "TELA_RESERVA_OPERACAO_TELA_ALTERACAO";
	private static final String EXECUTAR_SCRIPT_TELA_RSVA_APTO = "SESSAO_JAVASCRIPT_RESERVAAPTO";
	private static final String SESSION_RESERVA_APARTAMENTO_DIARIA = "TELA_RESERVA_RESERVA_APARTAMENTO_DIARIA_CORRENTE";
	private ReservaVO filtro;
	private ReservaVO filtroBloqueio;
	private EmpresaHotelVO empresaHotelVO;
	private ReservaVO reservaVO;
	private ReservaVO reservaBloqueioVO;
	private ReservaApartamentoVO reservaApartamentoVO;
	private String diariaTotalIdIdentificaLancamento1;
	private String alimentosEBebidasIdIdentificaLancamento4;
	private String telefoniaEComunicacoesIdIdentificaLancamento6;
	private String lavanderiaIdIdentificaLancamento8;
	private String receitaOutrasIdIdentificaLancamento21;
	private PagamentoReservaVO pagamentoReservaVO;
	private MovimentoApartamentoEJB movimentoApartamento;
	private String display;
	private String gridCor;
	private String gridCorLetra;
	private String gridCorTotal;
	private String gridCorTotalLetra;
	private String ocupacaoDisponibilidade;
	private String nomeHospede;
	private String idHospedeSelecionado;
	private String qtdePax;
	private String id;
	private List<TipoApartamentoVO> listTipoApto;
	private List<TipoPaxVO> listTipoPax;
	private List<TipoDiariaVO> listTipoDiaria;
	private List<PagamentoReservaVO> listFormaPgto;
	private List<ApartamentoVO> listApartamentoCofan;
	private String indicePagamento;
	private String indiceResApto;
	private String indiceHospede;
	private String formaPgtoSel;
	private Long idIdentificaLancamento;
	private Boolean origemCrs;
	private Boolean isBloqueio;
	private Long idHotelCRS;
	private Long idTarifaCRS;
	private CrsVO filtroCRS;
	private String idTipoAptoCRS;
	private String emailPara;
	private String emailCC;
	private String emailBody;
	private String somenteReservaApartamento;
	private String imprimirVoucher;
	private ReservaMapaOcupacaoVO filtroMapa;
	private Long idMoeda;
	private Long idApartamentoChart;
	private Timestamp dataEntradaChart;
	private Boolean ativarCofan;
	private Boolean ehAlteracao;
	private List<MovimentoApartamentoEJB> listMovimentoApartamento;

	public Long getIdApartamentoChart() {
		return this.idApartamentoChart;
	}

	public void setIdApartamentoChart(Long idApartamentoChart) {
		this.idApartamentoChart = idApartamentoChart;
	}

	public Timestamp getDataEntradaChart() {
		return this.dataEntradaChart;
	}

	public void setDataEntradaChart(Timestamp dataEntradaChart) {
		this.dataEntradaChart = dataEntradaChart;
	}

	public ReservaAction() {
		this.filtro = new ReservaVO();
		this.filtroBloqueio = new ReservaVO();
		this.filtroCRS = new CrsVO();
		this.empresaHotelVO = new EmpresaHotelVO();
		this.reservaVO = new ReservaVO();
		this.reservaApartamentoVO = new ReservaApartamentoVO();
		this.pagamentoReservaVO = new PagamentoReservaVO();
	}

	public String prepararRelatorio() {
		return "sucesso";
	}

	public String prepararGestaoBloqueio() {
		return "gestaoBloqueio";
	}

	public String excluirReserva() {
		try {
			this.reservaVO.setUsuario(getUserSession().getUsuarioEJB());
			this.reservaVO.setBcIdReserva(new Long(this.reservaVO
					.getGracIdReservaIdReservaApartamento().split(",")[0]));
			this.reservaVO.setBcApagada("S");
			
			if (ReservaDelegate.instance().existeCheckinAtivo(this.reservaVO)) {
				addMensagemErro("Esta reserva já possui checkin, logo, não pode ser cancelada.");
				error("Esta reserva já possui checkin, logo, não pode ser cancelada.");
				return "sucesso";
			}
			
			ReservaDelegate.instance().apagarReserva(this.reservaVO);
			addMensagemSucesso("Operação realizada com sucesso.");
			return prepararPesquisa();
		} catch (MozartValidateException ex) {
			addMensagemSucesso(ex.getMessage());
			return "sucesso";
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return "sucesso";
	}

	public String destravarReserva() {
		try {
			this.reservaVO.setUsuario(getUserSession().getUsuarioEJB());
			this.reservaVO.setBcIdReserva(new Long(this.reservaVO
					.getGracIdReservaIdReservaApartamento().split(",")[0]));
			this.reservaVO.setBcAlterando("N");
			ReservaDelegate.instance().destravarReserva(this.reservaVO);
			addMensagemSucesso("Operação realizada com sucesso.");
			return prepararPesquisa();
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return "sucesso";
	}

	public String confirmarReserva() {
		try {
			this.reservaVO.setUsuario(getUserSession().getUsuarioEJB());
			this.reservaVO.setBcIdReserva(new Long(this.reservaVO
					.getGracIdReservaIdReservaApartamento().split(",")[0]));
			this.reservaVO.setBcConfirma("S");
			ReservaDelegate.instance().confirmarReserva(this.reservaVO);
			addMensagemSucesso("Operação realizada com sucesso.");
			return prepararPesquisa();
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return "sucesso";
	}

	public String enviarEmail() {
		try {
			EmailDelegate.instance().send(
					getHotelCorrente().getEmail(),
					this.emailPara,
					MozartUtil.isNull(this.emailCC) ? this.emailPara
							: this.emailCC,
					"Confirmação da reserva: "
							+ this.reservaVO.getBcIdReserva(), this.emailBody);
			addMensagemSucesso("Operação realizada com sucesso.");
			return "sucesso";
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return "sucesso";
	}

	public String prepararEnviarReservaApartamentoPorEmail() {
		try {
			prepararEnviarReservaPorEmail();
			this.somenteReservaApartamento = this.reservaVO
					.getGracIdReservaIdReservaApartamento().split(",")[1];

			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
		}
		return "pesquisa";
	}

	public String prepararEnviarReservaPorEmail() {
		try {
			this.reservaVO
					.setBcIdReserva(Long.valueOf(Long
							.parseLong(this.reservaVO
									.getGracIdReservaIdReservaApartamento()
									.split(",")[0])));
			this.reservaVO = ReservaDelegate.instance().obterReservaPorId(
					this.reservaVO);
			EmpresaHotelEJB empresaHotel = new EmpresaHotelEJB();
			EmpresaHotelEJBPK ehpk = new EmpresaHotelEJBPK(
					this.reservaVO.getBcIdEmpresa(), getIdHoteis()[0]);
			empresaHotel = EmpresaDelegate.instance().obterEmpresaHotelByPK(
					ehpk);
			if (!MozartUtil.isNull(empresaHotel)) {
				this.emailPara = empresaHotel.getEmpresaRedeEJB().getEmail();
			}
			this.somenteReservaApartamento = "";
			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
		}
		return "pesquisa";
	}

	public String prepararPesquisaMapa() {
		this.filtroMapa = new ReservaMapaOcupacaoVO();
		this.filtroMapa.setBloqueio("N");
		this.filtroMapa.setDataEntrada(getControlaData().getFrontOffice());
		this.filtroMapa.setDataSaida(MozartUtil.incrementarDia(this.filtroMapa
				.getDataEntrada()));
		return pesquisarMapa();
	}

	public String pesquisarMapa() {
		try {
			this.filtroMapa.setIdHotel(getIdHoteis()[0]);
			List<ReservaMapaOcupacaoVO> lista = ReservaDelegate.instance()
					.pesquisarMapaOcupacao(this.filtroMapa);
			this.request.getSession().setAttribute("listaPesquisa", lista);
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararPesquisa() {
		this.request.setAttribute("filtro.dataEntrada.tipoIntervalo", "1");
		this.request.setAttribute("filtro.dataEntrada.valorInicial", MozartUtil
				.format(getControlaData().getFrontOffice(), "dd/MM/yyyy"));
		this.request.setAttribute("filtro.dataEntrada.valorFinal", MozartUtil
				.format(getControlaData().getFrontOffice(), "dd/MM/yyyy"));
		this.request.setAttribute("filtro.apagada.tipoIntervalo", "N");
		
		this.request.getSession().removeAttribute("listaPesquisaReserva");
		limpaSessaoTela();
		return "sucesso";
	}

	public String pesquisar() {
		return "sucesso";
	}

	public String prepararPesquisaCRS() {
		warn("Preparando a pesquisa da reserva via CRS");
		try {
			this.request.getSession().removeAttribute("listaPesquisaReserva");
			this.origemCrs = Boolean.valueOf(true);

			HotelEJB hotel = getHotelCorrente();
			if (!MozartUtil.isNull(this.idHotelCRS)) {
				hotel = new HotelEJB();
				hotel.setIdHotel(this.idHotelCRS);
			}
			List<HotelEJB> lista = ((CentralReservaEJB) this.request
					.getSession().getAttribute("CRS_SESSION_NAME"))
					.getHoteisAtivos();
			hotel = (HotelEJB) lista.get(lista.indexOf(hotel));
			this.request.getSession().setAttribute("HOTEL_SESSION", hotel);
			this.request.getSession().setAttribute("imagemHotel",
					hotel.getEnderecoLogotipo());
			this.request.getSession().setAttribute("nomeHotel",
					hotel.getNomeFantasia());

			ControlaDataEJB controladata = UsuarioDelegate.instance()
					.obterControlaData(hotel.getIdHotel());
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION",
					controladata);

			this.idHoteis = new Long[1];
			this.idHoteis[0] = this.idHotelCRS;
			this.request.setAttribute("idHoteis", this.idHoteis);
			if (MozartUtil.isNull(this.filtroCRS.getDataEntrada())) {
				this.request.setAttribute("filtro.dataEntrada.tipoIntervalo",
						"1");
				this.request.setAttribute("filtro.dataEntrada.valorInicial",
						MozartUtil.format(controladata.getFrontOffice(),
								"dd/MM/yyyy"));
				this.request.setAttribute("filtro.dataEntrada.valorFinal",
						MozartUtil.format(
								MozartUtil.incrementarDia(
										controladata.getFrontOffice(), 1),
								"dd/MM/yyyy"));
			} else {
				this.request.setAttribute("filtro.dataEntrada.tipoIntervalo",
						"1");
				this.request.setAttribute("filtro.dataEntrada.valorInicial",
						MozartUtil.format(this.filtroCRS.getDataEntrada(),
								"dd/MM/yyyy"));
				this.request.setAttribute("filtro.dataEntrada.valorFinal",
						MozartUtil.format(this.filtroCRS.getDataSaida(),
								"dd/MM/yyyy"));
			}
			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String preparaManterCRS() throws MozartSessionException {
		warn("Preparando manter reserva via CRS");
		this.origemCrs = Boolean.valueOf(true);
		HotelEJB hotel = new HotelEJB();
		hotel.setIdHotel(this.idHotelCRS);
		List<HotelEJB> lista = ((CentralReservaEJB) this.request.getSession()
				.getAttribute("CRS_SESSION_NAME")).getHoteisAtivos();
		hotel = (HotelEJB) lista.get(lista.indexOf(hotel));
		this.request.getSession().setAttribute("HOTEL_SESSION", hotel);
		this.request.getSession().setAttribute("imagemHotel",
				hotel.getEnderecoLogotipo());
		this.request.getSession().setAttribute("nomeHotel",
				hotel.getNomeFantasia());

		preparaManter();
		ControlaDataEJB controladata = UsuarioDelegate.instance()
				.obterControlaData(hotel.getIdHotel());
		this.request.getSession().setAttribute("CONTROLA_DATA_SESSION",
				controladata);
		if (MozartUtil.isNull(this.filtroCRS.getDataEntrada())) {
			this.reservaVO.setBcDataEntrada(controladata.getFrontOffice());
			this.reservaVO.setBcDataSaida(MozartUtil.incrementarDia(
					controladata.getFrontOffice(), 1));
		} else {

			if (MozartUtil.getDiferencaDia(controladata.getFrontOffice(),
					this.filtroCRS.getDataEntrada()) < 0) {
				this.filtroCRS.setDataEntrada(controladata.getFrontOffice());
			}
			if (MozartUtil.getDiferencaDia(controladata.getFrontOffice(),
					this.filtroCRS.getDataSaida()) < 0) {
				this.filtroCRS.setDataSaida(MozartUtil
						.incrementarDia(controladata.getFrontOffice()));
			}

			this.reservaVO.setBcDataEntrada(this.filtroCRS.getDataEntrada());
			this.reservaVO.setBcDataSaida(this.filtroCRS.getDataSaida());

			request.getSession().setAttribute("resAptoDataEntrada",
					this.filtroCRS.getDataEntrada());
			request.getSession().setAttribute("resAptoDataSaida",
					this.filtroCRS.getDataSaida());

			String scriptResApto = "document.getElementById('reservaApartamentoVO.bcDataEntrada').value='"
					+ MozartUtil.format(this.filtroCRS.getDataEntrada(),
							"dd/MM/yyyy") + "';";
			scriptResApto = scriptResApto
					+ "document.getElementById('reservaApartamentoVO.bcDataSaida').value='"
					+ MozartUtil.format(this.filtroCRS.getDataSaida(),
							"dd/MM/yyyy") + "';";

			this.request.getSession().setAttribute(
					EXECUTAR_SCRIPT_TELA_RSVA_APTO, scriptResApto);
		}
		return "prepara";
	}

	public String preparaManterCRSBloqueio() throws MozartSessionException {
		warn("Preparando manter bloqueio via CRS");
		String retorno = preparaManterCRS();
		this.isBloqueio = Boolean.valueOf(true);
		return retorno;
	}

	public String preparaManterViaChart() throws MozartSessionException {
		String result = preparaManter();

		this.reservaVO.setBcDataEntrada(this.dataEntradaChart);
		this.reservaVO.setBcDataSaida(MozartUtil.incrementarDia(
				this.reservaVO.getBcDataEntrada(), 1));

		return result;
	}

	public String preparaManter() throws MozartSessionException {
		warn("Preparando manter reserva");
		limpaSessaoTela();
		initCombo();

		ehAlteracao = false;
		this.request.getSession().setAttribute(SESSION_OPERACAO_TELA, INCLUSAO);

		List<ReservaApartamentoVO> listaReservaApartamento = new ArrayList();
		this.request.getSession().setAttribute(SESSION_RESERVA_APARTAMENTO,
				listaReservaApartamento);

		List<RoomListVO> listaRoomList = new ArrayList();
		this.request.getSession().setAttribute(SESSION_ROOM_LIST_ATUAL,
				listaRoomList);

		List<PagamentoReservaVO> listPagamento = new ArrayList();
		this.request.getSession().setAttribute(SESSION_PAGAMENTO_RESERVA,
				listPagamento);
		List<MovimentoApartamentoEJB> listMovimentoApto = new ArrayList();
		this.request.getSession().setAttribute(SESSION_MOVIMENTO_APARTAMENTO,
				listMovimentoApto);

		ControlaDataEJB controladata = (ControlaDataEJB) this.request
				.getSession().getAttribute("CONTROLA_DATA_SESSION");

		this.reservaVO
				.setBcIdReserva(ReservaDelegate.instance().obterNextVal());
		this.reservaVO.setBcDataEntrada(controladata.getFrontOffice());
		this.reservaVO.setBcDataSaida(MozartUtil.incrementarDia(
				this.reservaVO.getBcDataEntrada(), 1));
		this.reservaVO.setBcPermuta("N");
		this.reservaVO.setBcGrupo("N");
		this.reservaVO.setBcGaranteNoShow("N");
		this.reservaVO.setBcFidelidade("N");
		this.reservaVO.setBcFlgAlcoolica("N");
		this.reservaVO.setBcIdReservaMida(5L);
		this.isBloqueio = Boolean.valueOf(false);
		return "prepara";
	}

	public String preparaManterBloqueio() throws MozartSessionException {
		warn("Preparando manter bloqueio");
		String retorno = preparaManter();
		this.isBloqueio = Boolean.valueOf(true);
		return retorno;
	}

	public String alterarReserva() throws MozartSessionException {
		info("Alterando a reserva");
		try {
			if (this.origemCrs.booleanValue()) {
				preparaManterCRS();
			} else {
				limpaSessaoTela();
				initCombo();
			}
			this.request.getSession().setAttribute(SESSION_OPERACAO_TELA,
					ALTERACAO);
			this.reservaVO
					.setBcIdReserva(Long.valueOf(Long
							.parseLong(this.reservaVO
									.getGracIdReservaIdReservaApartamento()
									.split(",")[0])));
			this.reservaVO = ReservaDelegate.instance().obterReservaPorId(
					this.reservaVO);
			if ("S".equals(this.reservaVO.getBcAlterando())) {
				throw new MozartSessionException(
						"- A reserva já está sendo alterada por outro usuário.");
			}
			this.empresaHotelVO = this.reservaVO.getEmpresaHotelVO();
			this.request.getSession().setAttribute(SESSION_EMPRESA_HOTEL,
					this.empresaHotelVO);

			this.request.getSession().setAttribute(SESSION_RESERVA_APARTAMENTO,
					this.reservaVO.getListReservaApartamento());

			this.request.getSession().setAttribute(SESSION_PAGAMENTO_RESERVA,
					this.reservaVO.getListPagamento());
			
			List<MovimentoApartamentoEJB> listMovimentoApto = reservaVO.getListMovimentoApartamento();
			
			this.request.getSession().setAttribute(SESSION_MOVIMENTO_APARTAMENTO,
					(null == listMovimentoApto)? new ArrayList<MovimentoApartamentoEJB>() :listMovimentoApto);

			this.idMoeda = ((ReservaApartamentoDiariaVO) ((ReservaApartamentoVO) this.reservaVO
					.getListReservaApartamento().get(0))
					.getListReservaApartamentoDiaria().get(0)).getBcIdMoeda();

			Iterator localIterator = this.reservaVO
					.getListReservaGrupoLancamento().iterator();
			while (localIterator.hasNext()) {
				ReservaGrupoLancamentoVO obj = (ReservaGrupoLancamentoVO) localIterator
						.next();
				if (obj.getBcIdIdentificaLancamento().equals(new Long(1L))) {
					this.diariaTotalIdIdentificaLancamento1 = obj
							.getBcQuemPaga();
				} else if (obj.getBcIdIdentificaLancamento().equals(
						new Long(4L))) {
					this.alimentosEBebidasIdIdentificaLancamento4 = obj
							.getBcQuemPaga();
				} else if (obj.getBcIdIdentificaLancamento().equals(
						new Long(6L))) {
					this.telefoniaEComunicacoesIdIdentificaLancamento6 = obj
							.getBcQuemPaga();
				} else if (obj.getBcIdIdentificaLancamento().equals(
						new Long(8L))) {
					this.lavanderiaIdIdentificaLancamento8 = obj
							.getBcQuemPaga();
				} else if (obj.getBcIdIdentificaLancamento().equals(
						new Long(21L))) {
					this.receitaOutrasIdIdentificaLancamento21 = obj
							.getBcQuemPaga();
				}
			}
			String script = "parent.document.getElementById('reservaVO.bcGrupo').readOnly = true;";
			script = script
					+ "parent.document.getElementById('reservaVO.bcGrupo').style.color = 'gray';";
			script = script + calculaTotalReservaEGeraScript("iframe");
			this.request.getSession().setAttribute(
					EXECUTAR_SCRIPT_TELA_RSVA_APTO, script);
			
			ehAlteracao = true;
		} catch (Exception ex) {
			addMensagemErro(ex.getMessage());
			error(ex.getMessage());
			this.filtro = null;
			return "pesquisa";
		}
		return "prepara";
	}

	public String prepararCabecalhoGestaoBloqueio()
			throws MozartSessionException {
		return "sucessoCabecalhoGestaoBloqueio";
	}

	public String prepararTarifasGestaoBloqueio() throws MozartSessionException {
		return "sucessoTarifasGestaoBloqueio";
	}

	public String prepararQtdeGestaoBloqueio() throws MozartSessionException {
		return "sucessoQtdeGestaoBloqueio";
	}

	public String prepararReservaApto() throws MozartSessionException {
		this.reservaApartamentoVO.setBcQtdeCrianca(new Long(0L));
		this.reservaApartamentoVO.setBcAdicional(new Long(0L));
		this.reservaApartamentoVO.setBcQtdeApartamento(new Long(1L));
		this.reservaApartamentoVO.setBcTarifa(new Double(0.0D));
		this.reservaApartamentoVO.setBcTotalTarifa(new Double(0.0D));
		this.reservaApartamentoVO.setBcIdTipoApartamento(null);
		if (this.request.getSession().getAttribute("resAptoDataEntrada") != null) {
			this.reservaApartamentoVO.setBcDataEntrada((Timestamp) this.request
					.getSession().getAttribute("resAptoDataEntrada"));
			this.reservaApartamentoVO.setBcDataSaida((Timestamp) this.request
					.getSession().getAttribute("resAptoDataSaida"));
		} else {
			ControlaDataEJB controladata = (ControlaDataEJB) this.request
					.getSession().getAttribute("CONTROLA_DATA_SESSION");
			this.reservaApartamentoVO.setBcDataEntrada(controladata
					.getFrontOffice());
			this.reservaApartamentoVO.setBcDataSaida(MozartUtil.incrementarDia(
					controladata.getFrontOffice(), 1));
		}
		initComboReservaApto();
		if (this.request.getSession().getAttribute(
				EXECUTAR_SCRIPT_TELA_RSVA_APTO) == null) {
			String script = calculaTotalReservaEGeraScript("iframe");
			this.request.getSession().setAttribute(
					EXECUTAR_SCRIPT_TELA_RSVA_APTO, script);
		}
		return "sucessoResApto";
	}

	public String prepararHospede() throws MozartSessionException {
		return "sucessoHospede";
	}

	public String excluirHospedeReservaApartamento()
			throws MozartSessionException {
		List<RoomListVO> listRoomList = (List) this.request.getSession()
				.getAttribute(SESSION_ROOM_LIST_ATUAL);
		listRoomList.remove(Integer.parseInt(this.indiceHospede));
		return "sucessoHospede";
	}

	private void limpaSessaoTela() {
		this.request.getSession().setAttribute(SESSION_EMPRESA_HOTEL, null);
		this.request.getSession().setAttribute(SESSION_RESERVA_APARTAMENTO,
				null);
		this.request.getSession().setAttribute(
				SESSION_RESERVA_APARTAMENTO_DIARIA, null);
		this.request.getSession().setAttribute("resAptoDataEntrada", null);
		this.request.getSession().setAttribute("resAptoDataSaida", null);
		this.request.getSession().setAttribute("APTOS_RESERVA",
				Collections.emptyList());
		this.request.getSession().removeAttribute(SESSION_RESERVA_APARTAMENTO);
		this.request.getSession().removeAttribute(SESSION_EMPRESA_HOTEL);
		this.request.getSession().removeAttribute(SESSION_ROOM_LIST_ATUAL);
		this.request.getSession().removeAttribute(SESSION_PAGAMENTO_RESERVA);
		this.request.getSession().removeAttribute(SESSION_OPERACAO_TELA);
		this.request.getSession().removeAttribute(INCLUSAO);
		this.request.getSession().removeAttribute(ALTERACAO);
		this.request.getSession().removeAttribute(
				EXECUTAR_SCRIPT_TELA_RSVA_APTO);
		this.request.getSession().removeAttribute(
				SESSION_RESERVA_APARTAMENTO_DIARIA);
	}

	public String adicionarReservaApto() throws MozartSessionException {
		
		try {
		info("Adicionando res apro");
		if ((this.reservaApartamentoVO.getBcIdApartamento() != null)
				&& (this.reservaApartamentoVO.getBcIdApartamento().longValue() != 0L)) {
			ApartamentoVO apto = new ApartamentoVO();
			apto.setBcIdApartamento(this.reservaApartamentoVO
					.getBcIdApartamento());
			apto = ReservaDelegate.instance().obterApartamentoPorId(apto);
			this.reservaApartamentoVO.setBcApartamentoDesc(apto
					.getBcNumApartamento().toString());
		}
		TipoApartamentoVO tp = new TipoApartamentoVO();
		tp.setBcIdTipoApartamento(this.reservaApartamentoVO
				.getBcIdTipoApartamento());
		tp = ReservaDelegate.instance().obterTipoApartamentoPorId(tp);
		this.reservaApartamentoVO.setBcTipoApartamentoDesc(tp.getBcFantasia());

		TipoDiariaVO td = new TipoDiariaVO();
		td.setBcIdTipoDiaria(this.reservaApartamentoVO.getBcIdTipoDiaria());
		td = ReservaDelegate.instance().obterTipoDiariaPorId(td);
		this.reservaApartamentoVO.setBcTipoDiariaDesc(td.getBcDescricao());
		if ("S".equals(this.reservaApartamentoVO.getBcTarifaManual())) {
			Timestamp dataEntrada = this.reservaApartamentoVO
					.getBcDataEntrada();
			while (dataEntrada.before(this.reservaApartamentoVO
					.getBcDataSaida())) {
				ReservaApartamentoDiariaVO resAptoDiaria = new ReservaApartamentoDiariaVO();
				resAptoDiaria.setBcData(dataEntrada);
				resAptoDiaria.setBcIdHotel(getIdHoteis()[0]);
				resAptoDiaria
						.setBcIdMoeda(MozartUtil.isNull(this.idMoeda) ? new Long(
								1L) : this.idMoeda);
				resAptoDiaria.setBcJustificaTarifa("TARIFA MANUAL");
				resAptoDiaria.setBcTarifa(this.reservaApartamentoVO
						.getBcTarifa());
				dataEntrada = MozartUtil.incrementarDia(dataEntrada, 1);
				this.reservaApartamentoVO.setBcJustificaTarifa("TARIFA MANUAL");
				this.reservaApartamentoVO.getListReservaApartamentoDiaria()
						.add(resAptoDiaria);
			}
		} else {
			this.empresaHotelVO = ((EmpresaHotelVO) this.request.getSession()
					.getAttribute(SESSION_EMPRESA_HOTEL));
			this.reservaApartamentoVO.setBcIdEmpresa(this.empresaHotelVO
					.getBcIdEmpresa());
			this.reservaApartamentoVO.setBcIdHotel(getIdHoteis()[0]);
			this.reservaApartamentoVO.setBcIdMoeda(new Long(1L));
			this.reservaApartamentoVO.setBcIdMoeda(MozartUtil
					.isNull(this.idMoeda) ? new Long(1L) : this.idMoeda);
			List<TarifaVO> listTarifasVO = ReservaDelegate.instance()
					.obterTarifaPorPeriodo(this.reservaApartamentoVO);
			for (TarifaVO obj : listTarifasVO) {
				ReservaApartamentoDiariaVO resAptoDiaria = new ReservaApartamentoDiariaVO();
				resAptoDiaria.setBcData(obj.getBcDataEntrada());
				resAptoDiaria.setBcIdHotel(getIdHoteis()[0]);
				resAptoDiaria
						.setBcIdMoeda(MozartUtil.isNull(this.idMoeda) ? new Long(
								1L) : this.idMoeda);
				resAptoDiaria.setBcJustificaTarifa(obj.getBcDescricao());
				resAptoDiaria.setBcTarifa(obj.getBcPax());
				this.reservaApartamentoVO.setBcJustificaTarifa(obj
						.getBcDescricao());
				this.reservaApartamentoVO.getListReservaApartamentoDiaria()
						.add(resAptoDiaria);
			}
			this.reservaApartamentoVO.setBcTarifa(

			Double.valueOf(this.reservaApartamentoVO.getBcTotalTarifa()
					.doubleValue()
					/ this.reservaApartamentoVO
							.getListReservaApartamentoDiaria().size()));
		}
		List<ReservaApartamentoVO> listaReservaApartamentoVO = (List) this.request
				.getSession().getAttribute(SESSION_RESERVA_APARTAMENTO);

		if (this.isBloqueio) {
			Timestamp dataEntrada = this.reservaApartamentoVO
					.getBcDataEntrada();
			Timestamp dataEntradaD1 = MozartUtil.incrementarDia(dataEntrada, 1);
			while (dataEntrada.before(this.reservaApartamentoVO
					.getBcDataSaida())) {
				for (int x = 0; x < this.reservaApartamentoVO
						.getBcQtdeApartamento().intValue(); x++) {
					ReservaApartamentoVO rsApClone = (ReservaApartamentoVO) this.reservaApartamentoVO
							.clone(this.reservaApartamentoVO);
					rsApClone.setBcQtdeApartamento(new Long(1L));
					rsApClone.setBcQtdeCheckin(new Long(0L));
					rsApClone.setBcIdReservaApartamento(null);
					if ("N".equals(this.reservaVO.getBcGrupo())) {
						rsApClone.setBcIdReserva(ReservaDelegate.instance()
								.obterNextVal());
						rsApClone.setBcGrupoSimNao(new Long(0L));
					}
					if (new Long(0L).equals(rsApClone.getBcIdApartamento())) {
						rsApClone.setBcIdApartamento(null);
					}
					if ((this.reservaApartamentoVO.getBcQtdeApartamento()
							.longValue() > 1L) && (x > 0)) {
						rsApClone.setBcIdApartamento(null);
						rsApClone.setBcApartamentoDesc(null);
					}
					rsApClone.setBcDataEntrada(dataEntrada);
					rsApClone.setBcDataSaida(dataEntradaD1);
					listaReservaApartamentoVO.add(rsApClone);
				}
				dataEntrada = MozartUtil.incrementarDia(dataEntrada, 1);
				dataEntradaD1 = MozartUtil.incrementarDia(dataEntrada, 1);
			}
		} else {
			for (int x = 0; x < this.reservaApartamentoVO
					.getBcQtdeApartamento().intValue(); x++) {
				ReservaApartamentoVO rsApClone = (ReservaApartamentoVO) this.reservaApartamentoVO
						.clone(this.reservaApartamentoVO);
				rsApClone.setBcQtdeApartamento(new Long(1L));
				rsApClone.setBcQtdeCheckin(new Long(0L));
				rsApClone.setBcIdReservaApartamento(null);
				if ("N".equals(this.reservaVO.getBcGrupo())) {
					rsApClone.setBcIdReserva(ReservaDelegate.instance()
							.obterNextVal());
					rsApClone.setBcGrupoSimNao(new Long(0L));
				}
				if (new Long(0L).equals(rsApClone.getBcIdApartamento())) {
					rsApClone.setBcIdApartamento(null);
				}
				if ((this.reservaApartamentoVO.getBcQtdeApartamento()
						.longValue() > 1L) && (x > 0)) {
					rsApClone.setBcIdApartamento(null);
					rsApClone.setBcApartamentoDesc(null);
				}
				listaReservaApartamentoVO.add(rsApClone);
			}
		}
		this.indiceResApto = null;
		this.reservaApartamentoVO.setBcIdTipoApartamento(null);
		this.reservaApartamentoVO.setBcQtdePax(null);

		String script = "";
		script = script
				+ "parent.document.getElementById('reservaVO.bcGrupo').readOnly = true;";
		script = script
				+ "parent.document.getElementById('reservaVO.bcGrupo').style.color = 'gray';";

		script = script + calculaTotalReservaEGeraScript("iframe");

		this.request.getSession().setAttribute(EXECUTAR_SCRIPT_TELA_RSVA_APTO,
				script);

		} catch (MozartValidateException ex) {
			addMensagemSucesso(ex.getMessage());
			error(ex.getMessage());
			return "sucesso";
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		
		return prepararReservaApto();
	}

	private String calculaTotalReservaEGeraScript(String TELA) {
		info("Calculando valor da tarifa");
		this.empresaHotelVO = ((EmpresaHotelVO) this.request.getSession()
				.getAttribute(SESSION_EMPRESA_HOTEL));
		this.empresaHotelVO = (this.empresaHotelVO == null ? new EmpresaHotelVO()
				: this.empresaHotelVO);
		ReservaVO resVO = new ReservaVO();
		if ("S".equals(this.reservaVO.getBcCalculaIss())) {
			resVO.setPercentualIss(Double.valueOf(getHotelCorrente().getIss()
					.doubleValue()));
		}
		if ("S".equals(this.reservaVO.getBcCalculaRoomTax())) {
			resVO.setPercentualRoomTax(Double.valueOf(getHotelCorrente()
					.getRoomtax().doubleValue()));
		}
		if ("S".equals(this.reservaVO.getBcCalculaTaxa())) {
			resVO.setPercentualTaxaServico(Double.valueOf(getHotelCorrente()
					.getTaxaServico().doubleValue()));
		}
		List<ReservaApartamentoVO> listaReservaApartamentoVO = (List) this.request
				.getSession().getAttribute(SESSION_RESERVA_APARTAMENTO);

		resVO.setListReservaApartamento(listaReservaApartamentoVO);
		String valorTaxaIss = MozartUtil.format(resVO.getValorIss());
		String valorTaxaServico = MozartUtil
				.format(resVO.getValorTaxaServico());
		String valorRoomTax = MozartUtil.format(resVO.getValorRoomTax());
		String valorReserva = MozartUtil.format(resVO.getValorTotalReserva());

		String parent = "";
		if (TELA.equals("iframe")) {
			parent = "parent.";
		}
		String script = "";
		script = script
				+ parent
				+ "document.getElementById('divValorTaxaServico').innerHTML = '"
				+ valorTaxaServico + "';";
		script = script + parent
				+ "document.getElementById('divValorRoomTax').innerHTML = '"
				+ valorRoomTax + "';";
		script = script + parent
				+ "document.getElementById('divValorISS').innerHTML = '"
				+ valorTaxaIss + "';";
		script = script + parent + "setValorReserva('" + valorReserva + "');";
		return script;
	}

	public String excluirReservaApto() throws MozartSessionException {
		info("Excluindo res apro");
		List<ReservaApartamentoVO> listaReservaApartamentoVO = (List) this.request
				.getSession().getAttribute(SESSION_RESERVA_APARTAMENTO);
		if (Integer.parseInt(this.indiceResApto) < 0) {
			Iterator it = listaReservaApartamentoVO.iterator();
			while (it.hasNext()) {
				ReservaApartamentoVO resAptoVO = (ReservaApartamentoVO) it
						.next();
				if ((resAptoVO.getBcQtdeCheckin() == null)
						|| (resAptoVO.getBcQtdeCheckin().equals(new Long(0L)))) {
					listaReservaApartamentoVO.remove(resAptoVO);
					it = listaReservaApartamentoVO.iterator();
				}
			}
		} else {
			listaReservaApartamentoVO.remove(Integer
					.parseInt(this.indiceResApto));
		}
		this.indiceResApto = null;

		String script = calculaTotalReservaEGeraScript("iframe");
		if (this.request.getSession().getAttribute(SESSION_OPERACAO_TELA)
				.equals(ALTERACAO)) {
			script = script
					+ "parent.document.getElementById('reservaVO.bcGrupo').readOnly = true;";
			script = script
					+ "parent.document.getElementById('reservaVO.bcGrupo').style.color = 'gray';";
		} else if (listaReservaApartamentoVO.size() == 0) {
			script = script
					+ "parent.document.getElementById('reservaVO.bcGrupo').readOnly = false;";
			script = script
					+ "parent.document.getElementById('reservaVO.bcGrupo').style.color = 'black';";
		} else {
			script = script
					+ "parent.document.getElementById('reservaVO.bcGrupo').readOnly = true;";
			script = script
					+ "parent.document.getElementById('reservaVO.bcGrupo').style.color = 'gray';";
		}
		this.request.getSession().setAttribute(EXECUTAR_SCRIPT_TELA_RSVA_APTO,
				script);

		return prepararReservaApto();
	}

	public String prepararReservaPagamento() throws MozartSessionException {
		ControlaDataEJB controladata = (ControlaDataEJB) this.request
				.getSession().getAttribute("CONTROLA_DATA_SESSION");
		this.pagamentoReservaVO = new PagamentoReservaVO();
		this.pagamentoReservaVO.setBcFormaPg("F");
		this.ativarCofan = false;
        this.idIdentificaLancamento = null;
		this.request.getSession()
				.setAttribute("ATIVAR_COFAN", this.ativarCofan);
		this.pagamentoReservaVO.setBcIdHotel(getHotelCorrente().getIdHotel());
		this.pagamentoReservaVO
				.setBcDataConfirma(controladata.getFrontOffice());
		this.listFormaPgto = ReservaDelegate.instance()
				.obterTiposDePagamentoReserva(this.pagamentoReservaVO);

		listMovimentoApartamento = new ArrayList<MovimentoApartamentoEJB>();

		initComboApantamentoCofan();

		return "sucessoResPgto";
	}

	private void initComboApantamentoCofan() throws MozartSessionException {
		listApartamentoCofan = new ArrayList<ApartamentoVO>();

		List l = ReservaDelegate.instance().obterComboApartamentoCofan(
				getHotelCorrente().getIdHotel());

		for (Object o : l) {
			Object[] arr = (Object[]) o;
			ApartamentoVO ap = new ApartamentoVO();

			ap.setIdCheckin(Long.valueOf(arr[0].toString()));
			ap.setBcObservacao(arr[1].toString());
			ap.setSigla(arr[2].toString());
			ap.setBcIdApartamento(Long.valueOf(arr[3].toString()));
			this.listApartamentoCofan.add(ap);
		}

		this.request.getSession().setAttribute(SESSION_COMBO_COFAN,
				listApartamentoCofan);
	}

	public String prepararRoomList() throws MozartSessionException {
		List<ReservaApartamentoVO> listResAptoVO = (List) this.request
				.getSession().getAttribute(SESSION_RESERVA_APARTAMENTO);
		// Adicionando a quantidade de room list que deve ter para cada
		// apartamento e depois será removida se n for utilizada
		RoomListVO roomListVO = null;
		for (ReservaApartamentoVO objVO : listResAptoVO) {
			while (objVO.getListRoomList().size() < objVO.getBcQtdePax()) {
				roomListVO = new RoomListVO();
				roomListVO.setBcTemp("TEMP");
				objVO.getListRoomList().add(roomListVO);
			}
		}
		// Fim Adicionando a quantidade de room list que deve ter para cada
		// apartamento e depois será removida se n for utilizada
		return "sucessoResRoomList";
	}

	public String prepararDiarias() throws MozartSessionException {
		return "sucessoDiarias";
	}

	public String excluirPagamento() throws MozartSessionException {
		warn("Excluir pagamento");
		List<PagamentoReservaVO> listPagamentoReserva = (List) this.request
				.getSession().getAttribute(SESSION_PAGAMENTO_RESERVA);

		PagamentoReservaVO pgtoRes= listPagamentoReserva.get(Integer.parseInt(this.indicePagamento));
		if( ! MozartUtil.isNull(pgtoRes.getBcIdMovimentoApartamento())){
			String mensagem = "Não é possível excluir pagamento lançado na recepção";
			addMensagemErro(mensagem);
			return prepararReservaPagamento();
		}
		
		listPagamentoReserva.remove(Integer.parseInt(this.indicePagamento));

		excluirMovimentoApartamento();

		return prepararReservaPagamento();
	}

	public void excluirMovimentoApartamento() throws MozartSessionException {
		warn("Excluir Movimento Apartamento");
		List<MovimentoApartamentoEJB> listMovimentoApartamento = (List) this.request
				.getSession().getAttribute(SESSION_MOVIMENTO_APARTAMENTO);

		if (listMovimentoApartamento != null
				&& !listMovimentoApartamento.isEmpty())
			listMovimentoApartamento.remove(Integer
					.parseInt(this.indicePagamento));

		this.request.getSession().setAttribute(SESSION_MOVIMENTO_APARTAMENTO,
				listMovimentoApartamento);
		if (movimentoApartamento != null) {

			movimentoApartamento.setCheckinEJB(new CheckinEJB());
		}
	}

	public String adicionarPagamento() throws MozartSessionException {
		warn("adicionar pagamento");
		ApartamentoVO cofan = null;
		List<PagamentoReservaVO> listPagamentoReserva = (List) this.request
				.getSession().getAttribute(SESSION_PAGAMENTO_RESERVA);

		List<ApartamentoVO> listCofan = (List<ApartamentoVO>) this.request
				.getSession().getAttribute(SESSION_COMBO_COFAN);
		this.pagamentoReservaVO.setBcBandeira(this.formaPgtoSel);

		listPagamentoReserva.add(this.pagamentoReservaVO);
		if (movimentoApartamento != null) {
			for (ApartamentoVO obj : listCofan) {
				if (obj.getIdCheckin().equals(
						movimentoApartamento.getCheckinEJB().getIdCheckin())) {
					cofan = obj;
				}
			}
			if (cofan != null) {
				pagamentoReservaVO.setBcIdApartamento(cofan.getBcIdApartamento());
				pagamentoReservaVO.setDsAptoCofan(cofan.getBcObservacao()
						.split(" - ")[0]);
			}
		}

		adicionarMovimentoApartamento();

		return prepararReservaPagamento();
	}

	private void adicionarMovimentoApartamento() throws MozartSessionException {
		warn("adicionar Movimento Apartamento");

		List<MovimentoApartamentoEJB> listMovimentoApto = (List) this.request
				.getSession().getAttribute(SESSION_MOVIMENTO_APARTAMENTO);

		TipoLancamentoEJB tpLancamento = new TipoLancamentoEJB();
		TipoLancamentoEJBPK tpLPK = new TipoLancamentoEJBPK();
		tpLPK.idTipoLancamento = pagamentoReservaVO.getBcIdTipoLancamento();
		tpLPK.idHotel = getHotelCorrente().getIdHotel();

		tpLancamento = (TipoLancamentoEJB) CheckinDelegate.instance()
				.obterTipoLancamentoByPK(tpLPK);
		if (MozartUtil.isNull(movimentoApartamento)) {
			movimentoApartamento = new MovimentoApartamentoEJB();
		}
		movimentoApartamento.setTipoLancamentoEJB(tpLancamento);

		if (null== listMovimentoApto)
			listMovimentoApto = new ArrayList<MovimentoApartamentoEJB>();

		listMovimentoApto.add(movimentoApartamento);

		this.request.getSession().setAttribute(SESSION_MOVIMENTO_APARTAMENTO,
				listMovimentoApto);
		if (movimentoApartamento != null
				&& movimentoApartamento.getCheckinEJB() == null) {
			movimentoApartamento.setCheckinEJB(new CheckinEJB());
		}
	}

	private void initCombo() throws MozartSessionException {
		initComboReservaApto();
		initCombosTelaReserva();
	}

	private void initCombosTelaReserva() throws MozartSessionException {
		List<MozartComboWeb> listaSimNao = new ArrayList();
		listaSimNao.add(new MozartComboWeb("S", "Sim"));
		listaSimNao.add(new MozartComboWeb("N", "Não"));
		this.request.getSession().setAttribute("ListaSimNao", listaSimNao);

		List<MozartComboWeb> listaOcupacaoDisponibilidade = new ArrayList();
		listaOcupacaoDisponibilidade.add(new MozartComboWeb("1", "Ocupação"));
		listaOcupacaoDisponibilidade.add(new MozartComboWeb("0",
				"Disponibilidade"));
		this.request.getSession().setAttribute("listaOcupacaoDisponibilidade",
				listaOcupacaoDisponibilidade);

		List<MozartComboWeb> listaEmpresaHospede = new ArrayList();
		listaEmpresaHospede.add(new MozartComboWeb("E", "Empresa"));
		listaEmpresaHospede.add(new MozartComboWeb("H", "Hospede"));
		this.request.getSession().setAttribute("ListaEmpresaHospede",
				listaEmpresaHospede);

		List<MozartComboWeb> listaFormaReserva = new ArrayList();
		listaFormaReserva.add(new MozartComboWeb("E-mail".toUpperCase(),
				"E-mail"));
		listaFormaReserva.add(new MozartComboWeb("Fax".toUpperCase(), "Fax"));
		listaFormaReserva.add(new MozartComboWeb("Telefone".toUpperCase(),
				"Telefone"));
		listaFormaReserva.add(new MozartComboWeb("Walk-In".toUpperCase(),
				"Walk-In"));
		listaFormaReserva.add(new MozartComboWeb("Outras".toUpperCase(),
				"Outras"));
		this.request.getSession().setAttribute("ListaFormaReserva",
				listaFormaReserva);

		List<MozartComboWeb> listaTipoMidia = new ArrayList();

		for (ReservaMidiaEJB rm : ReservaDelegate.instance()
				.obterListaReservaMidia()) {
			listaTipoMidia.add(new MozartComboWeb(rm.getIdReservaMidia()
					.toString(), rm.getDsReservaMidia()));
		}

		this.request.getSession()
				.setAttribute("ListaTipoMidia", listaTipoMidia);

		List<MozartComboWeb> listaTipoPensao = new ArrayList();
		listaTipoPensao.add(new MozartComboWeb("NAO", "Sem café"));
		listaTipoPensao.add(new MozartComboWeb("SIM", "Com café"));
		listaTipoPensao.add(new MozartComboWeb("FAP", "FAP"));
		listaTipoPensao.add(new MozartComboWeb("MAP", "MAP"));
		listaTipoPensao.add(new MozartComboWeb("ALL", "All Inclusive"));
		this.request.getSession().setAttribute("ListaTipoPensao",
				listaTipoPensao);

		this.request.getSession().setAttribute("moedaList",
				CheckinDelegate.instance().pesquisarMoeda());
	}

	private void initComboReservaApto() throws MozartSessionException {
		TipoApartamentoVO tipoApartamentoVO = new TipoApartamentoVO();
		tipoApartamentoVO.setBcIdHotel(getIdHoteis()[0]);
		this.listTipoApto = ReservaDelegate.instance()
				.obterTipoApartamentoPorHotel(tipoApartamentoVO);
		this.listTipoApto.add(0, new TipoApartamentoVO());

		this.listTipoPax = new ArrayList();
		this.listTipoPax.add(new TipoPaxVO(new Long(0L), ""));
		this.listTipoPax.add(new TipoPaxVO(new Long(1L), "Single"));
		this.listTipoPax.add(new TipoPaxVO(new Long(2L), "Double"));
		this.listTipoPax.add(new TipoPaxVO(new Long(3L), "Triple"));
		this.listTipoPax.add(new TipoPaxVO(new Long(4L), "Quadruple"));
		this.listTipoPax.add(new TipoPaxVO(new Long(5L), "Fivefold"));
		this.listTipoPax.add(new TipoPaxVO(new Long(6L), "Sixfold"));
		this.listTipoPax.add(new TipoPaxVO(new Long(7L), "Sevenfold"));

		TipoDiariaVO tipoDiariaVO = new TipoDiariaVO();
		tipoDiariaVO.setBcIdRedeHotel(getIdHoteis()[0]);
		this.listTipoDiaria = ReservaDelegate.instance()
				.obterTipoDiariaPorHotel(tipoDiariaVO);
	}

	public String pesquisarReservas() {
		try {
			info("Pesquisando reserva");
			this.filtro.setIdHoteis(getIdHoteis());
			if (this.origemCrs.booleanValue()) {
				CentralReservasRedeEJB crsRede = new CentralReservasRedeEJB();
				CentralReservasRedeEJBPK pk = new CentralReservasRedeEJBPK();
				pk.setIdCentralReservas(getCentralReservaEJB()
						.getIdCentralReservas());
				pk.setIdRedeHotel(getControlaData().getIdRedeHotel()
						.longValue());
				crsRede.setId(pk);

				if (getCentralReservaEJB().getCentralReservasRedeHotel()
						.contains(crsRede)) {

					crsRede = (CentralReservasRedeEJB) getCentralReservaEJB()
							.getCentralReservasRedeHotel().get(
									getCentralReservaEJB()
											.getCentralReservasRedeHotel()
											.indexOf(crsRede));
				}
				if (("S".equals(crsRede.getAtivo()))
						&& ("N".equals(crsRede.getCrsPropria()))) {
					this.filtro.getIdCrs().setTipo("I");
					this.filtro.getIdCrs().setTipoIntervalo("2");
					this.filtro.getIdCrs().setValorInicial(
							String.valueOf(getCentralReservaEJB()
									.getIdCentralReservas()));
				}
			}
			this.filtro.setBcBloqueio("N");
			List<ReservaVO> lista = ReservaDelegate.instance()
					.pesquisarReservas(this.filtro);
			if (MozartUtil.isNull(lista)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}
			this.request.getSession().setAttribute("listaPesquisaReserva",
					lista);
		} catch (Exception ex) {
			addMensagemErro("Erro ao pesquisar reservas");
			error(ex.getMessage());
			this.filtro = null;
		}
		return "sucesso";
	}

	public String salvarReserva() {
		try {
			info("Salvando a reserva");
			Date agora = new Date();
			EmpresaHotelVO empresaHotelVO = (EmpresaHotelVO) this.request
					.getSession().getAttribute(SESSION_EMPRESA_HOTEL);
			if (this.origemCrs.booleanValue()
					|| getUsuario().getRedeHotelEJB() != null) {
				this.reservaVO
						.setBcIdCentralReservas(Long
								.valueOf(getCentralReservaEJB()
										.getIdCentralReservas()));
			}
			if (this.isBloqueio.booleanValue()) {
				this.reservaVO.setBcBloqueio("S");
				this.reservaVO.setBcGrupo("S");
			} else {
				this.reservaVO.setBcBloqueio("N");
			}
			this.reservaVO.setBcIdCidadeContato(empresaHotelVO.getBcIdCidade());
			this.reservaVO.setBcCheckin("N");
			this.reservaVO.setBcCortesia("N");
			this.reservaVO.setBcAlterando("N");
			this.reservaVO.setBcIdReservaMida(null);

			this.reservaVO.setBcIdHotel(getHotelCorrente().getIdHotel());
			this.reservaVO.setBcReservaJava("S");
			this.reservaVO.setEmpresaHotelVO(empresaHotelVO);

			this.reservaVO.setListReservaApartamento((List) this.request
					.getSession().getAttribute(SESSION_RESERVA_APARTAMENTO));

			this.reservaVO.setListPagamento((List) this.request.getSession()
					.getAttribute(SESSION_PAGAMENTO_RESERVA));

			this.reservaVO.setListMovimentoApartamento((List) this.request
					.getSession().getAttribute(SESSION_MOVIMENTO_APARTAMENTO));

			// colocando o roomlist na reserva e setando o id da reserva em
			// reserva apartamento
			for (ReservaApartamentoVO obj : reservaVO
					.getListReservaApartamento()) {
				if (obj.getBcIdReservaApartamento() == null
						|| obj.getBcIdReservaApartamento().equals(new Long(0)))
					obj.setBcIdReservaApartamento(ReservaDelegate.instance()
							.obterNextVal());
				if (obj.getBcIdReserva() == null
						|| obj.getBcIdReserva().equals(new Long(0)))
					obj.setBcIdReserva(reservaVO.getBcIdReserva());
				obj.setBcIdHotel(reservaVO.getBcIdHotel());
				if (obj.getBcQtdeCheckin() == null)
					obj.setBcQtdeCheckin(new Long(0));
				obj.setBcMaster("N");
				// setando os campos do room list
				for (RoomListVO objRL : obj.getListRoomList()) {
					if (objRL.getBcIdRoomList() == null
							|| objRL.getBcIdRoomList().equals(new Long(0)))
						objRL.setBcIdRoomList(ReservaDelegate.instance()
								.obterNextVal());
					objRL.setBcIdReserva(obj.getBcIdReserva());
					objRL.setBcIdReservaApartamento(obj
							.getBcIdReservaApartamento());
					objRL.setBcIdHotel(obj.getBcIdHotel());
				}
				// fim setando os campos do room list
				// setando os campos de reserva_apartamento diaria
				for (ReservaApartamentoDiariaVO objRAD : obj
						.getListReservaApartamentoDiaria()) {
					objRAD.setBcIdReservaApartamentoDiaria(ReservaDelegate
							.instance().obterNextVal()); // Na alteração, sempre
					// exclui todos...
					// entao pdoe gerar
					// ids...
					objRAD.setBcIdHotel(obj.getBcIdHotel());
					objRAD.setBcIdReservaApartamento(obj
							.getBcIdReservaApartamento());
					objRAD.setBcIdMoeda(idMoeda);
					objRAD.setBcIdReserva(obj.getBcIdReserva());
				}
				// fim setando os campos de reserva_apartamento diaria
			}
			for (PagamentoReservaVO objPR : this.reservaVO.getListPagamento()) {
				if ("A".equals(objPR.getBcFormaPg())){
					
				}
				objPR.setBcIdReserva(this.reservaVO.getBcIdReserva());
				objPR.setBcIdHotel(this.reservaVO.getBcIdHotel());
				objPR.setBcDataConfirma(agora);
				objPR.setBcConfirma("N");
				if ((objPR.getBcIdPagamentoReserva() == null)
						|| (objPR.getBcIdPagamentoReserva()
								.equals(new Long(0L)))) {
					objPR.setBcIdPagamentoReserva(ReservaDelegate.instance()
							.obterNextVal());
				}
			}
			int index = 0;
			initComboApantamentoCofan();
			if (this.reservaVO.getListMovimentoApartamento() != null) {

				for (MovimentoApartamentoEJB objMov : this.reservaVO
						.getListMovimentoApartamento()) {

					if(! "A".equalsIgnoreCase(reservaVO.getListPagamento().get(index).getBcFormaPg())){
						index++;
						continue;
					}
										
					if (!MozartUtil.isNull(objMov)
							&& !MozartUtil.isNull(objMov.getCheckinEJB())
							&& !MozartUtil.isNull(objMov.getCheckinEJB()
									.getIdCheckin())
							&& !(objMov.getCheckinEJB().getIdCheckin()
									.longValue() == 0L)) { 
  
						CheckinEJB checkinCorrente = CheckinDelegate.instance()
								.obterCheckin(
										objMov.getCheckinEJB().getIdCheckin());
						RoomListEJB roomList = checkinCorrente
								.getRoomListPrincipal();
						ApartamentoVO cofan = new ApartamentoVO();
						for (ApartamentoVO o : listApartamentoCofan) {
							if (o.getIdCheckin().equals(
									checkinCorrente.getIdCheckin())) {
								cofan = o;
							}
						}

						objMov.setRoomListEJB(roomList);
						objMov.setCheckinEJB(checkinCorrente);
						objMov.setQuemPaga(this.diariaTotalIdIdentificaLancamento1);

						objMov.setNumDocumento(reservaVO.getBcIdReserva()
								+ " - "
								+ MozartUtil.format(reservaVO
										.getBcDataEntrada()));

						objMov.setDataLancamento(new Timestamp(
								getControlaData().getFrontOffice().getTime()));
						objMov.setHoraLancamento(new Timestamp(new Date()
								.getTime()));
						objMov.setCheckout("N");
						objMov.setMovTmp("S");
						objMov.setIdRedeHotel(getHotelCorrente()
								.getRedeHotelEJB().getIdRedeHotel());

						objMov.setParcial("N");
						objMov.setIdTipoDiaria(null);
						objMov.setValorPensao(checkinCorrente
								.getApartamentoEJB().getCofan().equals("S") ? null
								: checkinCorrente.getReservaEJB()
										.getValorPensao());

						objMov.setValorLancamento(reservaVO.getListPagamento()
								.get(index).getBcValor());

						if ("C".equals(objMov.getTipoLancamentoEJB()
								.getDebitoCredito())) {
							objMov.setValorLancamento(Double
									.valueOf(objMov.getValorLancamento()
											.doubleValue() * -1.0D));
						}
						objMov.setUsuario(getUserSession().getUsuarioEJB());

						StatusNotaEJB notaPagamento = null;
						if ("2".equals(objMov.getTipoLancamentoEJB()
								.getIdentificaLancamento().getReceitaCheckout())) {
							HotelEJB pHotel = getHotelCorrente();
							pHotel.setUsuario(getUserSession().getUsuarioEJB());

							notaPagamento = CheckinDelegate.instance()
									.obterProximaNotaHospedagem(pHotel);
							notaPagamento.setIdCheckin(checkinCorrente
									.getIdCheckin());
							notaPagamento.setUsuario(getUserSession()
									.getUsuarioEJB());
							notaPagamento = (StatusNotaEJB) CheckinDelegate
									.instance().alterar(notaPagamento);

							objMov.setStatusNotaEJB(notaPagamento);

							objMov.setIdNr(notaPagamento.getIdNota());

							this.request.setAttribute(
									"abrirPopupReciboPagamento", "true");
						}

						if (notaPagamento != null) {
							List<MovimentoApartamentoEJB> movimentoReciboPagamento = new ArrayList();
							movimentoReciboPagamento.add(objMov);
							this.request.setAttribute("notaHospedagem",
									notaPagamento);
							this.request.setAttribute(
									"movimentoReciboPagamento",
									movimentoReciboPagamento);
						}

						
					}
					if(MozartUtil.isNull(objMov.getIdMovimentoApartamento())){
						objMov.setIdMovimentoApartamento(ReservaDelegate
								.instance().obterNextVal());
					}
					
					reservaVO.getListPagamento()
					.get(index).setBcIdMovimentoApartamento(objMov.getIdMovimentoApartamento());
					
					index++;
				}
			}

			this.reservaVO.getListReservaGrupoLancamento().add(
					getNovoResGrupLanc(this.reservaVO.getEmpresaHotelVO()
							.getBcIdEmpresa(), this.reservaVO.getBcIdHotel(),
							new Long(1L), this.reservaVO.getBcIdReserva(),
							this.diariaTotalIdIdentificaLancamento1));
			this.reservaVO.getListReservaGrupoLancamento().add(
					getNovoResGrupLanc(this.reservaVO.getEmpresaHotelVO()
							.getBcIdEmpresa(), this.reservaVO.getBcIdHotel(),
							new Long(4L), this.reservaVO.getBcIdReserva(),
							this.alimentosEBebidasIdIdentificaLancamento4));
			this.reservaVO
					.getListReservaGrupoLancamento()
					.add(getNovoResGrupLanc(this.reservaVO.getEmpresaHotelVO()
							.getBcIdEmpresa(), this.reservaVO.getBcIdHotel(),
							new Long(6L), this.reservaVO.getBcIdReserva(),
							this.telefoniaEComunicacoesIdIdentificaLancamento6));
			this.reservaVO.getListReservaGrupoLancamento().add(
					getNovoResGrupLanc(this.reservaVO.getEmpresaHotelVO()
							.getBcIdEmpresa(), this.reservaVO.getBcIdHotel(),
							new Long(8L), this.reservaVO.getBcIdReserva(),
							this.lavanderiaIdIdentificaLancamento8));
			this.reservaVO.getListReservaGrupoLancamento().add(
					getNovoResGrupLanc(this.reservaVO.getEmpresaHotelVO()
							.getBcIdEmpresa(), this.reservaVO.getBcIdHotel(),
							new Long(21L), this.reservaVO.getBcIdReserva(),
							this.receitaOutrasIdIdentificaLancamento21));

			this.reservaVO.setUsuario(getUserSession().getUsuarioEJB());
			if (request.getSession().getAttribute(SESSION_OPERACAO_TELA)
					.equals(ALTERACAO))
				ReservaDelegate.instance().atualizarReserva(reservaVO);
			else if ("S".equals(reservaVO.getBcGrupo()))// Reserva de grupo
				ReservaDelegate.instance().salvarReserva(reservaVO);
			else {// Reservas multiplas
				ReservaVO reservaObj = null;
				for (ReservaApartamentoVO obj : reservaVO
						.getListReservaApartamento()) {
					reservaObj = (ReservaVO) reservaVO.clone(reservaVO);
					reservaObj.setBcIdReserva(obj.getBcIdReserva());
					reservaObj.setBcDataEntrada(obj.getBcDataEntrada());
					reservaObj.setBcDataSaida(obj.getBcDataSaida());
					reservaObj.getListReservaApartamento().clear();
					reservaObj.getListReservaApartamento().add(obj);
					for (PagamentoReservaVO objPR : reservaObj
							.getListPagamento()) {
						objPR.setBcIdReserva(reservaObj.getBcIdReserva());
						objPR.setBcIdPagamentoReserva(ReservaDelegate
								.instance().obterNextVal());
					}
					for (ReservaGrupoLancamentoVO objRGL : reservaObj
							.getListReservaGrupoLancamento())
						objRGL.setBcIdReserva(reservaObj.getBcIdReserva());

					reservaObj.setUsuario(getUserSession().getUsuarioEJB());
					reservaVO.setBcIdReserva(reservaObj.getBcIdReserva());
					ReservaDelegate.instance().salvarReserva(reservaObj);

				}

			}
			addMensagemSucesso("Operação realizada com sucesso.");
			if (this.origemCrs.booleanValue()) {
				prepararPesquisaCRS();
			} else {
				prepararPesquisa();
			}
			if ("S".equalsIgnoreCase(this.imprimirVoucher)) {
				this.reservaVO
						.setGracIdReservaIdReservaApartamento(this.reservaVO
								.getBcIdReserva() + ",");
				prepararEnviarReservaPorEmail();
				return "sucesso_email";
			}
			return "pesquisa";
		} catch (MozartValidateException ex) {
			addMensagemSucesso(ex.getMessage());
			error(ex.getMessage());
			return "sucesso";
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return "sucesso";
	}

	private ReservaGrupoLancamentoVO getNovoResGrupLanc(Long idEmpresa,
			Long idHotel, Long idIdentificaLancamento, Long idReserva,
			String quemPaga) {
		ReservaGrupoLancamentoVO resG = new ReservaGrupoLancamentoVO();
		resG.setBcIdEmpresa(idEmpresa);
		resG.setBcIdHotel(idHotel);
		resG.setBcIdIdentificaLancamento(idIdentificaLancamento);
		resG.setBcIdReserva(idReserva);
		resG.setBcQuemPaga(quemPaga);
		return resG;
	}

	public String pesquisarOcupacaoDisponibilidade() {
		try {
			ControlaDataEJB controladata = (ControlaDataEJB) this.request
					.getSession().getAttribute("CONTROLA_DATA_SESSION");
			if ((this.reservaVO.getBcDataEntrada() == null)
					|| (this.reservaVO.getBcDataSaida() == null)) {
				this.reservaVO.setBcDataEntrada(controladata.getFrontOffice());
				this.reservaVO.setBcDataSaida(MozartUtil.incrementarDia(
						controladata.getFrontOffice(), 1));
				this.reservaVO.setOcupacaoDisponibilidade(new Long(1L));
			}
			this.reservaVO.setBcIdHotel(getHotelCorrente().getIdHotel());
			List<OcupDispVO> listOcupDisp = ReservaDelegate.instance()
					.obterOcupacaoDisponibilidade(this.reservaVO);
			this.request.getSession()
					.setAttribute("listOcupDisp", listOcupDisp);
		} catch (Exception ex) {
			addMensagemErro("Erro ao pesquisar ocupação/disponibilidade");
			error(ex.getMessage());
			this.filtro = null;
		}
		return "sucessoOcupacaoDisponibilidade";
	}

	public String cancelarReserva() {
		return "pesquisa";
	}

	public void setListTipoApto(List<TipoApartamentoVO> listTipoApto) {
		this.listTipoApto = listTipoApto;
	}

	public List<TipoApartamentoVO> getListTipoApto() {
		return this.listTipoApto;
	}

	public void setListTipoPax(List<TipoPaxVO> listTipoPax) {
		this.listTipoPax = listTipoPax;
	}

	public List<TipoPaxVO> getListTipoPax() {
		return this.listTipoPax;
	}

	public void setListTipoDiaria(List<TipoDiariaVO> listTipoDiaria) {
		this.listTipoDiaria = listTipoDiaria;
	}

	public List<TipoDiariaVO> getListTipoDiaria() {
		return this.listTipoDiaria;
	}

	public void setIndiceResApto(String indiceResApto) {
		this.indiceResApto = indiceResApto;
	}

	public String getIndiceResApto() {
		return this.indiceResApto;
	}

	public void setIndiceHospede(String indiceHospede) {
		this.indiceHospede = indiceHospede;
	}

	public String getIndiceHospede() {
		return this.indiceHospede;
	}

	public void setIndicePagamento(String indicePagamento) {
		this.indicePagamento = indicePagamento;
	}

	public String getIndicePagamento() {
		return this.indicePagamento;
	}

	public void setFiltro(ReservaVO filtro) {
		this.filtro = filtro;
	}

	public ReservaVO getFiltro() {
		return this.filtro;
	}

	public void setFiltroBloqueio(ReservaVO filtroBloqueio) {
		this.filtroBloqueio = filtroBloqueio;
	}

	public ReservaVO getFiltroBloqueio() {
		return filtroBloqueio;
	}

	public void setEmpresaHotelVO(EmpresaHotelVO empresaHotelVO) {
		this.empresaHotelVO = empresaHotelVO;
	}

	public EmpresaHotelVO getEmpresaHotelVO() {
		return this.empresaHotelVO;
	}

	public void setReservaVO(ReservaVO reservaVO) {
		this.reservaVO = reservaVO;
	}

	public ReservaVO getReservaVO() {
		return this.reservaVO;
	}

	public ReservaVO getReservaBloqueioVO() {
		return reservaBloqueioVO;
	}

	public void setReservaBloqueioVO(ReservaVO reservaBloqueioVO) {
		this.reservaBloqueioVO = reservaBloqueioVO;
	}

	public void setReservaApartamentoVO(
			ReservaApartamentoVO reservaApartamentoVO) {
		this.reservaApartamentoVO = reservaApartamentoVO;
	}

	public ReservaApartamentoVO getReservaApartamentoVO() {
		return this.reservaApartamentoVO;
	}

	public void setDiariaTotalIdIdentificaLancamento1(
			String diariaTotalIdIdentificaLancamento1) {
		this.diariaTotalIdIdentificaLancamento1 = diariaTotalIdIdentificaLancamento1;
	}

	public String getDiariaTotalIdIdentificaLancamento1() {
		return this.diariaTotalIdIdentificaLancamento1;
	}

	public void setAlimentosEBebidasIdIdentificaLancamento4(
			String alimentosEBebidasIdIdentificaLancamento4) {
		this.alimentosEBebidasIdIdentificaLancamento4 = alimentosEBebidasIdIdentificaLancamento4;
	}

	public String getAlimentosEBebidasIdIdentificaLancamento4() {
		return this.alimentosEBebidasIdIdentificaLancamento4;
	}

	public void setTelefoniaEComunicacoesIdIdentificaLancamento6(
			String telefoniaEComunicacoesIdIdentificaLancamento6) {
		this.telefoniaEComunicacoesIdIdentificaLancamento6 = telefoniaEComunicacoesIdIdentificaLancamento6;
	}

	public String getTelefoniaEComunicacoesIdIdentificaLancamento6() {
		return this.telefoniaEComunicacoesIdIdentificaLancamento6;
	}

	public void setLavanderiaIdIdentificaLancamento8(
			String lavanderiaIdIdentificaLancamento8) {
		this.lavanderiaIdIdentificaLancamento8 = lavanderiaIdIdentificaLancamento8;
	}

	public String getLavanderiaIdIdentificaLancamento8() {
		return this.lavanderiaIdIdentificaLancamento8;
	}

	public void setReceitaOutrasIdIdentificaLancamento21(
			String receitaOutrasIdIdentificaLancamento21) {
		this.receitaOutrasIdIdentificaLancamento21 = receitaOutrasIdIdentificaLancamento21;
	}

	public String getReceitaOutrasIdIdentificaLancamento21() {
		return this.receitaOutrasIdIdentificaLancamento21;
	}

	public void setPagamentoReservaVO(PagamentoReservaVO pagamentoReservaVO) {
		this.pagamentoReservaVO = pagamentoReservaVO;
	}

	public PagamentoReservaVO getPagamentoReservaVO() {
		return this.pagamentoReservaVO;
	}

	public void setListFormaPgto(List<PagamentoReservaVO> listFormaPgto) {
		this.listFormaPgto = listFormaPgto;
	}

	public List<PagamentoReservaVO> getListFormaPgto() {
		return this.listFormaPgto;
	}

	public void setFormaPgtoSel(String formaPgtoSel) {
		this.formaPgtoSel = formaPgtoSel;
	}

	public String getFormaPgtoSel() {
		return this.formaPgtoSel;
	}

	public void setNomeHospede(String nomeHospede) {
		this.nomeHospede = nomeHospede;
	}

	public String getNomeHospede() {
		return this.nomeHospede;
	}

	public void setIdHospedeSelecionado(String idHospedeSelecionado) {
		this.idHospedeSelecionado = idHospedeSelecionado;
	}

	public String getIdHospedeSelecionado() {
		return this.idHospedeSelecionado;
	}

	public void setQtdePax(String qtdePax) {
		this.qtdePax = qtdePax;
	}

	public String getQtdePax() {
		return this.qtdePax;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setGridCor(String gridCor) {
		this.gridCor = gridCor;
	}

	public String getGridCor() {
		return this.gridCor;
	}

	public void setDisplay(String display) {
		this.display = display;
	}

	public String getDisplay() {
		return this.display;
	}

	public void setGridCorTotal(String gridCorTotal) {
		this.gridCorTotal = gridCorTotal;
	}

	public String getGridCorTotal() {
		return this.gridCorTotal;
	}

	public void setOcupacaoDisponibilidade(String ocupacaoDisponibilidade) {
		this.ocupacaoDisponibilidade = ocupacaoDisponibilidade;
	}

	public String getOcupacaoDisponibilidade() {
		return this.ocupacaoDisponibilidade;
	}

	public void setGridCorLetra(String gridCorLetra) {
		this.gridCorLetra = gridCorLetra;
	}

	public String getGridCorLetra() {
		return this.gridCorLetra;
	}

	public void setGridCorTotalLetra(String gridCorTotalLetra) {
		this.gridCorTotalLetra = gridCorTotalLetra;
	}

	public String getGridCorTotalLetra() {
		return this.gridCorTotalLetra;
	}

	public Boolean getOrigemCrs() {
		return this.origemCrs;
	}

	public void setOrigemCrs(Boolean origemCrs) {
		this.origemCrs = origemCrs;
	}

	public Boolean getIsBloqueio() {
		return isBloqueio;
	}

	public void setIsBloqueio(Boolean isBloqueio) {
		this.isBloqueio = isBloqueio;
	}

	public Long getIdHotelCRS() {
		return this.idHotelCRS;
	}

	public void setIdHotelCRS(Long idHotelCRS) {
		this.idHotelCRS = idHotelCRS;
	}

	public Long getIdTarifaCRS() {
		return this.idTarifaCRS;
	}

	public void setIdTarifaCRS(Long idTarifaCRS) {
		this.idTarifaCRS = idTarifaCRS;
	}

	public CrsVO getFiltroCRS() {
		return this.filtroCRS;
	}

	public void setFiltroCRS(CrsVO filtroCRS) {
		this.filtroCRS = filtroCRS;
	}

	public String getIdTipoAptoCRS() {
		return this.idTipoAptoCRS;
	}

	public void setIdTipoAptoCRS(String idTipoAptoCRS) {
		this.idTipoAptoCRS = idTipoAptoCRS;
	}

	public ReservaMapaOcupacaoVO getFiltroMapa() {
		return this.filtroMapa;
	}

	public void setFiltroMapa(ReservaMapaOcupacaoVO filtroMapa) {
		this.filtroMapa = filtroMapa;
	}

	public String getEmailPara() {
		return this.emailPara;
	}

	public void setEmailPara(String emailPara) {
		this.emailPara = emailPara;
	}

	public String getEmailCC() {
		return this.emailCC;
	}

	public void setEmailCC(String emailCC) {
		this.emailCC = emailCC;
	}

	public String getEmailBody() {
		return this.emailBody;
	}

	public void setEmailBody(String emailBody) {
		this.emailBody = emailBody;
	}

	public String getSomenteReservaApartamento() {
		return this.somenteReservaApartamento;
	}

	public void setSomenteReservaApartamento(String somenteReservaApartamento) {
		this.somenteReservaApartamento = somenteReservaApartamento;
	}

	public String getImprimirVoucher() {
		return this.imprimirVoucher;
	}

	public void setImprimirVoucher(String imprimirVoucher) {
		this.imprimirVoucher = imprimirVoucher;
	}

	public Long getIdMoeda() {
		return this.idMoeda;
	}

	public void setIdMoeda(Long idMoeda) {
		this.idMoeda = idMoeda;
	}

	public List getListApartamentoCofan() {
		return listApartamentoCofan;
	}

	public void setListApartamentoCofan(List listApartamentoCofan) {
		this.listApartamentoCofan = listApartamentoCofan;
	}

	public MovimentoApartamentoEJB getMovimentoApartamento() {
		return movimentoApartamento;
	}

	public void setMovimentoApartamento(
			MovimentoApartamentoEJB movimentoApartamento) {
		this.movimentoApartamento = movimentoApartamento;
	}

	public Boolean getAtivarCofan() {
		return ativarCofan;
	}

	public void setAtivarCofan(Boolean ativarCofan) {
		this.ativarCofan = ativarCofan;
	}

	public Long getIdIdentificaLancamento() {
		return idIdentificaLancamento;
	}

	public void setIdIdentificaLancamento(Long idIdentificaLancamento) {
		this.idIdentificaLancamento = idIdentificaLancamento;
	}

	public Boolean getEhAlteracao() {
		return ehAlteracao;
	}

	public void setEhAlteracao(Boolean ehAlteracao) {
		this.ehAlteracao = ehAlteracao;
	}
	
}