package com.mozart.web.actions.rede;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.DepartamentoEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CentroCustoVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;


public class CentroCustoAction extends BaseAction{

	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	
	private CentroCustoContabilEJB entidade;
	private CentroCustoVO filtro;
	private List<DepartamentoEJB> departamentoList;
	private List <MozartComboWeb> tipoPessoaList;
			

	public CentroCustoAction (){
		
		entidade = new CentroCustoContabilEJB();
		filtro = new CentroCustoVO();
		departamentoList = Collections.emptyList();
		tipoPessoaList = Collections.emptyList();
		
	}
	
	
	private void initCombo() throws MozartSessionException {
			
		DepartamentoEJB filtroDep = new DepartamentoEJB(); 
		filtroDep.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		departamentoList = RedeDelegate.instance().pesquisarDepartamento(filtroDep);
		
		tipoPessoaList = new ArrayList<MozartComboWeb>();
		tipoPessoaList.add(new MozartComboWeb("H","Hóspede"));
		tipoPessoaList.add(new MozartComboWeb("F","Funcionários"));
		tipoPessoaList.add(new MozartComboWeb("O","Outros"));
									
	}
	
	
	
	
	
	public String prepararInclusao(){
		try {
			initCombo();
			
			
		} catch (MozartSessionException e) {
			
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
			
		}
		return SUCESSO_FORWARD;
		
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}
	
	public String prepararAlteracao() {
		
		try { 
			initCombo();
			entidade=(CentroCustoContabilEJB)CheckinDelegate.instance().obter(CentroCustoContabilEJB.class, entidade.getIdCentroCustoContabil());
				
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
		
	}
	
	public String gravar() {
		try { 
			
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdHotel(getIdHoteis()[0]);
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			initCombo();
			
						
			if (MozartUtil.isNull(entidade.getIdCentroCustoContabil())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new CentroCustoContabilEJB();
			
			
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
				filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
				List<CentroCustoVO> lista = RedeDelegate.instance().pesquisarCentroCusto(filtro);
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

	
	
	public CentroCustoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(CentroCustoVO filtro) {
		this.filtro = filtro;
	}

	public CentroCustoContabilEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(CentroCustoContabilEJB entidade) {
		this.entidade = entidade;
	}

	public List<DepartamentoEJB> getDepartamentoList() {
		return departamentoList;
	}

	public void setDepartamentoList(List<DepartamentoEJB> departamentoList) {
		this.departamentoList = departamentoList;
	}


	public List<MozartComboWeb> getTipoPessoaList() {
		return tipoPessoaList;
	}


	public void setTipoPessoaList(List<MozartComboWeb> tipoPessoaList) {
		this.tipoPessoaList = tipoPessoaList;
	}
	
	
	
}