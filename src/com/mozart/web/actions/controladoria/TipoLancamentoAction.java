package com.mozart.web.actions.controladoria;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ControladoriaDelegate;
import com.mozart.model.delegate.EmpresaDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.ContaCorrenteEJB;
import com.mozart.model.ejb.entity.EmpresaEJB;
import com.mozart.model.ejb.entity.IdentificaLancamentoEJB;
import com.mozart.model.ejb.entity.TipoApartamentoEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJBPK;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.EmpresaHotelVO;
import com.mozart.model.vo.PlanoContaVO;
import com.mozart.model.vo.TipoLancamentoVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class TipoLancamentoAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3126795467853564022L;
	
	private TipoLancamentoEJB entidade;
	private TipoLancamentoVO filtro;
	
	private String repasse;
	private String contaCorrente;
	private String empresaCartao;
	String selectedChave;
	
	/*Listas*/
	private List<MozartComboWeb> debitoCreditoList;
	private List<PlanoContaVO> planoContasList, planoContaFinanceiroList;
	private List<CentroCustoContabilEJB> centroCustoList;
	private List<TipoApartamentoEJB> tipoApartamentoList;
	private List<IdentificaLancamentoEJB> identificaLancamentoList;
	
	private Long idPlanoContaNome, idPlanoContaNomeCredito;
	
	public TipoLancamentoAction(){
		entidade = new TipoLancamentoEJB(); 
	}
	

	public String prepararInclusao(){
		prepararPesquisa();
		initCombo();
		identificaLancamentoList = Collections.emptyList();
		request.getSession().setAttribute("identificaLancamentoList", identificaLancamentoList);
		entidade = new TipoLancamentoEJB(); 
		entidade.setFundoReserva("N");
		entidade.setDespesaFixa("N");
		
		entidade.setIss("N");
		entidade.setNotaFiscal("N");
		entidade.setIssNota("N");
		entidade.setPis("N");
		entidade.setRoomtax("N");
		entidade.setTaxaServico("N");
		
		repasse = "N";
		contaCorrente = "";
		selectedChave = "";
		return SUCESSO_FORWARD;
	}
	
	private void initCombo(){

		try{
			debitoCreditoList = Collections.emptyList();
			planoContasList = Collections.emptyList();
			planoContaFinanceiroList = Collections.emptyList();
			centroCustoList = Collections.emptyList();
		
			debitoCreditoList = new ArrayList<MozartComboWeb>();
			debitoCreditoList.add( new MozartComboWeb("C", "Crédito"));
			debitoCreditoList.add( new MozartComboWeb("D", "Débito"));
			
			
			PlanoContaVO filtroPlanoConta = new PlanoContaVO();
			filtroPlanoConta.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			filtroPlanoConta.getFiltroTipoConta().setTipo("C");
			filtroPlanoConta.getFiltroTipoConta().setTipoIntervalo("2");
			filtroPlanoConta.getFiltroTipoConta().setValorInicial("Analitico");

			planoContaFinanceiroList = RedeDelegate.instance().pesquisarPlanoConta(filtroPlanoConta); 

			
			filtroPlanoConta = new PlanoContaVO();
			filtroPlanoConta.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			filtroPlanoConta.getFiltroTipoConta().setTipo("C");
			filtroPlanoConta.getFiltroTipoConta().setTipoIntervalo("2");
			filtroPlanoConta.getFiltroTipoConta().setValorInicial("Analitico");

			planoContasList = RedeDelegate.instance().pesquisarPlanoConta(filtroPlanoConta); 

			CentroCustoContabilEJB filtroCentroCusto = new CentroCustoContabilEJB();
			filtroCentroCusto.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			centroCustoList = RedeDelegate.instance().pesquisarCentroCusto(filtroCentroCusto);

            TipoApartamentoEJB pTipoApartamentoEJB = new TipoApartamentoEJB();
            pTipoApartamentoEJB.setIdHotel( getIdHoteis()[0] );
            tipoApartamentoList = CheckinDelegate.instance().obterTipoApartamento( pTipoApartamentoEJB );

		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
	}
	
	
	public String prepararAlteracao(){
		
		try{
			initCombo();
			TipoLancamentoEJBPK pk = new TipoLancamentoEJBPK();
			pk.idTipoLancamento = entidade.getIdTipoLancamento();
			pk.idHotel = getHotelCorrente().getIdHotel();
			
			entidade = (TipoLancamentoEJB)CheckinDelegate.instance().obter(TipoLancamentoEJB.class, pk);
			if (!MozartUtil.isNull(entidade.getClassificacaoContabilEJBList())){
				entidade.setClassificacaoContabilEJB( entidade.getClassificacaoContabilEJBList().get(0));
				idPlanoContaNome = !MozartUtil.isNull(entidade.getClassificacaoContabilEJB().getPlanoContasDebito()) ? entidade.getClassificacaoContabilEJB().getPlanoContasDebito().getIdPlanoContas() : idPlanoContaNome;
				idPlanoContaNomeCredito = !MozartUtil.isNull(entidade.getClassificacaoContabilEJB().getPlanoContasCredito()) ? entidade.getClassificacaoContabilEJB().getPlanoContasCredito().getIdPlanoContas() : idPlanoContaNomeCredito;
			}
			repasse = "N";
			if (entidade.getEmpresaHotelEJB()!=null){
				repasse = "S";
			}
			IdentificaLancamentoEJB filtro = new IdentificaLancamentoEJB();
        	filtro.setAtividade("HOTEL");
        	filtro.setGrupoSub( entidade.getSubGrupoLancamento().equals("000")?"G":"S");
        	if (filtro.getGrupoSub() == "S"){
        		filtro.setIdentificaLancamentoPaiEJB( entidade.getIdentificaLancamento().getIdentificaLancamentoPaiEJB()==null?
        				entidade.getIdentificaLancamento():
        				entidade.getIdentificaLancamento().getIdentificaLancamentoPaiEJB()
        		);
        	}
        	
        	if(!MozartUtil.isNull(entidade.getContaCorrente())){
        		ContaCorrenteEJB contaCorrenteEJB = (ContaCorrenteEJB) CheckinDelegate.instance().obter(ContaCorrenteEJB.class, entidade.getContaCorrente());
        		if(!MozartUtil.isNull(contaCorrenteEJB)){
        			contaCorrente =  String.format("%1s - %2s - %3s", contaCorrenteEJB.getBancoEJB().getNomeFantasia(), contaCorrenteEJB.getNumeroAgencia(), contaCorrenteEJB.getNumContaCorrente()).toString();
        		}
        	}
        	
        	if(!MozartUtil.isNull(entidade.getIdCartaoCredito())){
        		EmpresaHotelVO filtroEmpresaVo = new EmpresaHotelVO();
        		filtroEmpresaVo.setBcIdHotel(getHotelCorrente().getIdHotel());
        		filtroEmpresaVo.setBcIdEmpresa(entidade.getIdCartaoCredito());
        		
        		EmpresaHotelVO empresaEJB = EmpresaDelegate.instance().obterEmpresaPorIdEmpresa(filtroEmpresaVo);
        		if(!MozartUtil.isNull(empresaEJB)){
        			empresaCartao = empresaEJB.getBcNomeFantasia() + " - " + empresaEJB.getCnpj();
        		}
        	}
        	
        	selectedChave = entidade.getIdentificaLancamento().getChave();
			List<IdentificaLancamentoEJB> identificaLancamentoList = ControladoriaDelegate.instance().obterIdentificaLancamentoEJB(filtro);
        	request.getSession().setAttribute("identificaLancamentoList", identificaLancamentoList);
        	
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}

	

	public String gravar(){
		
		try{
			initCombo();
			
			
			if (!new Long(26).equals(entidade.getIdentificaLancamento().getIdIdentificaLancamento())){
				entidade.setIdTipoApartamento( null );
			}
			
			entidade.setIdHotel( getHotelCorrente().getIdHotel() );
			entidade.setUsuario(getUsuario());
			entidade.getClassificacaoContabilEJB().setIdHotel( getHotelCorrente().getIdHotel() );
			entidade.getClassificacaoContabilEJB().setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
			
			entidade.getClassificacaoContabilEJB().setPis(entidade.getPis());
			entidade.setCofins(entidade.getPis());
			OperacionalDelegate.instance().gravarTipoLancamento( entidade );
			
			prepararInclusao();
			addMensagemSucesso( MSG_SUCESSO );

		}catch(MozartValidateException ex){
			error( ex.getMessage() );
			addMensagemSucesso( ex.getMessage() );
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}
	
	
	
	public String prepararPesquisa(){
		
		request.getSession().removeAttribute( LISTA_PESQUISA );
		return SUCESSO_FORWARD;
	}

	public String pesquisar(){
		try{
			filtro.setIdHoteis(getIdHoteis());
			List<TipoLancamentoVO> listaPesquisa = ControladoriaDelegate.instance().pesquisarTipoLancamento( filtro );
			request.getSession().setAttribute(LISTA_PESQUISA,listaPesquisa);
			if (MozartUtil.isNull( listaPesquisa)){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD;
	}

	public TipoLancamentoEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(TipoLancamentoEJB entidade) {
		this.entidade = entidade;
	}

	public TipoLancamentoVO getFiltro() {
		return filtro;
	}

	public void setFiltro(TipoLancamentoVO filtro) {
		this.filtro = filtro;
	}


	public String getRepasse() {
		return repasse;
	}


	public void setRepasse(String repasse) {
		this.repasse = repasse;
	}


	public List<MozartComboWeb> getDebitoCreditoList() {
		return debitoCreditoList;
	}


	public void setDebitoCreditoList(List<MozartComboWeb> debitoCreditoList) {
		this.debitoCreditoList = debitoCreditoList;
	}


	public List<PlanoContaVO> getPlanoContasList() {
		return planoContasList;
	}


	public void setPlanoContasList(List<PlanoContaVO> planoContasList) {
		this.planoContasList = planoContasList;
	}


	public List<PlanoContaVO> getPlanoContaFinanceiroList() {
		return planoContaFinanceiroList;
	}


	public void setPlanoContaFinanceiroList(
			List<PlanoContaVO> planoContaFinanceiroList) {
		this.planoContaFinanceiroList = planoContaFinanceiroList;
	}


	public List<CentroCustoContabilEJB> getCentroCustoList() {
		return centroCustoList;
	}


	public void setCentroCustoList(List<CentroCustoContabilEJB> centroCustoList) {
		this.centroCustoList = centroCustoList;
	}


	public List<TipoApartamentoEJB> getTipoApartamentoList() {
		return tipoApartamentoList;
	}


	public void setTipoApartamentoList(List<TipoApartamentoEJB> tipoApartamentoList) {
		this.tipoApartamentoList = tipoApartamentoList;
	}


	public List<IdentificaLancamentoEJB> getIdentificaLancamentoList() {
		return identificaLancamentoList;
	}


	public void setIdentificaLancamentoList(
			List<IdentificaLancamentoEJB> identificaLancamentoList) {
		this.identificaLancamentoList = identificaLancamentoList;
	}


	public Long getIdPlanoContaNome() {
		return idPlanoContaNome;
	}


	public void setIdPlanoContaNome(Long idPlanoContaNome) {
		this.idPlanoContaNome = idPlanoContaNome;
	}


	public Long getIdPlanoContaNomeCredito() {
		return idPlanoContaNomeCredito;
	}


	public void setIdPlanoContaNomeCredito(Long idPlanoContaNomeCredito) {
		this.idPlanoContaNomeCredito = idPlanoContaNomeCredito;
	}


	public String getContaCorrente() {
		return contaCorrente;
	}


	public void setContaCorrente(String contaCorrente) {
		this.contaCorrente = contaCorrente;
	}


	public String getEmpresaCartao() {
		return empresaCartao;
	}


	public void setEmpresaCartao(String empresaCartao) {
		this.empresaCartao = empresaCartao;
	}

	public String getSelectedChave() {
		return selectedChave;
	}

	public void setSelectedChave(String selectedChave) {
		this.selectedChave = selectedChave;
	}
}
