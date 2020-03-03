package com.mozart.web.actions.operacional;

import com.mozart.model.delegate.CaixaGeralDelegate;
import com.mozart.model.ejb.entity.ConfigNotaEJB;
import com.mozart.web.actions.BaseAction;

import java.util.ArrayList;
import java.util.List;

public class ConfiguracaoNotaFiscalAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4274484466690552165L;
	
	private List<ConfigNotaEJB> configNotaList;
	
	private String[] campos;
	private Long[] linhas;
	private Long[] colunas;

	
	public String prepararAlteracao(){
		
		try{
			
			configNotaList = CaixaGeralDelegate.instance().obterConfiguracaoImpressoraFiscal(getIdHoteis()[0]);	
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	
	
	public String gravar(){
		
		try{
			
			List<ConfigNotaEJB> lista = new ArrayList<ConfigNotaEJB>();
			Long idHotel = getIdHoteis()[0];
			for (int x=0; x<campos.length; x++){
				ConfigNotaEJB linha = new ConfigNotaEJB(campos[x], idHotel, linhas[x], colunas[x] );
				lista.add( linha );
			}
			CaixaGeralDelegate.instance().salvarConfiguracaoNotaFiscal(lista);
			
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro(MSG_ERRO);
		}
		
		return prepararAlteracao();
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public List<ConfigNotaEJB> getConfigNotaList() {
		return configNotaList;
	}

	public void setConfigNotaList(List<ConfigNotaEJB> configNotaList) {
		this.configNotaList = configNotaList;
	}


















	public String[] getCampos() {
		return campos;
	}


















	public void setCampos(String[] campos) {
		this.campos = campos;
	}


















	public Long[] getLinhas() {
		return linhas;
	}


















	public void setLinhas(Long[] linhas) {
		this.linhas = linhas;
	}


















	public Long[] getColunas() {
		return colunas;
	}


















	public void setColunas(Long[] colunas) {
		this.colunas = colunas;
	}

}
