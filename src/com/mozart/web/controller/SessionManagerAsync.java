package com.mozart.web.controller;

import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.ejb.entity.MensagemWebUsuarioEJB;
import com.mozart.model.ejb.entity.UsuarioSessionEJB;
import com.mozart.web.util.MozartConstantesWeb;

import com.mozart.web.util.MozartWebUtil;
import java.util.List;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;


/**
 * Esta classe é utilizada para trabalhar de forma assíncrona, com 
 * objetivo de realizar consultas em segundo plano, para atualização da sessão.
 * 
 * Cada sessão criada tem uma thread que realiza as consultas, estas threads 
 * são executadas a cada 10 segundos e também têm o poder de invalidar a sessão.
 * 
 * Ex: atualização da lista de mensagens para o usuário.
 * 
 * 
 * @author Márcio.Duques
 * */
public class SessionManagerAsync implements Runnable{
    
    private Logger log = Logger.getLogger(this.getClass());
    
    private static final int DEZ_SEGUNDOS = 10000;
    
    private HttpSession session = null;
    private String id = null;
    
    public SessionManagerAsync(HttpSession session) {
        this.session = session;        
        this.id = session.getId();
    
    }

    
	
	public void run() {

        try{    
            int loopSession = 0;
            int wait4login = 0;
            
            LOOP_GERAL:
                while (Boolean.TRUE){
                    MozartWebUtil.info(null, loopSession++ +": "+ id, log);
                    /*
                     * Limite de tempo máximo para efetuar o login 1 minuto,
                     * caso não faça será considerada uma sessão lixo que não foi invalidada
                     * ai então invalida a sessão.
                     * */
                    while (session.getAttribute(MozartConstantesWeb.USER_SESSION)==null){
                        wait4login++;
                        if (wait4login == 30){
                            MozartWebUtil.warn(null, "Sessão invalidada por falta de login: " + id, log);
                            session.invalidate();
                            break LOOP_GERAL;
                        }
                        Thread.sleep(DEZ_SEGUNDOS);
                    }
                    /*Consulta as mensagens do usuário*/
                    List<MensagemWebUsuarioEJB> mensagens = SistemaDelegate.instance().pesquisarMensagens(((UsuarioSessionEJB)session.getAttribute( MozartConstantesWeb.USER_SESSION )).getUsuarioEJB());
                    session.setAttribute(MozartConstantesWeb.LISTA_MENSAGEM, mensagens);
                    session.setAttribute(MozartConstantesWeb.POSSUI_MENSAGEM_URGENTE, "N");
                    for (MensagemWebUsuarioEJB msg: mensagens){
                    	if (new Long(3).equals( msg.getMensagemWeb().getNivel())){
                    		session.setAttribute(MozartConstantesWeb.POSSUI_MENSAGEM_URGENTE, "S");
                    		break;
                    	}
                    }
                    
                    /*Fim consulta as mensagens do usuário*/
                    
                    Thread.sleep(DEZ_SEGUNDOS);
                }
        }catch(Exception ex){
            MozartWebUtil.error(null, ex.getMessage() +": " + id, log);
        }
    
    
    }
}
