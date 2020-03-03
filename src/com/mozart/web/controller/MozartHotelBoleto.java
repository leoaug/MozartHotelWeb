package com.mozart.web.controller;

import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.jrimum.bopepo.BancosSuportados;
import org.jrimum.bopepo.Boleto;
import org.jrimum.bopepo.FatorDeVencimento;
import org.jrimum.bopepo.view.BoletoViewer;
import org.jrimum.domkee.comum.pessoa.endereco.CEP;
import org.jrimum.domkee.comum.pessoa.endereco.Endereco;
import org.jrimum.domkee.comum.pessoa.endereco.UnidadeFederativa;
import org.jrimum.domkee.financeiro.banco.Banco;
import org.jrimum.domkee.financeiro.banco.febraban.Agencia;
import org.jrimum.domkee.financeiro.banco.febraban.Carteira;
import org.jrimum.domkee.financeiro.banco.febraban.Cedente;
import org.jrimum.domkee.financeiro.banco.febraban.ContaBancaria;
import org.jrimum.domkee.financeiro.banco.febraban.NumeroDaConta;
import org.jrimum.domkee.financeiro.banco.febraban.Sacado;
import org.jrimum.domkee.financeiro.banco.febraban.TipoDeTitulo;
import org.jrimum.domkee.financeiro.banco.febraban.Titulo;
import org.jrimum.domkee.financeiro.banco.febraban.Titulo.Aceite;
import org.jrimum.utilix.ClassLoaders;
import org.jrimum.vallia.digitoverificador.Modulo;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ControladoriaDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
import com.mozart.model.ejb.entity.ConfigBloqueteEJB;
import com.mozart.model.ejb.entity.ConfigBloqueteEJBPK;
import com.mozart.model.ejb.entity.ContaCorrenteEJB;
import com.mozart.model.ejb.entity.ContaCorrenteEJBPK;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.DuplicataEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJBPK;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.UsuarioEJB;
import com.mozart.model.ejb.entity.UsuarioSessionEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.DuplicataVO;
import com.mozart.web.util.MozartWebUtil;
import com.mozart.web.util.cobranca.AbstractFactoryRemessa;

