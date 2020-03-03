package com.mozart.web.actions.operacional;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.ConfigFnrhEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;
import java.util.List;

public class ConfigFnrhAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	
	private ConfigFnrhEJB entidade;
	

	public ConfigFnrhAction (){
		
		entidade = new ConfigFnrhEJB();
		

	}

	public String excluir() throws MozartSessionException{
		
		try { 
			entidade=(ConfigFnrhEJB) CheckinDelegate.instance().obter(ConfigFnrhEJB.class, entidade.getIdConfig());
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			CheckinDelegate.instance().excluir(entidade);
			prepararPesquisa();
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
		
	}

	public String prepararInclusao() throws MozartSessionException{
		
		return SUCESSO_FORWARD;
		
	}
	

	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	
	public String prepararAlteracao() {
		
		try { 
			
			entidade=(ConfigFnrhEJB) CheckinDelegate.instance().obter(ConfigFnrhEJB.class, entidade.getIdConfig());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarConfigFnrh() {
		try { 
			
			entidade.setIdHotel(getIdHoteis()[0]);
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			if (MozartUtil.isNull(entidade.getIdConfig())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new ConfigFnrhEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	public String pesquisar(){
		
		try{
			entidade.setIdHotel(getIdHoteis()[0]);
			List<ConfigFnrhEJB> lista = OperacionalDelegate.instance().pesquisarConfigFnrh(entidade);
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

	public ConfigFnrhEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(ConfigFnrhEJB entidade) {
		this.entidade = entidade;
	}

}