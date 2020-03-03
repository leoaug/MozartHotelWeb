package com.mozart.web.actions.custo;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.ejb.entity.ItemEstoqueEJBPK;
import com.mozart.model.ejb.entity.ItemRedeEJB;
import com.mozart.model.ejb.entity.ItemRedeEJBPK;
import com.mozart.model.ejb.entity.PratoEJB;
import com.mozart.model.ejb.entity.PratoEJBPK;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ConsumoInternoVO;

public class LancamentoConsumoInternoItemAction extends TransferenciaCustoAction {

	private static final long serialVersionUID = 1061118313934167130L;

	private Long indice;
	protected String status;
	private String[] prato;
	private Long[] idPrato;
	private String[] quantidade;
	private String[] custo;
	private String[] custoTotal;
	private String unidade;
	private String qtde;
	private String valCusto;
	private String valVenda;
	private String[] venda;
	private String[] vendaTotal;
	private String valCustoTotal;
	private String valVendaTotal;
	
	private ConsumoInternoVO consumoInternoEntidade;
	
	public LancamentoConsumoInternoItemAction() {
	}

	private void inicializarCombos() throws MozartSessionException {
		
	}
	
	private void inicializarComboAliquotas() throws MozartSessionException {
	}
	
	public String prepararPesquisa() {
		this.request.getSession().removeAttribute("listaPesquisa");
		return PESQUISA_FORWARD;
	}
	
	public String prepararLancamento() {
		try {
			inicializarCombos();
			inicializarEntidades();
			List<ConsumoInternoVO> entidade = new ArrayList();
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
		consumoInternoEntidade = new ConsumoInternoVO();
		
		this.qtde = new String("");
		this.unidade = new String("");
		this.valCusto = new String("");
		this.valCustoTotal = new String("");
		this.valVenda = new String("");
		this.valVendaTotal = new String("");
	}
	
	public String validarItem() {

		try {
			inicializarCombos();
			inicializarEntidades();
			info("Iniciando validacao do item");
			PratoEJBPK pk = new PratoEJBPK();
			pk.setIdPrato(idPrato[0]);
			pk.setIdHotel(getHotelCorrente().getIdHotel());
			
			//consumoInternoEntidade.setpr = (PratoEJB) CheckinDelegate.instance().obter(PratoEJB.class, pk);
			//request.getSession().setAttribute("entidadeItemEstoque", itemEstoqueEJB);
		} catch (Exception ex) {
			addMensagemErro(MSG_ERRO);
			error(ex.getMessage());
		}

		return SUCESSO_FORWARD;
	}
	
	public String incluirLancamento() {
		try {
			sincronizarLancamento();

			List<ConsumoInternoVO> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

			ConsumoInternoVO lancamento = new ConsumoInternoVO();

			PratoEJBPK pk = new PratoEJBPK();
			pk.setIdPrato(this.idPrato[0]);
			pk.setIdHotel(getHotelCorrente().getIdHotel());
			
			PratoEJB prato = (PratoEJB) CheckinDelegate.instance().obter(
					PratoEJB.class, pk);
			
			lancamento.setPrato(prato.getNomePrato());
			lancamento.setIdPrato(prato.getId().getIdPrato());
			lancamento.setUnidade(this.unidade);
								
			BigDecimal valorCustoBig = !MozartUtil.isNull(this.valCusto) ? new BigDecimal(this.valCusto.toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
			BigDecimal valorCustoTotalBig = !MozartUtil.isNull(this.valCustoTotal) ? new BigDecimal(this.valCustoTotal.toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
			BigDecimal valorVendaBig = !MozartUtil.isNull(this.valVenda) ? new BigDecimal(this.valVenda.toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
			BigDecimal valorVendaTotalBig = !MozartUtil.isNull(this.valVendaTotal) ? new BigDecimal(this.valVendaTotal.toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
			BigDecimal valorQuantidadeBig = !MozartUtil.isNull(this.qtde)? new BigDecimal(this.qtde.toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
						
			lancamento.setQuantidade(valorQuantidadeBig != null ? valorQuantidadeBig.doubleValue() : null);
			lancamento.setCusto(valorCustoBig != null ? valorCustoBig.doubleValue() : null);
			lancamento.setCustoTotal(valorCustoTotalBig != null ? valorCustoTotalBig.doubleValue() : null);
			lancamento.setVenda(valorVendaBig != null ? valorVendaBig.doubleValue() : null);
			lancamento.setVendaTotal(valorVendaTotalBig != null ? valorVendaTotalBig.doubleValue() : null);
			
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
			List<ConsumoInternoVO> entidade = (List) this.request
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
		List<ConsumoInternoVO> entidade = (List) this.request
				.getSession().getAttribute("entidadeSession");
	}
	
	private void resetLancamento() {	
		this.unidade = new String("");
		this.prato[0] = new String("");
		this.idPrato[0] = new Long(-1L);
		this.quantidade[0] = new String("");
		this.custo[0] = new String("");
		this.custoTotal[0] = new String("");		
		this.venda[0] = new String("");
		this.vendaTotal[0] = new String("");	
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

	public String[] getPrato() {
		return prato;
	}

	public void setPrato(String[] prato) {
		this.prato = prato;
	}

	public Long[] getIdPrato() {
		return idPrato;
	}

	public void setIdPrato(Long[] idPrato) {
		this.idPrato = idPrato;
	}

	public String[] getQuantidade() {
		return quantidade;
	}

	public void setQuantidade(String[] quantidade) {
		this.quantidade = quantidade;
	}

	public String[] getCusto() {
		return custo;
	}

	public void setCusto(String[] custo) {
		this.custo = custo;
	}

	public String[] getCustoTotal() {
		return custoTotal;
	}

	public void setCustoTotal(String[] custoTotal) {
		this.custoTotal = custoTotal;
	}

	public String[] getVenda() {
		return venda;
	}

	public void setVenda(String[] venda) {
		this.venda = venda;
	}

	public String[] getVendaTotal() {
		return vendaTotal;
	}

	public void setVendaTotal(String[] vendaTotal) {
		this.vendaTotal = vendaTotal;
	}

	public ConsumoInternoVO getConsumoInternoEntidade() {
		return consumoInternoEntidade;
	}

	public void setConsumoInternoEntidade(ConsumoInternoVO consumoInternoEntidade) {
		this.consumoInternoEntidade = consumoInternoEntidade;
	}

	public String getQtde() {
		return qtde;
	}

	public void setQtde(String qtde) {
		this.qtde = qtde;
	}

	public String getValCusto() {
		return valCusto;
	}

	public void setValCusto(String valCusto) {
		this.valCusto = valCusto;
	}

	public String getValVenda() {
		return valVenda;
	}

	public void setValVenda(String valVenda) {
		this.valVenda = valVenda;
	}

	public String getValCustoTotal() {
		return valCustoTotal;
	}

	public void setValCustoTotal(String valCustoTotal) {
		this.valCustoTotal = valCustoTotal;
	}

	public String getValVendaTotal() {
		return valVendaTotal;
	}

	public void setValVendaTotal(String valVendaTotal) {
		this.valVendaTotal = valVendaTotal;
	}

	public String getUnidade() {
		return unidade;
	}

	public void setUnidade(String unidade) {
		this.unidade = unidade;
	}
}