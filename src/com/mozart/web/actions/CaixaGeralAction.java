package com.mozart.web.actions;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import com.mozart.model.delegate.BraspagDelegate;
import com.mozart.model.delegate.CaixaGeralDelegate;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.EstoqueDelegate;
import com.mozart.model.ejb.entity.ApartamentoEJB;
import com.mozart.model.ejb.entity.ApartamentoTransferidoEJB;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.CheckinEJB;
import com.mozart.model.ejb.entity.ConfigNotaEJB;
import com.mozart.model.ejb.entity.FichaTecnicaPratoEJB;
import com.mozart.model.ejb.entity.HospedeEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.IdentificaLancamentoEJB;
import com.mozart.model.ejb.entity.MovimentoApartamentoEJB;
import com.mozart.model.ejb.entity.MovimentoMiniPdvEJB;
import com.mozart.model.ejb.entity.MovimentoObjetoEJB;
import com.mozart.model.ejb.entity.PontoVendaEJB;
import com.mozart.model.ejb.entity.PontoVendaEJBPK;
import com.mozart.model.ejb.entity.PratoEJB;
import com.mozart.model.ejb.entity.PratoEJBPK;
import com.mozart.model.ejb.entity.PratoPontoVendaEJB;
import com.mozart.model.ejb.entity.RoomListEJB;
import com.mozart.model.ejb.entity.StatusNotaEJB;
import com.mozart.model.ejb.entity.TipoDiariaEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJB;
import com.mozart.model.ejb.entity.TransacaoWebEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CaixaGeralVO;
import com.mozart.model.vo.LinhaNotaFiscalVO;
import com.mozart.model.vo.MovimentoEstoqueVO;

@SuppressWarnings("unchecked")
public class CaixaGeralAction extends BaseAction {
	private static final long serialVersionUID = 8168221622319392515L;
	List<CaixaGeralVO> listaApartamento;
	private Long id;
	private String tipoPesquisa;
	private String[] movimentos;
	private String[] movimentosParcial;
	private Long idxCliente;
	private Long idTipoLancamento;
	private String numDocumento;
	private Double valorLancamento;
	private Long idTipoDiaria;
	private Double valorPagamento;
	private Double valorAdicionado;
	private String motivoCancelamentoNota;
	private Long idTipoLancamentoObj;
	private String idMovimentoObjeto;
	private Long idTipoDiaria1;
	private Long idTipoDiaria2;
	private Long idTipoLancamento1;
	private Long idTipoLancamento2;
	private String motivoCancelamentoNota1;
	private String idApartamentoDestino;
	private String motivoTransferencia;
	private Long idApartamentoDestino1;
	private String motivoTransferencia1;
	private String numCartao;
	private String validadeCartao;
	private String codigoSegurancaCartao;
	private String nomeClienteCartao;
	private String numComanda;
	private String numComanda1;
	private Long idPontoVenda;
	private Long idPontoVenda1;
	private String idPrato;
	private String idPrato1;
	private Double qtdePrato;
	private Double valorPrato;
	private Long numNotaFiscal;
	private String serieNotaFiscal;
	private String subSerieNotaFiscal;
	private boolean liberaGravacao;
	private Long idNovoRoomListPrincipal;
	private HospedeEJB idNovoHospedeSubstituicao;

	public CaixaGeralAction() {
		this.liberaGravacao = false;
	}

