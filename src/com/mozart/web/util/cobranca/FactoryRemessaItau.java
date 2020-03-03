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

public class FactoryRemessaItau extends AbstractFactoryRemessa{

	public FactoryRemessaItau(String padraoCNAB) {
		padraoCNABAtivo = new HashMap<String, String>();
		padraoCNABAtivo.put(PADRAO_CNAB_400, "LayoutItauCNAB400Envio.txg.xml");
		
		padraoCNABAtual = padraoCNAB;
	}

	@Override
	protected Record createHeader(FlatFile<Record> ff) {
		
		Titulo titulo = getTitulo(boletoAtual);
		ContaBancaria contaBancaria = titulo.getContaBancaria();
		Cedente cedente = titulo.getCedente();
		
		Record header = ff.createRecord("Header");
		
		Agencia agencia = contaBancaria.getAgencia();
		
		header.setValue("Agencia", agencia.getCodigo());
		header.setValue("Conta", contaBancaria.getNumeroDaConta().getCodigoDaConta());
		header.setValue("DacConta", contaBancaria.getNumeroDaConta().getDigitoDaConta());
		header.setValue("NomeEmpresa", cedente.getNome());
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
		String nossoNumeroComDigito = titulo.getNossoNumero() + (titulo.getDigitoDoNossoNumero()==null ?"":titulo.getDigitoDoNossoNumero());
		Sacado sacado = titulo.getSacado();
		SacadorAvalista sacadorAvalista = titulo.getSacadorAvalista();
		
		Endereco enderecoSacado = getEndereco(sacado.getEnderecos());

		lancamento.setValue("CodigoInscricao", titulo.getCedente().getCPRF().isFisica() ? 1 : 2); // 1- CPF 2-CNPJ
		lancamento.setValue("NumeroInscricao", titulo.getCedente().getCPRF().getCodigo()); /// numero documento
		lancamento.setValue("Agencia", titulo.getContaBancaria().getAgencia().getCodigo());
		lancamento.setValue("Conta", numeroDaConta.getCodigoDaConta());
		lancamento.setValue("DacConta", numeroDaConta.getDigitoDaConta());
		lancamento.setValue("UsoDaEmpresa", idDuplicata);
		lancamento.setValue("NossoNumeroComDigito", nossoNumeroComDigito);
		lancamento.setValue("NrCarteira", carteira.getCodigo());
		lancamento.setValue("CodigoCarteira", "I");
		lancamento.setValue("CodigoDeOcorrencia", "01");
		lancamento.setValue("NumeroDoDocumento", titulo.getNumeroDoDocumento());
		lancamento.setValue("Vencimento", titulo.getDataDoVencimento());
		lancamento.setValue("Valor", titulo.getValor());
		lancamento.setValue("CodigoCompensacaoBancoRecebedor", "341");
		lancamento.setValue("EspecieDeTitulo", "08");
		lancamento.setValue("Aceite", titulo.getAceite());
		lancamento.setValue("Emissao", titulo.getDataDoDocumento());
		lancamento.setValue("DataDesconto", titulo.getDataDoVencimento());
		lancamento.setValue("TipoInscricaoSacado", sacado.getCPRF().isFisica() ? 1 : 2); // 1- CPF 2-CNPJ
		lancamento.setValue("NumeroInscricaoSacado", sacado.getCPRF().getCodigo()); /// numero documento
		lancamento.setValue("NomeSacado", getSubString(sacado.getNome(),30));
		lancamento.setValue("LogradouroSacado", getSubString(enderecoSacado.getLogradouro(), 40));
		lancamento.setValue("BairroSacado", getSubString(enderecoSacado.getBairro(),12));
		lancamento.setValue("CepSacado", getCepNumerico(getEndereco(sacado.getEnderecos()).getCEP()));
		lancamento.setValue("Cidade", getSubString(enderecoSacado.getLocalidade(),15));
		lancamento.setValue("Estado", getEndereco(sacado.getEnderecos()).getUF());
		
		if(titulo.hasSacadorAvalista()){
			lancamento.setValue("SacadorAvalista", getSubString(sacadorAvalista.getNome(),30));
		}
		
		lancamento.setValue("NumeroSequencialRegistro",++numeroSequencial);
		
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
		return MozartUtil.format(	
				MozartUtil.toDate(data, "dd/MM/yyyy"),
				"ddMMyyyy"
		) +
		".TXT";
	}


}
