package com.mozart.web.controller.agent;

import com.mozart.model.delegate.AlfaDelegate;
import com.mozart.model.delegate.EmailDelegate;
import com.mozart.model.ejb.entity.AlfaArquivoEJB;
import com.mozart.model.ejb.entity.AlfaCertificadoEJB;
import com.mozart.model.util.MozartModelConstantes;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.util.MozartConstantesWeb;
import com.mozart.web.util.MozartWebUtil;

import java.io.BufferedReader;
import java.io.File;

import java.io.FileOutputStream;
import java.io.FileReader;

import java.util.Date;

import org.apache.log4j.Logger;

/**
 * Esta classe é utilizada para trabalhar de forma assíncrona, com 
 * objetivo de realizar a importação e geração de arquivos para a alfa.
 * 
 * @author Márcio.Duques
 * */
 
public class AlfaManagerAsync implements Runnable{

    private Logger log = Logger.getLogger(this.getClass());
    
    public AlfaManagerAsync() {
    }

    public void run() {
    
            MozartWebUtil.warn(null, "Iniciando [ALFA Manager]", log);

            //String URL = "c:\\Alfa";
            String URL = MozartModelConstantes.URL_ALFA_DIRETORIO;
            String URL_INPUT = URL + "/input";
            String URL_HISTORICO = URL + "/historico";
            String URL_OUTPUT = URL + "/output";
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
                            AlfaArquivoEJB arquivoEJB = new AlfaArquivoEJB();
                            BufferedReader file = new BufferedReader(new FileReader(arq));
                            String linha ="";
                            int qtdeLinha = 0;
                            while ((linha = file.readLine())!=null){
                                    qtdeLinha++;
                                    arquivoEJB.addLinha(linha);
                            }
                            file.close();
                            arq = null;
                            System.gc();
    
                            String msgOutPut = "";
                            if ( arquivoEJB.getQtdeRegistro().intValue() != 
                                 arquivoEJB.getAlfaCertificadoEJBList().size() ){
                                //throw erro invalido     
                                 MozartWebUtil.error(null, "Qtde registros não bate com TRAILLER: "+nomeArquivo, log);
                                 msgOutPut = MozartUtil.rpad("Qtde registros não bate com TRAILLER", " ", 50);
                                 
                            }else{
                                AlfaDelegate.gravarArquivo( arquivoEJB );                        
                                MozartWebUtil.warn(null, "Arquivo: "+URL_INPUT+"/"+arquivo+ " gravado com sucesso.", log);
                                arq =  new File( URL_INPUT + "/" +arquivo) ;
                                if (arq.renameTo( new File ( URL_HISTORICO + "/" +arquivo+new Date().getTime() ) )){
                                    MozartWebUtil.warn(null, "Arquivo: "+URL_INPUT+"/"+arquivo+ " movido para ["+URL_HISTORICO + "/" +arquivo+"] com sucesso.", log);
                                }else{
                                    MozartWebUtil.warn(null, "Arquivo: "+URL_INPUT+"/"+arquivo+ " NÃO movido para ["+URL_HISTORICO + "/" +arquivo+"].", log);
                                }
                                msgOutPut = MozartUtil.rpad("Importação realizada com sucesso", " ", 50);
    
                            }   
                            
                            FileOutputStream output = new FileOutputStream ( URL_OUTPUT +"/"+ "09MOZART"+
                                                                             MozartUtil.format( arquivoEJB.getDtGeracao(),"ddMMyyyy") +
                                                                             MozartUtil.lpad( arquivoEJB.getIdArquivo().toString(), "0", 10) +
                                                                             ".txt");
                            String linhas = "H" + MozartUtil.lpad( arquivoEJB.getIdArquivo().toString(), "0", 10) +
                                            "09" + MozartUtil.format( arquivoEJB.getDtGeracao(),"ddMMyyyy") + 
                                            arquivoEJB.getCodOrigem() + MozartUtil.rpad("MOZART SYSTEMS"," ",30) +
                                            arquivoEJB.getCodOrigem() + MozartUtil.rpad(" "," ",939)+"\n";
                            
                            output.write(linhas.getBytes());
                            MozartWebUtil.warn(null, "Gerando arquivo de retorno para: "+ arquivoEJB.getAlfaCertificadoEJBList().size(), log);
                            String dataStr = MozartUtil.format( new Date() ,"ddMMyyyy");
                            for (AlfaCertificadoEJB certificado: arquivoEJB.getAlfaCertificadoEJBList()){
                                linhas = "D"+ MozartUtil.lpad( certificado.getIdCertificado().toString(), "0", 10) +
                                         "000" + msgOutPut + dataStr + MozartUtil.rpad(" "," ",928)+"\n";   
                                output.write(linhas.getBytes());
                                //output.flush();
                            }
                            linhas = "T"+ MozartUtil.lpad( arquivoEJB.getAlfaCertificadoEJBList().size()+"", "0", 8) +
                                     dataStr + MozartUtil.rpad(" "," ",991);   
                            output.write(linhas.getBytes());
                            output.flush();
                            output.close();
                    
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
                                                   "#URGENTE - AlfaManagerAsync#", msgErro);
                    if (erro++ >= 5){
                        EmailDelegate.instance().send(MozartConstantesWeb.EMAIL_ADM_MOZART[0], 
                                                       MozartConstantesWeb.EMAIL_ADM_MOZART[1], 
                                                       "#URGENTE - AlfaManagerAsync - FINALIZADO#", msgErro);
                        throw new RuntimeException(ex.getMessage());
                    }
                }

            }
    }
}
