package com.mozart.web.actions.controladoria;

import java.util.List;
import java.util.Vector;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ControladoriaDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.ConfigBloqueteEJB;
import com.mozart.model.ejb.entity.ConfigBloqueteEJBPK;
import com.mozart.model.ejb.entity.ContaCorrenteEJB;
import com.mozart.model.ejb.entity.PlanoContaEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ContaCorrenteVO;
import com.mozart.model.vo.PlanoContaVO;
import com.mozart.web.actions.BaseAction;

public class ContaCorrenteAction extends BaseAction {

	private static final long serialVersionUID = 1L;

	private ContaCorrenteVO filtro;
	private List<ContaCorrenteVO> contaCorrenteList;
	private List<PlanoContaVO> contaList; 
	private List<CentroCustoContabilEJB> centroCustoList;
	private ContaCorrenteEJB entidade;
	private String alteracao;
	private List<ConfigBloqueteEJB> configBloqueteList;
	private String possuiPagamento, possuiRecebimento, possuiCarteira;
	private String pagamentoAtual, recebimentoAtual, carteiraAtual;
	private PlanoContaEJB planoContaDebCred;

	public ContaCorrenteAction() {
		entidade = new ContaCorrenteEJB();
		filtro = new ContaCorrenteVO();
		configBloqueteList = new Vector<ConfigBloqueteEJB>();
	}

	private void initCombo() throws MozartSessionException {
		PlanoContaVO filtroPlanoConta = new PlanoContaVO();
		filtroPlanoConta.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
				.getIdRedeHotel());
		contaList = RedeDelegate.instance().pesquisarPlanoConta(
				filtroPlanoConta);

