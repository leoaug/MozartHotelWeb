package com.mozart.web.actions.sistema;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.MensagemWebEJB;
import com.mozart.model.ejb.entity.MensagemWebUsuarioEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.HotelVO;
import com.mozart.model.vo.MensagemWebVO;
import com.mozart.model.vo.RedeHotelVO;
import com.mozart.model.vo.UsuarioVO;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class MensagemAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3123427909190980977L;

	private MensagemWebEJB entidade;
	private MensagemWebVO filtro;
	private String usuarioAdm;
	private Long idHotel, idRedeHotel;
	private List<HotelVO> hotelList;
	private List<RedeHotelVO> redeHotelList;
	private List<MozartComboWeb> nivelList;
	private List<UsuarioVO> usuarioList;
	
	private String bloqRede, bloqAdm, suporteMozart;
	
	
	public MensagemAction (){
		
		entidade = new MensagemWebEJB();
		filtro = new MensagemWebVO();
		
	}
	
	private void initCombo() throws MozartSessionException {
		
		HotelVO filtroHotel = new HotelVO();
		RedeHotelVO filtroRede = new RedeHotelVO();
		
		bloqAdm = "S";
		if (isAdm()){
			filtroHotel.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
			filtroRede.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
		}else{
			filtroHotel.setIdHotel( getIdHoteis()[0] );
			bloqRede = "S";
		}
		
		if (getUserSession().getUsuarioEJB().getIdUsuario().equals(new Long(2))){
			filtroHotel = new HotelVO();
			filtroRede = new RedeHotelVO();
			bloqAdm = "N";
		}
		
		nivelList = new ArrayList<MozartComboWeb>();
		nivelList.add( new MozartComboWeb("1","Normal"));
		nivelList.add( new MozartComboWeb("2","Médio"));
		nivelList.add( new MozartComboWeb("3","Urgente"));
		
		hotelList = SistemaDelegate.instance().pesquisarHotel( filtroHotel );
		
		redeHotelList = SistemaDelegate.instance().pesquisarRedeHotel( filtroRede );
		if ( !MozartUtil.isNull(idRedeHotel) || !MozartUtil.isNull(idHotel) || !MozartUtil.isNull(usuarioAdm) || "S".equals(suporteMozart))
			usuarioList = SistemaDelegate.instance().pesquisarUsuario(idRedeHotel, idHotel, usuarioAdm, suporteMozart);
		
	}

	
	@SuppressWarnings("unchecked")
	public String adicionarUsuarioLote(){
		
		try {
			initCombo();
			if (!MozartUtil.isNull( usuarioList )){
				List<MensagemWebUsuarioEJB> entidadeList = (List<MensagemWebUsuarioEJB>)request.getSession().getAttribute("usuarioAdicionadoList");
				for (UsuarioVO user: usuarioList){
		            MensagemWebUsuarioEJB novo = new MensagemWebUsuarioEJB();
		            novo.getUsuarioEJB().setIdUsuario( user.getIdUsuario() );
		            novo.getUsuarioEJB().setNome( user.getNomeUsuario() );
		            novo.getId().setIdUsuario( user.getIdUsuario() );            
		            if (!entidadeList.contains(novo)){
		            	entidadeList.add ( novo );
		             }            
				}
			}
			
		} catch (MozartSessionException e) {
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		return SUCESSO_FORWARD;
	}

	public String removerUsuarioLote(){
		
		try {
			initCombo();
			request.getSession().setAttribute("usuarioAdicionadoList", new ArrayList<MensagemWebUsuarioEJB>());
		} catch (MozartSessionException e) {
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		return SUCESSO_FORWARD;
	}


	public String pesquisarUsuario(){
		
		try {
			initCombo();
			
		} catch (MozartSessionException e) {
			addMensagemErro(MSG_ERRO);
			error(e.getMessage());
		}
		return SUCESSO_FORWARD;
	}

	
	public String prepararInclusao(){
		
		try {
			suporteMozart = "N";
			initCombo();
			entidade = new MensagemWebEJB();
			request.getSession().setAttribute("usuarioAdicionadoList", new ArrayList<MensagemWebUsuarioEJB>());
			
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
			entidade=(MensagemWebEJB)CheckinDelegate.instance().obter(MensagemWebEJB.class, entidade.getIdMensagem());
			request.getSession().setAttribute("usuarioAdicionadoList", entidade.getMensagemWebUsuarioEJBList());
			
		} catch (Exception ex){
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
			
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	@SuppressWarnings("unchecked")
	public String gravar() {
		try {
			initCombo();
			entidade.setUsuario(getUserSession().getUsuarioEJB());
			List<MensagemWebUsuarioEJB> lista = (List<MensagemWebUsuarioEJB>)request.getSession().getAttribute("usuarioAdicionadoList");
			
			for (MensagemWebUsuarioEJB linha: lista){
				entidade.addMensagemWebUsuarioEJB( linha );
			}
			
			if (MozartUtil.isNull(entidade.getIdMensagem())){
				entidade.setDataCriacao(new Timestamp( new Date().getTime()));
				
			} 
			entidade.setUsuarioEJB(getUserSession().getUsuarioEJB() );
			SistemaDelegate.instance().gravarMensagem(entidade);	
			prepararInclusao(); 
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
			
			filtro.setUsuario( getUserSession().getUsuarioEJB() );
			List<MensagemWebVO> lista = SistemaDelegate.instance().pesquisarMensagem(filtro);
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

	public MensagemWebEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(MensagemWebEJB entidade) {
		this.entidade = entidade;
	}

	public MensagemWebVO getFiltro() {
		return filtro;
	}

	public void setFiltro(MensagemWebVO filtro) {
		this.filtro = filtro;
	}

	public List<MozartComboWeb> getNivelList() {
		return nivelList;
	}

	public void setNivelList(List<MozartComboWeb> nivelList) {
		this.nivelList = nivelList;
	}

	public String getUsuarioAdm() {
		return usuarioAdm;
	}

	public void setUsuarioAdm(String usuarioAdm) {
		this.usuarioAdm = usuarioAdm;
	}

	public Long getIdHotel() {
		return idHotel;
	}

	public void setIdHotel(Long idHotel) {
		this.idHotel = idHotel;
	}

	public Long getIdRedeHotel() {
		return idRedeHotel;
	}

	public void setIdRedeHotel(Long idRedeHotel) {
		this.idRedeHotel = idRedeHotel;
	}

	public List<HotelVO> getHotelList() {
		return hotelList;
	}

	public void setHotelList(List<HotelVO> hotelList) {
		this.hotelList = hotelList;
	}

	public List<RedeHotelVO> getRedeHotelList() {
		return redeHotelList;
	}

	public void setRedeHotelList(List<RedeHotelVO> redeHotelList) {
		this.redeHotelList = redeHotelList;
	}

	public List<UsuarioVO> getUsuarioList() {
		return usuarioList;
	}

	public void setUsuarioList(List<UsuarioVO> usuarioList) {
		this.usuarioList = usuarioList;
	}

	public String getBloqRede() {
		return bloqRede;
	}

	public void setBloqRede(String bloqRede) {
		this.bloqRede = bloqRede;
	}

	public String getBloqAdm() {
		return bloqAdm;
	}

	public void setBloqAdm(String bloqAdm) {
		this.bloqAdm = bloqAdm;
	}

	public String getSuporteMozart() {
		return suporteMozart;
	}

	public void setSuporteMozart(String suporteMozart) {
		this.suporteMozart = suporteMozart;
	}

}
