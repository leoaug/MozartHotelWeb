package com.mozart.web.util;

import java.util.Calendar;

import br.com.caelum.stella.boleto.Banco;
import br.com.caelum.stella.boleto.Boleto;
import br.com.caelum.stella.boleto.Datas;
import br.com.caelum.stella.boleto.Emissor;
import br.com.caelum.stella.boleto.Sacado;
import br.com.caelum.stella.boleto.bancos.Bradesco;
import br.com.caelum.stella.boleto.transformer.BoletoGenerator;

import com.mozart.model.delegate.AuditoriaDelegate;
import com.mozart.model.delegate.EmailDelegate;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.UsuarioSessionEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;

import com.mozart.model.util.MozartUtil;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

public class MozartWebUtil {

   
    public static void warn(String login, String mensagem, Logger log){
        log.warn(formatLogin(login) + ":" + mensagem);
    }

    public static void info(String login, String mensagem, Logger log){
        log.info(formatLogin(login) + ":" + mensagem);
    }

    public static void error(String login, String mensagem, Logger log){
        log.error(formatLogin(login) + ":" + mensagem);
    }
    
    private static String formatLogin(String login){
        return "[" + (MozartUtil.isNull(login)?"system":login) + "]";
    }
    
    public static String getLogin(HttpServletRequest pRequest){
        UsuarioSessionEJB sessao = (UsuarioSessionEJB) pRequest.getSession().getAttribute(MozartConstantesWeb.USER_SESSION);
        return sessao==null?null:sessao.getUsuarioEJB().getNick();
    }
    
	public static void gerarBoletoSeguro(ControlaDataEJB cd, int qtdeDiasVencimento, HotelEJB hotel, String[] destinatario, Double valorBoleto) throws MozartSessionException{
		
		
			
			String sigla =  hotel.getSigla();
		    String nomeBoleto = "boletoSeguro"+sigla+".pdf";
			String data 	= MozartUtil.format( cd.getFrontOffice() );
			String dataVC 	= MozartUtil.format( MozartUtil.incrementarDia(cd.getFrontOffice(), qtdeDiasVencimento) );

			Long nossoNumero = AuditoriaDelegate.instance().obterNossoNumeroMesAnterior( cd );

            double valor = valorBoleto.doubleValue();
		
			Sacado sacado = Sacado.newSacado()  
		      .withNome(hotel.getNomeFantasia())  
		      .withCpf( MozartUtil.formatCNPJ( hotel.getCgc() ))  
		      .withEndereco( hotel.getEndereco() )  
		      .withBairro(hotel.getBairro())  
		      .withCep( MozartUtil.formatCEP( hotel.getCep() ))  
		      .withCidade( hotel.getCidadeEJB().getCidade() )  
		      .withUf(hotel.getCidadeEJB().getEstado().getUf());  

		 
			Calendar calDoc = Calendar.getInstance();
			calDoc.setTime( MozartUtil.toDate(data) );
	
			Calendar calProc = Calendar.getInstance();
			calProc.setTime( MozartUtil.toDate(data) );
			int tamanhoPDF = 0;
			Boleto[] arrBoleto = new Boleto[1]; 
	
			Calendar calVenc = Calendar.getInstance();
			calVenc.setTime( MozartUtil.toDate(dataVC) );
				
			Datas datas = Datas.newDatas().withDocumento(calDoc.get(Calendar.DAY_OF_MONTH), 
						 									  calDoc.get(Calendar.MONTH)+1, 
						 									  calDoc.get(Calendar.YEAR)).
						 									  
												withProcessamento(calProc.get(Calendar.DAY_OF_MONTH), 
																  calProc.get(Calendar.MONTH)+1, 
																  calProc.get(Calendar.YEAR)).
							  
												withVencimento(calVenc.get(Calendar.DAY_OF_MONTH), 
														  calVenc.get(Calendar.MONTH)+1, 
														  calVenc.get(Calendar.YEAR));
									 
			Emissor emissor = Emissor.newEmissor()  
				          .withCedente("ALFA PREVIDENCIA E VIDA S.A." )  
				          .withAgencia( 2372 )
				          .withDvAgencia( '8'  )  
				          .withContaCorrente(212485)  
				          .withDvContaCorrente('8')
				          .withCarteira(5)
				          .withNossoNumero( nossoNumero  );
		
		
		
			Banco banco = new Bradesco();									
											
						
			Boleto boleto = Boleto.newBoleto()
				      .withBanco(banco)  
				      .withDatas(datas)  
				      .withDescricoes("* Comprovante de Pagamento Alfa Previdência","* Comprovante de Pagamento e Vida S/A", "* Nº da Apólice: 02.982.856", "* Contrato: 614598", "")  
				      .withEmissor(emissor)  
				      .withSacado(sacado)  
				      .withValorBoleto(valor)  
				      .withNoDocumento(String.valueOf(nossoNumero))  
				      .withInstrucoes("ATENÇÃO: SR. CAIXA, NÃO RECEBER APÓS "+dataVC+" DATA DO VENCIMENTO.", "O não pagamento da parcela, implicará na suspensão automática da Cobertura de Seguros,",
				    		  		   "podendo ocorrer o Cancelamento da Apólice, ", "conforme Condições Gerais do Contrato de Seguro", "Após o vencimento procure o seu Corretor de Seguros.")  
				      .withLocaisDePagamento("Pagável em qualquer banco até a data de vencimento", "")
				      .withNoDocumento(String.valueOf(nossoNumero));  
				arrBoleto[tamanhoPDF++] =  boleto;

    	
		    BoletoGenerator gerador = new BoletoGenerator(arrBoleto);
		    
			byte[] pdf = gerador.toPDF();
			
			String para = destinatario[0];
			String comcopia = destinatario.length==2?destinatario[1]:"";
			String assunto = "Boleto de cobraça seguro do mês: "+ MozartUtil.format(MozartUtil.incrementarDia(cd.getFrontOffice(), -1), MozartUtil.FMT_MES_ANO);
			String corpo = "Segue boleto em anexo";
			
			if (!EmailDelegate.instance().send(para, comcopia, assunto, corpo, pdf, nomeBoleto)){
				throw new MozartValidateException("Não foi possível enviar o boleto de seguro por email.");
				
			}
	} 

     
}
