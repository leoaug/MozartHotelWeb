package com.mozart.web.util.cobranca;

import java.util.Date;
import java.util.HashMap;

import org.jrimum.domkee.comum.pessoa.endereco.Endereco;
import org.jrimum.domkee.financeiro.banco.febraban.Agencia;
import org.jrimum.domkee.financeiro.banco.febraban.Carteira;
import org.jrimum.domkee.financeiro.banco.febraban.Cedente;
import org.jrimum.domkee.financeiro.banco.febraban.ContaBancaria;
import org.jrimum.domkee.financeiro.banco.febraban.NumeroDaConta;
import org.jrimum.domkee.financeiro.banco.febraban.Sacado;
import org.jrimum.domkee.financeiro.banco.febraban.SacadorAvalista;
import org.jrimum.domkee.financeiro.banco.febraban.Titulo;
import org.jrimum.texgit.FlatFile;
import org.jrimum.texgit.Record;

import com.mozart.model.util.MozartUtil;
import com.mozart.web.util.cobranca.AbstractFactoryRemessa;

public class FactoryRemessaBradesco extends AbstractFactoryRemessa{

	public FactoryRemessaBradesco(String padraoCNAB) {
		padraoCNABAtivo = new HashMap<String, String>();
		padraoCNABAtivo.put(PADRAO_CNAB_400, "LayoutBradescoCNAB400Envio.txg.xml");
		
		padraoCNABAtual = padraoCNAB;
	}

	@Override
	protected Record createHeader(FlatFile<Record> ff) {
		
		Titulo titulo = getTitulo(boletoAtual);
		Cedente cedente = titulo.getCedente();
		
		Record header = ff.createRecord("Header");
		
		header.setValue("CodigoDaEmpresa", contaCorrente.getCodigoBradesco());
		header.setValue("NomeDaEmpresa", getSubString(cedente.getNome(),30));
		header.setValue("DataGravacaoArquivo", titulo.getDataDoDocumento());
		header.setValue("DataGeracao", boletoAtual.getDataDeProcessamento());
		header.setValue("NumeroSequencialRegistro", ++numeroSequencial);
		
		return header;
	}

	@Override
	protected Record createLancamento(FlatFile<Record> ff, Long idDuplicata) {
		Record lancamento = ff.createRecord("TransacaoTitulo");
		Titulo titulo = boletoAtual.getTitulo();
		
		NumeroDaConta numeroDaConta = titulo.getContaBancaria().getNumeroDaConta();
		Carteira carteira = titulo.getContaBancaria().getCarteira();
		Sacado sacado = titulo.getSacado();
		String nossoNumero = titulo.getNossoNumero() ;
		String nossoNumeroDigito = (titulo.getDigitoDoNossoNumero()==null ?" ":titulo.getDigitoDoNossoNumero()) ;
		Endereco enderecoSacado = getEndereco(sacado.getEnderecos());

		lancamento.setValue("Carteira", carteira.getCodigo()); 
		lancamento.setValue("Agencia", titulo.getContaBancaria().getAgencia().getCodigo()); 
		lancamento.setValue("Conta", numeroDaConta.getCodigoDaConta()); 
		lancamento.setValue("DacConta", numeroDaConta.getDigitoDaConta()); 
		lancamento.setValue("NumeroControleDoParticipante", idDuplicata); //idDuplicata
		lancamento.setValue("IdentificacaoTituloBanco", nossoNumero); 
		lancamento.setValue("DigitoAutoConferenciaNumeroBancario", nossoNumeroDigito); 
		lancamento.setValue("NumeroDoDocumento", titulo.getNumeroDoDocumento()); 
		lancamento.setValue("Vencimento", titulo.getDataDoVencimento());
		lancamento.setValue("Valor", titulo.getValor());
		lancamento.setValue("DataEmissaoTitulo", new Date());
		lancamento.setValue("IdentificadorTipoPagador", sacado.getCPRF().isFisica() ? 1 : 2);
		lancamento.setValue("NumeroInscricaoPagador", sacado.getCPRF().getCodigo());
		lancamento.setValue("NomePagador", getSubString(sacado.getNome(), 40));
		lancamento.setValue("EnderecoPagador", getSubString(enderecoSacado.getLogradouro(), 40));
		lancamento.setValue("CEP", getCepNumerico(enderecoSacado.getCEP()));
		lancamento.setValue("NumeroSequencialRegistro", ++numeroSequencial);
		
		return lancamento;
	}

	@Override
	protected Record createTrailler(FlatFile<Record> ff) {
		Record record = ff.createRecord("Trailler");
		
		record.setValue("NumeroSequencialRegistro",++numeroSequencial);
		return record;
	}

	@Override
	public String getNomeArquivoSaida(String data) {
		return "CB" +
			MozartUtil.format(	
					MozartUtil.toDate(data, "dd/MM/yyyy"),
					"ddMMyy"
			) +
			
			".REM";
	}


}
