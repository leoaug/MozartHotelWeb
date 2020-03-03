package com.mozart.web.actions.caixa;

import com.mozart.model.delegate.CaixaGeralDelegate;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.EstoqueDelegate;
import com.mozart.model.delegate.NfeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.CheckinEJB;
import com.mozart.model.ejb.entity.FichaTecnicaPratoEJB;
import com.mozart.model.ejb.entity.ItemEstoqueEJB;
import com.mozart.model.ejb.entity.MovimentoApartamentoEJB;
import com.mozart.model.ejb.entity.MovimentoMiniPdvEJB;
import com.mozart.model.ejb.entity.PontoVendaEJB;
import com.mozart.model.ejb.entity.PontoVendaEJBPK;
import com.mozart.model.ejb.entity.PratoEJB;
import com.mozart.model.ejb.entity.PratoEJBPK;
import com.mozart.model.ejb.entity.PratoPontoVendaEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CaixaGeralVO;
import com.mozart.model.vo.ItemEstoqueVO;
import com.mozart.model.vo.MiniPdvVO;
import com.mozart.model.vo.MovimentoEstoqueVO;
import com.mozart.web.actions.BaseAction;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

public class MiniPDVAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	private MiniPdvVO filtro;
	//private MesaEJB entidade;
	private List <PontoVendaEJB> pontoVendaList;
	private List <CaixaGeralVO> apartamentoList;
	private Double qtde;
	private Double vlUnitario;
	private Double vlTotal;
	private Long id;
	private Long idCheckin, idPontoVenda, idPrato;
	private String comanda;
	
	
	//readonly
	private String numApartamento, nomePDV;
	
	
	private void initCombo(){
		
		
		
		
		warn("Preparando o mini pdv ");

		try {
			
				CaixaGeralVO param = new CaixaGeralVO();
				param.setIdHotel(getIdHoteis()[0]);
				param.setCofan("N");
				param.setStatus(";OA;OS;");
				apartamentoList = CaixaGeralDelegate.instance()
						.pesquisarApartamentoComCheckinEReserva(param);
			
			
			
			PontoVendaEJB pFiltroPDV = new PontoVendaEJB();
			pFiltroPDV.setId(new PontoVendaEJBPK());
			pFiltroPDV.getId().setIdHotel(getHotelCorrente().getIdHotel());
			pontoVendaList = CheckinDelegate.instance()
					.pesquisarPontoVendaByFiltro(pFiltroPDV);
			
			request.getSession().setAttribute("listaPDV", pontoVendaList);

			
			} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);

		} 		
		
		
	}
	
	
	
	public MiniPDVAction (){
		
		filtro = new MiniPdvVO();
		
	}
	
	
	@SuppressWarnings("unchecked")
	              
	public String gravarMiniPDV() {

		warn("Gravar o mini pdv");

		try {
			initCombo();	
			List<MovimentoMiniPdvEJB> listaMiniPDV = (List<MovimentoMiniPdvEJB>) request
					.getSession().getAttribute("movimentoMiniPDVList");

			if (MozartUtil.isNull(listaMiniPDV)) {
				addMensagemErro("Não existe lançamentos para gravar.");
				return SUCESSO_FORWARD;
			}

			PontoVendaEJB pFiltroPDV = new PontoVendaEJB();
			pFiltroPDV.setId(new PontoVendaEJBPK());
			pFiltroPDV.getId().setIdHotel(getHotelCorrente().getIdHotel());
			pFiltroPDV.getId().setIdPontoVenda(idPontoVenda);

			List<PontoVendaEJB> listaPDV = (List<PontoVendaEJB>) request
					.getSession().getAttribute("listaPDV");
			PontoVendaEJB pdv = listaPDV.get(listaPDV.indexOf(pFiltroPDV));

			CheckinEJB checkinCorrente = CheckinDelegate.instance().obterCheckin(idCheckin);

			MovimentoApartamentoEJB newMovApartamento = new MovimentoApartamentoEJB();
			newMovApartamento.setCheckinEJB(checkinCorrente);

			newMovApartamento.setTipoLancamentoEJB(pdv.getTipoLancamentoEJB());
			
				newMovApartamento.setRoomListEJB(checkinCorrente.getRoomListPrincipal());
				newMovApartamento.setQuemPaga("H");
			
			newMovApartamento.setNumDocumento(comanda);
			newMovApartamento.setDataLancamento(new Timestamp(
					getControlaData().getFrontOffice()
							.getTime()));
			newMovApartamento.setHoraLancamento(new Timestamp(new Date()
					.getTime()));
			newMovApartamento.setCheckout("N");
			newMovApartamento.setMovTmp("S");
			newMovApartamento.setIdRedeHotel(getHotelCorrente()
					.getRedeHotelEJB().getIdRedeHotel());

			newMovApartamento.setParcial("N");
			newMovApartamento.setIdTipoDiaria(null);
			newMovApartamento.setValorPensao(checkinCorrente.getApartamentoEJB().getCofan().equals("S")?null:checkinCorrente.getReservaEJB()
					.getValorPensao());

			Double quantidade = 0.0;
			
			if(getHotelCorrente().getResumoFiscal().equals("N")) {
				Double valorLancamento = 0.0;
				newMovApartamento
						.setMovimentoMiniPdvEJBList(new ArrayList<MovimentoMiniPdvEJB>());
				for (MovimentoMiniPdvEJB lancMiniPDV : listaMiniPDV) {
					lancMiniPDV.setIdRoomList(checkinCorrente.getRoomListPrincipal().getIdRoomList());
					newMovApartamento.addMovimentoMiniPdvEJB(lancMiniPDV);
					valorLancamento += lancMiniPDV.getValorTotal();
					quantidade += lancMiniPDV.getQuantidade();
				}
	
				newMovApartamento.setValorLancamento(valorLancamento);
				newMovApartamento.setUsuario( getUserSession().getUsuarioEJB() );
				CheckinDelegate.instance().incluir(newMovApartamento);
			}
			else
			{
				for (MovimentoMiniPdvEJB lancMiniPDV : listaMiniPDV) {
					newMovApartamento.setMovimentoMiniPdvEJBList(new ArrayList<MovimentoMiniPdvEJB>());
					lancMiniPDV.setIdRoomList(checkinCorrente.getRoomListPrincipal().getIdRoomList());
					newMovApartamento.addMovimentoMiniPdvEJB(lancMiniPDV);
					Double valorLancamento = lancMiniPDV.getValorTotal();
					quantidade += lancMiniPDV.getQuantidade();
					
					newMovApartamento.setNumDocumento(comanda + "-" + lancMiniPDV.getQuantidade().intValue() + "-" + lancMiniPDV.getPratoEJB().getNomePrato());
					newMovApartamento.setValorLancamento(valorLancamento);
					newMovApartamento.setUsuario( getUserSession().getUsuarioEJB() );
					
					CheckinDelegate.instance().incluir(newMovApartamento);
				}
			}
			
			CentroCustoContabilEJB centroCustoContabil = (CentroCustoContabilEJB) CheckinDelegate.instance().obter(CentroCustoContabilEJB.class, pdv.getIdCentroCustoContabil());
					
			if(centroCustoContabil != null && centroCustoContabil.getControlado().equals("S")) {
				for (MovimentoMiniPdvEJB lancMiniPDV : listaMiniPDV) {
					PratoEJB prato = (PratoEJB) CheckinDelegate.instance().obter(PratoEJB.class, lancMiniPDV.getPratoEJB().getId());
					for (FichaTecnicaPratoEJB fichaTecnicaEJB : prato.getFichaTecnicaPratoEJBList()) {
						if(fichaTecnicaEJB.getItemEstoqueEJB().getControlado().equals("S")) {
							MovimentoEstoqueVO movimentoEstoqueVO = new MovimentoEstoqueVO();
							movimentoEstoqueVO.setIdMovEstoque(EstoqueDelegate.instance().obterNextVal());
							movimentoEstoqueVO.setIdItem(fichaTecnicaEJB.getItemEstoqueEJB().getId().getIdItem());
							movimentoEstoqueVO.setIdHotel(getHotelCorrente().getIdHotel());
							movimentoEstoqueVO.setIdPontoVenda(idPontoVenda);
							movimentoEstoqueVO.setNumDocumento(comanda);
							movimentoEstoqueVO.setIdCentroCusto(centroCustoContabil.getIdCentroCustoContabil());
							movimentoEstoqueVO.setDtDocumento(newMovApartamento.getDataLancamento());
							movimentoEstoqueVO.setDtMovimento(newMovApartamento.getDataLancamento());
							movimentoEstoqueVO.setDsTipoMovimento("B");
							movimentoEstoqueVO.setVlQuantidade(lancMiniPDV.getQuantidade());
							movimentoEstoqueVO.setIdRedeHotel(getHotelCorrente()
									.getRedeHotelEJB().getIdRedeHotel());
							
							if(movimentoEstoqueVO.getIdMovEstoque() != null){
								EstoqueDelegate.instance().salvarFechamentoMovimentoEstoque(movimentoEstoqueVO);
							}
						}
					}
				}
			}
			
			prepararInclusao();
			addMensagemSucesso(MSG_SUCESSO);

			return SUCESSO_FORWARD;
			


		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			return SUCESSO_FORWARD;
		} 

	}
	
	
	
	
	@SuppressWarnings("unchecked")
	public String incluirMiniPDV() {

		warn("Incluir lancamento mini pdv ");

		try {
		initCombo();	
		List<MovimentoMiniPdvEJB> listaMiniPDV = (List<MovimentoMiniPdvEJB>) request
					.getSession().getAttribute("movimentoMiniPDVList");

			MovimentoMiniPdvEJB novoLancamento = new MovimentoMiniPdvEJB();
			novoLancamento.setData(getControlaData().getFrontOffice());
			novoLancamento.setIdPdv(idPontoVenda);
		
			PratoEJBPK pkPrato = new PratoEJBPK();
			pkPrato.setIdHotel(getHotelCorrente().getIdHotel());
			pkPrato.setIdPrato(idPrato);

			PratoEJB prato = new PratoEJB();
			prato.setId(pkPrato);

			PratoPontoVendaEJB ppp = new PratoPontoVendaEJB();
			ppp.setPratoEJB(prato);

			List<PratoPontoVendaEJB> pratoPDVList = (List<PratoPontoVendaEJB>) request
					.getSession().getAttribute("pratoPDVList");
			prato = pratoPDVList.get(pratoPDVList.indexOf(ppp)).getPratoEJB();
			novoLancamento.setPratoEJB(prato);
			novoLancamento.setQuantidade(qtde);
			novoLancamento.setValorTotal(prato.getValorPrato() * qtde);
			novoLancamento.setTipo("PRODUTO");

			listaMiniPDV.add(novoLancamento);
			
			qtde=null;
			vlTotal = null;
			vlUnitario = null;
			idPrato = null;
		
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);

		} return SUCESSO_FORWARD;
		
	}
	
	
	@SuppressWarnings("unchecked")
	public String excluirMiniPDV() {

		warn("Excluindo lancamento: " + id);

		try {
			initCombo();	
			List<MovimentoMiniPdvEJB> listaMiniPDV = (List<MovimentoMiniPdvEJB>) request
					.getSession().getAttribute("movimentoMiniPDVList");
			listaMiniPDV.remove(id.intValue());
			
		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);

		} 
			return SUCESSO_FORWARD;
	
	}
	
	public String prepararInclusao(){
		idCheckin = null;
		idPontoVenda = null;
		numApartamento = null;
		comanda = null;
		qtde = null;
		vlUnitario = null;
		vlTotal = null;
		initCombo();
		List<MovimentoMiniPdvEJB> listaMiniPDV = new ArrayList<MovimentoMiniPdvEJB>();
		request.getSession().setAttribute("movimentoMiniPDVList",
				listaMiniPDV);
		
		
		request.getSession().setAttribute("pratoPDVList", Collections.emptyList());
		return SUCESSO_FORWARD;
		
	}
		

		
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	
		public String prepararAlteracao() {
				
				try { 
				
			//	entidade=(MesaEJB) CheckinDelegate.instance().obter(MesaEJB.class, entidade.getIdMesa());
					
				} catch (Exception ex){
					error(ex.getMessage());
					addMensagemErro(MSG_ERRO);
					
				}
				
				return SUCESSO_FORWARD;
				
			}
			
			
		
			



	
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis(getIdHoteis());
			List<MiniPdvVO> lista = CaixaGeralDelegate.instance().pesquisarMiniPDV(filtro);
			if (MozartUtil.isNull(lista)){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			request.getSession().setAttribute(LISTA_PESQUISA, lista);
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}

	public MiniPdvVO getFiltro() {
		return filtro;
	}

	public void setFiltro(MiniPdvVO filtro) {
		this.filtro = filtro;
	}


	public List<PontoVendaEJB> getPontoVendaList() {
		return pontoVendaList;
	}


	public void setPontoVendaList(List<PontoVendaEJB> pontoVendaList) {
		this.pontoVendaList = pontoVendaList;
	}


	public List<CaixaGeralVO> getApartamentoList() {
		return apartamentoList;
	}


	public void setApartamentoList(List<CaixaGeralVO> apartamentoList) {
		this.apartamentoList = apartamentoList;
	}


	public Double getQtde() {
		return qtde;
	}


	public void setQtde(Double qtde) {
		this.qtde = qtde;
	}


	
	public Double getVlTotal() {
		return vlTotal;
	}


	public void setVlTotal(Double vlTotal) {
		this.vlTotal = vlTotal;
	}



	public Long getId() {
		return id;
	}



	public void setId(Long id) {
		this.id = id;
	}



	public Double getVlUnitario() {
		return vlUnitario;
	}



	public void setVlUnitario(Double vlUnitario) {
		this.vlUnitario = vlUnitario;
	}



	public Long getIdCheckin() {
		return idCheckin;
	}



	public void setIdCheckin(Long idCheckin) {
		this.idCheckin = idCheckin;
	}



	public Long getIdPontoVenda() {
		return idPontoVenda;
	}



	public void setIdPontoVenda(Long idPontoVenda) {
		this.idPontoVenda = idPontoVenda;
	}



	public Long getIdPrato() {
		return idPrato;
	}



	public void setIdPrato(Long idPrato) {
		this.idPrato = idPrato;
	}



	public String getComanda() {
		return comanda;
	}



	public void setComanda(String comanda) {
		this.comanda = comanda;
	}



	public String getNumApartamento() {
		return numApartamento;
	}



	public void setNumApartamento(String numApartamento) {
		this.numApartamento = numApartamento;
	}



	public String getNomePDV() {
		return nomePDV;
	}



	public void setNomePDV(String nomePDV) {
		this.nomePDV = nomePDV;
	}



	
}