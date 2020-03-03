package com.mozart.web.actions.operacional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.TipoItemEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class TipoItemAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	
	private TipoItemEJB entidade;
	private List <MozartComboWeb> apelidoList;
	

	public TipoItemAction (){
		
		entidade = new TipoItemEJB();
		apelidoList = Collections.emptyList();
		

	}
	
	private void initCombo() throws MozartSessionException {
		
		apelidoList = new ArrayList<MozartComboWeb>();
		apelidoList.add(new MozartComboWeb("A","Alimentos"));
		apelidoList.add(new MozartComboWeb("B","Bebidas"));
		apelidoList.add(new MozartComboWeb("O","Outros Produtos"));
		apelidoList.add(new MozartComboWeb("D","Diversos"));
		apelidoList.add(new MozartComboWeb("I","Imobilizado"));
		
	}
	

	public String prepararInclusao() throws MozartSessionException{
		initCombo();
		return SUCESSO_FORWARD;
		
	}
	

	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	
	public String prepararAlteracao() {
		
		try { 
			initCombo();
			entidade=(TipoItemEJB) CheckinDelegate.instance().obter(TipoItemEJB.class, entidade.getIdTipoItem());
			
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarTipoItem() {
		try { 
			
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			initCombo();
			if (MozartUtil.isNull(entidade.getIdTipoItem())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new TipoItemEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	public String pesquisar(){
		
		try{
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			List<TipoItemEJB> lista = OperacionalDelegate.instance().pesquisarTipoItem(entidade);
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

	public TipoItemEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(TipoItemEJB entidade) {
		this.entidade = entidade;
	}

	public List<MozartComboWeb> getApelidoList() {
		return apelidoList;
	}

	public void setApelidoList(List<MozartComboWeb> apelidoList) {
		this.apelidoList = apelidoList;
	}

}