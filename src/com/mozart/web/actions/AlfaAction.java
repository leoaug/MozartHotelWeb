package com.mozart.web.actions;

import com.mozart.model.delegate.AlfaDelegate;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.ApoliceAlfa;
import com.mozart.model.vo.HospedeSegurado;


import com.mozart.model.vo.HotelConsolidadoAlfa;
import com.mozart.web.util.MozartConstantesWeb;

import java.io.File;

import java.io.FileNotFoundException;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class AlfaAction extends BaseAction{

    /**
	 * 
	 */
	private static final long serialVersionUID = 7404289833748825228L;
	private HospedeSegurado filtro = new HospedeSegurado ();
    private HotelConsolidadoAlfa filtroConsolidado = new HotelConsolidadoAlfa ();

    private ApoliceAlfa apolice = new ApoliceAlfa ();
    private File arquivo;
    private String arquivoFileName;
    private String arquivoContentType;
    private List<String> conteudo;
    private String currentSessionID;
    
    
    public AlfaAction() {
        
    }
    
    
    
    public String pesquisarApolice(){
        try{
            info("Gerando apólice de: "+ apolice.getCurrentSessionID()+".");
           
            
            apolice = AlfaDelegate.instance().opterApoliceAlfa( apolice );    
        }catch(Exception ex){
            addMensagemErro( "Erro ao gerar apólice: " +  apolice.getCurrentSessionID());
            error(ex.getMessage());
            apolice = null;
        }
        return SUCESSO_FORWARD;

        
    }
    
    
    public String prepararUpload(){
    
    
    
    
        return SUCESSO_FORWARD;
    }
    
    
    public String upload(){
    
        if (arquivo == null){
            addMensagemErro("O arquivo não pode ser nulo.");
            return SUCESSO_FORWARD;
        }
        if (!arquivoFileName.toUpperCase().endsWith(".TXT")){
            addMensagemErro("Formato do arquivo inválido, deve ser txt");
            return SUCESSO_FORWARD;
        }

        Scanner scan;
        try {
            conteudo = new ArrayList<String>();
            scan = new Scanner(arquivo);
            while (scan.hasNextLine()){
                conteudo.add( scan.nextLine() );
            }
        } catch (FileNotFoundException e) {
            addMensagemErro("Erro ao ler arquivo, entre em contato com a Mozart Systems.");
            error(e.getMessage());
            return SUCESSO_FORWARD;
        }
        addMensagemSucesso(MozartConstantesWeb.MSG_SUCESSO);
        return SUCESSO_FORWARD;
    } 
    
    public String preparaPesquisa(){
    
        HospedeSegurado hospede = new HospedeSegurado();
        hospede.setRedeHotel("");
        List<HospedeSegurado> listaPesquisa = new ArrayList<HospedeSegurado>();
        request.getSession().setAttribute("listaPesquisa", listaPesquisa);
    
        return SUCESSO_FORWARD;
    }


    public String pesquisaConsolidada(){
    
        try{    
           // HospedeSegurado hospede = new HospedeSegurado();
            info("Realizando Consulta Consolidada Alfa" + filtroConsolidado);
            filtroConsolidado.setIdSeguradora( new Long(82) );
            filtroConsolidado.setIdHoteis( getIdHoteis() );
            filtroConsolidado.setIdRedeHotel ( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
            List<HotelConsolidadoAlfa> listaPesquisa =  AlfaDelegate.instance().pesquisarHotelConsolidadoAlfa( filtroConsolidado );
            if (MozartUtil.isNull( listaPesquisa )){
                addMensagemSucesso("Nenhum resultado encontrado.");
            }
            request.getSession().setAttribute("listaPesquisa", listaPesquisa);
        }catch(Exception exc){
            error( exc.getMessage() );
        
            addMensagemErro("Erro ao realizar pesquisa");
        }
        
        return SUCESSO_FORWARD;

    
    }

    public String pesquisa(){
    
        try{    
           // HospedeSegurado hospede = new HospedeSegurado();
            info("Realizando Consulta Alfa" + filtro);
            filtro.setIdSeguradora( new Long(82) );
            //filtro.setIdHoteis( getIdHoteis() );
            filtro.setIdHoteis( getIdHoteis() );
            filtro.setIdRedeHotel ( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel() );
            List<HospedeSegurado> listaPesquisa =  AlfaDelegate.instance().pesquisarHospedeSegurado( filtro );
            if (MozartUtil.isNull( listaPesquisa )){
                addMensagemSucesso("Nenhum resultado encontrado.");
            }
            request.getSession().setAttribute("listaPesquisa", listaPesquisa);
        }catch(Exception exc){
            error( exc.getMessage() );
        
            addMensagemErro("Erro ao realizar pesquisa");
        }
    
        return SUCESSO_FORWARD;
    }


    public String gerarArquivo01(){
    
        try{    
           // HospedeSegurado hospede = new HospedeSegurado();
        	if ( getIdHoteis() == null || getIdHoteis().length != 1){
        		throw new MozartValidateException("Informe um hotel por vez, para gerar o arquivo.");	
        	}

        	if ( filtro.getFiltroDataSaida() == null || MozartUtil.isNull(filtro.getFiltroDataSaida().getTipoIntervalo()) ||
        		MozartUtil.isNull(filtro.getFiltroDataSaida().getValorInicial()) || 
        		MozartUtil.isNull(filtro.getFiltroDataSaida().getValorFinal())){
        			
        		throw new MozartValidateException("Você deve informar o período da data de saída.");	
        	}
        	
            info("Realizando Consulta Alfa" + filtro);
            filtro.setIdSeguradora( new Long(82) );
            filtro.setIdHoteis( getIdHoteis() );
            AlfaDelegate.instance().gerarArquivo01PorHotel( filtro );
            addMensagemSucesso( MSG_SUCESSO );
        }catch(MozartValidateException ex){
        	error( ex.getMessage() );
        	addMensagemSucesso( ex.getMessage() );
        }catch(Exception exc){
            error( exc.getMessage() );
            addMensagemErro(MSG_ERRO);
        }
        return SUCESSO_FORWARD;
    }

    public void setFiltro(HospedeSegurado filtro) {
        this.filtro = filtro;
    }

    public HospedeSegurado getFiltro() {
        return filtro;
    }

    public void setArquivo(File arquivo) {
        this.arquivo = arquivo;
    }

    public File getArquivo() {
        return arquivo;
    }

    public void setConteudo(List<String> conteudo) {
        this.conteudo = conteudo;
    }

    public List<String> getConteudo() {
        return conteudo;
    }

    public void setArquivoFileName(String arquivoFileName) {
        this.arquivoFileName = arquivoFileName;
    }

    public String getArquivoFileName() {
        return arquivoFileName;
    }

    public void setArquivoContentType(String arquivoContentType) {
        this.arquivoContentType = arquivoContentType;
    }

    public String getArquivoContentType() {
        return arquivoContentType;
    }

    public void setFiltroConsolidado(HotelConsolidadoAlfa filtroConsolidado) {
        this.filtroConsolidado = filtroConsolidado;
    }

    public HotelConsolidadoAlfa getFiltroConsolidado() {
        return filtroConsolidado;
    }


    public void setApolice(ApoliceAlfa apolice) {
        this.apolice = apolice;
    }

    public ApoliceAlfa getApolice() {
        return apolice;
    }

    public void setCurrentSessionID(String currentSessionID) {
        this.currentSessionID = currentSessionID;
    }

    public String getCurrentSessionID() {
        return currentSessionID;
    }
}
