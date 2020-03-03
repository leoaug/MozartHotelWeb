package com.mozart.web.actions.comercial;

import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.delegate.EmpresaDelegate;
import com.mozart.model.ejb.entity.EmpresaHotelEJBPK;
import com.mozart.model.ejb.entity.PermutaEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.PermutaVO;
import com.mozart.web.actions.BaseAction;

public class PermutaAction extends BaseAction{
	
	

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 4907115579770221357L;
	private PermutaEJB entidade;
	private PermutaVO filtro;
	
	
	public String prepararPesquisa(){
		
		request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		info("Pesquisando Profissao");
		try{
			
			request.getSession().removeAttribute("listaPesquisa");

			filtro.setIdHoteis( getIdHoteis() );
			filtro.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
			List<PermutaVO> listaPesquisa = ComercialDelegate.instance().pesquisarPremuta(filtro);
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
		
		entidade = new PermutaEJB();
		return SUCESSO_FORWARD;
	}
	

	public String prepararAlteracao(){
		
		try{
			entidade = (PermutaEJB)CheckinDelegate.instance().obter(PermutaEJB.class, entidade.getIdPermuta() );
		
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( ex.getMessage() );
		}
		return SUCESSO_FORWARD;

	}

	
	public String gravar(){
		
		try{
			
			EmpresaHotelEJBPK pk = new EmpresaHotelEJBPK();
			pk.idHotel = getIdHoteis()[0];
			pk.idEmpresa = entidade.getEmpresaHotel().getIdEmpresa();

			entidade.setEmpresaHotel( EmpresaDelegate.instance().obterEmpresaHotelByPK(pk) );
			
			entidade.getEmpresaHotel().setIdHotel( getIdHoteis()[0] );
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			if ( MozartUtil.isNull( entidade.getIdPermuta() )){
				
				entidade = (PermutaEJB)CheckinDelegate.instance().incluir(entidade);
			}else{
				entidade = (PermutaEJB) CheckinDelegate.instance().alterar(entidade);
				
			}
			addMensagemSucesso( MSG_SUCESSO + " Nº contrato: " + entidade.getIdPermuta() );
			
			return prepararInclusao();
		}catch(Exception ex){
			error(ex.getMessage());
			addActionError( MSG_ERRO );
			return SUCESSO_FORWARD;
		}
		
	}

	public PermutaEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(PermutaEJB entidade) {
		this.entidade = entidade;
	}

	public PermutaVO getFiltro() {
		return filtro;
	}

	public void setFiltro(PermutaVO filtro) {
		this.filtro = filtro;
	}

	

}
