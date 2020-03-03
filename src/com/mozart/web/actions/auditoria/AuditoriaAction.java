package com.mozart.web.actions.auditoria;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.AlfaDelegate;
import com.mozart.model.delegate.AuditoriaDelegate;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.ejb.entity.CheckinEJB;
import com.mozart.model.ejb.entity.CidadeEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.MovimentoApartamentoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CheckinVO;
import com.mozart.model.vo.HotelConsolidadoAlfa;
import com.mozart.model.vo.MovimentoApartamentoVO;
import com.mozart.model.vo.StatusNotaVO;
import com.mozart.model.vo.filtro.FiltroWeb;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartWebUtil;

@SuppressWarnings("unchecked")
public class AuditoriaAction extends BaseAction {
	private static final long serialVersionUID = 3682087145964488739L;
	private MovimentoApartamentoEJB entidade;
	private MovimentoApartamentoVO filtro;
	private String preCheckinVencidos;
	private String pdvEmAberto;
	private String diariasLancadas;
	private String contratosLancados;
	private String checkinIncompleto;
	private String checkoutVencido;
	private String pdvRestaurante;
	private String noShow;
	private String interditadosVencidos;
	private String tarifaBalcao;
	private List<StatusNotaVO> saidaDiaList;
	private Long idNota;
	private List<CheckinVO> checkinList;
	private List<String> motivoViagem;
	private List<String> tipoTransporte;
	private Long[] idCheckin;
	private Long[] idCidadeOrigem;
	private Long[] idCidadeDestino;
	private String[] motivoDaViagem;
	private String[] tipoDoTransporte;
	private String[] cidadeOrigem;
	private String[] cidadeDestino;
	private static final String ENCERRA_SERV = "encerraServ";
	private static final String ENCERRA_SUCESSO = "encerraSucesso";
	private boolean restaurante;