public class MozartHotelBoleto extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String TXT_CONTENT_TYPE = "text/plain;charset=windows-1252";
	private static final String PDF_CONTENT_TYPE = "application/pdf; charset=windows-1252";
	private Logger log = Logger.getLogger(getClass());

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String metodo = request.getRequestURL().toString();
		metodo = request.getParameter("MT");
		try {
			MozartWebUtil.info(null, "Executando método: " + metodo, this.log);
			getClass()

			.getMethod(
					metodo,
					new Class[] { HttpServletRequest.class,
							HttpServletResponse.class }).invoke(this,
					new Object[] { request, response });
		} catch (Exception e) {
			response.setContentType(TXT_CONTENT_TYPE);
			StringBuffer sbContentDispValue = new StringBuffer();
			sbContentDispValue.append("inline; ");
			response.setHeader("Content-disposition", sbContentDispValue.toString());
			
			MozartWebUtil.error(null,
					"Erro ao executar método: " + e.getMessage(), this.log);
			PrintWriter out = response.getWriter();
			out.println("<html>");
			out.println("<body>");
			out.println("<p>" + e.getLocalizedMessage() + ".</p>");
			out.println("</body></html>");
			out.close();
		}
	}
	
	public void exibirTelaBoleto(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException{
		
		RequestDispatcher rd = request.getRequestDispatcher("/pages/modulo/financeiro/faturamento/boleto.jsp");
		rd.forward(request, response);
		
	}

	public void gerarBoletoFaturamento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		int tamanhoPDF = 0;

		try {
			response.setContentType(PDF_CONTENT_TYPE);

			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			
			UsuarioEJB usuario = ((UsuarioSessionEJB) request.getSession()
					.getAttribute("USER_SESSION")).getUsuarioEJB();

			String data = request.getParameter("data");
			String ids = request.getParameter("ids");
			String idContaCorrente = request.getParameter("contaCorrente");

			ContaCorrenteEJB contaCorrente = obterContaCorrente(hotel, usuario, idContaCorrente);

			List<DuplicataVO> listaPesquisa = obterDuplicatas(hotel, data, ids,
					idContaCorrente);

			List<Boleto> listBoletos = gerarBoleto(request, listaPesquisa, contaCorrente);

			
			
			String pathTemplate = "/com/mozart/web/util/arquivos/templates/boletos/";
			
			String template = "BoletoMozartSemSacadorAvalista.pdf";

			File templatePersonalizado = new File(ClassLoaders.getResource(
					pathTemplate + template).getFile());


			byte[] bPDF = BoletoViewer.groupInOnePdfWithTemplate(listBoletos,
					templatePersonalizado);

			tamanhoPDF += bPDF.length;

			StringBuffer sbFilename = new StringBuffer();
			sbFilename.append("boleto_");
			sbFilename.append(System.currentTimeMillis());
			sbFilename.append(".pdf");

			response.reset();
			response.setHeader("Cache-Control", "max-age=30");
			response.setContentType(PDF_CONTENT_TYPE);

			StringBuffer sbContentDispValue = new StringBuffer();
			sbContentDispValue.append("inline");
			sbContentDispValue.append("; filename=");
			sbContentDispValue.append(sbFilename);

			response.setHeader("Content-disposition", sbContentDispValue.toString());
			response.setContentLength(tamanhoPDF);

			ByteArrayOutputStream baosPDF = new ByteArrayOutputStream(
					tamanhoPDF);

			baosPDF.write(bPDF);

			ServletOutputStream sos = response.getOutputStream();
			baosPDF.writeTo(sos);
			sos.flush();
		} catch (Exception dex) {
			response.setContentType("text/html");
			PrintWriter writer = response.getWriter();
			writer.println(getClass().getName() + " Erro: " + dex.getMessage()
					+ "<br>");

			writer.println("<pre>");
			dex.printStackTrace(writer);
			writer.println("</pre>");
		}
	}

	public void gerarArquivoRemessa(HttpServletRequest request,
			HttpServletResponse response
			) throws MozartSessionException {

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		
		UsuarioEJB usuario = ((UsuarioSessionEJB) request.getSession()
				.getAttribute("USER_SESSION")).getUsuarioEJB();

		String data = request.getParameter("data");
		String ids = request.getParameter("ids");
		String idContaCorrente = request.getParameter("contaCorrente");

		
		
		ContaCorrenteEJB contaCorrente = obterContaCorrente(hotel, usuario, idContaCorrente);


		List<DuplicataVO> listaPesquisa = obterDuplicatas(hotel, data, ids,
				idContaCorrente);

		List<Boleto> listBoletos = gerarBoleto(request, listaPesquisa, contaCorrente);

		response.reset();
		AbstractFactoryRemessa factoryRemessa = AbstractFactoryRemessa.create(
				listBoletos.get(0).getTitulo().getContaBancaria().getBanco()
						.getCodigoDeCompensacaoBACEN().getCodigo().toString(),
				"CNAB400", contaCorrente);

		String nomeArquivo = getServletContext().getRealPath(
				"/" + factoryRemessa.getNomeArquivoSaida(data));

		response.setContentType(TXT_CONTENT_TYPE);
		response.setCharacterEncoding("windows-1252");
		response.setHeader("Content-Disposition", "attachment;filename="
				+ factoryRemessa.getNomeArquivoSaida(data));

		File arquivo;
		try {
			arquivo = factoryRemessa.exportarRemessa(nomeArquivo, listBoletos,
					listaPesquisa);
			DataInputStream is = new DataInputStream(new FileInputStream(
					arquivo));

			byte[] bytes = FileUtils.readFileToByteArray(arquivo);
			ServletOutputStream os = response.getOutputStream();
			os.write(bytes);

			is.close();

			arquivo.getAbsoluteFile().delete();
			
			os.flush();
			os.close();
			
		} catch (Exception e) {
			throw new MozartSessionException("Erro na Geração do Arquivo Remessa");
		}

	}

	private ArrayList<Boleto> gerarBoleto(HttpServletRequest req, List<DuplicataVO> listaPesquisa, ContaCorrenteEJB contaCorrente )
			throws MozartSessionException {

		ArrayList<Boleto> listBoletos = new ArrayList<Boleto>();
		Boleto boleto;
		HotelEJB hotel = (HotelEJB) req.getSession().getAttribute(
				"HOTEL_SESSION");

		ControlaDataEJB controlaData = (ControlaDataEJB) req.getSession()
				.getAttribute("CONTROLA_DATA_SESSION");

		Banco banco = null;

		Map<Long, EmpresaHotelEJB> mapCacheEmpresa = new HashMap<Long, EmpresaHotelEJB>();

		Calendar calDoc = Calendar.getInstance();
		calDoc.setTime(controlaData.getFaturamentoContasReceber());

		Calendar calProc = Calendar.getInstance();
		calProc.setTime(controlaData.getFrontOffice());

		for (DuplicataVO duplicata : listaPesquisa) {

			int nossoNumero = duplicata.getSeqBancaria() == null ? 0: duplicata
					.getSeqBancaria().intValue();
			
			String numDocumento = duplicata.getNumDuplicata()
					+ duplicata.getParcela().toString()
					+ MozartUtil.format(duplicata.getDataLancamento(), "yy");

			DuplicataEJB dup = (DuplicataEJB) CheckinDelegate.instance().obter(
					DuplicataEJB.class, duplicata.getIdDuplicata());

			EmpresaHotelEJB empresa = null;
			if (mapCacheEmpresa.containsKey(duplicata.getIdEmpresa())) {
				empresa = (EmpresaHotelEJB) mapCacheEmpresa.get(duplicata
						.getIdEmpresa());
			} else {
				EmpresaHotelEJBPK idEmpresa = new EmpresaHotelEJBPK();
				idEmpresa.idHotel = hotel.getIdHotel();
				idEmpresa.idEmpresa = duplicata.getIdEmpresa();
				empresa = (EmpresaHotelEJB) CheckinDelegate.instance().obter(
						EmpresaHotelEJB.class, idEmpresa);
				mapCacheEmpresa.put(duplicata.getIdEmpresa(), empresa);
			}
			Calendar calVenc = Calendar.getInstance();
			calVenc.setTime(duplicata.getDataVencimento());

			for (BancosSuportados b : BancosSuportados.values()) {
				if (duplicata.getNumBanco().toString()
						.equalsIgnoreCase(b.getCodigoDeCompensacao())) {
					banco = b.create();
				}
			}

			if (banco == null) {
				throw new MozartSessionException("Banco inválido");
			}

			/*
			 * INFORMANDO DADOS SOBRE O CEDENTE.
			 */
			Cedente cedente = new Cedente(hotel.getRazaoSocial(),
					hotel.getCgc());

			/*
			 * INFORMANDO DADOS SOBRE O SACADO.
			 */
			Sacado sacado = new Sacado(empresa.getEmpresaRedeEJB()
					.getEmpresaEJB().getRazaoSocial(), empresa.getEmpresaRedeEJB()
					.getEmpresaEJB().getCgc());

			// Informando o endereço do sacado.
			Endereco enderecoSac = new Endereco();

			enderecoSac.setUF(UnidadeFederativa
					.valueOfSigla(empresa.getEmpresaRedeEJB().getCidade()
							.getEstado().getUf() == null ? "" : empresa
							.getEmpresaRedeEJB().getCidade().getEstado()
							.getUf()));

			enderecoSac.setLocalidade(empresa.getEmpresaRedeEJB().getCidade()
					.getCidade() == null ? "" : empresa.getEmpresaRedeEJB()
					.getCidade().getCidade());
			enderecoSac.setCep(new CEP(
					empresa.getEmpresaRedeEJB().getCep() == null ? "" : empresa
							.getEmpresaRedeEJB().getCep()));
			enderecoSac
					.setBairro(empresa.getEmpresaRedeEJB().getBairro() == null ? ""
							: empresa.getEmpresaRedeEJB().getBairro());
			enderecoSac.setLogradouro(empresa.getEmpresaRedeEJB()
					.getEnderecoCobranca() == null ? "" : empresa
					.getEmpresaRedeEJB().getEnderecoCobranca());
			enderecoSac.setNumero("1");
			sacado.addEndereco(enderecoSac);

			/*
			 * INFORMANDO OS DADOS SOBRE O TÍTULO.
			 */

			// Informando dados sobre a conta bancária do título.

			ContaBancaria contaBancaria = new ContaBancaria(banco);

			contaBancaria.setNumeroDaConta(new NumeroDaConta(new Integer(
					contaCorrente.getNumContaCorrente().intValue()),
					contaCorrente.getDigitoConta().toString()));

			if (contaCorrente.getNumCarteira() != null) {

				contaBancaria.setCarteira(new Carteira(Integer
						.valueOf(contaCorrente.getNumCarteira())));
			}
			if (contaCorrente.getDigitoAgencia() != null) {
				contaBancaria.setAgencia(new Agencia(contaCorrente
						.getNumeroAgencia().intValue(), contaCorrente
						.getDigitoAgencia() + ""));
			}
			contaBancaria.setAgencia(new Agencia(contaCorrente
					.getNumeroAgencia().intValue()));

			Titulo titulo = new Titulo(contaBancaria, sacado, cedente);
			titulo.setNumeroDoDocumento(numDocumento);
			String textoNossoNumero = "";
			String txtFcCedente = cedente.getNome();
			String txtRsInstrucaoAoSacado = hotel.getEndereco();
			txtFcCedente = cedente.getNome() + ", " + cedente.getCPRF().getCodigoFormatado() + ", " +  hotel.getEndereco();
			if (banco
					.getCodigoDeCompensacaoBACEN()
					.getCodigo()
					.equals(Integer.valueOf(BancosSuportados.BANCO_BRADESCO
							.getCodigoDeCompensacao()))) {
				
				String numCarteira = String.format("%02d",
						Integer.valueOf(contaCorrente.getNumCarteira()));
				
				String nossoNum = String.format("%011d", nossoNumero);
				
				textoNossoNumero = numCarteira
						+ "/" + nossoNum + "-" + getDigitoNossoNumeroBradesco(numCarteira+nossoNum);
				
				titulo.setNossoNumero(nossoNum);
				
			
			} else if (banco
					.getCodigoDeCompensacaoBACEN()
					.getCodigo()
					.equals(Integer.parseInt(BancosSuportados.BANCO_ITAU
							.getCodigoDeCompensacao()))) {
				
				String numCarteira = String.format("%03d",
						Integer.valueOf(contaCorrente.getNumCarteira()));
				
				String nossoNum = String.format("%08d", nossoNumero);
				String textoContaCorrente = String.format("%05d",contaCorrente.getNumContaCorrente());
				String textoAgencia= String.format("%04d",contaCorrente.getNumeroAgencia());
				
				textoNossoNumero = numCarteira + " / "
						+ nossoNum +"-"+ getDigitoNossoNumeroItau(textoAgencia + textoContaCorrente + numCarteira + nossoNum);
				
				titulo.setNossoNumero(nossoNum);
				
			}
			else if (banco
					.getCodigoDeCompensacaoBACEN()
					.getCodigo()
					.equals(Integer.parseInt(BancosSuportados.BANCOOB
							.getCodigoDeCompensacao()))) {
								
				String textoAgencia= String.format("%04d",contaCorrente.getNumeroAgencia());
				String textoContaCorrente = String.format("%010d",contaCorrente.getNumContaCorrente());
				String nossoNum = String.format("%07d", nossoNumero);

				textoNossoNumero = nossoNum + "-" + getDigitoNossoNumeroBancoob(textoAgencia + textoContaCorrente + nossoNum);
				
				titulo.setNossoNumero(nossoNum);
				titulo.setDigitoDoNossoNumero(getDigitoNossoNumeroBancoob(textoAgencia + textoContaCorrente + nossoNum));
				
			}
			titulo.setValor(BigDecimal.valueOf(duplicata
					.getValorRecebidoCalculado().doubleValue()));
			titulo.setDataDoDocumento(duplicata.getDataLancamento());
			
//			tratando horario de verão data do fator de vencimento 
			Date dtVencimento = duplicata.getDataVencimento();
			String txtDataVencimento = MozartUtil.format(dtVencimento, "dd/MM/yyyy");
			titulo.setDataDoVencimento(tratarFatorVencimento(dtVencimento));
			String especieDoc = contaCorrente.getEspecieDocumento();
			titulo.setTipoDeDocumento( 
					TipoDeTitulo.valueOfSigla(
							(especieDoc!=null) ? especieDoc : TipoDeTitulo.DS_DUPLICATA_DE_SERVICO.getSigla()
						)
					);
			titulo.setAceite(Aceite.valueOf("N"));
			titulo.getDigitoDoNossoNumero();

			/*
			 * INFORMANDO OS DADOS SOBRE O BOLETO.
			 */
			boleto = new Boleto(titulo);
			
			boleto.getLinhaDigitavel().toString();
			
			ConfigBloqueteEJBPK configBloqueteEJBPK = new ConfigBloqueteEJBPK();
			configBloqueteEJBPK.setIdBanco(contaCorrente.getBancoEJB().getIdBanco());
			configBloqueteEJBPK.setIdHotel(hotel.getIdHotel());
			configBloqueteEJBPK.setCampo("INSTRUCOES%");
			
			ConfigBloqueteEJB configBloqueteEJB = new ConfigBloqueteEJB(configBloqueteEJBPK);
			
			List<ConfigBloqueteEJB> instrucoes = (List<ConfigBloqueteEJB>) ControladoriaDelegate.instance().obterListConfigBloquete(configBloqueteEJB);
			
			for(ConfigBloqueteEJB instrucao : instrucoes){
				if(instrucao.getId().getCampo().equalsIgnoreCase("INSTRUCOES01")){
					boleto.setInstrucao1(getStringNotNull(instrucao.getDescricao()));
				}
				if(instrucao.getId().getCampo().equalsIgnoreCase("INSTRUCOES02")){
					boleto.setInstrucao2(getStringNotNull(instrucao.getDescricao()));
				}
				if(instrucao.getId().getCampo().equalsIgnoreCase("INSTRUCOES03")){
					boleto.setInstrucao3(getStringNotNull(instrucao.getDescricao()));
				}
				if(instrucao.getId().getCampo().equalsIgnoreCase("INSTRUCOES04")){
					boleto.setInstrucao4(getStringNotNull(instrucao.getDescricao()));
				}
				if(instrucao.getId().getCampo().equalsIgnoreCase("INSTRUCOES05")){
					boleto.setInstrucao5(getStringNotNull(instrucao.getDescricao()));
				}
				if(instrucao.getId().getCampo().equalsIgnoreCase("INSTRUCOES06")){
					boleto.setInstrucao6(getStringNotNull(instrucao.getDescricao()));
				}
				if(instrucao.getId().getCampo().equalsIgnoreCase("INSTRUCOES07")){
					boleto.setInstrucao7(getStringNotNull(instrucao.getDescricao()));
				}
				if(instrucao.getId().getCampo().equalsIgnoreCase("INSTRUCOES08")){
					boleto.setInstrucao8(getStringNotNull(instrucao.getDescricao()));
				}
			}

			boleto.setLocalPagamento("Pagável preferencialmente na Rede "
					+ banco.getNome().toUpperCase() + " ou em "
					+ "qualquer Banco até o Vencimento.");

			boleto.setDataDeProcessamento(new Date());
			

//			TEXTOS PERSONALIZADOS
			boleto.addTextosExtras("txtRsNossoNumero", textoNossoNumero);
			boleto.addTextosExtras("txtRsDataVencimento", txtDataVencimento);
			boleto.addTextosExtras("txtRsEspecie", "R$");
			boleto.addTextosExtras("txtRsInstrucaoAoSacado", txtRsInstrucaoAoSacado);

			boleto.addTextosExtras("txtFcDataVencimento", txtDataVencimento);
			boleto.addTextosExtras("txtFcNossoNumero", textoNossoNumero);
			boleto.addTextosExtras("txtFcCedente", txtFcCedente);
			boleto.addTextosExtras("txtFcEspecie", "R$");

			listBoletos.add(boleto);

		}

		return listBoletos;
	}

	private List<DuplicataVO> obterDuplicatas(HotelEJB hotel, String data,
			String ids, String idContaCorrente) throws MozartSessionException {
		DuplicataVO filtro = new DuplicataVO();
		if(!ids.equalsIgnoreCase("-1")){
			filtro.setFiltroIds(ids);
		}
		filtro.setIdHoteis(new Long[] { hotel.getIdHotel() });
		filtro.setFiltroTipoPesquisa("3");
		filtro.getFiltroDataLancamento().setTipo("D");
		filtro.getFiltroDataLancamento().setTipoIntervalo("2");
		filtro.getFiltroDataLancamento().setValorInicial(data);
		if (!MozartUtil.isNull(idContaCorrente)) {
			filtro.getFiltroContaCorrente().setTipo("I");
			filtro.getFiltroContaCorrente().setTipoIntervalo("2");
			filtro.getFiltroContaCorrente().setValorInicial(idContaCorrente);
		}

		List<DuplicataVO> listaPesquisa = FinanceiroDelegate.instance()
				.pesquisarDuplicata(filtro);
		return listaPesquisa;
	}

	private ContaCorrenteEJB obterContaCorrente(HotelEJB hotel,
			UsuarioEJB usuario, String idContaCorrente)
			throws MozartSessionException {
		
		ContaCorrenteEJB contaCorrente = (ContaCorrenteEJB) CheckinDelegate
				.instance().obter(ContaCorrenteEJB.class, Long.parseLong(idContaCorrente));
		return contaCorrente;
	}
	
	private String getStringNotNull(String str){
		return MozartUtil.isNull(str)? "" : str;
		
	}
	
	private Date tratarFatorVencimento(Date dataVencimento){
		int fatorVencimento =  FatorDeVencimento.toFator(dataVencimento);
		Date dtFromFatorVencimento = FatorDeVencimento.toDate(fatorVencimento);
		
		GregorianCalendar dtVencimento = new GregorianCalendar();
		dtVencimento.setTimeInMillis(dataVencimento.getTime());
	
		
		GregorianCalendar dtCalculada = new GregorianCalendar();
		dtCalculada.setTimeInMillis(dtFromFatorVencimento.getTime());
		
		if( ! dtCalculada.equals(dtVencimento) ){
			dtCalculada.add(Calendar.DAY_OF_YEAR, 2);
		}
		
		return dtCalculada.getTime();

	}
	
	private String getDigitoNossoNumeroBradesco(String pString){
		int modulo = Modulo.calculeMod11(pString,2 ,7);
		if(modulo == 1){
			return "P";
		}
		
		return 11-modulo + "";
	}
	private String getDigitoNossoNumeroItau(String pString){
		int modulo = Modulo.calculeMod10(pString,1 ,2);
				
		return 10-modulo + "";
	}
	
	private int calculaSomatorioModuloBancoob(String pString){
		int valor = 0;
		String constante = "3197";
		int countConstante = 0;
		
		for(int i = 0; i < pString.length(); i++){
			int numero = Character.getNumericValue(pString.toCharArray()[i]);
			
			if(numero > 0)
				valor += (numero * Character.getNumericValue(constante.toCharArray()[countConstante]));
			 
			countConstante = countConstante >= 3 ? 0 : countConstante + 1; 
		}
		
		return valor;
	}
	
	private String getDigitoNossoNumeroBancoob(String pString){
		
		int somatorio = calculaSomatorioModuloBancoob(pString);

		int restoDivisao;

		/*
		* Caso o somatório obtido seja menor que 11, considerar como resto da divisão o próprio somatório.
		*/
		if(somatorio < 11){
		  restoDivisao = somatorio;
		}else{
		  restoDivisao = somatorio % 11;
		}

		Integer restoSubtracao = (11 - restoDivisao);

		/*
		* Caso o resto obtido no cálculo do módulo 11 seja 0 ou 1, o segundo NC será
		* igual a 0.
		*/
		if(restoDivisao == 0 || restoDivisao == 1){
			  return "0";
		}else{
			 return restoSubtracao.toString();
		}
	}
}