package com.mozart.web.actions.estoque;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ContaCorrenteDelegate;
import com.mozart.model.delegate.EstoqueDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.AliquotaEJB;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.FiscalIncidenciaEJB;
import com.mozart.model.ejb.entity.FornecedorHotelEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.MovimentoEstoqueEJB;
import com.mozart.model.ejb.entity.PlanoContaEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ContaCorrenteVO;
import com.mozart.model.vo.EmpresaVO;
import com.mozart.model.vo.MovimentoEstoqueVO;
import com.mozart.web.actions.BaseAction;

public class LancamentoAction extends BaseAction {

	private static final long serialVersionUID = 1061118313934167130L;

	private static final String ENCERRAR_FORWARD = "encerrar";
	private static final String RELATORIO_FORWARD = "relatorio";
	// private static final String ENTRADA_FORWARD = "entrada";
	private static final String SAIDA_FORWARD = "saida";
	private static final String DEVOLUCAO_FORWARD = "devolucao";

	private MovimentoEstoqueVO filtro;
	protected MovimentoEstoqueEJB movimentoEstoque;
	private List<EmpresaVO> fornecedores;
	protected List<CentroCustoContabilEJB> centrosCustoContabil;
	protected List<ContaCorrenteVO> contasCorrente;
	protected List<FiscalIncidenciaEJB> fiscalIncidencias;
	protected List<AliquotaEJB> aliquotasList;

	protected Long idFornecedor;
	protected Long idPlanoContas;
	protected Long idContaCorrente;
	protected Long idCentroCusto;
	
	private String valorAcessorio;
	private String valorTotalNotas;

	public LancamentoAction() {
		this.centrosCustoContabil = Collections.emptyList();
		this.contasCorrente = Collections.emptyList();
		this.fiscalIncidencias = Collections.emptyList();
		this.aliquotasList = Collections.emptyList();
	}

	public String prepararPesquisa() {
		request.setAttribute("filtro.lancamento.tipoIntervalo", "2");
		//request.setAttribute("filtro.lancamento.valorInicial", MozartUtil.format(MozartUtil.incrementarDia(getControlaData().getEstoque(),-30), MozartUtil.FMT_DATE));
		request.setAttribute("filtro.lancamento.valorInicial", MozartUtil.format(getControlaData().getEstoque(), MozartUtil.FMT_DATE));

		this.request.getSession().removeAttribute("listaPesquisa");
		return PESQUISA_FORWARD;
	}
	