	public String prepararCupomFiscal() {
		try {
			prepararNotaHospedagem();
			this.request.setAttribute("abrirCupomFiscal", "true");
			StatusNotaEJB notaHospedagem = (StatusNotaEJB) this.request
					.getSession().getAttribute("notaHospedagem");
			notaHospedagem.setObs("CUPOM FISCAL");
			notaHospedagem.setTipoNotaFiscal("CF");
			this.liberaGravacao = true;
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

	public String cancelarCupomFiscal() {
		try {
			StatusNotaEJB notaHospedagem = (StatusNotaEJB) this.request
					.getSession().getAttribute("notaHospedagem");
			notaHospedagem.setObs("CANCELANDO CUPOM FISCAL");
			cancelarNotaHospedagem();
			addMensagemSucesso("Sua impressora não foi localizada, verifique a configuração");
			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String substituirHospede() {
		try {
			gravarSincronizacao();
			info("Substituindo hóspedes ");
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			RoomListEJB roomListDe = (RoomListEJB) checkinCorrente
					.getRoomListEJBList().get(this.idxCliente.intValue() - 1);
			roomListDe.setUsuario(getUserSession().getUsuarioEJB());
			this.idNovoHospedeSubstituicao.setIdRedeHotel(getHotelCorrente()
					.getRedeHotelEJB().getIdRedeHotel());
			CheckinDelegate.instance().substituirHospedeCheckin(roomListDe,
					this.idNovoHospedeSubstituicao);
			addMensagemSucesso("Operação realizada com sucesso.");
			this.id = checkinCorrente.getIdCheckin();
			prepararCheckout();
			return "sucesso";
		} catch (MozartValidateException ex) {
			removeMensagemSucesso();
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
			return "sucesso";
		} catch (Exception ex) {
			removeMensagemSucesso();
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String unificarTaxas() {
		try {
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			info("Unificando taxas do checkin: "
					+ checkinCorrente.getIdCheckin());
			checkinCorrente.setUsuario(getUserSession().getUsuarioEJB());
			CheckinDelegate.instance().unificaTaxasCheckin(checkinCorrente);
			addMensagemSucesso("Operação realizada com sucesso.");
			this.id = checkinCorrente.getIdCheckin();
			return prepararCheckout();
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String gravarMiniPDV() {
		warn("Gravar o mini pdv");
		try {
			List<MovimentoMiniPdvEJB> listaMiniPDV = (List) this.request
					.getSession().getAttribute("movimentoMiniPDVList");
			if (MozartUtil.isNull(listaMiniPDV)) {
				this.request.setAttribute("abrirPopupMiniPDV", "true");
				addMensagemErro("Não existe lançamentos para gravar.");
				return "sucesso";
			}
			PontoVendaEJB pFiltroPDV = new PontoVendaEJB();
			pFiltroPDV.setId(new PontoVendaEJBPK());
			pFiltroPDV.getId().setIdHotel(
					getHotelCorrente().getIdHotel().longValue());
			pFiltroPDV.getId().setIdPontoVenda(this.idPontoVenda);

			List<PontoVendaEJB> listaPDV = (List) this.request.getSession()
					.getAttribute("listaPDV");
			PontoVendaEJB pdv = (PontoVendaEJB) listaPDV.get(listaPDV
					.indexOf(pFiltroPDV));

			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");

			MovimentoApartamentoEJB newMovApartamento = new MovimentoApartamentoEJB();
			newMovApartamento.setCheckinEJB(checkinCorrente);

			newMovApartamento.setTipoLancamentoEJB(pdv.getTipoLancamentoEJB());
			if (this.idxCliente.intValue() == 0) {
				newMovApartamento.setQuemPaga("E");
				newMovApartamento.setRoomListEJB(checkinCorrente
						.getRoomListPrincipal());
			} else {
				newMovApartamento.setRoomListEJB((RoomListEJB) checkinCorrente
						.getRoomListEJBList().get(
								this.idxCliente.intValue() - 1));
				newMovApartamento.setQuemPaga("H");
			}
			newMovApartamento.setNumDocumento(this.numComanda);
			newMovApartamento.setDataLancamento(new Timestamp(getControlaData()
					.getFrontOffice().getTime()));
			newMovApartamento.setHoraLancamento(new Timestamp(new Date()
					.getTime()));
			newMovApartamento.setCheckout("N");
			newMovApartamento.setMovTmp("S");
			newMovApartamento.setIdRedeHotel(getHotelCorrente()
					.getRedeHotelEJB().getIdRedeHotel());

			newMovApartamento.setParcial("N");
			newMovApartamento.setIdTipoDiaria(this.idTipoDiaria);
			newMovApartamento.setValorPensao(checkinCorrente
					.getApartamentoEJB().getCofan().equals("S") ? null
					: checkinCorrente.getReservaEJB().getValorPensao());

			Double quantidade = 0.0;
			
			if(getHotelCorrente().getResumoFiscal().equals("N")) {
				Double valorLancamento = 0.0;
				newMovApartamento
						.setMovimentoMiniPdvEJBList(new ArrayList<MovimentoMiniPdvEJB>());
				for (MovimentoMiniPdvEJB lancMiniPDV : listaMiniPDV) {
					lancMiniPDV.setIdRoomList(checkinCorrente.getRoomListPrincipal().getIdRoomList());
					newMovApartamento.addMovimentoMiniPdvEJB(lancMiniPDV);
					valorLancamento += lancMiniPDV.getValorTotal();
					quantidade += lancMiniPDV.getQuantidade();
				}
	
				newMovApartamento.setValorLancamento(valorLancamento);
				newMovApartamento.setUsuario( getUserSession().getUsuarioEJB() );
				CheckinDelegate.instance().incluir(newMovApartamento);
			}
			else
			{
				for (MovimentoMiniPdvEJB lancMiniPDV : listaMiniPDV) {
					newMovApartamento.setMovimentoMiniPdvEJBList(new ArrayList<MovimentoMiniPdvEJB>());
					lancMiniPDV.setIdRoomList(checkinCorrente.getRoomListPrincipal().getIdRoomList());
					newMovApartamento.addMovimentoMiniPdvEJB(lancMiniPDV);
					Double valorLancamento = lancMiniPDV.getValorTotal();
					quantidade += lancMiniPDV.getQuantidade();
					
					newMovApartamento.setNumDocumento(this.numComanda + "-" + lancMiniPDV.getQuantidade().intValue() + "-" + lancMiniPDV.getPratoEJB().getNomePrato());
					newMovApartamento.setValorLancamento(valorLancamento);
					newMovApartamento.setUsuario( getUserSession().getUsuarioEJB() );
					
					CheckinDelegate.instance().incluir(newMovApartamento);
				}
			}
			
			CentroCustoContabilEJB centroCustoContabil = (CentroCustoContabilEJB) CheckinDelegate.instance().obter(CentroCustoContabilEJB.class, pdv.getIdCentroCustoContabil());
			
			if(centroCustoContabil != null && centroCustoContabil.getControlado().equals("S")) {
				for (MovimentoMiniPdvEJB lancMiniPDV : listaMiniPDV) {
					PratoEJB prato = (PratoEJB) CheckinDelegate.instance().obter(PratoEJB.class, lancMiniPDV.getPratoEJB().getId());
					for (FichaTecnicaPratoEJB fichaTecnicaEJB : prato.getFichaTecnicaPratoEJBList()) {
						if(fichaTecnicaEJB.getItemEstoqueEJB().getControlado().equals("S")) {
							MovimentoEstoqueVO movimentoEstoqueVO = new MovimentoEstoqueVO();
							movimentoEstoqueVO.setIdMovEstoque(EstoqueDelegate.instance().obterNextVal());
							movimentoEstoqueVO.setIdItem(fichaTecnicaEJB.getItemEstoqueEJB().getId().getIdItem());
							movimentoEstoqueVO.setIdHotel(getHotelCorrente().getIdHotel());
							movimentoEstoqueVO.setIdPontoVenda(idPontoVenda);
							movimentoEstoqueVO.setNumDocumento(this.numComanda);
							movimentoEstoqueVO.setIdCentroCusto(centroCustoContabil.getIdCentroCustoContabil());
							movimentoEstoqueVO.setDtDocumento(newMovApartamento.getDataLancamento());
							movimentoEstoqueVO.setDtMovimento(newMovApartamento.getDataLancamento());
							movimentoEstoqueVO.setDsTipoMovimento("B");
							movimentoEstoqueVO.setVlQuantidade(lancMiniPDV.getQuantidade());
							movimentoEstoqueVO.setIdRedeHotel(getHotelCorrente()
									.getRedeHotelEJB().getIdRedeHotel());
							
							if(movimentoEstoqueVO.getIdMovEstoque() != null){
								EstoqueDelegate.instance().salvarFechamentoMovimentoEstoque(movimentoEstoqueVO);
							}
						}
					}
				}
			}

			cancelarMiniPDV();
			addActionMessage("Operação realizada com sucesso.");

			checkinCorrente.setUsuario(getUserSession().getUsuarioEJB());
			CheckinDelegate.instance().unificaTaxasCheckin(checkinCorrente);
			this.id = checkinCorrente.getIdCheckin();
			
			return prepararCheckout();
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	@SuppressWarnings("finally")
	public String incluirMiniPDV() {
		warn("Incluir lancamento mini pdv ");
		try {
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");

			Long idRoomListPDV = this.idxCliente.intValue() == 0 ? checkinCorrente
					.getRoomListPrincipal().getIdRoomList()
					: ((RoomListEJB) checkinCorrente.getRoomListEJBList().get(
							this.idxCliente.intValue() - 1)).getIdRoomList();

			List<MovimentoMiniPdvEJB> listaMiniPDV = (List) this.request
					.getSession().getAttribute("movimentoMiniPDVList");

			MovimentoMiniPdvEJB novoLancamento = new MovimentoMiniPdvEJB();
			novoLancamento.setData(getControlaData().getFrontOffice());
			novoLancamento.setIdPdv(this.idPontoVenda);
			novoLancamento.setIdRoomList(idRoomListPDV);

			PratoEJBPK pkPrato = new PratoEJBPK();
			pkPrato.setIdHotel(getHotelCorrente().getIdHotel());
			pkPrato.setIdPrato(new Long(this.idPrato.trim()));

			PratoEJB prato = new PratoEJB();
			prato.setId(pkPrato);

			PratoPontoVendaEJB ppp = new PratoPontoVendaEJB();
			ppp.setPratoEJB(prato);

			List<PratoPontoVendaEJB> pratoPDVList = (List) this.request
					.getSession().getAttribute("pratoPDVList");
			prato = ((PratoPontoVendaEJB) pratoPDVList.get(pratoPDVList
					.indexOf(ppp))).getPratoEJB();
			novoLancamento.setPratoEJB(prato);
			novoLancamento.setQuantidade(this.qtdePrato);
			novoLancamento.setValorTotal(Double.valueOf(prato.getValorPrato()
					.doubleValue() * this.qtdePrato.doubleValue()));
			novoLancamento.setTipo("PRODUTO");

			listaMiniPDV.add(novoLancamento);

			this.request.setAttribute("PDVReadonly", "disabled");
			this.request.setAttribute("abrirPopupMiniPDV", "true");
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			return "sucesso";
		}
	}

	@SuppressWarnings("finally")
	public String excluirMiniPDV() {
		warn("Excluindo lancamento: " + this.id);
		try {
			List<MovimentoMiniPdvEJB> listaMiniPDV = (List) this.request
					.getSession().getAttribute("movimentoMiniPDVList");
			listaMiniPDV.remove(this.id.intValue());
			this.request.setAttribute("abrirPopupMiniPDV", "true");
			if (listaMiniPDV.isEmpty()) {
				this.request.setAttribute("PDVReadonly", "");
			} else {
				this.request.setAttribute("PDVReadonly", "disabled");
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			return "sucesso";
		}
	}

	@SuppressWarnings("finally")
	public String cancelarMiniPDV() {
		warn("Cancelando miniPDV");
		try {
			this.request.getSession().removeAttribute("movimentoMiniPDVList");
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			return "sucesso";
		}
	}

	/**
	 * @deprecated
	 */
	@SuppressWarnings("finally")
	public String pesquisarPrato() {
		warn("Pesquisando prato do PDV");
		try {
			PontoVendaEJB pFiltroPDV = new PontoVendaEJB();
			pFiltroPDV.setId(new PontoVendaEJBPK());
			pFiltroPDV.getId().setIdHotel(
					getHotelCorrente().getIdHotel().longValue());
			pFiltroPDV.getId().setIdPontoVenda(this.idPontoVenda);

			List<PontoVendaEJB> listaMiniPDV = (List) this.request.getSession()
					.getAttribute("listaPDV");

			List<PratoPontoVendaEJB> pratoPDVList = ((PontoVendaEJB) listaMiniPDV
					.get(listaMiniPDV.indexOf(pFiltroPDV)))
					.getPratoPontoVendaEJBList();
			this.request.getSession()
					.setAttribute("pratoPDVList", pratoPDVList);

			this.request.setAttribute("abrirPopupMiniPDV", "true");
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			return "sucesso";
		}
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

	public String transferirApartamento() {
		warn("Preparando a transferencia do apartamento: "
				+ this.idApartamentoDestino);
		try {
			ApartamentoTransferidoEJB apartamentoTransferido = new ApartamentoTransferidoEJB();
			apartamentoTransferido.setIdApartamentoDestino(new Long(
					this.idApartamentoDestino));
			apartamentoTransferido.setIdCheckin(this.id);
			apartamentoTransferido.setIdHotel(getHotelCorrente().getIdHotel());
			apartamentoTransferido.setMotivo(this.motivoTransferencia);

			apartamentoTransferido.setUsuario(getUserSession().getUsuarioEJB());
			CaixaGeralDelegate.instance().transferirApartamento(
					apartamentoTransferido);

			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
		}
		return prepararLancamento();
	}

	public String liberarHospede() {
		warn("Preparando a liberacao do hospede: " + this.idxCliente);
		try {
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			RoomListEJB roomList = (RoomListEJB) checkinCorrente
					.getRoomListEJBList().get(this.idxCliente.intValue() - 1);
			if (("S".equals(roomList.getPrincipal()))
					&& (MozartUtil.isNull(this.idNovoRoomListPrincipal))) {
				addMensagemErro("Você deve informar um novo hóspede principal ou liberar o apartamento.");
				return "sucesso";
			}
			if (!MozartUtil.isNull(this.idNovoRoomListPrincipal)) {
				roomList.setPrincipal("N");
				RoomListEJB roomNovoPrincipal = new RoomListEJB();
				roomNovoPrincipal.setIdRoomList(this.idNovoRoomListPrincipal);
				roomNovoPrincipal = (RoomListEJB) checkinCorrente
						.getRoomListEJBList().get(
								checkinCorrente.getRoomListEJBList().indexOf(
										roomNovoPrincipal));
				roomNovoPrincipal.setPrincipal("S");
			}
			gravarSincronizacao();
			roomList.setUsuario(getUserSession().getUsuarioEJB());
			roomList = CheckinDelegate.instance().liberarHospedeComPrincipal(
					roomList, this.idNovoRoomListPrincipal);
			this.id = checkinCorrente.getIdCheckin();
			addMensagemSucesso("Operação realizada com sucesso.");
			return prepararCheckout();
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String liberarApartamento() {
		try {
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			checkinCorrente.setUsuario(getUserSession().getUsuarioEJB());
			CheckinDelegate.instance().liberarCheckin(checkinCorrente);
			addMensagemSucesso("Operação realizada com sucesso.");
			return "pesquisa";
		} catch (MozartValidateException e) {
			error(e.getMessage());
			addMensagemErro(e.getMessage());
			return "sucesso";
		} catch (Exception e) {
			error(e.getMessage());
		}
		return "sucesso";
	}

	public String incluirMovimentoDevolucao() {
		try {
			this.request.setAttribute("abrirPopupDevolucao", "true");
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			RoomListEJB roomList = (RoomListEJB) checkinCorrente
					.getRoomListEJBList().get(this.idxCliente.intValue() - 1);
			List<MovimentoObjetoEJB> listaDevolucao = new ArrayList();
			String[] array = this.idMovimentoObjeto.split(";");
			for (int x = 0; x < array.length; x++) {
				if (!isNull(array[x]).booleanValue()) {
					MovimentoObjetoEJB mov = new MovimentoObjetoEJB();
					mov.setIdMovimentoObjeto(new Long(array[x]));
					mov = (MovimentoObjetoEJB) roomList
							.getMovimentoObjetoEJBList().get(
									roomList.getMovimentoObjetoEJBList()
											.indexOf(mov));
					listaDevolucao.add(mov);
				}
			}
			MovimentoApartamentoEJB newMovApartamento = new MovimentoApartamentoEJB();

			List<TipoLancamentoEJB> tipoLancamentoList = (List) this.request
					.getSession().getAttribute("tipoLancamentoList");

			TipoLancamentoEJB tipo = new TipoLancamentoEJB();
			tipo.setIdTipoLancamento(this.idTipoLancamento);
			tipo = (TipoLancamentoEJB) tipoLancamentoList
					.get(tipoLancamentoList.indexOf(tipo));

			newMovApartamento.setCheckinEJB(checkinCorrente);
			newMovApartamento.setTipoLancamentoEJB(tipo);
			if (this.idxCliente.intValue() == 0) {
				newMovApartamento.setQuemPaga("E");
				newMovApartamento.setRoomListEJB(checkinCorrente
						.getRoomListPrincipal());
			} else {
				newMovApartamento.setRoomListEJB((RoomListEJB) checkinCorrente
						.getRoomListEJBList().get(
								this.idxCliente.intValue() - 1));
				newMovApartamento.setQuemPaga("H");
			}
			newMovApartamento.setNumDocumento(this.numDocumento);
			newMovApartamento.setDataLancamento(new Timestamp(getControlaData()
					.getFrontOffice().getTime()));
			newMovApartamento.setHoraLancamento(new Timestamp(new Date()
					.getTime()));
			newMovApartamento.setCheckout("N");
			newMovApartamento.setMovTmp("S");
			newMovApartamento.setIdRedeHotel(getHotelCorrente()
					.getRedeHotelEJB().getIdRedeHotel());
			newMovApartamento.setValorLancamento(this.valorLancamento);
			newMovApartamento.setParcial("N");
			newMovApartamento.setIdTipoDiaria(this.idTipoDiaria);
			newMovApartamento.setValorPensao(checkinCorrente
					.getApartamentoEJB().getCofan().equals("S") ? null
					: checkinCorrente.getReservaEJB().getValorPensao());

			newMovApartamento.setUsuario(getUserSession().getUsuarioEJB());

			List<MovimentoApartamentoEJB> movimentos = CheckinDelegate
					.instance().pagarObjetos(newMovApartamento, listaDevolucao);
			info("pagando objetos: " + movimentos);
			checkinCorrente.setUsuario(getUserSession().getUsuarioEJB());
			CheckinDelegate.instance().unificaTaxasCheckin(checkinCorrente);
			this.id = checkinCorrente.getIdCheckin();
			return prepararCheckout();
		} catch (Exception e) {
			error(e.getMessage());
		}
		return "sucesso";
	}

	public String devolverObjetos() {
		warn("Devolvendo objetos");
		try {
			this.request.setAttribute("abrirPopupDevolucao", "false");
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			RoomListEJB roomList = (RoomListEJB) checkinCorrente
					.getRoomListEJBList().get(this.idxCliente.intValue() - 1);
			List<MovimentoObjetoEJB> listaDevolucao = new ArrayList();
			String[] array = this.idMovimentoObjeto.split(";");
			for (int x = 0; x < array.length; x++) {
				if (!isNull(array[x]).booleanValue()) {
					MovimentoObjetoEJB mov = new MovimentoObjetoEJB();
					mov.setIdMovimentoObjeto(new Long(array[x]));
					mov = (MovimentoObjetoEJB) roomList
							.getMovimentoObjetoEJBList().get(
									roomList.getMovimentoObjetoEJBList()
											.indexOf(mov));
					mov.setUsuario(getUserSession().getUsuarioEJB());
					listaDevolucao.add(mov);
				}
			}
			CheckinDelegate.instance().devolverObjetos(listaDevolucao);
			checkinCorrente.setUsuario(getUserSession().getUsuarioEJB());
			CheckinDelegate.instance().unificaTaxasCheckin(checkinCorrente);
			this.id = checkinCorrente.getIdCheckin();
			return prepararCheckout();
		} catch (Exception ex) {
			error(ex.getMessage());
		}
		return "sucesso";
	}

	private void cancelarNotaFiscal() throws Exception {
		StatusNotaEJB notaFiscal = (StatusNotaEJB) this.request.getSession()
				.getAttribute("notaFiscal");
		if (!MozartUtil.isNull(notaFiscal)) {
			warn("cancelando a nota fiscal");
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			notaFiscal.setIdCheckin(checkinCorrente.getIdCheckin());
			notaFiscal.setObs(this.motivoCancelamentoNota);
			notaFiscal.setStatus("NOTA CANC");
			notaFiscal.setData(new Timestamp(getControlaData().getFrontOffice()
					.getTime()));
			notaFiscal.setIdHospede(checkinCorrente.getRoomListPrincipal()
					.getHospede().getIdHospede());
			notaFiscal.setIdEmpresa(checkinCorrente.getEmpresaHotelEJB()
					.getEmpresaRedeEJB().getEmpresaEJB().getIdEmpresa());
			notaFiscal.setUsuario(getUserSession().getUsuarioEJB());
			CheckinDelegate.instance().alterar(notaFiscal);
			this.request.getSession().removeAttribute("notaFiscal");
			this.request.getSession().setAttribute("movimentoPagamentoList",
					new ArrayList());
		}
	}

	@SuppressWarnings("finally")
	public String cancelarNotaHospedagem() {
		warn("cancelando a nota de hospedagem");
		try {
			this.request.setAttribute("abrirPopupCheckout", "true");
			cancelarNotaFiscal();
			StatusNotaEJB notaHospedagem = (StatusNotaEJB) this.request
					.getSession().getAttribute("notaHospedagem");
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			notaHospedagem.setIdCheckin(checkinCorrente.getIdCheckin());
			notaHospedagem.setObs(this.motivoCancelamentoNota);
			notaHospedagem.setStatus("NOTA CANC");
			notaHospedagem.setData(new Timestamp(getControlaData()
					.getFrontOffice().getTime()));
			notaHospedagem.setTipoDocumento(new Long(1L));
			notaHospedagem.setIdHospede(checkinCorrente.getRoomListPrincipal()
					.getHospede().getIdHospede());
			notaHospedagem.setIdEmpresa(checkinCorrente.getEmpresaHotelEJB()
					.getEmpresaRedeEJB().getEmpresaEJB().getIdEmpresa());
			notaHospedagem.setUsuario(getUserSession().getUsuarioEJB());
			CheckinDelegate.instance().alterar(notaHospedagem);
			this.request.getSession().removeAttribute("notaHospedagem");
			this.request.getSession().setAttribute("movimentoPagamentoList",
					new ArrayList());
		} catch (Exception ex) {
			error(ex.getMessage());
		} finally {
			return "sucesso";
		}
	}

	public String prepararNotaFiscal() {
		try {
			prepararNotaHospedagem();
			this.liberaGravacao = false;
			StatusNotaEJB notaFiscal = (StatusNotaEJB) this.request
					.getSession().getAttribute("notaFiscal");
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");

			RoomListEJB hospede = this.idxCliente.intValue() == 0 ? checkinCorrente
					.getRoomListPrincipal() : (RoomListEJB) checkinCorrente
					.getRoomListEJBList().get(this.idxCliente.intValue() - 1);

			notaFiscal.setNumNota(this.numNotaFiscal + "");
			notaFiscal.setNotaFinal(this.numNotaFiscal);
			notaFiscal.setNotaInicial(this.numNotaFiscal);
			notaFiscal.setSerie(this.serieNotaFiscal);
			notaFiscal.setSubSerie(this.subSerieNotaFiscal);
			this.request.getSession().setAttribute("notaFiscal", notaFiscal);

			List<ConfigNotaEJB> listaConfigNota = CaixaGeralDelegate.instance()
					.obterConfiguracaoImpressoraFiscal(getIdHoteis()[0]);

			List<LinhaNotaFiscalVO> listaLinhasNota = new ArrayList();

			ConfigNotaEJB itemData = null;
			ConfigNotaEJB itemHora = null;
			ConfigNotaEJB itemDocumento = null;
			ConfigNotaEJB itemDescricao = null;
			ConfigNotaEJB itemValor = null;
			ConfigNotaEJB itemBase = null;
			ConfigNotaEJB itemIss = null;
			ConfigNotaEJB itemAliquota = null;
			ConfigNotaEJB itemTotal = null;

			String valor = "";
			for (ConfigNotaEJB configNota : listaConfigNota) {
				LinhaNotaFiscalVO linha = new LinhaNotaFiscalVO(
						Integer.valueOf(configNota.getLinha().intValue()));
				if (!listaLinhasNota.contains(linha)) {
					listaLinhasNota.add(linha);
				} else {
					linha = (LinhaNotaFiscalVO) listaLinhasNota
							.get(listaLinhasNota.indexOf(linha));
				}
				if (configNota.getId().getCampo().equals("HOSPEDE")) {
					valor = hospede.getHospede().getNomeHospede() + " "
							+ hospede.getHospede().getSobrenomeHospede();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("DATA_SAIDA")) {
					valor = MozartUtil.format(notaFiscal.getData(),
							"dd/MM/yyyy");
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("APARTAMENTO")) {
					valor = checkinCorrente.getApartamentoEJB()
							.getNumApartamento() + "";
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("HORA_SAIDA")) {
					valor = MozartUtil.format(notaFiscal.getData(), "HH:mm");
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("ESTADO")) {
					valor = getHotelCorrente().getCidadeEJB().getEstado()
							.getEstado();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo()
						.equals("INSC_MUNICIPAL")) {
					valor = getHotelCorrente().getInscMunicipal();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("LEGENDA")) {
					valor = getHotelCorrente().getNotaTermo();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("NATUREZA")) {
					valor = getHotelCorrente().getNatureza();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("MESANO")) {
					valor = MozartUtil.format(getControlaData()
							.getFrontOffice(), "MM/yyyy");
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("NUMERO_NOTA")) {
					valor = notaFiscal.getNumNota();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("RESPONSAVEL")) {
					valor = checkinCorrente.getEmpresaHotelEJB()
							.getEmpresaRedeEJB().getEmpresaEJB()
							.getRazaoSocial();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("ENDERECO")) {
					valor = checkinCorrente.getEmpresaHotelEJB()
							.getEmpresaRedeEJB().getEmpresaEJB().getEndereco();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("CEP")) {
					valor = checkinCorrente.getEmpresaHotelEJB()
							.getEmpresaRedeEJB().getEmpresaEJB().getCep();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("CIDADE")) {
					valor = checkinCorrente.getEmpresaHotelEJB()
							.getEmpresaRedeEJB().getEmpresaEJB().getCidade()
							.getCidade();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("CGC")) {
					valor = checkinCorrente.getEmpresaHotelEJB()
							.getEmpresaRedeEJB().getEmpresaEJB().getCgc();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo()
						.equals("INSC_ESTADUAL")) {
					valor = checkinCorrente.getEmpresaHotelEJB()
							.getEmpresaRedeEJB().getEmpresaEJB()
							.getInscEstadual();
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("DATA_ENTRADA")) {
					valor = MozartUtil.format(checkinCorrente.getDataEntrada(),
							"dd/MM/yyyy");
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("RESERVA")) {
					valor = checkinCorrente.getReservaEJB().getIdReserva() + "";
					linha.addColuna(configNota.getColuna(), valor);
				} else if (configNota.getId().getCampo().equals("ISS")) {
					itemIss = configNota;
				} else if (configNota.getId().getCampo().equals("BASE")) {
					itemBase = configNota;
				} else if (configNota.getId().getCampo().equals("ALIQUOTA")) {
					itemAliquota = configNota;
				} else if (configNota.getId().getCampo().equals("TOTAL")) {
					itemTotal = configNota;
				} else if (configNota.getId().getCampo().equals("NUMERO_FOLHA")) {
					valor = "1";
					linha.addColuna(configNota.getColuna(), valor);
				} else {
					if (configNota.getId().getCampo().equals("DATA")) {
						itemData = configNota;
					}
					if (configNota.getId().getCampo().equals("HORA")) {
						itemHora = configNota;
					}
					if (configNota.getId().getCampo().equals("DOCUMENTO")) {
						itemDocumento = configNota;
					}
					if (configNota.getId().getCampo().equals("DESCRICAO")) {
						itemDescricao = configNota;
					}
					if (configNota.getId().getCampo().equals("VALOR")) {
						itemValor = configNota;
					}
				}
			}
			int idxLinha = 0;
			idxLinha = itemData == null ? 0 : itemData.getLinha().intValue();
			Double valorTotal = Double.valueOf(0.0D);
			Double valorIss = Double.valueOf(0.0D);
			Double valorBase = Double.valueOf(0.0D);
			List<MovimentoApartamentoEJB> movNotaFiscal = (List) this.request
					.getSession().getAttribute("movimentoNotaHospedagem");
			for (MovimentoApartamentoEJB mov : movNotaFiscal) {
				if ("S".equals(mov.getTipoLancamentoEJB().getNotaFiscal())) {
					LinhaNotaFiscalVO linha = new LinhaNotaFiscalVO(
							Integer.valueOf(idxLinha));
					if (listaLinhasNota.contains(linha)) {
						linha = (LinhaNotaFiscalVO) listaLinhasNota
								.get(listaLinhasNota.indexOf(linha));
					}
					if (itemData != null) {
						valor = MozartUtil.format(mov.getDataLancamento(),
								"dd/MM/yyyy");
						linha.addColuna(itemData.getColuna(), valor);
					}
					if (itemDocumento != null) {
						valor = mov.getNumDocumento();
						linha.addColuna(itemDocumento.getColuna(), valor);
					}
					if (itemHora != null) {
						valor = MozartUtil.format(mov.getHoraLancamento(),
								"HH:mm");
						linha.addColuna(itemHora.getColuna(), valor);
					}
					if (itemDescricao != null) {
						valor = mov.getTipoLancamentoEJB()
								.getDescricaoLancamento();
						linha.addColuna(itemDescricao.getColuna(), valor);
					}
					if (itemValor != null) {
						valor = MozartUtil.lpad(
								MozartUtil.format(mov.getValorLancamento()),
								" ", 10);
						linha.addColuna(itemValor.getColuna(), valor);
					}
					valorTotal = Double.valueOf(valorTotal.doubleValue()
							+ mov.getValorLancamento().doubleValue());
					if ((getHotelCorrente().getIssNf() != null)
							&& (getHotelCorrente().getIssNf().doubleValue() > 0.0D)
							&& ("S".equals(mov.getTipoLancamentoEJB().getIss()))) {
						valorIss = Double.valueOf(valorIss.doubleValue()
								+ mov.getValorLancamento().doubleValue());
					}
					if ((itemBase != null)
							&& (checkinCorrente.getCalculaIss().equals("S"))
							&& ("S".equals(mov.getTipoLancamentoEJB()
									.getIssNota()))) {
						valorBase = Double.valueOf(valorBase.doubleValue()
								+ mov.getValorLancamento().doubleValue());
					}
					listaLinhasNota.add(linha);
					idxLinha++;
				}
			}
			if (itemIss != null) {
				if ((getHotelCorrente().getIssNf() != null)
						&& (getHotelCorrente().getIssNf().doubleValue() > 0.0D)) {
					valorIss = MozartUtil.round(Double.valueOf(valorIss
							.doubleValue()
							* getHotelCorrente().getIssNf().doubleValue()
							/ 100.0D));
				} else {
					valorIss = Double.valueOf(0.0D);
				}
				notaFiscal.setIss(valorIss);

				LinhaNotaFiscalVO itemRodape = (LinhaNotaFiscalVO) listaLinhasNota
						.get(listaLinhasNota.indexOf(new LinhaNotaFiscalVO(
								Integer.valueOf(itemIss.getLinha().intValue()))));
				itemRodape.addColuna(itemIss.getColuna(),
						MozartUtil.format(valorIss));
			}
			if (itemBase != null) {
				LinhaNotaFiscalVO itemRodape = (LinhaNotaFiscalVO) listaLinhasNota
						.get(listaLinhasNota
								.indexOf(new LinhaNotaFiscalVO(
										Integer.valueOf(itemBase.getLinha()
												.intValue()))));
				itemRodape.addColuna(itemBase.getColuna(), MozartUtil
						.format(MozartUtil.round(Double.valueOf(valorBase
								.doubleValue()
								* (1.0D + getHotelCorrente().getIss()
										.doubleValue() / 100.0D)))));
				notaFiscal.setBaseCalculo(MozartUtil.round(Double
						.valueOf(valorBase.doubleValue()
								* (1.0D + getHotelCorrente().getIss()
										.doubleValue() / 100.0D))));
			}
			if (itemAliquota != null) {
				LinhaNotaFiscalVO itemRodape = (LinhaNotaFiscalVO) listaLinhasNota
						.get(listaLinhasNota.indexOf(new LinhaNotaFiscalVO(
								Integer.valueOf(itemAliquota.getLinha()
										.intValue()))));
				itemRodape.addColuna(itemAliquota.getColuna(), "0,00");
				notaFiscal.setAliquotaIss(new Double(0.0D));
			}
			if (itemTotal != null) {
				LinhaNotaFiscalVO itemRodape = (LinhaNotaFiscalVO) listaLinhasNota
						.get(listaLinhasNota.indexOf(new LinhaNotaFiscalVO(
								Integer.valueOf(itemTotal.getLinha().intValue()))));
				itemRodape.addColuna(itemTotal.getColuna(),
						MozartUtil.format(valorTotal));

				notaFiscal.setValorNota(valorTotal);
			}
			Collections.sort(listaLinhasNota, new Comparator() {
				public int compare(Object o1, Object o2) {
					return ((LinhaNotaFiscalVO) o1).getIndice().compareTo(
							((LinhaNotaFiscalVO) o2).getIndice());
				}
			});
			StringBuilder conteudoNotaFiscal = new StringBuilder();

			int ultimaLinha = ((LinhaNotaFiscalVO) listaLinhasNota
					.get(listaLinhasNota.size() - 1)).getIndice().intValue();
			for (int x = 1; x <= ultimaLinha; x++) {
				LinhaNotaFiscalVO item = new LinhaNotaFiscalVO(
						Integer.valueOf(x));
				if (listaLinhasNota.contains(item)) {
					item = (LinhaNotaFiscalVO) listaLinhasNota
							.get(listaLinhasNota.indexOf(item));
					conteudoNotaFiscal.append(item.getConteudo() + " \n");
				} else {
					conteudoNotaFiscal.append(" \n");
				}
			}
			String conteudo = conteudoNotaFiscal.toString();
			this.request.setAttribute("conteudoNotaFiscal", conteudo);
			this.request.setAttribute("abrirPopupNotaFiscal", "true");
			this.request.setAttribute("abrirPopupNotaHospedagem", "false");
			this.liberaGravacao = true;
		} catch (Exception ex) {
			this.request.setAttribute("abrirPopupNotaHospedagem", "false");
			this.request.setAttribute("abrirPopupNotaFiscal", "false");
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
			try {
				cancelarNotaFiscal();
			} catch (Exception exz) {
				error("Cancelando nota fiscal:   " + exz.getMessage());
			}
		}
		return "sucesso";
	}

	public String prepararNotaHospedagem() {
		try {
			this.liberaGravacao = false;
			String movs = (String) this.request.getSession().getAttribute(
					"movimentosParciais");

			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");

			List<MovimentoApartamentoEJB> movimentoNotaHospedagem = new ArrayList();

			TipoLancamentoEJB iss = new TipoLancamentoEJB();
			iss.setIdHotel(getIdHoteis()[0]);
			iss.getIdentificaLancamento().setIdIdentificaLancamento(13L);
			iss.setSubGrupoLancamento("001");

			List<TipoLancamentoEJB> result = CheckinDelegate.instance()
					.pesquisarTipoLancamentoByFiltro(iss);
			if (MozartUtil.isNull(result)) {
				iss = null;
			} else {
				iss = (TipoLancamentoEJB) result.get(0);
			}
			TipoLancamentoEJB taxa = new TipoLancamentoEJB();
			taxa.setIdHotel(getIdHoteis()[0]);
			taxa.getIdentificaLancamento().setIdIdentificaLancamento(11L);
			taxa.setSubGrupoLancamento("001");

			result = CheckinDelegate.instance()
					.pesquisarTipoLancamentoByFiltro(taxa);
			if (MozartUtil.isNull(result)) {
				taxa = null;
			} else {
				taxa = (TipoLancamentoEJB) result.get(0);
			}
			String[] movimentos = movs.split(";");
			MovimentoApartamentoEJB movimentoInicialISS = null;
			MovimentoApartamentoEJB movimentoInicialTaxa = null;
			for (int x = 0; x < movimentos.length; x++) {
				MovimentoApartamentoEJB mov = new MovimentoApartamentoEJB();
				mov.setIdMovimentoApartamento(new Long(movimentos[x]));
				mov = (MovimentoApartamentoEJB) checkinCorrente
						.getMovimentoApartamentoEJBList().get(
								checkinCorrente
										.getMovimentoApartamentoEJBList()
										.indexOf(mov));
				movimentoNotaHospedagem.add(mov);
				if ((iss != null)
						&& (getHotelCorrente().getTaxaCheckout().equals("S"))
						&& (getHotelCorrente().getIss().doubleValue() > 0.0D)
						&& ("S".equals(checkinCorrente.getCalculaIss()))
						&& ("S".equals(mov.getTipoLancamentoEJB().getIss()))) {
					if (movimentoInicialISS == null) {
						movimentoInicialISS = new MovimentoApartamentoEJB();
						movimentoInicialISS.setTipoLancamentoEJB(iss);
						movimentoInicialISS.setNumDocumento("ISS");
						movimentoInicialISS.setDataLancamento(new Timestamp(
								getControlaData().getFrontOffice().getTime()));
						movimentoInicialISS.setHoraLancamento(new Timestamp(
								new Date().getTime()));
						movimentoNotaHospedagem.add(movimentoInicialISS);
						movimentoInicialISS.setCheckout("N");
						movimentoInicialISS.setMovTmp("S");
						movimentoInicialISS.setParcial("N");
						movimentoInicialISS
								.setValorLancamento(new Double(0.0D));
					}
					movimentoInicialISS.setValorLancamento(Double
							.valueOf(movimentoInicialISS.getValorLancamento()
									.doubleValue()
									+ mov.getValorLancamento().doubleValue()));
				}
				if ((taxa != null)
						&& ("S".equals(getHotelCorrente().getTaxaCheckout()))
						&& ("S".equals(checkinCorrente.getCalculaTaxa()))
						&& ("S".equals(mov.getTipoLancamentoEJB()
								.getTaxaServico()))) {
					if (movimentoInicialTaxa == null) {
						movimentoInicialTaxa = new MovimentoApartamentoEJB();
						movimentoInicialTaxa.setTipoLancamentoEJB(taxa);
						movimentoInicialTaxa.setNumDocumento("TAXA");
						movimentoInicialTaxa.setDataLancamento(new Timestamp(
								getControlaData().getFrontOffice().getTime()));
						movimentoInicialTaxa.setHoraLancamento(new Timestamp(
								new Date().getTime()));
						movimentoInicialTaxa.setCheckout("N");
						movimentoInicialTaxa.setMovTmp("S");
						movimentoInicialTaxa.setParcial("N");
						movimentoInicialTaxa
								.setValorLancamento(new Double(0.0D));
						movimentoNotaHospedagem.add(movimentoInicialTaxa);
					}
					movimentoInicialTaxa.setValorLancamento(Double
							.valueOf(movimentoInicialTaxa.getValorLancamento()
									.doubleValue()
									+ mov.getValorLancamento().doubleValue()));
				}
			}
			if (movimentoInicialISS != null) {
				movimentoInicialISS.setValorLancamento(MozartUtil.round(Double
						.valueOf(movimentoInicialISS.getValorLancamento()
								.doubleValue()
								* getHotelCorrente().getIss().doubleValue()
								/ 100.0D)));
			}
			if (movimentoInicialTaxa != null) {
				movimentoInicialTaxa.setValorLancamento(MozartUtil.round(Double
						.valueOf(movimentoInicialTaxa.getValorLancamento()
								.doubleValue()
								* getHotelCorrente().getTaxaServico()
										.doubleValue() / 100.0D)));
			}
			Collections.sort(movimentoNotaHospedagem,
					MovimentoApartamentoEJB.getComparator());
			this.request.getSession().setAttribute("movimentoNotaHospedagem",
					movimentoNotaHospedagem);
			this.request.setAttribute("abrirPopupNotaHospedagem", "true");
			if (isNull(this.request.getSession().getAttribute("notaHospedagem"))
					.booleanValue()) {
				HotelEJB pHotel = getHotelCorrente();
				pHotel.setUsuario(getUserSession().getUsuarioEJB());
				StatusNotaEJB notaHospedagem = CheckinDelegate.instance()
						.obterProximaNotaHospedagem(pHotel, "F");

				this.request.getSession().setAttribute("notaHospedagem",
						notaHospedagem);
			}
			this.liberaGravacao = true;
		} catch (Exception ex) {
			this.request.setAttribute("abrirPopupNotaHospedagem", "false");
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String excluirPagamentoCheckout() {
		info("Excluindo o pagamento: " + this.id);
		this.request.setAttribute("abrirPopupCheckout", "true");

		List<MovimentoApartamentoEJB> movimentoPagamentoList = (List) this.request
				.getSession().getAttribute("movimentoPagamentoList");
		MovimentoApartamentoEJB mov = (MovimentoApartamentoEJB) movimentoPagamentoList
				.remove(this.id.intValue());
		this.valorAdicionado = Double.valueOf(this.valorAdicionado
				.doubleValue() + mov.getValorLancamento().doubleValue());

		this.valorAdicionado = MozartUtil.round(this.valorAdicionado);

		return "sucesso";
	}

	public String adicionarPagamentoCheckout() {
		try {
			info("Adicionando pagamento:adicionarPagamentoCheckout");
			this.request.setAttribute("abrirPopupCheckout", "true");

			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			List<MovimentoApartamentoEJB> movimentoPagamentoList = (List) this.request
					.getSession().getAttribute("movimentoPagamentoList");
			MovimentoApartamentoEJB newMovApartamento = new MovimentoApartamentoEJB();

			List<TipoLancamentoEJB> tipoLancamentoList = (List) this.request
					.getSession().getAttribute("tipoPagamentoList");

			TipoLancamentoEJB tipo = new TipoLancamentoEJB();
			tipo.setIdTipoLancamento(this.idTipoLancamento);
			tipo = (TipoLancamentoEJB) tipoLancamentoList
					.get(tipoLancamentoList.indexOf(tipo));
			if (("N".equals(checkinCorrente.getEmpresaHotelEJB()
					.getEmpresaRedeEJB().getCredito()))
					&& (new Long(18L).equals(tipo.getIdentificaLancamento()
							.getIdIdentificaLancamento()))) {
				addMensagemErro("Não é permitido faturar para uma empresa SEM crédito.");
				return "sucesso";
			}
			newMovApartamento.setTipoLancamentoEJB(tipo);
			if (this.idxCliente.intValue() == 0) {
				newMovApartamento.setQuemPaga("E");
				newMovApartamento.setRoomListEJB(checkinCorrente
						.getRoomListPrincipal());
			} else {
				newMovApartamento.setRoomListEJB((RoomListEJB) checkinCorrente
						.getRoomListEJBList().get(
								this.idxCliente.intValue() - 1));
				newMovApartamento.setQuemPaga("H");
			}
			newMovApartamento.setNumDocumento(this.numDocumento);
			newMovApartamento.setDataLancamento(new Timestamp(getControlaData()
					.getFrontOffice().getTime()));
			newMovApartamento.setHoraLancamento(new Timestamp(new Date()
					.getTime()));
			newMovApartamento.setCheckout("S");
			newMovApartamento.setMovTmp("N");
			newMovApartamento.setIdRedeHotel(getHotelCorrente()
					.getRedeHotelEJB().getIdRedeHotel());
			newMovApartamento.setValorLancamento(Double
					.valueOf(this.valorLancamento.doubleValue() * -1.0D));
			newMovApartamento.setParcial("N");

			newMovApartamento.setValorPensao(checkinCorrente
					.getApartamentoEJB().getCofan().equals("S") ? null 
					: MozartUtil.isNull(checkinCorrente.getReservaEJB())? null
					: checkinCorrente.getReservaEJB().getValorPensao());
			if (!MozartUtil.isNull(tipo.getCodTransacaoWeb())) {
				TransacaoWebEJB novaTransacao = new TransacaoWebEJB();
				novaTransacao.setIdCheckin(checkinCorrente.getIdCheckin());
				novaTransacao.setTipoLancamentoEJB(tipo);
				novaTransacao.setNomeCartao(this.nomeClienteCartao);
				novaTransacao.setNumeroCartao(this.numCartao);
				novaTransacao.setValidade(this.validadeCartao);
				novaTransacao.setCodSeguranca(this.codigoSegurancaCartao);
				novaTransacao.setUsuario(getUsuario());
				novaTransacao.setHotelEJB(getHotelCorrente());
				novaTransacao.setValorTransacao(Double
						.valueOf(newMovApartamento.getValorLancamento()
								.doubleValue() < 0.0D ? newMovApartamento
								.getValorLancamento().doubleValue() * -1.0D
								: newMovApartamento.getValorLancamento()
										.doubleValue()));
				novaTransacao = BraspagDelegate.instance()
						.realizarTransacaoWeb(novaTransacao);

				newMovApartamento.setIdTransacaoWeb(novaTransacao
						.getIdTransacaoWeb());
				addMensagemSucesso("Operação realizada com sucesso.");
			}
			newMovApartamento.setCheckinEJB(checkinCorrente);
			movimentoPagamentoList.add(newMovApartamento);

			this.valorAdicionado = Double.valueOf(this.valorAdicionado
					.doubleValue() + this.valorLancamento.doubleValue());
			this.valorAdicionado = MozartUtil.round(this.valorAdicionado);

			sincronizarLancamentos();
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
		} catch (MozartSessionException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararPopCheckout() {
		info("Preparando o checkout: " + this.idxCliente);
		try {
			if ((this.movimentosParcial == null)
					|| (isNull(this.movimentosParcial[this.idxCliente
							.intValue()]).booleanValue())) {
				throw new MozartValidateException(
						"Selecione pelo menos uma despesa.");
			}
			this.request.getSession().setAttribute("movimentosParciais",
					this.movimentosParcial[this.idxCliente.intValue()]);

			sincronizarLancamentos();
			ordenarMovimentos();

			this.valorAdicionado = Double.valueOf(0.0D);

			this.request.setAttribute("abrirPopupCheckout", "true");

			List<MovimentoApartamentoEJB> movimentoPagamentoList = new ArrayList();
			this.request.getSession().setAttribute("movimentoPagamentoList",
					movimentoPagamentoList);
			this.request.getSession()
					.removeAttribute("movimentoNotaHospedagem");
			this.request.getSession().removeAttribute("notaHospedagem");
			this.request.getSession().removeAttribute("notaFiscal");
		} catch (MozartValidateException ex) {
			addMensagemSucesso(ex.getMessage());
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		} finally {
		}
		return "sucesso";
	}

	public String gravarSincronizacao() {
		info("CaixaGeralAction:gravarSincronizacao");
		try {
			sincronizarLancamentos();
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			checkinCorrente.setUsuario(getUserSession().getUsuarioEJB());
			checkinCorrente = CheckinDelegate.instance().gravarCheckout(
					checkinCorrente);
			CheckinDelegate.instance().unificaTaxasCheckin(checkinCorrente);
			ordenarMovimentos();
			this.request.getSession().setAttribute("checkinCorrente",
					checkinCorrente);
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			addMensagemErro(ex.getMessage());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
		}
		return "sucesso";
	}
	public String gravarCheckoutContaCorrente() {
		prepararNotaHospedagem();
		return gravarCheckout();
	}
	public String gravarCheckout() {
		info("CaixaGeralAction:gravarCheckout de: " + this.idxCliente);
		try {
			List<MovimentoApartamentoEJB> movimentoPagamentoList = (List) this.request
					.getSession().getAttribute("movimentoPagamentoList");

			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");

			String movimentosParciais = (String) this.request.getSession()
					.getAttribute("movimentosParciais");
			if (!isNull(movimentosParciais).booleanValue()) {
				StatusNotaEJB notaHospedagem = (StatusNotaEJB) this.request
						.getSession().getAttribute("notaHospedagem");

				StatusNotaEJB notaFiscal = (StatusNotaEJB) this.request
						.getSession().getAttribute("notaFiscal");
				if (!isNull(notaHospedagem).booleanValue()) {
					notaHospedagem.setIdCheckin(checkinCorrente.getIdCheckin());
				}
				if (!isNull(notaFiscal).booleanValue()) {
					notaFiscal.setIdCheckin(checkinCorrente.getIdCheckin());
				}
				String[] ids = movimentosParciais.split(";");
				TipoLancamentoEJB tipoLancamento11 = new TipoLancamentoEJB();
				tipoLancamento11.setIdHotel(getIdHoteis()[0]);
				tipoLancamento11.getIdentificaLancamento()
						.setIdIdentificaLancamento(11L);
				tipoLancamento11.setSubGrupoLancamento("001");
				List<TipoLancamentoEJB> result = CheckinDelegate.instance()
						.pesquisarTipoLancamentoByFiltro(tipoLancamento11);
				if (MozartUtil.isNull(result)) {
					tipoLancamento11 = null;
				} else {
					tipoLancamento11 = (TipoLancamentoEJB) result.get(0);
				}
				TipoLancamentoEJB tipoLancamento13 = new TipoLancamentoEJB();
				tipoLancamento13.setIdHotel(getIdHoteis()[0]);
				tipoLancamento13.getIdentificaLancamento()
						.setIdIdentificaLancamento(13L);
				tipoLancamento13.setSubGrupoLancamento("001");
				result = CheckinDelegate.instance()
						.pesquisarTipoLancamentoByFiltro(tipoLancamento13);
				if (MozartUtil.isNull(result)) {
					tipoLancamento13 = null;
				} else {
					tipoLancamento13 = (TipoLancamentoEJB) result.get(0);
				}

				MovimentoApartamentoEJB movimentoInicialISS = null;
				MovimentoApartamentoEJB movimentoInicialTaxa = null;
				String id;
				for (int x = 0; x < ids.length; x++) {
					id = ids[x];
					if (!isNull(id).booleanValue()) {
						MovimentoApartamentoEJB mov = new MovimentoApartamentoEJB();
						mov.setIdMovimentoApartamento(new Long(id));
						mov =

						(MovimentoApartamentoEJB) checkinCorrente
								.getMovimentoApartamentoEJBList()
								.get(checkinCorrente
										.getMovimentoApartamentoEJBList()
										.indexOf(mov));
						mov.setCheckout("N");
						mov.setIdTipoDiaria(checkinCorrente.getApartamentoEJB()
								.getCofan().equals("S") ? null
								: MozartUtil.isNull(checkinCorrente.getReservaApartamentoEJB())
								? null
								: checkinCorrente.getReservaApartamentoEJB()
										.getIdTipoDiaria());
						mov.setMovTmp("N");
						mov.setStatusNotaEJB(notaHospedagem);
						mov.setStatusNotaFiscalEJB(notaFiscal);
						if ("S".equals(getHotelCorrente().getTaxaCheckout())) {
							if ((getHotelCorrente().getTaxaCheckout()
									.equals("S"))
									&& (getHotelCorrente().getIss()
											.doubleValue() > 0.0D)
									&& ("S".equals(checkinCorrente
											.getCalculaIss()))
									&& ("S".equals(mov.getTipoLancamentoEJB()
											.getIss()))) {
								
								if (movimentoInicialISS == null ) {
									movimentoInicialISS = new MovimentoApartamentoEJB();
									movimentoInicialISS
											.setIdRedeHotel(getHotelCorrente()
													.getRedeHotelEJB()
													.getIdRedeHotel());
									if(!MozartUtil.isNull( mov.getRoomListEJB())){
										movimentoInicialISS
											.setRoomListEJB((RoomListEJB) checkinCorrente
													.getRoomListEJBList()
													.get(checkinCorrente
															.getRoomListEJBList()
															.indexOf(
																	mov.getRoomListEJB())));
									}
									movimentoInicialISS
											.setCheckinEJB(checkinCorrente);

									movimentoInicialISS
											.setTipoLancamentoEJB(tipoLancamento13);

									movimentoInicialISS.setNumDocumento("ISS");
									movimentoInicialISS
											.setDataLancamento(new Timestamp(
													getControlaData()
															.getFrontOffice()
															.getTime()));
									movimentoInicialISS
											.setHoraLancamento(new Timestamp(
													new Date().getTime()));
									movimentoInicialISS.setQuemPaga(mov
											.getQuemPaga());
									movimentoInicialISS.setCheckout("N");
									movimentoInicialISS.setMovTmp("N");
									movimentoInicialISS.setParcial("N");
									movimentoInicialISS
											.setIdTipoDiaria(checkinCorrente
													.getApartamentoEJB()
													.getCofan().equals("S") ? null
													: MozartUtil.isNull(checkinCorrente
															.getReservaApartamentoEJB())
													? null
													: checkinCorrente
															.getReservaApartamentoEJB()
															.getIdTipoDiaria());
									movimentoInicialISS
											.setStatusNotaEJB(notaHospedagem);
									movimentoInicialISS
											.setStatusNotaFiscalEJB(notaFiscal);
									movimentoInicialISS
											.setValorLancamento(new Double(0.0D));
									movimentoPagamentoList
											.add(movimentoInicialISS);
								} 
								
								movimentoInicialISS.setValorLancamento(Double
										.valueOf(movimentoInicialISS
												.getValorLancamento()
												.doubleValue()
												+ mov.getValorLancamento()
														.doubleValue()));
								
							}
							if ((tipoLancamento11 != null)
									&& ("S".equals(checkinCorrente
											.getCalculaTaxa()))
									&& ("S".equals(mov.getTipoLancamentoEJB()
											.getTaxaServico()))) {
								if (movimentoInicialTaxa == null) {
									movimentoInicialTaxa = new MovimentoApartamentoEJB();
									movimentoInicialTaxa
											.setIdRedeHotel(getHotelCorrente()
													.getRedeHotelEJB()
													.getIdRedeHotel());

									movimentoInicialTaxa
											.setRoomListEJB((RoomListEJB) checkinCorrente
													.getRoomListEJBList()
													.get(checkinCorrente
															.getRoomListEJBList()
															.indexOf(
																	mov.getRoomListEJB())));

									movimentoInicialTaxa
											.setCheckinEJB(checkinCorrente);
									movimentoInicialTaxa
											.setTipoLancamentoEJB(tipoLancamento11);
									movimentoInicialTaxa
											.setNumDocumento("TAXA");
									movimentoInicialTaxa
											.setDataLancamento(new Timestamp(

											getControlaData().getFrontOffice()
													.getTime()));
									movimentoInicialTaxa
											.setHoraLancamento(new Timestamp(
													new Date().getTime()));
									movimentoInicialTaxa.setQuemPaga(mov
											.getQuemPaga());
									movimentoInicialTaxa.setCheckout("N");
									movimentoInicialTaxa.setMovTmp("N");
									movimentoInicialTaxa.setParcial("N");
									movimentoInicialTaxa
											.setIdTipoDiaria(checkinCorrente
													.getApartamentoEJB()
													.getCofan().equals("S") ? null
													: checkinCorrente
															.getReservaApartamentoEJB()
															.getIdTipoDiaria());
									movimentoInicialTaxa
											.setStatusNotaEJB(notaHospedagem);
									movimentoInicialTaxa
											.setStatusNotaFiscalEJB(notaFiscal);
									movimentoInicialTaxa
											.setValorLancamento(new Double(0.0D));
									movimentoPagamentoList
											.add(movimentoInicialTaxa);
								}
								movimentoInicialTaxa.setValorLancamento(Double
										.valueOf(movimentoInicialTaxa
												.getValorLancamento()
												.doubleValue()
												+ mov.getValorLancamento()
														.doubleValue()));
							}
						}
					}
				}
				if (movimentoInicialISS != null) {
					movimentoInicialISS.setValorLancamento(MozartUtil
							.round(Double.valueOf(movimentoInicialISS
									.getValorLancamento().doubleValue()
									* getHotelCorrente().getIss().doubleValue()
									/ 100.0D)));
				}
				if (movimentoInicialTaxa != null) {
					movimentoInicialTaxa.setValorLancamento(MozartUtil
							.round(Double.valueOf(movimentoInicialTaxa
									.getValorLancamento().doubleValue()
									* getHotelCorrente().getTaxaServico()
											.doubleValue() / 100.0D)));
				}
				if (!isNull(notaHospedagem).booleanValue()) {
					for (MovimentoApartamentoEJB movPgto : movimentoPagamentoList) {
						movPgto.setStatusNotaEJB(notaHospedagem);
						movPgto.setStatusNotaFiscalEJB(notaFiscal);
					}
					if ("CF".equals(notaHospedagem.getTipoNotaFiscal())) {
						this.request.setAttribute("finalizarCupomFiscal",
								"true");
						this.request.getSession().setAttribute(
								"movimentoPagamentoCupomList",
								movimentoPagamentoList);
					}
				}
			}
			checkinCorrente.getMovimentoApartamentoEJBList().addAll(
					movimentoPagamentoList);
			checkinCorrente.setUsuario(getUserSession().getUsuarioEJB());
			this.id = checkinCorrente.getIdCheckin();
			checkinCorrente = CheckinDelegate.instance().gravarCheckout(
					checkinCorrente);

			Double baseCalculo = new Double(0);
			StatusNotaEJB sn = (StatusNotaEJB) this.request.getSession()
					.getAttribute("notaHospedagem");
			for (MovimentoApartamentoEJB ma : checkinCorrente
					.getMovimentoApartamentoEJBList()) {
				TipoLancamentoEJB tpl = ma.getTipoLancamentoEJB();
				if (!isNull(ma.getStatusNotaEJB())
						&& sn.getIdNota().equals(
								ma.getStatusNotaEJB().getIdNota())) {
					if (!isNull(tpl) && "S".equals(tpl.getIssNota())) {
						IdentificaLancamentoEJB il = tpl
								.getIdentificaLancamento();

						if (!isNull(il) && "1".equals(il.getReceitaCheckout())) {

							baseCalculo += ma.getValorLancamento();
						}
					}
				}
			}
			if (baseCalculo.doubleValue() > 0) {
				sn.setTipoNota("F");
				sn.setHotel(getHotelCorrente());
				sn = CheckinDelegate.instance().atualizarDadosRPS(sn);
				
				this.request.setAttribute("abrirRPS", "S".equals(getHotelCorrente().getRps()));
				this.request.setAttribute("data",
						MozartUtil.format(sn.getData()));
				this.request.setAttribute("idNota", sn.getIdNota());
			}

			this.request.getSession().setAttribute("checkinCorrente",
					checkinCorrente);

			addMensagemSucesso("Operação realizada com sucesso.");
			return prepararCheckout();
		} catch (MozartValidateException ex) {
			this.motivoCancelamentoNota = "ERRO FAT";
			cancelarNotaHospedagem();
			prepararCheckout();
			addMensagemErro(ex.getMessage());
			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String incluirMovimento() {
		info("CaixaGeralAction:incluirMovimento");
		try {
			sincronizarLancamentos();

			warn("Id cliente:" + this.idxCliente);
			warn("Tipo lancamento:" + this.idTipoLancamento);
			warn("Num Documento:" + this.numDocumento);
			warn("Valor:" + this.valorLancamento);
			warn("Tipo Diaria:" + this.idTipoDiaria);

			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			MovimentoApartamentoEJB newMovApartamento = new MovimentoApartamentoEJB();

			List<TipoLancamentoEJB> tipoLancamentoList = (List) this.request
					.getSession().getAttribute("tipoLancamentoList");

			TipoLancamentoEJB tipo = new TipoLancamentoEJB();
			tipo.setIdTipoLancamento(this.idTipoLancamento);
			tipo = (TipoLancamentoEJB) tipoLancamentoList
					.get(tipoLancamentoList.indexOf(tipo));
			if ((this.valorLancamento.doubleValue() < 0.0D)
					&& (!super.getUserSession().getUsuarioEJB().getNivel()
							.equals(new Long(3L)))) {
				if (!super.getUserSession().getUsuarioEJB().getNivel()
						.equals(new Long(5L))) {
					addMensagemErro("Você não tem permissão, para fazer esse lançamento.");
					return "sucesso";
				}
			}
			if ("C".equals(tipo.getDebitoCredito())) {
				this.valorLancamento = Double.valueOf(this.valorLancamento
						.doubleValue() * -1.0D);
			}
			if ((this.valorLancamento.doubleValue() < 0.0D)
					&& (!super.getUserSession().getUsuarioEJB().getNivel()
							.equals(new Long(3L)))) {
				if (!super.getUserSession().getUsuarioEJB().getNivel()
						.equals(new Long(5L))) {
					addMensagemErro("Você não tem permissão, para fazer esse lançamento.");
					return "sucesso";
				}
			}
			newMovApartamento.setCheckinEJB(checkinCorrente);
			newMovApartamento.setTipoLancamentoEJB(tipo);
			if (this.idxCliente.intValue() == 0) {
				newMovApartamento.setQuemPaga("E");
				newMovApartamento.setRoomListEJB(checkinCorrente
						.getRoomListPrincipal());
			} else {
				newMovApartamento.setRoomListEJB((RoomListEJB) checkinCorrente
						.getRoomListEJBList().get(
								this.idxCliente.intValue() - 1));
				newMovApartamento.setQuemPaga("H");
			}
			newMovApartamento.setNumDocumento(this.numDocumento);
			newMovApartamento.setDataLancamento(new Timestamp(getControlaData()
					.getFrontOffice().getTime()));
			newMovApartamento.setHoraLancamento(new Timestamp(new Date()
					.getTime()));
			newMovApartamento.setCheckout("N");
			newMovApartamento.setMovTmp("S");
			newMovApartamento.setIdRedeHotel(getHotelCorrente()
					.getRedeHotelEJB().getIdRedeHotel());
			newMovApartamento.setValorLancamento(this.valorLancamento);
			newMovApartamento.setParcial("N");
			newMovApartamento.setIdTipoDiaria(this.idTipoDiaria);
			newMovApartamento.setValorPensao(checkinCorrente
					.getApartamentoEJB().getCofan().equals("S") ? null
					: MozartUtil.isNull(checkinCorrente.getReservaEJB())? null
						: checkinCorrente.getReservaEJB().getValorPensao());

			StatusNotaEJB notaPagamento = null;
			if ("2".equals(newMovApartamento.getTipoLancamentoEJB()
					.getIdentificaLancamento().getReceitaCheckout())) {
				HotelEJB pHotel = getHotelCorrente();
				pHotel.setUsuario(getUserSession().getUsuarioEJB());

				notaPagamento = CheckinDelegate.instance()
						.obterProximaNotaHospedagem(pHotel, "F");
				notaPagamento.setIdCheckin(checkinCorrente.getIdCheckin());
				notaPagamento.setUsuario(getUserSession().getUsuarioEJB());
				notaPagamento = (StatusNotaEJB) CheckinDelegate.instance()
						.alterar(notaPagamento);

				newMovApartamento.setStatusNotaEJB(notaPagamento);

				newMovApartamento.setIdNr(notaPagamento.getIdNota());

				this.request.setAttribute("abrirPopupReciboPagamento", "true");
			} else {
				this.request.setAttribute("abrirPopupLancamento", "true");
			}
			newMovApartamento
					.setUsuario(super.getUserSession().getUsuarioEJB());

			List<MovimentoApartamentoEJB> listaLancamento = (List) CheckinDelegate
					.instance().incluir(newMovApartamento);

			newMovApartamento = (MovimentoApartamentoEJB) listaLancamento
					.get(0);
			if (notaPagamento != null) {
				List<MovimentoApartamentoEJB> movimentoReciboPagamento = new ArrayList();
				movimentoReciboPagamento.addAll(listaLancamento);
				this.request.setAttribute("notaHospedagem", notaPagamento);
				this.request.setAttribute("movimentoReciboPagamento",
						movimentoReciboPagamento);
			}
			for (MovimentoApartamentoEJB mov : listaLancamento) {
				checkinCorrente.addMovimentoApartamentoEJB(mov);
			}
			if (this.idxCliente.longValue() > 0L) {
				for (MovimentoApartamentoEJB mov : listaLancamento) {
					((RoomListEJB) checkinCorrente.getRoomListEJBList().get(
							this.idxCliente.intValue() - 1))
							.addMovimentoApartamentoEJBList(mov);
				}
			}
			ordenarMovimentos();

			addMensagemSucesso("Operação realizada com sucesso.");
			checkinCorrente.setUsuario(getUserSession().getUsuarioEJB());
			CheckinDelegate.instance().unificaTaxasCheckin(checkinCorrente);
			this.id = checkinCorrente.getIdCheckin();
			return prepararCheckout();
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return "sucesso";
	}

	public String imprimirExtrato() {
		info("Imprimindo: " + this.idxCliente);
		try {
			sincronizarLancamentos();
			ordenarMovimentos();
			this.request.setAttribute("abrirPopupExtrato", "true");
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
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

	private void sincronizarLancamentos() {
		info("CaixaGeralAction:sincronizarLancamentos");

		HotelEJB hotel = getHotelCorrente();

		CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
				.getAttribute("checkinCorrente");

		Collections.sort(checkinCorrente.getMovimentoApartamentoEJBList(),
				MovimentoApartamentoEJB.getComparator());

		this.valorPagamento = Double.valueOf(0.0D);
		Double valorTotal = Double.valueOf(0.0D);
		Double valorTotalIss = Double.valueOf(0.0D);
		Double valorTotalTaxa = Double.valueOf(0.0D);

		String movimentosParciais = (String) this.request.getSession()
				.getAttribute("movimentosParciais");
		for (int x = 0; x < this.movimentos.length; x++) {
			if (!isNull(this.movimentos[x]).booleanValue()) {
				String[] ids = this.movimentos[x].split(";");
				for (int y = 0; y < ids.length; y++) {
					String id = ids[y];
					if (!isNull(id).booleanValue()) {
						MovimentoApartamentoEJB mov = new MovimentoApartamentoEJB();
						mov.setIdMovimentoApartamento(new Long(id));

						int index = -1;
						if ((index = checkinCorrente
								.getMovimentoApartamentoEJBList().indexOf(mov)) >= 0) {
							mov =

							(MovimentoApartamentoEJB) checkinCorrente
									.getMovimentoApartamentoEJBList()
									.get(index);
							if ((movimentosParciais != null)
									&& (movimentosParciais.indexOf(id + ";") >= 0)) {
								valorTotal = Double.valueOf(valorTotal
										.doubleValue()
										+ mov.getValorLancamento()
												.doubleValue());
								if ((hotel.getTaxaCheckout().equals("S"))
										&& (hotel.getIss().doubleValue() > 0.0D)
										&& (checkinCorrente.getCalculaIss()
												.equals("S"))) {
									if ("S".equals(mov.getTipoLancamentoEJB()
											.getIss())) {
										valorTotalIss = Double
												.valueOf(valorTotalIss
														.doubleValue()
														+ mov.getValorLancamento()
																.doubleValue());
									}
								}
								if ((hotel.getTaxaCheckout().equals("S"))
										&& (checkinCorrente.getCalculaTaxa()
												.equals("S"))
										&& ("S".equals(mov
												.getTipoLancamentoEJB()
												.getTaxaServico()))) {
									valorTotalTaxa = Double
											.valueOf(valorTotalTaxa
													.doubleValue()
													+ mov.getValorLancamento()
															.doubleValue());
								}
							}
							if(!MozartUtil.isNull(mov.getRoomListEJB())){
								((RoomListEJB) checkinCorrente.getRoomListEJBList()
										.get(checkinCorrente.getRoomListEJBList()
												.indexOf(mov.getRoomListEJB())))
												.getMovimentoApartamentoEJBList().remove(
														mov);
							}
							if (x == 0) {
								mov.setQuemPaga("E");
								mov.setRoomListEJB(checkinCorrente
										.getRoomListPrincipal());
							} else {
								mov.setQuemPaga("H");
								((RoomListEJB) checkinCorrente
										.getRoomListEJBList().get(x - 1))
										.addMovimentoApartamentoEJBList(mov);
							}
						}
					}
				}
			}
		}
		this.valorPagamento = valorTotal;
		if ((hotel.getTaxaCheckout().equals("S"))
				&& (hotel.getIss().doubleValue() > 0.0D)) {
			this.valorPagamento = Double.valueOf(this.valorPagamento
					.doubleValue()
					+ MozartUtil.round(
							Double.valueOf(valorTotalIss.doubleValue()
									* hotel.getIss().doubleValue() / 100.0D))
							.doubleValue());
		}
		if ((hotel.getTaxaCheckout().equals("S"))
				&& (hotel.getTaxaServico().doubleValue() > 0.0D)) {
			this.valorPagamento = Double.valueOf(this.valorPagamento
					.doubleValue()
					+ MozartUtil.round(
							Double.valueOf(valorTotalTaxa.doubleValue()
									* hotel.getTaxaServico().doubleValue()
									/ 100.0D)).doubleValue());
		}
		this.valorPagamento = MozartUtil.round(this.valorPagamento);

		String valorPG = MozartUtil.format(Double.valueOf(this.valorPagamento
				.doubleValue() == -0.0D ? 0.0D : this.valorPagamento
				.doubleValue()));
		this.valorPagamento = MozartUtil.toDouble(valorPG);
	}

	public String prepararCheckout() {
		info("CaixaGeralAction:prepararCheckout");
		try {
			this.idPontoVenda = 0L;
			this.numComanda = "";
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
			CheckinEJB checkinCorrente = CheckinDelegate.instance()
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

			prepararMiniPdv();
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

	public String destravarApartamento() {
		try {
			ApartamentoEJB apto = (ApartamentoEJB) CheckinDelegate.instance()
					.obter(ApartamentoEJB.class, this.id);
			apto.setCheckout("N");
			apto.setUsuario(getUserSession().getUsuarioEJB());
			apto = (ApartamentoEJB) CheckinDelegate.instance().alterar(apto);

			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
			error(ex.getMessage());
		}
		return pesquisar();
	}

	@SuppressWarnings("finally")
	public String prepararLancamento() {
		warn("CaixaGeralAction:preparar");
		//prepararAbertura();
		this.request.getSession().removeAttribute("listaPesquisa");

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
			else{
				this.request.getSession().setAttribute("listaApartamentoGeral",
						Collections.emptyList());
			}
			
			this.request.getSession().setAttribute("listaAptoLivre",
					listaAptoLivre);
		} catch (MozartSessionException mox) {
			error(mox.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			return "sucesso";
		}
		
	}
	
	@SuppressWarnings("finally")
	public String pesquisar() {
		info("CaixaGeralAction:pesquisar");
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
			param.setIdHotel(getIdHoteis()[0]);
			param.setCofan("N");
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
					.pesquisarApartamentoComCheckinEReserva(param);

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
			return "sucesso";
		}
	}

	public String preparar() {
		warn("CaixaGeralAction:preparar");
		this.tipoPesquisa = "TODOS";
		return pesquisar();
	}

	public void setListaApartamento(List<CaixaGeralVO> listaApartamento) {
		this.listaApartamento = listaApartamento;
	}

	public List<CaixaGeralVO> getListaApartamento() {
		return this.listaApartamento;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return this.id;
	}

	public void setTipoPesquisa(String tipoPesquisa) {
		this.tipoPesquisa = tipoPesquisa;
	}

	public String getTipoPesquisa() {
		return this.tipoPesquisa;
	}

	public void setMovimentos(String[] movimentos) {
		this.movimentos = movimentos;
	}

	public String[] getMovimentos() {
		return this.movimentos;
	}

	public void setMovimentosParcial(String[] movimentosParcial) {
		this.movimentosParcial = movimentosParcial;
	}

	public String[] getMovimentosParcial() {
		return this.movimentosParcial;
	}

	public void setIdxCliente(Long idxCliente) {
		this.idxCliente = idxCliente;
	}

	public Long getIdxCliente() {
		return this.idxCliente;
	}

	public void setIdTipoLancamento(Long idTipoLancamento) {
		this.idTipoLancamento = idTipoLancamento;
	}

	public Long getIdTipoLancamento() {
		return this.idTipoLancamento;
	}

	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
	}

	public String getNumDocumento() {
		return this.numDocumento;
	}

	public void setValorLancamento(Double valorLancamento) {
		this.valorLancamento = valorLancamento;
	}

	public Double getValorLancamento() {
		return this.valorLancamento;
	}

	public void setIdTipoDiaria(Long idTipoDiaria) {
		this.idTipoDiaria = idTipoDiaria;
	}

	public Long getIdTipoDiaria() {
		return this.idTipoDiaria;
	}

	public void setValorPagamento(Double valorPagamento) {
		this.valorPagamento = valorPagamento;
	}

	public Double getValorPagamento() {
		return this.valorPagamento;
	}

	public void setValorAdicionado(Double valorAdicionado) {
		this.valorAdicionado = valorAdicionado;
	}

	public Double getValorAdicionado() {
		return this.valorAdicionado;
	}

	public void setMotivoCancelamentoNota(String motivoCancelamentoNota) {
		this.motivoCancelamentoNota = motivoCancelamentoNota;
	}

	public String getMotivoCancelamentoNota() {
		return this.motivoCancelamentoNota;
	}

	public void setIdTipoLancamentoObj(Long idTipoLancamentoObj) {
		this.idTipoLancamentoObj = idTipoLancamentoObj;
	}

	public Long getIdTipoLancamentoObj() {
		return this.idTipoLancamentoObj;
	}

	public void setIdMovimentoObjeto(String idMovimentoObjeto) {
		this.idMovimentoObjeto = idMovimentoObjeto;
	}

	public String getIdMovimentoObjeto() {
		return this.idMovimentoObjeto;
	}

	public void setIdTipoDiaria1(Long idTipoDiaria1) {
		this.idTipoDiaria1 = idTipoDiaria1;
	}

	public Long getIdTipoDiaria1() {
		return this.idTipoDiaria1;
	}

	public void setIdTipoLancamento1(Long idTipoLancamento1) {
		this.idTipoLancamento1 = idTipoLancamento1;
	}

	public Long getIdTipoLancamento1() {
		return this.idTipoLancamento1;
	}

	public void setIdTipoDiaria2(Long idTipoDiaria2) {
		this.idTipoDiaria2 = idTipoDiaria2;
	}

	public Long getIdTipoDiaria2() {
		return this.idTipoDiaria2;
	}

	public void setIdTipoLancamento2(Long idTipoLancamento2) {
		this.idTipoLancamento2 = idTipoLancamento2;
	}

	public Long getIdTipoLancamento2() {
		return this.idTipoLancamento2;
	}

	public void setMotivoCancelamentoNota1(String motivoCancelamentoNota1) {
		this.motivoCancelamentoNota1 = motivoCancelamentoNota1;
	}

	public String getMotivoCancelamentoNota1() {
		return this.motivoCancelamentoNota1;
	}

	public void setMotivoTransferencia(String motivoTransferencia) {
		this.motivoTransferencia = motivoTransferencia;
	}

	public String getMotivoTransferencia() {
		return this.motivoTransferencia;
	}

	public void setIdApartamentoDestino1(Long idApartamentoDestino1) {
		this.idApartamentoDestino1 = idApartamentoDestino1;
	}

	public Long getIdApartamentoDestino1() {
		return this.idApartamentoDestino1;
	}

	public void setMotivoTransferencia1(String motivoTransferencia1) {
		this.motivoTransferencia1 = motivoTransferencia1;
	}

	public String getMotivoTransferencia1() {
		return this.motivoTransferencia1;
	}

	public void setIdApartamentoDestino(String idApartamentoDestino) {
		this.idApartamentoDestino = idApartamentoDestino;
	}

	public String getIdApartamentoDestino() {
		return this.idApartamentoDestino;
	}

	public String getNumCartao() {
		return this.numCartao;
	}

	public void setNumCartao(String numCartao) {
		this.numCartao = numCartao;
	}

	public String getValidadeCartao() {
		return this.validadeCartao;
	}

	public void setValidadeCartao(String validadeCartao) {
		this.validadeCartao = validadeCartao;
	}

	public String getCodigoSegurancaCartao() {
		return this.codigoSegurancaCartao;
	}

	public void setCodigoSegurancaCartao(String codigoSegurancaCartao) {
		this.codigoSegurancaCartao = codigoSegurancaCartao;
	}

	public String getNumComanda() {
		return this.numComanda;
	}

	public void setNumComanda(String numComanda) {
		this.numComanda = numComanda;
	}

	public Long getIdPontoVenda() {
		return this.idPontoVenda;
	}

	public void setIdPontoVenda(Long idPontoVenda) {
		this.idPontoVenda = idPontoVenda;
	}

	public Long getIdPontoVenda1() {
		return this.idPontoVenda1;
	}

	public void setIdPontoVenda1(Long idPontoVenda1) {
		this.idPontoVenda1 = idPontoVenda1;
	}

	public String getIdPrato() {
		return this.idPrato;
	}

	public void setIdPrato(String idPrato) {
		this.idPrato = idPrato;
	}

	public String getIdPrato1() {
		return this.idPrato1;
	}

	public void setIdPrato1(String idPrato1) {
		this.idPrato1 = idPrato1;
	}

	public String getNumComanda1() {
		return this.numComanda1;
	}

	public void setNumComanda1(String numComanda1) {
		this.numComanda1 = numComanda1;
	}

	public Double getQtdePrato() {
		return this.qtdePrato;
	}

	public void setQtdePrato(Double qtdePrato) {
		this.qtdePrato = qtdePrato;
	}

	public Double getValorPrato() {
		return this.valorPrato;
	}

	public void setValorPrato(Double valorPrato) {
		this.valorPrato = valorPrato;
	}

	public Long getNumNotaFiscal() {
		return this.numNotaFiscal;
	}

	public void setNumNotaFiscal(Long numNotaFiscal) {
		this.numNotaFiscal = numNotaFiscal;
	}

	public String getSerieNotaFiscal() {
		return this.serieNotaFiscal;
	}

	public void setSerieNotaFiscal(String serieNotaFiscal) {
		this.serieNotaFiscal = serieNotaFiscal;
	}

	public String getSubSerieNotaFiscal() {
		return this.subSerieNotaFiscal;
	}

	public void setSubSerieNotaFiscal(String subSerieNotaFiscal) {
		this.subSerieNotaFiscal = subSerieNotaFiscal;
	}

	public boolean isLiberaGravacao() {
		return this.liberaGravacao;
	}

	public void setLiberaGravacao(boolean liberaGravacao) {
		this.liberaGravacao = liberaGravacao;
	}

	public Long getIdNovoRoomListPrincipal() {
		return this.idNovoRoomListPrincipal;
	}

	public void setIdNovoRoomListPrincipal(Long idNovoRoomListPrincipal) {
		this.idNovoRoomListPrincipal = idNovoRoomListPrincipal;
	}

	public HospedeEJB getIdNovoHospedeSubstituicao() {
		return this.idNovoHospedeSubstituicao;
	}

	public void setIdNovoHospedeSubstituicao(
			HospedeEJB idNovoHospedeSubstituicao) {
		this.idNovoHospedeSubstituicao = idNovoHospedeSubstituicao;
	}

	public String getNomeClienteCartao() {
		return this.nomeClienteCartao;
	}

	public void setNomeClienteCartao(String nomeClienteCartao) {
		this.nomeClienteCartao = nomeClienteCartao;
	}
	
}