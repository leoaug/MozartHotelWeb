package com.mozart.web.actions;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.EmpresaDelegate;
import com.mozart.model.delegate.ReservaDelegate;
import com.mozart.model.ejb.entity.ApartamentoEJB;
import com.mozart.model.ejb.entity.ApartamentoEJBPK;
import com.mozart.model.ejb.entity.CheckinEJB;
import com.mozart.model.ejb.entity.CheckinGrupoLancamentoEJB;
import com.mozart.model.ejb.entity.CheckinTipoLancamentoEJB;
import com.mozart.model.ejb.entity.CidadeEJB;
import com.mozart.model.ejb.entity.EmpresaGrupoLancamentoEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJBPK;
import com.mozart.model.ejb.entity.HospedeEJB;
import com.mozart.model.ejb.entity.MoedaEJB;
import com.mozart.model.ejb.entity.ReservaApartamentoDiariaEJB;
import com.mozart.model.ejb.entity.ReservaApartamentoEJB;
import com.mozart.model.ejb.entity.ReservaApartamentoEJBPK;
import com.mozart.model.ejb.entity.ReservaEJB;
import com.mozart.model.ejb.entity.ReservaGrupoLancamentoEJB;
import com.mozart.model.ejb.entity.ReservaPagamentoEJB;
import com.mozart.model.ejb.entity.RoomListEJB;
import com.mozart.model.ejb.entity.TipoApartamentoEJB;
import com.mozart.model.ejb.entity.TipoDiariaEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ChartApartamentoVO;
import com.mozart.model.vo.CheckinVO;
import com.mozart.model.vo.MovAptoPgtoAntecipadoVO;
import com.mozart.model.vo.ProcurarHospedeVO;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings("unchecked")
public class CheckinAction extends BaseAction {
	private static final long serialVersionUID = 2840280794966167045L;
	private CheckinVO filtro;
	private String idReserva;
	private Long idxCheckin;
	private Long idCheckin;
	private Long idxHospede;
	private Long[] tipoApartamentoCheckin;
	private List<CheckinVO> listaReservaDia;
	private List<String> listaReservaCombo;
	private List<String> listaHospedeCombo;
	private List<String> listaGrupoCombo;
	private List<String> listaEmpresaCombo;
	private List<String> motivoViagem;
	private List<String> tipoTransporte;
	private List<ReservaApartamentoEJB> listaReservaApartamento;
	private Long[] idTipoApartamento;
	private Long[] idApartamento;
	private String[] master;
	private String[] confirmada;
	private List<TipoApartamentoEJB> listaTipoApto;
	private List<List<ApartamentoEJB>> listaApartamento;
	private String[] hospedePrincipal;
	private String[] hospedeChegou;
	private String nomeHospede;
	private Long idHospede;
	private String nomeHospedeNovo;
	private String sobrenomeHospedeNovo;
	private String cpfHospedeNovo;
	private String passaporteHospedeNovo;
	private Timestamp dataNascimentoHospedeNovo;
	private String emailHospedeNovo;
	private String sexoHospedeNovo;
	private String seguro;
	private List<CheckinEJB> listaCheckin;
	private CheckinEJB checkinCorrente;
	private Long idCidadeOrigem;
	private String cidadeOrigem;
	private Long idCidadeDestino;
	private String cidadeDestino;
	private String salvarParaTodos;
	private String seguroPopUp;
	private Long idTipoLancamento;
	private Long qtdeTipoLancamento;
	private Double valorTipoLancamento;
	private String motivoDaViagem;
	private String tipoDoTransporte;
	private EmpresaHotelEJB empresaHotel;
	private List<String> qtdePaxList;
	private List<MozartComboWeb> tipoPensaoList;
	private List<MozartComboWeb> quemPagaList;
	private Long qtdePax;
	private Long qtdeAdicional;
	private Long qtdeCrianca;
	private Long qtdeCafe;
	private Long apartamento;
	private Long idMoeda;
	private Long idEmpresa;
	private List<ApartamentoEJB> apartamentoList;
	private List<MoedaEJB> moedaList;
	private String nomeGrupo;
	private String horaFinal;
	private String issHospede;
	private String taxaServicoHospede;
	private String roomTaxHospede;
	private String seguroHospede;
	private String issEmpresa;
	private String taxaServicoEmpresa;
	private String roomTaxEmpresa;
	private String possuiCredito;
	private String bebidaAlcoolica;
	private String cortesia;
	private String tarifaEmpresa;
	private String justificativaTarifa;
	private String observacao;
	private String empresa;
	private String tipoPensao;
	private Double comissao;
	private Double valorTarifa;
	private Timestamp dataInicial;
	private Timestamp dataFinal;
	private String[] quemPagaSelecionado;
	private Long[] identificaLancamento;
	private List<MozartComboWeb> listaSexo;
	private Timestamp chartDataEntrada;
	private Timestamp chartDataSaida;
	private List<ChartApartamentoVO> chartApartamentoList;
	private List<Timestamp> chartDatasList;
	private String procurarPor;
	private List<ProcurarHospedeVO> hospedeList;
	private String cofan;

	public CheckinAction() {
		this.filtro = new CheckinVO();

		this.motivoViagem = new ArrayList();
		this.motivoViagem.add("Turismo");
		this.motivoViagem.add("Negócios");
		this.motivoViagem.add("Convenção");
		this.motivoViagem.add("Outros");

		this.tipoTransporte = new ArrayList();
		this.tipoTransporte.add("Avião");
		this.tipoTransporte.add("Navio");
		this.tipoTransporte.add("Automóvel");
		this.tipoTransporte.add("Ônibus/Trem");

		this.qtdePaxList = new ArrayList();
		this.qtdePaxList.add("0");
		this.qtdePaxList.add("1");
		this.qtdePaxList.add("2");
		this.qtdePaxList.add("3");
		this.qtdePaxList.add("4");
		this.qtdePaxList.add("5");
		this.qtdePaxList.add("6");
		this.qtdePaxList.add("7");

		this.tipoPensaoList = new ArrayList();
		this.tipoPensaoList.add(new MozartComboWeb("SIM", "Com café"));
		this.tipoPensaoList.add(new MozartComboWeb("NAO", "Sem café"));
		this.tipoPensaoList.add(new MozartComboWeb("MAP", "MAP"));
		this.tipoPensaoList.add(new MozartComboWeb("FAP", "FAP"));

		this.listaSexo = new ArrayList();
		this.listaSexo.add(new MozartComboWeb("M", "Masculino"));
		this.listaSexo.add(new MozartComboWeb("F", "Feminino"));

		this.chartApartamentoList = new ArrayList();
	}

	public String preparaRelatorio() {
		return "sucesso";
	}

