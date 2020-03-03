package com.mozart.web.controller;

import com.mozart.model.util.MozartUtil;

import java.sql.Timestamp;

public class UsuarioSession {
    
    private String login;
    private String localAddress;
    private String session;
    private Timestamp dataLogin;


    public UsuarioSession() {
        dataLogin = MozartUtil.now();
    
    }
    
    public boolean equals(Object obj){
        if (obj == null || MozartUtil.isNull(session)){
            return false;
        }
        if (obj instanceof UsuarioSession){
            return session.equals(((UsuarioSession)obj).getSession());
        }
    
        return false;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getLogin() {
        return login;
    }

    public void setLocalAddress(String localAddress) {
        this.localAddress = localAddress;
    }

    public String getLocalAddress() {
        return localAddress;
    }

    public void setSession(String session) {
        this.session = session;
    }

    public String getSession() {
        return session;
    }

    public void setDataLogin(Timestamp dataLogin) {
        this.dataLogin = dataLogin;
    }

    public Timestamp getDataLogin() {
        return dataLogin;
    }
    
    public String getDataLoginFMT() {
        return MozartUtil.format(dataLogin, MozartUtil.FMT_DATE_TIME);
    }
    
}
