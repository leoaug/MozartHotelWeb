package com.mozart.web.controller.agent;

import com.mozart.model.delegate.AlfaDelegate;
import com.mozart.model.delegate.EmailDelegate;
import com.mozart.web.util.MozartConstantesWeb;
import com.mozart.web.util.MozartWebUtil;

import org.apache.log4j.Logger;

/**
 * Esta classe é utilizada para trabalhar de forma assíncrona, com 
 * objetivo de verificar a quantidade de certificados disponíveis.
 * 
 * @author Márcio.Duques
 * */

public class AlfaVerificaCertificadoAsync implements Runnable {
    public AlfaVerificaCertificadoAsync() {
    }
            
        private Logger log = Logger.getLogger(this.getClass());

        private static String MENSAGEM = 
            "<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\n" + 
            "<tr><td><b>Alfa Seguradora</b>, </td></tr>\n" + 
            "<tr><td>Precisamos de um arquivo com mais certificados, </td></tr>\n" + 
            "<tr><td>pois no momento só temos <b><font color=\"red\">%s</font></b> certificado(s) disponíve(l)(is). </td></tr>\n" + 
            "<tr><td>No aguardo, </td></tr>\n" + 
            "<tr><td><b>Mozart Systems</b> </td></tr>\n" + 
            "</table>";

        public void run() {
            MozartWebUtil.warn(null, "Iniciando [ALFA AlfaVerificaCertificadoAsync]", log);
            int erro = 0;
            while (Boolean.TRUE){
                try{    
                    MozartWebUtil.warn(null, "Verificando certificados disponíveis", log);
                    Long qtdeFree = AlfaDelegate.getQtdeCertificadosFree();
                    if (qtdeFree <= 10){
                        EmailDelegate.instance().send(MozartConstantesWeb.EMAIL_ADM_MOZART[0], 
                                                      MozartConstantesWeb.EMAIL_ADM_MOZART[1], 
                                                      "#URGENTÍSSIMO - Solicitação de novos certificados#", 
                                                      String.format(MENSAGEM,(Object[]) new String[]{qtdeFree+""}));
                    }else if (qtdeFree <= 50){
                        EmailDelegate.instance().send(MozartConstantesWeb.EMAIL_ADM_MOZART[0], 
                                                      MozartConstantesWeb.EMAIL_ADM_MOZART[1], 
                                                      "#URGENTE - Solicitação de novos certificados#", 
                                                      String.format(MENSAGEM,(Object[]) new String[]{qtdeFree+""}));
                    }else if (qtdeFree <=100){
                        EmailDelegate.instance().send(MozartConstantesWeb.EMAIL_ADM_MOZART[0], 
                                                      MozartConstantesWeb.EMAIL_ADM_MOZART[1], 
                                                      "#Solicitação de novos certificados#", 
                                                      String.format(MENSAGEM,(Object[]) new String[]{qtdeFree+""}));
                    }else{
                       /* EmailDelegate.instance().send(MozartConstantesWeb.EMAIL_ADM_MOZART[0], 
                                                      MozartConstantesWeb.EMAIL_ADM_MOZART[1], 
                                                      "#Aviso de certificados#", 
                                                      String.format(MENSAGEM,(Object[]) new String[]{qtdeFree+""}));
                    */}
                    Thread.sleep(1000 * 60 * 60);
                    erro = 0;
                }catch(Exception ex){
                    ex.printStackTrace();
                    String msgErro = "Erro na verificacao dos certificados: "+ ex.getMessage();
                    MozartWebUtil.error(null,  msgErro, log);
                    EmailDelegate.instance().send(MozartConstantesWeb.EMAIL_ADM_MOZART[0], 
                                                  MozartConstantesWeb.EMAIL_ADM_MOZART[1], 
                                                  "#ERRO - AlfaVerificaCertificadoAsync#", msgErro);

                    if (++erro > 5){
                        EmailDelegate.instance().send(MozartConstantesWeb.EMAIL_ADM_MOZART[0], 
                                                      MozartConstantesWeb.EMAIL_ADM_MOZART[1], 
                                                      "#URGENTE - AlfaVerificaCertificadoAsync - FINALIZADO#", msgErro);
                        throw new RuntimeException( ex.getMessage() );
                    }
                    //desenvolver rotina de email
                }

            }

        }
}