	public String procurarHospede() {
		warn("Procurando hóspede");
		try {
			ProcurarHospedeVO pFiltro = new ProcurarHospedeVO();
			pFiltro.setIdHoteis(getIdHoteis());
			pFiltro.setNomeHospede(this.procurarPor);

			this.hospedeList = CheckinDelegate.instance().procurarHospede(
					pFiltro);
			if (MozartUtil.isNull(this.hospedeList)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararProcurarHospede() {
		warn("Preparando a pesquis de hóspede");
		return "sucesso";
	}

	public String prepararChart() {
		this.chartDataEntrada = getControlaData().getFrontOffice();
		this.chartDataSaida = MozartUtil.incrementarDia(this.chartDataEntrada,
				30);
		return "sucesso";
	}

	public String pesquisarChart() {
		try {
			ChartApartamentoVO pFiltro = new ChartApartamentoVO();
			pFiltro.setIdHoteis(getIdHoteis());
			pFiltro.setDataInicio(this.chartDataEntrada);
			pFiltro.setDataFim(this.chartDataSaida);

			this.chartApartamentoList = CheckinDelegate.instance()
					.pesquisarChartApartamento(pFiltro);
			if (MozartUtil.isNull(this.chartApartamentoList)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			} else {
				this.chartDatasList = new ArrayList();
				Timestamp dataInicio = this.chartDataEntrada;
				while (MozartUtil.getDiferencaDia(dataInicio,
						this.chartDataSaida) >= 0) {
					this.chartDatasList.add(dataInicio);
					dataInicio = MozartUtil.incrementarDia(dataInicio);
				}
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String preparaAlteracao() {
		warn("Preparando alteracao do checkin/walkin: " + this.idCheckin);
		try {
			if (this.idCheckin == null) {
				throw new MozartValidateException("Selecione um checkin");
			}
			preparaManter();
			CheckinEJB checkinCorrente = CheckinDelegate.instance()
					.obterCheckinParaAlteracao(this.idCheckin);
			if (checkinCorrente.getReservaEJB() == null) {
				checkinCorrente.setReservaEJB(new ReservaEJB());
			}
			if (checkinCorrente.getReservaApartamentoEJB() == null) {
				checkinCorrente
						.setReservaApartamentoEJB(new ReservaApartamentoEJB());
			}
			checkinCorrente.getReservaApartamentoEJB().setRoomListEJBList(
					checkinCorrente.getRoomListEJBList());

			this.request.getSession().setAttribute("checkinCorrente",
					checkinCorrente);
			this.cofan = checkinCorrente.getApartamentoEJB().getCofan();

			ApartamentoEJB apto = CheckinDelegate.instance()
					.obterApartamentoByPK(
							new ApartamentoEJBPK(checkinCorrente
									.getApartamentoEJB().getIdApartamento(),
									getIdHoteis()[0]));
			this.apartamentoList = new ArrayList();
			this.apartamentoList.add(apto);
			this.request.getSession().setAttribute("apartamentoList",
					this.apartamentoList);

			this.apartamento = checkinCorrente.getApartamentoEJB()
					.getIdApartamento();
			List<CheckinEJB> listaCheckin = new ArrayList();
			listaCheckin.add(checkinCorrente);
			this.request.getSession()
					.setAttribute("listaCheckin", listaCheckin);

			this.tipoPensao = checkinCorrente.getTipoPensao();
			this.dataInicial = checkinCorrente.getDataEntrada();
			this.dataFinal = checkinCorrente.getDataSaida();

			this.horaFinal = checkinCorrente.getHora();
			this.qtdePax = checkinCorrente.getQtdeAdultos();
			this.qtdeCafe = checkinCorrente.getQtdeCafe();
			this.qtdeAdicional = checkinCorrente.getAdicional();
			this.qtdeCrianca = checkinCorrente.getQtdeCriancas();

			this.motivoDaViagem = checkinCorrente.getMotivoViagem();
			this.tipoDoTransporte = checkinCorrente.getMeioTransporte();
			if (checkinCorrente.getReservaEJB() != null) {
				this.nomeGrupo = checkinCorrente.getReservaEJB().getNomeGrupo();
			}
			this.horaFinal = checkinCorrente.getHora();

			this.issHospede = checkinCorrente.getCalculaIss();
			this.roomTaxHospede = checkinCorrente.getCalculaRoomtax();
			this.taxaServicoHospede = checkinCorrente.getCalculaTaxa();
			this.seguroHospede = checkinCorrente.getCalculaSeguro();
			this.possuiCredito = checkinCorrente.getCredito();
			this.bebidaAlcoolica = checkinCorrente.getFlgAlcoolica();
			this.tipoPensao = checkinCorrente.getTipoPensao();

			this.comissao = checkinCorrente.getComissao();
			this.cortesia = checkinCorrente.getCortesia();

			this.observacao = checkinCorrente.getObservacao();

			this.roomTaxEmpresa = checkinCorrente.getEmpresaHotelEJB()
					.getCalculaRoomtax();
			this.issEmpresa = checkinCorrente.getEmpresaHotelEJB()
					.getCalculaIss();
			this.taxaServicoEmpresa = checkinCorrente.getEmpresaHotelEJB()
					.getCalculaTaxa();
			if (checkinCorrente.getCidadeProcedencia() != null) {
				this.idCidadeOrigem = checkinCorrente.getCidadeProcedencia()
						.getIdCidade();
				this.cidadeOrigem = checkinCorrente.getCidadeProcedencia()
						.getCidade();
			}
			if (checkinCorrente.getCidadeDestino() != null) {
				this.idCidadeDestino = checkinCorrente.getCidadeDestino()
						.getIdCidade();
				this.cidadeDestino = checkinCorrente.getCidadeDestino()
						.getCidade();
			}
			this.valorTarifa = checkinCorrente.getTarifa();
			this.justificativaTarifa = checkinCorrente.getJustificaTarifa();
			this.observacao = checkinCorrente.getObservacao();
			this.empresa = checkinCorrente.getEmpresaHotelEJB()
					.getEmpresaRedeEJB().getNomeFantasia();
			this.idEmpresa = checkinCorrente.getEmpresaHotelEJB()
					.getEmpresaRedeEJB().getEmpresaEJB().getIdEmpresa();

			int qtde = checkinCorrente.getCheckinGrupoLancamentoEJBList()
					.size();
			this.quemPagaSelecionado = new String[qtde];
			this.identificaLancamento = new Long[qtde];

			qtde = 0;
			for (CheckinGrupoLancamentoEJB grupo : checkinCorrente
					.getCheckinGrupoLancamentoEJBList()) {
				this.quemPagaSelecionado[qtde] = grupo.getQuemPaga();
				this.identificaLancamento[qtde] = grupo
						.getIdIdentificaLancamento();
				qtde++;
			}
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
			return "erro";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	private void preencherReserva() throws Exception {
		CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
				.getAttribute("checkinCorrente");
		if (checkinCorrente.getIdCheckin() == null) {
			checkinCorrente.setReservaEJB(new ReservaEJB());
		}
		checkinCorrente.getReservaApartamentoEJB().setReservaEJB(
				checkinCorrente.getReservaEJB());
		ReservaEJB res = checkinCorrente.getReservaEJB();
		res.setCortesia(isNull(this.cortesia).booleanValue() ? "N"
				: this.cortesia);

		res.setGrupo("N");
		res.setApagada("N");
		res.setConfirma("S");
		res.setBloqueio("N");
		res.setCheckin("N");
		res.setFormaReserva("Walk-in".toUpperCase());

		res.setIdHotel(getIdHoteis()[0]);

		res.setCalculaIss(this.issHospede);
		res.setCalculaTaxa(this.taxaServicoHospede);
		res.setCalculaRoomtax(this.roomTaxHospede);
		res.setCalculaSeguro(this.seguroHospede);
		res.setObservacao(this.observacao);
		res.setDataEntrada(new Timestamp(this.dataInicial.getTime()));
		res.setDataSaida(new Timestamp(this.dataFinal.getTime()));
		res.setDataReserva(MozartUtil.now());
		res.setHoraReserva(MozartUtil.now());
		res.setComissao(this.comissao);
		if (this.empresaHotel.getEmpresaRedeEJB().getCidade() != null) {
			res.setIdCidadeContato(this.empresaHotel.getEmpresaRedeEJB()
					.getCidade().getIdCidade());
		}
		res.setReservaJava("S");
		if (this.empresaHotel.getEmpresaRedeEJB() != null) {
			if (this.empresaHotel.getEmpresaRedeEJB().getTelefone() != null) {
				res.setTelefoneContato(this.empresaHotel.getEmpresaRedeEJB()
						.getTelefone());
			} else {
				res.setTelefoneContato(" ");
			}
			if (isNull(this.empresaHotel.getEmpresaRedeEJB().getContato())
					.booleanValue()) {
				res.setContato("SEM CONTATO");
			} else {
				res.setContato(this.empresaHotel.getEmpresaRedeEJB()
						.getContato());
			}
		}
		res.setIdEmpresa(this.empresaHotel.getEmpresaRedeEJB().getEmpresaEJB()
				.getIdEmpresa());

		checkinCorrente.getReservaApartamentoEJB().setIdHotel(getIdHoteis()[0]);
		checkinCorrente.getReservaApartamentoEJB().setQtdeApartamento(1L);
		checkinCorrente.getReservaApartamentoEJB().setQtdeCheckin(0L);

		ApartamentoEJB apto = new ApartamentoEJB();
		apto.setIdHotel(getIdHoteis()[0]);
		apto.setIdApartamento(this.apartamento);

		apto = (ApartamentoEJB) CheckinDelegate.instance()
				.pesquisarApartamento(apto).get(0);
		if ((checkinCorrente.getIdCheckin() == null)
				&& (!apto.getStatus().startsWith("L"))) {
			throw new MozartValidateException(
					"Este apartamento não está mais livre");
		}
		checkinCorrente.getReservaApartamentoEJB().setApartamentoEJB(apto);
		checkinCorrente.getReservaApartamentoEJB().setIdTipoApartamento(
				apto.getTipoApartamentoEJB().getIdTipoApartamento());

		checkinCorrente.getReservaApartamentoEJB().setDataEntrada(
				checkinCorrente.getDataEntrada());
		checkinCorrente.getReservaApartamentoEJB().setDataSaida(
				checkinCorrente.getDataSaida());
		checkinCorrente.getReservaApartamentoEJB().setQtdePax(this.qtdePax);
		checkinCorrente.getReservaApartamentoEJB().setAdicional(
				this.qtdeAdicional);

		checkinCorrente.getReservaApartamentoEJB().setQtdeCrianca(
				this.qtdeCrianca);
		checkinCorrente.getReservaApartamentoEJB().setTarifa(this.valorTarifa);
		checkinCorrente.getReservaApartamentoEJB().setJustificaTarifa(
				this.justificativaTarifa);
		checkinCorrente.getReservaApartamentoEJB().setTarifaManual("N");
		checkinCorrente.getReservaApartamentoEJB().setDataManual("N");
		checkinCorrente.getReservaApartamentoEJB()
				.setReservaApartamentoDiariaEJBList(new ArrayList());

		int qtdeDias = MozartUtil.getDiferencaDia(
				checkinCorrente.getDataEntrada(),
				checkinCorrente.getDataSaida());
		double totalTarifa = 0.0D;
		for (int x = 0; x < qtdeDias; x++) {
			ReservaApartamentoDiariaEJB diaria = new ReservaApartamentoDiariaEJB();
			diaria.setIdReserva(res.getIdReserva());
			diaria.setIdHotel(getIdHoteis()[0]);
			diaria.setIdMoeda(this.idMoeda);
			Timestamp data = MozartUtil.incrementarDia(
					checkinCorrente.getDataEntrada(), x);
			diaria.setData(data);
			diaria.setTarifa(checkinCorrente.getTarifa());
			diaria.setJustificaTarifa(this.justificativaTarifa);
			checkinCorrente.getReservaApartamentoEJB()
					.addReservaApartamentoDiariaEJB(diaria);
			totalTarifa += checkinCorrente.getTarifa().doubleValue();
		}
		checkinCorrente.getReservaApartamentoEJB().setTotalTarifa(
				Double.valueOf(totalTarifa));
		TipoDiariaEJB tipoDiaria = CheckinDelegate.instance()
				.obterTipoDiariaPadraoByRede(
						getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		checkinCorrente.getReservaApartamentoEJB().setIdTipoDiaria(
				tipoDiaria.getIdTipoDiaria());

		res.setReservaApartamentoEJBList(new ArrayList());
		res.addReservaApartamentoEJB(checkinCorrente.getReservaApartamentoEJB());

		res.setReservaGrupoLancamentoEJBList(new ArrayList());
		for (int x = 0; x < this.quemPagaSelecionado.length; x++) {
			ReservaGrupoLancamentoEJB grupoReserva = new ReservaGrupoLancamentoEJB();
			grupoReserva.setQuemPaga(this.quemPagaSelecionado[x]);
			grupoReserva
					.setIdIdentificaLancamento(this.identificaLancamento[x]);
			grupoReserva.setIdEmpresa(this.empresaHotel.getEmpresaRedeEJB()
					.getEmpresaEJB().getIdEmpresa());
			grupoReserva.setIdHotel(getIdHoteis()[0]);
			res.addReservaGrupoLancamentoEJB(grupoReserva);
		}
		TipoLancamentoEJB tipoLancamento16 = new TipoLancamentoEJB();
		tipoLancamento16.setIdHotel(getIdHoteis()[0]);
		tipoLancamento16.getIdentificaLancamento().setIdIdentificaLancamento(
				16L);
		tipoLancamento16.setSubGrupoLancamento("001");

		List<TipoLancamentoEJB> result = CheckinDelegate.instance()
				.pesquisarTipoLancamentoByFiltro(tipoLancamento16);
		tipoLancamento16 = (TipoLancamentoEJB) result.get(0);

		res.setReservaPagamentoEJBList(new ArrayList());

		ReservaPagamentoEJB reservaPgto = new ReservaPagamentoEJB();
		reservaPgto.setConfirma("N");
		reservaPgto.setFormaPg("D");
		reservaPgto.setIdHotel(getIdHoteis()[0]);
		reservaPgto.setIdTipoLancamento(tipoLancamento16.getIdTipoLancamento());
		reservaPgto.setNumDocumento("PAGAMENTO DIRETO");

		res.addReservaPagamentoEJB(reservaPgto);
	}

	public String gravarWalkin() {
		try {
			info("Iniciando a gravacao do Walk-in");

			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");

			this.empresaHotel = new EmpresaHotelEJB();
			EmpresaHotelEJBPK ehpk = new EmpresaHotelEJBPK(this.idEmpresa,
					getIdHoteis()[0]);
			this.empresaHotel = EmpresaDelegate.instance()
					.obterEmpresaHotelByPK(ehpk);

			checkinCorrente.setCalculaIss(this.issHospede);
			checkinCorrente.setCalculaRoomtax(this.roomTaxHospede);
			checkinCorrente.setCalculaTaxa(this.taxaServicoHospede);
			checkinCorrente.setCalculaSeguro(this.seguroHospede);
			if (!isNull(getIdCidadeOrigem()).booleanValue()) {
				CidadeEJB cidade = new CidadeEJB();
				cidade.setIdCidade(getIdCidadeOrigem());
				checkinCorrente.setCidadeProcedencia(cidade);
			}
			if (!isNull(getIdCidadeDestino()).booleanValue()) {
				CidadeEJB cidade = new CidadeEJB();
				cidade.setIdCidade(getIdCidadeDestino());
				checkinCorrente.setCidadeDestino(cidade);
			}
			checkinCorrente.setCheckout("N");
			checkinCorrente.setRda("S");
			checkinCorrente.setComissao(this.comissao);
			checkinCorrente.setCortesia(this.cortesia);

			checkinCorrente.setCredito(this.possuiCredito);
			checkinCorrente.setDataEntrada(new Timestamp(this.dataInicial
					.getTime()));
			checkinCorrente
					.setDataSaida(new Timestamp(this.dataFinal.getTime()));
			checkinCorrente.setFlgAlcoolica(this.bebidaAlcoolica);
			checkinCorrente.setHora(this.horaFinal);

			ApartamentoEJB apto = new ApartamentoEJB();
			apto.setIdApartamento(this.apartamento);
			apto.setIdHotel(getIdHoteis()[0]);
			apto = CheckinDelegate.instance().obterApartamentoByPK(
					new ApartamentoEJBPK(apto.getIdApartamento(),
							getIdHoteis()[0]));

			checkinCorrente.setApartamentoEJB(apto);
			checkinCorrente.setEmpresaHotelEJB(this.empresaHotel);
			checkinCorrente.setJustificaTarifa(this.justificativaTarifa);
			checkinCorrente.setMeioTransporte(this.tipoDoTransporte);
			checkinCorrente.setMotivoViagem(this.motivoDaViagem);
			checkinCorrente.setObservacao(this.observacao);
			checkinCorrente.setQtdeAdultos(this.qtdePax);
			if ("NAO".equalsIgnoreCase(this.tipoPensao)) {
				checkinCorrente.setQtdeCafe(new Long(0L));
			} else {
				checkinCorrente.setQtdeCafe(this.qtdePax.longValue());
			}
			checkinCorrente.setQtdeCriancas(this.qtdeCrianca);
			checkinCorrente.setTarifa(this.valorTarifa);
			checkinCorrente.setTipoPensao(this.tipoPensao);

			preencherReserva();
			for (int x = 0; x < this.quemPagaSelecionado.length; x++) {
				((CheckinGrupoLancamentoEJB) checkinCorrente
						.getCheckinGrupoLancamentoEJBList().get(x))
						.setQuemPaga(this.quemPagaSelecionado[x]);
			}
			checkinCorrente.setUsuario(getUsuario());
			checkinCorrente.setHotelEJB(getHotelCorrente());
			checkinCorrente = CheckinDelegate.instance().gravarWalkin(
					checkinCorrente);
			if ("S".equals(this.cofan)) {
				addMensagemSucesso("Operação realizada com sucesso.Cofan: "
						+ checkinCorrente.getIdCheckin() + ".");
			} else {
				addMensagemSucesso("Operação realizada com sucesso.Check-in: "
						+ checkinCorrente.getIdCheckin() + ". Reserva: "
						+ checkinCorrente.getReservaEJB().getIdReserva());
			}
			preparaManter();
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
		}
		return "sucesso";
	}

	@SuppressWarnings("finally")
	public String incluirHospedeWalkin() {
		try {
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			if (this.qtdePax.intValue() == checkinCorrente
					.getReservaApartamentoEJB().getQtdeRoomList()) {
				addMensagemErro("Não é mais permitido incluir hóspede.");
			} else {
				RoomListEJB roomList = new RoomListEJB();
				roomList.setPrincipal(checkinCorrente
						.getReservaApartamentoEJB().getRoomListEJBList().size() == 0 ? "S"
						: "N");
				roomList.setChegou("S");

				HospedeEJB hospede = new HospedeEJB();
				hospede.setIdHospede(new Long(this.idHospede.longValue()));
				roomList.setHospede(CheckinDelegate.instance().obterHospede(
						hospede));

				checkinCorrente.getReservaApartamentoEJB().getRoomListEJBList()
						.add(roomList);
			}
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		} finally {
			return "sucesso";
		}
	}

	public String obterComplementoEmpresa() {
		try {
			warn("Obtendo empresa grupo lancamento para: " + getIdEmpresa());

			EmpresaHotelEJB pFiltro = new EmpresaHotelEJB();
			pFiltro.setIdHotel(getIdHoteis()[0]);
			pFiltro.setIdEmpresa(getIdEmpresa());

			EmpresaHotelEJBPK empresaPK = new EmpresaHotelEJBPK();
			empresaPK.idEmpresa = pFiltro.getIdEmpresa();
			empresaPK.idHotel = pFiltro.getIdHotel();
			this.checkinCorrente = ((CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente"));
			this.checkinCorrente
					.setEmpresaHotelEJB((EmpresaHotelEJB) CheckinDelegate
							.instance().obter(EmpresaHotelEJB.class, empresaPK));
			List<EmpresaGrupoLancamentoEJB> empresaGrupoLancamentoList = EmpresaDelegate
					.instance().obterGrupoLancamentoByEmpresa(pFiltro);

			this.checkinCorrente
					.setCheckinGrupoLancamentoEJBList(new ArrayList());
			for (EmpresaGrupoLancamentoEJB grupo : empresaGrupoLancamentoList) {
				CheckinGrupoLancamentoEJB grupoCk = new CheckinGrupoLancamentoEJB();
				grupoCk.setCheckinEJB(this.checkinCorrente);
				grupoCk.setIdentificaLancamentoEJB(grupo
						.getIdentificaLancamentoEJB());
				grupoCk.setIdHotel(getIdHoteis()[0]);
				grupoCk.setQuemPaga(grupo.getQuemPaga());
				this.checkinCorrente.getCheckinGrupoLancamentoEJBList().add(
						grupoCk);
			}
			this.roomTaxEmpresa = this.checkinCorrente.getEmpresaHotelEJB()
					.getCalculaRoomtax();
			this.issEmpresa = this.checkinCorrente.getEmpresaHotelEJB()
					.getCalculaIss();
			this.taxaServicoEmpresa = this.checkinCorrente.getEmpresaHotelEJB()
					.getCalculaTaxa();
			this.tipoPensao = this.checkinCorrente.getEmpresaHotelEJB()
					.getTipoPensao();
			this.seguroHospede = this.checkinCorrente.getEmpresaHotelEJB()
					.getCalculaSeguro();
			this.empresa = this.checkinCorrente.getEmpresaHotelEJB()
					.getEmpresaRedeEJB().getNomeFantasia();
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
		}
		return "prepara";
	}

	public String preparaManter() {
		warn("Preparando manter checkin/walkin");
		try {
			ApartamentoEJB pFiltro = new ApartamentoEJB();
			pFiltro.setIdHotel(getIdHoteis()[0]);
			pFiltro.setCofan("N");
			pFiltro.setStatus("LL");
			this.apartamentoList = CheckinDelegate.instance()
					.pesquisarApartamento(pFiltro);
			this.request.getSession().setAttribute("apartamentoList",
					this.apartamentoList);
			this.cofan = "N";

			this.moedaList = CheckinDelegate.instance().pesquisarMoeda();
			this.request.getSession().setAttribute("moedaList", this.moedaList);

			this.tipoPensao = "SIM";
			this.dataInicial = getControlaData().getFrontOffice();

			this.dataFinal = MozartUtil.incrementarDia(this.dataInicial, 1);
			this.horaFinal = "12:00";

			this.qtdePax = new Long(1L);

			TipoLancamentoEJB pFiltroTipo = new TipoLancamentoEJB();
			pFiltroTipo.setIdHotel(getIdHoteis()[0]);
			List<TipoLancamentoEJB> listaTipo = CheckinDelegate.instance()
					.pesquisarTipoLancamento(pFiltroTipo);
			this.request.getSession().setAttribute("listaTipoLancamento",
					listaTipo);

			CheckinEJB checkinCorrente = new CheckinEJB();
			checkinCorrente
					.setReservaApartamentoEJB(new ReservaApartamentoEJB());
			checkinCorrente.getReservaApartamentoEJB().setQtdePax(1L);
			this.request.getSession().setAttribute("checkinCorrente",
					checkinCorrente);

			List<CheckinEJB> listaCheckin = new ArrayList();
			listaCheckin.add(checkinCorrente);
			this.request.getSession()
					.setAttribute("listaCheckin", listaCheckin);

			this.quemPagaList = new ArrayList();
			this.quemPagaList.add(new MozartComboWeb("E", "Empresa"));
			this.quemPagaList.add(new MozartComboWeb("H", "Hóspede"));

			this.request.getSession().setAttribute("quemPagaList",
					this.quemPagaList);

			this.idCidadeOrigem = null;
			this.cidadeOrigem = null;
			this.idCidadeDestino = null;
			this.cidadeDestino = null;
			this.valorTarifa = null;
			this.justificativaTarifa = null;
			this.observacao = null;
			this.empresa = null;
			this.idEmpresa = null;
			this.nomeHospede = null;
			this.idHospede = null;
			this.cortesia = "N";
			this.qtdeCafe = new Long(1L);

			this.issEmpresa = "N";
			this.taxaServicoEmpresa = "N";
			this.roomTaxEmpresa = "N";

			this.idEmpresa = new Long(4522L);
			obterComplementoEmpresa();
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "prepara";
	}

	@SuppressWarnings("finally")
	public String preparaManterCofan() {
		warn("Preparando manter Cofan");
		try {
			preparaManter();
			ApartamentoEJB pFiltro = new ApartamentoEJB();
			pFiltro.setIdHotel(getIdHoteis()[0]);
			pFiltro.setCofan("S");
			pFiltro.setStatus("L");
			this.apartamentoList = CheckinDelegate.instance()
					.pesquisarApartamento(pFiltro);
			this.cofan = "S";
			this.issEmpresa = "N";
			this.taxaServicoEmpresa = "N";
			this.roomTaxEmpresa = "N";

			this.issHospede = "N";
			this.taxaServicoHospede = "N";
			this.roomTaxHospede = "N";
			this.seguroHospede = "N";

			this.request.getSession().setAttribute("apartamentoList",
					this.apartamentoList);
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			return "prepara";
		}
	}

	public String gravarPopupComplemento() {
		this.checkinCorrente = ((CheckinEJB) this.request.getSession()
				.getAttribute("checkinCorrente"));
		this.checkinCorrente.setMotivoViagem(this.motivoDaViagem);
		this.checkinCorrente.setMeioTransporte(this.tipoDoTransporte);
		this.checkinCorrente.getReservaApartamentoEJB().getReservaEJB()
				.setCalculaSeguro(this.seguroPopUp);

		CidadeEJB origem = new CidadeEJB();
		origem.setIdCidade(this.idCidadeOrigem);
		origem.setCidade(this.cidadeOrigem);
		this.checkinCorrente.setCidadeProcedencia(origem);

		CidadeEJB destino = new CidadeEJB();
		destino.setIdCidade(this.idCidadeDestino);
		destino.setCidade(this.cidadeDestino);
		this.checkinCorrente.setCidadeDestino(destino);
		if ("S".equalsIgnoreCase(this.salvarParaTodos)) {
			List<CheckinEJB> listaCheckin = (List) this.request.getSession()
					.getAttribute("listaCheckin");
			int x = 0;
			for (CheckinEJB chk : listaCheckin) {
				if (x++ != this.idxCheckin.intValue()) {
					chk.setMotivoViagem(this.checkinCorrente.getMotivoViagem());
					chk.setMeioTransporte(this.checkinCorrente
							.getMeioTransporte());
					chk.setCidadeDestino(this.checkinCorrente
							.getCidadeDestino());
					chk.setCidadeProcedencia(this.checkinCorrente
							.getCidadeProcedencia());
					chk.getReservaApartamentoEJB().getReservaEJB()
							.setCalculaSeguro(this.seguroPopUp);

					chk.setCheckinTipoLancamentoEJBList(new ArrayList());
					for (CheckinTipoLancamentoEJB tipo : this.checkinCorrente
							.getCheckinTipoLancamentoEJBList()) {
						CheckinTipoLancamentoEJB tipoNovo = new CheckinTipoLancamentoEJB();
						tipoNovo.setIdHotel(getIdHoteis()[0]);
						tipoNovo.setCheckinEJB(chk);
						tipoNovo.setTipoLancamentoEJB(tipo
								.getTipoLancamentoEJB());
						tipoNovo.setQuantidade(tipo.getQuantidade());
						tipoNovo.setValorUnitario(tipo.getValorUnitario());
						chk.getCheckinTipoLancamentoEJBList().add(tipoNovo);
					}
					x++;
				}
			}
		}
		this.request.setAttribute("fecharPopup", "S");

		return "sucesso";
	}

	public String obterValorTipoLancamento() {
		this.checkinCorrente = ((CheckinEJB) this.request.getSession()
				.getAttribute("checkinCorrente"));

		this.checkinCorrente.setMotivoViagem(this.motivoDaViagem);
		this.checkinCorrente.setMeioTransporte(this.tipoDoTransporte);

		this.qtdeTipoLancamento = 1L;
		TipoLancamentoEJB tipoLancamento = new TipoLancamentoEJB();
		tipoLancamento.setIdTipoLancamento(this.idTipoLancamento);

		List<TipoLancamentoEJB> listaTipo = (List) this.request.getSession()
				.getAttribute("listaTipoLancamento");

		tipoLancamento = (TipoLancamentoEJB) listaTipo.get(listaTipo
				.indexOf(tipoLancamento));

		this.valorTipoLancamento = tipoLancamento.getValorDespFixa();
		if (this.quemPagaSelecionado != null) {
			for (int x = 0; x < this.quemPagaSelecionado.length; x++) {
				((CheckinGrupoLancamentoEJB) this.checkinCorrente
						.getCheckinGrupoLancamentoEJBList().get(x))
						.setQuemPaga(this.quemPagaSelecionado[x]);
			}
		}
		return "sucesso";
	}

	public String adicionarTipoLancamento() {
		this.checkinCorrente = ((CheckinEJB) this.request.getSession()
				.getAttribute("checkinCorrente"));

		this.checkinCorrente.setMotivoViagem(this.motivoDaViagem);
		this.checkinCorrente.setMeioTransporte(this.tipoDoTransporte);

		TipoLancamentoEJB tipoLancamento = new TipoLancamentoEJB();
		tipoLancamento.setIdTipoLancamento(this.idTipoLancamento);

		List<TipoLancamentoEJB> listaTipo = (List) this.request.getSession()
				.getAttribute("listaTipoLancamento");
		tipoLancamento = (TipoLancamentoEJB) listaTipo.get(listaTipo
				.indexOf(tipoLancamento));

		CheckinTipoLancamentoEJB tipo = new CheckinTipoLancamentoEJB();
		tipo.setIdHotel(getIdHoteis()[0]);
		tipo.setTipoLancamentoEJB(tipoLancamento);
		tipo.setCheckinEJB(this.checkinCorrente);
		tipo.setValorUnitario(this.valorTipoLancamento);
		tipo.setQuantidade(Double.valueOf(this.qtdeTipoLancamento.doubleValue()));
		if (this.checkinCorrente.getCheckinTipoLancamentoEJBList().contains(
				tipo)) {
			addMensagemErro("Despesa já cadastrada.");
			return "sucesso";
		}
		this.checkinCorrente.getCheckinTipoLancamentoEJBList().add(tipo);

		this.qtdeTipoLancamento = null;
		this.valorTipoLancamento = null;
		this.idTipoLancamento = null;
		if (this.quemPagaSelecionado != null) {
			for (int x = 0; x < this.quemPagaSelecionado.length; x++) {
				((CheckinGrupoLancamentoEJB) this.checkinCorrente
						.getCheckinGrupoLancamentoEJBList().get(x))
						.setQuemPaga(this.quemPagaSelecionado[x]);
			}
		}
		return "sucesso";
	}

	public String excluirTipoLancamento() {
		this.checkinCorrente = ((CheckinEJB) this.request.getSession()
				.getAttribute("checkinCorrente"));
		this.checkinCorrente.setMotivoViagem(this.motivoDaViagem);
		this.checkinCorrente.setMeioTransporte(this.tipoDoTransporte);
		this.checkinCorrente.getCheckinTipoLancamentoEJBList().remove(
				this.idxHospede.intValue());
		if (this.quemPagaSelecionado != null) {
			for (int x = 0; x < this.quemPagaSelecionado.length; x++) {
				((CheckinGrupoLancamentoEJB) this.checkinCorrente
						.getCheckinGrupoLancamentoEJBList().get(x))
						.setQuemPaga(this.quemPagaSelecionado[x]);
			}
		}
		return "sucesso";
	}

	@SuppressWarnings("finally")
	public String prepararPopupComplemento() {
		try {
			List<CheckinEJB> listaCheckin = (List) this.request.getSession()
					.getAttribute("listaCheckin");
			this.checkinCorrente = ((CheckinEJB) listaCheckin
					.get(this.idxCheckin.intValue()));

			TipoLancamentoEJB pFiltro = new TipoLancamentoEJB();
			pFiltro.setIdHotel(getIdHoteis()[0]);
			List<TipoLancamentoEJB> listaTipo = CheckinDelegate.instance()
					.pesquisarTipoLancamento(pFiltro);
			this.seguroPopUp = this.checkinCorrente.getReservaApartamentoEJB()
					.getReservaEJB().getCalculaSeguro();
			this.request.getSession().setAttribute("listaTipoLancamento",
					listaTipo);
			this.salvarParaTodos = "S";
			this.request.getSession().setAttribute("checkinCorrente",
					this.checkinCorrente);
			if (this.checkinCorrente.getCidadeDestino() != null) {
				this.idCidadeDestino = this.checkinCorrente.getCidadeDestino()
						.getIdCidade();
				this.cidadeDestino = this.checkinCorrente.getCidadeDestino()
						.getCidade();
			}
			if (this.checkinCorrente.getCidadeProcedencia() != null) {
				this.idCidadeOrigem = this.checkinCorrente
						.getCidadeProcedencia().getIdCidade();
				this.cidadeOrigem = this.checkinCorrente.getCidadeProcedencia()
						.getCidade();
			}
		} catch (Exception er) {
			addMensagemErro("Erro ao realizar operação.");
			error(er.getMessage());
		} finally {
			return "sucesso";
		}
	}

	public String prepararPesquisa() {
		info("Preparando pesquisa checkin");

		this.filtro.getFiltroDataEntrada().setTipo("D");
		// this.filtro.getFiltroDataEntrada().setTipoIntervalo("1");
		// this.filtro.getFiltroDataEntrada().setValorInicial(
		// MozartUtil.format(MozartUtil.decrementarDia(getControlaData()
		// .getFrontOffice(), 15)));
		// this.filtro.getFiltroDataEntrada().setValorFinal(
		// MozartUtil.format(getControlaData().getFrontOffice()));

		this.request.getSession().setAttribute("listaPesquisa", null);

		this.checkinCorrente = ((CheckinEJB) this.request.getSession()
				.getAttribute("checkinCorrente"));
		if (this.quemPagaSelecionado != null) {
			for (int x = 0; x < this.quemPagaSelecionado.length; x++) {
				((CheckinGrupoLancamentoEJB) this.checkinCorrente
						.getCheckinGrupoLancamentoEJBList().get(x))
						.setQuemPaga(this.quemPagaSelecionado[x]);
			}
		}
		return "sucesso";
	}

	public String pesquisar() {
		info("Pesquisar checkin");
		try {
			// if ((MozartUtil.isNull(this.filtro.getFiltroDataEntrada()))
			// || (MozartUtil.isNull(this.filtro.getFiltroDataEntrada()
			// .getValorInicial()))) {
			// addMensagemSucesso("O campo do filtro 'Data Entrada' é obrigatório.");
			// return "sucesso";
			// }
			if ((!MozartUtil.isNull(this.filtro.getFiltroDataEntrada()
					.getValorInicial()))
					&& (!MozartUtil.isNull(this.filtro.getFiltroDataEntrada()
							.getValorFinal()))) {
				if (MozartUtil.getDiferencaDia(MozartUtil
						.toTimestamp(this.filtro.getFiltroDataEntrada()
								.getValorInicial()), MozartUtil
						.toTimestamp(this.filtro.getFiltroDataEntrada()
								.getValorFinal())) > 360) {
					addMensagemSucesso("A diferença de dias entre o filtro 'Data Entrada' deve ser menor que 1 ano.");
					return "sucesso";
				}
			}
			if ((!MozartUtil.isNull(this.filtro.getFiltroDataSaida()
					.getValorInicial()))
					&& (!MozartUtil.isNull(this.filtro.getFiltroDataSaida()
							.getValorFinal()))) {
				if (MozartUtil.getDiferencaDia(MozartUtil
						.toTimestamp(this.filtro.getFiltroDataSaida()
								.getValorInicial()), MozartUtil
						.toTimestamp(this.filtro.getFiltroDataSaida()
								.getValorFinal())) > 360) {
					addMensagemSucesso("A diferença de dias entre o filtro 'Data Saída' deve ser menor que 1 ano.");
					return "sucesso";
				}
			}
			this.filtro.setIdHoteis(getIdHoteis());
			List<CheckinVO> listaPesquisa = CheckinDelegate.instance()
					.pesquisarCheckin(this.filtro);
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

	public String gravarNovoHospede() {
		try {
			this.checkinCorrente = ((CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente"));

			HospedeEJB novoHospede = new HospedeEJB();
			novoHospede.setIdHospede(this.idHospede);
			novoHospede.setNomeHospede(this.nomeHospedeNovo);
			novoHospede.setSobrenomeHospede(this.sobrenomeHospedeNovo);
			novoHospede.setCpf(this.cpfHospedeNovo);
			novoHospede.setPassaporte(this.passaporteHospedeNovo);
			if (!MozartUtil.isNull(this.dataNascimentoHospedeNovo)) {
				novoHospede.setNascimento(new Timestamp(
						this.dataNascimentoHospedeNovo.getTime()));
			}
			novoHospede.setEmail(this.emailHospedeNovo);
			novoHospede.setSexo(this.sexoHospedeNovo);
			novoHospede.setIdBairro(new Long(0L));
			novoHospede.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			if ((!isNull(
					this.checkinCorrente.getReservaApartamentoEJB()
							.getRoomListEJBList()).booleanValue())
					&& (!MozartUtil.isNull(this.idxHospede))) {
				novoHospede
						.setTipoHospedeEJB(((RoomListEJB) this.checkinCorrente
								.getReservaApartamentoEJB()
								.getRoomListEJBList()
								.get(this.idxHospede.intValue())).getHospede()
								.getTipoHospedeEJB());
			}
			novoHospede.setUsuario(getUserSession().getUsuarioEJB());
			novoHospede = CheckinDelegate.instance().gravarHospede(novoHospede);

			this.idHospede = novoHospede.getIdHospede();
			this.nomeHospede = (novoHospede.getNomeHospede() + " "
					+ novoHospede.getSobrenomeHospede() + " " + novoHospede
					.getCpf());
			if ((!isNull(
					this.checkinCorrente.getReservaApartamentoEJB()
							.getRoomListEJBList()).booleanValue())
					&& (!MozartUtil.isNull(this.idxHospede))) {
				this.checkinCorrente.getReservaApartamentoEJB()
						.getRoomListEJBList()
						.remove(this.idxHospede.intValue());
			}
			return incluirPopupHospede();
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return "sucesso";
	}

	public String gravarPopupHospede() {
		this.checkinCorrente = ((CheckinEJB) this.request.getSession()
				.getAttribute("checkinCorrente"));

		boolean marcouPrincipal = false;
		int x = 1;
		for (; x < this.hospedePrincipal.length; x++) {
			if ("S".equals(this.hospedePrincipal[x])) {
				marcouPrincipal = true;
				break;
			}
		}
		if (!marcouPrincipal) {
			addMensagemErro("Pelo menos um hóspede deve ser o principal");
			return "sucesso";
		}

		x = 1;
		for (RoomListEJB room : this.checkinCorrente.getReservaApartamentoEJB()
				.getRoomListEJBList()) {
			if (room.getDataSaida() == null) {
				room.setPrincipal(this.hospedePrincipal[x]);
				room.setChegou(this.hospedeChegou[x]);
				x++;
			}
		}
		this.request.setAttribute("fecharPopup", "S");

		return "sucesso";
	}

	@SuppressWarnings("finally")
	public String incluirPopupHospede() {
		try {
			this.checkinCorrente = ((CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente"));
			if (this.checkinCorrente.getReservaApartamentoEJB().getQtdePax()
					.intValue() == this.checkinCorrente
					.getReservaApartamentoEJB().getQtdeRoomList()) {
				addMensagemErro("Não é mais permitido incluir hóspede.");
			} else {
				RoomListEJB roomList = new RoomListEJB();
				roomList.setPrincipal(this.hospedePrincipal[0]);
				roomList.setChegou(this.hospedeChegou[0]);

				HospedeEJB hospede = new HospedeEJB();
				hospede.setIdHospede(new Long(this.idHospede.longValue()));

				roomList.setHospede(CheckinDelegate.instance().obterHospede(
						hospede));
				if ("S".equals(roomList.getPrincipal())) {
					for (RoomListEJB room : this.checkinCorrente
							.getReservaApartamentoEJB().getRoomListEJBList()) {
						room.setPrincipal("N");
					}
				}
				this.checkinCorrente.getReservaApartamentoEJB()
						.getRoomListEJBList().add(roomList);
				this.idHospede = null;
			}
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		} finally {
			return "sucesso";
		}
	}

	public String excluirHospede() {
		this.checkinCorrente = ((CheckinEJB) this.request.getSession()
				.getAttribute("checkinCorrente"));

		RoomListEJB roomList = new RoomListEJB();
		roomList = (RoomListEJB) this.checkinCorrente
				.getReservaApartamentoEJB().getRoomListEJBList()
				.remove(this.idxHospede.intValue());
		this.idxHospede = null;
		if (("S".equals(roomList.getPrincipal()))
				&& (this.checkinCorrente.getReservaApartamentoEJB()
						.getRoomListEJBList().size() >= 1)) {
			((RoomListEJB) this.checkinCorrente.getReservaApartamentoEJB()
					.getRoomListEJBList().get(0)).setPrincipal("S");
		}
		if (this.quemPagaSelecionado != null) {
			for (int x = 0; x < this.quemPagaSelecionado.length; x++) {
				((CheckinGrupoLancamentoEJB) this.checkinCorrente
						.getCheckinGrupoLancamentoEJBList().get(x))
						.setQuemPaga(this.quemPagaSelecionado[x]);
			}
		}
		return "sucesso";
	}

	public String excluirPopupHospede() {
		this.checkinCorrente = ((CheckinEJB) this.request.getSession()
				.getAttribute("checkinCorrente"));

		RoomListEJB roomList = new RoomListEJB();
		roomList = (RoomListEJB) this.checkinCorrente
				.getReservaApartamentoEJB().getRoomListEJBList()
				.remove(this.idxHospede.intValue());
		this.idxHospede = null;
		if (("S".equals(roomList.getPrincipal()))
				&& (this.checkinCorrente.getReservaApartamentoEJB()
						.getRoomListEJBList().size() >= 1)) {
			((RoomListEJB) this.checkinCorrente.getReservaApartamentoEJB()
					.getRoomListEJBList().get(0)).setPrincipal("S");
		}
		if (this.quemPagaSelecionado != null) {
			for (int x = 0; x < this.quemPagaSelecionado.length; x++) {
				((CheckinGrupoLancamentoEJB) this.checkinCorrente
						.getCheckinGrupoLancamentoEJBList().get(x))
						.setQuemPaga(this.quemPagaSelecionado[x]);
			}
		}
		return "sucesso";
	}

	public String adicionarPopupHospede() {
		info("Iniciando edição do res apto" + this.idxCheckin);

		return "sucesso";
	}

	public String prepararPopupHospede() {
		info("Iniciando edição do res apto" + this.idxCheckin + ":"
				+ this.request.getParameter("idxCheckin") + ":"
				+ this.request.getAttribute("idxCheckin"));
		if (this.idxCheckin == null) {
			this.idxCheckin = new Long(this.request.getParameter("idxCheckin"));
		}
		if (this.idxCheckin == null) {
			this.idxCheckin = new Long(
					(String) this.request.getAttribute("idxCheckin"));
		}
		List<CheckinEJB> listaCheckin = (List) this.request.getSession()
				.getAttribute("listaCheckin");
		this.checkinCorrente = ((CheckinEJB) listaCheckin.get(this.idxCheckin
				.intValue()));
		if (("S".equals(this.seguro)) || ("N".equals(this.seguro))) {
			this.checkinCorrente.setCalculaSeguro(this.seguro);
		}
		if (this.qtdePax != null) {
			this.checkinCorrente.getReservaApartamentoEJB().setQtdePax(
					this.qtdePax);
		}
		this.request.getSession().removeAttribute("checkinCorrente");
		this.request.getSession().setAttribute("checkinCorrente",
				this.checkinCorrente);

		info("Popup iniciado com sucesso");
		return "sucesso";
	}

	public String preparaManterFast() {
		warn("Preparando manter checkin-fast");
		try {
			CheckinVO filtroReservaDia = new CheckinVO();
			filtroReservaDia.setFiltroTipoPesquisa("1");
			filtroReservaDia.setIdHoteis(getIdHoteis());
			filtroReservaDia.getFiltroConfirmada().setTipo("B");
			filtroReservaDia.getFiltroConfirmada().setTipoIntervalo("S");
			if (!isNull(this.idReserva).booleanValue()) {
				filtroReservaDia.getFiltroReserva().setTipo("I");
				filtroReservaDia.getFiltroReserva().setTipoIntervalo("2");
				filtroReservaDia.getFiltroReserva().setValorInicial(
						this.idReserva.toString());
			}
			this.listaReservaDia = CheckinDelegate.instance().pesquisarCheckin(
					filtroReservaDia);
			List<CheckinVO> listaUnica = new ArrayList();
			this.listaReservaCombo = new ArrayList();
			this.listaHospedeCombo = new ArrayList();
			this.listaGrupoCombo = new ArrayList();
			this.listaEmpresaCombo = new ArrayList();
			if (!isNull(this.listaReservaDia).booleanValue()) {
				for (CheckinVO vo : this.listaReservaDia) {
					if ((!isNull(vo.getIdReserva()).booleanValue())
							&& (this.listaReservaCombo.indexOf(vo
									.getIdReserva().toString()) == -1)) {
						this.listaReservaCombo
								.add(vo.getIdReserva().toString());
						listaUnica.add(vo);
					} else if ("S".equalsIgnoreCase(vo.getMaster())) {
						listaUnica.set(this.listaReservaCombo.indexOf(vo
								.getIdReserva().toString()), vo);
					}
					if ((!isNull(vo.getNomeHospede()).booleanValue())
							&& (this.listaHospedeCombo.indexOf(vo
									.getNomeHospede()) == -1)) {
						this.listaHospedeCombo.add(vo.getNomeHospede());
					}
					if ((!isNull(vo.getNomeGrupo()).booleanValue())
							&& (this.listaGrupoCombo.indexOf(vo.getNomeGrupo()) == -1)) {
						this.listaGrupoCombo.add(vo.getNomeGrupo());
					}
					if ((!isNull(vo.getNomeFantasia()).booleanValue())
							&& (this.listaEmpresaCombo.indexOf(vo
									.getNomeFantasia()) == -1)) {
						this.listaEmpresaCombo.add(vo.getNomeFantasia());
					}
				}
				Collections.sort(this.listaReservaCombo);
				Collections.sort(this.listaHospedeCombo);
				Collections.sort(this.listaGrupoCombo);
				Collections.sort(this.listaEmpresaCombo);

				this.request.getSession().setAttribute("listaReservaDia",
						listaUnica);
				return "prepara";
			}
			addMensagemSucesso("Não existe nenhuma reserva do dia, confirmada.");
			return "pesquisa";
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return "erro";
	}

	public String obterApartamento() {
		info("Obtendo lista de apartamentos");
		try {
			ApartamentoEJB pApto = new ApartamentoEJB();
			pApto.setIdHotel(getIdHoteis()[0]);
			pApto.setTipoApartamentoEJB(new TipoApartamentoEJB(
					this.idTipoApartamento[this.idxCheckin.intValue()]));
			pApto.setCofan("N");
			pApto.setStatus("LL");

			List<ApartamentoEJB> lista = CheckinDelegate.instance()
					.pesquisarApartamento(pApto);
			this.listaApartamento = ((List) this.request.getSession()
					.getAttribute("listaApartamentos"));
			this.listaApartamento.set(this.idxCheckin.intValue(), lista);
			updateReservaApartamento();
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_CHK_FST_HOP_FORWARD;
	}

	private void updateReservaApartamento() {
		List<CheckinEJB> listaCheckin = (List) this.request.getSession()
				.getAttribute("listaCheckin");
		int x = 0;
		int y = 0;
		for (CheckinEJB checkin : listaCheckin) {
			checkin.getReservaApartamentoEJB().getApartamentoEJB()
					.setIdApartamento(this.idApartamento[x]);
			checkin.getReservaApartamentoEJB().setIdTipoApartamento(
					this.idTipoApartamento[x]);
			checkin.getReservaApartamentoEJB().setMaster(this.master[x]);
			checkin.getReservaApartamentoEJB()
					.setConfirmada(this.confirmada[x]);
			for (RoomListEJB room : checkin.getReservaApartamentoEJB()
					.getRoomListEJBList()) {
				room.setPrincipal(this.hospedePrincipal[y]);
				room.setChegou(this.hospedeChegou[y]);
				y++;
			}
			x++;
		}
	}

	private void updateReservaApartamentoPopUp() {
		List<CheckinEJB> listaCheckin = (List) this.request.getSession()
				.getAttribute("listaCheckin");
		int x = 0;
		for (CheckinEJB checkin : listaCheckin) {
			checkin.getReservaApartamentoEJB().getApartamentoEJB()
					.setIdApartamento(this.idApartamento[x]);
			checkin.getReservaApartamentoEJB().setIdTipoApartamento(
					this.idTipoApartamento[x]);
			checkin.getReservaApartamentoEJB().setMaster(this.master[x]);
			checkin.getReservaApartamentoEJB()
					.setConfirmada(this.confirmada[x]);
			x++;
		}
	}

	public String atualizarCheckinHospedePopUp() {
		updateReservaApartamentoPopUp();
		return SUCESSO_CHK_FST_HOP_FORWARD;
	}

	public String atualizarCheckinHospede() {
		updateReservaApartamento();
		return SUCESSO_CHK_FST_HOP_FORWARD;
	}

	public String gravarCheckin() {
		boolean gravouCheckin = false;
		String retorno = SUCESSO_CHK_FST_HOP_FORWARD;
		try {
			updateReservaApartamento();

			List<CheckinEJB> listaCheckin = (List) this.request.getSession()
					.getAttribute("listaCheckin");

			List<CheckinEJB> listaCheckinConfirmado = new ArrayList();
			for (int x = 0; x < listaCheckin.size(); x++) {
				this.checkinCorrente = ((CheckinEJB) listaCheckin.get(x));
				if (!"N".equals(this.checkinCorrente.getReservaApartamentoEJB()
						.getConfirmada())) {
					this.checkinCorrente.setUsuario(getUserSession()
							.getUsuarioEJB());
					this.checkinCorrente.setHotelEJB(getHotelCorrente());

					listaCheckinConfirmado.add(this.checkinCorrente);
				}
			}
			if (!MozartUtil.isNull(listaCheckinConfirmado)) {
				 CheckinDelegate.instance().gravarCheckin(getUsuario(),
				 listaCheckinConfirmado);
				this.request.setAttribute("submetePai", "true");
				gravouCheckin = true;
				buscarPagamentoAntecipado(checkinCorrente);
			}
		} catch (MozartValidateException ex) {
			this.request.setAttribute("msgPai", ex.getMessage());
			error(ex.getMessage());
			if (gravouCheckin) {
				prepararCheckinHospede();
			}
		} catch (Exception ex) {
			if (gravouCheckin) {
				prepararCheckinHospede();
			}
			this.request.setAttribute("msgPai", "Erro ao realizar operação.");

			error(ex.getMessage());
		} finally {
		}
		return retorno;
	}

	@SuppressWarnings("finally")
	public String prepararCheckinHospede() {
		info("Índice da reserva: " + this.idReserva);
		String retorno = SUCESSO_CHK_FST_HOP_FORWARD;
		try {
			this.request.getSession().removeAttribute("listaApartamentos");
			
			this.request.getSession().removeAttribute("ID_RES_PAG_ANTEC");
			
			this.request.getSession().removeAttribute("ID_APTO_COFAN_PAG_ANTEC");

			this.request.getSession().removeAttribute("ID_APTO_CHECKIN");

			this.request.getSession().removeAttribute("listaTipoApto");

			this.request.getSession().removeAttribute("listaCheckin");

			this.request.getSession().removeAttribute("checkinCorrente");

			this.request.getSession().getAttribute("listaTipoLancamento");
			if (!isNull(this.idReserva).booleanValue()) {
				List<CheckinVO> lista = (List) this.request.getSession()
						.getAttribute("listaReservaDia");

				CheckinVO checkin = (CheckinVO) lista.get(Integer
						.parseInt(this.idReserva));

				info("Iniciando a leitura do checkin para a seguinte reserva: "
						+ checkin.getIdReserva());

				this.listaReservaApartamento = new ArrayList();

				this.listaCheckin = new ArrayList();
				if ("S".equalsIgnoreCase(checkin.getGrupo())) {
					ReservaEJB pReserva = new ReservaEJB();
					pReserva.setIdHotel(getIdHoteis()[0]);
					pReserva.setIdReserva(checkin.getIdReserva());
					this.listaReservaApartamento = ReservaDelegate.instance()
							.obterReservaApartamentoSemCheckin(pReserva);
				} else {
					ReservaApartamentoEJB resApto = new ReservaApartamentoEJB();
					ReservaApartamentoEJBPK pk = new ReservaApartamentoEJBPK(
							getIdHoteis()[0], checkin.getIdReservaApartamento());
					resApto = ReservaDelegate.instance()
							.obterReservaApartamento(pk);
					this.listaReservaApartamento.add(resApto);
				}
				TipoApartamentoEJB pTipoApartamentoEJB = new TipoApartamentoEJB();
				pTipoApartamentoEJB.setIdHotel(getIdHoteis()[0]);
				this.listaTipoApto = CheckinDelegate.instance()
						.obterTipoApartamento(pTipoApartamentoEJB);
				this.request.getSession().setAttribute("listaTipoApto",
						this.listaTipoApto);

				this.idTipoApartamento = new Long[this.listaReservaApartamento
						.size()];
				this.idApartamento = new Long[this.listaReservaApartamento
						.size()];
				this.master = new String[this.listaReservaApartamento.size()];
				this.confirmada = new String[this.listaReservaApartamento
						.size()];
				this.listaApartamento = new ArrayList(
						this.listaReservaApartamento.size());
				this.listaCheckin = new ArrayList(
						this.listaReservaApartamento.size());
				int idx = 0;
				for (ReservaApartamentoEJB resApto : this.listaReservaApartamento) {
					if (resApto.getApartamentoEJB() == null) {
						resApto.setApartamentoEJB(new ApartamentoEJB());
					}
					CheckinEJB checkinCorrente = new CheckinEJB();
					ApartamentoEJB pApto = new ApartamentoEJB();
					pApto.setIdHotel(getIdHoteis()[0]);
					pApto.setCofan("N");
					pApto.setStatus("LL");
					pApto.setTipoApartamentoEJB(new TipoApartamentoEJB(resApto
							.getIdTipoApartamento()));
					this.listaApartamento.add(CheckinDelegate.instance()
							.pesquisarApartamento(pApto));
					if (isNull(resApto.getMaster()).booleanValue()) {
						resApto.setMaster("N");
					}
					this.idTipoApartamento[idx] = resApto
							.getIdTipoApartamento();
					this.idApartamento[idx] = new Long(-1L);
					if (resApto.getApartamentoEJB().getIdApartamento() != null) {
						this.idApartamento[idx] = resApto.getApartamentoEJB()
								.getIdApartamento();
					}
					this.master[idx] = (isNull(resApto.getMaster())
							.booleanValue() ? "N" : resApto.getMaster());
					idx++;

					checkinCorrente.setCalculaSeguro(resApto.getReservaEJB()
							.getCalculaSeguro());
					for (RoomListEJB rl : resApto.getRoomListEJBList()) {
						rl.setChegou("S");
						if (MozartUtil.isNull(rl.getPrincipal())) {
							rl.setPrincipal("N");
						}
						checkinCorrente.getRoomListEJBList().add(rl);
					}
					checkinCorrente.setReservaApartamentoEJB(resApto);

					this.listaCheckin.add(checkinCorrente);
				}
				this.request.getSession().setAttribute("listaApartamentos",
						this.listaApartamento);

				this.request.getSession().setAttribute("listaCheckin",
						this.listaCheckin);
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addActionError("Erro ao realizar operação.");
		} finally {
			return retorno;
		}
	}

	private String buscarPagamentoAntecipado(CheckinEJB checkin) {
		String retorno = SUCESSO_CHK_FST_HOP_FORWARD;
		try {

			Long idReserva;
			Long idApartamento;
			if (!MozartUtil.isNull(checkin.getReservaEJB())
					&& !MozartUtil.isNull(checkin.getReservaEJB()
							.getIdReserva())) {
				
				idReserva = checkin.getReservaEJB().getIdReserva();
			}else {
				idReserva = checkin.getReservaApartamentoEJB().getReservaEJB().getIdReserva();
			}
			if (!MozartUtil.isNull(checkin.getApartamentoEJB())
					&& !MozartUtil.isNull(checkin.getApartamentoEJB()
							.getIdApartamento())) {
				
				idApartamento = checkin.getApartamentoEJB()
						.getIdApartamento();
			}else {
				idApartamento = checkin.getReservaApartamentoEJB().getApartamentoEJB().getIdApartamento();
			}
			List<MovAptoPgtoAntecipadoVO> list = CheckinDelegate.instance()
					.buscarPagamentoAntecipado(idReserva);
			if (list != null && !list.isEmpty()) {
				retorno = SUCESSO_CHK_FST_HOP_TRANSF_DESP_FORWARD;
				request.getSession().setAttribute("ID_RES_PAG_ANTEC", idReserva);
				request.getSession().setAttribute("ID_APTO_COFAN_PAG_ANTEC",
						list.get(0).getIdApartamento());
				request.getSession().setAttribute("ID_APTO_CHECKIN",idApartamento);
			}

		} catch (MozartSessionException ex) {
			error(ex.getMessage());
			addActionError("Erro ao verificar Pagamento Antecipado.");
		}

		return retorno;
	}

	public void setFiltro(CheckinVO filtro) {
		this.filtro = filtro;
	}

	public CheckinVO getFiltro() {
		return this.filtro;
	}

	public void setListaReservaDia(List<CheckinVO> listaReservaDia) {
		this.listaReservaDia = listaReservaDia;
	}

	public List<CheckinVO> getListaReservaDia() {
		return this.listaReservaDia;
	}

	public void setListaReservaCombo(List<String> listaReservaCombo) {
		this.listaReservaCombo = listaReservaCombo;
	}

	public List<String> getListaReservaCombo() {
		return this.listaReservaCombo;
	}

	public void setListaHospedeCombo(List<String> listaHospedeCombo) {
		this.listaHospedeCombo = listaHospedeCombo;
	}

	public List<String> getListaHospedeCombo() {
		return this.listaHospedeCombo;
	}

	public void setListaGrupoCombo(List<String> listaGrupoCombo) {
		this.listaGrupoCombo = listaGrupoCombo;
	}

	public List<String> getListaGrupoCombo() {
		return this.listaGrupoCombo;
	}

	public void setListaEmpresaCombo(List<String> listaEmpresaCombo) {
		this.listaEmpresaCombo = listaEmpresaCombo;
	}

	public List<String> getListaEmpresaCombo() {
		return this.listaEmpresaCombo;
	}

	public String getIdReserva() {
		return this.idReserva;
	}

	public void setIdReserva(String idReserva) {
		this.idReserva = idReserva;
	}

	public void setListaTipoApto(List<TipoApartamentoEJB> listaTipoApto) {
		this.listaTipoApto = listaTipoApto;
	}

	public List<TipoApartamentoEJB> getListaTipoApto() {
		return this.listaTipoApto;
	}

	public void setIdxCheckin(Long idxCheckin) {
		this.idxCheckin = idxCheckin;
	}

	public Long getIdxCheckin() {
		return this.idxCheckin;
	}

	public void setTipoApartamentoCheckin(Long[] tipoApartamentoCheckin) {
		this.tipoApartamentoCheckin = tipoApartamentoCheckin;
	}

	public Long[] getTipoApartamentoCheckin() {
		return this.tipoApartamentoCheckin;
	}

	public void setListaReservaApartamento(
			List<ReservaApartamentoEJB> listaReservaApartamento) {
		this.listaReservaApartamento = listaReservaApartamento;
	}

	public List<ReservaApartamentoEJB> getListaReservaApartamento() {
		return this.listaReservaApartamento;
	}

	public void setIdTipoApartamento(Long[] idTipoApartamento) {
		this.idTipoApartamento = idTipoApartamento;
	}

	public Long[] getIdTipoApartamento() {
		return this.idTipoApartamento;
	}

	public void setIdApartamento(Long[] idApartamento) {
		this.idApartamento = idApartamento;
	}

	public Long[] getIdApartamento() {
		return this.idApartamento;
	}

	public void setMaster(String[] master) {
		this.master = master;
	}

	public String[] getMaster() {
		return this.master;
	}

	public void setConfirmada(String[] confirmada) {
		this.confirmada = confirmada;
	}

	public String[] getConfirmada() {
		return this.confirmada;
	}

	public void setListaApartamento(List<List<ApartamentoEJB>> listaApartamento) {
		this.listaApartamento = listaApartamento;
	}

	public List<List<ApartamentoEJB>> getListaApartamento() {
		return this.listaApartamento;
	}

	public void setMotivoViagem(List<String> motivoViagem) {
		this.motivoViagem = motivoViagem;
	}

	public List<String> getMotivoViagem() {
		return this.motivoViagem;
	}

	public void setTipoTransporte(List<String> tipoTransporte) {
		this.tipoTransporte = tipoTransporte;
	}

	public List<String> getTipoTransporte() {
		return this.tipoTransporte;
	}

	public void setIdxHospede(Long idxHospede) {
		this.idxHospede = idxHospede;
	}

	public Long getIdxHospede() {
		return this.idxHospede;
	}

	public void setHospedePrincipal(String[] hospedePrincipal) {
		this.hospedePrincipal = hospedePrincipal;
	}

	public String[] getHospedePrincipal() {
		return this.hospedePrincipal;
	}

	public void setHospedeChegou(String[] hospedeChegou) {
		this.hospedeChegou = hospedeChegou;
	}

	public String[] getHospedeChegou() {
		return this.hospedeChegou;
	}

	public void setNomeHospede(String nomeHospede) {
		this.nomeHospede = nomeHospede;
	}

	public String getNomeHospede() {
		return this.nomeHospede;
	}

	public void setListaCheckin(List<CheckinEJB> listaCheckin) {
		this.listaCheckin = listaCheckin;
	}

	public List<CheckinEJB> getListaCheckin() {
		return this.listaCheckin;
	}

	public void setCheckinCorrente(CheckinEJB checkinCorrente) {
		this.checkinCorrente = checkinCorrente;
	}

	public CheckinEJB getCheckinCorrente() {
		return this.checkinCorrente;
	}

	public void setIdCidadeOrigem(Long idCidadeOrigem) {
		this.idCidadeOrigem = idCidadeOrigem;
	}

	public Long getIdCidadeOrigem() {
		return this.idCidadeOrigem;
	}

	public void setCidadeOrigem(String cidadeOrigem) {
		this.cidadeOrigem = cidadeOrigem;
	}

	public String getCidadeOrigem() {
		return this.cidadeOrigem;
	}

	public void setIdCidadeDestino(Long idCidadeDestino) {
		this.idCidadeDestino = idCidadeDestino;
	}

	public Long getIdCidadeDestino() {
		return this.idCidadeDestino;
	}

	public void setCidadeDestino(String cidadeDestino) {
		this.cidadeDestino = cidadeDestino;
	}

	public String getCidadeDestino() {
		return this.cidadeDestino;
	}

	public void setSalvarParaTodos(String salvarParaTodos) {
		this.salvarParaTodos = salvarParaTodos;
	}

	public String getSalvarParaTodos() {
		return this.salvarParaTodos;
	}

	public void setIdTipoLancamento(Long idTipoLancamento) {
		this.idTipoLancamento = idTipoLancamento;
	}

	public Long getIdTipoLancamento() {
		return this.idTipoLancamento;
	}

	public void setQtdeTipoLancamento(Long qtdeTipoLancamento) {
		this.qtdeTipoLancamento = qtdeTipoLancamento;
	}

	public Long getQtdeTipoLancamento() {
		return this.qtdeTipoLancamento;
	}

	public void setValorTipoLancamento(Double valorTipoLancamento) {
		this.valorTipoLancamento = valorTipoLancamento;
	}

	public Double getValorTipoLancamento() {
		return this.valorTipoLancamento;
	}

	public void setMotivoDaViagem(String motivoDaViagem) {
		this.motivoDaViagem = motivoDaViagem;
	}

	public String getMotivoDaViagem() {
		return this.motivoDaViagem;
	}

	public void setTipoDoTransporte(String tipoDoTransporte) {
		this.tipoDoTransporte = tipoDoTransporte;
	}

	public String getTipoDoTransporte() {
		return this.tipoDoTransporte;
	}

	public void setNomeHospedeNovo(String nomeHospedeNovo) {
		this.nomeHospedeNovo = nomeHospedeNovo;
	}

	public String getNomeHospedeNovo() {
		return this.nomeHospedeNovo;
	}

	public void setSobrenomeHospedeNovo(String sobrenomeHospedeNovo) {
		this.sobrenomeHospedeNovo = sobrenomeHospedeNovo;
	}

	public String getSobrenomeHospedeNovo() {
		return this.sobrenomeHospedeNovo;
	}

	public void setCpfHospedeNovo(String cpfHospedeNovo) {
		this.cpfHospedeNovo = cpfHospedeNovo;
	}

	public String getCpfHospedeNovo() {
		return this.cpfHospedeNovo;
	}

	public void setPassaporteHospedeNovo(String passaporteHospedeNovo) {
		this.passaporteHospedeNovo = passaporteHospedeNovo;
	}

	public String getPassaporteHospedeNovo() {
		return this.passaporteHospedeNovo;
	}

	public void setDataNascimentoHospedeNovo(Timestamp dataNascimentoHospedeNovo) {
		this.dataNascimentoHospedeNovo = dataNascimentoHospedeNovo;
	}

	public Timestamp getDataNascimentoHospedeNovo() {
		return this.dataNascimentoHospedeNovo;
	}

	public void setIdHospede(Long idHospede) {
		this.idHospede = idHospede;
	}

	public Long getIdHospede() {
		return this.idHospede;
	}

	public void setQtdePaxList(List<String> qtdePaxList) {
		this.qtdePaxList = qtdePaxList;
	}

	public List<String> getQtdePaxList() {
		return this.qtdePaxList;
	}

	public void setTipoPensaoList(List<MozartComboWeb> tipoPensaoList) {
		this.tipoPensaoList = tipoPensaoList;
	}

	public List<MozartComboWeb> getTipoPensaoList() {
		return this.tipoPensaoList;
	}

	public void setQtdePax(Long qtdePax) {
		this.qtdePax = qtdePax;
	}

	public Long getQtdePax() {
		return this.qtdePax;
	}

	public void setQtdeAdicional(Long qtdeAdicional) {
		this.qtdeAdicional = qtdeAdicional;
	}

	public Long getQtdeAdicional() {
		return this.qtdeAdicional;
	}

	public void setQtdeCrianca(Long qtdeCrianca) {
		this.qtdeCrianca = qtdeCrianca;
	}

	public Long getQtdeCrianca() {
		return this.qtdeCrianca;
	}

	public void setQtdeCafe(Long qtdeCafe) {
		this.qtdeCafe = qtdeCafe;
	}

	public Long getQtdeCafe() {
		return this.qtdeCafe;
	}

	public void setApartamento(Long apartamento) {
		this.apartamento = apartamento;
	}

	public Long getApartamento() {
		return this.apartamento;
	}

	public void setIdMoeda(Long idMoeda) {
		this.idMoeda = idMoeda;
	}

	public Long getIdMoeda() {
		return this.idMoeda;
	}

	public void setIdEmpresa(Long idEmpresa) {
		this.idEmpresa = idEmpresa;
	}

	public Long getIdEmpresa() {
		return this.idEmpresa;
	}

	public void setApartamentoList(List<ApartamentoEJB> apartamentoList) {
		this.apartamentoList = apartamentoList;
	}

	public List<ApartamentoEJB> getApartamentoList() {
		return this.apartamentoList;
	}

	public void setMoedaList(List<MoedaEJB> moedaList) {
		this.moedaList = moedaList;
	}

	public List<MoedaEJB> getMoedaList() {
		return this.moedaList;
	}

	public void setNomeGrupo(String nomeGrupo) {
		this.nomeGrupo = nomeGrupo;
	}

	public String getNomeGrupo() {
		return this.nomeGrupo;
	}

	public void setHoraFinal(String horaFinal) {
		this.horaFinal = horaFinal;
	}

	public String getHoraFinal() {
		return this.horaFinal;
	}

	public void setIssHospede(String issHospede) {
		this.issHospede = issHospede;
	}

	public String getIssHospede() {
		return this.issHospede;
	}

	public void setTaxaServicoHospede(String taxaServicoHospede) {
		this.taxaServicoHospede = taxaServicoHospede;
	}

	public String getTaxaServicoHospede() {
		return this.taxaServicoHospede;
	}

	public void setRoomTaxHospede(String roomTaxHospede) {
		this.roomTaxHospede = roomTaxHospede;
	}

	public String getRoomTaxHospede() {
		return this.roomTaxHospede;
	}

	public void setIssEmpresa(String issEmpresa) {
		this.issEmpresa = issEmpresa;
	}

	public String getIssEmpresa() {
		return this.issEmpresa;
	}

	public void setTaxaServicoEmpresa(String taxaServicoEmpresa) {
		this.taxaServicoEmpresa = taxaServicoEmpresa;
	}

	public String getTaxaServicoEmpresa() {
		return this.taxaServicoEmpresa;
	}

	public void setRoomTaxEmpresa(String roomTaxEmpresa) {
		this.roomTaxEmpresa = roomTaxEmpresa;
	}

	public String getRoomTaxEmpresa() {
		return this.roomTaxEmpresa;
	}

	public void setPossuiCredito(String possuiCredito) {
		this.possuiCredito = possuiCredito;
	}

	public String getPossuiCredito() {
		return this.possuiCredito;
	}

	public void setBebidaAlcoolica(String bebidaAlcoolica) {
		this.bebidaAlcoolica = bebidaAlcoolica;
	}

	public String getBebidaAlcoolica() {
		return this.bebidaAlcoolica;
	}

	public void setCortesia(String cortesia) {
		this.cortesia = cortesia;
	}

	public String getCortesia() {
		return this.cortesia;
	}

	public void setTarifaEmpresa(String tarifaEmpresa) {
		this.tarifaEmpresa = tarifaEmpresa;
	}

	public String getTarifaEmpresa() {
		return this.tarifaEmpresa;
	}

	public void setJustificativaTarifa(String justificativaTarifa) {
		this.justificativaTarifa = justificativaTarifa;
	}

	public String getJustificativaTarifa() {
		return this.justificativaTarifa;
	}

	public void setObservacao(String observacao) {
		this.observacao = observacao;
	}

	public String getObservacao() {
		return this.observacao;
	}

	public void setEmpresa(String empresa) {
		this.empresa = empresa;
	}

	public String getEmpresa() {
		return this.empresa;
	}

	public void setComissao(Double comissao) {
		this.comissao = comissao;
	}

	public Double getComissao() {
		return this.comissao;
	}

	public void setValorTarifa(Double valorTarifa) {
		this.valorTarifa = valorTarifa;
	}

	public Double getValorTarifa() {
		return this.valorTarifa;
	}

	public void setDataInicial(Timestamp dataInicial) {
		this.dataInicial = dataInicial;
	}

	public Timestamp getDataInicial() {
		return this.dataInicial;
	}

	public void setDataFinal(Timestamp dataFinal) {
		this.dataFinal = dataFinal;
	}

	public Timestamp getDataFinal() {
		return this.dataFinal;
	}

	public void setTipoPensao(String tipoPensao) {
		this.tipoPensao = tipoPensao;
	}

	public String getTipoPensao() {
		return this.tipoPensao;
	}

	public void setQuemPagaList(List<MozartComboWeb> quemPagaList) {
		this.quemPagaList = quemPagaList;
	}

	public List<MozartComboWeb> getQuemPagaList() {
		return this.quemPagaList;
	}

	public void setQuemPagaSelecionado(String[] quemPaga) {
		this.quemPagaSelecionado = quemPaga;
	}

	public String[] getQuemPagaSelecionado() {
		return this.quemPagaSelecionado;
	}

	public void setIdentificaLancamento(Long[] identificaLancamento) {
		this.identificaLancamento = identificaLancamento;
	}

	public Long[] getIdentificaLancamento() {
		return this.identificaLancamento;
	}

	public void setIdCheckin(Long idCheckin) {
		this.idCheckin = idCheckin;
	}

	public Long getIdCheckin() {
		return this.idCheckin;
	}

	public void setEmpresaHotel(EmpresaHotelEJB empresaHotel) {
		this.empresaHotel = empresaHotel;
	}

	public EmpresaHotelEJB getEmpresaHotel() {
		return this.empresaHotel;
	}

	public void setEmailHospedeNovo(String emailHospedeNovo) {
		this.emailHospedeNovo = emailHospedeNovo;
	}

	public String getEmailHospedeNovo() {
		return this.emailHospedeNovo;
	}

	public void setSeguroHospede(String seguroHospede) {
		this.seguroHospede = seguroHospede;
	}

	public String getSeguroHospede() {
		return this.seguroHospede;
	}

	public void setListaSexo(List<MozartComboWeb> listaSexo) {
		this.listaSexo = listaSexo;
	}

	public List<MozartComboWeb> getListaSexo() {
		return this.listaSexo;
	}

	public void setSexoHospedeNovo(String sexoHospedeNovo) {
		this.sexoHospedeNovo = sexoHospedeNovo;
	}

	public String getSexoHospedeNovo() {
		return this.sexoHospedeNovo;
	}

	public Timestamp getChartDataEntrada() {
		return this.chartDataEntrada;
	}

	public void setChartDataEntrada(Timestamp chartDataEntrada) {
		this.chartDataEntrada = chartDataEntrada;
	}

	public Timestamp getChartDataSaida() {
		return this.chartDataSaida;
	}

	public void setChartDataSaida(Timestamp chartDataSaida) {
		this.chartDataSaida = chartDataSaida;
	}

	public List<ChartApartamentoVO> getChartApartamentoList() {
		return this.chartApartamentoList;
	}

	public void setChartApartamentoList(
			List<ChartApartamentoVO> chartApartamentoList) {
		this.chartApartamentoList = chartApartamentoList;
	}

	public List<Timestamp> getChartDatasList() {
		return this.chartDatasList;
	}

	public void setChartDatasList(List<Timestamp> chartDatasList) {
		this.chartDatasList = chartDatasList;
	}

	public String getProcurarPor() {
		return this.procurarPor;
	}

	public void setProcurarPor(String procurarPor) {
		this.procurarPor = procurarPor;
	}

	public List<ProcurarHospedeVO> getHospedeList() {
		return this.hospedeList;
	}

	public void setHospedeList(List<ProcurarHospedeVO> hospedeList) {
		this.hospedeList = hospedeList;
	}

	public String getSeguro() {
		return this.seguro;
	}

	public void setSeguro(String seguro) {
		this.seguro = seguro;
	}

	public String getCofan() {
		return this.cofan;
	}

	public void setCofan(String cofan) {
		this.cofan = cofan;
	}

	public String getSeguroPopUp() {
		return this.seguroPopUp;
	}

	public void setSeguroPopUp(String seguroPopUp) {
		this.seguroPopUp = seguroPopUp;
	}

}