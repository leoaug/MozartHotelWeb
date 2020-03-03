package com.mozart.web.actions.rede;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.delegate.ReservaDelegate;
import com.mozart.model.ejb.entity.AdministradorCanaisEJB;
import com.mozart.model.ejb.entity.EmpresaRedeEJB;
import com.mozart.model.ejb.entity.EmpresaRedeEJBPK;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.AdministradorCanaisVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class AdministradorCanaisAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3537578173854807373L;
	
	private AdministradorCanaisEJB entidade;
	private AdministradorCanaisVO filtro;
	
	
	public String prepararPesquisa(){
		
		request.getSession().removeAttribute("listaPesquisa");
		return SUCESSO_FORWARD;
	}
	
	@PostConstruct
	public void init() throws MozartSessionException{
		initCombos();
	}
	
	private void initCombos() throws MozartSessionException {
		List<MozartComboWeb> listaConfirmacao = new ArrayList<MozartComboWeb>();
		listaConfirmacao.add(new MozartComboWeb("S", "Sim"));
		listaConfirmacao.add(new MozartComboWeb("N", "Não"));
		this.request.getSession().setAttribute("LISTA_CONFIRMACAO", listaConfirmacao);
		
		List<MozartComboWeb> listaDipsBloqueio = new ArrayList<MozartComboWeb>();
		listaDipsBloqueio.add(new MozartComboWeb("B", "Bloqueio"));
		listaDipsBloqueio.add(new MozartComboWeb("D", "Disponibilidade"));
		this.request.getSession().setAttribute("LISTA_DISP_BLOQUEIO", listaDipsBloqueio);
	}
	
	public String pesquisar(){
		info("Pesquisando Administradores de Canais");
		try{
			
			request.getSession().removeAttribute("listaPesquisa");

			filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			List<AdministradorCanaisVO> listaPesquisa = RedeDelegate.instance().pesquisarAdministradorCanais(filtro);
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
		info("Preparando inclusão de Administradores de Canais");
		
		
			try {
				initCombos();
				entidade = new AdministradorCanaisEJB();

			} catch (MozartSessionException e) {
				error( e.getMessage() );
				addMensagemErro( "Erro ao Preparar Tela de alteração" );
				return SUCESSO_FORWARD;
			}
			return SUCESSO_FORWARD;

	}
	

	public String prepararAlteracao(){
		
		info("Preparando alteração de Administradores de Canais");
		try{
			initCombos();
			entidade = (AdministradorCanaisEJB)CheckinDelegate.instance().obter(AdministradorCanaisEJB.class, entidade.getIdGds() );
		
			return SUCESSO_FORWARD;
		}catch(MozartSessionException ex){
			error( ex.getMessage() );
			addMensagemErro( "Erro ao Preparar Tela de alteração" );
			return SUCESSO_FORWARD;
		}

	}

	
	public String gravar(){
		
		try{
			entidade.setUsuario( getUserSession().getUsuarioEJB() );
			entidade.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
			
			EmpresaRedeEJBPK empresaRedeEJBPK = new EmpresaRedeEJBPK(entidade.getIdEmpresa(),
					entidade.getIdRedeHotel());
			
			EmpresaRedeEJB er= (EmpresaRedeEJB) CheckinDelegate.instance().obter(EmpresaRedeEJB.class, empresaRedeEJBPK);
			entidade.setEmpresaRedeEJB(er);

			if ( MozartUtil.isNull( entidade.getIdGds() )){
				entidade.setIdGds(ReservaDelegate.instance().obterNextVal());
				entidade = (AdministradorCanaisEJB)CheckinDelegate.instance().incluir(entidade);
			}else{
				entidade = (AdministradorCanaisEJB) CheckinDelegate.instance().alterar(entidade);
				
			}
			addMensagemSucesso( MSG_SUCESSO );
			
			return prepararInclusao();
		}catch(Exception ex){
			error(ex.getMessage());
			addActionError( MSG_ERRO );
			return SUCESSO_FORWARD;
		}		
	}

	public AdministradorCanaisEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(AdministradorCanaisEJB entidade) {
		this.entidade = entidade;
	}

	public AdministradorCanaisVO getFiltro() {
		return filtro;
	}

	public void setFiltro(AdministradorCanaisVO filtro) {
		this.filtro = filtro;
	}

	
}
