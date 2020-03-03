package com.mozart.web.actions;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.PostConstruct;

import com.mozart.model.delegate.AlfaDelegate;
import com.mozart.model.delegate.AuditoriaDelegate;
import com.mozart.model.delegate.CaixaGeralDelegate;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ReservaDelegate;
import com.mozart.model.ejb.entity.ApartamentoEJB;
import com.mozart.model.ejb.entity.CheckinEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.MovimentoApartamentoEJB;
import com.mozart.model.ejb.entity.MovimentoMiniPdvEJB;
import com.mozart.model.ejb.entity.PontoVendaEJB;
import com.mozart.model.ejb.entity.PontoVendaEJBPK;
import com.mozart.model.ejb.entity.PratoPontoVendaEJB;
import com.mozart.model.ejb.entity.RoomListEJB;
import com.mozart.model.ejb.entity.TipoDiariaEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CaixaGeralVO;
import com.mozart.model.vo.ContaCorrenteGeralVO;
import com.mozart.model.vo.HotelConsolidadoAlfa;
import com.mozart.web.util.MozartWebUtil;

public class ContaCorrenteGeralAction extends BaseAction {
	private static final long serialVersionUID = 2840280794966167045L;

	private static final String ABERTURA_FORWARD = "abertura";
	private static final String FECHAMENTO_FORWARD = "fechamento";
	private static final String LANCAMENTO_FORWARD = "lancamento";
	private static final String CONTRATO_FORWARD = "contrato";

	private ContaCorrenteGeralVO filtro;

	private CheckinEJB entidade;
	private ApartamentoEJB apto;

	private String tipoPesquisa;

	private Long id;

	private Long idTipoLancamento;
	
	private Long idApartamento;

	private List<CaixaGeralVO> listaApartamento;
	
	private Boolean alteracao;
	
	private String contratosLancados;
	
	private String contratosVencidos;
	
	private String contratosSemContaAberta;
	
	public ContaCorrenteGeralAction() {
		super();
	}

	@PostConstruct
	private void init() {
		filtro = new ContaCorrenteGeralVO();
		entidade = new CheckinEJB();
		apto= new ApartamentoEJB();
	}

