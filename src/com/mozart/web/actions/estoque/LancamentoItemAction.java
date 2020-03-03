package com.mozart.web.actions.estoque;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ContabilidadeDelegate;
import com.mozart.model.delegate.CustoDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.AliquotaEJB;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.FiscalCodigoEJB;
import com.mozart.model.ejb.entity.FiscalIncidenciaEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.ItemEstoqueEJB;
import com.mozart.model.ejb.entity.ItemEstoqueEJBPK;
import com.mozart.model.ejb.entity.ItemRedeEJB;
import com.mozart.model.ejb.entity.ItemRedeEJBPK;
import com.mozart.model.ejb.entity.MovimentoContabilEJB;
import com.mozart.model.ejb.entity.MovimentoEstoqueEJB;
import com.mozart.model.ejb.entity.TesourariaEJB;
import com.mozart.model.ejb.entity.UnidadeEstoqueEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;

public class LancamentoItemAction extends LancamentoAction {

	private static final long serialVersionUID = 1061118313934167130L;

	private Long indice;
	protected String status;
	private String[] idMovimento;
	private String[] itemEstoque;
	private Long[] idItemEstoque;
	private String[] quantidadeMovimento;
	private String qtdeMovimento;
	private String[] valorUnitario;
	private String[] valorTotal;
	private String vlrTotal;
	private Long[] idFiscalIncidencia;
	private Long[] idCentroCustos;
	private String[] baseCalculo;
	private String[] fiscalCodigo;
	private Long[] idCodigoFiscal;
	private Long[] idAliquotas;
	private String[] icmsValor;
	private ItemEstoqueEJB itemEstoqueEJB;
	

	public LancamentoItemAction() {
	}

	private void inicializarCombos() throws MozartSessionException {
		this.inicializarComboCentroCustoContabil();
		
	}
	
	protected void inicializarComboCentroCustoContabil()
			throws MozartSessionException {
		CentroCustoContabilEJB filtroCentroCustoContabil = new CentroCustoContabilEJB();
		filtroCentroCustoContabil.setIdRedeHotel(getHotelCorrente()
				.getRedeHotelEJB().getIdRedeHotel());
		this.centrosCustoContabil = RedeDelegate.instance()
				.pesquisarCentroCusto(filtroCentroCustoContabil);
	}
	
	private void inicializarComboAliquotas() throws MozartSessionException {
		this.aliquotasList = CustoDelegate.instance()
				.obterAliquota(getHotelCorrente());
	}
	
	private void inicializarComboFiscalIncidencia() throws MozartSessionException {
		this.fiscalIncidencias = (List<FiscalIncidenciaEJB>) CustoDelegate.instance()
				.obterFiscalIncidencias();
	}
	
	
	public String prepararPesquisa() {
		this.request.getSession().removeAttribute("listaPesquisa");
		return PESQUISA_FORWARD;
	}
	
