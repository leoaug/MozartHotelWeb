package com.mozart.web.actions.custo;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.CustoDelegate;
import com.mozart.model.delegate.EstoqueDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.ItemEstoqueEJB;
import com.mozart.model.ejb.entity.ItemEstoqueEJBPK;
import com.mozart.model.ejb.entity.MovimentoCiEJB;
import com.mozart.model.ejb.entity.MovimentoEstoqueEJB;
import com.mozart.model.ejb.entity.PontoVendaEJB;
import com.mozart.model.ejb.entity.PontoVendaEJBPK;
import com.mozart.model.ejb.entity.PratoEJB;
import com.mozart.model.ejb.entity.PratoEJBPK;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ConsumoInternoVO;
import com.mozart.model.vo.ItemEstoqueVO;
import com.mozart.model.vo.PratoConsumoInternoVO;
import com.mozart.web.actions.BaseAction;

public class ConsumoInternoAction extends BaseAction {

	private static final long serialVersionUID = -4797381933648578239L;

	protected ConsumoInternoVO filtro;
	
	private List <ConsumoInternoVO> usuarioList;
	private List <ConsumoInternoVO> pontoVendaList;
	private long idPontoVenda;
	private long idUsuario;
	private String numDocumento;
	private Date dataEmissao;
	private String pensao;
	
	public ConsumoInternoAction() {
		this.filtro = new ConsumoInternoVO();
		usuarioList = Collections.emptyList();
		pontoVendaList = Collections.emptyList();
	}

	private void initCombo() throws MozartSessionException {
		List <ConsumoInternoVO> comboUsuario = CustoDelegate.instance().pesquisarComboUsuarioConsumoInterno(getHotelCorrente());
		List <ConsumoInternoVO> comboPontoVenda = CustoDelegate.instance().pesquisarComboPontoVendaConsumoInterno(getHotelCorrente());
		usuarioList = comboUsuario;
		pontoVendaList = comboPontoVenda;
	}
	
	private void clear() throws MozartSessionException {
		idUsuario = 0;
		idPontoVenda = 0;
		numDocumento = "";
		dataEmissao = null;
		pensao = "";
	}

	public String prepararPesquisa() throws MozartSessionException {
		
		this.request.setAttribute("filtro.dataMovimento.tipoIntervalo",
				"1");
		this.request.setAttribute("filtro.dataMovimento.valorInicial",
				MozartUtil.format(getControlaData().getFrontOffice(),
						"dd/MM/yyyy"));
		this.request.setAttribute("filtro.dataMovimento.valorFinal",
				MozartUtil.format(getControlaData().getFrontOffice(),
						"dd/MM/yyyy"));
		
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}

	public String prepararInclusao() throws MozartSessionException {
		initCombo();
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}

	public String prepararAlteracao() throws MozartSessionException {
		initCombo();
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}