		CentroCustoContabilEJB filtroCentroCusto = new CentroCustoContabilEJB();
		filtroCentroCusto.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
				.getIdRedeHotel());
		centroCustoList = RedeDelegate.instance().pesquisarCentroCusto(
				filtroCentroCusto);

		entidade.setIdHotel(getHotelCorrente().getIdHotel());
		String[] resultado = ControladoriaDelegate.instance()
				.obterDadosContaCorrente(entidade);

		possuiPagamento = resultado[0];
		possuiRecebimento = resultado[1];
		possuiCarteira = resultado[2];

	}

	public String prepararInclusao() {
		try {
			entidade.setCarteira("N");
			entidade.setPagamento("N");
			entidade.setCobranca("N");
			initCombo();

		} catch (MozartSessionException e) {
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		return SUCESSO_FORWARD;
	}

	public String prepararPesquisa() {
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() {
		try {
			ConfigBloqueteEJBPK configBloqueteEJBPK = new ConfigBloqueteEJBPK();

			entidade.setIdHotel(getHotelCorrente().getIdHotel());
			entidade = (ContaCorrenteEJB) CheckinDelegate.instance().obter(
					ContaCorrenteEJB.class, entidade.getId());

			PlanoContaEJB pc = new PlanoContaEJB();
			pc.setIdPlanoContas(entidade.getIdContabilPag());
			planoContaDebCred = (PlanoContaEJB) CheckinDelegate.instance()
					.obter(PlanoContaEJB.class, pc.getIdPlanoContas());
			planoContaDebCred.setNomeConta(planoContaDebCred.getContaReduzida()
					+ " - " + planoContaDebCred.getContaContabil() + " - "
					+ planoContaDebCred.getNomeConta());
			configBloqueteEJBPK.setIdHotel(entidade.getIdHotel());
			configBloqueteEJBPK.setIdBanco(entidade.getBancoEJB().getIdBanco());
			configBloqueteEJBPK.setCampo("INSTRUCOES0%");

			configBloqueteList = ControladoriaDelegate.instance()
					.obterListConfigBloquete(
							new ConfigBloqueteEJB(configBloqueteEJBPK));

			initCombo();
			alteracao = "S";

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}

		return SUCESSO_FORWARD;
	}

	public String gravarContaCorrente() {
		try {
			String[] instrucoes = request.getParameterValues("instrucao");

			entidade.setIdHotel(getHotelCorrente().getIdHotel());
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			entidade.setUsuario(getUsuario());
			initCombo();

			PlanoContaEJB pc = new PlanoContaEJB();
			pc.setIdPlanoContas(planoContaDebCred.getIdPlanoContas());
			pc = (PlanoContaEJB) CheckinDelegate.instance().obter(
					PlanoContaEJB.class, pc.getIdPlanoContas());

			entidade.setIdContabilPag(pc.getIdPlanoContas());
			entidade.setIdContabilRec(pc.getIdPlanoContas());
			entidade.setIdHistoricoCredito(pc.getHistoricoCredito()
					.getIdHistorico());

			entidade.setIdHistoricoDebito(pc.getHistoricoDebito()
					.getIdHistorico());

			entidade.setIdCentroCustoC(entidade.getIdCentroCustoContabilD());
			
			
			if(entidade.getId() != null && entidade.getId() > 0 && alteracao.equals("S")){
				ContaCorrenteEJB entidadeAtual = (ContaCorrenteEJB) CheckinDelegate.instance().obter(
						ContaCorrenteEJB.class, entidade.getId());
				
				if(possuiPagamento == "S" && !entidade.getPagamento().equals(entidadeAtual.getPagamento())){
					error("Campo Pagamento não pode ser alterado.");
					addMensagemErro("Campo Pagamento não pode ser alterado.");
					return SUCESSO_FORWARD;
				}
				if(possuiRecebimento == "S" && !entidade.getCobranca().equals(entidadeAtual.getCobranca())){
					error("Campo Recebimento não pode ser alterado.");
					addMensagemErro("Campo Pagamento não pode ser alterado.");
					return SUCESSO_FORWARD;
				}
				if(possuiCarteira == "S" && !entidade.getCarteira().equals(entidadeAtual.getCarteira())){
					error("Campo Carteira não pode ser alterado.");
					addMensagemErro("Campo Recebimento não pode ser alterado.");
					return SUCESSO_FORWARD;
				}
			}

			if (MozartUtil.isNull(entidade.getId())) {
				CheckinDelegate.instance().incluir(entidade);
			} else {
				CheckinDelegate.instance().alterar(entidade);
			}

			int contador = 0;
			for (String instrucao : instrucoes) {
				ConfigBloqueteEJBPK configBloqueteEJBPK = new ConfigBloqueteEJBPK();
				configBloqueteEJBPK.setIdBanco(entidade.getBancoEJB()
						.getIdBanco());
				configBloqueteEJBPK.setIdHotel(entidade.getIdHotel());
				configBloqueteEJBPK.setCampo("INSTRUCOES"
						+ String.format("%02d", ++contador));
				configBloqueteEJBPK.setUsuario(getUsuario());

				ConfigBloqueteEJB configBloqueteEJB = new ConfigBloqueteEJB(
						configBloqueteEJBPK);
				configBloqueteEJB.setDescricao(instrucao);
				configBloqueteEJB.setUsuario(getUsuario());

				ControladoriaDelegate.instance().gravarConfigBloquete(
						configBloqueteEJB);
			}

			addMensagemSucesso(MSG_SUCESSO);
			entidade = new ContaCorrenteEJB();
			planoContaDebCred = new PlanoContaEJB();
			planoContaDebCred.setNomeConta("");

		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}

	public String pesquisar() {

		try {
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel());
			filtro.setIdHoteis(getIdHoteis());
			List<ContaCorrenteVO> lista = ControladoriaDelegate.instance()
					.pesquisarContaCorrente(filtro);

			if (MozartUtil.isNull(lista)) {
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			request.getSession().setAttribute(LISTA_PESQUISA, lista);

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}

	public ContaCorrenteVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ContaCorrenteVO filtro) {
		this.filtro = filtro;
	}

	public List<ContaCorrenteVO> getContaCorrenteList() {
		return contaCorrenteList;
	}

	public void setContaCorrenteList(List<ContaCorrenteVO> contaCorrenteList) {
		this.contaCorrenteList = contaCorrenteList;
	}

	public List<PlanoContaVO> getContaList() {
		return contaList;
	}

	public void setContaList(List<PlanoContaVO> contaList) {
		this.contaList = contaList;
	}

	public List<CentroCustoContabilEJB> getCentroCustoList() {
		return centroCustoList;
	}

	public void setCentroCustoList(List<CentroCustoContabilEJB> centroCustoList) {
		this.centroCustoList = centroCustoList;
	}

	public ContaCorrenteEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(ContaCorrenteEJB entidade) {
		this.entidade = entidade;
	}

	public String getAlteracao() {
		return alteracao;
	}

	public void setAlteracao(String alteracao) {
		this.alteracao = alteracao;
	}

	public String getPossuiPagamento() {
		return possuiPagamento;
	}

	public void setPossuiPagamento(String possuiPagamento) {
		this.possuiPagamento = possuiPagamento;
	}

	public String getPossuiRecebimento() {
		return possuiRecebimento;
	}

	public void setPossuiRecebimento(String possuiRecebimento) {
		this.possuiRecebimento = possuiRecebimento;
	}

	public String getPossuiCarteira() {
		return possuiCarteira;
	}

	public void setPossuiCarteira(String possuiCarteira) {
		this.possuiCarteira = possuiCarteira;
	}

	public List<ConfigBloqueteEJB> getConfigBloqueteList() {
		return configBloqueteList;
	}

	public void setConfigBloqueteList(List<ConfigBloqueteEJB> configBloqueteList) {
		this.configBloqueteList = configBloqueteList;
	}

	public PlanoContaEJB getPlanoContaDebCred() {
		return planoContaDebCred;
	}

	public void setPlanoContaDebCred(PlanoContaEJB planoContaDebCred) {
		this.planoContaDebCred = planoContaDebCred;
	}
}