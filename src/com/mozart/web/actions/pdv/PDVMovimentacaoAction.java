package com.mozart.web.actions.pdv;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.sql.Blob;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.EstoqueDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.delegate.PdvDelegate;
import com.mozart.model.delegate.ReservaDelegate;
import com.mozart.model.ejb.entity.CaixaPontoVendaEJB;
import com.mozart.model.ejb.entity.CheckinEJB;
import com.mozart.model.ejb.entity.MesaEJB;
import com.mozart.model.ejb.entity.MovimentoApartamentoEJB;
import com.mozart.model.ejb.entity.MovimentoRestauranteEJB;
import com.mozart.model.ejb.entity.PontoVendaEJB;
import com.mozart.model.ejb.entity.PontoVendaEJBPK;
import com.mozart.model.ejb.entity.PratoEJB;
import com.mozart.model.ejb.entity.PratoEJBPK;
import com.mozart.model.ejb.entity.ReservaGrupoLancamentoEJB;
import com.mozart.model.ejb.entity.RestTlHtlEJB;
import com.mozart.model.ejb.entity.RoomListEJB;
import com.mozart.model.ejb.entity.StatusNotaEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJB;
import com.mozart.model.ejb.entity.TipoRefeicaoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ApartamentoHospedeVO;
import com.mozart.model.vo.ContaCorrenteGeralVO;
import com.mozart.model.vo.DadosDescricaoVendaNotaVO;
import com.mozart.model.vo.DadosFormaPagamentoNotaVO;
import com.mozart.model.vo.DadosGeraisNotaVO;
import com.mozart.model.vo.DadosResumoItensNotaVO;
import com.mozart.model.vo.GarconVO;
import com.mozart.model.vo.MovimentoApartamentoVO;
import com.mozart.model.vo.MovimentoEstoqueVO;
import com.mozart.model.vo.MovimentoRestauranteVO;
import com.mozart.model.vo.NotaNaoFiscalVO;
import com.mozart.model.vo.PontoVendaVO;
import com.mozart.model.vo.RetornoNotaFiscalVO;
import com.mozart.model.vo.UsuarioVO;
import com.mozart.model.vo.filtro.FiltroWeb;
import com.mozart.web.actions.BaseAction;

public class PDVMovimentacaoAction extends BaseAction {

	private static final long ID_IDENTIFICA_LANCAMENTO_DEBITO_TERCEIRIZADO = 53L;

	private static final long ID_IDENTIFICA_LANCAMENTO_DEBITO_PROPRIO = 18L;
	private static final long ID_IDENTIFICA_LANCAMENTO_COMIDA_BEBIDA = 4L;

	/**
	 * 
	 */
	private static final long serialVersionUID = 4181218424838245214L;

	private MovimentoRestauranteVO filtro;
	private List<ApartamentoHospedeVO> listApartamentoHospede;
	private List<ContaCorrenteGeralVO> listContaCorrente;

	private Long[] idMovimentosRestaurante;
	private Long[] idMovimentosPagamento;
	private Long idMovimentoExclusao;

	private Long[] idPgtosRestaurante;
	private Long idPgtoExclusao;

	private MovimentoRestauranteEJB entidade;
	private List<PontoVendaVO> comboPontoVenda;
	private List<TipoRefeicaoEJB> comboTipoRefeicao;
	private List<GarconVO> comboGarcon;
	private List<TipoLancamentoEJB> tipoPagamentoList;

	private Long idCheckin;
	private Long idCheckinDebito;
	private Long idRoomListDebito;
	private Long idApartamento;
	private Long idApartamentoDebito;
	private Long idTipoLancamento;
	private Long idContaCorrenteDebito;
	private String valorPagamento;
	
	private String dataHotel;
	private String cpfCnpjHidden;

	private String mesa;
	private Long idMesa;
	private Long garcon;
	private Long pontoVenda;
	private Long tipoRefeicao;
	private Long numPessoas;
	private String numComanda;
	private String prato;
	private Long idPrato;
	private Long quantidade;
	private String desconto;
	private String percTaxaServico;
	private String valorTotal;
	private String valorPago;
	private String valorSaldo;
	private String valorTaxa;
	private String dataRest;

	private Long indice;
	private Long indicePgto;
	protected String status;

	public PDVMovimentacaoAction() {
		filtro = new MovimentoRestauranteVO();

		entidade = new MovimentoRestauranteEJB();

	}

	public String prepararMovimentacao() throws MozartSessionException {
		request.getSession().removeAttribute("listaPesquisa");

		List<MovimentoRestauranteVO> entidade = new ArrayList();
		this.request.getSession().setAttribute("entidadeSession", entidade);

		List<MovimentoApartamentoVO> listPgto = new ArrayList();
		this.request.getSession().setAttribute("pgtoSession", listPgto);
		
		request.setAttribute("filtro.datamovimento.tipoIntervalo", "2");
		request.setAttribute("filtro.datamovimento.valorInicial", MozartUtil.format(getControlaData().getFrontOffice(), MozartUtil.FMT_DATE));

		return SUCESSO_FORWARD;
	}

	public String prepararInclusao() throws MozartSessionException {
		request.getSession().removeAttribute("listaPesquisa");

		dataHotel = MozartUtil.format(getControlaData().getFrontOffice());
		initCombos();

		return SUCESSO_FORWARD;
	}

	public String prepararPagamento() throws MozartSessionException {
		request.getSession().removeAttribute("listaPesquisa");

		initCombos();

		return SUCESSO_FORWARD + "Pgto";
	}

	public String pesquisar() {
		info("Pesquisando Movimentação - PDV");
		try {
			request.getSession().removeAttribute("listaPesquisa");

			List<MovimentoRestauranteVO> listaPesquisa = null;
			filtro.setIdHoteis(new Long[] { getHotelCorrente().getIdHotel() });
			listaPesquisa = PdvDelegate.instance()
					.pesquisarMovimentoRestaurante(filtro);

			request.getSession().setAttribute("listaPesquisa", listaPesquisa);

			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			return SUCESSO_FORWARD;
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			return SUCESSO_FORWARD;
		}
	}

	public MovimentoRestauranteVO getFiltro() {
		return filtro;
	}

	public void setFiltro(MovimentoRestauranteVO filtro) {
		this.filtro = filtro;
	}

