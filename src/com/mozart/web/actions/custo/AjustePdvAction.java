package com.mozart.web.actions.custo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.CustoDelegate;
import com.mozart.model.delegate.EstoqueDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.MovimentoEstoqueEJB;
import com.mozart.model.ejb.entity.PontoVendaEJB;
import com.mozart.model.ejb.entity.PontoVendaEJBPK;
import com.mozart.model.ejb.entity.UsuarioCiRedeEJB;
import com.mozart.model.ejb.entity.UsuarioConsumoInternoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.AjustePdvVO;
import com.mozart.model.vo.ConsumoInternoVO;
import com.mozart.model.vo.UsuarioConsumoInternoVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class AjustePdvAction extends BaseAction {

	private static final long serialVersionUID = -4797381933648578239L;

	protected AjustePdvVO filtro;
	
	private List <PontoVendaEJB> pontoVendaList;
	private List <CentroCustoContabilEJB> centroCustoList;
	private long idPontoVenda;
	private long idMovimentoEstoque;
	//private String tipoDocumento;
	private String numDocumento;
	private String motivo;
	private Date dataEmissao;
	
	public AjustePdvAction() {
		centroCustoList = Collections.emptyList();
		this.filtro = new AjustePdvVO();
		pontoVendaList = Collections.emptyList();
	}

	private void initCombo() throws MozartSessionException {
		PontoVendaEJB pFiltroPDV = new PontoVendaEJB();
		pFiltroPDV.setId(new PontoVendaEJBPK());
		pFiltroPDV.getId().setIdHotel(
				getHotelCorrente().getIdHotel().longValue());
		pontoVendaList = CheckinDelegate.instance()
				.pesquisarPontoVendaByFiltro(pFiltroPDV);
	}
	
	public String prepararPesquisaRelatorio() throws MozartSessionException{
		
		CentroCustoContabilEJB filtroCentroCusto = new CentroCustoContabilEJB();
		filtroCentroCusto.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		centroCustoList = RedeDelegate.instance().pesquisarCentroCusto(filtroCentroCusto);  

		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
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
		
		//entidade=(UsuarioConsumoInternoEJB) CheckinDelegate.instance().obter(UsuarioConsumoInternoEJB.class, entidade.getId());
		//request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
		
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}

	public String pesquisar() throws MozartSessionException {

		try {
			List<AjustePdvVO> listaPesquisa = CustoDelegate
					.instance().pesquisarAjustePdv(this.filtro, getHotelCorrente());
			
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
	public String salvarAjustePdv() throws MozartSessionException {
		try {
			
			//initCombo();
			List<MovimentoEstoqueEJB> entidade = (List) this.request
					.getSession().getAttribute("entidadeSession");

			HotelEJB hotel = getHotelCorrente();
			hotel.setUsuario(getUsuario());
			
			if(entidade.size() == 0) {
				addMensagemErro("Deve ser informado algum Item para o Estoque PDV.");
				prepararInclusao();
				return "sucesso";
			}
			for (MovimentoEstoqueEJB lancamento : entidade) {
				lancamento.setUsuario(getUsuario());
				lancamento.setHotel(hotel);
				lancamento.setRedeHotel(hotel.getRedeHotelEJB());
				
				lancamento.setDataMovimento(dataEmissao);
				lancamento.setDataDocumento(dataEmissao);
				
				if(!MozartUtil.isNull(numDocumento)){
					lancamento.setNumDocumento(numDocumento);
				}
				
				if(!MozartUtil.isNull(motivo)){
					lancamento.setMotivo(motivo);
				}
				
//				if(!MozartUtil.isNull(tipoDocumento)){
//					lancamento.setTipoDocumento(tipoDocumento);
//				}

				PontoVendaEJBPK pontoVendaPk = new PontoVendaEJBPK();
				pontoVendaPk.setIdHotel(hotel.getIdHotel());
				pontoVendaPk.setIdPontoVenda(idPontoVenda);
				PontoVendaEJB pontoVenda = (PontoVendaEJB) CheckinDelegate.instance().obter(PontoVendaEJB.class, pontoVendaPk);

				if(!MozartUtil.isNull(pontoVenda)){
					CentroCustoContabilEJB centroCustoContabil = new CentroCustoContabilEJB();
					centroCustoContabil.setIdCentroCustoContabil(pontoVenda.getIdCentroCustoContabil());
					lancamento.setCentroCustoContabil(centroCustoContabil);
				}
								
				lancamento.setTipoMovimento("A");
				lancamento.setTipoDocumento("AjPDV");
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
		idPontoVenda = 0;
		motivo = "";
		dataEmissao = null;
	}
	
	
	public AjustePdvVO getFiltro() {
		return filtro;
	}

	public void setFiltro(AjustePdvVO filtro) {
		this.filtro = filtro;
	}

	public List<PontoVendaEJB> getPontoVendaList() {
		return pontoVendaList;
	}

	public void setPontoVendaList(List<PontoVendaEJB> pontoVendaList) {
		this.pontoVendaList = pontoVendaList;
	}

	public long getIdPontoVenda() {
		return idPontoVenda;
	}

	public void setIdPontoVenda(long idPontoVenda) {
		this.idPontoVenda = idPontoVenda;
	}

	public long getIdMovimentoEstoque() {
		return idMovimentoEstoque;
	}

	public void setIdMovimentoEstoque(long idMovimentoEstoque) {
		this.idMovimentoEstoque = idMovimentoEstoque;
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

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public List<CentroCustoContabilEJB> getCentroCustoList() {
		return centroCustoList;
	}

	public void setCentroCustoList(List<CentroCustoContabilEJB> centroCustoList) {
		this.centroCustoList = centroCustoList;
	}
}
