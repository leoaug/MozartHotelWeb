package com.mozart.web.actions.comercial;

import java.util.ArrayList;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.ejb.entity.GrupoEconomicoEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.GrupoEconomicoVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class GrupoEconomicoAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = -2162761811812465219L;

	
	
	private GrupoEconomicoEJB entidade;
	private GrupoEconomicoVO filtro;
	private List<MozartComboWeb> tipoGrupoList;
	
	public GrupoEconomicoAction(){
	
		tipoGrupoList = new ArrayList<MozartComboWeb>();
		tipoGrupoList.add( new MozartComboWeb("E","Empresa"));
		tipoGrupoList.add( new MozartComboWeb("H","Hotel"));
	}

	
	public String prepararPesquisa(){
		
		request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		info("Pesquisando grupo economico");
		try{
			
			request.getSession().removeAttribute("listaPesquisa");
			filtro.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
			filtro.setIdHoteis( getIdHoteis());
			List<GrupoEconomicoVO> listaPesquisa = ComercialDelegate.instance().pesquisarGrupoEconomico(filtro);
			if (MozartUtil.isNull(listaPesquisa)){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
				return SUCESSO_FORWARD;
			}
			request.getSession().setAttribute("listaPesquisa", listaPesquisa);
			return SUCESSO_FORWARD;
		}catch(Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			return SUCESSO_FORWARD;
		}
	}

	
	
	public String prepararInclusao(){
		
		entidade = new GrupoEconomicoEJB();
		return SUCESSO_FORWARD;
	}
	

	public String prepararAlteracao(){
		
		try{
			entidade = (GrupoEconomicoEJB)CheckinDelegate.instance().obter(GrupoEconomicoEJB.class, entidade.getIdGrupoEconomico() );
		
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( ex.getMessage() );
		}
		return SUCESSO_FORWARD;

	}

	
	public String gravar(){
		
		try{

			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			if ( MozartUtil.isNull( entidade.getIdGrupoEconomico() )){
			
				CheckinDelegate.instance().incluir(entidade);
			}else{
				CheckinDelegate.instance().alterar(entidade);
				
			}
			addMensagemSucesso( MSG_SUCESSO );
			
			return prepararInclusao();
		}catch(Exception ex){
			error(ex.getMessage());
			addActionError( MSG_ERRO );
			return SUCESSO_FORWARD;
		}
		
	}

	public GrupoEconomicoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(GrupoEconomicoEJB entidade) {
		this.entidade = entidade;
	}

	public GrupoEconomicoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(GrupoEconomicoVO filtro) {
		this.filtro = filtro;
	}


	public List<MozartComboWeb> getTipoGrupoList() {
		return tipoGrupoList;
	}


	public void setTipoGrupoList(List<MozartComboWeb> tipoGrupoList) {
		this.tipoGrupoList = tipoGrupoList;
	}

	
	
}
