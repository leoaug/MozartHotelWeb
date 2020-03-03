package com.mozart.web.actions.estoque;

import javax.annotation.PostConstruct;

import com.mozart.web.actions.BaseAction;

public class RequisicaoAction extends BaseAction{

	private static final long serialVersionUID = -295098558443080515L;
	
	public RequisicaoAction() {
	}
	
	@PostConstruct
	public void init(){
		
	}
	
	public String prepararPesquisa(){
		this.request.getSession().removeAttribute("listaPesquisa");
		return PESQUISA_FORWARD;
	}
	
	public String pesquisar(){
		
		return SUCESSO_FORWARD;
	}
	
	public String manterRequisicao(){
		
		return SUCESSO_FORWARD;
	}
	

	
	public String prepararInclusao(){
		
		return SUCESSO_FORWARD;
	}
	public String prepararAlteracao(){
		
		return SUCESSO_FORWARD;
	}
}