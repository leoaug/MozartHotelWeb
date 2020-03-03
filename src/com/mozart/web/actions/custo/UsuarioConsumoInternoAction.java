package com.mozart.web.actions.custo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.CustoDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.UsuarioCiRedeEJB;
import com.mozart.model.ejb.entity.UsuarioConsumoInternoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.UsuarioConsumoInternoVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class UsuarioConsumoInternoAction extends BaseAction {

	private static final long serialVersionUID = -4797381933648578239L;

	protected UsuarioConsumoInternoVO filtro;
	
	private List <CentroCustoContabilEJB> centroCustoList;
	private List<HotelEJB> hoteisList;
	private List<MozartComboWeb> pensaoList;
	private List<MozartComboWeb> alcoolicoList;
	private List<MozartComboWeb> ativoList;
	private UsuarioConsumoInternoEJB entidade;
	
	public UsuarioConsumoInternoAction() {
		this.filtro = new UsuarioConsumoInternoVO();
		centroCustoList = Collections.emptyList();
		hoteisList = Collections.emptyList();
		pensaoList = new ArrayList<MozartComboWeb>();
		alcoolicoList = new ArrayList<MozartComboWeb>();
		ativoList = new ArrayList<MozartComboWeb>();
		entidade = new UsuarioConsumoInternoEJB();
	}

	private void initCombo() throws MozartSessionException {
		CentroCustoContabilEJB filtroCentroCusto = new CentroCustoContabilEJB();
		filtroCentroCusto.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		centroCustoList = RedeDelegate.instance().pesquisarCentroCusto(filtroCentroCusto);
		hoteisList = CustoDelegate.instance().obterHoteis(getHotelCorrente()); 
		pensaoList.add(new MozartComboWeb("NAO", "Sem café da manhã"));
		pensaoList.add(new MozartComboWeb("SIM", "Com café da manhã"));
		pensaoList.add(new MozartComboWeb("MAP", "Meia Pensão"));
		pensaoList.add(new MozartComboWeb("FAP", "Pensão Completa"));
		pensaoList.add(new MozartComboWeb("ALL", "Tudo Incluso"));
		
		ativoList.add(new MozartComboWeb("N", "Não"));
		ativoList.add(new MozartComboWeb("S", "Sim"));
		
		alcoolicoList.add(new MozartComboWeb("N", "Não"));
		alcoolicoList.add(new MozartComboWeb("S", "Sim"));
	}

	public String prepararPesquisa() throws MozartSessionException {
		request.setAttribute("filtro.Ativo.tipoIntervalo", "1");
		request.setAttribute("filtro.Ativo.valorInicial", "S");
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}

	public String prepararInclusao() throws MozartSessionException {
		initCombo();
		entidade.setAlcoolica("N");
		entidade.setAtivo("S");
		request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}

	public String prepararAlteracao() throws MozartSessionException {
		initCombo();
		
		entidade=(UsuarioConsumoInternoEJB) CheckinDelegate.instance().obter(UsuarioConsumoInternoEJB.class, entidade.getId());
		request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
		
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}

	public String pesquisar() throws MozartSessionException {

		try {
			List<UsuarioConsumoInternoVO> listaPesquisa = CustoDelegate
					.instance().pesquisarConsumoInternoUsuario(this.filtro,
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

	public String adicionarHotelLote() throws MozartSessionException{
		try{
			initCombo();
			UsuarioConsumoInternoEJB entidadeSession = (UsuarioConsumoInternoEJB) request.getSession().getAttribute(ENTIDADE_SESSION);
			entidadeSession.setHotelEJBList(new ArrayList<UsuarioCiRedeEJB>());
			for(HotelEJB hotel :hoteisList){
				UsuarioCiRedeEJB novoHotel = new UsuarioCiRedeEJB();
				novoHotel.setUsuarioConsumoInternoEJB(entidadeSession);
				novoHotel.setHotel(hotel);
				novoHotel.setRedeHotel(getHotelCorrente().getRedeHotelEJB());
	            entidadeSession.addHotel ( novoHotel );   
			}
		}catch (MozartSessionException e){
			
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String removerHotelLote() throws MozartSessionException{
		try{
			initCombo();
			UsuarioConsumoInternoEJB entidadeSession = (UsuarioConsumoInternoEJB) request.getSession().getAttribute(ENTIDADE_SESSION);
			entidadeSession.setHotelEJBList(null);
		}catch (MozartSessionException e){
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		return SUCESSO_FORWARD;
	}
	
	public String gravarUsuarioConsumo() {
		try { 
			UsuarioConsumoInternoEJB entidadeSession = (UsuarioConsumoInternoEJB) request.getSession().getAttribute(ENTIDADE_SESSION);
			entidade.setRedeHotel(getHotelCorrente().getRedeHotelEJB());
			entidade.setHotel(getHotelCorrente());
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			initCombo();
			
			if(!MozartUtil.isNull(entidadeSession.getHotelEJBList())){
				
				entidade.setHotelEJBList(new ArrayList<UsuarioCiRedeEJB>());
				for(UsuarioCiRedeEJB linha:entidadeSession.getHotelEJBList()){
					linha.setId(null);
					linha.setRedeHotel(getHotelCorrente().getRedeHotelEJB());
					linha.setHotel((HotelEJB)CustoDelegate.instance().obterHotelPorId(linha.getHotel().getIdHotel()));
					entidade.addHotel(linha);
				}
			}
		
			CustoDelegate.instance().gravarUsuarioConsumo(entidade);
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new UsuarioConsumoInternoEJB();
			request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	public UsuarioConsumoInternoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(UsuarioConsumoInternoVO filtro) {
		this.filtro = filtro;
	}

	public List<CentroCustoContabilEJB> getCentroCustoList() {
		return centroCustoList;
	}

	public void setCentroCustoList(List<CentroCustoContabilEJB> centroCustoList) {
		this.centroCustoList = centroCustoList;
	}

	public List<HotelEJB> getHoteisList() {
		return hoteisList;
	}

	public void setHoteisList(List<HotelEJB> hoteisList) {
		this.hoteisList = hoteisList;
	}

	public UsuarioConsumoInternoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(UsuarioConsumoInternoEJB entidade) {
		this.entidade = entidade;
	}

	public List<MozartComboWeb> getPensaoList() {
		return pensaoList;
	}

	public void setPensaoList(List<MozartComboWeb> pensaoList) {
		this.pensaoList = pensaoList;
	}

	public List<MozartComboWeb> getAlcoolicoList() {
		return alcoolicoList;
	}

	public void setAlcoolicoList(List<MozartComboWeb> alcoolicoList) {
		this.alcoolicoList = alcoolicoList;
	}

	public List<MozartComboWeb> getAtivoList() {
		return ativoList;
	}

	public void setAtivoList(List<MozartComboWeb> ativoList) {
		this.ativoList = ativoList;
	}
	
	

}