	public String reabrirConta() {
		try {
			StatusNotaVO statusNota = new StatusNotaVO();
			statusNota.setIdNota(this.idNota);
			statusNota.setUsuario(getUserSession().getUsuarioEJB());
			AuditoriaDelegate.instance().reabrirConta(statusNota);
			addMensagemSucesso("Operação realizada com sucesso.");
			return prepararReaberturaConta();
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararReaberturaConta() {
		try {
			this.saidaDiaList = AuditoriaDelegate.instance()
					.obterReaberturaConta(getIdHoteis()[0]);
			if (MozartUtil.isNull(this.saidaDiaList)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}
			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String gravarCheckin() {
		try {
			List<CheckinEJB> checkinEJBList = new ArrayList();
			for (int x = 0; x < this.idCheckin.length; x++) {
				CheckinEJB chk = new CheckinEJB();
				chk.setIdCheckin(this.idCheckin[x]);
				chk.setMotivoViagem(this.motivoDaViagem[x]);
				chk.setMeioTransporte(this.tipoDoTransporte[x]);

				CidadeEJB origem = new CidadeEJB();
				origem.setIdCidade(this.idCidadeOrigem[x]);
				chk.setCidadeProcedencia(origem);

				CidadeEJB destino = new CidadeEJB();
				destino.setIdCidade(this.idCidadeDestino[x]);
				chk.setCidadeDestino(destino);

				checkinEJBList.add(chk);
			}
			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUsuario());
			AuditoriaDelegate.instance().gravarCheckinComplemento(hotel,
					checkinEJBList);
			prepararEncerramento();
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String encerrarServ() {
		try {
			ControlaDataEJB controlaData = getControlaData();
			controlaData.setUsuario(getUserSession().getUsuarioEJB());
			
			AuditoriaDelegate.instance().encerrarAuditoriaServ(
					controlaData);
				
			ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
					.obter(ControlaDataEJB.class, controlaData.getIdHotel());
			
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);
			
			addMensagemSucesso("Operação realizada com sucesso.");
			return ENCERRA_SUCESSO;
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
		}
		return ENCERRA_SERV;
		
	}
	public String encerrar() {
		try {
			ControlaDataEJB controlaData = getControlaData();
			controlaData.setUsuario(getUserSession().getUsuarioEJB());

			if (this.restaurante){
				AuditoriaDelegate.instance().encerrarAuditoriaRestaurante(
						controlaData);
			}else{
				AuditoriaDelegate.instance().encerrarAuditoria(controlaData);
			}
			
			ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
					.obter(ControlaDataEJB.class, getIdHoteis()[0]);
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);

			if ((!this.restaurante)
					&& (getHotelCorrente().getEmpresaSeguradoraEJB() != null)
					&& (MozartUtil.getDiaDoMes(cd.getFrontOffice()) == 1)) {
				HotelConsolidadoAlfa filtroConsolidado = new HotelConsolidadoAlfa();
				filtroConsolidado.setIdSeguradora(new Long(82L));
				Long[] idHoteis = new Long[1];
				idHoteis[0] = getHotelCorrente().getIdHotel();
				filtroConsolidado.setIdHoteis(idHoteis);
				filtroConsolidado.setIdRedeHotel(getHotelCorrente()
						.getRedeHotelEJB().getIdRedeHotel());
				filtroConsolidado.getFiltroVigencia().setTipo("D");
				filtroConsolidado.getFiltroVigencia().setTipoIntervalo("2");
				filtroConsolidado.getFiltroVigencia().setValorInicial(
						MozartUtil.format(controlaData.getFrontOffice(),
								"MM/yyyy"));

				List<HotelConsolidadoAlfa> listaPesquisa = AlfaDelegate
						.instance().pesquisarHotelConsolidadoAlfa(
								filtroConsolidado);
				if (MozartUtil.isNull(listaPesquisa)) {
					throw new MozartValidateException(
							"Não foi possível gerar o boleto de seguro.");
				}
				Double valor = ((HotelConsolidadoAlfa) listaPesquisa.get(0))
						.getVlTotalSeguro();

				MozartWebUtil.gerarBoletoSeguro(cd, 6, getHotelCorrente(),
						EMAIL_BOLETO_SEGURO, valor);
			}

			addMensagemSucesso("Operação realizada com sucesso.");

		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
		} catch (Exception ex) {
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			if (this.restaurante)
				prepararEncerramentoRest();
			else
				prepararEncerramento();
		}
		return "sucesso";

	}

	public String prepararEncerramento() {
		try {
			this.restaurante = false;
			this.checkinList = Collections.EMPTY_LIST;
			this.motivoViagem = Collections.EMPTY_LIST;
			this.tipoTransporte = Collections.EMPTY_LIST;

			List validacaoAuditoria = AuditoriaDelegate.instance()
					.obterValidacao(getIdHoteis()[0]);
			this.preCheckinVencidos = ((String) validacaoAuditoria.get(0));
			this.pdvEmAberto = ((String) validacaoAuditoria.get(1));
			this.diariasLancadas = ((String) validacaoAuditoria.get(2));
			this.checkinIncompleto = ((String) validacaoAuditoria.get(3));
			this.checkoutVencido = ((String) validacaoAuditoria.get(4));
			this.pdvRestaurante = ((String) validacaoAuditoria.get(5));
			this.noShow = ((String) validacaoAuditoria.get(6));
			this.interditadosVencidos = ((String) validacaoAuditoria.get(7));
			this.tarifaBalcao = ((String) validacaoAuditoria.get(8));
			if (!MozartUtil.isNull(this.checkinIncompleto)) {
				CheckinVO pCheckinVO = new CheckinVO();
				pCheckinVO.setFiltroTipoPesquisa("3");
				pCheckinVO.setFiltroCheckinIncompleto(new FiltroWeb());
				pCheckinVO.getFiltroCheckinIncompleto().setTipo("B");
				pCheckinVO.getFiltroCheckinIncompleto().setTipoIntervalo(
						this.checkinIncompleto);
				pCheckinVO.setIdHoteis(getIdHoteis());
				this.checkinList = CheckinDelegate.instance().pesquisarCheckin(
						pCheckinVO);

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
			}
			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
			addActionError("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararEncerramentoRest() {

		String retorno = prepararEncerramento();
		this.restaurante = true;

		return retorno;
	}
	
	public String prepararEncerramentoServ() {
		
		try {
			List validacaoAuditoria = CheckinDelegate.instance()
					.obterValidacaoContrato(getHotelCorrente().getIdHotel());

			if(!MozartUtil.isNull(validacaoAuditoria)){
				contratosLancados = (String) validacaoAuditoria.get(0);
			}
		} catch (MozartSessionException e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return ENCERRA_SERV;
		
	}

	public String prepararRelatorio() {
		prepararPesquisa();
		return "sucesso";
	}

	public String prepararPesquisa() {
		this.request.getSession().removeAttribute("listaPesquisa");
		this.request.getSession().removeAttribute("entidadeSession");
		this.request.setAttribute("filtro.filtroDataLancamento.tipoIntervalo",
				"1");
		this.request.setAttribute("filtro.filtroDataLancamento.valorInicial",
				MozartUtil.format(getControlaData().getFrontOffice(),
						"dd/MM/yyyy"));
		this.request.setAttribute("filtro.filtroDataLancamento.valorFinal",
				MozartUtil.format(getControlaData().getFrontOffice(),
						"dd/MM/yyyy"));
		return "sucesso";
	}

	public String pesquisar() {
		info("Pesquisando auditoria");
		try {
			prepararPesquisa();
			this.filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			this.filtro.setIdHoteis(getIdHoteis());
			List<MovimentoApartamentoVO> listaPesquisa = AuditoriaDelegate
					.instance().pesquisarMovimento(this.filtro);
			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
				return "sucesso";
			}
			this.request.getSession().setAttribute("listaPesquisa",
					listaPesquisa);
			return "sucesso";
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

	public String prepararInclusao() {
		this.entidade = new MovimentoApartamentoEJB();
		return "sucesso";
	}

	public String prepararAlteracao() {
		try {
			this.entidade = ((MovimentoApartamentoEJB) CheckinDelegate
					.instance().obter(MovimentoApartamentoEJB.class,
							this.entidade.getIdMovimentoApartamento()));
			if (this.entidade.getDataLancamento()
					.compareTo(
							new Timestamp(getControlaData().getFrontOffice()
									.getTime())) != 0) {
				addMensagemSucesso("Não é permitido alterar lançamentos antigos.");
				return "erro";
			}
			this.request.getSession().setAttribute("entidadeSession",
					this.entidade);
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
		}
		return "sucesso";
	}

	public String gravar() {
		try {
			MovimentoApartamentoEJB mov = (MovimentoApartamentoEJB) this.request
					.getSession().getAttribute("entidadeSession");
			mov.setQtdeCafe(this.entidade.getQtdeCafe());
			mov.setMap(this.entidade.getMap());
			mov.setFap(this.entidade.getFap());

			validarAlteracaoAuditoria();

			mov.setUsuario(getUserSession().getUsuarioEJB());
			if (MozartUtil.isNull(mov.getIdMovimentoApartamento())) {
				CheckinDelegate.instance().incluir(mov);
			} else {
				CheckinDelegate.instance().alterar(mov);
			}
			addMensagemSucesso("Operação realizada com sucesso.");

			prepararInclusao();
			prepararPesquisa();
			return "erro";
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
			return "sucesso";
		} catch (Exception ex) {
			error(ex.getMessage());
			addActionError("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	private void validarAlteracaoAuditoria() throws MozartValidateException {
		MovimentoApartamentoEJB mov = (MovimentoApartamentoEJB) this.request
				.getSession().getAttribute("entidadeSession");

		int qtdeHospede = mov.getQtdeAdultos().intValue();

		int totalCafe = 0;
		if (!MozartUtil.isNull(this.entidade.getQtdeCafe())) {
			totalCafe = this.entidade.getQtdeCafe().intValue();
		}
		if (!MozartUtil.isNull(this.entidade.getMap())) {
			totalCafe += this.entidade.getMap().intValue();
		}
		if (!MozartUtil.isNull(this.entidade.getFap())) {
			totalCafe += this.entidade.getFap().intValue();
		}
		if (totalCafe > qtdeHospede) {
			throw new MozartValidateException(
					"Qtde de café maior que a Qtde de hóspede.");
		}
	}

	public MovimentoApartamentoEJB getEntidade() {
		return this.entidade;
	}

	public void setEntidade(MovimentoApartamentoEJB entidade) {
		this.entidade = entidade;
	}

	public MovimentoApartamentoVO getFiltro() {
		return this.filtro;
	}

	public void setFiltro(MovimentoApartamentoVO filtro) {
		this.filtro = filtro;
	}

	public String getPreCheckinVencidos() {
		return this.preCheckinVencidos;
	}

	public void setPreCheckinVencidos(String preCheckinVencidos) {
		this.preCheckinVencidos = preCheckinVencidos;
	}

	public String getPdvEmAberto() {
		return this.pdvEmAberto;
	}

	public void setPdvEmAberto(String pdvEmAberto) {
		this.pdvEmAberto = pdvEmAberto;
	}

	public String getDiariasLancadas() {
		return this.diariasLancadas;
	}

	public void setDiariasLancadas(String diariasLancadas) {
		this.diariasLancadas = diariasLancadas;
	}

	public String getCheckinIncompleto() {
		return this.checkinIncompleto;
	}

	public void setCheckinIncompleto(String checkinIncompleto) {
		this.checkinIncompleto = checkinIncompleto;
	}

	public String getCheckoutVencido() {
		return this.checkoutVencido;
	}

	public void setCheckoutVencido(String checkoutVencido) {
		this.checkoutVencido = checkoutVencido;
	}

	public List<StatusNotaVO> getSaidaDiaList() {
		return this.saidaDiaList;
	}

	public void setSaidaDiaList(List<StatusNotaVO> saidaDiaList) {
		this.saidaDiaList = saidaDiaList;
	}

	public Long getIdNota() {
		return this.idNota;
	}

	public void setIdNota(Long idNota) {
		this.idNota = idNota;
	}

	public List<CheckinVO> getCheckinList() {
		return this.checkinList;
	}

	public void setCheckinList(List<CheckinVO> checkinList) {
		this.checkinList = checkinList;
	}

	public List<String> getMotivoViagem() {
		return this.motivoViagem;
	}

	public void setMotivoViagem(List<String> motivoViagem) {
		this.motivoViagem = motivoViagem;
	}

	public List<String> getTipoTransporte() {
		return this.tipoTransporte;
	}

	public void setTipoTransporte(List<String> tipoTransporte) {
		this.tipoTransporte = tipoTransporte;
	}

	public Long[] getIdCheckin() {
		return this.idCheckin;
	}

	public void setIdCheckin(Long[] idCheckin) {
		this.idCheckin = idCheckin;
	}

	public Long[] getIdCidadeOrigem() {
		return this.idCidadeOrigem;
	}

	public void setIdCidadeOrigem(Long[] idCidadeOrigem) {
		this.idCidadeOrigem = idCidadeOrigem;
	}

	public Long[] getIdCidadeDestino() {
		return this.idCidadeDestino;
	}

	public void setIdCidadeDestino(Long[] idCidadeDestino) {
		this.idCidadeDestino = idCidadeDestino;
	}

	public String[] getMotivoDaViagem() {
		return this.motivoDaViagem;
	}

	public void setMotivoDaViagem(String[] motivoDaViagem) {
		this.motivoDaViagem = motivoDaViagem;
	}

	public String[] getTipoDoTransporte() {
		return this.tipoDoTransporte;
	}

	public void setTipoDoTransporte(String[] tipoDoTransporte) {
		this.tipoDoTransporte = tipoDoTransporte;
	}

	public String[] getCidadeOrigem() {
		return this.cidadeOrigem;
	}

	public void setCidadeOrigem(String[] cidadeOrigem) {
		this.cidadeOrigem = cidadeOrigem;
	}

	public String[] getCidadeDestino() {
		return this.cidadeDestino;
	}

	public void setCidadeDestino(String[] cidadeDestino) {
		this.cidadeDestino = cidadeDestino;
	}

	public String getPdvRestaurante() {
		return this.pdvRestaurante;
	}

	public void setPdvRestaurante(String pdvRestaurante) {
		this.pdvRestaurante = pdvRestaurante;
	}

	public String getNoShow() {
		return noShow;
	}

	public void setNoShow(String noShow) {
		this.noShow = noShow;
	}

	public boolean isRestaurante() {
		return restaurante;
	}

	public void setRestaurante(boolean restaurante) {
		this.restaurante = restaurante;
	}

	public String getContratosLancados() {
		return contratosLancados;
	}

	public void setContratosLancados(String contratosLancados) {
		this.contratosLancados = contratosLancados;
	}

	public String getInterditadosVencidos() {
		return interditadosVencidos;
	}

	public void setInterditadosVencidos(String interditadosVencidos) {
		this.interditadosVencidos = interditadosVencidos;
	}

	public String getTarifaBalcao() {
		return tarifaBalcao;
	}

	public void setTarifaBalcao(String tarifaBalcao) {
		this.tarifaBalcao = tarifaBalcao;
	}
}