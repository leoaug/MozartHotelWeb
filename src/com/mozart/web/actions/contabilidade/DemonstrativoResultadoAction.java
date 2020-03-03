package com.mozart.web.actions.contabilidade;

import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.ContabilidadeDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.DepartamentoEJB;
import com.mozart.model.vo.DemonstrativoVO;
import com.mozart.web.actions.BaseAction;

public class DemonstrativoResultadoAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8549356440714640406L;

	private List<DemonstrativoVO> demonstrativoPlanoContasList;
	private List<DemonstrativoVO> demonstrativoResultadoList;
	
	
	private String contas;
	private String demonstrativos;
	private List<CentroCustoContabilEJB> centroCustoList;
	private List<DepartamentoEJB> departamentoList;
	
	
	public String prepararRelatorio(){
		
		try{
			centroCustoList = Collections.emptyList();
			departamentoList = Collections.emptyList();
			
			CentroCustoContabilEJB filtroCentroCusto = new CentroCustoContabilEJB();
			filtroCentroCusto.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			centroCustoList = RedeDelegate.instance().pesquisarCentroCusto(filtroCentroCusto);  
			
			DepartamentoEJB filtro = new DepartamentoEJB();
			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			departamentoList = RedeDelegate.instance().pesquisarDepartamento(filtro);
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}
	
	private void initCombo(){
		try{
			demonstrativoPlanoContasList = Collections.emptyList();
			demonstrativoResultadoList = Collections.emptyList();
			demonstrativoPlanoContasList = ContabilidadeDelegate.instance().obterDemonstrativoPlanoContas(getHotelCorrente().getRedeHotelEJB());
			demonstrativoResultadoList = ContabilidadeDelegate.instance().obterDemonstrativoResultado(getHotelCorrente().getRedeHotelEJB());
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
	}
	
	public String prepararManter(){
		initCombo();
		return SUCESSO_FORWARD;
	}

	public String gravar(){
		
		try{
			DemonstrativoVO entidade = new DemonstrativoVO(); 
			entidade.setUsuario(getUsuario());
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			entidade.setIdHoteis(getIdHoteis());
			entidade.setContas(contas);
			entidade.setDemonstrativos(demonstrativos);
			ContabilidadeDelegate.instance().gravarDemonstrativos( entidade );
			addMensagemSucesso(MSG_SUCESSO);
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}finally{
			initCombo();
		}
		return SUCESSO_FORWARD;
	}

	public List<DemonstrativoVO> getDemonstrativoPlanoContasList() {
		return demonstrativoPlanoContasList;
	}

	public void setDemonstrativoPlanoContasList(
			List<DemonstrativoVO> demonstrativoPlanoContasList) {
		this.demonstrativoPlanoContasList = demonstrativoPlanoContasList;
	}

	public List<DemonstrativoVO> getDemonstrativoResultadoList() {
		return demonstrativoResultadoList;
	}

	public void setDemonstrativoResultadoList(
			List<DemonstrativoVO> demonstrativoResultadoList) {
		this.demonstrativoResultadoList = demonstrativoResultadoList;
	}

	public String getContas() {
		return contas;
	}

	public void setContas(String contas) {
		this.contas = contas;
	}

	public String getDemonstrativos() {
		return demonstrativos;
	}

	public void setDemonstrativos(String demonstrativos) {
		this.demonstrativos = demonstrativos;
	}

	public List<CentroCustoContabilEJB> getCentroCustoList() {
		return centroCustoList;
	}

	public void setCentroCustoList(List<CentroCustoContabilEJB> centroCustoList) {
		this.centroCustoList = centroCustoList;
	}

	public List<DepartamentoEJB> getDepartamentoList() {
		return departamentoList;
	}

	public void setDepartamentoList(List<DepartamentoEJB> departamentoList) {
		this.departamentoList = departamentoList;
	}
	
	
	
}