	public String prepararLancamento() {
		try {
			inicializarCombos();
			inicializarEntidades();
			List<MovimentoContabilEJB> entidade = new ArrayList();
			this.request.getSession().setAttribute("entidadeSession", entidade);
			
		} catch (MozartSessionException e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		
		return SUCESSO_FORWARD;
	}
	
	
	private void inicializarEntidades(){
		ItemRedeEJBPK itemRedeEJBPK= new ItemRedeEJBPK();
		ItemRedeEJB itemRedeEJB = new ItemRedeEJB();
		itemRedeEJB.setId(itemRedeEJBPK);
		itemEstoqueEJB = new ItemEstoqueEJB();
		itemEstoqueEJB.setId(new ItemEstoqueEJBPK());
		itemEstoqueEJB.setItemRedeEJB(itemRedeEJB);
		itemEstoqueEJB.getItemRedeEJB().setUnidadeEstoqueRedeEJB(new UnidadeEstoqueEJB());
		this.qtdeMovimento = new String("");
		this.vlrTotal = new String("");
	}
	
	public String validarItem() {

		try {
			inicializarCombos();
			inicializarEntidades();
			info("Iniciando validacao do item");
			ItemEstoqueEJBPK  pk = new ItemEstoqueEJBPK();
			pk.setIdItem(idItemEstoque[0]);
			pk.setIdHotel(getHotelCorrente().getIdHotel());
			
			itemEstoqueEJB = (ItemEstoqueEJB) CheckinDelegate.instance().obter(ItemEstoqueEJB.class, pk);
			request.getSession().setAttribute("entidadeItemEstoque", itemEstoqueEJB);
		} catch (Exception ex) {
			addMensagemErro(MSG_ERRO);
			error(ex.getMessage());
		}

		return SUCESSO_FORWARD;
	}
	
	public String incluirLancamento() {
		try {
			sincronizarLancamento();

			List<MovimentoEstoqueEJB> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

			MovimentoEstoqueEJB lancamento = new MovimentoEstoqueEJB();

			ItemEstoqueEJBPK pkEstoque = new ItemEstoqueEJBPK();
			pkEstoque.setIdItem(this.idItemEstoque[0]);
			pkEstoque.setIdHotel(getHotelCorrente().getIdHotel());
			ItemEstoqueEJB itemEstoque1 = (ItemEstoqueEJB) CheckinDelegate.instance().obter(
					ItemEstoqueEJB.class, pkEstoque);
			
			lancamento.setItem(itemEstoque1);
			
			
			if(!MozartUtil.isNull(this.itemEstoqueEJB.getIdCentroCusto())){
				CentroCustoContabilEJB centroCusto = (CentroCustoContabilEJB) CheckinDelegate.instance().obter(
						CentroCustoContabilEJB.class, this.itemEstoqueEJB.getIdCentroCusto());
				
				lancamento.setCentroCustoContabil(centroCusto);
			}
			
//			if(!MozartUtil.isNull(this.idAliquotas) && !MozartUtil.isNull(this.idAliquotas[0]) && this.idAliquotas[0] != 0){
//				AliquotaEJB aliquota = (AliquotaEJB) CheckinDelegate.instance().obter(
//					AliquotaEJB.class, this.idAliquotas[0]);
//				
//				lancamento.setAliquotas(aliquota);
//			}
//			else
//				lancamento.setAliquotas(new AliquotaEJB());
//			
//			FiscalIncidenciaEJB fiscalIncidencia = (FiscalIncidenciaEJB) CheckinDelegate.instance().obter(
//					FiscalIncidenciaEJB.class, this.idFiscalIncidencia[0]);
//			
//			lancamento.setFiscalIncidencia(fiscalIncidencia);
			
			FiscalCodigoEJB codigoFiscal = (FiscalCodigoEJB) CheckinDelegate.instance().obter(
					FiscalCodigoEJB.class, this.itemEstoqueEJB.getFiscalCodigoEJB().getIdCodigoFiscal());
			
			lancamento.setFiscalCodigo(codigoFiscal);
		
			BigDecimal valorTotalBig = !MozartUtil.isNull(this.vlrTotal) ? new BigDecimal(this.vlrTotal.toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
			BigDecimal valorQuantidadeBig = !MozartUtil.isNull(this.qtdeMovimento)? new BigDecimal(this.qtdeMovimento.toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
			BigDecimal valorBaseCalculo =  null;
			BigDecimal valorICMS =  null;
			
			lancamento.setQuantidade(valorQuantidadeBig);
			lancamento.setValorUnitario(!MozartUtil.isNull(this.vlrTotal) && !MozartUtil.isNull(this.qtdeMovimento) ? valorTotalBig.divide(valorQuantidadeBig, 4, 1) : null);
			lancamento.setValorTotal(valorTotalBig);
			lancamento.setBaseCalculo(valorBaseCalculo);
			lancamento.setIcmsValor(valorICMS);
			
			
			if(!MozartUtil.isNull(itemEstoque1.getPlanoContaEJB())){
				String depreciacao  = itemEstoque1.getPlanoContaEJB().getDepreciacao();

				if(!MozartUtil.isNull(depreciacao) && "S".equals(depreciacao)){
					Long controleAtivoFixo = ContabilidadeDelegate.instance()
							.obterMaxControleAtivoFixoMovimentoContabilPorHotel(getHotelCorrente().getIdHotel());
					lancamento.setControleAtivoFixo(new BigDecimal(controleAtivoFixo.longValue() + 1L));
				}
				
			}
			entidade.add(lancamento);
			this.request
			.getSession().setAttribute("entidadeSession", entidade);
			this.indice = null;
			inicializarEntidades();
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}
	
	public String excluirLancamento() {
		try {
			sincronizarLancamento();
			List<MovimentoEstoqueEJB> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");
			entidade.remove(this.indice.intValue());
			resetLancamento();
		} catch (Exception e) {
			error(e.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}
		return "sucesso";
	}
	
	private void sincronizarLancamento() throws Exception {
		inicializarCombos();
		List<MovimentoEstoqueEJB> entidade = (List) this.request
				.getSession().getAttribute("entidadeSession");

		int x = 1;
//		for (MovimentoEstoqueEJB lancamento : entidade) {
//
//			lancamento.setIdMovimentoEstoque(new Long(x));
//			
//			ItemEstoqueEJBPK pkEstoque = new ItemEstoqueEJBPK();
//			pkEstoque.setIdItem(this.idItemEstoque[x]);
//			pkEstoque.setIdHotel(getHotelCorrente().getIdHotel());
//			ItemEstoqueEJB itemEstoque1 = (ItemEstoqueEJB) CheckinDelegate.instance().obter(
//					ItemEstoqueEJB.class, pkEstoque);
//			
//			lancamento.setItem(itemEstoque1);
//			
//			if(!MozartUtil.isNull(this.idCentroCustos[x])){
//				CentroCustoContabilEJB centroCusto = (CentroCustoContabilEJB) CheckinDelegate.instance().obter(
//						CentroCustoContabilEJB.class, this.idCentroCustos[x]);
//				
//				lancamento.setCentroCustoContabil(centroCusto);
//			}
//			
//			if(!MozartUtil.isNull(this.idAliquotas) && this.idAliquotas.length > x && !MozartUtil.isNull(this.idAliquotas[x]) && this.idAliquotas[x] != 0){
//				AliquotaEJB aliquota = (AliquotaEJB) CheckinDelegate.instance().obter(
//						AliquotaEJB.class, this.idAliquotas[x]);
//			
//				lancamento.setAliquotas(aliquota);
//			}
//			else
//				lancamento.setAliquotas(new AliquotaEJB());
//			
//			FiscalIncidenciaEJB fiscalIncidencia = (FiscalIncidenciaEJB) CheckinDelegate.instance().obter(
//					FiscalIncidenciaEJB.class, this.idFiscalIncidencia[x]);
//			
//			lancamento.setFiscalIncidencia(fiscalIncidencia);
//			
//			FiscalCodigoEJB codigoFiscal = (FiscalCodigoEJB) CheckinDelegate.instance().obter(
//					FiscalCodigoEJB.class, this.idCodigoFiscal[x]);
//			
//			lancamento.setFiscalCodigo(codigoFiscal);
//			
//			BigDecimal valorTotalBig = !MozartUtil.isNull(this.valorTotal[x]) ? new BigDecimal(this.valorTotal[x]) : null;
//			BigDecimal valorBaseCalculo = !MozartUtil.isNull(this.baseCalculo[x]) ? new BigDecimal(this.baseCalculo[x]) : null;
//			BigDecimal valorICMS = !MozartUtil.isNull(this.icmsValor[x]) ? new BigDecimal(this.icmsValor[x]) : null;
//			
//			lancamento.setQuantidade(!MozartUtil.isNull(this.quantidadeMovimento[x]) ? new BigDecimal(this.quantidadeMovimento[x]) : null);
//			lancamento.setValorUnitario(!MozartUtil.isNull(this.valorTotal[x]) && !MozartUtil.isNull(this.quantidadeMovimento[x]) ? valorTotalBig.divide(new BigDecimal(this.quantidadeMovimento[x]), 4, 1) : null);
//			lancamento.setValorTotal(valorTotalBig);
//			lancamento.setBaseCalculo(valorBaseCalculo);
//			lancamento.setIcmsValor(valorICMS);
//
//			x++;
//		}
	}
	
	private void resetLancamento() {
		
		//this.idMovimento[0] = new String("");		
		this.itemEstoque[0] = new String("");
		this.idItemEstoque[0] = new Long(-1L);
		this.quantidadeMovimento[0] = new String("");
		this.valorUnitario[0] = new String("");
		this.valorTotal[0] = new String("");
		this.idFiscalIncidencia[0] = new Long(-1L);
		this.idCentroCustos[0] = new Long(-1L);
		this.baseCalculo[0] = new String("");
		this.fiscalCodigo[0] = new String("");
		this.idCodigoFiscal[0] = new Long(-1L);
		this.idAliquotas[0] = new Long(-1L);
		this.icmsValor[0] = new String("");
		
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

	public Long getIndice() {
		return indice;
	}

	public void setIndice(Long indice) {
		this.indice = indice;
	}

	public String[] getIdMovimento() {
		return idMovimento;
	}

	public void setIdMovimento(String[] idMovimento) {
		this.idMovimento = idMovimento;
	}

	public String[] getItemEstoque() {
		return itemEstoque;
	}

	public void setItemEstoque(String[] itemEstoque) {
		this.itemEstoque = itemEstoque;
	}

	public String[] getQuantidadeMovimento() {
		return quantidadeMovimento;
	}

	public void setQuantidadeMovimento(String[] quantidadeMovimento) {
		this.quantidadeMovimento = quantidadeMovimento;
	}

	public String[] getValorUnitario() {
		return valorUnitario;
	}

	public void setValorUnitario(String[] valorUnitario) {
		this.valorUnitario = valorUnitario;
	}

	public String[] getValorTotal() {
		return valorTotal;
	}

	public void setValorTotal(String[] valorTotal) {
		this.valorTotal = valorTotal;
	}

	public Long[] getIdFiscalIncidencia() {
		return idFiscalIncidencia;
	}

	public void setIdFiscalIncidencia(Long[] idFiscalIncidencia) {
		this.idFiscalIncidencia = idFiscalIncidencia;
	}

	public Long[] getIdCentroCustos() {
		return idCentroCustos;
	}

	public void setIdCentroCustos(Long[] idCentroCustos) {
		this.idCentroCustos = idCentroCustos;
	}

	public String[] getBaseCalculo() {
		return baseCalculo;
	}

	public void setBaseCalculo(String[] baseCalculo) {
		this.baseCalculo = baseCalculo;
	}

	public String[] getFiscalCodigo() {
		return fiscalCodigo;
	}

	public void setFiscalCodigo(String[] fiscalCodigo) {
		this.fiscalCodigo = fiscalCodigo;
	}

	public Long[] getIdAliquotas() {
		return idAliquotas;
	}

	public void setIdAliquotas(Long[] idAliquotas) {
		this.idAliquotas = idAliquotas;
	}

	public String[] getIcmsValor() {
		return icmsValor;
	}

	public void setIcmsValor(String[] icmsValor) {
		this.icmsValor = icmsValor;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Long[] getIdItemEstoque() {
		return idItemEstoque;
	}

	public void setIdItemEstoque(Long[] idItemEstoque) {
		this.idItemEstoque = idItemEstoque;
	}

	public Long[] getIdCodigoFiscal() {
		return idCodigoFiscal;
	}

	public void setIdCodigoFiscal(Long[] idCodigoFiscal) {
		this.idCodigoFiscal = idCodigoFiscal;
	}

	public ItemEstoqueEJB getItemEstoqueEJB() {
		return itemEstoqueEJB;
	}

	public void setItemEstoqueEJB(ItemEstoqueEJB itemEstoqueEJB) {
		this.itemEstoqueEJB = itemEstoqueEJB;
	}

	public String getQtdeMovimento() {
		return qtdeMovimento;
	}

	public void setQtdeMovimento(String qtdeMovimento) {
		this.qtdeMovimento = qtdeMovimento;
	}

	public String getVlrTotal() {
		return vlrTotal;
	}

	public void setVlrTotal(String vlrTotal) {
		this.vlrTotal = vlrTotal;
	}
	
	
	
}