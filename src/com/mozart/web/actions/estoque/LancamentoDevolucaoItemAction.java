package com.mozart.web.actions.estoque;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
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
import com.mozart.model.ejb.entity.MovimentoContabilEJB;
import com.mozart.model.ejb.entity.MovimentoEstoqueEJB;
import com.mozart.model.ejb.entity.TesourariaEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;

public class LancamentoDevolucaoItemAction extends LancamentoAction {

	private static final long serialVersionUID = 1061118313934167130L;

	private Long indice;
	protected String status;
	private String[] idMovimento;
	private String[] itemEstoque;
	private Long[] idItemEstoque;
	private String[] quantidadeMovimento;
	private String[] valorUnitario;
	private String[] valorTotal;
	

	public LancamentoDevolucaoItemAction() {
	}
	
	public String prepararPesquisa() {
		this.request.getSession().removeAttribute("listaPesquisa");
		return PESQUISA_FORWARD;
	}
	
	public String prepararLancamentoSaida() {
		List<MovimentoContabilEJB> entidade = new ArrayList();
		this.request.getSession().setAttribute("entidadeSession", entidade);
		
		return SUCESSO_FORWARD;
	}
	
	public String incluirLancamentoSaida() {
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
						
			BigDecimal valorTotalBig = !MozartUtil.isNull(this.valorTotal[0]) ? new BigDecimal(this.valorTotal[0].toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
			BigDecimal quantidadeBig = !MozartUtil.isNull(this.quantidadeMovimento[0]) ? new BigDecimal(this.quantidadeMovimento[0].toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
			
			lancamento.setQuantidade(quantidadeBig);
			lancamento.setValorUnitario(!MozartUtil.isNull(this.valorTotal[0]) && !MozartUtil.isNull(this.quantidadeMovimento[0]) ? valorTotalBig.divide(quantidadeBig, 4, 1) : null);
			lancamento.setValorTotal(valorTotalBig);
			 
			entidade.add(lancamento);

			this.indice = null;
			resetLancamento();
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
}