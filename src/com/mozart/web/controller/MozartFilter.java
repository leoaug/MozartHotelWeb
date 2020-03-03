package com.mozart.web.controller;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.UsuarioDelegate;
import com.mozart.model.ejb.entity.ConfigWebEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.UsuarioEJB;
import com.mozart.model.ejb.entity.UsuarioSessionEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.exception.MozartForaDoHorarioException;
import com.mozart.web.exception.MozartSemPermissaoException;
import com.mozart.web.exception.MozartUsuarioException;
import com.mozart.web.util.MozartConstantesWeb;

import com.mozart.web.util.MozartWebUtil;

import java.io.IOException;
import java.util.Date;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

/**
 * Filtro da aplicação, todos os actions e jsps que precisam ser validadas
 * estão configuradas pra passar por aqui.
 * 
 * Validações de usuario logado e válido. Lembrando que a validação do usuário,
 * é verificada para cada método.
 * 
 * Eu devo melhorar isso mais pra frente, verificar o desempenho e alguns
 * problemas com ajax e comparar com injection.
 * 
 * @author Marcio.Duques
 * */
public class MozartFilter implements Filter {
    private Logger log = Logger.getLogger(this.getClass());
    private FilterConfig _filterConfig = null;
    private String MENSAGEM = "doFilter: %s";

    public void init(FilterConfig filterConfig) throws ServletException {
        set_filterConfig(filterConfig);
    }

    public void destroy() {
        set_filterConfig(null);
    }

    public void doFilter(ServletRequest request, ServletResponse response, 
                         FilterChain chain) throws IOException, ServletException {
                         
        HttpServletRequest  myRequest  = (HttpServletRequest) request;
        
        String curUrl = ((HttpServletRequest)request).getServletPath();

        

        try{
            
            
            if ((myRequest.getSession().getAttribute(MozartConstantesWeb.USER_SESSION))==null){
                throw new MozartUsuarioException("Usuário não autenticado, ao acessar: " + curUrl);
            }else{
                /*
                 * Fazer a validacao do usuario, se está ativo, invalido etc
                 * if (DelegateUsuario.instance().usuarioValido((Usuario)usuario)){
                 *    chain.doFilter(request, response);
                 * }else{
                 *  throw new UsuarioInvalidoException("Usuário inválido");
                 * }
                 * */
                if (true){
                    
                    /*Enumeration num = request.getParameterNames();
                    while (num.hasMoreElements()){
                        String nomepar = num.nextElement().toString();
                        MozartWebUtil.warn( MozartWebUtil.getLogin((HttpServletRequest)request) ,
                            "Par:" + nomepar + ". Value: "+ request.getParameter( nomepar ), log);
                        request.setAttribute(nomepar, request.getParameter( nomepar ));    
                    }*/
                
                	
                	/*Alteração para bloquear usuário somente com acesso de leitura*/
             		UsuarioSessionEJB sessao = (UsuarioSessionEJB) myRequest.getSession().getAttribute(MozartConstantesWeb.USER_SESSION);
                	
                	ConfigWebEJB config = UsuarioDelegate.instance().obterConfiguracaoWeb();
             		if ("S".equals(config.getBloquearAcesso()) && (!"MANUTENCAO".equals( sessao.getUsuarioEJB().getNick()))){
             			request.setAttribute(MozartConstantesWeb.MENSAGEM_SUCESSO, "<label>"+MozartConstantesWeb.MENSAGEM_LOGOFF_TXT+"</label>");
                     }

             		
             		
             		UsuarioEJB user = (UsuarioEJB)CheckinDelegate.instance().refresh(UsuarioEJB.class, sessao.getUsuarioEJB().getIdUsuario());
             		if (!MozartUtil.isTurnoValido(user)){
             			throw new MozartForaDoHorarioException();
             		}
             		
             		
             		/*if (curUrl.indexOf("main!") == -1 && (curUrl.indexOf(".action") > 0) 
             					&& curUrl.indexOf("pesquisa") == -1 
             					&& curUrl.indexOf("selecionar") == -1
             					&& curUrl.indexOf("relatorio") == -1 && sessao.getUsuarioEJB().getNivel().intValue() == 0){*/
             		
             		if (sessao.getUsuarioEJB().getNivel().intValue() == 0){
             			myRequest.getSession().setAttribute("LANCA_TELEFONIA","");
             			if (curUrl.indexOf("manter") > 0 ){
	             			request.setAttribute(MozartConstantesWeb.MENSAGEM_SUCESSO, "<label>"+MozartConstantesWeb.MENSAGEM_USUARIO_CONSULTA+"</label>");
	             			throw new MozartSemPermissaoException(MozartConstantesWeb.MENSAGEM_USUARIO_CONSULTA);
             			}
             		}
             		
                    ControlaDataEJB controlaData =  (ControlaDataEJB)myRequest.getSession().getAttribute(MozartConstantesWeb.CONTROLA_DATA_SESSION);
                    if (!MozartUtil.format(controlaData.getFrontOffice(), MozartUtil.FMT_DATE).equals( MozartUtil.format(new Date(), MozartUtil.FMT_DATE))){
                    	ControlaDataEJB controlaDataNovo = UsuarioDelegate.instance().obterControlaData( controlaData.getIdHotel() );
                        if (!MozartUtil.format(controlaData.getFrontOffice(), MozartUtil.FMT_DATE).equals( MozartUtil.format(controlaDataNovo.getFrontOffice(), MozartUtil.FMT_DATE))){
	                    	myRequest.getSession().setAttribute( MozartConstantesWeb.CONTROLA_DATA_SESSION, controlaDataNovo);
	                    	request.setAttribute(MozartConstantesWeb.MENSAGEM_SUCESSO, "<label>"+MozartConstantesWeb.MENSAGEM_ENCERRAMENTO_TXT+"</label>");
                    	}
                    }

                    MozartWebUtil.warn( MozartWebUtil.getLogin((HttpServletRequest)request) , String.format(MENSAGEM, (Object[])new String[]{curUrl}), log);
                    chain.doFilter(request, response);
                }
            }
                
        }catch(ServletException e){
            MozartWebUtil.error(null, String.format(MENSAGEM, (Object[])new String[]{e.getMessage()}), log);
            e.printStackTrace();
            throw e;
        }catch(Exception e){
            MozartWebUtil.error(null, String.format(MENSAGEM, (Object[])new String[]{e.getMessage()}), log);
        }
        
    }

	public void set_filterConfig(FilterConfig _filterConfig) {
		this._filterConfig = _filterConfig;
	}

	public FilterConfig get_filterConfig() {
		return _filterConfig;
	}
	
}
