package com.mozart.web.actions.comercial;

import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComercialDelegate;
import com.mozart.model.delegate.ReservaDelegate;
import com.mozart.model.ejb.entity.CanalVendaEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJBPK;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CanalVendaVO;
import com.mozart.web.actions.BaseAction;

public class CanalVendaAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3537578173854807373L;
	
	private CanalVendaEJB entidade;
	private CanalVendaVO filtro;
	
	
	public String prepararPesquisa(){
		
		request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}
	
	public String pesquisar(){
		info("Pesquisando Canais de Vendas");
		try{
			
			request.getSession().removeAttribute("listaPesquisa");
			
			filtro.setIdHotel(getHotelCorrente().getIdHotel());

			List<CanalVendaVO> listaPesquisa = ComercialDelegate.instance().pesquisarCanalVendas(filtro);
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
		
		entidade = new CanalVendaEJB();
		return SUCESSO_FORWARD;
	}
	

	public String prepararAlteracao(){
		
		try{
			entidade = (CanalVendaEJB)CheckinDelegate.instance().obter(CanalVendaEJB.class, entidade.getIdGdsCanal() );
		
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( ex.getMessage() );
		}
		return SUCESSO_FORWARD;

	}

	
	public String gravar(){
		
		try{
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			
			entidade.setHotel(getHotelCorrente());
			
			EmpresaHotelEJBPK empresaHotelEJBPK = new EmpresaHotelEJBPK(entidade.getEmpresa().getIdEmpresa(), entidade.getHotel().getIdHotel());

			EmpresaHotelEJB eh = (EmpresaHotelEJB) CheckinDelegate.instance()
					.obter(EmpresaHotelEJB.class, empresaHotelEJBPK);
			entidade.setEmpresa(eh);
			
			entidade.setIdEmpresa(entidade.getEmpresa().getIdEmpresa());
			entidade.setIdHotel(entidade.getHotel().getIdHotel());
			entidade.setIdGds(entidade.getAdministradorCanais().getIdGds());
			
			if ( MozartUtil.isNull( entidade.getIdGdsCanal() )){
				entidade.setIdGdsCanal(ReservaDelegate.instance().obterNextVal());
				entidade = (CanalVendaEJB)CheckinDelegate.instance().incluir(entidade);
			}else{
				entidade = (CanalVendaEJB) CheckinDelegate.instance().alterar(entidade);
				
			}
			addMensagemSucesso( MSG_SUCESSO );
			
			return prepararInclusao();
		}catch(Exception ex){
			error(ex.getMessage());
			addActionError( MSG_ERRO );
			return SUCESSO_FORWARD;
		}		
	}

	public CanalVendaEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(CanalVendaEJB entidade) {
		this.entidade = entidade;
	}

	public CanalVendaVO getFiltro() {
		return filtro;
	}

	public void setFiltro(CanalVendaVO filtro) {
		this.filtro = filtro;
	}
	
}
