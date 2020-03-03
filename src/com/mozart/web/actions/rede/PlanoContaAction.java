package com.mozart.web.actions.rede;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.DemonstrativoPlanoContasEJB;
import com.mozart.model.ejb.entity.HistoricoContabilEJB;
import com.mozart.model.ejb.entity.PlanoContaEJB;
import com.mozart.model.ejb.entity.PlanoContasSpedEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.PlanoContaVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;


public class PlanoContaAction extends BaseAction{

	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	private List <PlanoContasSpedEJB> planoContasSpedList;
	private PlanoContaEJB entidade;
	private PlanoContaVO filtro;		
	private List <MozartComboWeb> tipoList, tipoContaList;
	private List <HistoricoContabilEJB> historicoContabilList;
	private List <PlanoContaVO> planoContaList;
	
	
	public PlanoContaAction (){
		
		entidade = new PlanoContaEJB();
		planoContasSpedList = Collections.emptyList();
		filtro = new PlanoContaVO();
		
	}
	
	private void initCombo() throws MozartSessionException {
		
		planoContasSpedList = RedeDelegate.instance().pesquisarPlanoContasSped(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		tipoList = new ArrayList<MozartComboWeb>();
		tipoList.add(new MozartComboWeb("A", "Ativo"));
		tipoList.add(new MozartComboWeb("P", "Passivo"));
		tipoList.add(new MozartComboWeb("O", "Outros"));

		tipoContaList = new ArrayList<MozartComboWeb>();
		tipoContaList.add(new MozartComboWeb("A", "Analítico"));
		tipoContaList.add(new MozartComboWeb("S", "Sintético"));
		
		PlanoContaVO filtroPC = new PlanoContaVO();
		filtroPC.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		planoContaList = RedeDelegate.instance().pesquisarPlanoConta(filtroPC);
		
		HistoricoContabilEJB filtro = new HistoricoContabilEJB();
		filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		historicoContabilList = RedeDelegate.instance().pesquisarHistoricoContabil(filtro);
		
	}
	
	public String prepararInclusao(){
		
		try {
			initCombo();
			entidade.setMutuo("N");
			getHotelCorrente().getRedeHotelEJB();
			entidade.setDepreciacao("N");
			entidade.setCorrecaoMonetaria("N");
			entidade.setCofins("N");
			entidade.setRazaoAuxiliar("N");
			entidade.setTipoConta("A");
			
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
			entidade=(PlanoContaEJB) CheckinDelegate.instance().obter(PlanoContaEJB.class, entidade.getIdPlanoContas());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarPlanoConta() {
		try { 
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			entidade.setIdHotel(getHotelCorrente().getIdHotel());
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			initCombo();
			
			if(entidade.getHistoricoDebito()!=null && entidade.getHistoricoDebito().getIdHistorico()==null){
				entidade.setHistoricoDebito(null);
				
			}
			
			if(entidade.getHistoricoCredito()!=null && entidade.getHistoricoCredito().getIdHistorico()==null){
				entidade.setHistoricoCredito(null);
				
			}
			
			if(entidade.getPlanoConta1()!=null && entidade.getPlanoConta1().getIdPlanoContas()==null){
				entidade.setPlanoConta1(null);
			
			}
			
			if(entidade.getPlanoConta2()!=null && entidade.getPlanoConta2().getIdPlanoContas()==null){
				entidade.setPlanoConta2(null);
			
			}

			if(entidade.getPlanoContasSpedEJB()!=null && entidade.getPlanoContasSpedEJB().getIdPlanoContasSped()==null){
				entidade.setPlanoContasSpedEJB(null);
			
			}
			
			if (MozartUtil.isNull(entidade.getIdPlanoContas())){
				entidade = (PlanoContaEJB) CheckinDelegate.instance().incluir(entidade);
				DemonstrativoPlanoContasEJB demonstrativoPlanoContas = new DemonstrativoPlanoContasEJB();
				
				demonstrativoPlanoContas.setPlanoConta(entidade);
				demonstrativoPlanoContas.setRedeHotel(getHotelCorrente().getRedeHotelEJB());
				
				 CheckinDelegate.instance().incluir(demonstrativoPlanoContas);
			} else {
			    CheckinDelegate.instance().alterar(entidade);	
			} 
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new PlanoContaEJB();
			entidade.setMutuo("N");
			entidade.setDepreciacao("N");
			entidade.setCorrecaoMonetaria("N");
			entidade.setCofins("N");
			entidade.setRazaoAuxiliar("N");
			entidade.setTipoConta("A");

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
			List<PlanoContaVO> lista = RedeDelegate.instance().pesquisarPlanoConta(filtro);
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
	
	
	public PlanoContaEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(PlanoContaEJB entidade) {
		this.entidade = entidade;
	}

	public List<PlanoContasSpedEJB> getTipoIndiceList() {
		return planoContasSpedList;
	}

	public void setPlanoContasSpedList(List<PlanoContasSpedEJB> planoContasSpedList) {
		this.planoContasSpedList = planoContasSpedList;
	}

	
	public List<PlanoContasSpedEJB> getPlanoContasSpedList() {
		return planoContasSpedList;
	}

	public PlanoContaVO getFiltro() {
		return filtro;
	}

	public void setFiltro(PlanoContaVO filtro) {
		this.filtro = filtro;
	}

	public List<MozartComboWeb> getTipoList() {
		return tipoList;
	}

	public void setTipoList(List<MozartComboWeb> tipoList) {
		this.tipoList = tipoList;
	}

	public List<HistoricoContabilEJB> getHistoricoContabilList() {
		return historicoContabilList;
	}

	public void setHistoricoContabilList(
			List<HistoricoContabilEJB> historicoContabilList) {
		this.historicoContabilList = historicoContabilList;
	}

	public List<PlanoContaVO> getPlanoContaList() {
		return planoContaList;
	}

	public void setPlanoContaList(List<PlanoContaVO> planoContaList) {
		this.planoContaList = planoContaList;
	}

	public List<MozartComboWeb> getTipoContaList() {
		return tipoContaList;
	}

	public void setTipoContaList(List<MozartComboWeb> tipoContaList) {
		this.tipoContaList = tipoContaList;
	}

}