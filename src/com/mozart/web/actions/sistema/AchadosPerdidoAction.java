package com.mozart.web.actions.sistema;


import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.AchadosPerdidoEJB;
import com.mozart.model.ejb.entity.CidadeEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.AchadosPerdidoVO;
import com.mozart.model.vo.HospedeAchadosPerdidoVO;
import com.mozart.web.actions.BaseAction;

import java.util.Collections;
import java.util.List;


public class AchadosPerdidoAction extends BaseAction{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	
		private AchadosPerdidoVO filtro;
		private AchadosPerdidoEJB entidade;
		private List<HospedeAchadosPerdidoVO> hospedeAPList;
		private HospedeAchadosPerdidoVO ap;
		
		
	
	public AchadosPerdidoAction (){
		
		filtro = new AchadosPerdidoVO();
		entidade = new AchadosPerdidoEJB();
		hospedeAPList = Collections.emptyList();
		ap = new HospedeAchadosPerdidoVO();
	
	}
	
	private void initCombo() throws MozartSessionException {
		
		hospedeAPList = SistemaDelegate.instance().pesquisarHospedeAP(ap);
		
						
	}
	
	
	public String prepararInclusao(){
		try {
			initCombo();
			
			
		} catch (MozartSessionException e) {
			
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
			
		}
		return SUCESSO_FORWARD;
		
			
	}
	
	
	public String prepararAlteracao() {
		
		try { 
			initCombo();
			entidade=(AchadosPerdidoEJB)CheckinDelegate.instance().obter(CidadeEJB.class, entidade.getIdAchadosPerdidos());
				
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	
	
	public String gravar() {
		try { 
			
			entidade.setIdHotel(getHotelCorrente().getIdHotel());	
			initCombo();
			
						
			if (MozartUtil.isNull(entidade.getIdAchadosPerdidos())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new AchadosPerdidoEJB();

		} catch (MozartValidateException ex){
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} 		
		return SUCESSO_FORWARD; 
		
		
	}
	

	
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	
	public String pesquisar(){
		
		try{
			filtro.setIdHotel(getHotelCorrente().getIdHotel());
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			List<AchadosPerdidoVO> lista = SistemaDelegate.instance().pesquisarAchadosPerdido(filtro);
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

	public AchadosPerdidoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(AchadosPerdidoVO filtro) {
		this.filtro = filtro;
	}

	public AchadosPerdidoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(AchadosPerdidoEJB entidade) {
		this.entidade = entidade;
	}

	public List<HospedeAchadosPerdidoVO> getHospedeAPList() {
		return hospedeAPList;
	}

	public void setHospedeAPList(List<HospedeAchadosPerdidoVO> hospedeAPList) {
		this.hospedeAPList = hospedeAPList;
	}

	
}