package com.mozart.web.actions.reserva.bloqueio;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.TreeMap;
import java.util.Vector;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.EmailDelegate;
import com.mozart.model.delegate.EmpresaDelegate;
import com.mozart.model.delegate.ReservaDelegate;
import com.mozart.model.delegate.UsuarioDelegate;
import com.mozart.model.ejb.entity.CentralReservaEJB;
import com.mozart.model.ejb.entity.CentralReservasRedeEJB;
import com.mozart.model.ejb.entity.CentralReservasRedeEJBPK;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJBPK;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ApartamentoVO;
import com.mozart.model.vo.BloqueioVO;
import com.mozart.model.vo.CrsVO;
import com.mozart.model.vo.DisponibilidadeAptoGestaoBloqueioVO;
import com.mozart.model.vo.EmpresaHotelVO;
import com.mozart.model.vo.OcupDispVO;
import com.mozart.model.vo.PagamentoReservaVO;
import com.mozart.model.vo.QuantidadeAptoGestaoBloqueioVO;
import com.mozart.model.vo.ReservaApartamentoDiariaVO;
import com.mozart.model.vo.ReservaApartamentoVO;
import com.mozart.model.vo.ReservaGrupoLancamentoVO;
import com.mozart.model.vo.ReservaMapaOcupacaoVO;
import com.mozart.model.vo.ReservaVO;
import com.mozart.model.vo.RoomListVO;
import com.mozart.model.vo.TarifaApartamentoGestaoBloqueioVO;
import com.mozart.model.vo.TarifaVO;
import com.mozart.model.vo.TipoApartamentoVO;
import com.mozart.model.vo.TipoDiariaVO;
import com.mozart.model.vo.TipoPaxVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings("unchecked")
public class BloqueioAction extends BaseAction {
	private static final long serialVersionUID = 8699554755069029236L;
	private static final String SESSION_EMPRESA_HOTEL = "TELA_RESERVA_EMPRESA_HOTEL";
	private static final String SESSION_RESERVA_APARTAMENTO = "TELA_RESERVA_RESERVA_APARTAMENTO";
	private static final String SESSION_ROOM_LIST_ATUAL = "TELA_RESERVA_ROOM_LIST_ATUAL";
	private static final String SESSION_PAGAMENTO_RESERVA = "TELA_RESERVA_PAGAMENTO_RESERVA";
	private static final String SESSION_OPERACAO_TELA = "TELA_RESERVA_OPERACAO_TELA";
	private static final String INCLUSAO = "TELA_RESERVA_OPERACAO_TELA_INCLUSAO";
	private static final String ALTERACAO = "TELA_RESERVA_OPERACAO_TELA_ALTERACAO";
	private static final String EXECUTAR_SCRIPT_TELA_RSVA_APTO = "SESSAO_JAVASCRIPT_RESERVAAPTO";
	private static final String SESSION_RESERVA_APARTAMENTO_DIARIA = "TELA_RESERVA_RESERVA_APARTAMENTO_DIARIA_CORRENTE";
	private BloqueioVO filtro;
	private BloqueioVO filtroBloqueio;
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
	private String indicePagamento;
	private String indiceResApto;
	private String indiceHospede;
	private String formaPgtoSel;
	private Boolean origemCrs;
	private Boolean isBloqueio = true;
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

	private Date bcDataEntrada;
	private Date bcDataSaida;

	private boolean flagAlteracaoTarifa;
	private boolean flagAlteracaoQtdApartamento;

	private TreeMap<String, ArrayList<TarifaApartamentoGestaoBloqueioVO>> hmGridTarifa;
	private TreeMap<String, ArrayList<QuantidadeAptoGestaoBloqueioVO>> hmGridQtd;
	private TreeMap<String, ArrayList<DisponibilidadeAptoGestaoBloqueioVO>> hmGridDisp;
	private List arrayDias;

