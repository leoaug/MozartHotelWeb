package com.mozart.web.actions.operacional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CaixaGeralDelegate;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.delegate.UsuarioDelegate;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.NfeImpressoraEJB;
import com.mozart.model.ejb.entity.PontoVendaEJB;
import com.mozart.model.ejb.entity.PontoVendaEJBPK;
import com.mozart.model.ejb.entity.PratoEJB;
import com.mozart.model.ejb.entity.PratoEJBPK;
import com.mozart.model.ejb.entity.PratoPontoVendaEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJB;
import com.mozart.model.ejb.entity.UsuarioEJB;
import com.mozart.model.ejb.entity.UsuarioPontoVendaEJB;
import com.mozart.model.ejb.entity.UsuarioPontoVendaEJBPK;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CaixaGeralVO;
import com.mozart.model.vo.PlanoContaVO;
import com.mozart.model.vo.PontoVendaVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class PontoVendaAction extends BaseAction{
	/**
	 * 
	*/

	private static final long serialVersionUID = 1L;

	private PontoVendaVO filtro;
	private PontoVendaEJB entidade;
	private List<MozartComboWeb> tipoPdvList;
	private List<MozartComboWeb> ambientePdvList;
	private List<TipoLancamentoEJB> tipoLancamentoList;
	private List<CaixaGeralVO> apartamentoList;
	private List<CentroCustoContabilEJB> centroCustoList; 
	private List<PlanoContaVO> planoContaList;
	private List<TipoLancamentoEJB> tipoLancamentoServicoList;
	private Long cofan;
	private List<PratoEJB> pratoList;
	private List <UsuarioEJB> usuarioList;
	private List <PontoVendaEJB> pontoVendaList;
	private List <NfeImpressoraEJB> modeloImpressoraList;
	private BigDecimal quantidadeMovimentosAbertos;
	
	public PontoVendaAction (){
		
		tipoLancamentoServicoList = Collections.emptyList();
		tipoLancamentoList = Collections.emptyList();
		filtro = new PontoVendaVO();
		entidade = new PontoVendaEJB();
		apartamentoList = Collections.emptyList();
		centroCustoList = Collections.emptyList();
		planoContaList = Collections.emptyList();
		pratoList = Collections.emptyList();
		pontoVendaList = Collections.emptyList();
		modeloImpressoraList = Collections.emptyList();
	}
	

	public String encerrar(){
		
		try{
			
			if (MozartUtil.isNull( entidade) || MozartUtil.isNull( entidade.getId()) || MozartUtil.isNull( entidade.getId().getIdPontoVenda())){
				throw new MozartValidateException("Informe um PDV para realizar o encerramento");
			}
			entidade.getId().setIdHotel( getHotelCorrente().getIdHotel() );
			entidade.setUsuario(getUsuario());
			OperacionalDelegate.instance().encerrarPontoVenda( entidade );
			prepararEncerramento();
			addMensagemSucesso( MSG_SUCESSO );
			
		}catch (MozartValidateException e){
			prepararEncerramento();
			error( e.getMessage() );
			addMensagemSucesso( e.getMessage() );
			return SUCESSO_FORWARD;
		}catch (Exception e){
			prepararEncerramento();
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		
		return SUCESSO_FORWARD;
		
		
		
	} 

	
	public String prepararEncerramento(){
		
		try{
			pontoVendaList = OperacionalDelegate.instance().obterPontoVendaEncerramento( getHotelCorrente() );
			
			quantidadeMovimentosAbertos = OperacionalDelegate.instance().obterQuantidadeMovimentosAbertos(getHotelCorrente());
			
		}catch (Exception e){
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		return SUCESSO_FORWARD;
		
		
		
	} 
	
	private void initCombo() throws MozartSessionException {
		
		TipoLancamentoEJB valor;
		valor = new TipoLancamentoEJB();
		valor.setIdHotel(getHotelCorrente().getIdHotel());
		tipoLancamentoList = OperacionalDelegate.instance().pesquisarTipoLancamentoPDV(valor);
		
		CentroCustoContabilEJB filtroCentroCusto = new CentroCustoContabilEJB();
		filtroCentroCusto.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		centroCustoList = RedeDelegate.instance().pesquisarCentroCusto(filtroCentroCusto);
		
		PlanoContaVO filtroPlanoConta = new PlanoContaVO();
		filtroPlanoConta.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		planoContaList = RedeDelegate.instance().pesquisarPlanoConta(filtroPlanoConta);
		
		tipoPdvList = new ArrayList<MozartComboWeb>();
		tipoPdvList.add(new MozartComboWeb("H","Hotel"));
		tipoPdvList.add(new MozartComboWeb("R","Restaurante"));
		tipoPdvList.add(new MozartComboWeb("A","Apart-Hotel"));
		
		ambientePdvList = new ArrayList<MozartComboWeb>();
		ambientePdvList.add(new MozartComboWeb("H","Homologação"));
		ambientePdvList.add(new MozartComboWeb("P","Produção"));
		
		CaixaGeralVO param = new CaixaGeralVO();
		param.setIdHotel(getIdHoteis()[0]);
		param.setCofan("S");
		
		apartamentoList = CaixaGeralDelegate.instance()
				.pesquisarApartamentoComCheckinEReserva(param);

		
		valor = new TipoLancamentoEJB();
		valor.setIdHotel(getHotelCorrente().getIdHotel());
		tipoLancamentoServicoList = OperacionalDelegate.instance().pesquisarTipoLancamentoServico(valor);
		
		PratoEJBPK id = new PratoEJBPK();
		id.setIdHotel(getHotelCorrente().getIdHotel());
		PratoEJB filtro;
		filtro = new PratoEJB();
		filtro.setId(id);
		pratoList = OperacionalDelegate.instance().pesquisarPrato(filtro);
		

        //usuarios = delegate.listarUsuarios( getHotelCorrente() );
        UsuarioEJB pFiltro = getUserSession().getUsuarioEJB();
        if (pFiltro.getRedeHotelEJB() != null){
        	pFiltro.setHotelEJB(getHotelCorrente());
        }else{
        	pFiltro.setHotelEJB( null );
        	pFiltro.setRedeHotelEJB( getHotelCorrente().getRedeHotelEJB() );
        }
        usuarioList = UsuarioDelegate.instance().listarUsuarios(pFiltro);
		
		
        modeloImpressoraList = OperacionalDelegate.instance().pesquisarImpressoras();
		
	}
	
	public String removerPratoLote() throws MozartSessionException{
		
		try{
			initCombo();
			PontoVendaEJB entidadeSession = (PontoVendaEJB) request.getSession().getAttribute(ENTIDADE_SESSION);
			
			entidadeSession.setPratoPontoVendaEJBList(null);
			
			
		}catch (MozartSessionException e){
			
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		
		return SUCESSO_FORWARD;
		
		
	}
	
	public String removerUsuarioLote () throws MozartSessionException{
			
			try{
				initCombo();
				PontoVendaEJB entidadeSession = (PontoVendaEJB) request.getSession().getAttribute(ENTIDADE_SESSION);
				
				entidadeSession.setUsuarioPontoVendaEJBList(null);
				
				
			}catch (MozartSessionException e){
				
				addMensagemErro(MSG_ERRO);
				error(e.getMessage());
			}
			
			return SUCESSO_FORWARD;
			
			
		}
	
	
	
	public String adicionarPratoLote() throws MozartSessionException{
		try{
			initCombo();
			PontoVendaEJB entidadeSession = (PontoVendaEJB) request.getSession().getAttribute(ENTIDADE_SESSION);
			entidadeSession.setPratoPontoVendaEJBList(new ArrayList<PratoPontoVendaEJB>());
			for(PratoEJB prato:pratoList){
				
	            PratoPontoVendaEJB novoPrato = new PratoPontoVendaEJB();
	            novoPrato.setPontoVendaEJB(entidadeSession);
	            novoPrato.setPratoEJB(prato);
	            entidadeSession.addPrato ( novoPrato );
	                 
	            
			}
			
			
		}catch (MozartSessionException e){
			
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String adicionarUsuarioLote() throws MozartSessionException{
		try{
			initCombo();
			PontoVendaEJB entidadeSession = (PontoVendaEJB) request.getSession().getAttribute(ENTIDADE_SESSION);
			entidadeSession.setUsuarioPontoVendaEJBList(new ArrayList<UsuarioPontoVendaEJB>());
			
			for(UsuarioEJB usuario:usuarioList){
				
				UsuarioPontoVendaEJB novoUsuario = new UsuarioPontoVendaEJB();
	            novoUsuario.setId(new UsuarioPontoVendaEJBPK());
	            novoUsuario.getId().setIdUsuario(usuario.getIdUsuario());
				novoUsuario.setUsuarioEJB(usuario);
				novoUsuario.setIdHotel(getIdHoteis()[0]);
	            entidadeSession.addUsuario ( novoUsuario );
	                 
	            
			}
			
			
		}catch (MozartSessionException e){
			
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		
		return SUCESSO_FORWARD;
		
	}
			
	
	
			
	public String prepararInclusao(){
		try{
			initCombo();
			entidade.setNomeProprietario(getHotelCorrente().getTitular());
			request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
		}catch (MozartSessionException e){
			
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
			PontoVendaEJBPK id = new PontoVendaEJBPK();
			id.setIdPontoVenda(entidade.getIdPontoVenda());
			id.setIdHotel(getHotelCorrente().getIdHotel());
			
			entidade=(PontoVendaEJB) CheckinDelegate.instance().obter(PontoVendaEJB.class, id);
			entidade.setIdPontoVenda(id.getIdPontoVenda());
			
			if(! MozartUtil.isNull(entidade.getIdCheckin()))
				for(CaixaGeralVO o: apartamentoList){
					if(entidade.getIdCheckin().equals(o.getIdCheckin())){
						cofan = o.getIdApartamento();
					}
				} 
				
			request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	public String gravarPontoVenda() {
		try { 
			PontoVendaEJB entidadeSession = (PontoVendaEJB) request.getSession().getAttribute(ENTIDADE_SESSION);
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			initCombo();
			
			if(!MozartUtil.isNull(entidadeSession.getPratoPontoVendaEJBList())){
				
				entidade.setPratoPontoVendaEJBList(new ArrayList<PratoPontoVendaEJB>());
				for(PratoPontoVendaEJB linha:entidadeSession.getPratoPontoVendaEJBList()){
					linha.setIdPratoPontoVenda(null);
					
					linha.setPratoEJB((PratoEJB)CheckinDelegate.instance().obter(PratoEJB.class, linha.getPratoEJB().getId()));
					entidade.addPrato(linha);
					
				}
				
			}
			
			if(!MozartUtil.isNull(entidadeSession.getUsuarioPontoVendaEJBList())){
				
				entidade.setUsuarioPontoVendaEJBList(new ArrayList<UsuarioPontoVendaEJB>());
				for(UsuarioPontoVendaEJB linha:entidadeSession.getUsuarioPontoVendaEJBList()){
					linha.getId().setIdUsuario(linha.getUsuarioEJB().getIdUsuario().longValue());
					linha.setIdHotel(getIdHoteis()[0]);
					linha.setUsuarioEJB(null);
					linha.setPontoVendaEJB(null);
					entidade.addUsuario(linha);
					
					
				}
				
			}
			
			
			PontoVendaEJBPK id = new PontoVendaEJBPK();
			id.setIdHotel(getHotelCorrente().getIdHotel());
			entidade.setId(id);
			
			entidade.getTipoLancamentoEJB().setIdHotel(getIdHoteis()[0]);
			entidade.getId().setIdPontoVenda(entidade.getIdPontoVenda());
			if(MozartUtil.isNull(entidade.getId().getIdPontoVenda())){
				entidade.setDataPv(getControlaData().getFrontOffice());
				
			}
			
			for(CaixaGeralVO o: apartamentoList){
				if(o.getIdApartamento().equals(cofan)){
					entidade.setIdCheckin(o.getIdCheckin());
				}
			} 
			
			OperacionalDelegate.instance().gravarPontoVenda(entidade);
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new PontoVendaEJB();
			request.getSession().setAttribute(ENTIDADE_SESSION, entidade);
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		} finally{
			
		}
		
		return SUCESSO_FORWARD; 
		
	}
	
	
	
	public String pesquisar(){
		
		try{
			filtro.setIdHoteis(getIdHoteis());
			List<PontoVendaVO> lista = OperacionalDelegate.instance().pesquisarPontoVenda(filtro);
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

	public PontoVendaVO getFiltro() {
		return filtro;
	}

	public void setFiltro(PontoVendaVO filtro) {
		this.filtro = filtro;
	}

	public PontoVendaEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(PontoVendaEJB entidade) {
		this.entidade = entidade;
	}

	public List<MozartComboWeb> getTipoPdvList() {
		return tipoPdvList;
	}

	public void setTipoPdvList(List<MozartComboWeb> tipoPdvList) {
		this.tipoPdvList = tipoPdvList;
	}

	public List<TipoLancamentoEJB> getTipoLancamentoList() {
		return tipoLancamentoList;
	}

	public void setTipoLancamentoList(List<TipoLancamentoEJB> tipoLancamentoList) {
		this.tipoLancamentoList = tipoLancamentoList;
	}

	public List<CaixaGeralVO> getApartamentoList() {
		return apartamentoList;
	}

	public void setApartamentoList(List<CaixaGeralVO> apartamentoList) {
		this.apartamentoList = apartamentoList;
	}

	public List<CentroCustoContabilEJB> getCentroCustoList() {
		return centroCustoList;
	}

	public void setCentroCustoList(List<CentroCustoContabilEJB> centroCustoList) {
		this.centroCustoList = centroCustoList;
	}

	public List<PlanoContaVO> getPlanoContaList() {
		return planoContaList;
	}

	public void setPlanoContaList(List<PlanoContaVO> planoContaList) {
		this.planoContaList = planoContaList;
	}

	public List<TipoLancamentoEJB> getTipoLancamentoServicoList() {
		return tipoLancamentoServicoList;
	}

	public void setTipoLancamentoServicoList(
			List<TipoLancamentoEJB> tipoLancamentoServicoList) {
		this.tipoLancamentoServicoList = tipoLancamentoServicoList;
	}

	public Long getCofan() {
		return cofan;
	}

	public void setCofan(Long cofan) {
		this.cofan = cofan;
	}

	public List<PratoEJB> getPratoList() {
		return pratoList;
	}

	public void setPratoList(List<PratoEJB> pratoList) {
		this.pratoList = pratoList;
	}

	public List<UsuarioEJB> getUsuarioList() {
		return usuarioList;
	}

	public void setUsuarioList(List<UsuarioEJB> usuarioList) {
		this.usuarioList = usuarioList;
	}


	public List<PontoVendaEJB> getPontoVendaList() {
		return pontoVendaList;
	}


	public void setPontoVendaList(List<PontoVendaEJB> pontoVendaList) {
		this.pontoVendaList = pontoVendaList;
	}


	public BigDecimal getQuantidadeMovimentosAbertos() {
		return quantidadeMovimentosAbertos;
	}


	public void setQuantidadeMovimentosAbertos(BigDecimal quantidadeMovimentosAbertos) {
		this.quantidadeMovimentosAbertos = quantidadeMovimentosAbertos;
	}

	public List<NfeImpressoraEJB> getModeloImpressoraList() {
		return modeloImpressoraList;
	}

	public void setModeloImpressoraList(List<NfeImpressoraEJB> modeloImpressoraList) {
		this.modeloImpressoraList = modeloImpressoraList;
	}

	public List<MozartComboWeb> getAmbientePdvList() {
		return ambientePdvList;
	}

	public void setAmbientePdvList(List<MozartComboWeb> ambientePdvList) {
		this.ambientePdvList = ambientePdvList;
	}
	
}