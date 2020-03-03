package com.mozart.web.actions.empresa;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.EmpresaDelegate;
import com.mozart.model.ejb.entity.TipoEmpresaEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.TipoEmpresaVO;
import com.mozart.web.actions.BaseAction;
import java.util.List;

public class TipoEmpresaAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	private TipoEmpresaVO filtro;
	private TipoEmpresaEJB entidade;
	
	
	public TipoEmpresaAction  (){
		
		filtro = new TipoEmpresaVO();
		entidade = new TipoEmpresaEJB();
		
	}
	
	public String prepararInclusao (){
		
		
		return SUCESSO_FORWARD;	
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
public String prepararAlteracao() {
		
		try { 
		
			entidade=(TipoEmpresaEJB) CheckinDelegate.instance().obter(TipoEmpresaEJB.class, entidade.getIdTipoEmpresa());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	
	
	public String gravarTipoEmpresa() {
		try { 
			entidade.setIdHotel(getHotelCorrente().getIdHotel());
			entidade.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
			if (MozartUtil.isNull(entidade.getIdTipoEmpresa())){
				CheckinDelegate.instance().incluir(entidade);
				} 
			else {
			
				CheckinDelegate.instance().alterar(entidade);
		
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new TipoEmpresaEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis(getIdHoteis());
			List<TipoEmpresaVO> lista = EmpresaDelegate.instance().pesquisarTipoEmpresa(filtro);
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

	public TipoEmpresaVO getFiltro() {
		return filtro;
	}

	public void setFiltro(TipoEmpresaVO filtro) {
		this.filtro = filtro;
	}

	public TipoEmpresaEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(TipoEmpresaEJB entidade) {
		this.entidade = entidade;
	}

	
}