	public Long getIdApartamentoChart() {
		hmGridTarifa.getClass();
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

	public BloqueioAction() {
		this.filtro = new BloqueioVO();
		this.filtroMapa = new ReservaMapaOcupacaoVO();
		this.filtroBloqueio = new BloqueioVO();
		this.filtroCRS = new CrsVO();
		this.empresaHotelVO = new EmpresaHotelVO();
		this.reservaVO = new ReservaVO();
		this.reservaApartamentoVO = new ReservaApartamentoVO();
		this.pagamentoReservaVO = new PagamentoReservaVO();
		this.isBloqueio = true;
		this.hmGridTarifa = new TreeMap<String, ArrayList<TarifaApartamentoGestaoBloqueioVO>>();
		this.hmGridQtd = new TreeMap<String, ArrayList<QuantidadeAptoGestaoBloqueioVO>>();
		this.hmGridDisp = new TreeMap<String, ArrayList<DisponibilidadeAptoGestaoBloqueioVO>>();
		this.arrayDias = new Vector();
	}

	public String prepararRelatorio() {
		return "sucesso";
	}

	public String prepararGestaoBloqueio() throws MozartSessionException {
		this.request.getSession().removeAttribute("BLOQUEIO");
		this.request.getSession().removeAttribute("BLOQUEIO_GESTAO");

		ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
				.obter(ControlaDataEJB.class, getIdHoteis()[0]);
		
		this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);
		
		return "gestaoBloqueio";
	}

