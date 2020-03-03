package com.mozart.web.controller;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

import com.mozart.model.exception.MozartSessionException;
import com.mozart.web.util.MozartWebUtil;

public class MozartHotelNotaFiscal extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String TXT_CONTENT_TYPE = "text/plain;charset=windows-1252";
	private static final String XML_CONTENT_TYPE = "Application/xml";
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
	
	public InputStream downloadArquivoLote(HttpServletRequest request,
			HttpServletResponse response, String nome, String conteudo
			) throws MozartSessionException {

//		response.reset();
// 
//		response.setContentType(TXT_CONTENT_TYPE);
//		response.setCharacterEncoding("windows-1252");
//		response.setHeader("Content-Disposition", "attachment;filename="
//				+ nome + ".xml");
		
		try {
			byte[] bytes = conteudo.getBytes();
			InputStream file = new ByteArrayInputStream(bytes);
//			ServletOutputStream os = response.getOutputStream();
//			os.write(bytes);
//			
//			os.flush();
//			os.close();
			return file;
		} catch (Exception e) {
			throw new MozartSessionException("Erro na Geração do Lote de Notas");
		}

	}
	
	public byte[] downloadXmlArquivoLote(HttpServletRequest request,
			HttpServletResponse response, String nome, String conteudo
			) throws MozartSessionException {

		response.reset();
 
		response.setContentType(TXT_CONTENT_TYPE);
		response.setCharacterEncoding("windows-1252");
		response.setHeader("Content-Disposition", "attachment;filename="
				+ nome + ".xml");
		
		try {
			byte[] bytes = conteudo.getBytes();
			//ServletOutputStream os = response.getOutputStream();
//			os.write(bytes);
//			os.flush();
//			os.close();
			
			return bytes;
		} catch (Exception e) {
			throw new MozartSessionException("Erro na Geração do Lote de Notas");
		}

	}

}