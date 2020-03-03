package com.mozart.web.actions.mudanca;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.MudancaDelegate;
import com.mozart.model.delegate.UsuarioDelegate;
import com.mozart.model.ejb.entity.ScmMudancaComplementoEJB;
import com.mozart.model.ejb.entity.ScmMudancaEJB;
import com.mozart.model.ejb.entity.ScmSistemaEJB;
import com.mozart.model.ejb.entity.ScmStatusEJB;
import com.mozart.model.ejb.entity.UsuarioEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ScmMudancaVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class MudancaAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4671997846332060848L;

	private ScmMudancaVO filtro; 
	private ScmMudancaEJB entidade;
	private ScmMudancaComplementoEJB entidadeComplemento;
	private List<ScmSistemaEJB> sistemaList;
	private List<ScmStatusEJB> statusList;
	private List<MozartComboWeb> nivelList;
	private List<UsuarioEJB> usuarioDestinoList;
	private Long nivelUsuario, idCriador;
	
	public MudancaAction(){
		filtro = new ScmMudancaVO();
		sistemaList = Collections.emptyList();
		statusList = Collections.emptyList();
		nivelList = Collections.emptyList();
		usuarioDestinoList = Collections.emptyList();
		//Default: Suporte
		nivelUsuario = new Long(10);
		idCriador = new Long(-1);
	}

	private void initCombo()throws MozartSessionException{
		
		nivelList = new ArrayList<MozartComboWeb>();
		nivelList.add( new MozartComboWeb("3", "Baixo"));
		nivelList.add( new MozartComboWeb("2", "Médio"));
		nivelList.add( new MozartComboWeb("1", "Alto"));
		
		sistemaList = MudancaDelegate.instance().pesquisarSistema();
		statusList = MudancaDelegate.instance().pesquisarStatus( entidade );
		
		//10 - Nivel do usuario do suporte
		UsuarioEJB filtro = new UsuarioEJB();
		filtro.setNivel(nivelUsuario);
		if (nivelUsuario.intValue() == 10)
			filtro.setIdUsuario(idCriador);
		usuarioDestinoList = UsuarioDelegate.instance().listarUsuarios( filtro );
		
	}

	public String gravar(){
		try{
			
			entidade.setUsuario(getUsuario());
			if (MozartUtil.isNull( entidade.getUsuarioEJB())){
				entidade.setUsuarioEJB(getUsuario());
			}
			
			if (MozartUtil.isNull(entidadeComplemento.getId().getDtDataCriacao())){
				entidadeComplemento.getId().setDtDataCriacao( MozartUtil.now() );
			}
			
			if (MozartUtil.isNull( entidade.getIdMudanca())){
				entidade.addScmMudancaComplementos( entidadeComplemento );
				CheckinDelegate.instance().incluir(entidade);
			}else{
				entidade.addScmMudancaComplementos( entidadeComplemento );
				CheckinDelegate.instance().alterar(entidade);
			}
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new ScmMudancaEJB();
			entidadeComplemento = new ScmMudancaComplementoEJB();
			
		}catch(MozartSessionException ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}finally{
			try{
				initCombo();
			}catch(Exception ex){
				error( ex.getMessage() );
				addMensagemErro( MSG_ERRO );
			}
		}
		return SUCESSO_FORWARD; 
	}

	
	
	public String prepararAlteracao(){
		try{
			prepararPesquisa();
			
			entidade = (ScmMudancaEJB)CheckinDelegate.instance().obter(ScmMudancaEJB.class, entidade.getIdMudanca());
			entidadeComplemento = entidade.getScmMudancaComplementos().get( entidade.getScmMudancaComplementos().size()-1 );
			nivelUsuario = getUsuario().getNivel();
			if (nivelUsuario.intValue() == 10)
				idCriador = entidade.getUsuarioEJB().getIdUsuario();
			entidadeComplemento = new ScmMudancaComplementoEJB();
			initCombo();
		}catch(MozartSessionException ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD; 
	}

	public String prepararInclusao(){
		try{
			prepararPesquisa();
			nivelUsuario = getUsuario().getNivel();
			if (nivelUsuario.intValue() == 10)
				idCriador = entidade.getUsuarioEJB().getIdUsuario();
			initCombo();
			
		}catch(MozartSessionException ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		return SUCESSO_FORWARD; 
	}
	
	public String prepararPesquisa(){
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}

	public String pesquisar(){
		
		try{
			
			filtro.setIdHoteis(getIdHoteis());
			filtro.setUsuario(getUsuario());
			List<ScmMudancaVO> lista = MudancaDelegate.instance().pesquisarMudanca( filtro );
			
			if (MozartUtil.isNull(lista)){
				addMensagemSucesso(MSG_PESQUISA_VAZIA);	
			}else{
				request.getSession().setAttribute(LISTA_PESQUISA, lista);
			}
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		
		return SUCESSO_FORWARD;
	}

	public ScmMudancaVO getFiltro() {
		return filtro;
	}

	public void setFiltro(ScmMudancaVO filtro) {
		this.filtro = filtro;
	}


	public ScmMudancaEJB getEntidade() {
		return entidade;
	}


	public void setEntidade(ScmMudancaEJB entidade) {
		this.entidade = entidade;
	}


	public ScmMudancaComplementoEJB getEntidadeComplemento() {
		return entidadeComplemento;
	}


	public void setEntidadeComplemento(ScmMudancaComplementoEJB entidadeComplemento) {
		this.entidadeComplemento = entidadeComplemento;
	}

	public List<ScmSistemaEJB> getSistemaList() {
		return sistemaList;
	}

	public void setSistemaList(List<ScmSistemaEJB> sistemaList) {
		this.sistemaList = sistemaList;
	}

	public List<ScmStatusEJB> getStatusList() {
		return statusList;
	}

	public void setStatusList(List<ScmStatusEJB> statusList) {
		this.statusList = statusList;
	}

	public List<MozartComboWeb> getNivelList() {
		return nivelList;
	}

	public void setNivelList(List<MozartComboWeb> nivelList) {
		this.nivelList = nivelList;
	}

	public List<UsuarioEJB> getUsuarioDestinoList() {
		return usuarioDestinoList;
	}

	public void setUsuarioDestinoList(List<UsuarioEJB> usuarioDestinoList) {
		this.usuarioDestinoList = usuarioDestinoList;
	}

	public Long getNivelUsuario() {
		return nivelUsuario;
	}

	public void setNivelUsuario(Long nivelUsuario) {
		this.nivelUsuario = nivelUsuario;
	}

	public Long getIdCriador() {
		return idCriador;
	}

	public void setIdCriador(Long idCriador) {
		this.idCriador = idCriador;
	}
}