	private void initCombos() throws MozartSessionException {

		comboPontoVenda = OperacionalDelegate.instance()
				.pesquisarPontoVendaUsuario(
						new UsuarioVO(getUsuario().getIdUsuario(), "",
								getHotelCorrente().getIdHotel()));

		TipoRefeicaoEJB filtro = new TipoRefeicaoEJB();
		filtro.setIdRedeHotel(getIdRedeHotel());
		comboTipoRefeicao = OperacionalDelegate.instance()
				.pesquisarTipoRefeicao(filtro);

		GarconVO filtroGarcon = new GarconVO();
		filtroGarcon.setIdHoteis(getIdHoteis());
		FiltroWeb ativo = new FiltroWeb();
		ativo.setTipoIntervalo("3");
		ativo.setTipo("C");
		ativo.setValorInicial("S");
		filtroGarcon.setFiltroAtivo(ativo);
		comboGarcon = OperacionalDelegate.instance().pesquisarGarcon(
				filtroGarcon);

		TipoLancamentoEJB paramTipo = new TipoLancamentoEJB();
		paramTipo.setIdHotel(getIdHoteis()[0]);
		paramTipo.setGrupoLancamento("99");
		tipoPagamentoList = CheckinDelegate.instance()
				.pesquisarSubGrupoLancamento(paramTipo);

		ApartamentoHospedeVO apartamentoHospedeVO = new ApartamentoHospedeVO();
		apartamentoHospedeVO.setIdHotel(getHotelRestauranteCorrente()
				.getIdHotel());

		listApartamentoHospede = OperacionalDelegate.instance()
				.pesquisarApartamentoHospede(apartamentoHospedeVO);
				
		ContaCorrenteGeralVO contaCorrenteVO = new ContaCorrenteGeralVO();
		contaCorrenteVO.setIdHoteis(getIdHoteis());

		listContaCorrente = CheckinDelegate.instance().pesquisarContaCorrenteGeral(contaCorrenteVO);

		String data = dataRest;
		this.request.getSession().removeAttribute("MovPagosSession");
	}

	private void sincronizarLancamento() throws Exception {
		initCombos();

		List<MovimentoRestauranteVO> listEntidade = (List) this.request
				.getSession().getAttribute("entidadeSession");

		Double valorTot = 0D;
		for (MovimentoRestauranteVO movimentoRestauranteVO : listEntidade) {
			valorTot += movimentoRestauranteVO.getVlPrato();
		}

		valorTotal = MozartUtil.format(valorTot);
	}

