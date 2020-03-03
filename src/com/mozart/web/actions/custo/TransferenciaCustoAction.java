package com.mozart.web.actions.custo;

import java.util.Collections;
import java.util.Date;
import java.util.List;

import com.mozart.model.delegate.CustoDelegate;
import com.mozart.model.delegate.EstoqueDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.MovimentoEstoqueEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.TransferenciaCentroCustoVO;
import com.mozart.web.actions.BaseAction;

public class TransferenciaCustoAction extends BaseAction {

	private static final long serialVersionUID = -4797381933648578239L;

	protected TransferenciaCentroCustoVO filtro;
	
	private List <CentroCustoContabilEJB> centroCustoOrigemList;
	private List <CentroCustoContabilEJB> centroCustoDestinoList;
	private long idMovimentoEstoque;
	private long idCentroCustoOrigem;
	private long idCentroCustoDestino;
	private String tipoDocumento;
	private String numDocumento;
	private Date dataEmissao;
	private Date dataMovimento;
	
	public TransferenciaCustoAction() {
		this.filtro = new TransferenciaCentroCustoVO();
		centroCustoOrigemList = Collections.emptyList();
		centroCustoDestinoList = Collections.emptyList();
	}

	private void initCombo() throws MozartSessionException {
		
		CentroCustoContabilEJB filtroCentroCusto = new CentroCustoContabilEJB();
		filtroCentroCusto.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		List <CentroCustoContabilEJB> centroCustoList = RedeDelegate.instance().pesquisarCentroCusto(filtroCentroCusto);  
		centroCustoOrigemList = centroCustoList;
		centroCustoDestinoList = centroCustoList;
		
		dataEmissao = getControlaData().getEstoque();
		dataMovimento = getControlaData().getEstoque();
	}

	public String prepararPesquisa() throws MozartSessionException {
		
		this.request.setAttribute("filtro.DataMovimento.tipoIntervalo",
				"1");
		this.request.setAttribute("filtro.DataMovimento.valorInicial",
				MozartUtil.format(getControlaData().getEstoque(),
						"dd/MM/yyyy"));
		this.request.setAttribute("filtro.DataMovimento.valorFinal",
				MozartUtil.format(getControlaData().getEstoque(),
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
			List<TransferenciaCentroCustoVO> listaPesquisa = CustoDelegate
					.instance().pesquisarTransferenciaCentroCusto(this.filtro,
							getHotelCorrente());
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
	public String salvarTransferencia() throws MozartSessionException {
		try {
			
			initCombo();
			List<MovimentoEstoqueEJB> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUsuario());
			
			if(entidade.size() == 0) {
				addMensagemErro("Deve ser informado algum Item para Transferência.");
				prepararInclusao();
				return "sucesso";
			}
			for (MovimentoEstoqueEJB lancamento : entidade) {
				lancamento.setUsuario(getUsuario());
				lancamento.setHotel(hotel);
				lancamento.setRedeHotel(hotel.getRedeHotelEJB());
				
				lancamento.setDataMovimento(dataMovimento);
				
				
				if(!MozartUtil.isNull(numDocumento)){
					lancamento.setNumDocumento(numDocumento);
				}
				
				if(!MozartUtil.isNull(tipoDocumento)){
					lancamento.setTipoDocumento(tipoDocumento);
				}
				
				if(!MozartUtil.isNull(dataEmissao)){
					lancamento.setDataDocumento(dataEmissao);
				}
				
				/*if(!MozartUtil.isNull(movimentoEstoque.getSerieDocumento())){
					lancamento.setSerieDocumento(movimentoEstoque.getSerieDocumento());
				}*/
				
				if(!MozartUtil.isNull(idCentroCustoOrigem)){
					CentroCustoContabilEJB centroCustoContabil = new CentroCustoContabilEJB();
					centroCustoContabil.setIdCentroCustoContabil(idCentroCustoOrigem);
					lancamento.setCentroCustoContabil(centroCustoContabil);
				}
				
				lancamento.setTipoMovimento("T");
				lancamento.setIdMovimentoEstoque(EstoqueDelegate.instance().obterNextVal());
								
				EstoqueDelegate.instance().salvarMovimentoEstoqueReduzido(lancamento);
								
				lancamento.setTipoMovimento("R");
				if(!MozartUtil.isNull(idCentroCustoDestino)){
					CentroCustoContabilEJB centroCustoContabil = new CentroCustoContabilEJB();
					centroCustoContabil.setIdCentroCustoContabil(idCentroCustoDestino);
					lancamento.setCentroCustoContabil(centroCustoContabil);
				}
				lancamento.setIdMovimentoEstoque(EstoqueDelegate.instance().obterNextVal());
								
				EstoqueDelegate.instance().salvarMovimentoEstoqueReduzido(lancamento);
			
			}
			
			resetFields();
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
	
	private void resetFields(){
		numDocumento = "";
		idCentroCustoOrigem = 0;
		idCentroCustoDestino = 0;
		tipoDocumento = "";
	}
	
	public Date getDataMovimento() {
		return dataMovimento;
	}

	public void setDataMovimento(Date dataMovimento) {
		this.dataMovimento = dataMovimento;
	}

	public TransferenciaCentroCustoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(TransferenciaCentroCustoVO filtro) {
		this.filtro = filtro;
	}

	public List<CentroCustoContabilEJB> getCentroCustoOrigemList() {
		return centroCustoOrigemList;
	}

	public void setCentroCustoOrigemList(
			List<CentroCustoContabilEJB> centroCustoOrigemList) {
		this.centroCustoOrigemList = centroCustoOrigemList;
	}

	public List<CentroCustoContabilEJB> getCentroCustoDestinoList() {
		return centroCustoDestinoList;
	}

	public void setCentroCustoDestinoList(
			List<CentroCustoContabilEJB> centroCustoDestinoList) {
		this.centroCustoDestinoList = centroCustoDestinoList;
	}

	public long getIdCentroCustoOrigem() {
		return idCentroCustoOrigem;
	}

	public void setIdCentroCustoOrigem(long idCentroCustoOrigem) {
		this.idCentroCustoOrigem = idCentroCustoOrigem;
	}

	public long getIdCentroCustoDestino() {
		return idCentroCustoDestino;
	}

	public void setIdCentroCustoDestino(long idCentroCustoDestino) {
		this.idCentroCustoDestino = idCentroCustoDestino;
	}

	public String getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
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

	public long getIdMovimentoEstoque() {
		return idMovimentoEstoque;
	}

	public void setIdMovimentoEstoque(long idMovimentoEstoque) {
		this.idMovimentoEstoque = idMovimentoEstoque;
	}
	
}
