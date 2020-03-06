package com.mozart.web.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;

import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.mozart.crypto.MozartCryptoReport;
import com.mozart.model.delegate.AuditoriaDelegate;
import com.mozart.model.delegate.CaixaGeralDelegate;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComprasDelegate;
import com.mozart.model.delegate.ContaCorrenteDelegate;
import com.mozart.model.delegate.ContabilidadeDelegate;
import com.mozart.model.delegate.ControladoriaDelegate;
import com.mozart.model.delegate.CrsDelegate;
import com.mozart.model.delegate.CustoDelegate;
import com.mozart.model.delegate.EmpresaDelegate;
import com.mozart.model.delegate.EstoqueDelegate;
import com.mozart.model.delegate.FinanceiroDelegate;
import com.mozart.model.delegate.MarketingDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.delegate.ReservaDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.delegate.TipoLancamentolDelegate;
import com.mozart.model.delegate.UsuarioDelegate;
import com.mozart.model.ejb.entity.ApartamentoEJB;
import com.mozart.model.ejb.entity.CamareiraEJB;
import com.mozart.model.ejb.entity.CheckinEJB;
import com.mozart.model.ejb.entity.CidadeEJB;
import com.mozart.model.ejb.entity.ClassificacaoContabilEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.EmpresaEJB;
import com.mozart.model.ejb.entity.EmpresaHotelEJB;
import com.mozart.model.ejb.entity.EmpresaRedeEJB;
import com.mozart.model.ejb.entity.EmpresaTarifaEJB;
import com.mozart.model.ejb.entity.FornecedorHotelEJB;
import com.mozart.model.ejb.entity.FornecedorRedeEJB;
import com.mozart.model.ejb.entity.HospedeEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.IdentificaLancamentoEJB;
import com.mozart.model.ejb.entity.ItemRedeEJB;
import com.mozart.model.ejb.entity.ItemRedeEJBPK;
import com.mozart.model.ejb.entity.MensagemWebUsuarioEJB;
import com.mozart.model.ejb.entity.MenuMozartWebEJB;
import com.mozart.model.ejb.entity.MenuMozartWebUsuarioEJB;
import com.mozart.model.ejb.entity.MesaEJB;
import com.mozart.model.ejb.entity.MovimentoApartamentoEJB;
import com.mozart.model.ejb.entity.MovimentoObjetoEJB;
import com.mozart.model.ejb.entity.ObjetoEJB;
import com.mozart.model.ejb.entity.PlanoContaEJB;
import com.mozart.model.ejb.entity.PontoVendaEJB;
import com.mozart.model.ejb.entity.PontoVendaEJBPK;
import com.mozart.model.ejb.entity.PratoEJB;
import com.mozart.model.ejb.entity.PratoEJBPK;
import com.mozart.model.ejb.entity.PratoPontoVendaEJB;
import com.mozart.model.ejb.entity.RoomListEJB;
import com.mozart.model.ejb.entity.StatusNotaEJB;
import com.mozart.model.ejb.entity.TarifaEJB;
import com.mozart.model.ejb.entity.TarifaIdiomaEJB;
import com.mozart.model.ejb.entity.TipoItemEJB;
import com.mozart.model.ejb.entity.TipoLancamentoEJB;
import com.mozart.model.ejb.entity.UsuarioCiRedeEJB;
import com.mozart.model.ejb.entity.UsuarioConsumoInternoEJB;
import com.mozart.model.ejb.entity.UsuarioEJB;
import com.mozart.model.ejb.entity.UsuarioPontoVendaEJB;
import com.mozart.model.ejb.entity.UsuarioPontoVendaEJBPK;
import com.mozart.model.ejb.entity.UsuarioSessionEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.Criptografia;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.AdministradorCanaisVO;
import com.mozart.model.vo.ApartamentoHospedeVO;
import com.mozart.model.vo.ApartamentoVO;
import com.mozart.model.vo.BancoVO;
import com.mozart.model.vo.BloqueioGestaoVO;
import com.mozart.model.vo.CaixaGeralVO;
import com.mozart.model.vo.ClassificacaoContabilFaturamentoVO;
//import com.mozart.model.vo.ClassificacaoContabilFaturamentoVO;
import com.mozart.model.vo.ComprovanteAjusteVO;
import com.mozart.model.vo.ConsumoInternoVO;
import com.mozart.model.vo.ContaCorrenteVO;
import com.mozart.model.vo.ContasPagarVO;
import com.mozart.model.vo.CreditoEmpresaDetalheVO;
import com.mozart.model.vo.CreditoEmpresaVO;
import com.mozart.model.vo.CrsVO;
import com.mozart.model.vo.DuplicataVO;
import com.mozart.model.vo.EmpresaGrupoLancamentoVO;
import com.mozart.model.vo.EmpresaHotelVO;
import com.mozart.model.vo.EmpresaRedeVO;
import com.mozart.model.vo.EmpresaVO;
import com.mozart.model.vo.EstoqueItemVO;
import com.mozart.model.vo.FiscalCodigoVO;
import com.mozart.model.vo.HospedeVO;
import com.mozart.model.vo.HotelVO;
import com.mozart.model.vo.ItemEstoqueVO;
//import com.mozart.model.vo.ListaFiscalServicoVO;
import com.mozart.model.vo.OcupDispVO;
import com.mozart.model.vo.PagamentoReservaVO;
import com.mozart.model.vo.PatrimonioSetorVO;
import com.mozart.model.vo.PlanoContaVO;
import com.mozart.model.vo.PratoConsumoInternoVO;
import com.mozart.model.vo.ReservaApartamentoDiariaVO;
import com.mozart.model.vo.ReservaApartamentoVO;
import com.mozart.model.vo.ReservaVO;
import com.mozart.model.vo.RoomListVO;
import com.mozart.model.vo.StatusNotaVO;
import com.mozart.model.vo.TarifaVO;
import com.mozart.model.vo.TipoApartamentoVO;
import com.mozart.model.vo.TipoDiariaVO;
import com.mozart.model.vo.TipoLancamentoVO;
import com.mozart.model.vo.UsuarioVO;
import com.mozart.model.vo.filtro.ComponenteAjax;
import com.mozart.model.vo.filtro.FiltroWeb;
import com.mozart.web.helper.ArvorePermissaoHelper;
import com.mozart.web.util.MozartComboWeb;
import com.mozart.web.util.MozartConstantesWeb;
import com.mozart.web.util.MozartWebUtil;