	public String prepararLancamento() {
		try
		{
			ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
					.obter(ControlaDataEJB.class, getIdHoteis()[0]);
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return SUCESSO_FORWARD;
	}

	private void inicializarCombos() throws MozartSessionException {
		this.inicializarComboCentroCustoContabil();
		this.inicializarComboContaCorrente();
	}

	protected void inicializarComboCentroCustoContabil()
			throws MozartSessionException {
		CentroCustoContabilEJB filtroCentroCustoContabil = new CentroCustoContabilEJB();
		filtroCentroCustoContabil.setIdRedeHotel(getHotelCorrente()
				.getRedeHotelEJB().getIdRedeHotel());
		this.centrosCustoContabil = RedeDelegate.instance()
				.pesquisarCentroCusto(filtroCentroCustoContabil);
	}
	
	private void inicializarComboContaCorrente() throws MozartSessionException {
		ContaCorrenteVO filtro = new ContaCorrenteVO();
		filtro.setIdHotel(getHotelCorrente().getIdHotel());
		this.contasCorrente = (List<ContaCorrenteVO>) ContaCorrenteDelegate
				.instance().obterContasCorrente(filtro);
		this.definirContaCorrentePadrao();
		this.preencherBancoAgenciaContaCorrente();
	}
	
	

	private void definirContaCorrentePadrao() {
		for (ContaCorrenteVO conta : this.contasCorrente) {
			if ("S".equals(conta.getPagamento())) {
				this.idContaCorrente = conta.getIdContaCorrente();
				break;
			}
		}
	}

	private void preencherBancoAgenciaContaCorrente() {
		for (ContaCorrenteVO conta : this.contasCorrente) {
			StringBuilder sb = new StringBuilder(conta.getBanco()).
					append(" - Ag. ").
					append(conta.getNomeAgencia()).
					append(" - CC. ").
					append(conta.getNumContaCorrente());
			conta.setBancoAgenciaContaCorrente(sb.toString());
		}
	}

	public String prepararEntrada() throws MozartSessionException {
		this.inicializarCombos();
		
		this.movimentoEstoque = new MovimentoEstoqueEJB();
			
		return SUCESSO_FORWARD;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String salvarEstoque() throws MozartSessionException {
		try {
			
			List<MovimentoEstoqueEJB> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUsuario());
			
			for (MovimentoEstoqueEJB lancamento : entidade) {
				lancamento.setUsuario(getUsuario());
				lancamento.setHotel(hotel);
				lancamento.setRedeHotel(hotel.getRedeHotelEJB());
				
				lancamento.setDataMovimento(getControlaData().getEstoque());
				lancamento.setContaCorrente(idContaCorrente);
				
				if(!MozartUtil.isNull(idFornecedor)){
					FornecedorHotelEJB fornecedor = new FornecedorHotelEJB();
					fornecedor.setIdFornecedor(idFornecedor);
					lancamento.setFornecedorHotelEJB(fornecedor);
				}
				
				if(!MozartUtil.isNull(movimentoEstoque.getNumDocumento())){
					lancamento.setNumDocumento(movimentoEstoque.getNumDocumento());
				}
				
				if(!MozartUtil.isNull(movimentoEstoque.getTipoDocumento())){
					lancamento.setTipoDocumento(movimentoEstoque.getTipoDocumento());
				}
				
				if(!MozartUtil.isNull(movimentoEstoque.getDataDocumento())){
					lancamento.setDataDocumento(movimentoEstoque.getDataDocumento());
				}
				
				if(!MozartUtil.isNull(movimentoEstoque.getSerieDocumento())){
					lancamento.setSerieDocumento(movimentoEstoque.getSerieDocumento());
				}
				
//				if(!MozartUtil.isNull(valorTotalNotas)){
//					lancamento.setValorTotal(new BigDecimal(valorTotalNotas));
//				}
				
				if(!MozartUtil.isNull(idPlanoContas)){
					PlanoContaEJB planoConta = new PlanoContaEJB();
					planoConta.setIdPlanoContas(idPlanoContas);
					lancamento.setPlanoContas(planoConta);
				}
				
				if(!MozartUtil.isNull(idCentroCusto)){
					CentroCustoContabilEJB centroCustoContabil = new CentroCustoContabilEJB();
					centroCustoContabil.setIdCentroCustoContabil(idCentroCusto);
					lancamento.setCentroCustoContabilAcessor(centroCustoContabil);
				}
				
				if(!MozartUtil.isNull(valorAcessorio)){
					BigDecimal valorAcessorioTotal = !MozartUtil.isNull(valorAcessorio) ? new BigDecimal(valorAcessorio.toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
					lancamento.setValorAcessorio(valorAcessorioTotal);
				}
				
				if(!MozartUtil.isNull(movimentoEstoque.getObservacao())){
					lancamento.setObservacao(movimentoEstoque.getObservacao());
				}
				
				if(!MozartUtil.isNull(idContaCorrente)){
					lancamento.setContaCorrente(idContaCorrente);
				}
				
				if(!MozartUtil.isNull(movimentoEstoque.getDataVencimento())){
					lancamento.setDataVencimento(movimentoEstoque.getDataVencimento());
				}
				
				if(!MozartUtil.isNull(movimentoEstoque.getChaveAcesso())){
					lancamento.setChaveAcesso(movimentoEstoque.getChaveAcesso());
				}
				
				lancamento.setTipoMovimento("E");
				lancamento.setIdMovimentoEstoque(EstoqueDelegate.instance().obterNextVal());
								
				EstoqueDelegate.instance().salvarMovimentoEstoque(lancamento);
				
				if(!MozartUtil.isNull(lancamento.getCentroCustoContabil())){
					lancamento.setTipoMovimento("S");
					lancamento.setIdMovimentoEstoque(EstoqueDelegate.instance().obterNextVal());
									
					EstoqueDelegate.instance().salvarMovimentoEstoqueReduzido(lancamento);
				}
			}
			
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

	public String pesquisar() {
		info("Pesquisando Lançamentos no Estoque");
		try {
			filtro.setIdHotel(getHotelCorrente().getIdHotel());
			List<MovimentoEstoqueVO> listaPesquisa = EstoqueDelegate.instance()
					.pesquisarMovimentoEstoque(filtro);

			if (MozartUtil.isNull(listaPesquisa)) {
				//request.removeAttribute("filtro.tipoItem.tipoIntervalo");
				//request.removeAttribute("filtro.tipoItem.valorInicial");
				//prepararPesquisa();
				this.request.getSession().removeAttribute("listaPesquisa");
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
				this.filtro = null;
				return SUCESSO_FORWARD;
			}

			request.getSession().setAttribute("listaPesquisa", listaPesquisa);
			return SUCESSO_FORWARD;

		} catch (Exception ex) {
			this.request.getSession().removeAttribute("listaPesquisa");
			addMensagemErro("Erro ao pesquisar Lançamentos no Estoque");
			error(ex.getMessage());
			this.filtro = null;
			return SUCESSO_FORWARD;
		}
	}

	// TODO: (ID) Em Execucao
	public String entrada() {
		try {
			filtro.setIdHotel(getHotelCorrente().getIdHotel());
			List<MovimentoEstoqueVO> listaPesquisa = EstoqueDelegate.instance()
					.pesquisarMovimentoEstoque(filtro);

			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
				return SUCESSO_FORWARD;
			}

			request.getSession().setAttribute("listaPesquisa", listaPesquisa);
			return SUCESSO_FORWARD;

		} catch (Exception ex) {
			addMensagemErro("Erro ao pesquisar Lançamentos no Estoque");
			error(ex.getMessage());
			this.filtro = null;
			return SUCESSO_FORWARD;
		}
	}
	
	public String encerrar() {
		try {
			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUserSession().getUsuarioEJB());
			EstoqueDelegate.instance().encerrarEstoque(hotel);
			
			ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
					.obter(ControlaDataEJB.class, getIdHoteis()[0]);
			
			this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);
			
			addMensagemSucesso("Operação realizada com sucesso.");
		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemErro(ex.getMessage());
			return prepararEncerramento();
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
			return prepararEncerramento();
		}
		
		return SUCESSO_FORWARD;
	}
	
	
	public String prepararEncerramento() {
		return ENCERRAR_FORWARD;
	}

	public String prepararRelatorio() {
		return RELATORIO_FORWARD;
	}

	public String prepararSaida() {
		return SAIDA_FORWARD;
	}

	public String prepararDevolucao() {
		return DEVOLUCAO_FORWARD;
	}

	public MovimentoEstoqueVO getFiltro() {
		return filtro;
	}

	public void setFiltro(MovimentoEstoqueVO filtro) {
		this.filtro = filtro;
	}

	public MovimentoEstoqueEJB getMovimentoEstoque() {
		return movimentoEstoque;
	}

	public void setMovimentoEstoque(MovimentoEstoqueEJB movimentoEstoque) {
		this.movimentoEstoque = movimentoEstoque;
	}

	public List<EmpresaVO> getFornecedores() {
		return fornecedores;
	}

	public void setFornecedores(List<EmpresaVO> fornecedores) {
		this.fornecedores = fornecedores;
	}

	public Long getIdFornecedor() {
		return idFornecedor;
	}

	public void setIdFornecedor(Long idFornecedor) {
		this.idFornecedor = idFornecedor;
	}

	public Long getIdPlanoContas() {
		return idPlanoContas;
	}

	public void setIdPlanoContas(Long idPlanoContas) {
		this.idPlanoContas = idPlanoContas;
	}

	public List<CentroCustoContabilEJB> getCentrosCustoContabil() {
		return centrosCustoContabil;
	}

	public void setCentrosCustoContabil(
			List<CentroCustoContabilEJB> centrosCustoContabil) {
		this.centrosCustoContabil = centrosCustoContabil;
	}

	public List<ContaCorrenteVO> getContasCorrente() {
		return contasCorrente;
	}

	public void setContasCorrente(List<ContaCorrenteVO> contasCorrente) {
		this.contasCorrente = contasCorrente;
	}

	public Long getIdContaCorrente() {
		return idContaCorrente;
	}

	public void setIdContaCorrente(Long idContaCorrente) {
		this.idContaCorrente = idContaCorrente;
	}

	public List<FiscalIncidenciaEJB> getFiscalIncidencias() {
		return fiscalIncidencias;
	}

	public void setFiscalIncidencias(List<FiscalIncidenciaEJB> fiscalIncidencias) {
		this.fiscalIncidencias = fiscalIncidencias;
	}

	public List<AliquotaEJB> getAliquotasList() {
		return aliquotasList;
	}

	public void setAliquotasList(List<AliquotaEJB> aliquotasList) {
		this.aliquotasList = aliquotasList;
	}
	
	public Long getIdCentroCusto() {
		return idCentroCusto;
	}

	public void setIdCentroCusto(Long idCentroCusto) {
		this.idCentroCusto = idCentroCusto;
	}
	
	public String getValorAcessorio() {
		return valorAcessorio;
	}

	public void setValorAcessorio(String valorAcessorio) {
		this.valorAcessorio = valorAcessorio;
	}

	public String getValorTotalNotas() {
		return valorTotalNotas;
	}

	public void setValorTotalNotas(String valorTotalNotas) {
		this.valorTotalNotas = valorTotalNotas;
	}
	
}