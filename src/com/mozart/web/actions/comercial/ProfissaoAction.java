package com.mozart.web.actions.comercial;

import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.ejb.entity.ProfissaoEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ProfissaoVO;
import com.mozart.web.actions.BaseAction;

public class ProfissaoAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4187688187094727716L;

	
	
	
	private ProfissaoEJB entidade;
	private ProfissaoVO filtro;
	
	
	public String prepararPesquisa(){
		
		request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		info("Pesquisando Profissao");
		try{
			
			request.getSession().removeAttribute("listaPesquisa");

			List<ProfissaoVO> listaPesquisa = ComercialDelegate.instance().pesquisarProfissao(filtro);
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
		
		entidade = new ProfissaoEJB();
		return SUCESSO_FORWARD;
	}
	

	public String prepararAlteracao(){
		
		try{
			entidade = (ProfissaoEJB)CheckinDelegate.instance().obter(ProfissaoEJB.class, entidade.getIdProfissao() );
		
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( ex.getMessage() );
		}
		return SUCESSO_FORWARD;

	}

	
	public String gravar(){
		
		try{
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			if ( MozartUtil.isNull( entidade.getIdProfissao() )){
			
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

	public ProfissaoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(ProfissaoEJB entidade) {
		this.entidade = entidade;
	}

	public ProfissaoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ProfissaoVO filtro) {
		this.filtro = filtro;
	}



	
}
