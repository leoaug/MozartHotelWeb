package com.mozart.web.actions.sistema;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.EmpresaEJB;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.EmpresaVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

import java.util.ArrayList;
import java.util.List;


public class EmpresaAction extends BaseAction{
	/**
	 * 
	*/
	private static final long serialVersionUID = 1L;

	
	private EmpresaEJB entidade;
	private EmpresaVO filtro;
	private List<MozartComboWeb> tipoEmpresaList;
	private List<MozartComboWeb> opcoesList;
	private String empresaCnpj;
	private String empresaCpf;
	
	
	public EmpresaAction (){
		
		entidade = new EmpresaEJB();
		filtro = new EmpresaVO();
		tipoEmpresaList = new ArrayList<MozartComboWeb>();
		tipoEmpresaList.add( new MozartComboWeb("A","Agência de Turismo"));
		tipoEmpresaList.add( new MozartComboWeb("O","Operadora"));
		tipoEmpresaList.add( new MozartComboWeb("E","Empresa"));
		tipoEmpresaList.add( new MozartComboWeb("P","Particular"));
		tipoEmpresaList.add( new MozartComboWeb("D","Diversos"));
		
		this.opcoesList = new ArrayList();
		this.opcoesList.add(new MozartComboWeb("1", "Pessoa Jurídica"));
		this.opcoesList.add(new MozartComboWeb("2", "Pessoa Física"));
		this.opcoesList.add(new MozartComboWeb("3", "Outros"));
		
	}
	
	
	public String prepararInclusao(){
		
		return SUCESSO_FORWARD;
		
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() {
		
	try { 
			
			entidade=(EmpresaEJB)CheckinDelegate.instance().obter(EmpresaEJB.class, entidade.getIdEmpresa());
				
			if(entidade.getNacional().equals("1"))
				empresaCnpj = entidade.getCgc();
			else if(entidade.getNacional().equals("2"))
				empresaCpf = entidade.getCgc();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarEmpresa() {
		try { 
			
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			entidade.setEmpresaTerceirizadaEJBList(null);
			entidade.setEmpresaAcessoEJBList(null);
		 	entidade.setEmpresaRedeEJBList(null);	    
		    entidade.setEmpresaReferenciaEJBList(null);
			entidade.setEmpresaJuntaEJB(null);	   
		    entidade.setEmpresaSocioEJBList(null); 
		    if (MozartUtil.isNull(entidade.getCartaoCredito()))
		    entidade.setCartaoCredito("N");
		    
		    
			if (MozartUtil.isNull(entidade.getIdEmpresa())){
				//CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			

		} catch (MozartValidateException ex){
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} 		
		return SUCESSO_FORWARD; 
		
		
	}
		
	public String pesquisar(){
		try{
			
			filtro.setIdHoteis( getIdHoteis() );
			filtro.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
			List<EmpresaVO> listaPesquisa = SistemaDelegate.instance().pesquisarEmpresa(filtro);
				
			
			if (MozartUtil.isNull( listaPesquisa )){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
				return prepararPesquisa();
			}
			
			request.getSession().setAttribute("listaPesquisa", listaPesquisa);
			
			
		}catch(Exception ex){
			addMensagemErro( MSG_ERRO );
			error( ex.getMessage() );
		}finally{	
		}
			return SUCESSO_FORWARD;
		}
	


	public EmpresaEJB getEntidade() {
		return entidade;
	}


	public void setEntidade(EmpresaEJB entidade) {
		this.entidade = entidade;
	}


	public EmpresaVO getFiltro() {
		return filtro;
	}


	public void setFiltro(EmpresaVO filtro) {
		this.filtro = filtro;
	}


	public List<MozartComboWeb> getTipoEmpresaList() {
		return tipoEmpresaList;
	}


	public void setTipoEmpresaList(List<MozartComboWeb> tipoEmpresaList) {
		this.tipoEmpresaList = tipoEmpresaList;
	}

	public List<MozartComboWeb> getOpcoesList() {
		return opcoesList;
	}

	public void setOpcoesList(List<MozartComboWeb> opcoesList) {
		this.opcoesList = opcoesList;
	}


	public String getEmpresaCnpj() {
		return empresaCnpj;
	}


	public void setEmpresaCnpj(String empresaCnpj) {
		this.empresaCnpj = empresaCnpj;
	}


	public String getEmpresaCpf() {
		return empresaCpf;
	}


	public void setEmpresaCpf(String empresaCpf) {
		this.empresaCpf = empresaCpf;
	}
	
	

}