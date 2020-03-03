package com.mozart.web.actions.comercial;

import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.ejb.entity.EmpresaAcessoEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.EmpresaAcessoVO;
import com.mozart.web.actions.BaseAction;

public class AcessoWebAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3537578173854807373L;
	
	private EmpresaAcessoEJB entidade;
	private EmpresaAcessoVO filtro;
	
	
	public String prepararPesquisa(){
		
		request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		info("Pesquisando acesso web");
		try{
			
			request.getSession().removeAttribute("listaPesquisa");

			List<EmpresaAcessoVO> listaPesquisa = ComercialDelegate.instance().pesquisarEmpresaAcesso(filtro);
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
		
		entidade = new EmpresaAcessoEJB();
		return SUCESSO_FORWARD;
	}
	

	public String prepararAlteracao(){
		
		try{
			entidade = (EmpresaAcessoEJB)CheckinDelegate.instance().obter(EmpresaAcessoEJB.class, entidade.getIdUser() );
		
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( ex.getMessage() );
		}
		return SUCESSO_FORWARD;

	}

	
	public String gravar(){
		
		try{
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			if ( MozartUtil.isNull( entidade.getIdUser() )){
				
				entidade = (EmpresaAcessoEJB)CheckinDelegate.instance().incluir(entidade);
			}else{
				entidade = (EmpresaAcessoEJB) CheckinDelegate.instance().alterar(entidade);
				
			}
			addMensagemSucesso( MSG_SUCESSO );
			
			return prepararInclusao();
		}catch(Exception ex){
			error(ex.getMessage());
			addActionError( MSG_ERRO );
			return SUCESSO_FORWARD;
		}		
	}

	public EmpresaAcessoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(EmpresaAcessoEJB entidade) {
		this.entidade = entidade;
	}

	public EmpresaAcessoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(EmpresaAcessoVO filtro) {
		this.filtro = filtro;
	}
}
