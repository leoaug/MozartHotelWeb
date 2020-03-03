package com.mozart.web.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.struts2.interceptor.PrincipalAware;
import org.apache.struts2.interceptor.PrincipalProxy;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;

import com.mozart.model.ejb.entity.CentralReservaEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.UsuarioEJB;
import com.mozart.model.ejb.entity.UsuarioSessionEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.util.MozartConstantesWeb;
import com.mozart.web.util.MozartWebUtil;
import com.opensymphony.xwork2.ActionSupport;

public abstract class BaseAction extends ActionSupport 
		implements MozartConstantesWeb, PrincipalAware, ServletResponseAware, ServletRequestAware {

	private static final long serialVersionUID = 5615406368560350775L;
	protected PrincipalProxy proxy;
    protected HttpServletResponse response;
    protected HttpServletRequest request;
    protected Logger log = Logger.getLogger(this.getClass());
    protected Long[] idHoteis;
    
    public BaseAction() {
        log.setLevel(Level.ALL);
    }

    public void setPrincipalProxy(PrincipalProxy principalProxy) {
        this.proxy = principalProxy;
    }

    public void setServletResponse(HttpServletResponse httpServletResponse) {
        this.response = httpServletResponse;
    }

    public void setServletRequest(HttpServletRequest httpServletRequest) {
        this.request = httpServletRequest;
    }
    
    protected Boolean isNull(Object object){
        return MozartUtil.isNull(object);
    }
    
    protected HotelEJB getHotelCorrente(){
        return (HotelEJB)request.getSession().getAttribute( 
        		MozartConstantesWeb.HOTEL_SESSION );
    }

    protected HotelEJB getHotelRestauranteCorrente(){
    	return (HotelEJB)request.getSession().getAttribute( 
    			MozartConstantesWeb.HOTEL_RESTAURANTE_SESSION );
    }
    
    protected ControlaDataEJB getControlaData(){
        return (ControlaDataEJB)request.getSession().getAttribute( 
        		MozartConstantesWeb.CONTROLA_DATA_SESSION );
    }
    
    protected CentralReservaEJB getCentralReservaEJB(){
    	CentralReservaEJB result = (CentralReservaEJB)request.getSession().getAttribute( MozartConstantesWeb.CRS_SESSION_NAME );
    	if (result == null){
    		result = getUserSession().getUsuarioEJB().getRedeHotelEJB().getCrsPropria();
    	}
    	return result;
    }
    
    protected boolean isAdm(){
    	String admin = (String)request.getSession().getAttribute(
    			MozartConstantesWeb.USER_ADMIN);
    	return MozartUtil.isNull(admin) || "FALSE".equalsIgnoreCase(admin)?false:true;
    }
    
    protected UsuarioSessionEJB getUserSession(){
        return (UsuarioSessionEJB)request.getSession().getAttribute( 
        		MozartConstantesWeb.USER_SESSION );
    }

    protected UsuarioEJB getUsuario(){
        return getUserSession().getUsuarioEJB();
    }
    protected void addMensagemErro(String mensagem){
        String mensagemExistente = (String)request.getAttribute(
        		MozartConstantesWeb.MENSAGEM_ERRO);
        if (isNull(mensagemExistente)){
            mensagemExistente = "";
        }
        request.setAttribute(MozartConstantesWeb.MENSAGEM_ERRO, 
        		mensagemExistente.concat("<label>"+mensagem+"</label>"));
    }    
    
    protected void addMensagemSucesso(String mensagem){
        String mensagemExistente = (String)request.getAttribute(
        		MozartConstantesWeb.MENSAGEM_SUCESSO);
        mensagemExistente = "";
        request.setAttribute(MozartConstantesWeb.MENSAGEM_SUCESSO, 
        		mensagemExistente.concat("<label>"+mensagem+"</label>"));
    }    

    protected void removeMensagemSucesso(){
        request.removeAttribute(MozartConstantesWeb.MENSAGEM_SUCESSO);
    }    
    
    protected void warn(String mensagem){
        String user = MozartWebUtil.getLogin(request);
        MozartWebUtil.warn(user, mensagem, log);
    }

    protected void info(String mensagem){
        String user = MozartWebUtil.getLogin(request);
        MozartWebUtil.info(user, mensagem, log);
    }

    protected void error(String mensagem){
        String user = MozartWebUtil.getLogin(request);
        MozartWebUtil.error(user, mensagem, log);
    }

    public void setIdHoteis(Long[] idHoteis) {
        this.idHoteis = idHoteis;
    }

    public Long[] getIdHoteis() {
        if (idHoteis == null && 82 != getHotelCorrente().getIdHotel().intValue()){
            idHoteis = new Long[1];
            idHoteis[0] = getHotelCorrente().getIdHotel();        
        }
        return idHoteis;
    }
    
    protected String convertTipoPensao(String hotelPensao){
    	
    	if(hotelPensao.equals("C"))
    		return "SIM";
    	if(hotelPensao.equals("N"))
    		return "NAO";
    	if(hotelPensao.equals("A"))
    		return "ALL";
    	if(hotelPensao.equals("M"))
    		return "MAP";
    	if(hotelPensao.equals("F"))
    		return "FAP";
    	
    	return "";
    }
    
    
	/*
	 * TODO: (ID) Por que foram removidos os métodos abstratos?
	 * 
	 * public abstract String prepararAlteracao();
	 * public abstract String prepararInclusao();
	 * public abstract String gravar();
	 * public abstract String prepararPesquisa();
	 * public abstract String pesquisar();
	 * 
	 */    
}
