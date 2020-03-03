package com.mozart.web.actions;

import com.mozart.model.delegate.UsuarioDelegate;

import com.mozart.model.ejb.entity.UsuarioSessionEJB;

import java.io.File;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class AdminAction extends BaseAction{

    /**
	 * 
	 */
	private static final long serialVersionUID = 357363894457586007L;
	List<String> listaArquivos = Collections.emptyList();
    List<UsuarioSessionEJB> listaSessoes = Collections.emptyList();
    
    private String fileName;


    public AdminAction() {
    }
    
    public String preparar(){
    
        try{
            String path_log = System.getProperty("oracle.j2ee.home")+"/log/oc4j/";
            File diretorioLog = new File(path_log);
            if (diretorioLog.isDirectory() && diretorioLog.canRead()){
                //FilenameFilter filter = new FilenameFilter();
                String[] arquivos = diretorioLog.list();
                listaArquivos = new ArrayList<String>();
                for (String file:arquivos){
                        listaArquivos.add(file);
                }
            
               
                
            }else{
                warn("Não foi possível ler o diretório: " + path_log);
            }
            listaSessoes = UsuarioDelegate.instance().listarSessoesAtivas();
    
        }catch(Exception e){
            error(e.getMessage());
        }
    
        return SUCESSO_FORWARD;
    }

    public void setListaArquivos(List<String> listaArquivos) {
        this.listaArquivos = listaArquivos;
    }

    public List<String> getListaArquivos() {
        return listaArquivos;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileName() {
        return fileName;
    }

    public void setListaSessoes(List<UsuarioSessionEJB> listaSessoes) {
        this.listaSessoes = listaSessoes;
    }

    public List<UsuarioSessionEJB> getListaSessoes() {
        return listaSessoes;
    }
}
