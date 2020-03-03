package com.mozart.web.actions.estoque;

import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.EstoqueDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.MovimentoEstoqueEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.MovimentoEstoqueVO;
import com.mozart.web.actions.BaseAction;

public class LancamentoSaidaAction extends BaseAction {

	private static final long serialVersionUID = 1061118313934167130L;

	private MovimentoEstoqueVO filtro;
	protected MovimentoEstoqueEJB movimentoEstoque;
	protected List<CentroCustoContabilEJB> listCentrosCusto;
	
	protected Long idCentroCusto;
	
	private String tipoMovimento;

	public LancamentoSaidaAction() {
		this.listCentrosCusto = Collections.emptyList();
	}
	
	public String prepararSaida() {
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
		this.inicializarComboCentroCusto();
	}

	protected void inicializarComboCentroCusto()
			throws MozartSessionException {
		CentroCustoContabilEJB filtroCentroCustoContabil = new CentroCustoContabilEJB();
		filtroCentroCustoContabil.setIdRedeHotel(getHotelCorrente()
				.getRedeHotelEJB().getIdRedeHotel());
		this.listCentrosCusto = RedeDelegate.instance()
				.pesquisarCentroCusto(filtroCentroCustoContabil);
	}

	public String prepararEntrada() throws MozartSessionException {
		this.inicializarCombos();
		ControlaDataEJB cd = (ControlaDataEJB) CheckinDelegate.instance()
				.obter(ControlaDataEJB.class, getIdHoteis()[0]);
		this.request.getSession().setAttribute("CONTROLA_DATA_SESSION", cd);
		
		this.movimentoEstoque = new MovimentoEstoqueEJB();
		
		this.movimentoEstoque.setDataDocumento(cd.getEstoque());
			
		return SUCESSO_FORWARD;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String salvarSaida() throws MozartSessionException {
		try {
			
			List<MovimentoEstoqueEJB> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUsuario());
			
			for (MovimentoEstoqueEJB lancamento : entidade) {
				
				lancamento.setHotel(hotel);
				lancamento.setRedeHotel(hotel.getRedeHotelEJB());
				
				lancamento.setDataMovimento(getControlaData().getEstoque());
				
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
				
				if(!MozartUtil.isNull(idCentroCusto)){
					CentroCustoContabilEJB centroCustoContabil = new CentroCustoContabilEJB();
					centroCustoContabil.setIdCentroCustoContabil(idCentroCusto);
					lancamento.setCentroCustoContabil(centroCustoContabil);
				}
				
				lancamento.setTipoMovimento(tipoMovimento);
				lancamento.setIdMovimentoEstoque(EstoqueDelegate.instance().obterNextVal());
								
				EstoqueDelegate.instance().salvarSaidaMovimentoEstoque(lancamento);
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
	
	public Long getIdCentroCusto() {
		return idCentroCusto;
	}

	public void setIdCentroCusto(Long idCentroCusto) {
		this.idCentroCusto = idCentroCusto;
	}

	public List<CentroCustoContabilEJB> getListCentrosCusto() {
		return listCentrosCusto;
	}

	public void setListCentrosCusto(List<CentroCustoContabilEJB> listCentrosCusto) {
		this.listCentrosCusto = listCentrosCusto;
	}

	public String getTipoMovimento() {
		return tipoMovimento;
	}

	public void setTipoMovimento(String tipoMovimento) {
		this.tipoMovimento = tipoMovimento;
	}
}