	public String prepararAbertura() {
		this.request.getSession().removeAttribute("listaPesquisa");
		init();
		this.tipoPesquisa = "TODOS";
		return ABERTURA_FORWARD;
	}
	public String gravarAbertura() {
		info("gravar Abertura");
		try {
			entidade.setIdHotel(getHotelCorrente().getIdHotel());
			entidade.setUsuario(getUsuario());
			apto =(ApartamentoEJB) CheckinDelegate.instance().obter(ApartamentoEJB.class, apto.getIdApartamento() );
			entidade.setApartamentoEJB(apto);
			
			entidade.setCheckout("N");
			entidade.setDataEntrada(getControlaData().getFrontOffice());
			entidade.setDataSaida(MozartUtil.incrementarMes(getControlaData().getFrontOffice(), 48));
			entidade.setCredito("S");
			entidade.setCortesia("N");
			entidade.setCalculaIss("N");
			entidade.setCalculaRoomtax("N");
			entidade.setCalculaTaxa("N");

			if( MozartUtil.isNull(entidade.getIdCheckin())){
				entidade.setIdCheckin(ReservaDelegate.instance().obterNextVal());
				CheckinDelegate.instance().incluir(entidade);
				addMensagemSucesso("Conta Aberta com Sucesso.");
			}else {
				CheckinDelegate.instance().alterar(entidade);
				addMensagemSucesso("Conta Alterada com Sucesso.");
			}
			prepararInclusaoAbertura();
		}catch (Exception exc) {
			error(exc.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD;
	}

	public String pesquisarAbertura() {
		info("pesquisar conta corrente geral");
		prepararAbertura();
		try {

			this.filtro.setIdHoteis(getIdHoteis());

			List<ContaCorrenteGeralVO> listaPesquisa;
			listaPesquisa = CheckinDelegate.instance()
					.pesquisarContaCorrenteGeral(filtro);

			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}

			this.request.getSession().setAttribute("listaPesquisa",
					listaPesquisa);
		}catch (Exception exc) {
			error(exc.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}

		return ABERTURA_FORWARD;
	}

	public String prepararFechamento() {
		info("CaixaGeralAction:prepararCheckout");
		try {
			this.request.getSession().removeAttribute("checkinCorrente");
			this.request.getSession().removeAttribute("movimentoPagamentoList");
			this.request.getSession().removeAttribute("movimentosParciais");

			List<TipoLancamentoEJB> litaTipoLancamento = Collections.EMPTY_LIST;
			List<TipoDiariaEJB> tipoDiariaList = Collections.EMPTY_LIST;
			List<TipoLancamentoEJB> tipoPagamentoList = Collections.EMPTY_LIST;

			this.request.getSession().setAttribute("tipoLancamentoList",
					litaTipoLancamento);
			this.request.getSession().setAttribute("tipoDiariaList",
					tipoDiariaList);
			this.request.getSession().setAttribute("tipoPagamentoList",
					tipoPagamentoList);
			this.request.getSession().setAttribute("listaPDV",
					Collections.EMPTY_LIST);
			if (MozartUtil.isNull(this.id)) {
				throw new MozartValidateException("Selecione um apartamento.");
			}
			CheckinEJB checkinCorrente = (CheckinEJB) CheckinDelegate.instance()
					.obterCheckin(this.id);

			ApartamentoEJB apto = (ApartamentoEJB) CheckinDelegate.instance()
					.obter(ApartamentoEJB.class,
							checkinCorrente.getApartamentoEJB()
									.getIdApartamento());
			apto.setCheckout("S");
			apto.setUsuario(getUserSession().getUsuarioEJB());
			apto = (ApartamentoEJB) CheckinDelegate.instance().alterar(apto);
			checkinCorrente.setApartamentoEJB(apto);

			this.request.getSession().setAttribute("checkinCorrente",
					checkinCorrente);

			ordenarMovimentos();
			
			TipoLancamentoEJB param = new TipoLancamentoEJB();
			param.setIdHotel(getIdHoteis()[0]);

			litaTipoLancamento = CheckinDelegate.instance()
					.pesquisarSubGrupoLancamento(param);
			this.request.getSession().setAttribute("tipoLancamentoList",
					litaTipoLancamento);

			TipoDiariaEJB pTipo = new TipoDiariaEJB();
			pTipo.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());

			tipoDiariaList = CheckinDelegate.instance().pesquisarTipoDiaria(
					pTipo);
			this.request.getSession().setAttribute("tipoDiariaList",
					tipoDiariaList);

			TipoLancamentoEJB paramTipo = new TipoLancamentoEJB();
			paramTipo.setIdHotel(getIdHoteis()[0]);
			paramTipo.setGrupoLancamento("99");
			tipoPagamentoList = CheckinDelegate.instance()
					.pesquisarSubGrupoLancamento(paramTipo);
			this.request.getSession().setAttribute("tipoPagamentoList",
					tipoPagamentoList);

			this.request.setAttribute("abrirPopupCheckout", null);
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			ex.printStackTrace();
		} finally {
		}
		
		return "sucesso";
	}
	public String prepararLancamentoContrato() {
		
		try {
		
			List validacaoAuditoria = CheckinDelegate.instance()
					.obterValidacaoContrato(getHotelCorrente().getIdHotel());

			if(!MozartUtil.isNull(validacaoAuditoria)){
				contratosLancados = (String) validacaoAuditoria.get(0);
				contratosVencidos = (String) validacaoAuditoria.get(1);
				contratosSemContaAberta = (String) validacaoAuditoria.get(2);
			}
		} catch (MozartSessionException e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return CONTRATO_FORWARD;
	}

	public String pesquisarFechamento() {
		return FECHAMENTO_FORWARD;
	}

	private void ordenarMovimentos() {
		CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
				.getAttribute("checkinCorrente");
		Collections.sort(checkinCorrente.getMovimentoApartamentoEJBList(),
				MovimentoApartamentoEJB.getComparator());
		for (RoomListEJB room : checkinCorrente.getRoomListEJBList()) {
			Collections.sort(room.getMovimentoApartamentoEJBList(),
					MovimentoApartamentoEJB.getComparator());
		}
	}
	
	@SuppressWarnings("finally")
	public String prepararLancamento() {
		warn("CaixaGeralAction:preparar");
		//prepararAbertura();
		this.request.getSession().removeAttribute("listaPesquisa");
		init();
		try {
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			this.request.getSession().removeAttribute("checkinCorrente");
			if ((!isNull(checkinCorrente).booleanValue())
					&& (checkinCorrente.getApartamentoEJB() != null)
					&& ("S".equals(checkinCorrente.getApartamentoEJB()
							.getCheckout()))) {
				ApartamentoEJB apto = (ApartamentoEJB) CheckinDelegate
						.instance().obter(
								ApartamentoEJB.class,
								checkinCorrente.getApartamentoEJB()
										.getIdApartamento());
				apto.setCheckout("N");
				apto.setUsuario(getUserSession().getUsuarioEJB());
				apto = (ApartamentoEJB) CheckinDelegate.instance()
						.alterar(apto);
				checkinCorrente.setApartamentoEJB(apto);
			}
			CaixaGeralVO param = new CaixaGeralVO();
			param.setIdHotel(getHotelCorrente().getIdHotel());
			param.setCofan("N");
			if(MozartUtil.isNull(this.tipoPesquisa)){
				this.tipoPesquisa = "TODOS";
			}
			
			if ("entrada".equalsIgnoreCase(this.tipoPesquisa)) {
				param.setEntradaDia("S");
			} else if ("saida".equalsIgnoreCase(this.tipoPesquisa)) {
				param.setSaidaDia("S");
			} else if ("sujo".equalsIgnoreCase(this.tipoPesquisa)) {
				param.setStatus(";LS;OS;");
			} else if ("ocupado".equalsIgnoreCase(this.tipoPesquisa)) {
				param.setStatus(";OA;OS;");
			} else if ("livre".equalsIgnoreCase(this.tipoPesquisa)) {
				param.setStatus(";LL;LA;LS;");
			} else if ("interditado".equalsIgnoreCase(this.tipoPesquisa)) {
				param.setStatus(";IN;");
			} else if ("cofan".equalsIgnoreCase(this.tipoPesquisa)) {
				param.setCofan("S");
			} else if ("livre_livre".equalsIgnoreCase(this.tipoPesquisa)) {
				param.setStatus(";LL;");
			} else if ("CHECKOUT_AGORA".equalsIgnoreCase(this.tipoPesquisa)) {
				param.setCheckout("S");
			} else if ("apartamento".equalsIgnoreCase(this.tipoPesquisa)) {
				param.setNumApartamento(this.id);
				this.idTipoLancamento = this.id;
			}
			this.listaApartamento = CaixaGeralDelegate.instance()
					.pesquisarApartamentoComCheckinEReserva(param, false);

			param = new CaixaGeralVO();
			param.setIdHotel(getIdHoteis()[0]);
			param.setStatus(";LL;");
			param.setCofan("N");

			List<CaixaGeralVO> listaAptoLivre = Collections.emptyList();

			this.request.getSession().setAttribute("listaApartamento",
					this.listaApartamento);
			if ("TODOS".equals(this.tipoPesquisa)) {
				this.request.getSession().setAttribute("listaApartamentoGeral",
						this.listaApartamento);
			}
			this.request.getSession().setAttribute("listaAptoLivre",
					listaAptoLivre);
		} catch (MozartSessionException mox) {
			error(mox.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			return LANCAMENTO_FORWARD;
		}
		
	}

	public String pesquisarLancamento() {
		return LANCAMENTO_FORWARD;
	}

	public String prepararInclusaoAbertura() {
		try {
			alteracao=false;
			entidade = new CheckinEJB();
			apto = new ApartamentoEJB();
			this.request.getSession().removeAttribute("LIST_APTO");
			apto.setIdApartamento(idApartamento);
			ApartamentoEJB apto = new ApartamentoEJB();
			apto.setIdHotel(getHotelCorrente().getIdHotel());
			apto.setStatus("L");
		
			List<ApartamentoEJB> list = CheckinDelegate.instance().pesquisarApartamento(apto, true);
			
			this.request.getSession().setAttribute("LIST_APTO", list);
			
		} catch (MozartSessionException e) {
			addActionError("Erro de operação");
		}
		
		
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() {
		try {
			this.alteracao = true;
			this.request.getSession().removeAttribute("LIST_APTO");
			entidade = (CheckinEJB) CheckinDelegate.instance().obter(CheckinEJB.class, entidade.getIdCheckin());
			apto = entidade.getApartamentoEJB();
			ApartamentoEJB filtroApto = new ApartamentoEJB();
			filtroApto.setIdHotel(getHotelCorrente().getIdHotel());
			filtroApto.setStatus("L");
			
			List<ApartamentoEJB> list = CheckinDelegate.instance().pesquisarApartamento(filtroApto);
			
			this.request.getSession().setAttribute("LIST_APTO", list);
			
		} catch (MozartSessionException e) {
			addActionError("Erro de operação");
		}
		
		
		return SUCESSO_FORWARD;
	}

	@SuppressWarnings("finally")
	public String prepararMiniPdv() {
		warn("Preparando o mini pdv ");
		try {
			PontoVendaEJB pFiltroPDV = new PontoVendaEJB();
			pFiltroPDV.setId(new PontoVendaEJBPK());
			pFiltroPDV.getId().setIdHotel(
					getHotelCorrente().getIdHotel().longValue());
			List<PontoVendaEJB> pontoVendaList = CheckinDelegate.instance()
					.pesquisarPontoVendaByFiltro(pFiltroPDV);
			this.request.getSession().setAttribute("listaPDV", pontoVendaList);

			List<MovimentoMiniPdvEJB> listaMiniPDV = new ArrayList();
			this.request.getSession().setAttribute("movimentoMiniPDVList",
					listaMiniPDV);

			List<PratoPontoVendaEJB> pratoPDVList = Collections.emptyList();
			this.request.getSession()
					.setAttribute("pratoPDVList", pratoPDVList);

			this.request.setAttribute("PDVReadonly", "");
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			return "sucesso";
		}
	}
	
	public String lancarContrato() {
		try {
			List<CaixaGeralVO> listaAptoLivre = Collections.emptyList();

			this.request.getSession().setAttribute("listaApartamento",
					this.listaApartamento);
			if ("TODOS".equals(this.tipoPesquisa)) {
				this.request.getSession().setAttribute("listaApartamentoGeral",
						this.listaApartamento);
			}
			else{
				this.request.getSession().setAttribute("listaApartamentoGeral",
						Collections.emptyList());
			}
			
			this.request.getSession().setAttribute("listaAptoLivre",
					listaAptoLivre);
			
			ControlaDataEJB controlaData = getControlaData();
			controlaData.setUsuario(getUserSession().getUsuarioEJB());

			CheckinDelegate.instance().lancarContrato(controlaData);
			
			ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
					.obter(ControlaDataEJB.class, getHotelCorrente().getIdHotel());
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);

			addMensagemSucesso("Operação realizada com sucesso.");
			
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
		} 
		return LANCAMENTO_FORWARD;

	}
	
	public String prepararInclusaoFechamento() {
		return SUCESSO_FORWARD;
	}

	public String prepararInclusaoLancamento() {
		return SUCESSO_FORWARD;
	}

	public ContaCorrenteGeralVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ContaCorrenteGeralVO filtro) {
		this.filtro = filtro;
	}

	public CheckinEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(CheckinEJB entidade) {
		this.entidade = entidade;
	}

	public ApartamentoEJB getApto() {
		return apto;
	}

	public void setApto(ApartamentoEJB apto) {
		this.apto = apto;
	}

	public String getTipoPesquisa() {
		return tipoPesquisa;
	}

	public void setTipoPesquisa(String tipoPesquisa) {
		this.tipoPesquisa = tipoPesquisa;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdTipoLancamento() {
		return idTipoLancamento;
	}

	public void setIdTipoLancamento(Long idTipoLancamento) {
		this.idTipoLancamento = idTipoLancamento;
	}

	public List<CaixaGeralVO> getListaApartamento() {
		return listaApartamento;
	}

	public void setListaApartamento(List<CaixaGeralVO> listaApartamento) {
		this.listaApartamento = listaApartamento;
	}

	public Boolean getAlteracao() {
		return alteracao;
	}

	public void setAlteracao(Boolean alteracao) {
		this.alteracao = alteracao;
	}

	public Long getIdApartamento() {
		return idApartamento;
	}

	public void setIdApartamento(Long idApartamento) {
		this.idApartamento = idApartamento;
	}

	public String getContratosLancados() {
		return contratosLancados;
	}

	public void setContratosLancados(String contratosLancados) {
		this.contratosLancados = contratosLancados;
	}

	public String getContratosVencidos() {
		return contratosVencidos;
	}

	public void setContratosVencidos(String contratosVencidos) {
		this.contratosVencidos = contratosVencidos;
	}

	public String getContratosSemContaAberta() {
		return contratosSemContaAberta;
	}

	public void setContratosSemContaAberta(String contratosSemContaAberta) {
		this.contratosSemContaAberta = contratosSemContaAberta;
	}

}