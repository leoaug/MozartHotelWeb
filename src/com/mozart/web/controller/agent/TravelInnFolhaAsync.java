package com.mozart.web.controller.agent;

import com.mozart.model.delegate.EmailDelegate;
import com.mozart.model.delegate.TravelInnDelegate;
import com.mozart.model.util.MozartModelConstantes;
import com.mozart.model.vo.TinnFolhaVO;
import com.mozart.web.util.MozartConstantesWeb;
import com.mozart.web.util.MozartWebUtil;

import java.io.BufferedReader;
import java.io.File;

import java.io.FileReader;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;

/**
 * Esta classe é utilizada para trabalhar de forma assíncrona, com 
 * objetivo de realizar a importação da contabilidade da travelinn.
 * 
 * @author Márcio.Duques
 * */
 
public class TravelInnFolhaAsync implements Runnable{

    private Logger log = Logger.getLogger(this.getClass());
    
    public TravelInnFolhaAsync() {
    }

    public void run() {
    
            MozartWebUtil.warn(null, "Iniciando [Integracao TINN]", log);

            String URL = MozartModelConstantes.URL_TINN_DIRETORIO;
            String URL_INPUT = URL + "/input";
            String URL_HISTORICO = URL + "/historico";

            int erro = 0;
            while (Boolean.TRUE){
                try{    
                        MozartWebUtil.warn(null, "Verificando leitura de arquivo", log);
                        File DIRETORIO = new File(URL_INPUT);
                        String[] files = DIRETORIO.list();
                        DIRETORIO = null;
                        for (String arquivo: files){
                            String nomeArquivo = URL_INPUT+"/"+arquivo;
                            File arq = new File(nomeArquivo);
                            MozartWebUtil.warn(null, "Lendo arquivo: "+nomeArquivo , log);
                            
                            BufferedReader file = new BufferedReader(new FileReader(arq));
                            String linha ="";
                            int qtdeLinha = 0;
                            List<TinnFolhaVO> linhas = new ArrayList<TinnFolhaVO>();
                            while ((linha = file.readLine())!=null){
                                    qtdeLinha++;
                                    TinnFolhaVO obj = new TinnFolhaVO( linha );
                                    obj.setId( new Long(qtdeLinha) );
                                    linhas.add( obj );
                            }
                            file.close();
                            file = null;
                            arq = null;
                            System.gc();
                            
                            TravelInnDelegate.gravarArquivo( linhas );                        
                            MozartWebUtil.warn(null, "Arquivo: "+URL_INPUT+"/"+arquivo+ " gravado com sucesso.", log);
                            arq =  new File( URL_INPUT + "/" +arquivo) ;
                            
                            if(arq.renameTo( new File ( URL_HISTORICO + "/" +arquivo+new Date().getTime() ) )){
                            	MozartWebUtil.warn(null, "Arquivo: "+URL_INPUT+"/"+arquivo+ " movido para ["+URL_HISTORICO + "/" +arquivo+"] com sucesso.", log);
                            }else{
                            	MozartWebUtil.warn(null, "Arquivo: "+URL_INPUT+"/"+arquivo+ " NÃO movido para ["+URL_HISTORICO + "/" +arquivo+"].", log);
                            }
                            
                    }
                    //um minuto
                    Thread.sleep(1000 * 60);
                    erro = 0;
                }catch(Exception ex){
                    ex.printStackTrace();
                    String msgErro = "Erro ao importar arquivo: " + ex.getMessage();
                    MozartWebUtil.error(null, ex.getMessage() +": ", log);
                    EmailDelegate.instance().send(MozartConstantesWeb.EMAIL_ADM_MOZART[0], 
                                                   MozartConstantesWeb.EMAIL_ADM_MOZART[1], 
                                                   "#URGENTE - TravelInnFolhaAsync#", msgErro);
                    if (erro++ >= 5){
                        EmailDelegate.instance().send(MozartConstantesWeb.EMAIL_ADM_MOZART[0], 
                                                       MozartConstantesWeb.EMAIL_ADM_MOZART[1], 
                                                       "#URGENTE - TravelInnFolhaAsync - FINALIZADO#", msgErro);
                        throw new RuntimeException(ex.getMessage());
                    }
                }

            }
    }
}
