package com.mozart.web.actions.custo;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.ejb.entity.ItemEstoqueEJB;
import com.mozart.model.ejb.entity.ItemEstoqueEJBPK;
import com.mozart.model.ejb.entity.ItemRedeEJB;
import com.mozart.model.ejb.entity.ItemRedeEJBPK;
import com.mozart.model.ejb.entity.MovimentoEstoqueEJB;
import com.mozart.model.ejb.entity.UnidadeEstoqueEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;

public class LancamentoTransferenciaItemAction extends TransferenciaCustoAction {

	private static final long serialVersionUID = 1061118313934167130L;

	private Long indice;
	protected String status;
	private String[] itemEstoque;
	private Long[] idItemEstoque;
	private String[] quantidadeMovimento;
	private String qtdeMovimento;
	private String[] valorUnitario;
	private String[] valorTotal;
	private String vlrTotal;
	
	private ItemEstoqueEJB itemEstoqueEJB;
	
	public LancamentoTransferenciaItemAction() {
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
			List<MovimentoEstoqueEJB> entidade = new ArrayList();
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
						
			BigDecimal valorTotalBig = !MozartUtil.isNull(this.vlrTotal) ? new BigDecimal(this.vlrTotal.toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
			BigDecimal valorQuantidadeBig = !MozartUtil.isNull(this.qtdeMovimento)? new BigDecimal(this.qtdeMovimento.toString().replace('.', ' ').replaceAll(" ", "").replace(',', '.')) : null;
			
			lancamento.setQuantidade(valorQuantidadeBig);
			lancamento.setValorUnitario(!MozartUtil.isNull(this.vlrTotal) && !MozartUtil.isNull(this.qtdeMovimento) ? valorTotalBig.divide(valorQuantidadeBig, 4, 1) : null);
			lancamento.setValorTotal(valorTotalBig);
			
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
	}
	
	private void resetLancamento() {	
		this.itemEstoque[0] = new String("");
		this.idItemEstoque[0] = new Long(-1L);
		this.quantidadeMovimento[0] = new String("");
		this.valorUnitario[0] = new String("");
		this.valorTotal[0] = new String("");		
	}
	
	public Long getIndice() {
		return indice;
	}

	public void setIndice(Long indice) {
		this.indice = indice;
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