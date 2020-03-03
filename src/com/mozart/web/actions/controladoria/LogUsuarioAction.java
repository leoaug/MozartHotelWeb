package com.mozart.web.actions.controladoria;

import java.util.List;

import com.mozart.model.delegate.ControladoriaDelegate;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.LogUsuarioVO;
import com.mozart.web.actions.BaseAction;

public class LogUsuarioAction extends BaseAction {
	private static final long serialVersionUID = 1L;
	private String titulo;
	private String tabela;
	private LogUsuarioVO filtro;
	private static final String RESERVA = "RESERVA";

	public LogUsuarioAction() {
		this.filtro = new LogUsuarioVO();
	}

	public String prepararPesquisaEmpresa() {
		this.titulo = "Empresa";
		this.tabela = "EMPRESA";

		return prepararPesquisa();
	}

	public String prepararPesquisaReservaAptoDiaria() {
		this.titulo = "Reserva Apto Diária";
		this.tabela = "RESERVA_APARTAMENTO_DIARIA";

		return prepararPesquisa();
	}

	public String prepararPesquisaReservaApto() {
		this.titulo = "Log Checkin";
		this.tabela = "RESERVA_APARTAMENTO";

		return prepararPesquisa();
	}

	public String prepararPesquisaCheckinLog() {
		this.titulo = "Log Checkin";
		this.tabela = "CHECKIN";
		return prepararPesquisa();
	}

	public String prepararPesquisaReservaLog() {
		this.titulo = "Log Reserva";
		this.tabela = RESERVA;
		return prepararPesquisa();
	}

	public String prepararPesquisaContabil() {
		this.titulo = "Contabil";
		this.tabela = "MOVIMENTO_CONTABIL";
		return prepararPesquisa();
	}

	public String prepararPesquisaDuplicata() {
		this.titulo = "Duplicata";
		this.tabela = "DUPLICATA";
		return prepararPesquisa();
	}

	public String prepararPesquisaApartamento() {
		this.titulo = "Apartamento";
		this.tabela = "APARTAMENTO";
		return prepararPesquisa();
	}

	public String prepararPesquisaMovimentoApto() {
		this.titulo = "Movimento Apto";
		this.tabela = "MOVIMENTO_APARTAMENTO";
		return prepararPesquisa();
	}

	public String prepararPesquisaAuditoria() {
		this.titulo = "Encerramento Auditoria";
		this.tabela = "AUDITORIA";
		return prepararPesquisa();
	}

	public String prepararPesquisaLancamentoDiaria() {
		this.titulo = "Lançamento Diárias";
		this.tabela = "LANCAMENTO_DIARIAS";
		return prepararPesquisa();
	}

	public String prepararPesquisa() {
		this.request.setAttribute("filtro.filtroData.tipoIntervalo", "1");
		this.request.setAttribute("filtro.filtroData.valorInicial", MozartUtil
				.format(MozartUtil.decrementarDia(getControlaData()
						.getFrontOffice(), 30), "dd/MM/yyyy"));
		this.request.setAttribute("filtro.filtroData.valorFinal", MozartUtil
				.format(getControlaData().getFrontOffice(), "dd/MM/yyyy"));
		this.request.getSession().removeAttribute("listaPesquisa");
		return "sucesso";
	}

	public String pesquisar() {
		try {
			if ((!RESERVA.equals(this.tabela))
					&& (MozartUtil.isNull(this.filtro.getFiltroData()
							.getTipoIntervalo()))) {
				addMensagemSucesso("O Campo 'Data' é obrigatório");
				return "sucesso";
			}
			this.filtro.setIdHoteis(getIdHoteis());
			this.filtro.setIdUsuario(getUserSession().getUsuarioEJB()
					.getIdUsuario());
			this.filtro.setTabela(this.tabela);
			this.filtro.setTitulo(this.titulo);
			List<LogUsuarioVO> lista = ControladoriaDelegate.instance()
					.pesquisarLogUsuario(this.filtro);
			if (MozartUtil.isNull(lista)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}
			this.request.getSession().setAttribute("listaPesquisa", lista);
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}

	public LogUsuarioVO getFiltro() {
		return this.filtro;
	}

	public void setFiltro(LogUsuarioVO filtro) {
		this.filtro = filtro;
	}

	public String getTitulo() {
		return this.titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getTabela() {
		return this.tabela;
	}

	public void setTabela(String tabela) {
		this.tabela = tabela;
	}
}