	public String excluirReserva() {
		try {
			this.reservaVO.setUsuario(getUserSession().getUsuarioEJB());
			this.reservaVO.setBcIdReserva(new Long(this.reservaVO
					.getGracIdReservaIdReservaApartamento().split(",")[0]));
			this.reservaVO.setBcApagada("S");
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

			HotelEJB hotel = new HotelEJB();
			hotel.setIdHotel(this.idHotelCRS);
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
			this.reservaVO.setBcDataEntrada(this.filtroCRS.getDataEntrada());
			this.reservaVO.setBcDataSaida(this.filtroCRS.getDataSaida());

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

			this.idMoeda = ((ReservaApartamentoDiariaVO) ((ReservaApartamentoVO) this.reservaVO
					.getListReservaApartamento().get(0))
					.getListReservaApartamentoDiaria().get(0)).getBcIdMoeda();
			this.isBloqueio = true;

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
		ReservaVO reserva = (ReservaVO) request.getSession().getAttribute(
				"BLOQUEIO");

		if (reserva != null
				&& (hmGridTarifa == null || hmGridTarifa.size() == 0)) {
			flagAlteracaoTarifa = false;
			String in = request.getParameter("bcDataEntrada");
			String out = request.getParameter("bcDataSaida");

			bcDataEntrada = MozartUtil.toDate(in);
			bcDataSaida = MozartUtil.decrementarDia(MozartUtil.toDate(out));
			
			reserva.setBcDataEntrada(new Timestamp(bcDataEntrada.getTime()));
			reserva.setBcDataSaida(new Timestamp(bcDataSaida.getTime()));
			
			List<TarifaApartamentoGestaoBloqueioVO> lista = ReservaDelegate
					.instance().obterGridTarBloqueioGestaoEmpresa(reserva);
			arrayDias = getListaDias(reserva);
			hmGridTarifa = agruparTarifaPorFantasiaPax(lista);

			request.getSession().setAttribute("LIST_DATAS", arrayDias);
			request.getSession().setAttribute("HASH_TARIFAS", hmGridTarifa);
			request.getSession().setAttribute("FLAG_ALTERACAO_TARIFA",
					flagAlteracaoTarifa);
		}

		return "sucessoTarifasGestaoBloqueio";
	}

	public String atualizarTarifasGestaoBloqueio()
			throws MozartSessionException {
		ReservaVO reserva = (ReservaVO) request.getSession().getAttribute(
				"BLOQUEIO");
		hmGridTarifa = (TreeMap<String, ArrayList<TarifaApartamentoGestaoBloqueioVO>>) request
				.getSession().getAttribute("HASH_TARIFAS");
		String grupo = request.getParameter("grupo");

		reserva.setBcDataEntrada(new Timestamp(bcDataEntrada.getTime()));
		
		arrayDias = getListaDias(reserva);

		int index = 0;
		boolean criarTarifa = false;
		for (int i = 0; i < arrayDias.size(); i++) {
			String valor = request.getParameter(grupo
					+ TarifaApartamentoGestaoBloqueioVO.CAMPO_SEPARADOR + i);
			if (valor != null && !valor.equals("")) {
				Double vl = Double.parseDouble(valor.replace(".", "").replace(
						",", "."));
				if (hmGridTarifa.containsKey(grupo)) {
					index = 0;
					criarTarifa = false;
					boolean objetoEncontrado = false;
					for (TarifaApartamentoGestaoBloqueioVO vo : hmGridTarifa
							.get(grupo)) {
						if (vo.getDtEntrada().compareTo(
								((GregorianCalendar) arrayDias.get(i))
										.getTime()) == 0) {
							objetoEncontrado = true;
							if (vo.getValor().compareTo(vl) != 0) {
								vo.setValor(vl);
								vo.setObjetoAlterado(true);
								hmGridTarifa.get(grupo).set(index, vo);
								this.flagAlteracaoTarifa = true;
								break;
							}
						}
						if (!objetoEncontrado
								&& index == hmGridTarifa.get(grupo).size() - 1) {
							criarTarifa = true;
						}
						index++;
					}

					if (criarTarifa) {
						TarifaApartamentoGestaoBloqueioVO vo = new TarifaApartamentoGestaoBloqueioVO();
						String dados[] = grupo
								.replace(
										TarifaApartamentoGestaoBloqueioVO.CAMPO_SEPARADOR,
										"-").split("-");
						vo.setDsFantasia(dados[0]);
						vo.setPax(dados[1]);
						vo.setDtEntrada(((GregorianCalendar) arrayDias.get(i))
								.getTime());
						vo.setDtSaida(((GregorianCalendar) arrayDias.get(i))
								.getTime());
						vo.setValor(vl);
						vo.setIdHotel(getHotelCorrente().getIdHotel());
						vo.setObjetoAlterado(true);
						vo.setIdEmpresa(reserva.getBcIdEmpresa());
						vo.setIdMoeda(1L);// /////<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
											// VALOR PADRÃO DO ID MOEDA: 1
						this.flagAlteracaoTarifa = true;
						hmGridTarifa.get(grupo).add(vo);
					}

				}
			}
		}
		request.getSession().setAttribute("FLAG_ALTERACAO_TARIFA",
				flagAlteracaoTarifa);
		request.getSession().setAttribute("HASH_TARIFAS", hmGridTarifa);

		return "sucessoTarifasGestaoBloqueio";
	}

	public String prepararQtdeGestaoBloqueio() throws MozartSessionException {

		ReservaVO reserva = (ReservaVO) request.getSession().getAttribute(
				"BLOQUEIO");

		if (reserva != null) {
			String in = request.getParameter("bcDataEntrada");
			String out = request.getParameter("bcDataSaida");
			bcDataEntrada = MozartUtil.toDate(in);
			bcDataSaida =  MozartUtil.decrementarDia(MozartUtil.toDate(out));
			reserva.setBcDataEntrada(new Timestamp(bcDataEntrada.getTime()));
			reserva.setBcDataSaida(new Timestamp(bcDataSaida.getTime()));
			
			if (hmGridQtd == null || hmGridQtd.size() == 0) {
				flagAlteracaoQtdApartamento = false;

				List<QuantidadeAptoGestaoBloqueioVO> lista = ReservaDelegate
						.instance().obterGridQtdAptoBloqTipo(reserva);
				arrayDias = getListaDias(reserva);
				hmGridQtd = agruparQtdPorFantasia(lista);

				request.getSession().setAttribute("HASH_QTD", hmGridQtd);
			}

			if (hmGridDisp == null || hmGridDisp.size() == 0) {

				List<DisponibilidadeAptoGestaoBloqueioVO> lista = ReservaDelegate
						.instance().obterGridDisponibilidadeAptoBloq(reserva);
				
				hmGridDisp = agruparDisponibilidadePorReserva(lista);
				
				request.getSession().setAttribute("HASH_DISP", hmGridDisp);
			}
		}
		request.getSession().setAttribute("FLAG_ALTERACAO_QTD_APTO",
				flagAlteracaoQtdApartamento);

		return "sucessoQtdeGestaoBloqueio";
	}

	public String atualizarQtdeGestaoBloqueio() throws MozartSessionException {
		
		ReservaVO reserva = (ReservaVO) request.getSession().getAttribute(
				"BLOQUEIO");

		hmGridQtd = (TreeMap<String, ArrayList<QuantidadeAptoGestaoBloqueioVO>>) request.getSession().getAttribute("HASH_QTD");
		arrayDias = getListaDias(reserva);
		String grupo = request.getParameter("grupo");

		int index = 0;
		boolean criarQuantidade = false;
		for (int i = 0; i < arrayDias.size(); i++) {
			String valor = request.getParameter(grupo
					+ QuantidadeAptoGestaoBloqueioVO.CAMPO_SEPARADOR + i);
			if (valor != null && !valor.equals("")) {
				Long vl = Long.parseLong(valor);
				if (hmGridQtd.containsKey(grupo)) {
					index = 0;
					criarQuantidade = false;
					boolean objetoEncontrado = false;
					for (QuantidadeAptoGestaoBloqueioVO vo : hmGridQtd
							.get(grupo)) {
						if (vo.getData().compareTo(
								((GregorianCalendar) arrayDias.get(i))
										.getTime()) == 0) {
							objetoEncontrado = true;
							if (vo.getValor().compareTo(vl) != 0) {
								vo.setValor(vl);
								vo.setObjetoAlterado(true);
								vo.setIdHoteis(getIdHoteis());
								hmGridQtd.get(grupo).set(index, vo);
								this.flagAlteracaoQtdApartamento = true;
								break;
							}
						}
						if (!objetoEncontrado
								&& index == hmGridQtd.get(grupo).size() - 1) {
							criarQuantidade = true;
						}
						index++;
					}

					if (criarQuantidade) {
						QuantidadeAptoGestaoBloqueioVO vo = new QuantidadeAptoGestaoBloqueioVO();
						vo.setIdReserva(reserva.getBcIdReserva());
						vo.setDsFantasia(grupo);
						vo.setData(((GregorianCalendar) arrayDias.get(i))
								.getTime());
						vo.setIdHoteis(getIdHoteis());
						vo.setValor(vl);
						vo.setObjetoAlterado(true);
						this.flagAlteracaoQtdApartamento = true;
						hmGridQtd.get(grupo).add(vo);
					}

				}
			}
		}
		
		request.getSession().setAttribute("FLAG_ALTERACAO_QTD_APTO",
				flagAlteracaoQtdApartamento);
		request.getSession().setAttribute("HASH_QTD",hmGridQtd);
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
					
					List<TarifaVO> listTarifasVO = ReservaDelegate.instance()
							.obterTarifaPorPeriodo(rsApClone);
					
					for (TarifaVO obj : listTarifasVO) {
						ReservaApartamentoDiariaVO resAptoDiaria = new ReservaApartamentoDiariaVO();
						resAptoDiaria.setBcData(obj.getBcDataEntrada());
						resAptoDiaria.setBcIdHotel(getIdHoteis()[0]);
						resAptoDiaria
								.setBcIdMoeda(MozartUtil.isNull(this.idMoeda) ? new Long(
										1L) : this.idMoeda);
						resAptoDiaria.setBcJustificaTarifa(obj.getBcDescricao());
						resAptoDiaria.setBcTarifa(obj.getBcPax());
						rsApClone.setBcJustificaTarifa(obj
								.getBcDescricao());
						rsApClone.getListReservaApartamentoDiaria()
								.add(resAptoDiaria);
						
					}

					rsApClone.setBcTarifa(
							
							Double.valueOf(rsApClone.getBcTotalTarifa()
									.doubleValue()
									/ rsApClone
									.getListReservaApartamentoDiaria().size()));
					
					
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
		this.pagamentoReservaVO.setBcIdHotel(getHotelCorrente().getIdHotel());
		this.pagamentoReservaVO
				.setBcDataConfirma(controladata.getFrontOffice());
		this.listFormaPgto = ReservaDelegate.instance()
				.obterTiposDePagamentoReserva(this.pagamentoReservaVO);
		return "sucessoResPgto";
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
		listPagamentoReserva.remove(Integer.parseInt(this.indicePagamento));
		return prepararReservaPagamento();
	}

	public String adicionarPagamento() throws MozartSessionException {
		warn("adicionar pagamento");
		List<PagamentoReservaVO> listPagamentoReserva = (List) this.request
				.getSession().getAttribute(SESSION_PAGAMENTO_RESERVA);
		this.pagamentoReservaVO.setBcTipoLancamento(this.formaPgtoSel);
		listPagamentoReserva.add(this.pagamentoReservaVO);
		return prepararReservaPagamento();
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
		listaFormaReserva.add(new MozartComboWeb("E-mail".toUpperCase(), "E-mail"));
		listaFormaReserva.add(new MozartComboWeb("Fax".toUpperCase(), "Fax"));
		listaFormaReserva.add(new MozartComboWeb("Telefone".toUpperCase(), "Telefone"));
		listaFormaReserva.add(new MozartComboWeb("Walk-In".toUpperCase(), "Walk-In"));
		listaFormaReserva.add(new MozartComboWeb("Outras".toUpperCase(), "Outras"));
		this.request.getSession().setAttribute("ListaFormaReserva",
				listaFormaReserva);

		List<MozartComboWeb> listaTipoMidia = new ArrayList();
		listaTipoMidia.add(new MozartComboWeb("1", "Indicacao"));
		listaTipoMidia.add(new MozartComboWeb("2", "Televisao"));
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

				crsRede = (CentralReservasRedeEJB) getCentralReservaEJB()
						.getCentralReservasRedeHotel().get(
								getCentralReservaEJB()
										.getCentralReservasRedeHotel().indexOf(
												crsRede));
				// if (("S".equals(crsRede.getAtivo()))
				// && ("N".equals(crsRede.getCrsPropria()))) {
				// this.filtro.getIdCrs().setTipo("I");
				// this.filtro.getIdCrs().setTipoIntervalo("2");
				// this.filtro.getIdCrs().setValorInicial(
				// String.valueOf(getCentralReservaEJB()
				// .getIdCentralReservas()));
				// }
			}
			List<BloqueioVO> lista = ReservaDelegate.instance()
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
			if (this.origemCrs.booleanValue()) {
				this.reservaVO
						.setBcIdCentralReservas(Long
								.valueOf(getCentralReservaEJB()
										.getIdCentralReservas()));
			}
			this.reservaVO.setBcBloqueio("S");
			this.reservaVO.setBcGrupo("S");

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
				objPR.setBcIdReserva(this.reservaVO.getBcIdReserva());
				objPR.setBcIdHotel(this.reservaVO.getBcIdHotel());
				objPR.setBcDataConfirma(agora);
				if ((objPR.getBcIdPagamentoReserva() == null)
						|| (objPR.getBcIdPagamentoReserva()
								.equals(new Long(0L)))) {
					objPR.setBcIdPagamentoReserva(ReservaDelegate.instance()
							.obterNextVal());
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
					.equals(ALTERACAO)) {
				ReservaDelegate.instance().atualizarReserva(reservaVO);
			} else if ("S".equals(reservaVO.getBcGrupo())) {// Reserva de grupo{
				ReservaDelegate.instance().salvarReserva(reservaVO);
			} else {// Reservas multiplas
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

	public String salvarGestao() throws MozartSessionException {
		String paginaRetorno = SUCESSO_FORWARD;
		String mensagem = "";

		flagAlteracaoTarifa = (Boolean) request.getSession().getAttribute(
				"FLAG_ALTERACAO_TARIFA");
		flagAlteracaoQtdApartamento = (Boolean) request.getSession()
				.getAttribute("FLAG_ALTERACAO_QTD_APTO");
		if (flagAlteracaoTarifa) {
			salvarTarifas();
			mensagem = "Alterações efetuadas com Sucesso!";
		}
		if (flagAlteracaoQtdApartamento) {
			salvarApartamentos();
			mensagem = "Alterações efetuadas com Sucesso!";
		}

		if (flagAlteracaoQtdApartamento || flagAlteracaoTarifa) {
			if (mensagem != null && !mensagem.equals("")) {
				addMensagemSucesso(mensagem);
			}
		}

		return paginaRetorno;
	}

	public void salvarTarifas() throws MozartSessionException {
		hmGridTarifa = (TreeMap<String, ArrayList<TarifaApartamentoGestaoBloqueioVO>>) request
				.getSession().getAttribute("HASH_TARIFAS");

		for (List<TarifaApartamentoGestaoBloqueioVO> lista : hmGridTarifa
				.values()) {
			for (TarifaApartamentoGestaoBloqueioVO vo : lista) {
				if (vo.isObjetoAlterado()) {
					vo.setUsuario(getUsuario());
					ReservaDelegate.instance()
							.salvarReservaApartamentoGestaoBloqueioVO(vo);
				}

			}
		}

	}

	public void salvarApartamentos() throws MozartSessionException {
		hmGridQtd = (TreeMap<String, ArrayList<QuantidadeAptoGestaoBloqueioVO>>) request
				.getSession().getAttribute("HASH_QTD");

		for (List<QuantidadeAptoGestaoBloqueioVO> lista : hmGridQtd
				.values()) {
			for (QuantidadeAptoGestaoBloqueioVO vo : lista) {
				if (vo.isObjetoAlterado()) {
					vo.setUsuario(getUsuario());
					ReservaDelegate.instance()
							.salvarQtdAptoBloqueio(vo);
				}

			}
		}

	}

	public String cancelarReserva() {
		return "pesquisa";
	}

	private TreeMap<String, ArrayList<TarifaApartamentoGestaoBloqueioVO>> agruparTarifaPorFantasiaPax(
			List<TarifaApartamentoGestaoBloqueioVO> lista) {
		int nuNumeroPax = 0;
		String fantasia = "";
		String chave = "";
		TreeMap<String, ArrayList<TarifaApartamentoGestaoBloqueioVO>> hmTarAgurpFantPax = new TreeMap<String, ArrayList<TarifaApartamentoGestaoBloqueioVO>>();

		for (TarifaApartamentoGestaoBloqueioVO obj : lista) {
			fantasia = obj.getDsFantasia();
			nuNumeroPax = 1;

			chave = fantasia
					+ TarifaApartamentoGestaoBloqueioVO.CAMPO_SEPARADOR
					+ obj.getPax();

			if (!hmTarAgurpFantPax.containsKey(chave)) {
				hmTarAgurpFantPax.put(chave,
						new ArrayList<TarifaApartamentoGestaoBloqueioVO>());
			}

			hmTarAgurpFantPax.get(chave).add(obj);
		}
		return hmTarAgurpFantPax;
	}
	
	private TreeMap<String, ArrayList<QuantidadeAptoGestaoBloqueioVO>> agruparQtdPorFantasia(
			List<QuantidadeAptoGestaoBloqueioVO> lista) {
		String fantasia = "";
		String chave = "";
		TreeMap<String, ArrayList<QuantidadeAptoGestaoBloqueioVO>> hmQtdAgurpFant = new TreeMap<String, ArrayList<QuantidadeAptoGestaoBloqueioVO>>();
		
		for (QuantidadeAptoGestaoBloqueioVO obj : lista) {
			fantasia = obj.getDsFantasia();
			
			chave = fantasia;
			
			if (!hmQtdAgurpFant.containsKey(chave)) {
				hmQtdAgurpFant.put(chave,
						new ArrayList<QuantidadeAptoGestaoBloqueioVO>());
			}
			
			hmQtdAgurpFant.get(chave).add(obj);
		}
		return hmQtdAgurpFant;
	}
	private TreeMap<String, ArrayList<DisponibilidadeAptoGestaoBloqueioVO>> agruparDisponibilidadePorReserva(
			List<DisponibilidadeAptoGestaoBloqueioVO> lista) {
		Long idReserva;
		String chave = "";
		TreeMap<String, ArrayList<DisponibilidadeAptoGestaoBloqueioVO>> hmQtdAgurpFant = new TreeMap<String, ArrayList<DisponibilidadeAptoGestaoBloqueioVO>>();
		
		for (DisponibilidadeAptoGestaoBloqueioVO obj : lista) {
			idReserva = obj.getIdReserva();
			
			chave = idReserva.toString();
			
			if (!hmQtdAgurpFant.containsKey(chave)) {
				hmQtdAgurpFant.put(chave,
						new ArrayList<DisponibilidadeAptoGestaoBloqueioVO>());
			}
			
			hmQtdAgurpFant.get(chave).add(obj);
		}
		return hmQtdAgurpFant;
	}

	private List getSequenciaDias(ReservaVO reserva) {
		List list = new Vector();
		int diaInicial = getDiaDoMes(reserva.getBcDataEntrada());
		int diaFinal = getDiaDoMes(reserva.getBcDataSaida());

		while (diaInicial <= diaFinal) {

			list.add(diaInicial++);

		}
		Collections.sort(list);
		return list;
	}

	private int getDiaDoMes(Date data) {
		GregorianCalendar c = new GregorianCalendar();
		c.setTime(data);
		return c.get(Calendar.DAY_OF_MONTH);

	}

	private List getListaDias(ReservaVO reserva) {

		GregorianCalendar dtIni = new GregorianCalendar();
		GregorianCalendar dtFim = new GregorianCalendar();
		dtIni.setTime(getControlaDataFrontOffice().before(reserva.getBcDataEntrada()) ? reserva.getBcDataEntrada() : getControlaDataFrontOffice());
		dtFim.setTime(reserva.getBcDataSaida());
		List<GregorianCalendar> lista = new Vector<GregorianCalendar>();
		while (dtIni.compareTo(dtFim) <= 0) {
			lista.add((GregorianCalendar) dtIni.clone());
			dtIni.add(Calendar.DAY_OF_MONTH, 1);

		}
		return lista;

	}

	public List getDiaSemana() {

		List<String> dias = new Vector<String>();
		HashMap<Integer, String> diaSemana = new HashMap<Integer, String>();
		diaSemana.put(01, "Dom");
		diaSemana.put(02, "Seg");
		diaSemana.put(03, "Ter");
		diaSemana.put(04, "Qua");
		diaSemana.put(05, "Qui");
		diaSemana.put(06, "Sex");
		diaSemana.put(07, "Sáb");
		for (GregorianCalendar obj : (Vector<GregorianCalendar>) arrayDias) {
			dias.add(diaSemana.get(obj.get(Calendar.DAY_OF_WEEK)));
		}
		return dias;
	}

	private Timestamp getControlaDataFrontOffice(){
		return getControlaData().getFrontOffice();
		
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

	public BloqueioVO getFiltro() {
		return filtro;
	}

	public void setFiltro(BloqueioVO filtro) {
		this.filtro = filtro;
	}

	public BloqueioVO getFiltroBloqueio() {
		return filtroBloqueio;
	}

	public void setFiltroBloqueio(BloqueioVO filtroBloqueio) {
		this.filtroBloqueio = filtroBloqueio;
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

	public TreeMap<String, ArrayList<TarifaApartamentoGestaoBloqueioVO>> getHmGridTarifa() {
		return hmGridTarifa;
	}

	public void setHmGridTarifa(
			TreeMap<String, ArrayList<TarifaApartamentoGestaoBloqueioVO>> hmGrid) {
		this.hmGridTarifa = hmGrid;
	}

	public List getArrayDias() {
		return arrayDias;
	}

	public TreeMap<String, ArrayList<QuantidadeAptoGestaoBloqueioVO>> getHmGridQtd() {
		return hmGridQtd;
	}

	public void setHmGridQtd(
			TreeMap<String, ArrayList<QuantidadeAptoGestaoBloqueioVO>> hmGridQtd) {
		this.hmGridQtd = hmGridQtd;
	}

	public TreeMap<String, ArrayList<DisponibilidadeAptoGestaoBloqueioVO>> getHmGridDisp() {
		return hmGridDisp;
	}

	public void setHmGridDisp(
			TreeMap<String, ArrayList<DisponibilidadeAptoGestaoBloqueioVO>> hmGridDisp) {
		this.hmGridDisp = hmGridDisp;
	}

	public void setArrayDias(List arrayDias) {
		this.arrayDias = arrayDias;
	}

	public Date getBcDataEntrada() {
		return bcDataEntrada;
	}

	public void setBcDataEntrada(Date dataEntrada) {
		this.bcDataEntrada = dataEntrada;
	}

	public Date getBcDataSaida() {
		return bcDataSaida;
	}

	public void setBcDataSaida(Date dataSaida) {
		this.bcDataSaida = dataSaida;
	}

	public boolean isFlagAlteracaoTarifa() {
		return flagAlteracaoTarifa;
	}

	public void setFlagAlteracaoTarifa(boolean flagAlteracaoTarifa) {
		this.flagAlteracaoTarifa = flagAlteracaoTarifa;
	}

	public boolean isFlagAlteracaoQtdApartamento() {
		return flagAlteracaoQtdApartamento;
	}

	public void setFlagAlteracaoQtdApartamento(
			boolean flagAlteracaoQtdApartamento) {
		this.flagAlteracaoQtdApartamento = flagAlteracaoQtdApartamento;
	}
	

	

}