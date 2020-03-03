package com.mozart.web.actions.sistema;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.EmpresaSeguradoraEJB;
import com.mozart.model.ejb.entity.RedeHotelEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.RedeHotelVO;
import com.mozart.web.actions.BaseAction;
import java.util.List;

public class RedeHotelAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	
	private RedeHotelEJB entidade;
	private RedeHotelVO filtro;
	private EmpresaSeguradoraEJB seguradora;
	private String operacao;
	
	
	public RedeHotelAction (){
		
		entidade = new RedeHotelEJB();
		filtro = new RedeHotelVO();
		seguradora = new EmpresaSeguradoraEJB();
	}

	public String prepararInclusao(){
		operacao = "I";
		entidade.setForaAno("N");
		
		return SUCESSO_FORWARD;
		
	}
	

	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	
public String prepararAlteracao() {
		
		try { 
			operacao="A";
			entidade=(RedeHotelEJB) CheckinDelegate.instance().obter(RedeHotelEJB.class, entidade.getIdRedeHotel());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarRedeHotel() {
		try { 
			
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			
			
			if ("I".equals(getOperacao())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new RedeHotelEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	public String pesquisar(){
		
		try{
			List<RedeHotelEJB> lista = SistemaDelegate.instance().pesquisarRedeHotelEJB(filtro);
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

	public RedeHotelEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(RedeHotelEJB entidade) {
		this.entidade = entidade;
	}

	public RedeHotelVO getFiltro() {
		return filtro;
	}

	public void setFiltro(RedeHotelVO filtro) {
		this.filtro = filtro;
	}

	public EmpresaSeguradoraEJB getSeguradora() {
		return seguradora;
	}

	public void setSeguradora(EmpresaSeguradoraEJB seguradora) {
		this.seguradora = seguradora;
	}

	public String getOperacao() {
		return operacao;
	}

	public void setOperacao(String operacao) {
		this.operacao = operacao;
	}

	
	
}