package com.mozart.web.util.cobranca;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.jrimum.bopepo.BancosSuportados;
import org.jrimum.bopepo.Boleto;
import org.jrimum.domkee.comum.pessoa.endereco.CEP;
import org.jrimum.domkee.comum.pessoa.endereco.Endereco;
import org.jrimum.domkee.financeiro.banco.febraban.Titulo;
import org.jrimum.texgit.FlatFile;
import org.jrimum.texgit.Record;
import org.jrimum.texgit.Texgit;
import org.jrimum.utilix.ClassLoaders;

import com.mozart.model.ejb.entity.ContaCorrenteEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.DuplicataVO;

public abstract class AbstractFactoryRemessa {
	
	protected static final String USUARIO = "GRANDE EMPRESA LTD";
	protected static final Integer FILIALMATRIZ = 5000;
	
	protected static final String PADRAO_CNAB_400 = "CNAB400"; 
	protected static final String PADRAO_CNAB_240 = "CNAB240"; 
	
	
	public static AbstractFactoryRemessa create(String codCompensacao, String cnab, ContaCorrenteEJB contaCorrenteEJB){
		AbstractFactoryRemessa instancia = null;
		contaCorrente = contaCorrenteEJB;
		if(codCompensacao.equals(BancosSuportados.BANCO_ITAU.getCodigoDeCompensacao())){
			instancia = new FactoryRemessaItau(cnab);
		}
		if(codCompensacao.equals(BancosSuportados.BANCO_BRADESCO.getCodigoDeCompensacao())){
			instancia = new FactoryRemessaBradesco(cnab);
		}
		if(codCompensacao.equals(BancosSuportados.BANCOOB.getCodigoDeCompensacao())){
			instancia = new FactoryRemessaBancoob(cnab);
		}
		
		return instancia;
	}
	
	protected static final String diretorioTamplate = "com/mozart/web/util/arquivos/templates/remessaRetorno/";
	
	protected Boleto boletoAtual;
	
	protected static ContaCorrenteEJB contaCorrente;
	
	protected HashMap<String, String> padraoCNABAtivo; 
	protected String padraoCNABAtual; 
	protected File layout;
	protected File arquivoSaida;
	protected int numeroSequencial;
	
	public File exportarRemessa(String nomeArquivoSaida, List<Boleto> listBoleto, List<DuplicataVO> listaDuplicatas) throws MozartSessionException {
		
		this.layout = new File(ClassLoaders.getResource(diretorioTamplate + padraoCNABAtivo.get(padraoCNABAtual)).getFile());
		this.arquivoSaida = new File(nomeArquivoSaida);
		FlatFile<Record> ff = Texgit.createFlatFile(this.layout);

		int i =0;
		for(Boleto boleto : listBoleto){
			boletoAtual = boleto;
			
			if(i == 0){
				ff.addRecord(createHeader(ff));
			}
			
			ff.addRecord(createLancamento(ff, listaDuplicatas.get(i).getIdDuplicata()));
			
			
			if( ++i == listBoleto.size()){
				ff.addRecord(createTrailler(ff));
			}
		}

		return createArquivoSaida(ff);
	}
	
	protected Titulo getTitulo(Boleto boleto){
		return boleto.getTitulo();
	}
	
	protected Endereco getEndereco(Collection enderecos){
		
		return (Endereco) ((ArrayList)enderecos).get(0);
	}
	
	protected String getSubString(String texto , int tamanho){
		String retorno = texto;
		if(retorno.length() > tamanho){
			retorno = retorno.substring(0,tamanho);
		}
		return MozartUtil.getTextoSemCaracterEspecial(retorno);
	}
	
	protected String getCepNumerico(CEP cep){
		return MozartUtil.removerNaoNumericos(cep.getCep());
	}

	protected File createArquivoSaida(FlatFile<Record> ff) throws MozartSessionException {
		try {
			FileUtils.writeLines(arquivoSaida, ff.write(), "\r\n");
		} catch (Exception e) {
			throw new MozartSessionException(e.getStackTrace().toString());
		}
		return arquivoSaida;
	}
	
	public abstract String getNomeArquivoSaida(String data);
	protected abstract Record createHeader(FlatFile<Record> ff);
	protected abstract Record createLancamento(FlatFile<Record> ff, Long idDuplicata);
	protected abstract Record createTrailler(FlatFile<Record> ff);
}