	public String pesquisar() throws MozartSessionException {

		try {
			List<ConsumoInternoVO> listaPesquisa = CustoDelegate
					.instance().pesquisarConsumoInterno(this.filtro);
			if (MozartUtil.isNull(listaPesquisa)) {
				addMensagemSucesso("Nenhum resultado encontrado.");
			}
			this.request.getSession().setAttribute("listaPesquisa",
					listaPesquisa);
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro("Erro ao realizar operação.");
		}

		return SUCESSO_FORWARD;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String salvarConsumo() throws MozartSessionException {
		try {
			
			initCombo();
			List<ConsumoInternoVO> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUsuario());
			
			if(entidade.size() == 0) {
				addMensagemErro("Deve ser informado algum Item para Transferência.");
				prepararInclusao();
				return "sucesso";
			}
			for (ConsumoInternoVO lancamento : entidade) {
				
				MovimentoEstoqueEJB movimento = new MovimentoEstoqueEJB();
				
				movimento.setUsuario(getUsuario());
				movimento.setHotel(hotel);
				movimento.setRedeHotel(hotel.getRedeHotelEJB());
				
				if(!MozartUtil.isNull(numDocumento)){
					movimento.setNumDocumento(numDocumento);
				}
			
				if(!MozartUtil.isNull(dataEmissao)){
					movimento.setDataDocumento(dataEmissao);
					movimento.setDataMovimento(dataEmissao);
				}
				
				PontoVendaEJBPK pontoVendaPk = new PontoVendaEJBPK();
				pontoVendaPk.setIdHotel(hotel.getIdHotel());
				pontoVendaPk.setIdPontoVenda(idPontoVenda);
				
				PontoVendaEJB pontoVenda = (PontoVendaEJB)CheckinDelegate.instance().obter(PontoVendaEJB.class, pontoVendaPk);
				if(!MozartUtil.isNull(pontoVenda.getIdCentroCustoContabil())){
					CentroCustoContabilEJB centroCusto = (CentroCustoContabilEJB)CheckinDelegate.instance().obter(CentroCustoContabilEJB.class, pontoVenda.getIdCentroCustoContabil());
					movimento.setCentroCustoContabil(centroCusto);
				}
				
				PratoConsumoInternoVO filtroMov = new PratoConsumoInternoVO();
				filtroMov.setIdPrato(lancamento.getIdPrato());
				filtroMov.setIdHotel(hotel.getIdHotel());
				filtroMov.setQuantidade(lancamento.getQuantidade());
				List<ItemEstoqueVO> listItemEstoqueVO = CustoDelegate.instance().pesquisarItemEstoqueConsumoInterno(filtroMov);
				
				for (ItemEstoqueVO itemEstoqueVO : listItemEstoqueVO) {
					if(!MozartUtil.isNull(itemEstoqueVO)){
						ItemEstoqueEJBPK itemEstoquePK = new ItemEstoqueEJBPK();
						itemEstoquePK.setIdHotel(hotel.getIdHotel());
						itemEstoquePK.setIdItem(itemEstoqueVO.getIdItem());
						
						ItemEstoqueEJB itemEstoque = (ItemEstoqueEJB) CheckinDelegate.instance().obter(ItemEstoqueEJB.class, itemEstoquePK);
						movimento.setItem(itemEstoque);
						movimento.setQuantidade(!MozartUtil.isNull(itemEstoqueVO.getQuantidadeConsumoInterno()) ? new BigDecimal(itemEstoqueVO.getQuantidadeConsumoInterno()) : null);
						movimento.setValorUnitario(!MozartUtil.isNull(itemEstoqueVO.getVlUnitario()) ? new BigDecimal(itemEstoqueVO.getVlUnitario()) : null );
						movimento.setValorTotal(!MozartUtil.isNull(itemEstoqueVO.getVlTotal()) ? new BigDecimal(itemEstoqueVO.getVlTotal()) : null);
					}
					
					movimento.setTipoDocumento("CI");
					movimento.setTipoMovimento("C");
					movimento.setIdMovimentoEstoque(EstoqueDelegate.instance().obterNextVal());
					
					EstoqueDelegate.instance().salvarMovimentoEstoqueReduzido(movimento);
				}
				
				MovimentoCiEJB movimentoCi = new MovimentoCiEJB();
				movimentoCi.setIdUsuariosConsumoInterno(idUsuario);
				movimentoCi.setHotel(hotel);
				
				movimentoCi.setPontoVendaEJB(pontoVenda);
				
				PratoEJBPK pratoPk = new PratoEJBPK();
				pratoPk.setIdHotel(hotel.getIdHotel());
				pratoPk.setIdPrato(lancamento.getIdPrato());
				
				PratoEJB prato = (PratoEJB)CheckinDelegate.instance().obter(PratoEJB.class, pratoPk);
				movimentoCi.setPratoEJB(prato);
				
				movimentoCi.setDataMovimento(dataEmissao);
				movimentoCi.setQuantidade(new BigDecimal(lancamento.getQuantidade()));
				movimentoCi.setValorUnitarioCusto(new BigDecimal(lancamento.getCusto()));
				movimentoCi.setValorUnitarioVenda(new BigDecimal(lancamento.getVenda()));
				
				if(!MozartUtil.isNull(numDocumento)){
					movimentoCi.setNumDocumento(numDocumento);
				}
				
				movimentoCi.setIdMovimentoCi(CustoDelegate.instance().obterSeqMovimentoCiNextVal());
				
				CheckinDelegate.instance().incluir(movimentoCi);
				//CustoDelegate.instance().salvarMovimentoCi(movimentoCi);
			}
			clear();
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

	public ConsumoInternoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ConsumoInternoVO filtro) {
		this.filtro = filtro;
	}

	public List<ConsumoInternoVO> getUsuarioList() {
		return usuarioList;
	}

	public void setUsuarioList(List<ConsumoInternoVO> usuarioList) {
		this.usuarioList = usuarioList;
	}

	public long getIdPontoVenda() {
		return idPontoVenda;
	}

	public void setIdPontoVenda(long idPontoVenda) {
		this.idPontoVenda = idPontoVenda;
	}

	public long getIdUsuario() {
		return idUsuario;
	}

	public void setIdUsuario(long idUsuario) {
		this.idUsuario = idUsuario;
	}

	public String getNumDocumento() {
		return numDocumento;
	}

	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
	}

	public Date getDataEmissao() {
		return dataEmissao;
	}

	public void setDataEmissao(Date dataEmissao) {
		this.dataEmissao = dataEmissao;
	}

	public String getPensao() {
		return pensao;
	}

	public void setPensao(String pensao) {
		this.pensao = pensao;
	}

	public List<ConsumoInternoVO> getPontoVendaList() {
		return pontoVendaList;
	}

	public void setPontoVendaList(List<ConsumoInternoVO> pontoVendaList) {
		this.pontoVendaList = pontoVendaList;
	}
}