@SuppressWarnings({ "unchecked", "rawtypes" })
public class MozartHotelAjax extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String CONTENT_TYPE = "text/plain;charset=windows-1252";
	private Logger log = Logger.getLogger(getClass());

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);
		String metodo = request.getRequestURL().toString();
		metodo = metodo.substring(metodo.indexOf("!") + 1);
		try {
			MozartWebUtil.info(null, "Executando método: " + metodo, this.log);
			getClass()

			.getMethod(
					metodo,
					new Class[] { HttpServletRequest.class,
							HttpServletResponse.class }).invoke(this,
					new Object[] { request, response });
		} catch (Exception e) {
			MozartWebUtil.error(null,
					"Erro ao executar método: " + e.getMessage(), this.log);
			PrintWriter out = response.getWriter();
			out.println("<html>");
			out.println("<body>");
			out.println("<p>" + e.getMessage() + ".</p>");
			out.println("</body></html>");
			out.close();
		}
	}

	public void selecionarCidade(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando cidades", this.log);

		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");

		String valor = request.getParameter("OBJ_VALUE");
		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"$('#%s').val('%s');$('#%s').val('%s');$('div.divLookup').remove();\">%s</li>";
		builder.append("<ul>");
		try {
			List<CidadeEJB> lista = CheckinDelegate.instance().pesquisarCidade(
					valor);
			for (CidadeEJB obj : lista) {
				String nome = obj.getCidade()
						+ " - "
						+ (obj.getEstado() == null ? "ND" : obj.getEstado()
								.getUf());
				builder.append(String.format(
						linha,
						new Object[] { parObj, nome, parObjId,
								String.valueOf(obj.getIdCidade()), nome }));
			}
		} catch (Exception ex) {
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void getPontoVendaSelecionado(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando Ponto de venda", this.log);

		request.getSession().removeAttribute("PDV_SESSION");

		String valor = request.getParameter("OBJ_VALUE");

		StringBuilder builder = new StringBuilder();
		String linha = "atualizarDataRestaurante('%s');killModal();";
		String data = "";
		if (!MozartUtil.isNull(valor)) {
			try {
				HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
						"HOTEL_SESSION");
				PontoVendaEJBPK pdvPK = new PontoVendaEJBPK();
				pdvPK.setIdHotel(hotel.getIdHotel());
				pdvPK.setIdPontoVenda(Long.valueOf(valor));

				PontoVendaEJB pdv = (PontoVendaEJB) CheckinDelegate.instance()
						.obter(PontoVendaEJB.class, pdvPK);

				data = (MozartUtil.isNull(pdv.getDataPv())) ? "" : MozartUtil
						.format(pdv.getDataPv());

				request.getSession().setAttribute("PDV_SESSION", pdv);

			} catch (Exception ex) {
				MozartWebUtil.error(MozartWebUtil.getLogin(request),
						ex.getMessage(), this.log);
			}
		}

		builder.append(String.format(linha, new Object[] { data }));

		PrintWriter out = response.getWriter();

		out.println(builder.toString());
		out.close();
	}

	public void selecionarHospede(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando hóspede", this.log);

		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");

		String valor = request.getParameter("OBJ_VALUE");
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		HospedeVO param = new HospedeVO();
		param.setBcNomeHospede(valor);
		param.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"$('#%s').val('%s');$('#%s').val('%s');$('div.divLookup').remove();\">%s</li>";
		builder.append("<ul>");
		try {
			List<HospedeEJB> listaHospede = CheckinDelegate.instance()
					.pesquisarHospede(param);
			for (HospedeEJB hos : listaHospede) {
				String nome = hos.getNomeHospede()
						+ " "
						+ hos.getSobrenomeHospede()
						+ (MozartUtil.isNull(hos.getCpf()) ? " "
								: new StringBuilder(" - ").append(hos.getCpf())
										.toString());
				nome = nome.replaceAll("'", "");
				builder.append(String.format(linha, new Object[] { parObj,
						nome, parObjId, String.valueOf(hos.getIdHospede()),
						nome }));
			}
		} catch (Exception ex) {
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void selecionarHospedePorNomeSobrenomeCpfPassaporte(
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando hóspede", this.log);

		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");

		String valor = request.getParameter("OBJ_VALUE");
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"$('#%s').val('%s');$('#%s').val('%s');$('div.divLookup').remove();\">%s</li>";
		builder.append("<ul>");
		try {
			List<HospedeVO> listaHospede = RedeDelegate.instance()
					.obterHospedePorNomeSobrenomeCpfPassaporte(
							hotel.getRedeHotelEJB().getIdRedeHotel(), valor);
			for (HospedeVO hos : listaHospede) {
				String nome = hos.getBcNomeHospede()
						+ (MozartUtil.isNull(hos.getBcCpf()) ? " "
								: new StringBuilder(" - ").append(
										hos.getBcCpf()).toString())
						+ (MozartUtil.isNull(hos.getBcPassaporte()) ? " "
								: new StringBuilder(" - ").append(
										hos.getBcPassaporte()).toString());
				nome = nome.replaceAll("'", "");
				builder.append(String.format(linha, new Object[] { parObj,
						nome, parObjId, String.valueOf(hos.getBcIdHospede()),
						nome }));
			}
		} catch (Exception ex) {
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void selecionarEmpresa(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando empresa", this.log);
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");
		String valor = request.getParameter("OBJ_VALUE");
		String isCartao = request.getParameter("IS_CARTAO");

		EmpresaEJB empresaEJB = new EmpresaEJB();
		EmpresaRedeEJB empresaRedeEJB = new EmpresaRedeEJB();
		EmpresaHotelEJB pFiltro = new EmpresaHotelEJB();

		empresaEJB.setCartaoCredito(isCartao);
		empresaRedeEJB.setEmpresaEJB(empresaEJB);
		pFiltro.setEmpresaRedeEJB(empresaRedeEJB);

		pFiltro.setNomeFantasia(valor.toUpperCase());
		pFiltro.setIdHotel(hotel.getIdHotel());
		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"$('#%s').val('%s');$('#%s').val('%s');$('#issEmpresa').val('%s');$('#taxaServicoEmpresa').val('%s');$('#roomTaxEmpresa').val('%s');$('div.divLookup').remove();obterComplementoEmpresa();\" style='%s'>%s%s</li>";
		builder.append("<ul>");
		try {
			List<EmpresaHotelVO> lista = EmpresaDelegate.instance()
					.obterEmpresaLookup(pFiltro);
			for (EmpresaHotelVO empresa : lista) {
				String nome = empresa.getBcNomeFantasia() + " - "
						+ empresa.getCnpj();
				String imagem = "S".equals(empresa.getBcCredito()) ? "<img src='imagens/btnComCredito.png' title='Com crédito'></img>"
						: "<img src='imagens/btnSemCredito.png' title='Sem crédito'></img>";
				String estilo = "S".equals(empresa.getBcCredito()) ? "color:black;"
						: "color:red;";
				builder.append(String.format(
						linha,
						new Object[] { parObj, nome, parObjId,
								String.valueOf(empresa.getBcIdEmpresa()),
								empresa.getBcCalculaIss(),
								empresa.getBcCalculaTaxa(),
								empresa.getBcCalculaRoomtax(), estilo, imagem,
								nome }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void selecionarGds(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request), "Selecionando GDS",
				this.log);
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");
		String valor = request.getParameter("OBJ_VALUE");

		AdministradorCanaisVO gds = new AdministradorCanaisVO();

		gds.setEmpresa(new FiltroWeb());

		gds.getEmpresa().setTipoIntervalo("1");
		gds.getEmpresa().setTipo("C");
		gds.getEmpresa().setValorInicial(valor.toUpperCase());
		gds.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"$('#%s').val('%s');$('#%s').val('%s');$('div.divLookup').remove();obterComplementoEmpresa();\">%s</li>";
		builder.append("<ul>");
		try {
			List<AdministradorCanaisVO> lista = RedeDelegate.instance()
					.pesquisarAdministradorCanais(gds);
			for (AdministradorCanaisVO empresa : lista) {
				String nome = empresa.getNomeFantasia();
				builder.append(String.format(linha, new Object[] { parObj,
						nome, parObjId, String.valueOf(empresa.getIdGds()),
						nome }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void obterMenu(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			String idUsuarioTree = request.getParameter("idUsuarioTree");

			StringBuilder builder = new StringBuilder();
			List<UsuarioEJB> lista = (List) request.getSession().getAttribute(
					"usuarios");
			List<UsuarioEJB> listaDesativada = (List) request.getSession()
					.getAttribute("usuariosDesativados");

			UsuarioEJB usuarioSelecionado = new UsuarioEJB();
			usuarioSelecionado.setIdUsuario(new Long(idUsuarioTree));
			if (lista.contains(usuarioSelecionado)) {
				usuarioSelecionado = (UsuarioEJB) lista.get(lista
						.indexOf(usuarioSelecionado));
			} else {
				usuarioSelecionado = (UsuarioEJB) listaDesativada
						.get(listaDesativada.indexOf(usuarioSelecionado));
			}
			usuarioSelecionado.setMenuMozartWebUsuarioEJBList(UsuarioDelegate
					.instance().listarPermissoes(usuarioSelecionado));
			builder.append("{\"ids\":[");

			Iterator localIterator = usuarioSelecionado
					.getMenuMozartWebUsuarioEJBList().iterator();
			while (localIterator.hasNext()) {
				MenuMozartWebUsuarioEJB menu = (MenuMozartWebUsuarioEJB) localIterator
						.next();
				builder.append("\"" + menu.getIdMenuItem() + "\",");
			}
			builder.delete(builder.lastIndexOf(","),
					builder.lastIndexOf(",") + 1);
			builder.append("]}");

			PrintWriter out = response.getWriter();
			out.println(builder.toString());
			out.close();
		} catch (Exception ex) {
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
			PrintWriter out = response.getWriter();
			out.println("{\"ids\":[]}");
			out.close();
		}
	}

	public void obterConteudoArquivo(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String nomeArquivo = request.getParameter("nomeArquivo");
		String linha = "<li>%s</li>";
		StringBuilder builder = new StringBuilder();
		builder.append("<ul>");
		try {
			String path_log = System.getProperty("oracle.j2ee.home")
					+ "/log/oc4j/";
			Scanner s = new Scanner(new File(path_log + nomeArquivo));
			while (s.hasNextLine()) {
				builder.append(String.format(linha,
						new Object[] { s.nextLine() }));
			}
			builder.append("</ul>");
		} catch (Exception e) {
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					"Erro ao ler arquivo: " + e.getMessage(), this.log);
			builder.append(String.format(linha,
					new Object[] { "Erro ao ler arquivo" }));
			builder.append("</ul>");
		}
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void obterDadosUsuario(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String idUsuarioTree = request.getParameter("idUsuarioTree");
		StringBuilder builder = new StringBuilder();
		List<UsuarioEJB> lista = (List) request.getSession().getAttribute(
				"usuarios");
		List<UsuarioEJB> listaDesativada = (List) request.getSession()
				.getAttribute("usuariosDesativados");
		UsuarioEJB usuario = ((UsuarioSessionEJB) request.getSession()
				.getAttribute("USER_SESSION")).getUsuarioEJB();

		UsuarioEJB usuarioSelecionado = new UsuarioEJB();
		usuarioSelecionado.setIdUsuario(new Long(idUsuarioTree));
		if (lista.contains(usuarioSelecionado)) {
			usuarioSelecionado = (UsuarioEJB) lista.get(lista
					.indexOf(usuarioSelecionado));
		} else {
			usuarioSelecionado = (UsuarioEJB) listaDesativada
					.get(listaDesativada.indexOf(usuarioSelecionado));
		}
		builder.append("nome:"
				+ usuarioSelecionado.getNome()
				+ ";nivel:"
				+ usuarioSelecionado.getNivel()
				+ ";dataExpiracao:"
				+ MozartUtil.format(usuarioSelecionado.getDataValidade(),
						"dd/MM/yyyy")
				+ ";ativo:"
				+ usuarioSelecionado.getAtivo()
				+ ";turno:"
				+ usuarioSelecionado.getTurno()
				+ ";login:"
				+ usuarioSelecionado.getNick().substring(7)
				+ ";"
				+ (usuarioSelecionado.getRedeHotelEJB() == null ? "idRede:N;"
						: usuario.getRedeHotelEJB() == null ? "" : "idRede:S;"));

		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void selecionarEmpresaReserva(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando empresa reserva", this.log);
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");
		String valor = request.getParameter("OBJ_VALUE");

		EmpresaHotelEJB pFiltro = new EmpresaHotelEJB();
		pFiltro.setNomeFantasia(valor.toUpperCase());
		pFiltro.setIdHotel(hotel.getIdHotel());
		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"loading();setarValorJS('%s','%s');setarValorJS('%s','%s');$('div.divLookup').remove();";
		linha = linha + "setarValorJS('reservaVO.bcComissao','%s');";
		linha = linha + "setarValorJS('reservaVO.bcIdEmpresa','%s');";
		linha = linha + "selecionarValorCombo('reservaVO.bcCalculaTaxa','%s');";
		linha = linha
				+ "selecionarValorCombo('reservaVO.bcCalculaRoomTax','%s');";
		linha = linha + "selecionarValorCombo('reservaVO.bcCalculaIss','%s');";
		linha = linha + "consultarCorporate();\" style='%s'>%s%s</li>";
		builder.append("<ul>");
		try {
			List<EmpresaHotelVO> lista = EmpresaDelegate.instance()
					.obterEmpresaLookup(pFiltro);
			for (EmpresaHotelVO empresa : lista) {
				String nome = empresa.getBcNomeFantasia()
						+ " - "
						+ (empresa.getCnpj() == null ? "[Sem CNPJ]" : empresa
								.getCnpj());
				String imagem = "S".equals(empresa.getBcCredito()) ? "<img src='imagens/btnComCredito.png' title='Com crédito'></img>"
						: "<img src='imagens/btnSemCredito.png' title='Sem crédito'></img>";
				String estilo = "S".equals(empresa.getBcCredito()) ? "color:black;"
						: "color:red;";
				builder.append(String.format(
						linha,
						new Object[] { parObj, nome, parObjId,
								String.valueOf(empresa.getBcIdEmpresa()),
								MozartUtil.format(empresa.getBcComissao()),
								String.valueOf(empresa.getBcIdEmpresa()),
								empresa.getBcCalculaTaxa(),
								empresa.getBcCalculaRoomtax(),
								empresa.getBcCalculaIss(), estilo, imagem, nome }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void selecionarBloqueioReserva(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando bloqueio reserva", this.log);
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");

		ReservaVO pFiltro = new ReservaVO();
		pFiltro.setBcIdHotel(hotel.getIdHotel());
		pFiltro.setBcIdEmpresa(Long.parseLong(request.getParameter("idEmpresa")));
		pFiltro.setBcDataEntrada(MozartUtil.toTimestamp(request
				.getParameter("dataEntrada")));
		pFiltro.setBcDataSaida(MozartUtil.toTimestamp(request
				.getParameter("dataSaida")));
		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"setarValorJS('%s','%s');setarValorJS('%s','%s');$('div.divLookup').remove();\">%s</li>";
		builder.append("<ul>");
		try {
			List<ReservaVO> lista = ReservaDelegate.instance().obterBloqueios(
					pFiltro);
			for (ReservaVO reserva : lista) {
				String nome = reserva.getBloqueio();
				builder.append(String.format(
						linha,
						new Object[] { parObj, nome, parObjId,
								String.valueOf(reserva.getBcIdReserva()), nome }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void selecionarBloqueio(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando bloqueio", this.log);
		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");
		String valor = request.getParameter("OBJ_VALUE");

		ReservaVO vo = new ReservaVO();
		vo.setGracFantasia(valor);
		vo.setBcIdHotel(hotel.getIdHotel());

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"setarValorJS('%s','%s');setarValorJS('%s','%s');$('div.divLookup').remove();";
		linha = linha + "consultarTarifasEApartamentos();\">%s</li>";
		builder.append("<ul>");
		try {
			List<ReservaVO> lista = ReservaDelegate.instance()
					.obterBloqueioLookup(vo);
			for (ReservaVO reserva : lista) {
				String nome = reserva.getBcIdReserva()
						+ " - "
						+ MozartUtil.format(reserva.getBcDataEntrada(),
								"dd/MM/yyyy")
						+ " - "
						+ MozartUtil.format(reserva.getBcDataSaida(),
								"dd/MM/yyyy");
				builder.append(String.format(
						linha,
						new Object[] { parObj, nome, parObjId,
								String.valueOf(reserva.getBcIdReserva()), nome }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void consultarCorporate(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"consultando corporate reserva", this.log);
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			Long idEmpresa = Long.parseLong(request.getParameter("idEmpresa"));
			EmpresaHotelVO empresaHotelVO = new EmpresaHotelVO();
			empresaHotelVO.setBcIdHotel(hotel.getIdHotel());
			empresaHotelVO.setBcIdEmpresa(idEmpresa);
			empresaHotelVO = ReservaDelegate.instance()
					.obterEmpresaHotelPorIdEHotel(empresaHotelVO);

			EmpresaHotelVO empresaCorporateVO = null;
			if ((empresaHotelVO.getBcIdCorporate() != null)
					&& (empresaHotelVO.getBcIdCorporate().longValue() > 0L)) {
				empresaCorporateVO = new EmpresaHotelVO();
				empresaCorporateVO.setBcIdHotel(hotel.getIdHotel());
				empresaCorporateVO.setBcIdEmpresa(empresaHotelVO
						.getBcIdCorporate());
				empresaCorporateVO = ReservaDelegate.instance()
						.obterEmpresaHotelPorIdEHotel(empresaCorporateVO);
			}
			EmpresaRedeVO empresaRedeVO = new EmpresaRedeVO();
			empresaRedeVO.setBcIdEmpresa(idEmpresa);
			empresaRedeVO.setBcIdRedeHotel(hotel.getRedeHotelEJB()
					.getIdRedeHotel());
			empresaRedeVO.setBcIdHotel(hotel.getIdHotel());
			empresaRedeVO = ReservaDelegate.instance()
					.obterEmpresaRedePorIdERede(empresaRedeVO);

			EmpresaGrupoLancamentoVO empresaGrupoLancamentoVO = new EmpresaGrupoLancamentoVO();
			empresaGrupoLancamentoVO.setBcIdEmpresa(idEmpresa);
			empresaGrupoLancamentoVO.setBcIdHotel(hotel.getIdHotel());
			List<EmpresaGrupoLancamentoVO> listEmpresaGrupoLancamento = ReservaDelegate
					.instance().obterEmpresaGrupoLancamentoPorHotelEEmpresa(
							empresaGrupoLancamentoVO);

			request.getSession().setAttribute("TELA_RESERVA_EMPRESA_HOTEL",
					empresaHotelVO);

			String script = "killModal();";
			for (EmpresaGrupoLancamentoVO obj : listEmpresaGrupoLancamento) {
				if (new Long(1L).equals(obj.getBcIdIdentificaLancamento())) {
					script = script
							+ "selecionarValorCombo('diariaTotalIdIdentificaLancamento1','"
							+ obj.getBcQuemPaga() + "');";
				} else if (new Long(4L).equals(obj
						.getBcIdIdentificaLancamento())) {
					script = script
							+ "selecionarValorCombo('alimentosEBebidasIdIdentificaLancamento4','"
							+ obj.getBcQuemPaga() + "');";
				} else if (new Long(6L).equals(obj
						.getBcIdIdentificaLancamento())) {
					script = script
							+ "selecionarValorCombo('telefoniaEComunicacoesIdIdentificaLancamento6','"
							+ obj.getBcQuemPaga() + "');";
				} else if (new Long(8L).equals(obj
						.getBcIdIdentificaLancamento())) {
					script = script
							+ "selecionarValorCombo('lavanderiaIdIdentificaLancamento8','"
							+ obj.getBcQuemPaga() + "');";
				} else if (new Long(21L).equals(obj
						.getBcIdIdentificaLancamento())) {
					script = script
							+ "selecionarValorCombo('receitaOutrasIdIdentificaLancamento21','"
							+ obj.getBcQuemPaga() + "');";
				}
			}
			script = script + "setarValorJS('reservaVO.bcContato','"
					+ empresaRedeVO.getBcContato() + "');";
			script = script + "setarValorJS('reservaVO.bcTelefoneContato','"
					+ empresaRedeVO.getBcTelefone() + "');";
			script = script + "setarValorJS('reservaVO.bcFaxContato','"
					+ empresaRedeVO.getBcFax() + "');";
			script = script + "setarValorJS('reservaVO.bcEmailContato','"
					+ empresaRedeVO.getBcEmail() + "');";

			script = script + "setarValorJS('empresaHotelVO.bcCidade','"
					+ empresaHotelVO.getBcCidade() + "');";
			script = script + "setarValorJS('empresaHotelVO.bcIdCidade','"
					+ empresaHotelVO.getBcIdCidade() + "');";

			script = script + "selecionarValorCombo('reservaVO.bcTipoPensao','"
					+ empresaHotelVO.getBcTipoPensao() + "');";
			if (empresaCorporateVO != null) {
				script = script + "setarValorJS('empresaHotelVO.bcCorporate','"
						+ empresaCorporateVO.getBcNomeFantasia() + "');";
				script = script
						+ "setarValorJS('empresaHotelVO.bcIdCorporate','"
						+ empresaCorporateVO.getBcIdCorporate() + "');";
			}
			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void consultarTarifasEApartamentos(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"consultando tarifas e apartamentos da reserva", this.log);
		Long idBloqueio = Long.parseLong(request.getParameter("idBloqueio"));
		ReservaVO vo = new ReservaVO();
		vo.setBcIdReserva(idBloqueio);
		vo = ReservaDelegate.instance().obterReservaPorId(vo);
		request.getSession().setAttribute("BLOQUEIO", vo);

		BloqueioGestaoVO gestao = new BloqueioGestaoVO();
		gestao.setBcIdReserva(idBloqueio);
		gestao = ReservaDelegate.instance().obterBloqueioGestaoPorId(gestao);
		request.getSession().setAttribute("BLOQUEIO_GESTAO", gestao);

		String script = "";
		script = script
				+ "document.getElementById('idGestaoBloqueioCabecalho').contentWindow.atualizar();";
		PrintWriter out = response.getWriter();
		out.println(script);
		out.flush();
		out.close();
	}

	public void carregarApartamentos(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			MozartWebUtil.info(MozartWebUtil.getLogin(request),
					"carregando apartamentos", this.log);

			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			int indiceResApto = -1;
			if ((!"".equals(request.getParameter("indiceResApto")))
					&& (request.getParameter("indiceResApto") != null)) {
				indiceResApto = Integer.parseInt(request
						.getParameter("indiceResApto"));
			}
			ApartamentoVO apto = new ApartamentoVO();
			apto.setBcIdHotel(hotel.getIdHotel());
			apto.setBcDataEntrada(MozartUtil.toTimestamp(request
					.getParameter("dataEntrada")));
			apto.setBcDataSaida(MozartUtil.toTimestamp(request
					.getParameter("dataSaida")));
			apto.setBcIdTipoApartamento(new Long(request
					.getParameter("idTipoApartamento")));

			List<ApartamentoVO> listApartamentos = ReservaDelegate.instance()
					.obterApartamentoPorDisponibilidade(apto);
			request.getSession()
					.setAttribute("APTOS_RESERVA", listApartamentos);
			String TextEValues = "";
			for (ApartamentoVO vo : listApartamentos) {
				TextEValues = TextEValues + vo.getNumApartamentoStatus() + ","
						+ vo.getBcIdApartamento() + "|";
			}
			TextEValues = " ,0|" + TextEValues;
			TextEValues = TextEValues.substring(0, TextEValues.length() - 1);

			String campoCombo = "";
			if (indiceResApto > -1) {
				campoCombo = "bcIdApartamento" + indiceResApto;
			} else {
				campoCombo = "reservaApartamentoVO.bcIdApartamento";
			}
			String script = "preencherComboBoxJS('" + campoCombo + "', '"
					+ TextEValues + "');";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void pesquisarHospede(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"pesquisando hospede", this.log);

		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");
		String valor = request.getParameter("OBJ_VALUE");

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		HospedeVO hospedeVO = new HospedeVO();
		hospedeVO.setBcIdHotel(hotel.getIdHotel());
		hospedeVO.setBcNomeHospede(valor);
		hospedeVO.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());
		List<HospedeVO> listHospede = ReservaDelegate.instance()
				.obterHospedePorNome(hospedeVO);

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"setarValorJS('%s','%s');setarValorJS('%s','%s');$('div.divLookup').remove();";
		linha = linha + "\">%s</li>";
		builder.append("<ul>");
		try {
			for (HospedeVO obj : listHospede) {
				builder.append(String.format(linha,
						new Object[] { parObj, obj.getBcNomeHospede(),
								parObjId, String.valueOf(obj.getBcIdHospede()),
								obj.getBcNomeHospede() }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void adicionarHospedeReservaApartamento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"adicionando hospede em reservaapartamento", this.log);
		try {
			List<RoomListVO> listRoomList = (List) request.getSession()
					.getAttribute("TELA_RESERVA_ROOM_LIST_ATUAL");
			Long idHospedeSelecionado = Long.parseLong(request
					.getParameter("idHospedeSelecionado"));
			String hospedePrincipal = request.getParameter("principal");
			int qtdePaxMax = Integer.parseInt(request
					.getParameter("qtdePaxMax"));

			HospedeVO hospedeVO = new HospedeVO();
			hospedeVO.setBcIdHospede(idHospedeSelecionado);
			hospedeVO = ReservaDelegate.instance().obterHospedePorId(hospedeVO);

			RoomListVO roomListVO = new RoomListVO();
			roomListVO.setBcChegou("N");
			roomListVO.setBcIdHospede(hospedeVO.getBcIdHospede());
			roomListVO.setBcNomeHospede(hospedeVO.getBcNomeHospede());
			roomListVO.setBcPrincipal(hospedePrincipal);

			String script = "";
			if ("S".equals(hospedePrincipal)) {
				for (RoomListVO vo : listRoomList) {
					if ("S".equals(vo.getBcPrincipal())) {
						roomListVO.setBcPrincipal("N");
						break;
					}
				}
			}
			if (MozartUtil.isNull(script)) {
				if (qtdePaxMax > listRoomList.size()) {
					listRoomList.add(roomListVO);
					script = script
							+ "document.getElementById('idResHospede').contentWindow.atualizar();";
					script = script
							+ "document.getElementById('nomeHospede').value = '';";
					script = script + "$('#hospedePrincipal').val('S');";
					script = script
							+ "document.getElementById('idHospedeSelecionado').value = '';";
				} else {
					script = "alerta('O Apartamento já está com a sua capacidade máxima de hospede.');document.getElementById('idResHospede').contentWindow.killModal();";
				}
			}
			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void preparaHospedeReservaApartamento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"colocando hospede de reservaapartamento na sessao", this.log);
		try {
			List<ReservaApartamentoVO> listReservaApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_RESERVA_APARTAMENTO");
			int indiceReservaApto = Integer.parseInt(request
					.getParameter("indiceResApto"));
			ReservaApartamentoVO resAptoCorrente = (ReservaApartamentoVO) listReservaApartamento
					.get(indiceReservaApto);
			request.getSession().setAttribute("TELA_RESERVA_ROOM_LIST_ATUAL",
					resAptoCorrente.getListRoomList());

			String script = "document.getElementById('idResHospede').src = document.getElementById('idResHospede').src;";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void atualizarTelaResApto(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"colocando o hospede no div de reserva apartamento", this.log);
		try {
			List<ReservaApartamentoVO> listReservaApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_RESERVA_APARTAMENTO");
			int indiceReservaApto = Integer.parseInt(request
					.getParameter("indiceResApto"));
			ReservaApartamentoVO resAptoCorrente = (ReservaApartamentoVO) listReservaApartamento
					.get(indiceReservaApto);
			String nomeHospedes = resAptoCorrente.getBcNomesHospedes();
			String nomePrimeiroHospede = resAptoCorrente
					.getBcNomePrimeiroHospede();

			String script = "document.getElementById('idResAptoFrame').contentWindow.document.getElementById('divHospede"
					+ indiceReservaApto
					+ "').innerHTML = '"
					+ nomeHospedes
					+ "';";
			script = script
					+ "document.getElementById('idResAptoFrame').contentWindow.document.getElementById('divHospedePrincipal"
					+ indiceReservaApto + "').innerHTML = '"
					+ nomePrimeiroHospede + "';";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void carregarTipoPagamentoReserva(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"carregando tipos pagamento reserva", this.log);
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			PagamentoReservaVO pagamentoReservaVO = new PagamentoReservaVO();
			pagamentoReservaVO.setBcIdHotel(hotel.getIdHotel());
			pagamentoReservaVO.setBcFormaPg(request.getParameter("formaPg"));

			boolean ativarCofan = pagamentoReservaVO.getBcFormaPg()
					.equalsIgnoreCase("A");

			request.getSession().setAttribute("ATIVAR_COFAN", ativarCofan);

			List<PagamentoReservaVO> listTiposPagamentos = ReservaDelegate
					.instance()
					.obterTiposDePagamentoReserva(pagamentoReservaVO);
			String TextEValues = "";
			for (PagamentoReservaVO vo : listTiposPagamentos) {
				TextEValues = TextEValues + vo.getBcFormaPg() + ","
						+ vo.getBcIdTipoLancamento() + ","
						+ "identificaLancamento="
						+ vo.getBcIdIdentificaLancamento() + "|";
			}
			TextEValues = TextEValues.substring(0, TextEValues.length() - 1);

			String script = "killModal();preencherComboBoxJS('pagamentoReservaVO.bcIdTipoLancamento', '"
					+ TextEValues
					+ "');"
					+ "ativarDesativarCofan('"
					+ ativarCofan + "');";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void editarReservaApartamentoInformacoes(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"editando o reserva apartamento", this.log);
		try {
			List<ReservaApartamentoVO> listReservaApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_RESERVA_APARTAMENTO");
			int indiceReservaApto = Integer.parseInt(request
					.getParameter("indiceResApto"));
			ReservaApartamentoVO resAptoCorrente = (ReservaApartamentoVO) listReservaApartamento
					.get(indiceReservaApto);

			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			TipoApartamentoVO tipoApartamentoVO = new TipoApartamentoVO();
			tipoApartamentoVO.setBcIdHotel(hotel.getIdHotel());
			List<TipoApartamentoVO> listTipoApto = ReservaDelegate.instance()
					.obterTipoApartamentoPorHotel(tipoApartamentoVO);
			String TextEValuesTipoApto = "";
			for (TipoApartamentoVO obj : listTipoApto) {
				TextEValuesTipoApto = TextEValuesTipoApto + obj.getBcFantasia()
						+ "," + obj.getBcIdTipoApartamento() + "|";
			}
			TextEValuesTipoApto = " ,0|" + TextEValuesTipoApto;
			TextEValuesTipoApto = TextEValuesTipoApto.substring(0,
					TextEValuesTipoApto.length() - 1);

			String TextEValuesPax = " ,0|Single,1|Double,2|Triple,3|Quadruple,4|Fivefold,5|Sixfold,6|Sevenfold,7";

			TipoDiariaVO tipoDiariaVO = new TipoDiariaVO();
			tipoDiariaVO.setBcIdRedeHotel(hotel.getIdHotel());
			List<TipoDiariaVO> listTipoDiaria = ReservaDelegate.instance()
					.obterTipoDiariaPorHotel(tipoDiariaVO);
			String TextEValuesTipoDiaria = "";
			for (TipoDiariaVO obj : listTipoDiaria) {
				TextEValuesTipoDiaria = TextEValuesTipoDiaria
						+ obj.getBcDescricao() + "," + obj.getBcIdTipoDiaria()
						+ "|";
			}
			TextEValuesTipoDiaria = TextEValuesTipoDiaria.substring(0,
					TextEValuesTipoDiaria.length() - 1);

			ApartamentoVO apto = new ApartamentoVO();
			apto.setBcIdHotel(hotel.getIdHotel());
			apto.setBcDataEntrada(resAptoCorrente.getBcDataEntrada());
			apto.setBcDataSaida(resAptoCorrente.getBcDataSaida());
			apto.setBcIdTipoApartamento(resAptoCorrente
					.getBcIdTipoApartamento());
			List<ApartamentoVO> listApartamentos = ReservaDelegate.instance()
					.obterApartamentoPorDisponibilidade(apto);
			String TextEValuesAptos = "";
			for (ApartamentoVO vo : listApartamentos) {
				TextEValuesAptos += vo.getNumApartamentoStatus() + ","
						+ vo.getBcIdApartamento() + "|";
			}
			if (request.getSession().getAttribute("TELA_RESERVA_OPERACAO_TELA")
					.equals("TELA_RESERVA_OPERACAO_TELA_ALTERACAO")) {
				for (ReservaApartamentoVO objResApto : listReservaApartamento) {
					if (objResApto.getBcIdTipoApartamento().equals(
							resAptoCorrente.getBcIdTipoApartamento())) {
						if ((objResApto.getBcIdApartamento() != null)
								&& (!objResApto.getBcIdApartamento().equals(
										new Long(0L)))) {
							if (!TextEValuesAptos.contains(objResApto
									.getBcIdApartamento().toString())) {
								TextEValuesAptos =

								TextEValuesAptos
										+ objResApto.getBcApartamentoDesc()
										+ " OA,"
										+ objResApto.getBcIdApartamento() + "|";
							}
						}
					}
				}
			}
			TextEValuesAptos = " ,0|" + TextEValuesAptos;
			TextEValuesAptos = TextEValuesAptos.substring(0,
					TextEValuesAptos.length() - 1);

			String script = "preencherComboBoxJS('bcIdTipoApartamento"
					+ indiceReservaApto + "', '" + TextEValuesTipoApto + "');";
			script = script + "preencherComboBoxJS('bcQtdePax"
					+ indiceReservaApto + "', '" + TextEValuesPax + "');";
			script = script + "preencherComboBoxJS('bcIdTipoDiaria"
					+ indiceReservaApto + "', '" + TextEValuesTipoDiaria
					+ "');";
			script = script + "preencherComboBoxJS('bcIdApartamento"
					+ indiceReservaApto + "', '" + TextEValuesAptos + "');";
			script = script
					+ "setarValorJS('bcDataEntrada"
					+ indiceReservaApto
					+ "','"
					+ MozartUtil.format(resAptoCorrente.getBcDataEntrada(),
							"dd/MM/yyyy") + "');";
			script = script
					+ "setarValorJS('bcDataSaida"
					+ indiceReservaApto
					+ "','"
					+ MozartUtil.format(resAptoCorrente.getBcDataSaida(),
							"dd/MM/yyyy") + "');";
			script = script + "selecionarValorCombo('bcIdTipoApartamento"
					+ indiceReservaApto + "','"
					+ resAptoCorrente.getBcIdTipoApartamento() + "');";
			script = script + "selecionarValorCombo('bcQtdePax"
					+ indiceReservaApto + "','"
					+ resAptoCorrente.getBcQtdePax() + "');";
			script = script + "selecionarValorCombo('bcIdTipoDiaria"
					+ indiceReservaApto + "','"
					+ resAptoCorrente.getBcIdTipoDiaria() + "');";
			script = script + "setarValorJS('bcQtdeApartamento"
					+ indiceReservaApto + "','"
					+ resAptoCorrente.getBcQtdeApartamento() + "');";
			script = script + "setarValorJS('bcTarifa" + indiceReservaApto
					+ "','" + MozartUtil.format(resAptoCorrente.getBcTarifa())
					+ "');";
			script = script + "setarValorJS('bcTotalTarifa" + indiceReservaApto
					+ "','"
					+ MozartUtil.format(resAptoCorrente.getBcTotalTarifa())
					+ "');";
			script = script + "setarValorJS('bcQtdeCrianca" + indiceReservaApto
					+ "','" + resAptoCorrente.getBcQtdeCrianca() + "');";
			script = script + "selecionarValorCombo('bcIdApartamento"
					+ indiceReservaApto + "','"
					+ resAptoCorrente.getBcIdApartamento() + "');";
			script = script + "selecionarValorCombo('bcTarifaManual"
					+ indiceReservaApto + "','"
					+ resAptoCorrente.getBcTarifaManual() + "');";
			script = script + "selecionarValorCombo('bcDataManual"
					+ indiceReservaApto + "','"
					+ resAptoCorrente.getBcDataManual() + "');";
			script = script + "document.getElementById('divEditarResApto"
					+ indiceReservaApto + "').style.display='block';";
			script = script + "document.getElementById('divCorrenteResApto"
					+ indiceReservaApto + "').style.display='none';";
			script = script + "exibeEscondeTarifaManual('" + indiceReservaApto
					+ "');";
			script = script + "habilitaDesabilitaDataManual('"
					+ indiceReservaApto + "');";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void selecionarContaCorrenteNaoAberta(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionar os apartamentos disponiveis para a transferencia",
				this.log);

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		String idCheckin = request.getParameter("OBJ_VALUE");
		String result = "";
		try {
			result = obterAptoDipspTransf(hotel, idCheckin, false);
			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		} catch (Exception e) {
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					"ajax:selecionarApartamentoSemReserva", this.log);
		}
	}

	private String obterAptoDipspTransf(HotelEJB hotel, String idCheckin,
			boolean isHotelaria) throws Exception {
		String result = "";
		try {
			List<ApartamentoEJB> list = CaixaGeralDelegate.instance()
					.obterApartamentoDisponivelTransferencia(
							new Long(idCheckin), hotel.getIdHotel());

			if (MozartUtil.isNull(list)) {
				result = " , |";
			} else {
				for (ApartamentoEJB apto : list) {
					result = result.concat(((isHotelaria) ? apto.toString()
							: apto.getNumApartamento()+"")); 
							
					result = result.concat( ","
									+ apto.getIdApartamento().toString() + "|");
				}
			}
		} catch (Exception e) {
			throw e;
		}
		return result;
	}

	public void selecionarApartamentoSemReserva(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionar os apartamentos disponiveis para a transferencia",
				this.log);

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		String idCheckin = request.getParameter("OBJ_VALUE");
		String result = "";
		try {
			result = obterAptoDipspTransf(hotel, idCheckin, true);
			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		} catch (Exception e) {
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					"ajax:selecionarApartamentoSemReserva", this.log);
		}
	}

	public void atualizarReservaApartamentoInformacoes(
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"editando o reserva apartamento", this.log);
		try {
			List<ReservaApartamentoVO> listReservaApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_RESERVA_APARTAMENTO");
			int indiceReservaApto = Integer.parseInt(request
					.getParameter("indiceResApto"));
			ReservaApartamentoVO resAptoCorrente = (ReservaApartamentoVO) listReservaApartamento
					.get(indiceReservaApto);

			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			resAptoCorrente.setBcDataEntrada(MozartUtil.toTimestamp(request
					.getParameter("saDataEntrada")));
			resAptoCorrente.setBcDataSaida(MozartUtil.toTimestamp(request
					.getParameter("saDataSaida")));
			resAptoCorrente.setBcIdTipoApartamento(new Long(request
					.getParameter("saIdTipoApartamento")));
			resAptoCorrente.setBcQtdePax(new Long(request
					.getParameter("saQtdePax")));
			resAptoCorrente.setBcIdTipoDiaria(new Long(request
					.getParameter("saIdTipoDiaria")));
			resAptoCorrente.setBcQtdeApartamento(new Long(1L));
			resAptoCorrente.setBcTarifa(new Double(request
					.getParameter("saTarifa").replace(".", "")
					.replace(",", ".")));
			resAptoCorrente.setBcTotalTarifa(new Double(request
					.getParameter("saTotalTarifa").replace(".", "")
					.replace(",", ".")));
			resAptoCorrente.setBcQtdeCrianca(new Long(request
					.getParameter("saQtdeCrianca")));
			resAptoCorrente.setBcIdApartamento(new Long(request
					.getParameter("saIdApartamento")));
			resAptoCorrente.setBcTarifaManual(request
					.getParameter("saTarifaManual"));
			resAptoCorrente.setBcDataManual(request
					.getParameter("saDataManual"));

			String idMoeda = request.getParameter("idMoeda");
			if ((resAptoCorrente.getBcIdApartamento() != null)
					&& (resAptoCorrente.getBcIdApartamento().longValue() != 0L)) {
				ApartamentoVO apto = new ApartamentoVO();
				apto.setBcIdApartamento(resAptoCorrente.getBcIdApartamento());
				apto = ReservaDelegate.instance().obterApartamentoPorId(apto);
				resAptoCorrente.setBcApartamentoDesc(apto.getBcNumApartamento()
						.toString());
			} else {
				resAptoCorrente.setBcIdApartamento(null);
				resAptoCorrente.setBcApartamentoDesc("");
			}
			TipoApartamentoVO tp = new TipoApartamentoVO();
			tp.setBcIdTipoApartamento(resAptoCorrente.getBcIdTipoApartamento());
			tp = ReservaDelegate.instance().obterTipoApartamentoPorId(tp);
			resAptoCorrente.setBcTipoApartamentoDesc(tp.getBcFantasia());

			TipoDiariaVO td = new TipoDiariaVO();
			td.setBcIdTipoDiaria(resAptoCorrente.getBcIdTipoDiaria());
			td = ReservaDelegate.instance().obterTipoDiariaPorId(td);
			resAptoCorrente.setBcTipoDiariaDesc(td.getBcDescricao());
			if ("S".equals(resAptoCorrente.getBcTarifaManual())) {
				Timestamp dataEntrada = resAptoCorrente.getBcDataEntrada();
				resAptoCorrente.getListReservaApartamentoDiaria().clear();
				ReservaApartamentoDiariaVO resAptoDiaria = null;
				while (dataEntrada.before(resAptoCorrente.getBcDataSaida())) {
					resAptoDiaria = new ReservaApartamentoDiariaVO();
					resAptoDiaria.setBcData(dataEntrada);
					resAptoDiaria.setBcIdHotel(hotel.getIdHotel());
					resAptoDiaria
							.setBcIdMoeda(MozartUtil.isNull(idMoeda) ? new Long(
									1L) : new Long(idMoeda));
					resAptoDiaria.setBcJustificaTarifa("TARIFA MANUAL");
					resAptoDiaria.setBcTarifa(resAptoCorrente.getBcTarifa());
					dataEntrada = MozartUtil.incrementarDia(dataEntrada, 1);
					resAptoCorrente.setBcJustificaTarifa("TARIFA MANUAL");
					resAptoCorrente.getListReservaApartamentoDiaria().add(
							resAptoDiaria);
				}
			} else {
				EmpresaHotelVO empresaHotelVO = (EmpresaHotelVO) request
						.getSession()
						.getAttribute("TELA_RESERVA_EMPRESA_HOTEL");
				resAptoCorrente.setBcIdEmpresa(empresaHotelVO.getBcIdEmpresa());
				resAptoCorrente.setBcIdHotel(hotel.getIdHotel());
				resAptoCorrente.setBcIdMoeda(new Long(1L));
				resAptoCorrente
						.setBcIdMoeda(MozartUtil.isNull(idMoeda) ? new Long(1L)
								: new Long(idMoeda));
				List<TarifaVO> listTarifasVO = ReservaDelegate.instance()
						.obterTarifaPorPeriodo(resAptoCorrente);
				ReservaApartamentoDiariaVO resAptoDiaria = null;
				resAptoCorrente.getListReservaApartamentoDiaria().clear();
				for (TarifaVO obj : listTarifasVO) {
					resAptoDiaria = new ReservaApartamentoDiariaVO();
					resAptoDiaria.setBcData(obj.getBcDataEntrada());
					resAptoDiaria.setBcIdHotel(hotel.getIdHotel());
					resAptoDiaria
							.setBcIdMoeda(MozartUtil.isNull(idMoeda) ? new Long(
									1L) : new Long(idMoeda));
					resAptoDiaria.setBcJustificaTarifa(obj.getBcDescricao());
					resAptoDiaria.setBcTarifa(obj.getBcPax());
					resAptoCorrente.setBcJustificaTarifa(obj.getBcDescricao());
					resAptoCorrente.getListReservaApartamentoDiaria().add(
							resAptoDiaria);
				}
				resAptoCorrente.setBcTarifa(

				Double.valueOf(resAptoCorrente.getBcTotalTarifa().doubleValue()
						/ resAptoCorrente.getListReservaApartamentoDiaria()
								.size()));
			}
			String script = "document.getElementById('divBcDataEntrada"
					+ indiceReservaApto
					+ "').innerHTML = '<p>"
					+ MozartUtil.format(resAptoCorrente.getBcDataEntrada(),
							"dd/MM/yyyy") + "</p>';";
			script = script
					+ "document.getElementById('divBcDataSaida"
					+ indiceReservaApto
					+ "').innerHTML = '<p>"
					+ MozartUtil.format(resAptoCorrente.getBcDataSaida(),
							"dd/MM/yyyy") + "</p>';";
			script = script
					+ "document.getElementById('divBcTipoApartamentoDesc"
					+ indiceReservaApto
					+ "').innerHTML = '<p style=\"width:40pt;\">"
					+ resAptoCorrente.getBcTipoApartamentoDesc() + "</p>';";
			script = script + "document.getElementById('divBcQtdePaxDesc"
					+ indiceReservaApto
					+ "').innerHTML = '<p style=\"width:60pt;\">"
					+ resAptoCorrente.getBcQtdePaxDesc() + "</p>';";
			script = script + "document.getElementById('divBcTipoDiariaDesc"
					+ indiceReservaApto
					+ "').innerHTML = '<p style=\"width:60pt;\">"
					+ resAptoCorrente.getBcTipoDiariaDesc() + "</p>';";
			script = script + "document.getElementById('divBcQtdeApartamento"
					+ indiceReservaApto
					+ "').innerHTML = '<p style=\"width:30pt;\">"
					+ resAptoCorrente.getBcQtdeApartamento() + "</p>';";
			script = script + "document.getElementById('divBcTarifa"
					+ indiceReservaApto
					+ "').innerHTML = '<p style=\"width:30pt;\">"
					+ MozartUtil.format(resAptoCorrente.getBcTarifa())
					+ "</p>';";
			script = script + "document.getElementById('divBcTotalTarifa"
					+ indiceReservaApto
					+ "').innerHTML = '<p style=\"width:30pt;\">"
					+ MozartUtil.format(resAptoCorrente.getBcTotalTarifa())
					+ "</p>';";
			script = script + "document.getElementById('divBcQtdeCrianca"
					+ indiceReservaApto
					+ "').innerHTML = '<p style=\"width:30pt;\">"
					+ resAptoCorrente.getBcQtdeCrianca() + "</p>';";
			script = script + "document.getElementById('divBcApartamentoDesc"
					+ indiceReservaApto
					+ "').innerHTML = '<p style=\"width:40pt;\">"
					+ resAptoCorrente.getBcApartamentoDesc() + "</p>';";
			script = script
					+ "document.getElementById('divBcApartamentoTituloDesc"
					+ indiceReservaApto + "').innerHTML = '"
					+ resAptoCorrente.getBcApartamentoDesc() + "';";
			script = script + "document.getElementById('divBcTarifaManualDesc"
					+ indiceReservaApto
					+ "').innerHTML = '<p style=\"width:40pt;\">"
					+ resAptoCorrente.getBcTarifaManualDesc() + "</p>';";
			script = script + "document.getElementById('divBcDataManualDesc"
					+ indiceReservaApto
					+ "').innerHTML = '<p style=\"width:50pt;\">"
					+ resAptoCorrente.getBcDataManualDesc() + "</p>';";
			script = script
					+ "document.getElementById('divBcPeriodoTituloDesc"
					+ indiceReservaApto
					+ "').innerHTML = '"
					+ MozartUtil.format(resAptoCorrente.getBcDataEntrada(),
							"dd/MM/yyyy")
					+ " - "
					+ MozartUtil.format(resAptoCorrente.getBcDataSaida(),
							"dd/MM/yyyy") + "';";
			script = script + calculaTotalReservaEGeraScript(request);

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void validarGravacaoReserva(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String erro = "";
		String alertaCofan = "";
		try {
			
			String ehAlteracaoString = request.getParameter("ehAlteracao");
			boolean ehAlteracao = !MozartUtil.isNull(ehAlteracaoString) ? Boolean.parseBoolean(ehAlteracaoString) : false;
			
			List<ReservaApartamentoVO> listReservaApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_RESERVA_APARTAMENTO");

			List<PagamentoReservaVO> listPagamento = (List) request
					.getSession()
					.getAttribute("TELA_RESERVA_PAGAMENTO_RESERVA");

			List<MovimentoApartamentoEJB> listMovimentoApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_MOVIMENTO_APARTAMENTO");

			if ((listReservaApartamento == null)
					|| (listReservaApartamento.size() <= 0)) {
				erro = erro + "Insira ao menos um apartamento na reserva\\n";
			} else {
				Boolean roomListFaltando = Boolean.valueOf(false);
				Boolean achouRoomListPrincipal = Boolean.valueOf(false);
				for (ReservaApartamentoVO obj : listReservaApartamento) {
					if (obj.getListRoomList().size() <= 0) {
						roomListFaltando = Boolean.valueOf(true);
						break;
					}
					for (RoomListVO room : obj.getListRoomList()) {
						if ("S".equals(room.getBcPrincipal())) {
							achouRoomListPrincipal = Boolean.valueOf(true);
							break;
						}
					}
				}
				if (roomListFaltando.booleanValue()) {
					erro = erro
							+ "Existe(m) apartamento(s) sem hóspede principal\\n";
				}
				if (!achouRoomListPrincipal.booleanValue()) {
					erro = erro
							+ "Existe(m) apartamento(s) sem hóspede principal\\n";
				}
			}

			if (listMovimentoApartamento != null
					&& !listMovimentoApartamento.isEmpty()) {
				String lcmtCofan = "";
				List<ApartamentoVO> l = (List<ApartamentoVO>) request
						.getSession().getAttribute("TELA_RESERVA_COMBO_COFAN");

				HashMap<Long, String> hashAptoCofan = new HashMap<Long, String>();

				for (ApartamentoVO ap : l) {

					hashAptoCofan.put(ap.getIdCheckin(), ap.getBcObservacao());
				}
				int index = 0;
				for (MovimentoApartamentoEJB obj : listMovimentoApartamento) {
					if (!MozartUtil.isNull(obj.getCheckinEJB())
							&& !MozartUtil.isNull(obj.getCheckinEJB()
									.getIdCheckin())
							&& obj.getCheckinEJB().getIdCheckin().longValue() != 0L
							&& (listPagamento.get(index).getBcFormaPg().equals("A") 
							&& (listPagamento.get(index).getBcIdPagamentoReserva() == null 
							|| listPagamento.get(index).getBcIdPagamentoReserva() == 0L))) {

						lcmtCofan = lcmtCofan
								+ "Valor: "
								+ listPagamento.get(index).getBcValor()
								+ " apto COFAN: "
								+ hashAptoCofan.get(obj.getCheckinEJB()
										.getIdCheckin()) + "\\n";
					}
					index++;
				}

				if (!"".equals(lcmtCofan)) {

					alertaCofan = "Confirma o lancamento na(s) COFAN: \\n"
							+ lcmtCofan;
				}
			}

			if ((listPagamento == null) || (listPagamento.size() <= 0)) {
				erro = erro + "Insira a forma de pagamento\\n";
			}
			String script = "";
			if (!"".equals(erro)) {
				script = script + "alert('" + erro + "');";
			} else if (!"".equals(alertaCofan)) {
				script = script + " confirmarReserva('" + alertaCofan + "'); ";
			} else {
				script = script + "salvarReserva();";
			}
			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal()");
			out.flush();
			out.close();
		}
	}

	private HotelEJB getHotelCorrente(HttpServletRequest request) {
		return (HotelEJB) request.getSession().getAttribute(
				MozartConstantesWeb.HOTEL_SESSION);
	}

	public void verificaApartamentoJaEscolhido(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			int indiceReservaApto = Integer.parseInt(request
					.getParameter("indiceResApto"));
			String idApartamentoS = request.getParameter("idApartamento");
			String onSucess = request.getParameter("onSucess");
			Long idApartamento = null;
			if ((idApartamentoS != null) && (!"".equals(idApartamentoS))) {
				idApartamento = Long.parseLong(idApartamentoS);
			}
			List<ReservaApartamentoVO> listReservaApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_RESERVA_APARTAMENTO");
			int i = 0;
			Boolean aptoRepetido = Boolean.valueOf(false);
			for (ReservaApartamentoVO obj : listReservaApartamento) {
				if ((i != indiceReservaApto)
						&& (obj.getBcIdApartamento() != null)
						&& (!obj.getBcIdApartamento().equals(new Long(0L)))
						&& (obj.getBcIdApartamento().equals(idApartamento))) {
					aptoRepetido = Boolean.valueOf(true);
				}
				i++;
			}
			String script = "";
			if (aptoRepetido.booleanValue()) {
				script = script
						+ "alerta('- Apartamento já selecionado, favor selecionar outro');";
			} else {
				script = script + onSucess + ";";
			}
			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal()");
			out.flush();
			out.close();
		}
	}

	public void validaERecalculaTarifas(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			Timestamp dataEntrada = MozartUtil.toTimestamp(request
					.getParameter("dataEntrada"));
			Timestamp dataSaida = MozartUtil.toTimestamp(request
					.getParameter("dataSaida"));

			String erro = "";

			Timestamp menorDataEntrada = null;
			Timestamp maiorDataSaida = null;

			List<ReservaApartamentoVO> listReservaApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_RESERVA_APARTAMENTO");
			for (ReservaApartamentoVO obj : listReservaApartamento) {
				if (((obj.getBcQtdeCheckin() != null) && (obj
						.getBcQtdeCheckin().longValue() > new Long(0L)
						.longValue()))
						|| ("S".equals(obj.getBcDataManual()))) {
					if (MozartUtil.getDiferencaDia(dataEntrada,
							obj.getBcDataEntrada()) < 0) {
						if (menorDataEntrada == null) {
							menorDataEntrada = obj.getBcDataEntrada();
						} else if (obj.getBcDataEntrada().before(
								menorDataEntrada)) {
							menorDataEntrada = obj.getBcDataEntrada();
						}
					}
					if (MozartUtil.getDiferencaDia(dataSaida,
							obj.getBcDataSaida()) > 0) {
						if (maiorDataSaida == null) {
							maiorDataSaida = obj.getBcDataSaida();
						} else if (maiorDataSaida.before(obj.getBcDataSaida())) {
							maiorDataSaida = obj.getBcDataSaida();
						}
					}
				}
			}
			String scriptAux = "";
			if (menorDataEntrada != null) {
				erro =

				erro
						+ "- A data de entrada da reserva deve ser menor ou igual a "
						+ MozartUtil.format(menorDataEntrada, "dd/MM/yyyy")
						+ "\\n";
				scriptAux = scriptAux
						+ "setarValorJS('reservaVO.bcDataEntrada','');";
			}
			if (maiorDataSaida != null) {
				erro =

				erro
						+ "- A data de saida da reserva deve ser maior ou igual a "
						+ MozartUtil.format(maiorDataSaida, "dd/MM/yyyy")
						+ "\\n";
				scriptAux = scriptAux
						+ "setarValorJS('reservaVO.bcDataSaida','');";
			}
			String script = "";
			if (erro.equals("")) {
				ReservaApartamentoDiariaVO resAptoDiaria = null;
				Timestamp dataEntradaAux = null;
				Timestamp dataSaidaAux = null;
				for (ReservaApartamentoVO obj : listReservaApartamento) {
					if (((obj.getBcQtdeCheckin() == null) || (obj
							.getBcQtdeCheckin().equals(new Long(0L))))
							&& (!"S".equals(obj.getBcDataManual()))) {
						dataEntradaAux = dataEntrada;
						dataSaidaAux = obj.getBcDataSaida();
						while (dataEntradaAux.before(obj.getBcDataEntrada())) {
							resAptoDiaria = (ReservaApartamentoDiariaVO) obj
									.getListReservaApartamentoDiaria().get(0);
							resAptoDiaria = (ReservaApartamentoDiariaVO) resAptoDiaria
									.clone(resAptoDiaria);

							resAptoDiaria.setBcData(dataEntradaAux);
							obj.getListReservaApartamentoDiaria().add(
									resAptoDiaria);
							dataEntradaAux = MozartUtil
									.incrementarDia(dataEntradaAux);
						}
						if (dataEntrada.before(obj.getBcDataEntrada())) {
							obj.setBcDataEntrada(dataEntrada);
						}
						while (dataSaidaAux.before(dataSaida)) {
							resAptoDiaria = (ReservaApartamentoDiariaVO) obj
									.getListReservaApartamentoDiaria().get(0);
							resAptoDiaria = (ReservaApartamentoDiariaVO) resAptoDiaria
									.clone(resAptoDiaria);

							resAptoDiaria.setBcData(dataSaidaAux);
							obj.getListReservaApartamentoDiaria().add(
									resAptoDiaria);
							dataSaidaAux = MozartUtil
									.incrementarDia(dataSaidaAux);
						}
						if (obj.getBcDataSaida().before(dataSaida)) {
							obj.setBcDataSaida(dataSaida);
						}
						dataEntradaAux = obj.getBcDataEntrada();
						while (dataEntradaAux.before(dataEntrada)) {
							Iterator it = obj.getListReservaApartamentoDiaria()
									.iterator();
							while (it.hasNext()) {
								resAptoDiaria = (ReservaApartamentoDiariaVO) it
										.next();
								if (resAptoDiaria.getBcData().equals(
										dataEntradaAux)) {
									obj.getListReservaApartamentoDiaria()
											.remove(resAptoDiaria);
									it = obj.getListReservaApartamentoDiaria()
											.iterator();
								}
							}
							dataEntradaAux = MozartUtil
									.incrementarDia(dataEntradaAux);
						}
						if (obj.getBcDataEntrada().before(dataEntrada)) {
							obj.setBcDataEntrada(dataEntrada);
						}
						dataSaidaAux = dataSaida;
						while (dataSaidaAux.before(obj.getBcDataSaida())) {
							Iterator it = obj.getListReservaApartamentoDiaria()
									.iterator();
							while (it.hasNext()) {
								resAptoDiaria = (ReservaApartamentoDiariaVO) it
										.next();
								if (resAptoDiaria.getBcData().equals(
										dataSaidaAux)) {
									obj.getListReservaApartamentoDiaria()
											.remove(resAptoDiaria);
									it = obj.getListReservaApartamentoDiaria()
											.iterator();
								}
							}
							dataSaidaAux = MozartUtil
									.incrementarDia(dataSaidaAux);
						}
						if (dataSaida.before(obj.getBcDataSaida())) {
							obj.setBcDataSaida(dataSaida);
						}
					}
				}
				script = script
						+ " document.getElementById('idResAptoFrame').contentWindow.atualizar(); ";
				request.getSession().setAttribute("resAptoDataEntrada",
						dataEntrada);
				request.getSession()
						.setAttribute("resAptoDataSaida", dataSaida);
			} else {
				script = script + "alerta('" + erro + "');";
			}
			script = "killModal();" + script + scriptAux;

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void validaERecalculaTarifasBloqueio(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			Timestamp dataEntradaTela = MozartUtil.toTimestamp(request
					.getParameter("dataEntrada"));

			Timestamp dataSaidaTela = MozartUtil.toTimestamp(request
					.getParameter("dataSaida"));

			String erro = "";

			Timestamp menorDataEntrada = null;
			Timestamp maiorDataSaida = null;

			List<ReservaApartamentoVO> listReservaApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_RESERVA_APARTAMENTO");

			Timestamp dataInAux = dataEntradaTela;
			Timestamp dataOutAux = MozartUtil.incrementarDia(dataInAux);

			ReservaApartamentoVO reservaApartamentoVO = new ReservaApartamentoVO();

			for (ReservaApartamentoVO obj : listReservaApartamento) {

				if (((obj.getBcQtdeCheckin() != null) && (obj
						.getBcQtdeCheckin().longValue() > new Long(0L)
						.longValue()))
						|| ("S".equals(obj.getBcDataManual()))) {

					if (MozartUtil.getDiferencaDia(dataEntradaTela,
							obj.getBcDataEntrada()) < 0) {
						if (menorDataEntrada == null) {
							menorDataEntrada = obj.getBcDataEntrada();
						} else if (obj.getBcDataEntrada().before(
								menorDataEntrada)) {
							menorDataEntrada = obj.getBcDataEntrada();
						}
					}

					if (MozartUtil.getDiferencaDia(dataSaidaTela,
							obj.getBcDataSaida()) > 0) {
						if (maiorDataSaida == null) {
							maiorDataSaida = obj.getBcDataSaida();
						} else if (maiorDataSaida.before(obj.getBcDataSaida())) {
							maiorDataSaida = obj.getBcDataSaida();
						}
					}

				}
			}

			String scriptAux = "";

			if (menorDataEntrada != null) {
				erro =

				erro
						+ "- A data de entrada da reserva deve ser menor ou igual a "
						+ MozartUtil.format(menorDataEntrada, "dd/MM/yyyy")
						+ "\\n";
				scriptAux = scriptAux
						+ "setarValorJS('reservaVO.bcDataEntrada','');";
			}

			if (maiorDataSaida != null) {
				erro =

				erro
						+ "- A data de saida da reserva deve ser maior ou igual a "
						+ MozartUtil.format(maiorDataSaida, "dd/MM/yyyy")
						+ "\\n";
				scriptAux = scriptAux
						+ "setarValorJS('reservaVO.bcDataSaida','');";
			}

			String script = "";
			if (erro.equals("")) {
				int contador = 0;
				while (dataInAux.before(dataSaidaTela)) {
					for (ReservaApartamentoVO obj : listReservaApartamento) {
						dataOutAux = MozartUtil.incrementarDia(dataInAux);
						if (MozartUtil.getDiferencaDia(obj.getBcDataEntrada(),
								dataInAux) == 0
								&& MozartUtil.getDiferencaDia(
										obj.getBcDataSaida(), dataOutAux) == 0) {
							contador++;
							reservaApartamentoVO = (ReservaApartamentoVO) obj
									.clone(obj);
						}

					}
					dataInAux = MozartUtil.incrementarDia(dataInAux);
					if (contador > 0) {
						break;
					}
				}

				reservaApartamentoVO.setBcQtdeApartamento((long) contador);
				reservaApartamentoVO.setBcDataEntrada(dataEntradaTela);
				reservaApartamentoVO.setBcDataSaida(dataSaidaTela);

				dataInAux = dataEntradaTela;
				listReservaApartamento.clear();
				while (dataInAux.before(reservaApartamentoVO.getBcDataSaida())) {
					for (int x = 0; x < reservaApartamentoVO
							.getBcQtdeApartamento().intValue(); x++) {
						ReservaApartamentoVO rsApClone = (ReservaApartamentoVO) reservaApartamentoVO
								.clone(reservaApartamentoVO);
						rsApClone.setBcQtdeApartamento(new Long(1L));
						rsApClone.setBcQtdeCheckin(new Long(0L));
						rsApClone.setBcIdReservaApartamento(null);
						if (new Long(0L).equals(rsApClone.getBcIdApartamento())) {
							rsApClone.setBcIdApartamento(null);
						}
						if ((reservaApartamentoVO.getBcQtdeApartamento()
								.longValue() > 1L) && (x > 0)) {
							rsApClone.setBcIdApartamento(null);
							rsApClone.setBcApartamentoDesc(null);
						}
						rsApClone.setBcDataEntrada(dataInAux);
						rsApClone.setBcDataSaida(dataOutAux);

						List<TarifaVO> listTarifasVO = ReservaDelegate
								.instance().obterTarifaPorPeriodo(rsApClone);

						Long idMoeda = rsApClone
								.getListReservaApartamentoDiaria().get(0)
								.getBcIdMoeda();
						rsApClone.getListReservaApartamentoDiaria().clear();
						for (TarifaVO obj : listTarifasVO) {
							ReservaApartamentoDiariaVO resAptoDiaria = new ReservaApartamentoDiariaVO();
							resAptoDiaria.setBcData(obj.getBcDataEntrada());
							resAptoDiaria.setBcIdHotel(reservaApartamentoVO
									.getBcIdHotel());
							resAptoDiaria.setBcIdMoeda(MozartUtil
									.isNull(idMoeda) ? new Long(1L) : idMoeda);
							resAptoDiaria.setBcJustificaTarifa(obj
									.getBcDescricao());
							resAptoDiaria.setBcTarifa(obj.getBcPax());
							rsApClone
									.setBcJustificaTarifa(obj.getBcDescricao());
							rsApClone.getListReservaApartamentoDiaria().add(
									resAptoDiaria);

						}

						rsApClone.setBcTarifa(

						Double.valueOf(rsApClone.getBcTotalTarifa()
								.doubleValue()
								/ rsApClone.getListReservaApartamentoDiaria()
										.size()));

						listReservaApartamento.add(rsApClone);
					}
					dataInAux = MozartUtil.incrementarDia(dataInAux, 1);
					dataOutAux = MozartUtil.incrementarDia(dataInAux, 1);
				}

				script = script
						+ " document.getElementById('idResAptoFrame').contentWindow.atualizar(); ";
				request.getSession().setAttribute("resAptoDataEntrada",
						dataEntradaTela);
				request.getSession().setAttribute("resAptoDataSaida",
						dataSaidaTela);
			} else {
				script = script + "alerta('" + erro + "');";
			}
			script = "killModal();" + script + scriptAux;

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void obterValorPrato(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			PratoEJBPK pkPrato = new PratoEJBPK();
			pkPrato.setIdHotel(hotel.getIdHotel());
			pkPrato.setIdPrato(new Long(request.getParameter("idPrato")));

			PratoEJB prato = new PratoEJB();
			prato.setId(pkPrato);

			PratoPontoVendaEJB ppp = new PratoPontoVendaEJB();
			ppp.setPratoEJB(prato);
			List<PratoPontoVendaEJB> pratoPDVList = (List) request.getSession()
					.getAttribute("pratoPDVList");
			prato = ((PratoPontoVendaEJB) pratoPDVList.get(pratoPDVList
					.indexOf(ppp))).getPratoEJB();
			String script = " $('#valor1').val('"
					+ MozartUtil.format(prato.getValorPrato()) + "')";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal()");
			out.flush();
			out.close();
		}
	}

	public void pesquisarPrato(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			PontoVendaEJB pFiltroPDV = new PontoVendaEJB();
			pFiltroPDV.setId(new PontoVendaEJBPK());
			pFiltroPDV.getId().setIdHotel(hotel.getIdHotel().longValue());
			pFiltroPDV.getId().setIdPontoVenda(
					new Long(request.getParameter("idPontoVenda")));

			List<PontoVendaEJB> listaMiniPDV = (List) request.getSession()
					.getAttribute("listaPDV");

			List<PratoPontoVendaEJB> pratoPDVList = ((PontoVendaEJB) listaMiniPDV
					.get(listaMiniPDV.indexOf(pFiltroPDV)))
					.getPratoPontoVendaEJBList();
			
			Collections.sort(pratoPDVList, PratoPontoVendaEJB.getComparator()); 
			
			request.getSession().setAttribute("pratoPDVList", pratoPDVList);

			String textEValues = "";
			for (PratoPontoVendaEJB vo : pratoPDVList) {
				textEValues = textEValues + vo.getPratoEJB().getNomePrato()
						+ "," + vo.getPratoEJB().getId().getIdPrato() + "|";
			}
			textEValues = "Selecione, |" + textEValues;
			textEValues = textEValues.substring(0, textEValues.length() - 1);

			MozartWebUtil.warn(MozartWebUtil.getLogin(request), textEValues,
					this.log);

			String campoCombo = "idPrato1";
			String script = "preencherComboBoxJS('" + campoCombo + "', '"
					+ textEValues + "');";
			script = textEValues;

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	private String calculaTotalReservaEGeraScript(HttpServletRequest request) {
		ReservaVO resVO = new ReservaVO();
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		String calculaISS = request.getParameter("calculaISS");
		String calculaTaxa = request.getParameter("calculaTaxa");
		String calculaRoomTax = request.getParameter("calculaRoomTax");
		String origem = request.getParameter("pai");
		if ("S".equals(calculaISS)) {
			resVO.setPercentualIss(Double.valueOf(hotel.getIss().doubleValue()));
		}
		if ("S".equals(calculaRoomTax)) {
			resVO.setPercentualRoomTax(Double.valueOf(hotel.getRoomtax()
					.doubleValue()));
		}
		if ("S".equals(calculaTaxa)) {
			resVO.setPercentualTaxaServico(Double.valueOf(hotel
					.getTaxaServico().doubleValue()));
		}
		List<ReservaApartamentoVO> listaReservaApartamentoVO = (List) request
				.getSession().getAttribute("TELA_RESERVA_RESERVA_APARTAMENTO");

		resVO.setListReservaApartamento(listaReservaApartamentoVO);
		String valorTaxaIss = MozartUtil.format(resVO.getValorIss());
		String valorTaxaServico = MozartUtil
				.format(resVO.getValorTaxaServico());
		String valorRoomTax = MozartUtil.format(resVO.getValorRoomTax());
		String valorReserva = MozartUtil.format(resVO.getValorTotalReserva());

		String parent = "parent.";
		if ("reserva".equals(origem)) {
			parent = "";
		}
		String script = "";
		script = script
				+ parent
				+ "document.getElementById('divValorTaxaServico').innerHTML = '"
				+ valorTaxaServico + "';";
		script = script + parent
				+ "document.getElementById('divValorRoomTax').innerHTML = '"
				+ valorRoomTax + "';";
		script = script + parent
				+ "document.getElementById('divValorISS').innerHTML = '"
				+ valorTaxaIss + "';";
		script = script + parent
				+ "document.getElementById('divValorReserva').innerHTML = '"
				+ valorReserva + "';";
		return script;
	}

	public void pesquisarStatusApartamento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			String statusOrigem = request.getParameter("idStatusOrigem");

			List<MozartComboWeb> statusAptoList = new ArrayList();
			if ("LS".equals(statusOrigem)) {
				statusAptoList.add(new MozartComboWeb("LA", "Livre/Arrumado"));
				statusAptoList.add(new MozartComboWeb("LL", "Livre/Limpo"));
				statusAptoList.add(new MozartComboWeb("IN", "Interditado"));
			} else if ("LA".equals(statusOrigem)) {
				statusAptoList.add(new MozartComboWeb("LL", "Livre/Limpo"));
				statusAptoList.add(new MozartComboWeb("IN", "Interditado"));
			} else if ("LL".equals(statusOrigem)) {
				statusAptoList.add(new MozartComboWeb("LS", "Livre/Sujo"));
				statusAptoList.add(new MozartComboWeb("LA", "Livre/Arrumado"));
				statusAptoList.add(new MozartComboWeb("IN", "Interditado"));
			} else if ("IN".equals(statusOrigem)) {
				statusAptoList.add(new MozartComboWeb("LS", "Livre/Sujo"));
			} else if ("OS".equals(statusOrigem)) {
				statusAptoList
						.add(new MozartComboWeb("OA", "Ocupado/Arrumado"));
			} else if ("OA".equals(statusOrigem)) {
				statusAptoList.add(new MozartComboWeb("OS", "Ocupado/Sujo"));
			}
			String textEValues = "";
			for (MozartComboWeb vo : statusAptoList) {
				textEValues = textEValues + vo.getValue() + "," + vo.getId()
						+ "|";
			}
			textEValues = "Selecione, |" + textEValues;
			textEValues = textEValues.substring(0, textEValues.length() - 1);

			PrintWriter out = response.getWriter();
			out.println(textEValues);
			out.flush();
			out.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void obterApartamento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			String parObj = request.getParameter("OBJ_NAME");
			String parObjId = request.getParameter("OBJ_HIDDEN");
			String valor = request.getParameter("OBJ_VALUE");

			ApartamentoEJB filtro = new ApartamentoEJB();

			filtro.setIdHotel(hotel.getIdHotel());
			filtro.setStatus("L");

			if (!MozartUtil.isNull(valor))
				filtro.setNumApartamento(new Long(valor));

			List<ApartamentoEJB> list = CheckinDelegate.instance()
					.pesquisarApartamento(filtro);
			String listItem = "<li onclick=\"selecionarApartamento('%s', '%s', '%s', '%s'); \" >%s</li>";

			ComponenteAjax componente = getComponenteAjax(request);

			StringBuilder sb = new StringBuilder();
			sb.append("<ul>");
			for (ApartamentoEJB itemApartamento : list) {
				sb.append(String.format(listItem, componente.getIdElemento(),
						componente.getIdElementoOculto(),
						String.valueOf(itemApartamento.getNumApartamento()),
						String.valueOf(itemApartamento.getIdApartamento()),
						String.valueOf(itemApartamento.getNumApartamento())));
			}
			sb.append("</ul>");

			PrintWriter out = response.getWriter();
			out.println(sb.toString());
			out.flush();
			out.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void pesquisarApartamentoStatus(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			String status = request.getParameter("status");
			String idApartamento = request.getParameter("idApartamento");

			CaixaGeralVO param = new CaixaGeralVO();
			if (!MozartUtil.isNull(idApartamento)) {
				idApartamento = idApartamento.split(";")[0];
				param.setIdApartamento(new Long(idApartamento.trim()));
			}
			param.setIdHotel(hotel.getIdHotel());
			param.setCofan("N");
			param.setCheckout("N");
			param.setStatus(";" + status + ";");

			List<CaixaGeralVO> listaApartamento = CaixaGeralDelegate.instance()
					.pesquisarApartamentoComCheckinEReserva(param);

			String textEValues = "";
			for (CaixaGeralVO vo : listaApartamento) {
				textEValues =

				textEValues + vo.getIdApartamento() + ","
						+ vo.getNumApartamento() + " - "
						+ vo.getTipoApartamento() + ";";
			}
			textEValues = textEValues.substring(0, textEValues.length() - 1);

			MozartWebUtil.warn(MozartWebUtil.getLogin(request), textEValues,
					this.log);

			String script = "preencherDivApartamento('" + status + "', '"
					+ textEValues + "');";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void pesquisarHospedeRoomList(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"pesquisando hospede", this.log);

		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");
		String valor = request.getParameter("OBJ_VALUE");

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		HospedeVO hospedeVO = new HospedeVO();
		hospedeVO.setBcIdHotel(hotel.getIdHotel());
		hospedeVO.setBcNomeHospede(valor);
		hospedeVO.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());
		List<HospedeVO> listHospede = ReservaDelegate.instance()
				.obterHospedePorNome(hospedeVO);

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"setarValorJS('%s','%s');setarValorJS('%s','%s');atualizarResAptoRoomList('%s','%s','%s','%s');$('div.divLookup').remove();";
		linha = linha + "\">%s</li>";
		builder.append("<ul>");

		String[] valores = parObj.split("-");
		String[] indiceResAptoIndiceRoomList = valores[1].split("/");
		try {
			for (HospedeVO obj : listHospede) {
				builder.append(String.format(
						linha,
						new Object[] { parObj, obj.getBcNomeHospede(),
								parObjId, String.valueOf(obj.getBcIdHospede()),
								obj.getBcNomeHospede(),
								String.valueOf(obj.getBcIdHospede()),
								indiceResAptoIndiceRoomList[0],
								indiceResAptoIndiceRoomList[1],
								obj.getBcNomeHospede() }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void pesquisarApartamentoHospede(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"pesquisando apartamento hospede", this.log);

		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");
		String valor = request.getParameter("OBJ_VALUE");

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				MozartConstantesWeb.HOTEL_RESTAURANTE_SESSION);

		ApartamentoHospedeVO apartamentoHospedeVO = new ApartamentoHospedeVO();
		apartamentoHospedeVO.setIdHotel(hotel.getIdHotel());
		apartamentoHospedeVO.setBcNomeHospede(valor);
		apartamentoHospedeVO.setBcSobrenomeHospede(valor);
		apartamentoHospedeVO.setNumApartamento(valor);

		ComponenteAjax componente = getComponenteAjax(request);
		List<ApartamentoHospedeVO> listApartamentoHospede = OperacionalDelegate
				.instance().pesquisarApartamentoHospede(apartamentoHospedeVO);

		String listItem = "<li onclick=\"selecionarApartamento('%s', '%s', '%s', '%s', '%s', '%s'); \" >%s</li>";

		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		for (ApartamentoHospedeVO itemApartamento : listApartamentoHospede) {
			sb.append(String.format(
					listItem,
					componente.getIdElemento(),
					componente.getIdElementoOculto(),
					String.valueOf(itemApartamento.getNumApartamento() + " - ("
							+ itemApartamento.getBcPrincipal() + ") - "
							+ itemApartamento.getBcNomeHospede() + " "
							+ itemApartamento.getBcSobrenomeHospede()),
					String.valueOf(itemApartamento.getIdApartamento()),
					String.valueOf(itemApartamento.getIdCheckin()),
					String.valueOf(itemApartamento.getBcIdRoomList()),
					String.valueOf(itemApartamento.getNumApartamento() + " - ("
							+ itemApartamento.getBcPrincipal() + ") - "
							+ itemApartamento.getBcNomeHospede() + " "
							+ itemApartamento.getBcSobrenomeHospede())));
		}
		sb.append("</ul>");

		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}

	public void pesquisarMesa(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request), "pesquisando mesa",
				this.log);

		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");
		String valor = request.getParameter("OBJ_VALUE");
		Long idPontoVenda = new Long(request.getParameter("OBJ_PONTO_VENDA"));

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		ComponenteAjax componente = getComponenteAjax(request);
		List<MesaEJB> listMesas = OperacionalDelegate.instance()
				.pesquisarMesaLivre(idPontoVenda, valor, valor);

		String listItem = "<li onclick=\"selecionarMesa('%s', '%s', '%s', '%s'); \" >%s</li>";

		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		for (MesaEJB mesa : listMesas) {
			sb.append(String.format(listItem, componente.getIdElemento(),
					componente.getIdElementoOculto(),
					String.valueOf(mesa.getNumMesa()),
					String.valueOf(mesa.getIdMesa()),
					String.valueOf(mesa.getNumMesa())));
		}
		sb.append("</ul>");

		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}

	public void pesquisarPratoHotel(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"pesquisando prato", this.log);

		String valor = request.getParameter("OBJ_VALUE");

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		ComponenteAjax componente = getComponenteAjax(request);
		List<PratoEJB> listPratos = OperacionalDelegate.instance()
				.pesquisarPrato(valor, hotel.getIdHotel());

		String listItem = "<li onclick=\"selecionarPrato('%s', '%s', '%s', '%s'); \" >%s</li>";

		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		for (PratoEJB prato : listPratos) {
			sb.append(String.format(listItem, componente.getIdElemento(),
					componente.getIdElementoOculto(),
					String.valueOf(prato.getNomePrato()),
					String.valueOf(prato.getId().getIdPrato()),
					String.valueOf(prato.getNomePrato())));
		}
		sb.append("</ul>");

		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}

	public void atualizarReservaApartamentoRoomList(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			String hospedeNome = request.getParameter("hospedeNome");
			Long hospedeId = Long.parseLong(request.getParameter("hospedeId"));
			int indiceResApto = Integer.parseInt(request
					.getParameter("indiceResApto"));
			int indiceRoomList = Integer.parseInt(request
					.getParameter("indiceRoomList"));

			List<ReservaApartamentoVO> listReservaApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_RESERVA_APARTAMENTO");
			ReservaApartamentoVO resAptoVO = (ReservaApartamentoVO) listReservaApartamento
					.get(indiceResApto);
			RoomListVO roomListVO = (RoomListVO) resAptoVO.getListRoomList()
					.get(indiceRoomList);
			if (indiceRoomList == 0) {
				roomListVO.setBcPrincipal("S");
			}
			roomListVO.setBcNomeHospede(hospedeNome);
			roomListVO.setBcIdHospede(hospedeId);
			roomListVO.setBcTemp("");

			String script = "";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void removeRoomListTemorario(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		List<ReservaApartamentoVO> listReservaApartamento = (List) request
				.getSession().getAttribute("TELA_RESERVA_RESERVA_APARTAMENTO");
		for (ReservaApartamentoVO objResApto : listReservaApartamento) {
			Iterator itRoomList = objResApto.getListRoomList().iterator();
			while (itRoomList.hasNext()) {
				RoomListVO rl = (RoomListVO) itRoomList.next();
				if ("TEMP".equals(rl.getBcTemp())) {
					objResApto.getListRoomList().remove(rl);
					itRoomList = objResApto.getListRoomList().iterator();
				}
			}
		}
	}

	public void pesquisarHospedeRoomListPadrao(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"pesquisando hospede", this.log);

		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");
		String valor = request.getParameter("OBJ_VALUE");

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		HospedeVO hospedeVO = new HospedeVO();
		hospedeVO.setBcIdHotel(hotel.getIdHotel());
		hospedeVO.setBcNomeHospede(valor);
		hospedeVO.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());
		List<HospedeVO> listHospede = ReservaDelegate.instance()
				.obterHospedePorNome(hospedeVO);

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"setarValorJS('%s','%s');setarValorJS('%s','%s');$('div.divLookup').remove();";
		linha = linha + "\">%s</li>";
		builder.append("<ul>");
		try {
			for (HospedeVO obj : listHospede) {
				builder.append(String.format(
						linha,
						new Object[] { parObj, obj.getBcNomeHospede(),
								parObjId, String.valueOf(obj.getBcIdHospede()),
								obj.getBcNomeHospede(),
								String.valueOf(obj.getBcIdHospede()),
								obj.getBcNomeHospede() }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void atualizarResAptoRoomListPadrao(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			String hospedeNome = request.getParameter("hospedeNome");
			Long hospedeId = Long.parseLong(request.getParameter("hospedeId"));

			List<ReservaApartamentoVO> listReservaApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_RESERVA_APARTAMENTO");
			// Setando o valor do roomlist
			for (ReservaApartamentoVO objResApto : listReservaApartamento) {
				int x = 0;
				for (RoomListVO roomListVO : objResApto.getListRoomList()) {
					if (x == 0) {
						roomListVO.setBcNomeHospede(hospedeNome);
						roomListVO.setBcIdHospede(hospedeId);
						roomListVO.setBcPrincipal("S");
						roomListVO.setBcTemp("");
					} else {
						roomListVO.setBcPrincipal("N");
					}
					x++;
				}
			}
			String script = "";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException localIOException) {
		}
	}

	public void empresaExcluirTarifa(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String indice = request.getParameter("indice");
		MozartWebUtil.warn(MozartWebUtil.getLogin(request), "Excluindo tarifa:"
				+ indice + ".", this.log);
		EmpresaEJB entidade = (EmpresaEJB) request.getSession().getAttribute(
				"entidadeSession");
		((EmpresaHotelEJB) ((EmpresaRedeEJB) entidade.getEmpresaRedeEJBList()
				.get(0)).getEmpresaHotelEJBList().get(0))
				.getEmpresaTarifaEJBList().remove(Integer.parseInt(indice));

		String script = "killModal();";
		try {
			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException localIOException) {
		}
	}

	public void empresaIncluirTarifa(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String indice = request.getParameter("indice");
		MozartWebUtil.warn(MozartWebUtil.getLogin(request), "Incluindo tarifa:"
				+ indice + ".", this.log);

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		EmpresaEJB entidade = (EmpresaEJB) request.getSession().getAttribute(
				"entidadeSession");

		List<TarifaEJB> tarifaList = (List) request.getSession().getAttribute(
				"tarifaList");
		EmpresaTarifaEJB empresaTarifa = new EmpresaTarifaEJB();
		empresaTarifa.setTarifaEJB((TarifaEJB) tarifaList.get(Integer
				.parseInt(indice)));
		empresaTarifa.setIdHotel(hotel.getIdHotel());
		empresaTarifa
				.setEmpresaHotelEJB((EmpresaHotelEJB) ((EmpresaRedeEJB) entidade
						.getEmpresaRedeEJBList().get(0))
						.getEmpresaHotelEJBList().get(0));
		((EmpresaHotelEJB) ((EmpresaRedeEJB) entidade.getEmpresaRedeEJBList()
				.get(0)).getEmpresaHotelEJBList().get(0))
				.getEmpresaTarifaEJBList().add(empresaTarifa);

		String script = "killModal();";
		try {
			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException localIOException) {
		}
	}

	public void colocaReservaApartamentoDiariaNaSessao(
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, MozartSessionException {
		try {
			Long indiceResApto = Long.parseLong(request
					.getParameter("indiceResApto"));

			List<ReservaApartamentoVO> listReservaApartamento = (List) request
					.getSession().getAttribute(
							"TELA_RESERVA_RESERVA_APARTAMENTO");
			request.getSession().setAttribute(
					"TELA_RESERVA_RESERVA_APARTAMENTO_DIARIA_CORRENTE",
					((ReservaApartamentoVO) listReservaApartamento
							.get(indiceResApto.intValue()))
							.getListReservaApartamentoDiaria());

			String script = "parent.alterarDiarias('" + indiceResApto + "');";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void atualizarReservaApartamentoDiaria(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		Long indiceResAptoDiaria = Long.parseLong(request
				.getParameter("indiceResAptoDiaria"));

		Double valor = MozartUtil.toDouble(request.getParameter("valor"));
		List<ReservaApartamentoDiariaVO> listReservaApartamentoDiaria = (List) request
				.getSession().getAttribute(
						"TELA_RESERVA_RESERVA_APARTAMENTO_DIARIA_CORRENTE");
		((ReservaApartamentoDiariaVO) listReservaApartamentoDiaria
				.get(indiceResAptoDiaria.intValue())).setBcTarifa(valor);

		Long idResApto = Long.parseLong(request.getParameter("idResApto"));
		List<ReservaApartamentoVO> listReservaApartamento = (List) request
				.getSession().getAttribute("TELA_RESERVA_RESERVA_APARTAMENTO");
		ReservaApartamentoVO vo = (ReservaApartamentoVO) listReservaApartamento
				.get(idResApto.intValue());
		vo.setBcTarifa(valor);
	}

	public void obterProximaNotaFiscal(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			StatusNotaEJB notaFiscal = CheckinDelegate.instance()
					.obterProximaNotaFiscal(hotel.getIdHotel());
			request.getSession().setAttribute("notaFiscal", notaFiscal);
			String script = "$('#numNotaFiscal1').val('"
					+ notaFiscal.getNumNota() + "');";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (IOException localIOException) {
		}
	}

	public void atualizaReservaApartamentoApto(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		Long idApto = new Long(request.getParameter("idApto"));
		Long indiceRA = new Long(request.getParameter("indice"));

		List<ApartamentoVO> lista = (List) request.getSession().getAttribute(
				"APTOS_RESERVA");
		ApartamentoVO apto = new ApartamentoVO();
		apto.setBcIdApartamento(idApto);
		if (lista.contains(apto)) {
			apto = (ApartamentoVO) lista.get(lista.indexOf(apto));
		} else {
			apto = ReservaDelegate.instance().obterApartamentoPorId(apto);
		}
		List<ReservaApartamentoVO> listReservaApartamento = (List) request
				.getSession().getAttribute("TELA_RESERVA_RESERVA_APARTAMENTO");
		((ReservaApartamentoVO) listReservaApartamento.get(indiceRA.intValue()))
				.setBcIdApartamento(idApto);
		((ReservaApartamentoVO) listReservaApartamento.get(indiceRA.intValue()))
				.setBcApartamentoDesc(apto.getNumApartamentoStatus());
	}

	public void criptografarParamsReport(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		try {
			String params = request.getParameter("params");
			params = new MozartCryptoReport().encryptString(params);

			PrintWriter out = response.getWriter();
			out.println(params);
			out.flush();
			out.close();
		} catch (IOException localIOException) {
		}
	}

	public void obterCreditoEmpresaDetalhe(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			CreditoEmpresaDetalheVO pFiltro = new CreditoEmpresaDetalheVO();
			pFiltro.setIdEmpresa(Long.parseLong(request
					.getParameter("idEmpresa")));
			pFiltro.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());
			List<CreditoEmpresaDetalheVO> lista = RedeDelegate.instance()
					.obterCreditoEmpresaDetalhe(pFiltro);

			StringBuilder divDupVencidas = new StringBuilder();
			StringBuilder divDupAbertas = new StringBuilder();
			StringBuilder divReserva = new StringBuilder();
			StringBuilder divCheckin = new StringBuilder();

			String killDivDupVencidas = "$('#divDupVencidas').css('display','none');";
			String killDivDupAbertas = "$('#divDupAbertas').css('display','none');";
			String killDivReserva = "$('#divReserva').css('display','none');";
			String killDivCheckin = "$('#divCheckin').css('display','none');";

			CreditoEmpresaVO filtro = new CreditoEmpresaVO();
			filtro.setIdEmpresa(pFiltro.getIdEmpresa());
			List<CreditoEmpresaVO> listaEmpresa = (List) request.getSession()
					.getAttribute("listaPesquisa");
			filtro = (CreditoEmpresaVO) listaEmpresa.get(listaEmpresa
					.indexOf(filtro));
			String nomeEmpresa = filtro.getNomeFantasia();
			for (CreditoEmpresaDetalheVO linha : lista) {
				if (linha.getTipo().equals(new Long(1L))) {
					killDivDupVencidas = "$('#divDupVencidas').css('display','block');";
					divDupVencidas.append("<div class=\"divLinhaCadastro\">");
					divDupVencidas
							.append("<div class=\"divItemGrupo\" style=\"width:60px;\" >"
									+ linha.getSigla() + "&nbsp;</div>");
					divDupVencidas
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ linha.getNumero() + "&nbsp;</div>");
					divDupVencidas
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ MozartUtil.format(linha.getDataSaida(),
											"dd/MM/yyyy") + "&nbsp;</div>");
					divDupVencidas
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ MozartUtil.format(linha.getDataEntrada(),
											"dd/MM/yyyy") + "&nbsp;</div>");
					divDupVencidas
							.append("<div class=\"divItemGrupo\" style=\"width:100px;text-align:right;\" >"
									+ MozartUtil.format(linha.getValor())
									+ "&nbsp;</div>");
					divDupVencidas.append("</div>");
				} else if (linha.getTipo().equals(new Long(2L))) {
					killDivDupAbertas = "$('#divDupAbertas').css('display','block');";
					divDupAbertas.append("<div class=\"divLinhaCadastro\">");
					divDupAbertas
							.append("<div class=\"divItemGrupo\" style=\"width:60px;\" >"
									+ linha.getSigla() + "&nbsp;</div>");
					divDupAbertas
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ linha.getNumero() + "&nbsp;</div>");
					divDupAbertas
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ MozartUtil.format(linha.getDataSaida(),
											"dd/MM/yyyy") + "&nbsp;</div>");
					divDupAbertas
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ MozartUtil.format(linha.getDataEntrada(),
											"dd/MM/yyyy") + "&nbsp;</div>");
					divDupAbertas
							.append("<div class=\"divItemGrupo\" style=\"width:100px;text-align:right;\" >"
									+ MozartUtil.format(linha.getValor())
									+ "&nbsp;</div>");
					divDupAbertas.append("</div>");
				} else if (linha.getTipo().equals(new Long(3L))) {
					killDivReserva = "$('#divReserva').css('display','block');";
					divReserva.append("<div class=\"divLinhaCadastro\">");
					divReserva
							.append("<div class=\"divItemGrupo\" style=\"width:60px;\" >"
									+ linha.getSigla() + "&nbsp;</div>");
					divReserva
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ linha.getIdReserva() + "&nbsp;</div>");
					divReserva
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ MozartUtil.format(linha.getDataEntrada(),
											"dd/MM/yyyy") + "&nbsp;</div>");
					divReserva
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ MozartUtil.format(linha.getDataSaida(),
											"dd/MM/yyyy") + "&nbsp;</div>");
					divReserva
							.append("<div class=\"divItemGrupo\" style=\"width:100px;text-align:right;\" >"
									+ MozartUtil.format(linha.getValor())
									+ "&nbsp;</div>");
					divReserva.append("</div>");
				} else if (linha.getTipo().equals(new Long(4L))) {
					killDivCheckin = "$('#divCheckin').css('display','block');";
					divCheckin.append("<div class=\"divLinhaCadastro\">");
					divCheckin
							.append("<div class=\"divItemGrupo\" style=\"width:60px;\" >"
									+ linha.getSigla() + "&nbsp;</div>");
					divCheckin
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ linha.getIdReserva() + "&nbsp;</div>");
					divCheckin
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ linha.getIdCheckin() + "&nbsp;</div>");
					divCheckin
							.append("<div class=\"divItemGrupo\" style=\"width:60px;\" >"
									+ linha.getNumero() + "&nbsp;</div>");
					divCheckin
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ MozartUtil.format(linha.getDataEntrada(),
											"dd/MM/yyyy") + "&nbsp;</div>");
					divCheckin
							.append("<div class=\"divItemGrupo\" style=\"width:100px;\" >"
									+ MozartUtil.format(linha.getDataSaida(),
											"dd/MM/yyyy") + "&nbsp;</div>");
					divCheckin
							.append("<div class=\"divItemGrupo\" style=\"width:100px;text-align:right;\" >"
									+ MozartUtil.format(linha.getValor())
									+ "&nbsp;</div>");
					divCheckin.append("</div>");
				}
			}
			String script = "$('#divNomeEmpresa').html('"
					+ nomeEmpresa
					+ "');"
					+ killDivDupVencidas
					+ killDivCheckin
					+ killDivDupAbertas
					+ killDivReserva
					+ (divDupVencidas.length() == 0 ? "" : new StringBuilder(
							"$('#divDupVencidasBody').html('")
							.append(divDupVencidas.toString()).append("');")
							.toString())
					+ (divDupAbertas.length() == 0 ? "" : new StringBuilder(
							"$('#divDupAbertasBody').html('")
							.append(divDupAbertas.toString()).append("');")
							.toString())
					+ (divReserva.length() == 0 ? "" : new StringBuilder(
							"$('#divReservaBody').html('")
							.append(divReserva.toString()).append("');")
							.toString())
					+ (divCheckin.length() == 0 ? "" : new StringBuilder(
							"$('#divCheckinBody').html('")
							.append(divCheckin.toString()).append("');")
							.toString())
					+ "killModal();movePanel.Show('divDetalhe');";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
		}
	}

	public void obterMovimentoDoApartamento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			Long idReserva = (Long) request.getSession().getAttribute(
					"ID_RES_PAG_ANTEC");

			ApartamentoEJB origem = new ApartamentoEJB();
			MovimentoApartamentoEJB movApto = new MovimentoApartamentoEJB();

			origem.setIdHotel(hotel.getIdHotel());

			origem.setIdApartamento(new Long(request
					.getParameter("idApartamento")));

			MozartWebUtil.info(MozartWebUtil.getLogin(request),
					"Obtendo despesas de:" + origem.getIdApartamento() + ".",
					this.log);

			movApto.setCheckinEJB(new CheckinEJB());
			movApto.getCheckinEJB().setApartamentoEJB(origem);
			if (!MozartUtil.isNull(idReserva) && idReserva != 0L) {
				movApto.setNumDocumento(idReserva.toString());
			}

			List<MovimentoApartamentoEJB> listaMovimentoAtual = CaixaGeralDelegate
					.instance().obterMovimentoAtualDoApartamento(movApto);
			StringBuilder divMovimento = new StringBuilder();
			for (MovimentoApartamentoEJB linha : listaMovimentoAtual) {
				divMovimento
						.append("<div class=\"divLinhaCadastro\" style=\"border:0px;background-color:white;\">");
				divMovimento
						.append("<div class=\"divItemGrupo\" style=\"width:200px;\" ><input type=\"checkbox\" name=\"despesas\" id=\"despesas\" value=\""
								+ linha.getIdMovimentoApartamento()
								+ "\" />"
								+ linha.getTipoLancamentoEJB()
										.getDescricaoLancamento() + "</div>");
				divMovimento
						.append("<div class=\"divItemGrupo\" style=\"width:100px;text-align:right;\" >"
								+ MozartUtil.format(linha.getValorLancamento())
								+ "&nbsp;</div>");
				divMovimento
						.append("<div class=\"divItemGrupo\" style=\"width:160px;text-align:center;\" >"
								+ MozartUtil.format(linha.getHoraLancamento(),
										"dd/MM/yyyy HH:mm:ss") + "&nbsp;</div>");
				divMovimento
						.append("<div class=\"divItemGrupo\" style=\"width:170px;\" >"
								+ (linha.getNumDocumento() == null ? "&nbsp;"
										: linha.getNumDocumento())
								+ "&nbsp;</div>");
				divMovimento
						.append("<div class=\"divItemGrupo\" style=\"width:250px;\" >"
								+ linha.getRoomListEJB().getHospede()
										.getNomeHospede()
								+ " "
								+ linha.getRoomListEJB().getHospede()
										.getSobrenomeHospede() + "&nbsp;</div>");
				divMovimento.append("</div>");
			}
			request.getSession().setAttribute("movimentoApartamentoList",
					listaMovimentoAtual);
			String script = "$('#divMovimento').html('"
					+ divMovimento.toString() + "');killModal();";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception e) {
			MozartWebUtil.error(MozartWebUtil.getLogin(request), e.getMessage()
					+ ".", this.log);

			PrintWriter out = response.getWriter();
			out.println("$('#divMovimento').html('');killModal();");
			out.flush();
			out.close();
		}
	}

	public void selecionarHospedePorApartamento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionar os selecionarHospedePorApartamento", this.log);

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		String idApto = request.getParameter("OBJ_VALUE");
		String result = "";
		try {
			ApartamentoEJB apto = new ApartamentoEJB();
			apto.setIdHotel(hotel.getIdHotel());
			apto.setIdApartamento(new Long(idApto));

			List<RoomListEJB> list = CaixaGeralDelegate.instance()
					.obterHospedePorApartamento(apto);
			if (MozartUtil.isNull(list)) {
				result = " , |";
			} else {
				for (RoomListEJB linha : list) {
					result = result.concat(linha.getHospede().getNomeHospede()
							+ " " + linha.getHospede().getSobrenomeHospede()
							+ ',' + linha.getIdRoomList().toString() + '|');
				}
			}
			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		} catch (Exception e) {
			PrintWriter out = response.getWriter();
			out.println(" ");
			out.flush();
			out.close();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					"ajax:selecionarHospedePorApartamento", this.log);
		}
	}

	public void pesquisarDisponibilidadeOcupacao(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"pesquisarDisponibilidade", this.log);

		StringBuilder result = new StringBuilder();
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			CrsVO filtro = new CrsVO();
			filtro.setIdHotel(hotel.getIdHotel());
			filtro.setDataEntrada(MozartUtil.toTimestamp(request
					.getParameter("dataIn")));
			filtro.setDataSaida(MozartUtil.toTimestamp(request
					.getParameter("dataOut")));
			filtro.setBloqueio(request.getParameter("bloqueio"));

			String tipo = request.getParameter("tipo");
			HotelEJB hotelResult = null;
			if ("D".equals(tipo)) {
				hotelResult = CrsDelegate.instance().pesquisarDisponibilidade(
						filtro);
			} else if ("O".equals(tipo)) {
				hotelResult = CrsDelegate.instance().pesquisarOcupacao(filtro);
			}
			if (MozartUtil.isNull(hotelResult)) {
				result.append("");
			} else {
				result = getDivDisponibilidadeOcupacao(hotelResult);
			}
			PrintWriter out = response.getWriter();
			out.println("killModal();$('#divBodyDisp').html(\""
					+ result.toString() + "\");");
			out.flush();
			out.close();
		} catch (Exception e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();alerta('Erro ao realizar operação');");
			out.flush();
			out.close();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					"pesquisarDisponibilidade", this.log);
		}
	}

	public void pesquisarOcupacao(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"pesquisarOcupacao", this.log);

		StringBuilder result = new StringBuilder();
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			CrsVO filtro = new CrsVO();
			filtro.setIdHotel(hotel.getIdHotel());
			filtro.setDataEntrada(MozartUtil.toTimestamp(request
					.getParameter("dataIn")));
			filtro.setDataSaida(MozartUtil.toTimestamp(request
					.getParameter("dataOut")));
			filtro.setBloqueio(request.getParameter("bloqueio"));

			HotelEJB hotelResult = CrsDelegate.instance().pesquisarOcupacao(
					filtro);
			if (MozartUtil.isNull(hotelResult)) {
				result.append("");
			} else {
				result = getDivDisponibilidadeOcupacao(hotelResult);
			}
			PrintWriter out = response.getWriter();
			out.println("killModal();$('#divBodyDisp').html('"
					+ result.toString() + "');");
			out.flush();
			out.close();
		} catch (Exception e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();alerta('Erro ao realizar operação');");
			out.flush();
			out.close();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					"pesquisarOcupacao", this.log);
		}
	}

	private StringBuilder getDivDisponibilidadeOcupacao(HotelEJB hotel)
			throws Exception {
		StringBuilder result = new StringBuilder();
		result.append("<div id='coluna02' class='divCrsHotelGrupo' style='width:99%; height:340px; float:left; overflow:auto;'>");

		List<OcupDispVO> lista = hotel.getDisponibilidadeHeader();
		OcupDispVO objetoCorrente = null;
		int x = 0;
		for (OcupDispVO linha : lista) {
			x++;
			if ((objetoCorrente == null)
					|| (!objetoCorrente.getData().equals(linha.getData()))) {
				result.append("<div class='divLinhaCadastro' style='background-color: rgb(200, 200, 200);'>");
				result.append("<div class='divItemGrupo' style='width: 65px;'>");
				result.append("<p style='width:100%;color:white;'>Data</p>");
				result.append("</div>");
			}
			result.append("<div class='divItemGrupo' style='width: 30px; margin:1px; text-align:center;'>");
			result.append("<p style='width:100%;color:white;'>");
			result.append(linha.getFantasia());
			result.append("</p>");
			result.append("</div>");

			objetoCorrente = linha;
			if (x == lista.size()) {
				result.append("<div class='divItemGrupo' style='width: 40px; margin:1px; text-align:center;'>");
				result.append("<p style='width:100%;color:white;'>Total</p>");
				result.append("</div>");

				result.append("<div class='divItemGrupo' style='width: 40px; margin:1px; text-align:center;'>");
				result.append("<p style='width:100%;color:white;'>%</p>");
				result.append("</div>");

				result.append("</div>");
			}
		}
		lista = hotel.getDisponibilidade();
		objetoCorrente = null;
		x = 0;
		Long acmDia = new Long(0L);
		for (OcupDispVO linha : lista) {
			x++;
			if (objetoCorrente == null) {
				result.append("<div class='divLinhaCadastro'>");
				result.append("<div class='divItemGrupo' style='width: 65px;'>");
				result.append(linha.getData());
				result.append("</div>");
			} else if (!objetoCorrente.getData().equals(linha.getData())) {
				result.append("<div class='divItemGrupo' style='width: 40px; margin:1px; text-align:center; ");
				result.append(acmDia.longValue() <= 10L ? "background-color:yellow; color:black;"
						: acmDia.longValue() <= 0L ? "background-color:red; color:white;"
								: "background-color:green; color:white;");
				result.append("'>" + acmDia);
				result.append("</div>");

				result.append("<div class='divItemGrupo' style='width: 40px; margin:1px; text-align:center; ");
				result.append(

				new Double(acmDia.longValue() * 100L
						/ objetoCorrente.getTotal().longValue()).doubleValue() <= 10.0D ? "background-color:yellow; color:black;"
						: new Double(acmDia.longValue() * 100L
								/ objetoCorrente.getTotal().longValue())
								.doubleValue() <= 0.0D ? "background-color:red; color:white;"
								: "background-color:green; color:white;");
				result.append("'>"
						+ MozartUtil.format(new Double(acmDia.longValue()
								* 100L / objetoCorrente.getTotal().longValue())));
				result.append("</div>");
				acmDia = 0L;

				result.append("</div>");
				result.append("<div class='divLinhaCadastro'>");
				result.append("<div class='divItemGrupo' style='width: 65px;margin:1px;'>");
				result.append(linha.getData());
				result.append("</div>");
			}
			result.append("<div class='divItemGrupo' style='width: 30px; margin:1px; text-align:center; ");
			result.append(linha.getValor().longValue() <= 10L ? "background-color:yellow; color:black;"
					: linha.getValor().longValue() <= 0L ? "background-color:red; color:white;"
							: "background-color:green; color:white;");
			result.append("'>");
			result.append(linha.getValor());
			result.append("</div>");
			acmDia = acmDia.longValue() + linha.getValor().longValue();
			objetoCorrente = linha;
			if (x == lista.size()) {
				result.append("<div class='divItemGrupo' style='width: 40px; margin:1px; text-align:center; ");
				result.append(acmDia.longValue() <= 10L ? "background-color:yellow; color:black;"
						: acmDia.longValue() <= 0L ? "background-color:red; color:white;"
								: "background-color:green; color:white;");
				result.append("'>" + acmDia);
				result.append("</div>");

				result.append("<div class='divItemGrupo' style='width: 40px; margin:1px; text-align:center; ");
				result.append(

				new Double(acmDia.longValue() * 100L
						/ objetoCorrente.getTotal().longValue()).doubleValue() <= 10.0D ? "background-color:yellow; color:black;"
						: new Double(acmDia.longValue() * 100L
								/ objetoCorrente.getTotal().longValue())
								.doubleValue() <= 0.0D ? "background-color:red; color:white;"
								: "background-color:green; color:white;");
				result.append("'>"
						+ MozartUtil.format(new Double(acmDia.longValue()
								* 100L / objetoCorrente.getTotal().longValue())));
				result.append("</div>");

				result.append("</div>");
			}
		}
		result.append("</div>");

		return result;
	}

	public void adicionarTarifaIdioma(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"adicionarTarifaIdioma", this.log);
		try {
			List<TarifaIdiomaEJB> lista = (List) request.getSession()
					.getAttribute("LISTA_TARIFA_IDIOMA");
			((TarifaIdiomaEJB) lista.get(Integer.parseInt(request
					.getParameter("idx")))).setDescricaoWeb(request
					.getParameter("value"));
			request.getSession().setAttribute("LISTA_TARIFA_IDIOMA", lista);
		} catch (Exception e) {
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					"adicionarTarifaIdioma", this.log);
		}
	}

	public void gravarNovoHospede(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"gravarNovoHospede", this.log);
		try {
			List<RoomListVO> listRoomList = (List) request.getSession()
					.getAttribute("TELA_RESERVA_ROOM_LIST_ATUAL");
			int qtdePaxMax = Integer.parseInt(request
					.getParameter("qtdePaxMax"));

			String origem = request.getParameter("origem");
			String paraTodos = request.getParameter("paraTodos");

			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			HospedeEJB novoHospede = new HospedeEJB();
			novoHospede.setNomeHospede(request.getParameter("nome"));
			novoHospede.setSobrenomeHospede(request.getParameter("sobreNome"));
			novoHospede.setCpf(request.getParameter("cpf"));

			novoHospede.setPassaporte(request.getParameter("passaporte"));
			novoHospede.setNascimento(MozartUtil.toTimestamp(
					request.getParameter("dataNascimento"), "dd/MM/yyyy"));
			novoHospede.setEmail(request.getParameter("email"));
			novoHospede.setSexo(request.getParameter("sexo"));

			novoHospede
					.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());
			novoHospede = CheckinDelegate.instance().gravarHospede(novoHospede);

			RoomListVO roomListVO = new RoomListVO();
			roomListVO.setBcChegou("N");
			roomListVO.setBcIdHospede(novoHospede.getIdHospede());
			roomListVO.setBcNomeHospede(novoHospede.getNomeHospede() + " "
					+ novoHospede.getSobrenomeHospede());
			roomListVO.setBcPrincipal(listRoomList.size() == 0 ? "S" : "N");

			String script = "killModal();";
			if ("1".equals(origem)) {
				if (qtdePaxMax > listRoomList.size()) {
					listRoomList.add(roomListVO);
					script = script + "atualizarResAptoRL();";
					if (listRoomList.size() < qtdePaxMax) {
						script = script + "abrirCadastroHospede('1');";
					}
					script = script
							+ "document.getElementById('nomeHospede').value = '';";
					script = script + "$('#hospedePrincipal').val('S');";
					script = script
							+ "document.getElementById('idHospedeSelecionado').value = '';";
				} else {
					script = script
							+ "abrirCadastroHospede('1');alerta('O Apartamento já está com a sua capacidade máxima de hospede.');";
				}
			} else if ("2".equals(origem)) {
				if ("S".equals(paraTodos)) {
					List<ReservaApartamentoVO> listReservaApartamento = (List) request
							.getSession().getAttribute(
									"TELA_RESERVA_RESERVA_APARTAMENTO");
					// Setando o valor do roomlist
					for (ReservaApartamentoVO objResApto : listReservaApartamento) {
						int x = 0;
						for (RoomListVO roomList : objResApto.getListRoomList()) {
							if (x == 0) {
								roomList.setBcNomeHospede(novoHospede
										.getNomeHospede()
										+ " "
										+ novoHospede.getSobrenomeHospede());
								roomList.setBcIdHospede(novoHospede
										.getIdHospede());
								roomList.setBcPrincipal("S");
								roomList.setBcTemp("");// STirando o temp
							} else {
								roomList.setBcPrincipal("N");
							}
							x++;
						}
					}
					script = script + "atualizarResAptoRL();";
				} else {
					script = script + "abrirCadastroHospede('2');";
				}
			}
			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception e) {
			PrintWriter out = response.getWriter();
			out.println("alerta('Erro: " + e.getMessage() + "');killModal();");
			out.flush();
			out.close();

			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					"gravarNovoHospede", this.log);
		}
	}

	public void pesquisarNotas(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request), "pesquisarNotas",
				this.log);
		try {
			String tipoNota = request.getParameter("tipoNota");
			String dataInicial = request.getParameter("dataInicial");
			String dataFinal = request.getParameter("dataFinal");

			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			List<StatusNotaVO> listaResult = CheckinDelegate.instance()
					.pesquisarStatusNota(hotel, tipoNota,
							MozartUtil.toTimestamp(dataInicial),
							MozartUtil.toTimestamp(dataFinal));

			String textEValues = "";
			for (StatusNotaVO vo : listaResult) {
				textEValues = textEValues
						+ MozartUtil.rpad(
								(tipoNota.equals("F")) ? vo.getNotaInicial()
										: vo.getNumNota(), " ", 10)
						+ " : "
						+ MozartUtil.rpad(
								vo.getNumApartamento() + "-"
										+ vo.getTipoApartamento(), " ", 10)
						+ " : " + MozartUtil.rpad(vo.getNomeHospede(), " ", 60)
						+ " : " + MozartUtil.rpad(vo.getNomeEmpresa(), " ", 60)
						+ "," + vo.getIdNota() + "|";
			}
			textEValues = "Selecione, |" + textEValues;
			textEValues = textEValues.substring(0, textEValues.length() - 1);

			PrintWriter out = response.getWriter();
			out.println(textEValues);
			out.flush();
			out.close();
		} catch (Exception e) {
			PrintWriter out = response.getWriter();
			out.println("killModal();");
			out.flush();
			out.close();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					"pesquisarNotas", this.log);
		}
	}

	public void pesquisarHospedeFNRH(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			RoomListEJB param = new RoomListEJB();
			String dataInicial = request.getParameter("dataInicial");
			String dataFinal = request.getParameter("dataFinal");
			param.setIdHotel(hotel.getIdHotel());
			param.setDataEntrada(MozartUtil.toTimestamp(dataInicial));
			param.setDataSaida(MozartUtil.toTimestamp(dataFinal));

			List<RoomListVO> listaApartamento = CheckinDelegate.instance()
					.pesquisarHospedeFNRH(param);

			String textEValues = "Todos,ALL|";

			for (RoomListVO vo : listaApartamento) {
				textEValues = textEValues
						+ MozartUtil.format(vo.getBcDataCertificado()) + " - "
						+ vo.getBcIdReserva() + " - " + vo.getBcNomeHospede()
						+ "," + vo.getBcIdReserva() + "|";
			}
			textEValues = textEValues.substring(0, textEValues.length() - 1);
			MozartWebUtil.warn(MozartWebUtil.getLogin(request), textEValues,
					this.log);

			PrintWriter out = response.getWriter();
			out.println(textEValues);
			out.flush();
			out.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void pesquisarApartamento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			CaixaGeralVO param = new CaixaGeralVO();
			param.setIdHotel(hotel.getIdHotel());
			param.setCofan("N");
			param.setStatus(";OA;OS;");
			List<CaixaGeralVO> listaApartamento = CaixaGeralDelegate.instance()
					.pesquisarApartamentoComCheckinEReserva(param);

			String textEValues = "";
			for (CaixaGeralVO vo : listaApartamento) {
				textEValues =

				textEValues + vo.getNumApartamento() + " - "
						+ vo.getTipoApartamento() + ","
						+ vo.getNumApartamento() + "|";
			}
			textEValues = textEValues.substring(0, textEValues.length() - 1);
			MozartWebUtil.warn(MozartWebUtil.getLogin(request), textEValues,
					this.log);

			PrintWriter out = response.getWriter();
			out.println(textEValues);
			out.flush();
			out.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void preparaGravacaoTelefonia(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			PrintWriter out = response.getWriter();
			out.println("alerta('Arquivo lido com sucesso');killModal();");
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("killModal()");
			out.flush();
			out.close();
		}
	}

	public void obterPermissaoSistema(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			String adm = request.getParameter("adm");
			String carregaUsuario = request.getParameter("carregaUsuario");
			carregaUsuario = (!MozartUtil.isNull(carregaUsuario)) ? "loadUsr('"
					+ carregaUsuario + "');" : "";
			Long tipo = getHotelCorrente(request).getIdPrograma();
			Long tipoRede = "S".equals(adm) ? tipo + 1 : tipo;

			List<MenuMozartWebEJB> menus = UsuarioDelegate.instance()
					.listarMenus(tipo, tipoRede);

			String menuStr = new ArvorePermissaoHelper(menus, tipo, tipoRede)
					.build();

			request.getSession().setAttribute("menus", menuStr);

			menuStr = menuStr.replaceAll("\n", "").replaceAll("'", "\"");

			PrintWriter out = response.getWriter();
			out.println("killModal();$('#ulPermissoes').css('display','none');$('#ulPermissoes').html('"
					+ menuStr.replaceAll("\n", "").replaceAll("'", "\"")
					+ "');$treeMenu.update();$treeMenu = $('#treeMenu').checkTree();$('#ulPermissoes').css('display','block');"
					+ carregaUsuario);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("killModal()");
			out.flush();
			out.close();
		}
	}

	public void calcularTotalReserva(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			PrintWriter out = response.getWriter();
			out.println("killModal();"
					+ calculaTotalReservaEGeraScript(request));
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("killModal()");
			out.flush();
			out.close();
		}
	}

	public void pesquisarCamareira(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			CamareiraEJB param = new CamareiraEJB();
			param.setIdHotel(hotel.getIdHotel());
			List<CamareiraEJB> lista = OperacionalDelegate.instance()
					.pesquisaCamareira(param);

			String textEValues = "Todas,ALL|";
			for (CamareiraEJB vo : lista) {
				textEValues = textEValues + vo.getNomeCamareira() + ","
						+ vo.getIdCamareira() + "|";
			}
			textEValues = textEValues.substring(0, textEValues.length() - 1);
			MozartWebUtil.warn(MozartWebUtil.getLogin(request), textEValues,
					this.log);

			PrintWriter out = response.getWriter();
			out.println(textEValues);
			out.flush();
			out.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void pesquisarArea(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			ApartamentoVO param = new ApartamentoVO();
			param.setIdHoteis(new Long[] { hotel.getIdHotel() });

			List<ApartamentoVO> lista = OperacionalDelegate.instance()
					.pesquisarArea(param);

			String textEValues = "Todas,ALL|";
			for (ApartamentoVO vo : lista) {
				textEValues = textEValues + vo.getBcAerea() + ","
						+ vo.getBcAerea() + "|";
			}
			textEValues = textEValues.substring(0, textEValues.length() - 1);
			MozartWebUtil.warn(MozartWebUtil.getLogin(request), textEValues,
					this.log);

			PrintWriter out = response.getWriter();
			out.println(textEValues);
			out.flush();
			out.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void mensagemUsuarioWebExcluir(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String script = "";
		PrintWriter out;
		try {
			String indice = request.getParameter("indice");
			String lote = request.getParameter("lote");
			script = "N".equals(lote) ? "killModal();" : "";
			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Excluindo usuário da mensagem:" + indice + ".", this.log);
			List<MensagemWebUsuarioEJB> entidade = (List) request.getSession()
					.getAttribute("usuarioAdicionadoList");
			entidade.remove(Integer.parseInt(indice));
		} finally {
			out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		}
	}

	public void mensagemUsuarioWebIncluir(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String script = "";
		PrintWriter out;
		try {
			String idUsuario = request.getParameter("idUsuario");
			String nomeUsuario = request.getParameter("nomeUsuario");
			String lote = request.getParameter("lote");
			script = "N".equals(lote) ? "killModal();" : "";
			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Incluindo usuário da mensagem:" + idUsuario + ".",
					this.log);
			List<MensagemWebUsuarioEJB> entidade = (List) request.getSession()
					.getAttribute("usuarioAdicionadoList");
			MensagemWebUsuarioEJB novo = new MensagemWebUsuarioEJB();
			novo.getUsuarioEJB().setIdUsuario(Long.parseLong(idUsuario));
			novo.getUsuarioEJB().setNome(nomeUsuario);
			novo.getId().setIdUsuario(Long.parseLong(idUsuario));
			if (!entidade.contains(novo)) {
				entidade.add(novo);
				script =

				"podeAdicionarUsuario('" + nomeUsuario + "');";
			}
		} finally {
			out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		}
	}

	public void selecionarRoomList(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String result = "";
		try {
			String idCheckin = request.getParameter("idCheckin");
			String idCombo = request.getParameter("idCombo");
			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Pesquisando hóspede para empréstimo objeto:" + idCheckin
							+ ".", this.log);

			List<RoomListEJB> list = CaixaGeralDelegate.instance()
					.obterHospedePorCheckin(Long.valueOf(idCheckin));
			if (MozartUtil.isNull(list)) {
				result = " , |";
			} else {
				for (RoomListEJB linha : list) {
					result = result.concat(linha.getHospede().getNomeHospede()
							+ " " + linha.getHospede().getSobrenomeHospede()
							+ ',' + linha.getIdRoomList().toString() + '|');
				}
			}
			PrintWriter out = response.getWriter();
			out.println("preencherComboBoxJS('" + idCombo + "', '" + result
					+ "');pesquisarObjetos();");
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		}
	}

	public void selecionarObjetos(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String result = "";
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Pesquisando os objetos do hotel:" + hotel.getIdHotel()
							+ ".", this.log);

			List<ObjetoEJB> list = CaixaGeralDelegate.instance()
					.obterObjetoPorHotel(hotel.getIdHotel());
			if (MozartUtil.isNull(list)) {
				result = " , |";
			} else {
				for (ObjetoEJB linha : list) {
					result = result.concat(linha.getFantasia() + ','
							+ linha.getIdObjeto().toString() + '|');
				}
			}
			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		}
	}

	public void gravarEmprestimo(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Gravando o emprestimo:" + hotel.getIdHotel() + ".",
					this.log);

			String idCheckin = request.getParameter("idCheckin");
			String idRoomList = request.getParameter("idRoomListEmprestimo");
			String idObjeto = request.getParameter("idObjetoEmprestimo");
			String data = request.getParameter("dataEmprestimo");
			String qtde = request.getParameter("qtdeEmprestimo");
			String obs = request.getParameter("obsEmprestimo");

			MovimentoObjetoEJB movimento = new MovimentoObjetoEJB();
			movimento.setData(MozartUtil.toTimestamp(data));
			movimento.setIdCheckin(Long.valueOf(idCheckin));
			movimento.setIdHotel(hotel.getIdHotel());
			movimento.setObservacao(obs);
			movimento.setQtde(Long.valueOf(qtde));

			ObjetoEJB obj = new ObjetoEJB();
			obj.setIdObjeto(Long.valueOf(idObjeto));
			movimento.setObjetoEJB(obj);

			RoomListEJB roomList = new RoomListEJB();
			roomList.setIdRoomList(Long.valueOf(idRoomList));
			movimento.setRoomListEJB(roomList);
			movimento.setUsuario(((UsuarioSessionEJB) request.getSession()
					.getAttribute("USER_SESSION")).getUsuarioEJB());
			CheckinDelegate.instance().incluir(movimento);

			PrintWriter out = response.getWriter();
			out.println("alerta('Operação realizada com sucesso');$('#idRoomListEmprestimo').val('');$('#idObjetoEmprestimo').val('');$('#dataEmprestimo').val('');$('#qtdeEmprestimo').val('');$('#obsEmprestimo').val('');");
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("alerta('Erro ao realizar operação');");
			out.flush();
			out.close();
		}
	}

	public void pesquisarAjuste(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String result = "";
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Pesquisando os ajustes do hotel:" + hotel.getIdHotel()
							+ ".", this.log);
			String idCombo = request.getParameter("idCombo");
			ComprovanteAjusteVO ajuste = new ComprovanteAjusteVO();

			ajuste.setIdHoteis(new Long[] { hotel.getIdHotel() });
			ajuste.setDataLancamento(MozartUtil.toTimestamp(request
					.getParameter("dataInicial")));

			List<ComprovanteAjusteVO> list = AuditoriaDelegate.instance()
					.obterComprovanteAjuste(ajuste);
			if (MozartUtil.isNull(list)) {
				result = " , |";
			} else {
				for (ComprovanteAjusteVO linha : list) {
					result = result.concat(linha.toString() + ','
							+ linha.getComprovanteAjuste().toString() + '|');
				}
			}
			PrintWriter out = response.getWriter();
			out.println("preencherComboBoxJS('" + idCombo + "', '" + result
					+ "');killModal();");
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		}
	}

	public void preencheCupomFiscal(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String result = "";
		try {
			StatusNotaEJB notaHospedagem = (StatusNotaEJB) request.getSession()
					.getAttribute("notaHospedagem");
			notaHospedagem.setNumNota(request.getParameter("numCupomFiscal"));
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		}
	}

	public void pesquisarDuplicatas(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String result = "Todas,-1|";
		try {
			String data = request.getParameter("dataInicial");
			String idContaCorrente = request.getParameter("idCC");
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			DuplicataVO filtro = new DuplicataVO();
			filtro.setIdHoteis(new Long[] { hotel.getIdHotel() });
			filtro.setFiltroTipoPesquisa("3");
			filtro.getFiltroDataLancamento().setTipo("D");
			filtro.getFiltroDataLancamento().setTipoIntervalo("2");
			filtro.getFiltroDataLancamento().setValorInicial(data);
			if (!MozartUtil.isNull(idContaCorrente)) {
				filtro.getFiltroContaCorrente().setTipo("I");
				filtro.getFiltroContaCorrente().setTipoIntervalo("2");
				filtro.getFiltroContaCorrente()
						.setValorInicial(idContaCorrente);
			}
			List<DuplicataVO> listaPesquisa = FinanceiroDelegate.instance()
					.pesquisarDuplicata(filtro);
			for (DuplicataVO vo : listaPesquisa) {
				result = result + vo.toString() + " - " + vo.getEmpresa() + ","
						+ vo.getIdDuplicata() + "|";
			}
			result = result.substring(0, result.length() - 1);

			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		}
	}

	public void pesquisarBanco(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String result = "Selecione, |";
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			BancoVO filtro = new BancoVO();
			filtro.setIdHoteis(new Long[] { hotel.getIdHotel() });
			List<BancoVO> bancoList = SistemaDelegate.instance()
					.pesquisarBanco(filtro);
			for (BancoVO vo : bancoList) {
				result = result + vo.getNomeFantasia() + "," + vo.getIdBanco()
						+ "|";
			}
			result = result.substring(0, result.length() - 1);

			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		}
	}

	public void pesquisarContaCorrente(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String result = "Todos, |";
		String carteira = request.getParameter("carteira");
		String cobranca = request.getParameter("cobranca");
		String boleto = request.getParameter("boleto");
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			ContaCorrenteVO filtro = new ContaCorrenteVO();
			filtro.setIdHoteis(new Long[] { hotel.getIdHotel() });

			if (cobranca != null && !cobranca.equals("")) {
				filtro.setCobranca(cobranca);
			}
			if (carteira != null && !carteira.equals("")) {
				filtro.setCarteira(carteira);
			}
			if (boleto != null && !boleto.equals("")) {
				filtro.setBoleto(boleto);
			}

			List<ContaCorrenteVO> contaCorrenteList = ControladoriaDelegate
					.instance().pesquisarContaCorrente(filtro);
			for (ContaCorrenteVO vo : contaCorrenteList) {
				// TODO: (ID/Conta Corrente)
				result = result + vo.toString() + "," + vo.getIdContaCorrente()
						+ "|";
			}
			result = result.substring(0, result.length() - 1);

			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println(result);
			out.flush();
			out.close();
		}
	}

	public void selecionarContaCorrente(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String result = "";
		String elemento = request.getParameter("OBJ_NAME");
		String conta = request.getParameter("OBJ_VALUE");
		String idHidden = request.getParameter("OBJ_HIDDEN");

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"" + "$('#%s').val('%s');"
				+ "$('#%s').val('%s');" + "$('div.divLookup').remove();"
				+ "\" >%s</li>";
		builder.append("<ul>");

		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			ContaCorrenteVO filtro = new ContaCorrenteVO();
			filtro.setIdHoteis(new Long[] { hotel.getIdHotel() });
			filtro.setBanco(conta);

			List<ContaCorrenteVO> contaCorrenteList = ControladoriaDelegate
					.instance().obterContaCorrenteLookup(filtro);
			for (ContaCorrenteVO vo : contaCorrenteList) {
				String nome = vo.getBanco();
				Long idContaCorrente = vo.getIdContaCorrente();
				builder.append(String.format(linha, new Object[] { elemento,
						nome, idHidden, idContaCorrente, nome }));
			}
			result = result.substring(0, result.length() - 1);

		} catch (Exception ex) {

		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void atualizarDuplicataNaSessao(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			String idDuplicata = request.getParameter("idDuplicata");
			DuplicataVO filtro = new DuplicataVO();
			filtro.setIdDuplicata(new Long(idDuplicata));
			List<DuplicataVO> listaPesquisa = (List) request.getSession()
					.getAttribute("listaPesquisa");
			filtro = (DuplicataVO) listaPesquisa.get(listaPesquisa
					.indexOf(filtro));

			ContaCorrenteVO contaCorrente = new ContaCorrenteVO();
			Long idContaCorrente = new Long(
					request.getParameter("contaCorrente"));
			if (idContaCorrente != null) {
				HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
						"HOTEL_SESSION");
				ContaCorrenteVO filtroContaCorrente = new ContaCorrenteVO();
				filtroContaCorrente.setIdContaCorrente(idContaCorrente);
				filtroContaCorrente.setIdHotel(hotel.getIdHotel());
				contaCorrente = ContaCorrenteDelegate.instance()
						.obterContaCorrente(filtroContaCorrente);
			}

			if (contaCorrente != null
					&& contaCorrente.getIdContaCorrente() != null) {
				filtro.setContaCorrente(contaCorrente.getNumContaCorrente());
				filtro.setIdContaCorrente(contaCorrente.getIdContaCorrente());
			} else {
				filtro.setIdContaCorrente(new Long(request
						.getParameter("contaCorrente")));
				filtro.setContaCorrente(new Long(request
						.getParameter("contaCorrente")));
			}

			filtro.setIdEmpresa(new Long(request.getParameter("idEmpresa")));
			filtro.setEmpresa(request.getParameter("empresa"));
			filtro.setJuros(MozartUtil.toDouble(request
					.getParameter("jurosRecebimento")));
			filtro.setDescontoRecebimento(MozartUtil.toDouble(request
					.getParameter("descontoRecebimento")));
			filtro.setRetencao(MozartUtil.toDouble(request
					.getParameter("retencao")));
			filtro.setCofins(MozartUtil.toDouble(request.getParameter("cofins")));
			filtro.setPis(MozartUtil.toDouble(request.getParameter("pis")));
			filtro.setCssl(MozartUtil.toDouble(request.getParameter("cssl")));
			filtro.setIss(MozartUtil.toDouble(request.getParameter("iss")));
			filtro.setIdPlanoContas(MozartUtil.toLong(request
					.getParameter("idPlanoContas")));
			filtro.setIdCentroCusto(MozartUtil.toLong(request
					.getParameter("idCentroCusto")));
			filtro.setJustificativa(request.getParameter("justificaAjuste"));
			filtro.setAgrupar(request.getParameter("agrupar"));
			filtro.setDataProrrogado(MozartUtil.toDate(request
					.getParameter("dataProrrogacao")));

			PrintWriter out = response.getWriter();
			out.println("atualizar();");
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("killModal();alerta('Erro ao realizar operação.')");

			out.flush();
			out.close();
		}
	}

	public void prepararRelatorioRDSAnual(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			String ateDia = request.getParameter("ateDia");
			String ateMes = request.getParameter("ateMes");
			String anoInicial = request.getParameter("anoInicial");
			String anoFinal = request.getParameter("anoFinal");
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			MarketingDelegate.instance().executarRDSAnual(hotel.getIdHotel(),
					ateDia, ateMes, anoInicial, anoFinal);

			PrintWriter out = response.getWriter();
			out.println("abrirRDSAnual();");
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("alerta('Erro ao realizar operação.')");
			out.flush();
			out.close();
		}
	}

	// TODO: (ID) Método muito grande.
	public void obterFornecedoresPorNomeOuCNPJ(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		// TODO: (ID) Cross-cutting concerns misturados ao código. tsc tsc tsc
		// (Implementar Aspect)
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando fornecedor", this.log);

		// TODO: (ID) Lixo de código
		// Trata-se do id do elemento exibido em tela. Quando selecionada uma
		// das opções apresentadas, substitui o valor do elemento para o usuário
		String idElemento = request.getParameter("OBJ_NAME");
		// Trata-se do id do elemento hidden que é usado para armazenar o
		// identificar da tupla, bind no modelo
		String idElementoOculto = request.getParameter("OBJ_HIDDEN");
		// Trata-se do valor do input, utilizado para realizar a pesquisa
		String valorElemento = request.getParameter("OBJ_VALUE");

		// TODO: (ID) Refatorar esse lixo. O que é C? O que é 2?
		FiltroWeb filtroNomeFantasiaCNPJ = new FiltroWeb();
		filtroNomeFantasiaCNPJ.setTipo("C");
		filtroNomeFantasiaCNPJ.setTipoIntervalo("2");
		filtroNomeFantasiaCNPJ.setValorInicial(valorElemento.trim()
				.toUpperCase());

		EmpresaVO filtro = new EmpresaVO();
		filtro.setIdHotel(getHotelCorrente(request).getIdHotel());
		filtro.setFiltroNomeFantasiaCNPJ(filtroNomeFantasiaCNPJ);

		// TODO: (ID) Extrair método de response. Single Responsibility
		// O onclick poderia ter uma função javascript ao invés de executar
		// diretamente.
		String linha = "<li onclick=\"$('#%s').val('%s'); $('#%s').val('%s'); $('div.divLookup').remove();complementoFornecedor('%s')\" >%s</li>";
		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		try {
			List<EmpresaVO> lista = EmpresaDelegate.instance()
					.obterFornecedoresHotelPorNomeOuCNPJ(filtro);
			for (EmpresaVO empresa : lista) {
				sb.append(String.format(
						linha,
						new Object[] { idElemento, empresa.getNomeFantasia(),
								idElementoOculto,
								String.valueOf(empresa.getIdEmpresa()),
								String.valueOf(empresa.getPrazoPagamento()),
								empresa.getNomeFantasia() }));
			}
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
		sb.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}

	public void obterFiscalCodigos(HttpServletRequest request,
			HttpServletResponse response) {
		ComponenteAjax componente = getComponenteAjax(request);
		FiscalCodigoVO filtro = montarFiltroFiscalCodigo(request, componente);
		try {
			componente.setQueryResultado(obterFiscalCodigos(filtro));
			renderizarFiscalCodigoEstoque(response, componente);
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
	}

	private void renderizarFiscalCodigoEstoque(HttpServletResponse response,
			ComponenteAjax componente) throws IOException {
		List<FiscalCodigoVO> itensFicais = (List<FiscalCodigoVO>) componente
				.getQueryResultado();
		String listItem = "<li onclick=\"selecionarFiscalCodigo('%s', '%s', '%s', '%s'); \" >%s</li>";

		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		for (FiscalCodigoVO itemFiscal : itensFicais) {
			sb.append(String.format(
					listItem,
					componente.getIdElemento(),
					componente.getIdElementoOculto(),
					itemFiscal.getSubCodigo() + " - "
							+ itemFiscal.getDescricao(),
					String.valueOf(itemFiscal.getIdCodigoFiscal()),
					itemFiscal.getSubCodigo() + " - "
							+ itemFiscal.getDescricao()));
		}
		sb.append("</ul>");

		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}

	private List<FiscalCodigoVO> obterFiscalCodigos(FiscalCodigoVO filtro)
			throws MozartSessionException {
		List<FiscalCodigoVO> resultado = CustoDelegate.instance()
				.obterFiscalCodigos(filtro);
		return resultado;
	}

	private FiscalCodigoVO montarFiltroFiscalCodigo(HttpServletRequest request,
			ComponenteAjax componente) {
		// TODO: (ID) Refatorar esse lixo. O que é C? O que é 2?
		FiltroWeb filtroSubcodigoOuDescricao = new FiltroWeb();
		filtroSubcodigoOuDescricao.setTipo("C");
		filtroSubcodigoOuDescricao.setTipoIntervalo("2");
		filtroSubcodigoOuDescricao
				.setValorInicial(componente.getQueryUsuario());

		FiscalCodigoVO filtro = new FiscalCodigoVO();
		filtro.setFiltroSubcodigoOuDescricao(filtroSubcodigoOuDescricao);

		return filtro;
	}

	public void obterItensEstoqueMovimentoEstoque(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO: (ID) Cross-cutting concerns misturados ao código. tsc tsc tsc
		// (Implementar Aspect)
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando ItemEstoque", this.log);

		ComponenteAjax componente = getComponenteAjax(request);
		EstoqueItemVO filtro = montarFiltroMovimentoEstoque(request, componente);

		String idCentroCusto = request.getParameter("OBJ_CENTRO_CUSTO_VALUE");
		if (!MozartUtil.isNull(idCentroCusto)) {
			filtro.setIdCentroCusto(Long.parseLong(idCentroCusto));
		}

		try {
			componente.setQueryResultado(obterItensEstoque(filtro));
			renderizarItensEstoqueMovimentoEstoque(response, componente);
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
	}

	public void obterValorUnitarioEstoqueMovimentoEstoque(
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando ItemEstoque", this.log);

		ItemEstoqueVO filtro = new ItemEstoqueVO();
		filtro.setIdItem(new Long(request.getParameter("idItem")));
		filtro.setIdHotel(getHotelCorrente(request).getIdHotel());
		StringBuilder builder = new StringBuilder();
		try {
			List<ItemEstoqueVO> itemEstoqueVO = EstoqueDelegate.instance()
					.pesquisarValorUnitarioItem(filtro);

			if (!itemEstoqueVO.isEmpty()) {
				builder.append(itemEstoqueVO.get(0).getVlUnitario() + ";"
						+ itemEstoqueVO.get(0).getQuantidade());
			}
			// builder.append("10");
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}

		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void obterValorUnitarioDevolucaoMovimentoEstoque(
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando ItemEstoque", this.log);

		ItemEstoqueVO filtro = new ItemEstoqueVO();
		filtro.setIdItem(new Long(request.getParameter("idItem")));
		filtro.setIdCentroCusto(new Long(request.getParameter("idCentroCusto")));
		filtro.setIdHotel(getHotelCorrente(request).getIdHotel());
		StringBuilder builder = new StringBuilder();
		try {
			List<ItemEstoqueVO> itemEstoqueVO = EstoqueDelegate.instance()
					.pesquisarValorUnitarioDevolucaoItem(filtro);

			if (!itemEstoqueVO.isEmpty()) {
				builder.append(itemEstoqueVO.get(0).getVlUnitario() + ";"
						+ itemEstoqueVO.get(0).getQuantidade());
			} else {
				builder.append("0;0");
			}
			// builder.append("10");
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}

		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}
	
	public void obterQuantidadeValorUnitarioTransferenciaCusto(
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando ItemEstoque", this.log);

		ItemEstoqueVO filtro = new ItemEstoqueVO();
		filtro.setIdItem(new Long(request.getParameter("idItem")));
		filtro.setIdCentroCusto(new Long(request.getParameter("idCentroCusto")));
		filtro.setIdHotel(getHotelCorrente(request).getIdHotel());
		StringBuilder builder = new StringBuilder();
		try {
			List<ItemEstoqueVO> itemEstoqueVO = EstoqueDelegate.instance()
					.pesquisarValorUnitarioTransferenciaCusto(filtro);

			if (!itemEstoqueVO.isEmpty()) {
				builder.append(itemEstoqueVO.get(0).getVlUnitario() + ";");
			} else {
				builder.append("0;");
			}
			
			itemEstoqueVO = EstoqueDelegate.instance()
					.pesquisarQuantidadeTransferenciaCusto(filtro);

			if (!itemEstoqueVO.isEmpty()) {
				builder.append(itemEstoqueVO.get(0).getQuantidade());
			} else {
				builder.append("0");
			}
			// builder.append("10");
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}

		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}
	
	private List<EstoqueItemVO> obterItensEstoque(EstoqueItemVO filtro)
			throws MozartSessionException {
		List<EstoqueItemVO> resultado = ComprasDelegate.instance()
				.pesquisarEstoqueItem(filtro);
		return resultado;
	}

	private ComponenteAjax getComponenteAjax(HttpServletRequest request) {
		ComponenteAjax componente = new ComponenteAjax();
		componente.setIdElemento(request.getParameter("OBJ_NAME"));
		componente.setIdElementoOculto(request.getParameter("OBJ_HIDDEN"));
		componente.setQueryUsuario(request.getParameter("OBJ_VALUE"));
		return componente;
	}

	private EstoqueItemVO montarFiltroMovimentoEstoque(
			HttpServletRequest request, ComponenteAjax componente) {
		// TODO: (ID) Refatorar esse lixo. O que é C? O que é 2?
		FiltroWeb filtroNomeOuNomeReduzido = new FiltroWeb();
		filtroNomeOuNomeReduzido.setTipo("C");
		filtroNomeOuNomeReduzido.setTipoIntervalo("2");
		filtroNomeOuNomeReduzido.setValorInicial(componente.getQueryUsuario());

		EstoqueItemVO filtro = new EstoqueItemVO();
		filtro.setIdHoteis(new Long[] { getHotelCorrente(request).getIdHotel() });
		filtro.setFiltroNomeOuNomeReduzido(filtroNomeOuNomeReduzido);

		return filtro;
	}

	private void renderizarItensEstoqueMovimentoEstoque(
			HttpServletResponse response, ComponenteAjax componente)
			throws IOException {
		List<EstoqueItemVO> itensEstoque = (List<EstoqueItemVO>) componente
				.getQueryResultado();
		String listItem = "<li onclick=\"selecionarItemEstoque('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s'); \" >%s</li>";

		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		for (EstoqueItemVO itemEstoque : itensEstoque) {
			sb.append(String.format(listItem, componente.getIdElemento(),
					componente.getIdElementoOculto(),
					itemEstoque.getNomeItem(),
					String.valueOf(itemEstoque.getIdItem()),
					itemEstoque.getNomeUnidadeReduzida(),
					String.valueOf(itemEstoque.getIdFiscalIncidencia()),
					String.valueOf(itemEstoque.getIdCentroCusto()),
					String.valueOf(itemEstoque.getDireto()),
					itemEstoque.getNomeItem()));
		}
		sb.append("</ul>");

		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}

	public void selecionarFornecedor(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando fornecedor", this.log);
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");
		String valor = request.getParameter("OBJ_VALUE");

		FornecedorRedeEJB redeFiltro = new FornecedorRedeEJB();
		redeFiltro.setNomeFantasia(valor.trim().toUpperCase());
		redeFiltro.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());

		FornecedorHotelEJB pFiltro = new FornecedorHotelEJB();
		pFiltro.setIdHotel(hotel.getIdHotel());
		pFiltro.setFornecedorRedeEJB(redeFiltro);

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"$('#%s').val('%s');$('#%s').val('%s');$('div.divLookup').remove();complementoFornecedor('%s')\" >%s</li>";
		builder.append("<ul>");
		try {
			List<FornecedorHotelEJB> lista = FinanceiroDelegate.instance()
					.obterFornecedorLookup(pFiltro);
			for (FornecedorHotelEJB forn : lista) {
				String nome = forn.getFornecedorRedeEJB().getNomeFantasia();
				builder.append(String.format(
						linha,
						new Object[] {
								parObj,
								nome,
								parObjId,
								String.valueOf(forn.getFornecedorRedeEJB()
										.getIdFornecedor()),
								forn.getPrazo().toString(), nome }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void obterLancamentoDefaulContasPagar(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando lancamento padrao CP", this.log);
		String idClassContabil = request
				.getParameter("idClassificacaoContabil");
		StringBuilder builder = new StringBuilder();
		builder.append("killModalPai();");
		try {
			ClassificacaoContabilEJB clas = (ClassificacaoContabilEJB) CheckinDelegate
					.instance().obter(ClassificacaoContabilEJB.class,
							Long.parseLong(idClassContabil));
			builder.append("atualizarDados('"
					+ clas.getCentroCustoDebito().getIdCentroCustoContabil()
					+ "','"
					+ clas.getCentroCustoCredito().getIdCentroCustoContabil()
					+ "','" + clas.getPlanoContasDebito().getIdPlanoContas()
					+ "','" + clas.getPlanoContasCredito().getIdPlanoContas()
					+ "','" + clas.getPlanoContasFin().getIdPlanoContas()
					+ "');");
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void pontoVendaWebExcluirPrato(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String script = "";
		PrintWriter out;
		try {
			String indice = request.getParameter("indice");
			String lote = request.getParameter("lote");
			script = "N".equals(lote) ? "killModal();" : "";
			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Excluindo prato do PDV:" + indice + ".", this.log);
			PontoVendaEJB entidade = (PontoVendaEJB) request.getSession()
					.getAttribute("entidadeSession");
			entidade.getPratoPontoVendaEJBList().remove(
					Integer.parseInt(indice));
		} finally {
			out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		}
	}

	public void usuarioWebExcluirHotel(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String script = "";
		PrintWriter out;
		try {
			String indice = request.getParameter("indice");
			String lote = request.getParameter("lote");
			script = "N".equals(lote) ? "killModal();" : "";
			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Excluindo hotel do Usuário:" + indice + ".", this.log);
			UsuarioConsumoInternoEJB entidade = (UsuarioConsumoInternoEJB) request.getSession()
					.getAttribute("entidadeSession");
			entidade.getHotelEJBList().remove(
					Integer.parseInt(indice));
		} finally {
			out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		}
	}
	
	public void usuarioWebIncluirHotel(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String script = "";
		PrintWriter out;
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			String idHotel = request.getParameter("idHotel");
			String nomeHotel = request.getParameter("nomeHotel");
			String lote = request.getParameter("lote");
			script = "N".equals(lote) ? "killModal();" : "";
			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Incluindo Hotel no Usuario:" + idHotel + ".", this.log);
			UsuarioConsumoInternoEJB entidade = (UsuarioConsumoInternoEJB) request.getSession()
					.getAttribute("entidadeSession");
			UsuarioCiRedeEJB novo = new UsuarioCiRedeEJB();
			novo.setUsuarioConsumoInternoEJB(entidade);
			HotelEJB hotelRecuperado = CustoDelegate.instance().obterHotelPorId(new Long(idHotel));
			novo.setHotel(hotelRecuperado);
			if (MozartUtil.isNull(entidade.getHotelEJBList())) {
				entidade.setHotelEJBList(new ArrayList());
			}
			if (!entidade.getHotelEJBList().contains(novo)) {
				entidade.addHotel(novo);
				script += "podeAdicionar('" + nomeHotel + "');";
			}
		} finally {
			out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		}
	}
	
	public void pontoVendaWebIncluirPrato(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String script = "";
		PrintWriter out;
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			String idPrato = request.getParameter("idPrato");
			String nomePrato = request.getParameter("nomePrato");
			String lote = request.getParameter("lote");
			script = "N".equals(lote) ? "killModal();" : "";
			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Incluindo Prato no PDV:" + idPrato + ".", this.log);
			PontoVendaEJB entidade = (PontoVendaEJB) request.getSession()
					.getAttribute("entidadeSession");
			PratoPontoVendaEJB novo = new PratoPontoVendaEJB();
			novo.setPontoVendaEJB(entidade);
			PratoEJB prato = new PratoEJB();
			PratoEJBPK pratoPk = new PratoEJBPK();
			pratoPk.setIdPrato(new Long(idPrato));
			pratoPk.setIdHotel(hotel.getIdHotel());
			prato.setId(pratoPk);
			novo.setPratoEJB(prato);
			if (MozartUtil.isNull(entidade.getPratoPontoVendaEJBList())) {
				entidade.setPratoPontoVendaEJBList(new ArrayList());
			}
			if (!entidade.getPratoPontoVendaEJBList().contains(novo)) {
				entidade.addPrato(novo);
				script += "podeAdicionar('" + nomePrato + "');";
			}
		} finally {
			out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		}
	}

	public void pontoVendaWebExcluirUsuario(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String script = "";
		PrintWriter out;
		try {
			String indice = request.getParameter("indice");
			String lote = request.getParameter("lote");
			script = "N".equals(lote) ? "killModal();" : "";
			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Excluindo usuário do PDV:" + indice + ".", this.log);
			PontoVendaEJB entidade = (PontoVendaEJB) request.getSession()
					.getAttribute("entidadeSession");
			entidade.getUsuarioPontoVendaEJBList().remove(
					Integer.parseInt(indice));
		} finally {
			out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		}
	}

	public void pontoVendaWebIncluirUsuario(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		String script = "";
		PrintWriter out;
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			String idUsuario = request.getParameter("idUsuario");
			String nomeUsuario = request.getParameter("nomeUsuario");
			String lote = request.getParameter("lote");
			script = "N".equals(lote) ? "killModal();" : "";
			MozartWebUtil.warn(MozartWebUtil.getLogin(request),
					"Incluindo usuário no PDV:" + idUsuario + ".", this.log);
			PontoVendaEJB entidade = (PontoVendaEJB) request.getSession()
					.getAttribute("entidadeSession");
			UsuarioPontoVendaEJB novo = new UsuarioPontoVendaEJB();
			novo.setPontoVendaEJB(entidade);
			novo.setIdHotel(hotel.getIdHotel());
			UsuarioEJB usuario = new UsuarioEJB();
			usuario.setIdUsuario(new Long(idUsuario));
			novo.setUsuarioEJB(usuario);
			novo.setId(new UsuarioPontoVendaEJBPK());
			if (MozartUtil.isNull(entidade.getUsuarioPontoVendaEJBList())) {
				entidade.setUsuarioPontoVendaEJBList(new ArrayList());
			}
			if (!entidade.getUsuarioPontoVendaEJBList().contains(novo)) {
				entidade.addUsuario(novo);
				script +=

				"podeAdicionarUsuario('" + nomeUsuario + "');";
			}
		} finally {
			out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		}
	}

	public void atualizarContasPagarNaSessao(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			String id = request.getParameter("idContasPagar");
			ContasPagarVO filtro = new ContasPagarVO();
			filtro.setIdContasPagar(new Long(id));
			List<ContasPagarVO> listaPesquisa = (List) request.getSession()
					.getAttribute("listaPesquisa");
			filtro = (ContasPagarVO) listaPesquisa.get(listaPesquisa
					.indexOf(filtro));

			ContaCorrenteVO contaCorrente = new ContaCorrenteVO();
			Long idContaCorrente = new Long(
					request.getParameter("contaCorrente"));
			if (idContaCorrente != null) {
				HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
						"HOTEL_SESSION");
				ContaCorrenteVO filtroContaCorrente = new ContaCorrenteVO();
				filtroContaCorrente.setIdContaCorrente(idContaCorrente);
				filtroContaCorrente.setIdHotel(hotel.getIdHotel());
				contaCorrente = ContaCorrenteDelegate.instance()
						.obterContaCorrente(filtroContaCorrente);
			}

			if (contaCorrente != null
					&& contaCorrente.getIdContaCorrente() != null) {
				filtro.setContaCorrente(contaCorrente.getNumContaCorrente());
				filtro.setIdContaCorrente(contaCorrente.getIdContaCorrente());
			} else {
				filtro.setIdContaCorrente(new Long(request
						.getParameter("contaCorrente")));
				filtro.setContaCorrente(new Long(request
						.getParameter("contaCorrente")));
			}
			filtro.setIdFornecedor(new Long(request
					.getParameter("idFornecedor")));
			filtro.setEmpresa(request.getParameter("fornecedor"));
			filtro.setJuros(MozartUtil.toDouble(request.getParameter("juros")));
			filtro.setDesconto(MozartUtil.toDouble(request
					.getParameter("desconto")));
			filtro.setIdPlanoContasDesc(MozartUtil.toLong(request
					.getParameter("idPlanoContas")));
			filtro.setIdCentroCustoDesc(MozartUtil.toLong(request
					.getParameter("idCentroCusto")));
			filtro.setJustificativaDesc(request.getParameter("justificaAjuste"));

			PrintWriter out = response.getWriter();
			out.println("atualizar();");
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("killModal();alerta('Erro ao realizar operação.')");

			out.flush();
			out.close();
		}
	}

	public void obterValorUnitarioItemFichaTecnica(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			String id = request.getParameter("idItem");
			ItemEstoqueVO filtro = new ItemEstoqueVO();
			filtro.setIdHoteis(new Long[] { hotel.getIdHotel() });
			filtro.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());
			List<ItemEstoqueVO> listaPesquisa = CustoDelegate.instance()
					.pesquisarItemEstoqueFichaTecnica(filtro);
			filtro.setIdItem(new Long(id));

			filtro = (ItemEstoqueVO) listaPesquisa.get(listaPesquisa
					.indexOf(filtro));

			PrintWriter out = response.getWriter();
			out.println("atualizar('"
					+ MozartUtil.format(filtro.getVlUnitario()) + "');");
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("killModal();alerta('Erro ao realizar operação.')");

			out.flush();
			out.close();
		}
	}

	public void obterComplementoConta(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			String id = request.getParameter("idPlanoContas");
			String dc = request.getParameter("debitoCredito");
			String idCampoContaCorrente = request
					.getParameter("idCampoContaCorrente");
			PlanoContaEJB pc = (PlanoContaEJB) CheckinDelegate.instance()
					.obter(PlanoContaEJB.class, new Long(id));
			pc.setIdHotel(hotel.getIdHotel());
			ContaCorrenteVO filtro = new ContaCorrenteVO();
			filtro.setIdHoteis(new Long[] { hotel.getIdHotel() });
			if ("D".equals(dc)) {
				filtro.setIdContabilPag(pc.getIdPlanoContas());
			} else {
				filtro.setIdContabilRec(pc.getIdPlanoContas());
			}
			List<ContaCorrenteVO> contaCorrenteList = ControladoriaDelegate
					.instance().pesquisarContaCorrente(filtro);
			String result = "";
			for (ContaCorrenteVO vo : contaCorrenteList) {
				if (pc.getIdPlanoContas().equals(vo.getIdContabilRec())) {
					result = result + vo.toString() + ","
					// TODO: (ID/Conta Corrente)
							+ vo.getIdContaCorrente() + "|";
				}
			}
			if (!MozartUtil.isNull(result)) {
				result = result.substring(0, result.length() - 1);
			}
			String script = "sincronzaContaReturn('"
					+ ("D".equals(dc) ? pc.getHistoricoDebito()
							.getIdHistorico() : pc.getHistoricoCredito()
							.getIdHistorico())
					+ "','"
					+ (result == " , |" ? "" : result)
					+ "'"
					+ ((!MozartUtil.isNull(idCampoContaCorrente) && !idCampoContaCorrente
							.equalsIgnoreCase("null")) ? ", "
							+ idCampoContaCorrente : "") + ");";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("if (killModal) killModal(); if (killModalPai) killModalPai(); alerta('Erro ao realizar operação.');");

			out.flush();
			out.close();
		}
	}
	
	public void obterQuantidadeControleAtivo(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			String id = request.getParameter("idPlanoContas");
			
			long quantidadePlanoConta = ContabilidadeDelegate
					.instance().verificaQuantidadePlanoConta(new Long(id));
			
			String script = "atualizarQuantidadeControleAtivo(" + quantidadePlanoConta + ");";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("if (killModal) killModal(); if (killModalPai) killModalPai(); alerta('Erro ao realizar operação.');");

			out.flush();
			out.close();
		}
	}

	public void obterIdentificaLancamento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			String grupo = request.getParameter("grupo");
			String grupoOuSub = request.getParameter("grupoOuSub");

			IdentificaLancamentoEJB filtro = new IdentificaLancamentoEJB();
			filtro.setAtividade("HOTEL");
			filtro.setGrupoSub(grupoOuSub);
			if ("S".equals(grupoOuSub)) {
				TipoLancamentoVO filtroTipo = new TipoLancamentoVO();
				filtroTipo.setIdHoteis(new Long[] { hotel.getIdHotel() });
				filtroTipo.getFiltroGrupo().setTipo("C");
				filtroTipo.getFiltroGrupo().setTipoIntervalo("3");
				filtroTipo.getFiltroGrupo().setValorInicial(grupo);
				filtroTipo = (TipoLancamentoVO) ControladoriaDelegate
						.instance().pesquisarTipoLancamento(filtroTipo).get(0);

				IdentificaLancamentoEJB identPai = new IdentificaLancamentoEJB();
				identPai.setIdIdentificaLancamento(filtroTipo
						.getIdIdentificaLancamento());
				filtro.setIdentificaLancamentoPaiEJB(identPai);
			}
			List<IdentificaLancamentoEJB> identificaLancamentoList = ControladoriaDelegate
					.instance().obterIdentificaLancamentoEJB(filtro);
			request.getSession().setAttribute("identificaLancamentoList",
					identificaLancamentoList);

			String result = "Selecione, |";
			for (IdentificaLancamentoEJB vo : identificaLancamentoList) {
				result = result + vo.getDescricaoLancamento() + ","
						+ vo.getChave() + "|";
			}
			if (!MozartUtil.isNull(result)) {
				result = result.substring(0, result.length() - 1);
			}
			String script = result;

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("killModal();alerta('Erro ao realizar operação.')");

			out.flush();
			out.close();
		}
	}

	public void obterSubGrupoLancamento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			String grupo = request.getParameter("grupo");
			TipoLancamentoVO pFiltro = new TipoLancamentoVO();
			pFiltro.setIdHoteis(new Long[] { hotel.getIdHotel() });
			pFiltro.setGrupo(grupo);
			pFiltro = ControladoriaDelegate.instance()
					.obterProximoSubGrupoLancamento(pFiltro);
			String script = "setSubGrupo('" + pFiltro.getSubGrupo() + "');";

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("killModal();alerta('Erro ao realizar operação.')");

			out.flush();
			out.close();
		}
	}

	public void obterPlanoContas(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {

		// TODO: (ID) É utilizado em um relatório da tesouraria.
		// Porém parece estar errado. O valorInicial é "Ativo", e a query
		// na RedeSessionBean faz decode de A-Analitico, senão Sintético.
		// Como poderia achar "Ativo"?
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");

			PlanoContaVO filtroPlanoConta = new PlanoContaVO();
			filtroPlanoConta.setIdRedeHotel(hotel.getRedeHotelEJB()
					.getIdRedeHotel());
			filtroPlanoConta.getFiltroTipoConta().setTipo("C");
			filtroPlanoConta.getFiltroTipoConta().setTipoIntervalo("2");
			filtroPlanoConta.getFiltroTipoConta().setValorInicial("Ativo");

			List<PlanoContaVO> planoContaList = RedeDelegate.instance()
					.pesquisarPlanoConta(filtroPlanoConta);
			String result = "Selecione, |";
			for (PlanoContaVO vo : planoContaList) {
				result = result + vo.toString() + "," + vo.getContaContabil()
						+ "|";
			}
			if (!MozartUtil.isNull(result)) {
				result = result.substring(0, result.length() - 1);
			}
			String script = result;

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("killModal();alerta('Erro ao realizar operação.')");

			out.flush();
			out.close();
		}
	}

	public void obterPlanoContasDemonstrativoAnalitico(
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, MozartSessionException {
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		PlanoContaVO filtro = new PlanoContaVO();
		filtro.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());
		filtro.getFiltroTipoConta().setTipo("C");
		filtro.getFiltroTipoConta().setTipoIntervalo("3");
		filtro.getFiltroTipoConta().setValorInicial("A");

		filtro.getFiltroAtivoPassivo().setTipo("C");
		filtro.getFiltroAtivoPassivo().setTipoIntervalo("3");
		filtro.getFiltroAtivoPassivo().setValorInicial("O");

		// TODO: (ID) Lixo de código
		String idElemento = request.getParameter("OBJ_NAME");
		String idElementoOculto = request.getParameter("OBJ_HIDDEN");
		String valorElemento = request.getParameter("OBJ_VALUE");

		filtro.getFiltroAjax().setTipo("C");
		filtro.getFiltroAjax().setTipoIntervalo("2");
		filtro.getFiltroAjax().setValorInicial(
				valorElemento.trim().toUpperCase());

		// TODO: (ID) Extrair método de response. Single Responsibility
		// O onclick poderia ter uma função javascript ao invés de executar
		// diretamente.
		String linha = "<li onclick=\"$('#%s').val('%s'); $('#%s').val('%s'); $('div.divLookup').remove(); \" >%s</li>";
		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		try {
			List<PlanoContaVO> lista = RedeDelegate.instance()
					.obterPlanoContasDemonstrativoAnalitico(filtro);
			for (PlanoContaVO planoConta : lista) {
				StringBuilder conta = new StringBuilder(
						planoConta.getContaContabil()).append(" - ")
						.append(planoConta.getContaReduzida()).append(" - ")
						.append(planoConta.getNomeConta());

				sb.append(String.format(
						linha,
						new Object[] { idElemento, conta.toString(),
								idElementoOculto,
								String.valueOf(planoConta.getIdPlanoContas()),
								conta.toString() }));
			}
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
		sb.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}

	public void executarProcedureBalanceteRede(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			String dataInicial = request.getParameter("dataInicial");
			String cnpj = request.getParameter("cnpj");
			String idHotel = request.getParameter("idHoteis");

			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			ContabilidadeDelegate.instance().executarProcedureBalanceteRede(
					idHotel, hotel.getRedeHotelEJB().getIdRedeHotel(),
					MozartUtil.toTimestamp(dataInicial), cnpj);

			String result = "killModal();imprimirBalanceteRede();";
			String script = result;

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("killModal();alerta('Erro ao realizar operação.')");

			out.flush();
			out.close();
		}
	}

	public void executarProcedureTotLote(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
			String dataInicial = request.getParameter("dataInicial");
			String idHotel = request.getParameter("idHoteis");
			String cnpj = request.getParameter("cnpj");

			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
			ContabilidadeDelegate.instance().executarProcedureTotLote(idHotel,
					hotel.getIdHotel(), hotel.getRedeHotelEJB(),
					MozartUtil.toTimestamp(dataInicial), cnpj);

			String result = "killModal();imprimirTotLote();";
			String script = result;

			PrintWriter out = response.getWriter();
			out.println(script);
			out.flush();
			out.close();
		} catch (Exception ex) {
			PrintWriter out = response.getWriter();
			out.println("killModal();alerta('Erro ao realizar operação.')");

			out.flush();
			out.close();
		}
	}

	public void selecionarClassificacaoContabilDebito(
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando classificação contábil débito", this.log);
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		String elementName = request.getParameter("OBJ_NAME");
		String elementValue = request.getParameter("OBJ_VALUE");
		String elementGroup = request.getParameter("OBJ_GROUP");
		String sincConta = request.getParameter("SINC_CONTA");
		String idElementConta = request.getParameter("OBJ_CONTA_ID");
		String ativoPassivo = request.getParameter("OBJ_ATIVO_PASSIVO_VALUE");

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"setarValorJS('%s','%s');$('div.divLookup').remove();";
		linha = linha + "setarValorJS('" + elementGroup
				+ ".idPlanoContas','%s');";
		linha = linha + "setarValorJS('" + elementGroup
				+ ".idHistoricoDebitoCredito','%s');";
		if (sincConta != null && sincConta.equalsIgnoreCase("true")) {
			linha = linha + "sincronzaConta('" + elementGroup
					+ ".idPlanoContas', '" + idElementConta + "');";
		}
		linha = linha + "\">%s</li>";
		builder.append("<ul>");

		try {
			List<ClassificacaoContabilFaturamentoVO> lista = ContabilidadeDelegate
					.instance().obterComboDebito(hotel.getRedeHotelEJB(),
							elementValue, ativoPassivo);
			for (ClassificacaoContabilFaturamentoVO debito : lista) {
				builder.append(String.format(
						linha,
						new Object[] {
								elementName,
								debito.getContaContabil(),
								String.valueOf(debito.getIdPlanoContas()),
								String.valueOf(debito
										.getIdHistoricoDebitoCredito()),
								debito.getContaContabil() }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void selecionarClassificacaoContabilCredito(
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando classificação contábil credito", this.log);
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		String elementName = request.getParameter("OBJ_NAME");
		String elementValue = request.getParameter("OBJ_VALUE");
		String elementGroup = request.getParameter("OBJ_GROUP");
		String sincConta = request.getParameter("SINC_CONTA");
		String idElementConta = request.getParameter("OBJ_CONTA_ID");

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"setarValorJS('%s','%s');$('div.divLookup').remove();";
		linha = linha + "setarValorJS('" + elementGroup
				+ ".idPlanoContas','%s');";
		linha = linha + "setarValorJS('" + elementGroup
				+ ".idHistoricoDebitoCredito','%s');";
		if (sincConta != null && sincConta.equalsIgnoreCase("true")) {
			linha = linha + "sincronzaConta('" + elementGroup
					+ ".idPlanoContas','" + idElementConta + "');";
		}
		linha = linha + "\">%s</li>";
		builder.append("<ul>");

		try {
			List<ClassificacaoContabilFaturamentoVO> lista = ContabilidadeDelegate
					.instance().obterComboCredito(hotel.getRedeHotelEJB(),
							elementValue);
			for (ClassificacaoContabilFaturamentoVO credito : lista) {
				builder.append(String.format(
						linha,
						new Object[] {
								elementName,
								credito.getContaContabil(),
								String.valueOf(credito.getIdPlanoContas()),
								String.valueOf(credito
										.getIdHistoricoDebitoCredito()),
								credito.getContaContabil() }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void selecionarItem(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando Item", this.log);

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		String elementName = request.getParameter("OBJ_NAME");
		String elementValue = request.getParameter("OBJ_VALUE");
		String elementGroup = request.getParameter("OBJ_GROUP");

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"setarValorJS('%s','%s');$('div.divLookup').remove();";
		linha = linha + "setarValorJS('" + elementGroup
				+ ".idItem','%s');validarItens();";

		linha = linha + "\">%s</li>";
		builder.append("<ul>");

		ItemRedeEJB filtro = new ItemRedeEJB();

		filtro.setId(new ItemRedeEJBPK());

		filtro.getId().setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());

		try {
			List<ItemRedeEJB> lista = ComprasDelegate
					.instance()
					.pesquisarItemRedeLikeNome(filtro, "%" + elementValue + "%");

			if (lista != null && !lista.isEmpty()) {

				for (ItemRedeEJB itemRede : lista) {
					builder.append(String.format(
							linha,
							new Object[] {
									elementName,
									itemRede.getNomeItem(),
									String.valueOf(itemRede.getId().getIdItem()),
									itemRede.getNomeItem() }));
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void selecionarTipoItem(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando Tipo Item", this.log);

		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		String elementName = request.getParameter("OBJ_NAME");
		String elementValue = request.getParameter("OBJ_VALUE");
		String elementGroup = request.getParameter("OBJ_GROUP");

		StringBuilder builder = new StringBuilder();
		String linha = "<li onclick=\"setarValorJS('%s','%s');$('div.divLookup').remove();";
		linha = linha + "setarValorJS('" + elementGroup + ".idTipoItem','%s');";

		linha = linha + "\">%s</li>";
		builder.append("<ul>");

		TipoItemEJB filtro = new TipoItemEJB();

		filtro.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());

		try {

			List<TipoItemEJB> lista = ComprasDelegate
					.instance()
					.pesquisarTipoItemLikeNome(filtro, "%" + elementValue + "%");
			if (lista != null && !lista.isEmpty()) {

				for (TipoItemEJB tipoItem : lista) {
					builder.append(String.format(linha,
							new Object[] { elementName, tipoItem.getNomeTipo(),
									String.valueOf(tipoItem.getIdTipoItem()),
									tipoItem.getNomeTipo() }));
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void selecionarBloqueioGestaoEmpresa(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando empresa bloqueio", this.log);
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");
		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_HIDDEN");
		String parObjIdBloqueio = request.getParameter("OBJ_HIDDEN_ID");
		String valor = request.getParameter("OBJ_VALUE");

		EmpresaHotelEJB pFiltro = new EmpresaHotelEJB();
		pFiltro.setNomeFantasia(valor.toUpperCase());
		pFiltro.setIdHotel(hotel.getIdHotel());

		StringBuilder builder = new StringBuilder();
		String linha = " <li onclick=\" loading(); "
				+ " setarValorJS('%s','%s'); " + " setarValorJS('%s','%s'); "
				+ " setarValorJS('%s','%s'); "
				+ " setValorPeriodo('%s','%s'); "
				+ " $('div.divLookup').remove(); " + " carregarGestao();\" ";
		linha = linha + " style=''>%s</li>";
		builder.append("<ul>");
		try {
			ControlaDataEJB cd = (ControlaDataEJB) request.getSession()
					.getAttribute("CONTROLA_DATA_SESSION");

			List<BloqueioGestaoVO> listaRes = ReservaDelegate.instance()
					.obterBloqueioGestaoEmpresa(pFiltro, cd.getFrontOffice());
			for (BloqueioGestaoVO empresa : listaRes) {
				String nome = empresa.getDescricaoCompleta();

				builder.append(String.format(
						linha,
						new Object[] {
								parObj,
								nome,
								parObjId,
								String.valueOf(empresa.getBcIdEmpresa()),
								parObjIdBloqueio,
								empresa.getBcIdReserva(),
								MozartUtil.format(empresa.getBcDataEntrada(),
										"dd/MM/yyyy"),
								MozartUtil.format(empresa.getBcDataSaida(),
										"dd/MM/yyyy"), nome }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void selecionarBanco(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando Banco", this.log);
		String parObj = request.getParameter("OBJ_NAME");
		String parObjId = request.getParameter("OBJ_GROUP");
		String valor = request.getParameter("OBJ_VALUE");

		BancoVO banco = new BancoVO();
		banco.getFiltroBanco().setTipo("C");
		banco.getFiltroBanco().setTipoIntervalo("2");
		banco.getFiltroBanco().setValorInicial(valor);

		StringBuilder builder = new StringBuilder();
		String linha = " <li onclick=\" " + " setarValorJS('%s','%s'); "
				+ " setarValorJS('%s','%s'); "
				+ " $('div.divLookup').remove(); ";
		linha = linha + "\" style=''>%s</li>";
		builder.append("<ul>");
		try {
			List<BancoVO> listaBanco = SistemaDelegate.instance()
					.pesquisarBancoComboAutoComplete(banco);

			for (BancoVO bancoAux : listaBanco) {
				String nome = bancoAux.getBanco();

				builder.append(String.format(linha, new Object[] { parObj,
						nome, parObjId, String.valueOf(bancoAux.getIdBanco()),
						nome }));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}
		builder.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}

	public void downloadXmlNotaFiscal(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request), "Download a file",
				this.log);

		String parObj = request.getParameter("OBJ_NAME");
		String rpsSelecionadasString = request.getParameter("OBJ_VALUE");
		byte[] bytes = null;
		try {
			List<String> idsRpsLote = new ArrayList<String>();

			for (String idRps : rpsSelecionadasString.split(",")) {
				idsRpsLote.add(idRps);
			}
			log.info(idsRpsLote);

			String xml = FinanceiroDelegate.instance().gerarXmlNotaFiscalLote(
					idsRpsLote,
					getHotelCorrente(request).getCgc(),
					getHotelCorrente(request).getInscMunicipal(),
					String.valueOf(idsRpsLote.size()),
					String.valueOf(getHotelCorrente(request).getCidadeEJB()
							.getIdCidade()));
			MozartHotelNotaFiscal mozartHotelNotaFiscal = new MozartHotelNotaFiscal();
			bytes = mozartHotelNotaFiscal.downloadXmlArquivoLote(request,
					response, parObj, xml);

		} catch (Exception ex) {
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					ex.getMessage(), this.log);
		}

		PrintWriter out = response.getWriter();
		out.println(bytes);
		out.close();
	}

	public void obterDadosUsuarioConsumoInternoMovimentacao(HttpServletRequest request,
			HttpServletResponse response) throws IOException {

		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando Usuario", this.log);
		
		long idUsuario = 0L;
		String idUsuarioStr = request.getParameter("OBJ_USUARIO_VALUE");
		if (!MozartUtil.isNull(idUsuarioStr)) {
			idUsuario = Long.parseLong(idUsuarioStr);
		}
		
		long idPontoVenda = 0L;
		String idPontoVendaStr = request.getParameter("OBJ_PV_VALUE");
		if (!MozartUtil.isNull(idPontoVendaStr)) {
			idPontoVenda = Long.parseLong(idPontoVendaStr);
		}

		StringBuilder builder = new StringBuilder();
		try {
			ConsumoInternoVO consumoInterno = CustoDelegate.instance().pesquisarUsuarioConsumoInternoPorId(getHotelCorrente(request), idUsuario, idPontoVenda);
			if(consumoInterno != null){
				builder.append(consumoInterno.getIdPontoVenda() + ";"
						+ new SimpleDateFormat("dd/MM/yyyy").format(consumoInterno.getDataPontoVenda()) + ";"
						+ consumoInterno.getPensao() + ";"
						+ consumoInterno.getTipoPensao());
			}
			else
			{
				builder.append("");
			}

		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}

		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	
	}
	
	public void obterPratoPorUsuarioConsumoInterno(HttpServletRequest request,
			HttpServletResponse response) {

		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando ItemEstoque", this.log);
		
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		ComponenteAjax componente = getComponenteAjax(request);
		PratoConsumoInternoVO filtro = new PratoConsumoInternoVO();
		
		filtro.setIdHotel(hotel.getIdHotel());
		
		String idPontoVendaDesc = request.getParameter("OBJ_PONTO_VENDA");
		if (!MozartUtil.isNull(idPontoVendaDesc)) {
			filtro.setIdPontoVenda(Long.parseLong(idPontoVendaDesc));
		}
		
		String idUsuarioDesc = request.getParameter("OBJ_USUARIO_CONSUMO");
		if (!MozartUtil.isNull(idUsuarioDesc)) {
			filtro.setIdUsuarioConsumoInterno(Long.parseLong(idUsuarioDesc));
		}
		
		FiltroWeb filtroNomePrato = new FiltroWeb();
		filtroNomePrato.setTipo("C");
		filtroNomePrato.setTipoIntervalo("2");
		filtroNomePrato.setValorInicial(componente.getQueryUsuario());
		
		filtro.setFiltroNomePrato(filtroNomePrato);

		try {
			componente.setQueryResultado(CustoDelegate.instance().pesquisarPratoUsuarioConsumoInterno(filtro));
			renderizarPratoPorUsuarioConsumoInterno(response, componente);
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
	}
	
	private void renderizarPratoPorUsuarioConsumoInterno(
			HttpServletResponse response, ComponenteAjax componente)
			throws IOException {
		List<PratoConsumoInternoVO> listPratoConsumo = (List<PratoConsumoInternoVO>) componente
				.getQueryResultado();
		String listItem = "<li onclick=\"selecionarPratoConsumoInterno('%s', '%s', '%s', '%s', '%s'); \" >%s</li>";

		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		for (PratoConsumoInternoVO pratoConsumo : listPratoConsumo) {
			sb.append(String.format(listItem, componente.getIdElemento(),
					componente.getIdElementoOculto(),
					pratoConsumo.getNomePrato(),
					String.valueOf(pratoConsumo.getIdPrato()),
					pratoConsumo.getUnidade(),
					pratoConsumo.getNomePrato()));
		}
		sb.append("</ul>");

		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}
	
	public void obterCustoVendaConsumoMovimentacao(
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando ItemEstoque", this.log);

		PratoConsumoInternoVO filtro = new PratoConsumoInternoVO();
		filtro.setIdPrato(new Long(request.getParameter("idItem")));
		filtro.setIdHotel(getHotelCorrente(request).getIdHotel());
		StringBuilder builder = new StringBuilder();
		try {
			PratoConsumoInternoVO pratoConsumo = CustoDelegate.instance()
					.pesquisarPratoValorConsumoInterno(filtro);

			if (pratoConsumo != null) {
				builder.append(pratoConsumo.getCusto() + ";");
				builder.append(pratoConsumo.getVenda());
			} else {
				builder.append("0;0");
			}

		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}

		PrintWriter out = response.getWriter();
		out.println(builder.toString());
		out.close();
	}
	
	public void obterItensPatrimonioSetor(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO: (ID) Cross-cutting concerns misturados ao código. tsc tsc tsc
		// (Implementar Aspect)
		MozartWebUtil.info(MozartWebUtil.getLogin(request),
				"Selecionando Patrimonio Setor", this.log);

		ComponenteAjax componente = getComponenteAjax(request);
		
		FiltroWeb filtroNomeOuNomeReduzido = new FiltroWeb();
		filtroNomeOuNomeReduzido.setTipo("C");
		filtroNomeOuNomeReduzido.setTipoIntervalo("2");
		filtroNomeOuNomeReduzido.setValorInicial(componente.getQueryUsuario());

		PatrimonioSetorVO filtro = new PatrimonioSetorVO();
		filtro.setIdHoteis(new Long[] { getHotelCorrente(request).getIdHotel() });
		filtro.setFiltroNomeOuNomeReduzido(filtroNomeOuNomeReduzido);

		try {
			componente.setQueryResultado(obterPatrimonioSetor(filtro));
			renderizarItensPatrimonioSetor(response, componente);
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
	}
	
	private void renderizarItensPatrimonioSetor(
			HttpServletResponse response, ComponenteAjax componente)
			throws IOException {
		List<PatrimonioSetorVO> itensEstoque = (List<PatrimonioSetorVO>) componente
				.getQueryResultado();
		String listItem = "<li onclick=\"selecionarPatrimonioSetor('%s', '%s', '%s', '%s'); \" >%s</li>";

		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		for (PatrimonioSetorVO itemEstoque : itensEstoque) {
			sb.append(String.format(listItem, componente.getIdElemento(),
					componente.getIdElementoOculto(),
					itemEstoque.getDescricao(),
					String.valueOf(itemEstoque.getIdPatrimonioSetor()),
					itemEstoque.getDescricao()));
		}
		sb.append("</ul>");

		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}

	private List<PatrimonioSetorVO> obterPatrimonioSetor(PatrimonioSetorVO filtro)
			throws MozartSessionException {
		List<PatrimonioSetorVO> resultado = RedeDelegate.instance()
				.pesquisarListaSetorPatrimonio(filtro);
		return resultado;
	}
	
	public void obterPlanoContasDepreciacao(
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, MozartSessionException {
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		PlanoContaVO filtro = new PlanoContaVO();
		filtro.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());

		String idElemento = request.getParameter("OBJ_NAME");
		String idElementoOculto = request.getParameter("OBJ_HIDDEN");
		String valorElemento = request.getParameter("OBJ_VALUE");

		filtro.getFiltroAjax().setTipo("C");
		filtro.getFiltroAjax().setTipoIntervalo("2");
		filtro.getFiltroAjax().setValorInicial(
				valorElemento.trim().toUpperCase());

		String linha = "<li onclick=\"$('#%s').val('%s'); $('#%s').val('%s'); $('div.divLookup').remove(); \" >%s</li>";
		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		try {
			List<PlanoContaVO> lista = ContabilidadeDelegate.instance().obterComboPlanoConta(filtro);
			for (PlanoContaVO planoConta : lista) {
				StringBuilder conta = new StringBuilder(
						planoConta.getContaContabil()).append(" - ")
						.append(planoConta.getContaReduzida()).append(" - ")
						.append(planoConta.getNomeConta());

				sb.append(String.format(
						linha,
						new Object[] { idElemento, conta.toString(),
								idElementoOculto,
								String.valueOf(planoConta.getIdPlanoContas()),
								conta.toString() }));
			}
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
		sb.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}
	
	public void obterUsuarios(
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, MozartSessionException {
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		UsuarioVO filtro = new UsuarioVO();
		filtro.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());
		filtro.setIdHotel(hotel.getIdHotel());
		
		String idElemento = request.getParameter("OBJ_NAME");
		String idElementoOculto = request.getParameter("OBJ_HIDDEN");
		String valorElemento = request.getParameter("OBJ_VALUE");

		filtro.getFiltroAjax().setTipo("C");
		filtro.getFiltroAjax().setTipoIntervalo("2");
		filtro.getFiltroAjax().setValorInicial(
				valorElemento.trim().toUpperCase());

		String linha = "<li onclick=\"$('#%s').val('%s'); $('#%s').val('%s'); $('div.divLookup').remove(); \" >%s</li>";
		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		try {
			List<UsuarioVO> lista = SistemaDelegate.instance().obterComboUsuarios(filtro);
			for (UsuarioVO usuario : lista) {
				StringBuilder conta = new StringBuilder(usuario.getNomeUsuario());

				sb.append(String.format(
						linha,
						new Object[] { idElemento, conta.toString(),
								idElementoOculto,
								String.valueOf(usuario.getIdUsuario()),
								conta.toString() }));
			}
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
		sb.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}

	public void obterPlanoContasRelRazao(
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, MozartSessionException {
		HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
				"HOTEL_SESSION");

		PlanoContaVO filtro = new PlanoContaVO();
		filtro.setIdRedeHotel(hotel.getRedeHotelEJB().getIdRedeHotel());

		String idElemento = request.getParameter("OBJ_NAME");
		String idElementoOculto = request.getParameter("OBJ_HIDDEN");
		String valorElemento = request.getParameter("OBJ_VALUE");

		filtro.getFiltroAjax().setTipo("C");
		filtro.getFiltroAjax().setTipoIntervalo("2");
		filtro.getFiltroAjax().setValorInicial(
				valorElemento.trim().toUpperCase());

		String linha = "<li onclick=\"$('#%s').val('%s'); $('#%s').val('%s'); $('div.divLookup').remove(); \" >%s</li>";
		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		try {
			List<PlanoContaVO> lista = RedeDelegate.instance().pesquisarPlanoContaSugest(filtro);
			for (PlanoContaVO planoConta : lista) {
				StringBuilder conta = new StringBuilder(
						planoConta.getContaContabil()).append(" - ")
						.append(planoConta.getNomeConta());

				sb.append(String.format(
						linha,
						new Object[] { idElemento, conta.toString(),
								idElementoOculto,
								String.valueOf(planoConta.getContaContabil()),
								conta.toString() }));
			}
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
		sb.append("</ul>");
		PrintWriter out = response.getWriter();
		out.println(sb.toString());
		out.close();
	}
	
	public void gerarToken(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		
		
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
		
			String valor = request.getParameter("OBJ_VALUE");
			
			PrintWriter out = response.getWriter();
			if(valor.trim().equals("")) {
				out.write("");
			} else {
				out.write(Criptografia.instance().crypto(valor));
			}
			
			out.close();
			/*
			if (!MozartUtil.isNull(this.entidade.getUsuario().getSenha())) { 

				this.entidade.setToken(Criptografia.instance().crypto(this.entidade.getUsuario().getSenha()));  
	            
			}
			*/
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}

				
	}

	public void selecionarComboReceita(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		
		
		try {
			//HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					//"HOTEL_SESSION");
		
			String valor = request.getParameter("OBJ_VALUE");
					
			
			PrintWriter out = response.getWriter();
			StringBuilder builder = new StringBuilder();
			
			this.montarComboReceita(builder, (List<TipoLancamentoVO>) request.getSession().getAttribute("listaReceita"),Long.parseLong(valor));
			
			 out.println(builder.toString());
		
			
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
	}
	
	public void selecionarComboRecebimento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try {
		
			String valor = request.getParameter("OBJ_VALUE");
					
			
			PrintWriter out = response.getWriter();
			StringBuilder builder = new StringBuilder();
			
			Long id = (long) 0;
			
			if(valor != null && !valor.equals("null")) {
				id = Long.parseLong(valor);
			}
			
			this.montaComboRecebimento(builder, (List<TipoLancamentoVO>) request.getSession().getAttribute("listaRecebimento"),id);
			
			 out.println(builder.toString());
		
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
	}	
	
	public void getTipoLancamentoReceitaERecebimento(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		
		
		try {
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
		
			String valor = request.getParameter("OBJ_VALUE");
			
			HotelVO filtro = new HotelVO();
			filtro.setIdHotel(Long.parseLong(valor));
			
			//request.getSession().setAttribute("listaRecebimento", TipoLancamentolDelegate.instance().consultarTipoLancamentoRecebimento(filtro)); 
			
			
			List <TipoLancamentoVO> listaRecebimento = TipoLancamentolDelegate.instance().consultarTipoLancamentoRecebimento(filtro);
			request.getSession().setAttribute("listaRecebimento", listaRecebimento);
			
			List <TipoLancamentoVO> listaReceita = TipoLancamentolDelegate.instance().consultarTipoLancamentoReceita(filtro);
			request.getSession().setAttribute("listaReceita", listaReceita);

			
			PrintWriter out = response.getWriter();
			StringBuilder builder = new StringBuilder();
			
			builder.append("<div id=\"idDivLancamentoReceitaRecebimento\" style=\"height:200px;\">");
			
			
			this.montarComboReceita(builder,listaReceita, (long) -1);
			
			
			
				this.montaComboRecebimento(builder,listaRecebimento, (long) -1);
				
			
			
			builder.append("</div>");	
            out.println(builder.toString());
            
            
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}

				
	}
	
	private void montaComboRecebimento(StringBuilder builder, List<TipoLancamentoVO> listaRecebimento,Long idTipoLancamentoRecebimento) {
		
		String selected = " ";
		if(idTipoLancamentoRecebimento == null) {
			idTipoLancamentoRecebimento = (long) 0;
		}
		builder.append("<div class=\"divLinhaCadastro\">");			
		builder.append("	 <div class=\"divItemGrupo\" style=\"width:600px;\" >");  
		builder.append("			<p style=\"width:150px;\">Tipo Lançamento recebimento </p>" );
		builder.append("			<select name=\"apiContrato.idTipoLancamentoCk\" id=\"idSelectRecebimento\" onchange=\"selecionarComboRecebimento(this);loading()\" style=\"width:350px\">");
		builder.append("	   			<option value=\"-1\" >Selecione</option>");
		for(TipoLancamentoVO voRecebimento : listaRecebimento) {
			Long idTipoRecebimento = voRecebimento.getIdTipoLancamento() == null ? 0 : voRecebimento.getIdTipoLancamento() ;
			
			String idTipoRecebimentoFormatado = "\"" + idTipoRecebimento.toString() +"\"";
			
			Long idTipoLancamentoRecebimentoVO = voRecebimento.getIdTipoLancamento() == null ? 0 : voRecebimento.getIdTipoLancamento();
			if(idTipoLancamentoRecebimento != null && idTipoLancamentoRecebimento.equals(idTipoLancamentoRecebimentoVO)) {
				selected = " selected=\"selected\"";
			} else {
				selected = " ";
			}
			
			builder.append("			<option value="+ idTipoRecebimentoFormatado + " " +selected +">"+voRecebimento.getDescricaoLancamento()+"</option>");
		}
		builder.append("			</select>");
		builder.append("	</div>");
		builder.append("</div>");  
		
	}

	private void montarComboReceita(StringBuilder builder,List <TipoLancamentoVO> listaReceita,Long idTipoLancamentoReceita) {
		
		String selected = " ";
		
		builder.append("<div id=\"idDivSelectReceita\" class=\"divLinhaCadastro\"> ");
		builder.append("	<div class=\"divItemGrupo\" style=\"width:600px;\" > ");
		builder.append("		<p style=\"width:150px;\">Tipo Lançamento receita </p>" );
		
		builder.append("		<select name=\"apiContrato.idTipoLancamento\" onchange=\"selecionarComboReceita(this);loading()\" id=\"idSelectReceita\" style=\"width:350px\">");
		builder.append("			<option value=\"-1\" >Selecione</option>");
		for(TipoLancamentoVO voReceita : listaReceita) {
			String idTipoLancamento = "\"" + voReceita.getIdTipoLancamento() + "\"";
			if(idTipoLancamentoReceita != null && idTipoLancamentoReceita.equals(voReceita.getIdTipoLancamento())) {
				selected = " selected=\"selected\"";
			} else {
				selected = " ";
			}
			builder.append("		<option value="+idTipoLancamento + " " +selected +">"+ voReceita.getDescricaoLancamento() +"</option>");
		}
		builder.append("		</select>");
		builder.append("   </div>");
		builder.append("</div>");	
		
	}

	public void consultarEmpresaPorRazaoSocialLike(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			MozartSessionException {
		try { 
			HotelEJB hotel = (HotelEJB) request.getSession().getAttribute(
					"HOTEL_SESSION");
		
			PrintWriter out = response.getWriter();
			
			//parametro do autocomplete do jquery (padrão da arquitetura)
			String nomeEmpresaOuCnpj = request.getParameter("q");

			//ObjectMapper mapper = new ObjectMapper();
			
			if(nomeEmpresaOuCnpj != null && !nomeEmpresaOuCnpj.equals("") && nomeEmpresaOuCnpj.toCharArray().length > 3) {

				EmpresaEJB filtro = new EmpresaEJB();
				filtro.setRazaoSocial(nomeEmpresaOuCnpj);

				List <EmpresaEJB> lista = EmpresaDelegate.instance().consultarEmpresaPorRazaoSocialLike(filtro);

				//List <String> listaJson = new ArrayList<String>();
				
				for(EmpresaEJB ejb : lista) {
					
					/*
					ObjectNode objectNode1 = mapper.createObjectNode();
			        objectNode1.put("idEmpresa", ejb.getIdEmpresa());
			        objectNode1.put("razaoSocialCGC", ejb.getRazaoSocialCGC());
					 */
					out.println(ejb.getRazaoSocialCGC());
			        //out.println(objectNode1);
				}

			}
			
		} catch (Exception e) {
			e.printStackTrace();
			MozartWebUtil.error(MozartWebUtil.getLogin(request),
					e.getMessage(), this.log);
		}
	}
	
	// public void selecionarListaFiscalServico(HttpServletRequest request,
	// HttpServletResponse response) throws ServletException, IOException {
	// MozartWebUtil.info(MozartWebUtil.getLogin(request),
	// "Selecionando Lista Fiscal Servico", this.log);
	//
	// String parObj = request.getParameter("OBJ_NAME");
	// String parObjId = request.getParameter("OBJ_HIDDEN");
	// String valor = request.getParameter("OBJ_VALUE");
	//
	// ListaFiscalServicoVO listaFiltro = new ListaFiscalServicoVO();
	// listaFiltro.setDescricao(valor.trim().toUpperCase());
	//
	// StringBuilder builder = new StringBuilder();
	// String linha =
	// "<li onclick=\"$('#%s').val('%s');$('#%s').val('%s');$('div.divLookup').remove();\" >%s</li>";
	// builder.append("<ul>");
	// try {
	// List<ListaFiscalServicoVO> lista = SistemaDelegate.instance()
	// .pesquisarListaServicoFiscal(listaFiltro);
	// for (ListaFiscalServicoVO forn : lista) {
	// String nome = forn.getDescricao();
	// builder.append(String.format(
	// linha,
	// new Object[] {
	// parObj,
	// nome,
	// parObjId,
	// String.valueOf(forn.getId()), nome }));
	// }
	// } catch (Exception ex) {
	// ex.printStackTrace();
	// MozartWebUtil.error(MozartWebUtil.getLogin(request),
	// ex.getMessage(), this.log);
	// }
	// builder.append("</ul>");
	// PrintWriter out = response.getWriter();
	// out.println(builder.toString());
	// out.close();
	// }

}