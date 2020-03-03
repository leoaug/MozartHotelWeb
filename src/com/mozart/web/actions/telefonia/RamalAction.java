package com.mozart.web.actions.telefonia;

import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.TelefoniaDelegate;
import com.mozart.model.ejb.entity.ApartamentoEJB;
import com.mozart.model.ejb.entity.RamalTelefonicoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.RamalVO;
import com.mozart.web.actions.BaseAction;

public class RamalAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = -111664264335016598L;

	private RamalVO filtro;
	private RamalTelefonicoEJB entidade;

	private List<ApartamentoEJB> apartamentoList;

	public RamalAction(){
		filtro = new RamalVO(); 
		entidade = new RamalTelefonicoEJB();
	}
	
	public String excluir(){
		try{
			initCombo();
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			TelefoniaDelegate.instance().excluirRamalTelefonico(entidade);
			addMensagemSucesso(MSG_SUCESSO);
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}

	
	
	public String gravar(){
		try{
			initCombo();
			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			TelefoniaDelegate.instance().gravarRamalTelefonico(entidade);
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new RamalTelefonicoEJB();
		}catch(MozartValidateException ex){	
			error( ex.getMessage() );
			addMensagemSucesso( ex.getMessage() );
		
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}

	
	public String prepararInclusao(){
		try{
			initCombo();
			entidade.setInterno("N");
		
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}
	

	public String prepararAlteracao(){
		try{
			initCombo();
			entidade = (RamalTelefonicoEJB)CheckinDelegate.instance().obter(RamalTelefonicoEJB.class, entidade.getIdRamalTelefonico());
		
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}

	
	private void initCombo() throws MozartSessionException{ 	
		apartamentoList = Collections.emptyList();
		ApartamentoEJB filtro = new ApartamentoEJB(); 
		filtro.setIdHotel( getIdHoteis()[0]);
		apartamentoList = CheckinDelegate.instance().pesquisarApartamento(filtro);
	}

	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis( getIdHoteis() );
			List<RamalVO> lista = TelefoniaDelegate.instance().pesquisarRamal(filtro);
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


	public RamalVO getFiltro() {
		return filtro;
	}


	public void setFiltro(RamalVO filtro) {
		this.filtro = filtro;
	}



	public List<ApartamentoEJB> getApartamentoList() {
		return apartamentoList;
	}



	public void setApartamentoList(List<ApartamentoEJB> apartamentoList) {
		this.apartamentoList = apartamentoList;
	}



	public RamalTelefonicoEJB getEntidade() {
		return entidade;
	}



	public void setEntidade(RamalTelefonicoEJB entidade) {
		this.entidade = entidade;
	}
	
}
