package com.mozart.web.util;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.mozart.model.ejb.entity.UsuarioSessionEJB;

public class MozartUtil {

    public MozartUtil() {
    }
    
    public static void warn(String login, String mensagem, Logger log){
        log.warn(formatLogin(login) + ":" + mensagem);
    }

    public static void info(String login, String mensagem, Logger log){
        log.info(formatLogin(login) + ":" + mensagem);
    }

    public static void error(String login, String mensagem, Logger log){
        log.error(formatLogin(login) + ":" + mensagem);
    }
    
    private static String formatLogin(String login){
        return "[" + (com.mozart.model.util.MozartUtil.isNull(login)?"system":login) + "]";
    }
    
    public static String getLogin(HttpServletRequest pRequest){
        UsuarioSessionEJB sessao = (UsuarioSessionEJB) pRequest.getSession().getAttribute(MozartConstantesWeb.USER_SESSION);
        return sessao==null?null:sessao.getUsuarioEJB().getNick();
    }
    
}
