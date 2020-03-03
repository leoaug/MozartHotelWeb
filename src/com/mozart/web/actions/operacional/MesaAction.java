package com.mozart.web.actions.operacional;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.MesaEJB;
import com.mozart.model.ejb.entity.PontoVendaEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.GarconVO;
import com.mozart.model.vo.MesaVO;
import com.mozart.model.vo.PontoVendaVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class MesaAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	private List <GarconVO> garconList;
	private List <PontoVendaVO> pvList;
	private List<MozartComboWeb> statusList;
	private MesaVO filtro;
	private MesaEJB entidade;
	
	
	public MesaAction (){
		
		filtro = new MesaVO();
		garconList = Collections.emptyList();
		pvList = Collections.emptyList();
		statusList = Collections.emptyList();
		entidade = new MesaEJB();
	}
	
private void initCombo() throws MozartSessionException {
		
		GarconVO filtroGarcon = new GarconVO();
		filtroGarcon.setIdHoteis(getIdHoteis());
		PontoVendaVO filtroPontoVenda = new PontoVendaVO();
		filtroPontoVenda.setIdHoteis(getIdHoteis());
		
		garconList = OperacionalDelegate.instance().pesquisarGarcon(filtroGarcon);
		pvList = OperacionalDelegate.instance().pesquisarPontoVenda(filtroPontoVenda);
		statusList = new ArrayList<MozartComboWeb>();
		statusList.add(new MozartComboWeb("O","Ocupado"));
		statusList.add(new MozartComboWeb("L","Livre"));
		statusList.add(new MozartComboWeb("R","Reservado"));
		statusList.add(new MozartComboWeb("M","Manutenção"));
		
}
	
	
	public String prepararInclusao(){
		try{
			initCombo();
			entidade = new MesaEJB();
			entidade.setStatusMesa("L");
		}catch (MozartSessionException e){
			
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
				
		return SUCESSO_FORWARD;
		
	}
		

		
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	
	
		public String prepararAlteracao() {
				
				try { 
					initCombo();
					entidade=(MesaEJB) CheckinDelegate.instance().obter(MesaEJB.class, entidade.getIdMesa());
					
				} catch (Exception ex){
					error(ex.getMessage());
					addMensagemErro(MSG_ERRO);
					
				}
				
				return SUCESSO_FORWARD;
				
			}
			
			
		public String gravarMesa() {
			try { 
				
				entidade.getPontoVenda().getId().setIdHotel(getIdHoteis()[0]);
				entidade.setPontoVenda((PontoVendaEJB)CheckinDelegate.instance().obter(PontoVendaEJB.class, entidade.getPontoVenda().getId()));
				initCombo();
				
				if (MozartUtil.isNull(entidade.getIdMesa())){
					CheckinDelegate.instance().incluir(entidade);
				} else {
				    CheckinDelegate.instance().alterar(entidade);	
				} 
				addMensagemSucesso(MSG_SUCESSO);
				entidade = new MesaEJB();
				
			} catch (Exception ex){
				error(ex.getMessage());
				addMensagemErro(MSG_ERRO);
				
			} finally{
				
			}
			
			return SUCESSO_FORWARD; 
			
		}
			



	
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis(getIdHoteis());
			List<MesaVO> lista = OperacionalDelegate.instance().pesquisarMesa(filtro);
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

	public MesaVO getFiltro() {
		return filtro;
	}

	public void setFiltro(MesaVO filtro) {
		this.filtro = filtro;
	}

	public MesaEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(MesaEJB entidade) {
		this.entidade = entidade;
	}

	public List<GarconVO> getGarconList() {
		return garconList;
	}

	public void setGarconList(List<GarconVO> garconList) {
		this.garconList = garconList;
	}

	public List<PontoVendaVO> getPvList() {
		return pvList;
	}

	public void setPvList(List<PontoVendaVO> pvList) {
		this.pvList = pvList;
	}

	public List<MozartComboWeb> getStatusList() {
		return statusList;
	}

	public void setStatusList(List<MozartComboWeb> statusList) {
		this.statusList = statusList;
	}

	
}