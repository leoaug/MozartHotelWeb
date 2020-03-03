package com.mozart.web.actions.controladoria;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ControladoriaDelegate;
import com.mozart.model.ejb.entity.TipoPensaoEJB;
import com.mozart.model.ejb.entity.ValorCafeEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ValorCafeVO;
import com.mozart.web.actions.BaseAction;
import java.util.Collections;
import java.util.List;


public class ValorCafeAction extends BaseAction{
	/**
	 * 
	*/
	private static final long serialVersionUID = 1L;

	private List<TipoPensaoEJB> pensaoList;
	private ValorCafeEJB entidade;
	private ValorCafeVO filtro;
	
	
	
	public ValorCafeAction (){
		
		entidade = new ValorCafeEJB();
		pensaoList = Collections.emptyList();
		filtro = new ValorCafeVO();
		
	}
	
	private void initCombo() throws MozartSessionException {
		
		pensaoList = ControladoriaDelegate.instance().pesquisarTipoPensao();
						
	}
	
	public String prepararInclusao(){
		
		try {
			initCombo();
			entidade.setData(getControlaData().getFrontOffice());
			
			
		} catch (MozartSessionException e) {
			
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
			entidade=(ValorCafeEJB)CheckinDelegate.instance().obter(ValorCafeEJB.class, entidade.getIdValorCafe());
				
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarValorCafe() {
		try { 
			entidade.setIdHotel(getHotelCorrente().getIdHotel());
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			initCombo();
			
						
			if (MozartUtil.isNull(entidade.getIdValorCafe())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new ValorCafeEJB();
			entidade.setData(getControlaData().getFrontOffice());

		} catch (MozartValidateException ex){
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} 		
		return SUCESSO_FORWARD; 
		
		
	}
		
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis(getIdHoteis());
			List<ValorCafeVO> lista = ControladoriaDelegate.instance().pesquisarValorCafe(filtro);
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

	
	public ValorCafeEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(ValorCafeEJB entidade) {
		this.entidade = entidade;
	}

	public ValorCafeVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ValorCafeVO filtro) {
		this.filtro = filtro;
	}

	public List<TipoPensaoEJB> getPensaoList() {
		return pensaoList;
	}

	public void setPensaoList(List<TipoPensaoEJB> pensaoList) {
		this.pensaoList = pensaoList;
	}

	
}