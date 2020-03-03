package com.mozart.web.actions.comercial;


import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.ejb.entity.TarifaGrupoEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.TarifaGrupoVO;
import com.mozart.web.actions.BaseAction;

@SuppressWarnings({"serial"})
public class GrupoTarifaAction extends BaseAction{

	
	private TarifaGrupoEJB entidade;
	private TarifaGrupoVO filtro;
	

	
	
	
	public GrupoTarifaAction(){
		
	}
	public String prepararPesquisa(){
		
		request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		info("Pesquisando tarifa grupo");
		try{
			
			request.getSession().removeAttribute("listaPesquisa");
			filtro.setIdHoteis( getIdHoteis() );
			filtro.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
			List<TarifaGrupoVO> listaPesquisa = ComercialDelegate.instance().pesquisarTarifaGrupo(filtro);
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
		
		entidade = new TarifaGrupoEJB();
		return SUCESSO_FORWARD;
	}
	

	public String prepararAlteracao(){
		
		try{
			entidade = (TarifaGrupoEJB)CheckinDelegate.instance().obter(TarifaGrupoEJB.class, entidade.getIdTarifaGrupo() );
		
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( ex.getMessage() );
		}
		return SUCESSO_FORWARD;

	}

	
	public String gravar(){
		
		try{

			entidade.setIdHotel( getIdHoteis()[0] );
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			if ( MozartUtil.isNull( entidade.getIdTarifaGrupo() )){
			
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



	public TarifaGrupoEJB getEntidade() {
		return entidade;
	}


	public void setEntidade(TarifaGrupoEJB entidade) {
		this.entidade = entidade;
	}


	public TarifaGrupoVO getFiltro() {
		return filtro;
	}


	public void setFiltro(TarifaGrupoVO filtro) {
		this.filtro = filtro;
	}

	
	
}
