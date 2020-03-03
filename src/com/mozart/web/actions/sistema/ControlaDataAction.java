package com.mozart.web.actions.sistema;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ControlaDataVO;
import com.mozart.model.vo.HotelVO;
import com.mozart.web.actions.BaseAction;

import java.util.Collections;
import java.util.List;


public class ControlaDataAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	private List <HotelEJB> hotelList;
	private ControlaDataEJB entidade;
	private ControlaDataVO filtro;


	public ControlaDataAction (){
		
		filtro = new ControlaDataVO();
		entidade = new ControlaDataEJB();
		hotelList = Collections.emptyList();
		
	}
	
	private void initCombo() throws MozartSessionException {
			
		hotelList = SistemaDelegate.instance().pesquisarHotelEJB(new HotelVO());
			
	}
	
	
	public String prepararInclusao() {
		try{
		initCombo();
		ControlaDataEJB corrente = getControlaData();
		entidade.setFrontOffice(corrente.getFrontOffice());
		entidade.setFaturamentoContasReceber(corrente.getFaturamentoContasReceber());
		entidade.setTesouraria(corrente.getTesouraria());
		entidade.setEstoque(corrente.getEstoque());
		entidade.setUltimoNumDuplicata(corrente.getUltimoNumDuplicata());
		entidade.setUltimaNotaHospedagem(corrente.getUltimaNotaHospedagem());
		entidade.setUltimoNumCotacao(corrente.getUltimoNumCotacao());
		entidade.setUltimoNumPedido(corrente.getUltimoNumPedido());
		entidade.setTelefonia(corrente.getTelefonia());
		entidade.setSaldoElevado(corrente.getSaldoElevado());
		entidade.setFechadura(corrente.getFechadura());
		entidade.setUltimaRequisicao(corrente.getUltimaRequisicao());
		entidade.setCentralAdviser(corrente.getCentralAdviser());
		entidade.setAudEncerra(corrente.getAudEncerra());
		entidade.setUltimaNfs(corrente.getUltimaNfs());
		entidade.setUltimaCnfs(corrente.getUltimaCnfs());
		entidade.setUltimaSeqBancaria(corrente.getUltimaSeqBancaria());
		entidade.setUltimaCnfe(corrente.getUltimaCnfe());
		
		}catch (MozartSessionException e) {
			
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
				HotelEJB hotel = new HotelEJB();
				hotel.setIdHotel( entidade.getIdHotel() );
				hotel = hotelList.get( hotelList.indexOf(hotel));
				entidade.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());
				entidade=(ControlaDataEJB) CheckinDelegate.instance().obter(ControlaDataEJB.class, entidade.getIdHotel());
				
			} catch (Exception ex){
				error(ex.getMessage());
				addMensagemErro(MSG_ERRO);
				
			}
			
			return SUCESSO_FORWARD;
			
		}
	
	public String gravarControlaData() {
		try { 

			initCombo();
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			
			
			if (MozartUtil.isNull(entidade.getIdHotel())){
				CheckinDelegate.instance().incluir(entidade);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new ControlaDataEJB();
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	public String pesquisar(){
		
		try{
			List<ControlaDataEJB> lista = SistemaDelegate.instance().pesquisarControlaData(filtro);
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

	public ControlaDataEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(ControlaDataEJB entidade) {
		this.entidade = entidade;
	}

	public List<HotelEJB> getHotelList() {
		return hotelList;
	}

	public void setHotelList(List<HotelEJB> hotelList) {
		this.hotelList = hotelList;
	}

	public ControlaDataVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ControlaDataVO filtro) {
		this.filtro = filtro;
	}

}