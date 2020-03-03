package com.mozart.web.actions.operacional;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.GarconEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.GarconVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

import java.util.ArrayList;
import java.util.List;

public class GarconAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;
 
	private GarconVO filtro;
	private GarconEJB entidade;
	private List<MozartComboWeb> listaPadrao;
	
	public GarconAction (){
		
		filtro = new GarconVO();
		entidade = new GarconEJB();
		
	}
	
	
	public String prepararInclusao(){
		initCombo();
		return SUCESSO_FORWARD;
		
	}
	
	private void initCombo(){
		
		listaPadrao = new ArrayList<MozartComboWeb>();
        listaPadrao.add(new MozartComboWeb("S","Sim"));
        listaPadrao.add(new MozartComboWeb("N","Não"));
        		
	}
	
	
	public String prepararPesquisa(){
		
		request.setAttribute("filtro.filtroAtivo.tipoIntervalo", "3");
		request.setAttribute("filtro.filtroAtivo.valorInicial", "S");
			
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
public String prepararAlteracao() {
		
		try { 
			initCombo();
			entidade=(GarconEJB) CheckinDelegate.instance().obter(GarconEJB.class, entidade.getIdGarcon());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}


public String gravarGarcon() {
	try { 
		entidade.setUsuario(getUserSession().getUsuarioEJB());
		entidade.setIdHotel(getHotelCorrente().getIdHotel());
		
		
		if (MozartUtil.isNull(entidade.getIdGarcon())){
			CheckinDelegate.instance().incluir(entidade);
		} else {
		    CheckinDelegate.instance().alterar(entidade);	
		} 
		addMensagemSucesso(MSG_SUCESSO);
		entidade = new GarconEJB();
		
	} catch (Exception ex){
		error(ex.getMessage());
		addMensagemErro(MSG_ERRO);
		
	} finally{
		initCombo();
	}
	
	return SUCESSO_FORWARD; 
	
}
	
	
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis(getIdHoteis());
			List<GarconVO> lista = OperacionalDelegate.instance().pesquisarGarcon(filtro);
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

	public GarconVO getFiltro() {
		return filtro;
	}

	public void setFiltro(GarconVO filtro) {
		this.filtro = filtro;
	}


	public GarconEJB getEntidade() {
		return entidade;
	}


	public void setEntidade(GarconEJB entidade) {
		this.entidade = entidade;
	}


	public List<MozartComboWeb> getListaPadrao() {
		return listaPadrao;
	}


	public void setListaPadrao(List<MozartComboWeb> listaPadrao) {
		this.listaPadrao = listaPadrao;
	}

	
}