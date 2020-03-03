package com.mozart.web.actions.controladoria;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ControladoriaDelegate;
import com.mozart.model.ejb.entity.MoedaEJB;
import com.mozart.model.ejb.entity.ValorDolarEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ValorDolarVO;
import com.mozart.web.actions.BaseAction;
import java.util.Collections;
import java.util.List;


public class ValorDolarAction extends BaseAction{
	/**
	 * 
	*/
	private static final long serialVersionUID = 1L;

	private List<MoedaEJB> moedaList;
	private ValorDolarEJB entidade;
	private ValorDolarVO filtro;
	
	
	
	public ValorDolarAction (){
		
		entidade = new ValorDolarEJB();
		moedaList = Collections.emptyList();
		filtro = new ValorDolarVO();
		
	}
	
	private void initCombo() throws MozartSessionException {
		
		moedaList = CheckinDelegate.instance().pesquisarMoeda();
						
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
			entidade=(ValorDolarEJB)CheckinDelegate.instance().obter(ValorDolarEJB.class, entidade.getIdValorDolar());
				
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarValorDolar() {
		try { 
			entidade.setIdHotel(getHotelCorrente().getIdHotel());
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			initCombo();
			
						
			if (MozartUtil.isNull(entidade.getIdValorDolar())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new ValorDolarEJB();
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
			List<ValorDolarVO> lista = ControladoriaDelegate.instance().pesquisarValorDolar(filtro);
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

	public List<MoedaEJB> getMoedaList() {
		return moedaList;
	}

	public void setMoedaList(List<MoedaEJB> moedaList) {
		this.moedaList = moedaList;
	}

	public ValorDolarEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(ValorDolarEJB entidade) {
		this.entidade = entidade;
	}

	public ValorDolarVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ValorDolarVO filtro) {
		this.filtro = filtro;
	}

}