	public String excluirMovimento() {
		try {

			MovimentoRestauranteEJB movimentoRestaurante = new MovimentoRestauranteEJB();
			movimentoRestaurante.setIdMovimentoRestaurante(idMovimentoExclusao);

			PdvDelegate.instance().excluir(movimentoRestaurante);

			List<MovimentoRestauranteVO> listEntidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

			listEntidade.remove(this.indice.intValue());

			resetLancamento();
			sincronizarLancamento();
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String incluirMovimentacao() {
		try {
			this.request.removeAttribute("MovPagosSession");
			List<MovimentoRestauranteVO> listEntidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

			Long idHotel = getHotelCorrente().getIdHotel();

			PontoVendaEJBPK pkPontoVenda = new PontoVendaEJBPK();
			pkPontoVenda.setIdHotel(idHotel);
			pkPontoVenda.setIdPontoVenda(pontoVenda);
			PontoVendaEJB pontoVendaEJB = (PontoVendaEJB) CheckinDelegate
					.instance().obter(PontoVendaEJB.class, pkPontoVenda);

			MovimentoRestauranteEJB movimentoRestaurante = new MovimentoRestauranteEJB();

			movimentoRestaurante.setIdPontoVenda(pontoVenda);
			movimentoRestaurante.setIdHotel(idHotel);
			movimentoRestaurante.setIdMesa(idMesa);
			movimentoRestaurante.setIdGarcon(garcon);
			movimentoRestaurante.setDataMovimento(pontoVendaEJB.getDataPv());
			movimentoRestaurante.setNumComanda(numComanda);
			movimentoRestaurante.setIdPrato(idPrato);
			movimentoRestaurante.setQuantidade(new BigDecimal(quantidade));

			PratoEJBPK pkPrato = new PratoEJBPK();
			pkPrato.setIdHotel(idHotel);
			pkPrato.setIdPrato(idPrato);
			PratoEJB pratoEJB = (PratoEJB) CheckinDelegate.instance().obter(
					PratoEJB.class, pkPrato);

			movimentoRestaurante.setValorUnitario(new BigDecimal(pratoEJB
					.getValorPrato()));

			Locale meuLocal = new Locale( "pt", "BR" );
			NumberFormat nfVal = NumberFormat.getCurrencyInstance( meuLocal );
			
			Double vlDesconto = (nfVal.parse("R$ "
					+ desconto)).doubleValue();
			
			Double valorComDesconto = (quantidade * pratoEJB.getValorPrato()) - ((quantidade * pratoEJB.getValorPrato())*(vlDesconto/100));
			
			movimentoRestaurante.setValorPrato(new BigDecimal(valorComDesconto));

			movimentoRestaurante.setValorDesconto(new BigDecimal(vlDesconto));

			BigDecimal prcTxServico = !MozartUtil.isNull(pontoVendaEJB
					.getPercTaxaServico()) ? new BigDecimal(
					pontoVendaEJB.getPercTaxaServico()) : null;

			BigDecimal vlrTxSrv = (!MozartUtil.isNull(prcTxServico)) ? prcTxServico
					.movePointLeft(2).multiply(
							movimentoRestaurante.getValorPrato()) : null;

			movimentoRestaurante.setValorTaxaServico(vlrTxSrv);
			movimentoRestaurante.setUsuario(getUsuario());

			percTaxaServico = prcTxServico != null ? prcTxServico.toString()
					.replace(",", "").replace(".", ",") : "0,00";

			// Bloqueia a mesa e coloca a quantidade de pessoas.
			MesaEJB mesaEJB = (MesaEJB) CheckinDelegate.instance().obter(
					MesaEJB.class, idMesa);

			mesaEJB.setNumPessoas(numPessoas);
			mesaEJB.setStatusMesa("O");

			movimentoRestaurante = PdvDelegate.instance()
					.gravarMovimentoRestaurante(movimentoRestaurante, mesaEJB);

			MovimentoRestauranteVO movimento = montarMovimentoRestauranteVO(
					movimentoRestaurante, pratoEJB);

			listEntidade.add(movimento);

			this.request.getSession().setAttribute("entidadeSession",
					listEntidade);

			sincronizarLancamento();
			this.indice = null;
			resetLancamento();

		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}

		return "sucesso";
	}

	private MovimentoRestauranteVO montarMovimentoRestauranteVO(
			MovimentoRestauranteEJB movimentoRestaurante, PratoEJB pratoEJB) {
		MovimentoRestauranteVO movimento = new MovimentoRestauranteVO();

		movimento.setIdMovimentoRestaurante(movimentoRestaurante
				.getIdMovimentoRestaurante());
		movimento.setNomePrato(pratoEJB.getNomePrato());
		movimento.setQuantidade(movimentoRestaurante.getQuantidade()
				.longValue());
		movimento.setVlDesconto(movimentoRestaurante.getValorDesconto()
				.doubleValue());
		movimento
				.setVlPrato(movimentoRestaurante.getValorPrato().doubleValue());
		movimento.setVlUnitario(movimentoRestaurante.getValorUnitario()
				.doubleValue());
		movimento.setFlgAlcoolico(pratoEJB.getFlgAlcoolica());
		movimento.setIdGarcon(movimentoRestaurante.getIdGarcon());
		if (!MozartUtil.isNull(movimentoRestaurante.getGarconEJB())) {
			movimento.setNomeGarcon(movimentoRestaurante.getGarconEJB()
					.getNomeGarcon());
		}
		movimento.setNumComanda(movimentoRestaurante.getNumComanda());
		return movimento;
	}
	
	private MovimentoApartamentoVO montarPagamentoVO(
			MovimentoApartamentoEJB movimentoApartamento, Double valTx) {
		MovimentoApartamentoVO movimento = new MovimentoApartamentoVO();

		movimento.setIdMovimentoApartamento(movimentoApartamento.getIdMovimentoApartamento());
		
		Double valorLancar = movimentoApartamento.getValorLancamento().doubleValue() < 0 ? 
			 	(movimentoApartamento.getValorLancamento().doubleValue()*-1) + valTx : 
			 		movimentoApartamento.getValorLancamento().doubleValue() + valTx;
		
		movimento.setValorLancamento(valorLancar);
		
		// TODO VERIFICAR FORMAS DE LANCAMENTO DIFERENTES.
		if(movimentoApartamento.getTipoLancamentoEJB().getIdIdentificaLancamento().equals(16L))
			movimento.setDescricaoLancamento("Dinheiro");
		else if(movimentoApartamento.getTipoLancamentoEJB().getIdIdentificaLancamento().equals(19L))
			movimento.setDescricaoLancamento("Dinheiro");
		else
			movimento.setDescricaoLancamento("Dinheiro");
		//movimento.setDescricaoLancamento(movimentoApartamento.getTipoLancamentoEJB().getDescricaoLancamento());
		
		return movimento;
	}

	private void resetLancamento() {
		this.prato = null;
		this.idPrato = null;
		this.desconto = "0,00";
		this.quantidade = null;
	}

	private void resetPgto() {
		idCheckinDebito = null;
		idRoomListDebito = null;
		idContaCorrenteDebito = null;
		idApartamentoDebito = null;
		idTipoLancamento = null;
		valorPagamento = null;
	}

	public String adicionarPgto() {
		try {
			info("Adicionando um pagamento");
			initCombos();

			MovimentoApartamentoEJB movimentoApartamento = new MovimentoApartamentoEJB();
			MovimentoApartamentoEJB movAlcoolica = new MovimentoApartamentoEJB();
			movAlcoolica.setValorLancamento(0D);

			List<MovimentoApartamentoEJB> listPgto = (List) this.request
					.getSession().getAttribute("pgtoSession");

			List<MovimentoRestauranteVO> listMovimento = (List) this.request
					.getSession().getAttribute("entidadeSession");

			PontoVendaEJBPK pdvPK = new PontoVendaEJBPK();
			pdvPK.setIdHotel(getHotelCorrente().getIdHotel());
			pdvPK.setIdPontoVenda(pontoVenda);
			PontoVendaEJB pdv = (PontoVendaEJB) CheckinDelegate.instance()
					.obter(PontoVendaEJB.class, pdvPK);

			RoomListEJB roomListEJB = PdvDelegate.instance()
					.getRoomListPrincipalCheckin(pdv.getIdCheckin(), "S");

			Long idIdentificaLancamentoAux = getIdIdentificaLancamentoDebitado();

			Long idRedeHotel = getIdRedeHotel();

			Boolean isDebitoApto = false;

			for (TipoLancamentoEJB t : tipoPagamentoList) {
				if (t.getIdTipoLancamento().equals(idTipoLancamento)) {

					TipoLancamentoEJB tpLancAux = PdvDelegate
							.instance()
							.consultarTipoLancamentoParaRestauranteTerceirizado(
									t);

					if (t.getIdentificaLancamento().getIdIdentificaLancamento()
							.equals(idIdentificaLancamentoAux)) {

						roomListEJB = (RoomListEJB) CheckinDelegate.instance()
								.obter(RoomListEJB.class, idRoomListDebito);

						idRedeHotel = getIdRedeHotelRestaurante();
						isDebitoApto = true;

					}

					movimentoApartamento.setTipoLancamentoEJB(tpLancAux);
					break;
				}
			}

			if(getHotelCorrente().getIdPrograma() == 1)
				movimentoApartamento.setRoomListEJB(roomListEJB);
			
			if(!isDebitoApto && movimentoApartamento.getTipoLancamentoEJB().getIdentificaLancamento().getIdIdentificaLancamento()
					.equals(18L)){
			
				CheckinEJB checkinEJB = (CheckinEJB) CheckinDelegate.instance().obter(
						CheckinEJB.class, idContaCorrenteDebito);
				
				movimentoApartamento.setCheckinEJB(checkinEJB);
			}
			else if(MozartUtil.isNull(roomListEJB)){
					movimentoApartamento.setCheckinEJB(pdv.getCheckinEJB());
			}
			else
				movimentoApartamento.setCheckinEJB(roomListEJB.getCheckin());
			
			movimentoApartamento.setIdRedeHotel(idRedeHotel);
			movimentoApartamento.setCheckout("N");
			movimentoApartamento.setMovTmp("N");

			movimentoApartamento.setValorLancamento((NumberFormat
					.getCurrencyInstance().parse("R$ " + valorPagamento))
					.doubleValue());

			String quemPaga = "";

			for (Long idMovRestaurante : idMovimentosPagamento) {
				MovimentoRestauranteEJB movimento = (MovimentoRestauranteEJB) CheckinDelegate
						.instance().obter(MovimentoRestauranteEJB.class,
								idMovRestaurante);
				
				if(!MozartUtil.isNull(roomListEJB)){
					movimentoApartamento.setRoomListEJB(roomListEJB);
					if (roomListEJB.getCheckin().getApartamentoEJB().getCofan()
							.equals("S")) {
						quemPaga = "H";
					} else {
						for (ReservaGrupoLancamentoEJB rgl : roomListEJB
								.getCheckin().getReservaEJB()
								.getReservaGrupoLancamentoEJBList()) {
							if (rgl.getIdIdentificaLancamento().equals(
									ID_IDENTIFICA_LANCAMENTO_COMIDA_BEBIDA)) {
								quemPaga = rgl.getQuemPaga();
								if ("E".equals(quemPaga)
										&& "N".equals(roomListEJB.getCheckin()
												.getFlgAlcoolica())) {
									PratoEJBPK idPrato = new PratoEJBPK();
									idPrato.setIdHotel(movimento.getIdHotel());
									idPrato.setIdPrato(movimento.getIdPrato());
									PratoEJB prato = (PratoEJB) CheckinDelegate
											.instance().obter(PratoEJB.class,
													idPrato);
									if ("S".equals(prato.getFlgAlcoolica())) {
										movAlcoolica
												.setTipoLancamentoEJB(movimentoApartamento
														.getTipoLancamentoEJB());
	
										movAlcoolica.setQuemPaga("H");
										movAlcoolica
												.setCheckinEJB(movimentoApartamento
														.getCheckinEJB());
										movAlcoolica
												.setRoomListEJB(movimentoApartamento
														.getRoomListEJB());
										movAlcoolica.setCheckout("N");
										movAlcoolica.setMovTmp("N");
										movAlcoolica
												.setIdRedeHotel(movimentoApartamento
														.getIdRedeHotel());
	
										movAlcoolica
												.setValorLancamento(movAlcoolica
														.getValorLancamento()
														+ movimento.getValorPrato()
																.doubleValue());
	
									}
								}
								break;
							}
						}
					}
					if (isRestauranteProprio()) {
						movimento.setIdCheckin(roomListEJB.getCheckin()
								.getIdCheckin());
						CheckinDelegate.instance().alterar(movimento);
					}
				}
				else{
					quemPaga = "E";
				}
			}

			if (movAlcoolica.getValorLancamento().compareTo(0D) > 0) {
				if (!MozartUtil.isNull(valorTaxa)) {
					Locale meuLocal = new Locale( "pt", "BR" );
					NumberFormat nfVal = NumberFormat.getCurrencyInstance( meuLocal );
					
					Double vlrTaxa = (nfVal.parse("R$ " + valorTaxa)).doubleValue();
					if (vlrTaxa.doubleValue() > 0D) {
						movAlcoolica.setValorLancamento(movAlcoolica
								.getValorLancamento().doubleValue()
								* (1 + (pdv.getPercTaxaServico() / 100D)));
					}
				}
				listPgto.add(movAlcoolica);
			}

			//quemPaga = getHotelCorrente().getIdPrograma() != 1 ? "E" : quemPaga;
			
			movimentoApartamento.setQuemPaga(quemPaga);
			movimentoApartamento.setValorLancamento(movimentoApartamento
					.getValorLancamento() - movAlcoolica.getValorLancamento());
			movimentoApartamento.setUsuario(getUsuario());
			
			listPgto.add(movimentoApartamento);

			this.request.getSession().setAttribute("pgtoSession", listPgto);
			calcularValorPago();
			resetPgto();

			return SUCESSO_FORWARD + "Pgto";
		} catch (MozartValidateException e) {
			error(e.getMessage());
			addMensagemSucesso(e.getMessage());
			return SUCESSO_FORWARD + "Pgto";
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD + "Pgto";
	}

	public void calcularValorPago() {
		List<MovimentoApartamentoEJB> listPgto = (List) this.request
				.getSession().getAttribute("pgtoSession");

		BigDecimal valorPg = new BigDecimal(0);

		for (MovimentoApartamentoEJB mov : listPgto) {
			valorPg = valorPg.add(new BigDecimal(mov.getValorLancamento()));
		}

		valorPago = MozartUtil.format(valorPg.doubleValue());

		this.request.getSession().setAttribute("pgtoSession", listPgto);
	}

	public String removerPgto() {
		try {

			initCombos();

			List<MovimentoApartamentoEJB> listPgto = (List) this.request
					.getSession().getAttribute("pgtoSession");

			listPgto.remove(indicePgto.intValue());
			calcularValorPago();
			return SUCESSO_FORWARD + "Pgto";
		} catch (MozartValidateException e) {
			error(e.getMessage());
			addMensagemSucesso(e.getMessage());
			return SUCESSO_FORWARD + "Pgto";
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD + "Pgto";

	}

	@SuppressWarnings("deprecation")
	public String gravar() {
		try {

			initCombos();
			Timestamp now = MozartUtil.now();
			List<MovimentoRestauranteEJB> listMovRest = new ArrayList<MovimentoRestauranteEJB>();

			for (Long idMovRestaurante : idMovimentosPagamento) {
				MovimentoRestauranteEJB movimento = (MovimentoRestauranteEJB) CheckinDelegate
						.instance().obter(MovimentoRestauranteEJB.class,
								idMovRestaurante);
				listMovRest.add(movimento);
			}

			List<MovimentoApartamentoEJB> listPgto = (List) this.request
					.getSession().getAttribute("pgtoSession");

			PontoVendaEJBPK pdvPK = new PontoVendaEJBPK();
			pdvPK.setIdHotel(getHotelCorrente().getIdHotel());
			pdvPK.setIdPontoVenda(pontoVenda);
			PontoVendaEJB pdv = (PontoVendaEJB) CheckinDelegate.instance()
					.obter(PontoVendaEJB.class, pdvPK);

			StatusNotaEJB statusNota = new StatusNotaEJB();
			statusNota.setIdNota(ReservaDelegate.instance().obterNextVal());
			statusNota.setUsuario(getUsuario());

			long ultimaCnfe = MozartUtil.isNull(getControlaData().getUltimaCnfe()) ? 0 : getControlaData().getUltimaCnfe();
			long controle = MozartUtil.isNull(pdv.getControle()) ? 0 : pdv.getControle();
			
			statusNota.setLoteNfe(ultimaCnfe + 1L);
			statusNota.setRpsStatus("A");
			statusNota.setNumNota(String.valueOf(controle + 1L));
			pdv.setControle(Long.valueOf(statusNota.getNumNota()));
			statusNota.setTipoNota("R");
			statusNota.setStatus("OK");
			statusNota.setData(getControlaData().getFrontOffice());
			statusNota.setRestaurante("S");
			statusNota.setIdHotel(getHotelCorrente().getIdHotel());
			
			Timestamp dataEmissao = new Timestamp(pdv.getDataPv().getYear(), pdv.getDataPv().getMonth(), pdv.getDataPv().getDate(), now.getHours(), now.getMinutes(), now.getSeconds(), now.getNanos()); 
			
			statusNota.setDataEmissao(dataEmissao);

			statusNota.setCpfCnpj(cpfCnpjHidden);
			statusNota.setIdCheckin(pdv.getIdCheckin());

			statusNota = (StatusNotaEJB) PdvDelegate.instance()
					.gravarStatusNota(statusNota);

			pdv.setUsuario(getUsuario());
			PdvDelegate.instance().gravarPontoVenda(pdv);

			MesaEJB mesaEJB = (MesaEJB) CheckinDelegate.instance().obter(
					MesaEJB.class, idMesa);

			MovimentoApartamentoEJB movimentoTaxaServico = new MovimentoApartamentoEJB();
			movimentoTaxaServico.setValorLancamento(new Double(0));
			Double valTaxaTotal = new Double(0);

			if (!MozartUtil.isNull(valorTaxa)) {
				String vlrTaxa = valorTaxa.replace(".", "").replace(",", ".");
				valTaxaTotal = Double.parseDouble(vlrTaxa);
			}
			
			List<MovimentoApartamentoVO> listPagamento = new ArrayList<MovimentoApartamentoVO>();

			CaixaPontoVendaEJB caixaPontoVenda = new CaixaPontoVendaEJB();
			for (MovimentoApartamentoEJB movAptoRest : listPgto) {
				caixaPontoVenda.setIdCaixaPontoVenda(ReservaDelegate.instance()
						.obterNextVal());
				caixaPontoVenda.setIdPontoVenda(pontoVenda);
				caixaPontoVenda.setIdMesa(idMesa);

				// TODO TRATAR TIPO DE LANCAMENTO DO HOTEL CORRENTE
				caixaPontoVenda.setIdTipoLancamento(movAptoRest
						.getTipoLancamentoEJB().getIdTipoLancamento());

				caixaPontoVenda.setDataMovimento(getControlaData()
						.getFrontOffice());
				caixaPontoVenda.setNumNota(statusNota.getNumNota());
				caixaPontoVenda.setIdTipoRefeicao(tipoRefeicao);
				caixaPontoVenda.setQtdPessoas(numPessoas);
				caixaPontoVenda.setIdNota(statusNota.getIdNota());
				caixaPontoVenda.setIdHotel(getHotelCorrente().getIdHotel());
				caixaPontoVenda.setUsuario(getUsuario());

				caixaPontoVenda = (CaixaPontoVendaEJB) PdvDelegate.instance()
						.gravarCaixaPontoVenda(caixaPontoVenda);

				movAptoRest.setStatusNotaEJB(statusNota);

				movAptoRest.setNumDocumento(statusNota.getNumNota());

				movAptoRest.setDataLancamento(getControlaData()
						.getFrontOffice());
				movAptoRest.setHoraLancamento(now);

				// TODO TRATAR TERCEIRIZADO
				if (movAptoRest.getTipoLancamentoEJB()
						.getIdentificaLancamento().getIdIdentificaLancamento()
						.equals(18L)) {
					movAptoRest.setMovTmp("S");
					statusNota.setIdCheckin(movAptoRest.getCheckinEJB()
							.getIdCheckin());

					statusNota = (StatusNotaEJB) PdvDelegate.instance()
							.gravarStatusNota(statusNota);
				}

				movAptoRest.setIdMovimentoApartamento(ReservaDelegate
						.instance().obterNextVal());

				TipoLancamentoEJB tpLancAux = PdvDelegate.instance()
						.consultarTipoLancamentoParaRestauranteTerceirizado(
								pdv.getTipoLancamentoEJB());

				Double valorLancamentoSemTax = movAptoRest.getValorLancamento()
						.doubleValue();
				Double valTx = new Double(0);
				if ((!MozartUtil.isNull(pdv.getPercTaxaServico()))
						&& valTaxaTotal.doubleValue() > 0) {

					valorLancamentoSemTax = (valorLancamentoSemTax * 100D)
							/ (pdv.getPercTaxaServico() + 100D);

					valTx = movAptoRest.getValorLancamento()
							- valorLancamentoSemTax;

				}
				boolean isLancamentoContaHospede = false;
				if (!getIdIdentificaLancamentoDebitado().equals(
						movAptoRest.getTipoLancamentoEJB()
								.getIdIdentificaLancamento()) 
								&& ((!isRestauranteProprio() && !movAptoRest.getTipoLancamentoEJB()
										.getIdentificaLancamento().getIdIdentificaLancamento()
										.equals(18L)) || isRestauranteProprio())) {

					movAptoRest.setMovTmp("N");
					MovimentoApartamentoEJB pagamento = movAptoRest.clone();

					movAptoRest.setValorLancamento(valorLancamentoSemTax);
					
					movAptoRest
							.setTipoLancamentoEJB(pdv.getTipoLancamentoEJB());

					movAptoRest.setIdMovimentoApartamento(null);

					movAptoRest = PdvDelegate.instance()
							.gravarMovimentoApartamento(movAptoRest);

					pagamento.setIdMovimentoApartamento(null);

					pagamento.setValorLancamento(pagamento.getValorLancamento()
							* -1);

					pagamento = PdvDelegate.instance()
							.gravarMovimentoApartamento(pagamento);

				} else {
					movAptoRest.setMovTmp("S");
					movAptoRest.setValorLancamento(valorLancamentoSemTax);
					
					if (!isRestauranteProprio() && !movAptoRest.getTipoLancamentoEJB()
							.getIdentificaLancamento().getIdIdentificaLancamento()
							.equals(18L)) {
						movAptoRest.setStatusNotaEJB(null);
						MovimentoApartamentoEJB movimentoHotel = movAptoRest
								.clone();

						movimentoHotel.setIdMovimentoApartamento(null);
						movimentoHotel.setTipoLancamentoEJB(tpLancAux);
						
						movimentoHotel.setValorLancamento(valorLancamentoSemTax
								+ valTx);

						movimentoHotel = PdvDelegate.instance()
								.gravarMovimentoApartamento(movimentoHotel);

						RestTlHtlEJB restTlHtlEJB = PdvDelegate.instance()
								.consultarRestTlHtl(
										movimentoHotel.getTipoLancamentoEJB(),
										movAptoRest.getTipoLancamentoEJB());

						CheckinEJB checkinRest = MozartUtil
								.isNull(restTlHtlEJB) ? pdv.getCheckinEJB()
								: restTlHtlEJB.getCheckin();
					    
						isLancamentoContaHospede = MozartUtil
								.isNull(restTlHtlEJB) ? false : true;
								
						movAptoRest.setTipoLancamentoEJB(MozartUtil
								.isNull(restTlHtlEJB) ? movAptoRest.getTipoLancamentoEJB() 
										: restTlHtlEJB.getTipoLancamentoRestaurante());
						
						movAptoRest.setIdRedeHotel(getIdRedeHotel());
						movAptoRest.setCheckinEJB(checkinRest);

						RoomListEJB roomListRestaurante = PdvDelegate
								.instance().getRoomListPrincipalCheckin(
										movAptoRest.getCheckinEJB()
												.getIdCheckin(), "S");

						if(getHotelCorrente().getIdPrograma() == 1)
							movAptoRest.setRoomListEJB(roomListRestaurante);
						else
							movAptoRest.setRoomListEJB(null);

						movAptoRest.setIdMovimentoApartamento(null);
						movAptoRest.setQuemPaga("E");
						movAptoRest = PdvDelegate.instance()
								.gravarMovimentoApartamento(movAptoRest);

					} else {
						
						movAptoRest
						.setTipoLancamentoEJB(pdv.getTipoLancamentoEJB());
						
						movAptoRest.setIdMovimentoApartamento(null);

						movAptoRest = PdvDelegate.instance()
								.gravarMovimentoApartamento(movAptoRest);

					}

				}

				if (valTaxaTotal > 0) {
					movimentoTaxaServico = movAptoRest.clone();

					if (!isLancamentoContaHospede) {
						movimentoTaxaServico.setCheckinEJB(pdv.getCheckinEJB());
					}
					
					if(getHotelCorrente().getIdPrograma() == 1){
						RoomListEJB roomListRestaurante = PdvDelegate.instance()
								.getRoomListPrincipalCheckin(
										pdv.getCheckinEJB().getIdCheckin(), "S");
						movimentoTaxaServico.setRoomListEJB(roomListRestaurante);
					}
						
					
					movimentoTaxaServico.setTipoLancamentoEJB(pdv
							.getTipoLancamentoServicoEJB());
					movimentoTaxaServico.setIdRedeHotel(getIdRedeHotel());

					if (valTx.doubleValue() != 0D) {
						movimentoTaxaServico.setIdMovimentoApartamento(null);
						movimentoTaxaServico.setValorLancamento(valTx);
						movimentoTaxaServico = PdvDelegate.instance()
								.gravarMovimentoApartamento(
										movimentoTaxaServico);
					}
				}
				
				listPagamento.add(montarPagamentoVO(movAptoRest, valTx));			
				
			}

			for (MovimentoRestauranteEJB mov : listMovRest) {
				mov.setNumNota(statusNota.getNumNota());
				mov.setIdCaixaPontoVenda(caixaPontoVenda.getIdCaixaPontoVenda());
				mov.setUsuario(getUsuario());
				CheckinDelegate.instance().alterar(mov);
				
				//PdvDelegate.instance().executarProcedureNfeRestaurante(mov.getIdMovimentoRestaurante());
			}

			pesquisarMovimentacao();
			sincronizarLancamento();
			if (MozartUtil.isNull(this.request.getAttribute("entidadeSession"))) {
				mesaEJB.setStatusMesa("L");
				mesaEJB.setUsuario(getUsuario());
				CheckinDelegate.instance().alterar(mesaEJB);
			}
			
			MovimentoEstoqueVO filtroMovimentoEstoqueVO = new MovimentoEstoqueVO();
			filtroMovimentoEstoqueVO.setIdHotel(getHotelCorrente().getIdHotel());
			filtroMovimentoEstoqueVO.setIdPontoVenda(pontoVenda);
			filtroMovimentoEstoqueVO.setNumNota(statusNota.getNumNota());
			MovimentoEstoqueVO movimentoEstoqueVO = EstoqueDelegate.instance().pesquisarMovimentoEstoqueFechamento(filtroMovimentoEstoqueVO);
			
			if(movimentoEstoqueVO.getIdMovEstoque() != null){
				EstoqueDelegate.instance().salvarFechamentoMovimentoEstoque(movimentoEstoqueVO);
			}
			
			List<DadosResumoItensNotaVO> resumoItens = PdvDelegate.instance().obterResumoItensNota(getHotelCorrente(), statusNota);
			if(resumoItens.size() > 0)
				statusNota.setDiscriminacao(getHotelCorrente().getNotaTermo() + getHotelCorrente().getImpostosMercadoria() + "%" + " no valor de R$ " + resumoItens.get(0).getImposto());
			
			if((!MozartUtil.isNull(pdv.getNotaFiscal()) && pdv.getNotaFiscal().equals("S")) || 1 == 1){
				EnvioNotaFiscalBusiness envioNotaFiscal = new EnvioNotaFiscalBusiness();
				RetornoNotaFiscalVO retornoNota = envioNotaFiscal.envioNota(getHotelCorrente().getIdHotel(), statusNota.getIdNota());
				if(retornoNota.getErros().size() > 0)
				{
					
				}
				else{
					statusNota.setXml(retornoNota.getXmlNota().getBytes());
					statusNota.setNomeArquivoNotaNfe(retornoNota.getIdNotaFiscal());
					statusNota.setChaveAcesso(retornoNota.getChaveNota());
					statusNota.setRpsStatus("T");
				}
			}
			
			CheckinDelegate.instance().alterar(statusNota);
			
			if(getHotelCorrente().getCupomfiscal().equals("S")){
				//montarImpressaoCupom(statusNota, pdv, resumoItens);
			}
			
			this.request.getSession().removeAttribute("movPagosSession");
			this.request.getSession().removeAttribute("pgtoRelSession");
			
			valorTaxa = "";
			addMensagemSucesso("Operação realizada com sucesso. Número da Nota: " + statusNota.getNumNota());
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
	
	public void montarImpressaoCupom(StatusNotaEJB nota, PontoVendaEJB pdv, List<DadosResumoItensNotaVO> resumoItens) throws MozartSessionException, UnsupportedEncodingException{
		
		NotaNaoFiscalVO notaFiscal = new NotaNaoFiscalVO();
		
		notaFiscal.setNomeImpressora(!MozartUtil.isNull(pdv.getModeloImpressora()) && !MozartUtil.isNull(pdv.getModeloImpressora().getModelo()) ? pdv.getModeloImpressora().getModelo() : "MP-4200 TH");
		notaFiscal.setChaveNota(nota.getChaveAcesso());
		notaFiscal.setUrlQrCode(PdvDelegate.instance().obterUrlQrCode(pdv) + "/" + nota.getChaveAcesso());
		notaFiscal.setCpfCnpjConsumidor(nota.getCpfCnpj());
		
		List<DadosGeraisNotaVO> descricao = PdvDelegate.instance().obterDadosGeraisNota(getHotelCorrente(), nota);
		if(descricao.size() > 0){
			notaFiscal.setDadosGerais(descricao.get(0));
			notaFiscal.getDadosGerais().setContingencia(MozartUtil.getTextoSemCaracterEspecial(notaFiscal.getDadosGerais().getContingencia()));
			notaFiscal.getDadosGerais().setDescricaoNfce(MozartUtil.getTextoSemCaracterEspecial(notaFiscal.getDadosGerais().getDescricaoNfce()));
			notaFiscal.getDadosGerais().setDecricaoProtocolo(MozartUtil.getTextoSemCaracterEspecial(notaFiscal.getDadosGerais().getDecricaoProtocolo()));
		}
		
		List<DadosDescricaoVendaNotaVO> itens = PdvDelegate.instance().obterDescricaoVendaNota(getHotelCorrente(), nota);
		if(itens.size() > 0)
			notaFiscal.setDadosItens(itens);
		
		if(resumoItens.size() > 0)
			notaFiscal.setDadosResumoItensNota(resumoItens.get(0));
		
		List<DadosFormaPagamentoNotaVO> formaPagamento = PdvDelegate.instance().obterFormaPagamentoNota(getHotelCorrente(), nota);
		if(formaPagamento.size() > 0)
			notaFiscal.setDadosFormaPagamento(formaPagamento);
		
		
		this.request.setAttribute("abrirCupomFiscal", "true");
		this.request.getSession().setAttribute("notaFiscalSession", notaFiscal);
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
	}
	public String prepararCupomFiscal() {
		try {
			initCombos();
			Timestamp now = MozartUtil.now();
			List<MovimentoRestauranteEJB> listMovRest = new ArrayList<MovimentoRestauranteEJB>();

			for (Long idMovRestaurante : idMovimentosPagamento) {
				MovimentoRestauranteEJB movimento = (MovimentoRestauranteEJB) CheckinDelegate
						.instance().obter(MovimentoRestauranteEJB.class,
								idMovRestaurante);
				listMovRest.add(movimento);
			}
			
			List<MovimentoRestauranteVO> list = new ArrayList<MovimentoRestauranteVO>();
			for (MovimentoRestauranteEJB mov : listMovRest) {
				//mov.setNumNota(statusNota.getNumNota());
				//CheckinDelegate.instance().alterar(mov);
				list.add(montarMovimentoRestauranteVO(mov, mov.getPratoEJB()));
			}

			this.request.getSession().setAttribute("movPagosSession", list);
			
			this.request.setAttribute("abrirCupomFiscal", "true");
//			StatusNotaEJB notaHospedagem = (StatusNotaEJB) this.request
//					.getSession().getAttribute("notaHospedagem");
//			notaHospedagem.setObs("CUPOM FISCAL");
//			notaHospedagem.setTipoNotaFiscal("CF");
			//this.liberaGravacao = true;
			return "sucesso";
		} catch (Exception ex) {
			this.request.setAttribute("abrirCupomFiscal", "false");
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			return "sucesso";
		} finally {
			this.request.setAttribute("abrirPopupNotaHospedagem", "false");
		}
	}

	public String faturarMovimento() {
		info("Iniciando o faturamento.");
		try {
			initCombos();
			if ((this.idMovimentosRestaurante == null)
					|| (this.idMovimentosRestaurante.length == 0)) {
				addMensagemSucesso("Informe um movimento para efetuar o faturamento");
				return "sucesso";
			}
			List<MovimentoRestauranteVO> listEntidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

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

	

	public String pesquisarMovimentacao() throws MozartSessionException {

		try {
			prepararMovimentacao();

			MesaEJB mesaEJB = (MesaEJB) CheckinDelegate.instance().obter(
					MesaEJB.class, idMesa);

			garcon = mesaEJB.getIdGarcon();
			numPessoas = mesaEJB.getNumPessoas();

			percTaxaServico = mesaEJB.getPontoVenda().getPercTaxaServico() != null ? mesaEJB
					.getPontoVenda().getPercTaxaServico().toString()
					: "0,00";
			List<MovimentoRestauranteVO> entidade = new ArrayList();

			for (MovimentoRestauranteEJB mov : PdvDelegate.instance()
					.consultarMovimentacaoMesa(mesaEJB)) {

				PratoEJBPK p = new PratoEJBPK();
				p.setIdHotel(mov.getIdHotel());
				p.setIdPrato(mov.getIdPrato());
				PratoEJB prato = (PratoEJB) CheckinDelegate.instance().obter(
						PratoEJB.class, p);

				entidade.add(montarMovimentoRestauranteVO(mov, prato));

			}
			if (!entidade.isEmpty()) {
				this.request.getSession().setAttribute("entidadeSession",
						entidade);

			}
			sincronizarLancamento();
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}

		return SUCESSO_FORWARD;
	}
	
	 private static int verificadorChaveNota(String chave) {  
        int total = 0;  
        int peso = 2;  
              
        for (int i = 0; i < chave.length(); i++) {  
            total += (chave.charAt((chave.length()-1) - i) - '0') * peso;  
            peso ++;  
            if (peso == 10)  
                peso = 2;  
        }  
        int resto = total % 11;  
        return (resto == 0 || resto == 1) ? 0 : (11 - resto);  
    }
	 
	private void montaDadosImpressao(StatusNotaEJB nota) throws MozartSessionException {  
         
		String chaveNota = PdvDelegate.instance().obterChaveNota(getHotelCorrente(), nota);
		
		if(!MozartUtil.isNull(chaveNota))
			chaveNota = chaveNota + verificadorChaveNota(chaveNota);
		
		
    }

	public List<ApartamentoHospedeVO> getListApartamentoHospede() {
		return listApartamentoHospede;
	}

	public void setListApartamentoHospede(
			List<ApartamentoHospedeVO> listApartamentoHospede) {
		this.listApartamentoHospede = listApartamentoHospede;
	}

	public String getValorTaxa() {
		return valorTaxa;
	}

	public void setValorTaxa(String valorTaxa) {
		this.valorTaxa = valorTaxa;
	}

	public Long getIdRoomListDebito() {
		return idRoomListDebito;
	}

	public void setIdRoomListDebito(Long idRoomListDebito) {
		this.idRoomListDebito = idRoomListDebito;
	}

	public List<ContaCorrenteGeralVO> getListContaCorrente() {
		return listContaCorrente;
	}

	public void setListContaCorrente(List<ContaCorrenteGeralVO> listContaCorrente) {
		this.listContaCorrente = listContaCorrente;
	}

	public Long getIdContaCorrenteDebito() {
		return idContaCorrenteDebito;
	}

	public void setIdContaCorrenteDebito(Long idContaCorrenteDebito) {
		this.idContaCorrenteDebito = idContaCorrenteDebito;
	}

	public String getDataHotel() {
		return dataHotel;
	}

	public void setDataHotel(String dataHotel) {
		this.dataHotel = dataHotel;
	}
	
	public String getCpfCnpjHidden() {
		return cpfCnpjHidden;
	}

	public void setCpfCnpjHidden(String cpfCnpjHidden) {
		this.cpfCnpjHidden = cpfCnpjHidden;
	}

	public List<PontoVendaVO> getComboPontoVenda() {
		return comboPontoVenda;
	}

	public void setComboPontoVenda(List<PontoVendaVO> comboPontoVenda) {
		this.comboPontoVenda = comboPontoVenda;
	}

	public List<TipoRefeicaoEJB> getComboTipoRefeicao() {
		return comboTipoRefeicao;
	}

	public void setComboTipoRefeicao(List<TipoRefeicaoEJB> comboTipoRefeicao) {
		this.comboTipoRefeicao = comboTipoRefeicao;
	}

	public List<GarconVO> getComboGarcon() {
		return comboGarcon;
	}

	public void setComboGarcon(List<GarconVO> comboGarcon) {
		this.comboGarcon = comboGarcon;
	}

	public Long getIdApartamento() {
		return idApartamento;
	}

	public void setIdApartamento(Long idApartamento) {
		this.idApartamento = idApartamento;
	}

	public Long getIdMesa() {
		return idMesa;
	}

	public void setIdMesa(Long idMesa) {
		this.idMesa = idMesa;
	}

	public Long getGarcon() {
		return garcon;
	}

	public void setGarcon(Long garcon) {
		this.garcon = garcon;
	}

	public Long getPontoVenda() {
		return pontoVenda;
	}

	public void setPontoVenda(Long pontoVenda) {
		this.pontoVenda = pontoVenda;
	}

	public Long getTipoRefeicao() {
		return tipoRefeicao;
	}

	public void setTipoRefeicao(Long tipoRefeicao) {
		this.tipoRefeicao = tipoRefeicao;
	}

	public Long getNumPessoas() {
		return numPessoas;
	}

	public void setNumPessoas(Long numPessoas) {
		this.numPessoas = numPessoas;
	}

	public String getNumComanda() {
		return numComanda;
	}

	public void setNumComanda(String numComanda) {
		this.numComanda = numComanda;
	}

	public void setEntidade(MovimentoRestauranteEJB entidade) {
		this.entidade = entidade;
	}

	public MovimentoRestauranteEJB getEntidade() {
		return entidade;
	}

	public String getPrato() {
		return prato;
	}

	public void setPrato(String prato) {
		this.prato = prato;
	}

	public Long getQuantidade() {
		return quantidade;
	}

	public void setQuantidade(Long quantidade) {
		this.quantidade = quantidade;
	}

	public String getDesconto() {
		return desconto;
	}

	public void setDesconto(String desconto) {
		this.desconto = desconto;
	}

	public Long getIndice() {
		return indice;
	}

	public void setIndice(Long indice) {
		this.indice = indice;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Long[] getIdMovimentosRestaurante() {
		return idMovimentosRestaurante;
	}

	public void setIdMovimentosRestaurante(Long[] idMovimentosRestaurante) {
		this.idMovimentosRestaurante = idMovimentosRestaurante;
	}

	public Long getIdPrato() {
		return idPrato;
	}

	public void setIdPrato(Long idPrato) {
		this.idPrato = idPrato;
	}

	public Long getIdMovimentoExclusao() {
		return idMovimentoExclusao;
	}

	public void setIdMovimentoExclusao(Long idMovimentoExclusao) {
		this.idMovimentoExclusao = idMovimentoExclusao;
	}

	public String getPercTaxaServico() {
		return percTaxaServico;
	}

	public void setPercTaxaServico(String percTaxaServico) {
		this.percTaxaServico = percTaxaServico;
	}

	public String getValorTotal() {
		return valorTotal;
	}

	public void setValorTotal(String valorTotal) {
		this.valorTotal = valorTotal;
	}

	public List<TipoLancamentoEJB> getTipoPagamentoList() {
		return tipoPagamentoList;
	}

	public void setTipoPagamentoList(List<TipoLancamentoEJB> tipoPagamentoList) {
		this.tipoPagamentoList = tipoPagamentoList;
	}

	public Long[] getIdPgtosRestaurante() {
		return idPgtosRestaurante;
	}

	public void setIdPgtosRestaurante(Long[] idPgtosRestaurante) {
		this.idPgtosRestaurante = idPgtosRestaurante;
	}

	public Long getIdPgtoExclusao() {
		return idPgtoExclusao;
	}

	public void setIdPgtoExclusao(Long idPgtoExclusao) {
		this.idPgtoExclusao = idPgtoExclusao;
	}

	public Long getIdCheckin() {
		return idCheckin;
	}

	public void setIdCheckin(Long idCheckin) {
		this.idCheckin = idCheckin;
	}

	public Long getIdApartamentoDebito() {
		return idApartamentoDebito;
	}

	public void setIdApartamentoDebito(Long idApartamentoDebito) {
		this.idApartamentoDebito = idApartamentoDebito;
	}

	public String getValorPagamento() {
		return valorPagamento;
	}

	public void setValorPagamento(String valorPagamento) {
		this.valorPagamento = valorPagamento;
	}

	public Long getIdCheckinDebito() {
		return idCheckinDebito;
	}

	public void setIdCheckinDebito(Long idCheckinDebito) {
		this.idCheckinDebito = idCheckinDebito;
	}

	public Long getIdTipoLancamento() {
		return idTipoLancamento;
	}

	public void setIdTipoLancamento(Long idTipoLancamento) {
		this.idTipoLancamento = idTipoLancamento;
	}

	public Long getIndicePgto() {
		return indicePgto;
	}

	public void setIndicePgto(Long indicePgto) {
		this.indicePgto = indicePgto;
	}

	public Long[] getIdMovimentosPagamento() {
		return idMovimentosPagamento;
	}

	public void setIdMovimentosPagamento(Long[] idMovimentosPagamento) {
		this.idMovimentosPagamento = idMovimentosPagamento;
	}

	public String getValorPago() {
		return valorPago;
	}

	public void setValorPago(String valorPago) {
		this.valorPago = valorPago;
	}

	public String getValorSaldo() {
		return valorSaldo;
	}

	public void setValorSaldo(String valorSaldo) {
		this.valorSaldo = valorSaldo;
	}

	public Boolean isRestauranteProprio() {
		return getHotelCorrente().getIdHotel().equals(
				getHotelRestauranteCorrente().getIdHotel());
	}

	private Long getIdIdentificaLancamentoDebitado() {
		return isRestauranteProprio() ? ID_IDENTIFICA_LANCAMENTO_DEBITO_PROPRIO
				: ID_IDENTIFICA_LANCAMENTO_DEBITO_TERCEIRIZADO;
	}

	private Long getIdRedeHotelRestaurante() {
		return getHotelRestauranteCorrente().getRedeHotelEJB().getIdRedeHotel();
	}

	private Long getIdRedeHotel() {
		return getHotelCorrente().getRedeHotelEJB().getIdRedeHotel();
	}

	public String getDataRest() {
		return dataRest;
	}

	public void setDataRest(String dataRest) {
		this.dataRest = dataRest;
	}

	public String getMesa() {
		return mesa;
	}

	public void setMesa(String mesa) {
		this.mesa = mesa;
	}
	
	
}
