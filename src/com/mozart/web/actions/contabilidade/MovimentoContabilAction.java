package com.mozart.web.actions.contabilidade;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ContabilidadeDelegate;
import com.mozart.model.delegate.ControladoriaDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.MovimentoContabilEJB;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ContaCorrenteVO;
import com.mozart.model.vo.MovimentoContabilVO;
import com.mozart.model.vo.PlanoContaVO;
import com.mozart.web.actions.financeiro.TesourariaAction;
import com.mozart.web.util.MozartComboWeb;

@SuppressWarnings("unchecked")
public class MovimentoContabilAction extends TesourariaAction {
	private static final long serialVersionUID = 230059386958614800L;
	private MovimentoContabilEJB entidadeMov;
	private MovimentoContabilVO saldoMovimento;
	private String dataContabilidade;
	private String executarLancamentoAnual;

	public MovimentoContabilAction() {
		this.filtro = new MovimentoContabilVO();
	}

	public String encerrar() {
		try {
			int mes = Integer.parseInt(this.dataContabilidade.split("/")[0]);
			int ano = Integer.parseInt(this.dataContabilidade.split("/")[1]);
			Calendar cal = Calendar.getInstance();
			cal.set(5, 1);
			cal.set(2, mes - 1);
			cal.set(1, ano);
			cal.set(5, cal.getActualMaximum(5));

			this.entidadeMov = new MovimentoContabilEJB();
			this.entidadeMov.setIdHotel(getHotelCorrente().getIdHotel());
			this.entidadeMov.setUsuario(getUsuario());
			this.entidadeMov.setDataDocumento(new Timestamp(cal.getTime()
					.getTime()));
			this.entidadeMov
					.setExecutarLancamentoAnual(this.executarLancamentoAnual);

			ContabilidadeDelegate.instance().encerrarMovimentoContabil(
					this.entidadeMov);

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

	public String prepararRelatorio() {
		try {
			// TODO: (ID/Conta Corrente)
			ContaCorrenteVO filtro = new ContaCorrenteVO();
			filtro.setIdHoteis(getIdHoteis());
			setContaCorrenteList(ControladoriaDelegate.instance()
					.pesquisarContaCorrente(filtro));

			PlanoContaVO filtroPlanoConta = new PlanoContaVO();
			filtroPlanoConta.setOrdem(1);
			filtroPlanoConta.setIdRedeHotel(getHotelCorrente()
					.getRedeHotelEJB().getIdRedeHotel());
			filtroPlanoConta.getFiltroTipoConta().setTipo("C");
			filtroPlanoConta.getFiltroTipoConta().setTipoIntervalo("2");
			filtroPlanoConta.getFiltroTipoConta().setValorInicial("Analitico");
			setPlanoContaList(RedeDelegate.instance().pesquisarPlanoConta(
					filtroPlanoConta));

			CentroCustoContabilEJB filtroCentroCusto = new CentroCustoContabilEJB();
			filtroCentroCusto.setIdRedeHotel(getHotelCorrente()
					.getRedeHotelEJB().getIdRedeHotel());
			setCentroCustoList(RedeDelegate.instance().pesquisarCentroCusto(
					filtroCentroCusto));
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararEncerramento() {
		super.prepararPesquisa();
		this.executarLancamentoAnual = "N";
		Date data = getControlaData().getContabilidade();
		data = MozartUtil.primeiroDiaMes(data);
		this.dataContabilidade = MozartUtil.format(MozartUtil.incrementarMes(
				data, 1), "MM/yyyy");
		return "sucesso";
	}

	public String consolidar() {
		try {
			List<MovimentoContabilVO> listaPesquisa = (List) this.request
					.getSession().getAttribute("listaPesquisa");
			CheckinDelegate delegate = CheckinDelegate.instance();
			for (MovimentoContabilVO mov : listaPesquisa) {
				MovimentoContabilEJB movimento = (MovimentoContabilEJB) delegate
						.obter(MovimentoContabilEJB.class, mov
								.getIdMovimentoContabil());
				if ("A".equals(movimento.getTipoMovimento())) {
					movimento.setUsuario(getUsuario());
					movimento.setTipoMovimento("M");
					delegate.alterar(movimento);
				}
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		} finally {
			pesquisar();
		}
		return "sucesso";
	}

	public String prepararLancamento() {
		try {
			this.saldoMovimento = ContabilidadeDelegate.instance()
					.obterSaldoMovimentoContabil(getHotelCorrente());
			super.prepararLancamento();
			this.dataLancamento = getControlaData().getContabilidade();

			List<MovimentoContabilEJB> entidade = (ArrayList) this.request
					.getSession().getAttribute("entidadeSession");
			if ((entidade.size() == 1)
					&& (((MovimentoContabilEJB) entidade.get(0))
							.getIdMovimentoContabil() != null)) {
				this.status = "alteracao";
			}
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararInclusao() {
		try {
			super.prepararInclusao();
			this.saldoMovimento = ContabilidadeDelegate.instance()
					.obterSaldoMovimentoContabil(getHotelCorrente());
			int mes = MozartUtil.getMes(getControlaData().getContabilidade());
			int ano = MozartUtil.getAno(getControlaData().getContabilidade());
			Calendar cal = Calendar.getInstance();
			cal.set(5, 1);
			cal.set(2, mes - 1);
			cal.set(1, ano);
			int diaFim = cal.getActualMaximum(5);
			int diaInicio = 1;
			setDiaLancamentoList(new ArrayList());
			while (diaInicio <= diaFim) {
				getDiaLancamentoList().add(
						new MozartComboWeb(String.valueOf(diaInicio),
								MozartUtil.lpad(String.valueOf(diaInicio), "0",
										2)));
				diaInicio++;
			}
			this.status = "";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararAlteracao() {
		try {
			super.prepararInclusao();
			this.saldoMovimento = ContabilidadeDelegate.instance()
					.obterSaldoMovimentoContabil(getHotelCorrente());
			int mes = MozartUtil.getMes(getControlaData().getContabilidade());
			int ano = MozartUtil.getAno(getControlaData().getContabilidade());
			Calendar cal = Calendar.getInstance();
			cal.set(5, 1);
			cal.set(2, mes - 1);
			cal.set(1, ano);
			int diaFim = cal.getActualMaximum(5);
			int diaInicio = 1;
			setDiaLancamentoList(new ArrayList());
			while (diaInicio <= diaFim) {
				getDiaLancamentoList().add(
						new MozartComboWeb(String.valueOf(diaInicio),
								MozartUtil.lpad(String.valueOf(diaInicio), "0",
										2)));
				diaInicio++;
			}
			List<MovimentoContabilEJB> entidade = (ArrayList) this.request
					.getSession().getAttribute("entidadeSession");

			MovimentoContabilEJB mov = (MovimentoContabilEJB) CheckinDelegate
					.instance().obter(MovimentoContabilEJB.class,
							this.entidadeMov.getIdMovimentoContabil());
			entidade.add(mov);
			cal.setTime(mov.getDataDocumento());
			cal.get(5);
			setDiaLancamento(Integer.valueOf(cal.get(5)));
			
			this.seqContabil = !MozartUtil.isNull(mov.getIdSeqContabil()) ? mov.getIdSeqContabil() : 0L;
			this.status = "alteracao";
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String prepararPesquisa() {
		try {
			super.prepararPesquisa();
			this.request.setAttribute(
					"filtro.filtroDataDocumento.tipoIntervalo", "1");
			this.request.setAttribute(
					"filtro.filtroDataDocumento.valorInicial", MozartUtil
							.format(MozartUtil.primeiroDiaMes(getControlaData()
									.getContabilidade()), "dd/MM/yyyy"));
			this.request.setAttribute("filtro.filtroDataDocumento.valorFinal",
					MozartUtil.format(MozartUtil.ultimoDiaMes(getControlaData()
							.getContabilidade()), "dd/MM/yyyy"));
			this.saldoMovimento = ContabilidadeDelegate.instance()
					.obterSaldoMovimentoContabil(getHotelCorrente());
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public String pesquisar() {
		warn("Pesquisando movimentoContabil");
		try {
			if ((((MovimentoContabilVO) this.filtro).getFiltroDataDocumento() != null)
					&& (!MozartUtil.isNull(((MovimentoContabilVO) this.filtro)
							.getFiltroDataDocumento().getTipoIntervalo()))
					&& (!MozartUtil.isNull(((MovimentoContabilVO) this.filtro)
							.getFiltroDataDocumento().getValorInicial()))
					&& (!MozartUtil.isNull(((MovimentoContabilVO) this.filtro)
							.getFiltroDataDocumento().getValorFinal()))) {
				if (Integer
						.parseInt(((MovimentoContabilVO) this.filtro)
								.getFiltroDataDocumento().getValorInicial()
								.split("/")[1]) == (((MovimentoContabilVO) this.filtro)
						.getFiltroDataDocumento().getValorFinal() == null ? Integer
						.parseInt(((MovimentoContabilVO) this.filtro)
								.getFiltroDataDocumento().getValorInicial()
								.split("/")[1])
						: Integer.parseInt(((MovimentoContabilVO) this.filtro)
								.getFiltroDataDocumento().getValorFinal()
								.split("/")[1]))) {
				}
			} else {
				throw new MozartValidateException(
						"O campo 'Dt Doc.' é obrigatório ou está incompleto");
			}
			
			Calendar calDoc = Calendar.getInstance();
			calDoc.setTime(getControlaData().getContabilidade());
			
			if(!(Integer
					.parseInt(((MovimentoContabilVO) this.filtro)
							.getFiltroDataDocumento().getValorInicial()
							.split("/")[1]) == calDoc.get(Calendar.MONTH)+1)
	           && 
			   Integer
				.parseInt(((MovimentoContabilVO) this.filtro)
						.getFiltroDataDocumento().getValorInicial()
						.split("/")[2]) == calDoc.get(Calendar.YEAR)
			   && 
			   Integer
				.parseInt(((MovimentoContabilVO) this.filtro)
						.getFiltroDataDocumento().getValorFinal()
						.split("/")[1]) == calDoc.get(Calendar.MONTH)+1
	           && 
			   Integer
				.parseInt(((MovimentoContabilVO) this.filtro)
						.getFiltroDataDocumento().getValorFinal()
						.split("/")[2]) == calDoc.get(Calendar.YEAR)){
				throw new MozartValidateException(
						"O campo 'Dt Doc.' deve estar dentro de mês da Contabilidade");
			}
			
			prepararPesquisa();
			this.filtro.setIdHoteis(getIdHoteis());
			this.filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			List<MovimentoContabilVO> listaPesquisa = ContabilidadeDelegate
					.instance().pesquisarMovimentoContabil(
							(MovimentoContabilVO) this.filtro);
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
		warn("Excluindo movimentoContabil");
		try {
			this.saldoMovimento = ContabilidadeDelegate.instance()
					.obterSaldoMovimentoContabil(getHotelCorrente());
			this.entidadeMov = ((MovimentoContabilEJB) CheckinDelegate
					.instance().obter(MovimentoContabilEJB.class,
							this.entidadeMov.getIdMovimentoContabil()));
			this.entidadeMov.setUsuario(getUsuario());
			this.entidadeMov.setTipoMovimento("E");
			CheckinDelegate.instance().alterar(this.entidadeMov);
			pesquisar();
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

	public MovimentoContabilEJB getEntidadeMov() {
		return this.entidadeMov;
	}

	public void setEntidadeMov(MovimentoContabilEJB entidadeMov) {
		this.entidadeMov = entidadeMov;
	}

	public MovimentoContabilVO getSaldoMovimento() {
		return this.saldoMovimento;
	}

	public void setSaldoMovimento(MovimentoContabilVO saldoMovimento) {
		this.saldoMovimento = saldoMovimento;
	}

	public String getDataContabilidade() {
		return this.dataContabilidade;
	}

	public void setDataContabilidade(String dataContabilidade) {
		this.dataContabilidade = dataContabilidade;
	}

	public String getExecutarLancamentoAnual() {
		return this.executarLancamentoAnual;
	}

	public void setExecutarLancamentoAnual(String executarLancamentoAnual) {
		this.executarLancamentoAnual = executarLancamentoAnual;
	}
}