package com.mozart.web.actions;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.xml.bind.DatatypeConverter;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.CrsDelegate;
import com.mozart.model.delegate.PdvDelegate;
import com.mozart.model.delegate.SistemaDelegate;
import com.mozart.model.delegate.UsuarioDelegate;
import com.mozart.model.ejb.entity.ApartamentoEJB;
import com.mozart.model.ejb.entity.CentralReservaEJB;
import com.mozart.model.ejb.entity.CentralReservasHotelEJB;
import com.mozart.model.ejb.entity.CheckinEJB;
import com.mozart.model.ejb.entity.ConfigWebEJB;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.MensagemWebUsuarioEJB;
import com.mozart.model.ejb.entity.MenuMozartWebUsuarioEJB;
import com.mozart.model.ejb.entity.PartnerDominioEJB;
import com.mozart.model.ejb.entity.UsuarioEJB;
import com.mozart.model.ejb.entity.UsuarioSessionEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.Criptografia;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.aws.AwsFileUtilities;
import com.mozart.web.util.MozartComboWeb;
import com.mozart.web.util.MozartConstantesWeb;

import org.apache.commons.codec.binary.Base64;

@SuppressWarnings("unchecked")
public class LoginAction extends BaseAction {
	private static final long serialVersionUID = -911199371973873824L;
	private String login;
	private String senha;
	private String imgBase;
	private String cssColor;
	public static Thread alfaAscy = null;

	public String logout() {
		try {
			prepararLogin();
			CheckinEJB checkinCorrente = (CheckinEJB) this.request.getSession()
					.getAttribute("checkinCorrente");
			this.request.getSession().removeAttribute("checkinCorrente");
			if ((!isNull(checkinCorrente).booleanValue())
					&& (!isNull(checkinCorrente.getApartamentoEJB())
							.booleanValue())
					&& ("S".equals(checkinCorrente.getApartamentoEJB()
							.getCheckout()))) {
				ApartamentoEJB apto = (ApartamentoEJB) CheckinDelegate
						.instance().obter(
								ApartamentoEJB.class,
								checkinCorrente.getApartamentoEJB()
										.getIdApartamento());
				apto.setCheckout("N");
				apto.setUsuario(getUserSession().getUsuarioEJB());
				apto = (ApartamentoEJB) CheckinDelegate.instance()
						.alterar(apto);
				checkinCorrente.setApartamentoEJB(apto);
			}
			String BROWSER_TYPE = (String) this.request.getSession()
					.getAttribute("BROWSER_TYPE");
			String URL_BASE = (String) this.request.getSession().getAttribute(
					"URL_BASE");
			String FORA_HORA = (String) this.request.getSession().getAttribute(
					"FORA_HORA");

			String id = this.request.getSession().getId();
			this.request.getSession().invalidate();
			info("Sessão finalizada com sucesso: " + id);
			this.request.getSession(true);
			this.request.getSession()
					.setAttribute("BROWSER_TYPE", BROWSER_TYPE);
			this.request.getSession().setAttribute("URL_BASE", URL_BASE);
			this.request.getSession().setAttribute("FORA_HORA", FORA_HORA);
		} catch (MozartSessionException e) {
			error("Erro ao fechar sessão ");
			error("Erro: " + e.getMessage());
		}
		return "logout";
	}

	public String expired() {
		prepararLogin();
		this.request.setAttribute("ident", "true");

		return "sessionExpired";
	}

	public String validar() {
		return "sucesso";
	}
	
	public String prepararLogin(){
		try {
			String url = request.getServerName();
			
			if(url.contains("localhost")){
				url = "dev1.mozart.com.br";
			}
			
			PartnerDominioEJB partner = PdvDelegate.instance().getDesignHotel(url);
			
			if(partner != null){
				cssColor = partner.getColor();
				String logoStr = new String(Base64.encodeBase64(partner.getLogotipo()));
				imgBase = logoStr;
			}
			else{
				return "naoAutorizado";
			}
		} 
		catch (Exception e) 
		{
			return "prepara";
		}
		
		return "prepara";
	}

	public String logar() {
		info("Logando no sistema");
		try {
			prepararLogin();
			ConfigWebEJB config = UsuarioDelegate.instance()
					.obterConfiguracaoWeb();
			UsuarioEJB usuario = new UsuarioEJB();
			usuario.setNick(this.login);
			usuario.setSenha(Criptografia.instance().crypto(this.senha));
			usuario = UsuarioDelegate.instance().autenticar(usuario);
			if (isNull(usuario).booleanValue()) {
				addMensagemErro("Usuário inválido, tente novamente.");
				return "prepara";
			}
			if (!"S".equalsIgnoreCase(usuario.getAtivo())) {
				addMensagemSucesso("Usuário está inativo, entre em contato com o administrador.");
				return "prepara";
			}
			if (usuario.getDataValidade().before(
					new Timestamp(new Date().getTime()))) {
				addMensagemSucesso("Usuário está expirado, entre em contato com o administrador.");
				return "prepara";
			}
			
			if (("S".equals(config.getBloquearAcesso()))
					&& (!"MANUTENCAO".equals(this.login))) {
				addMensagemSucesso("Estamos atualizando o sistema, tente novamente em alguns instantes.");
				return "prepara";
			}
			if (!MozartUtil.isTurnoValido(usuario)) {
				addMensagemSucesso("Você não está no horário definido pelo gerente.");
				return "prepara";
			}
			usuario.setNick(usuario.getNick().substring("MOZART_".length()));

			UsuarioSessionEJB sessao = new UsuarioSessionEJB();

			sessao.setUsuarioEJB(usuario);
			sessao.setSessionId(this.request.getSession().getId());

			this.request.getSession().setAttribute("USER_SESSION", sessao);

			this.request.getSession().setAttribute(
					"USER_SESSION_NIVEL",
					usuario.getNivel() == null ? "" : usuario.getNivel()
							.toString());

			MenuMozartWebUsuarioEJB telefonia = new MenuMozartWebUsuarioEJB();
			telefonia.setIdMenuItem(ID_MENU_ICONE_TELEFONIA);
			if (usuario.getMenuMozartWebUsuarioEJBList().contains(telefonia)) {
				this.request.getSession().setAttribute("LANCA_TELEFONIA",
						"true");
			}
			List<MozartComboWeb> listaConfirmacao = new ArrayList();
			listaConfirmacao.add(new MozartComboWeb("S", "Sim"));
			listaConfirmacao.add(new MozartComboWeb("N", "Não"));
			this.request.getSession().setAttribute("LISTA_CONFIRMACAO",
					listaConfirmacao);

			List<MensagemWebUsuarioEJB> mensagens = SistemaDelegate.instance()
					.pesquisarMensagens(getUserSession().getUsuarioEJB());
			this.request.getSession().setAttribute("listMensagem", mensagens);
			this.request.getSession().setAttribute("POSSUI_MENSAGEM_URGENTE",
					"N");
			for (MensagemWebUsuarioEJB msg : mensagens) {
				if (new Long(3L).equals(msg.getMensagemWeb().getNivel())) {
					this.request.getSession().setAttribute(
							"POSSUI_MENSAGEM_URGENTE", "S");
					break;
				}
			}
			if (usuario.getCrsEJB() != null) {
				HotelEJB hotelCRS = null;
				for (CentralReservasHotelEJB crsHotel : usuario.getCrsEJB()
						.getCentralReservasHotel()) {
					if ("S".equals(crsHotel.getAtivo())) {
						hotelCRS = crsHotel.getHotelEJB();
						break;
					}
				}
				ControlaDataEJB controladata = UsuarioDelegate.instance()
						.obterControlaData(hotelCRS.getIdHotel());
				if (controladata.getFrontOffice() == null) {
					controladata.setFrontOffice(MozartUtil.now());
				}
				this.request.getSession().setAttribute("HOTEL_SESSION",
						hotelCRS);
				this.request.getSession().setAttribute("CONTROLA_DATA_SESSION",
						controladata);
				this.request.getSession().setAttribute("imagemHotel",
						hotelCRS.getEnderecoLogotipo());
				this.request.getSession().setAttribute("nomeHotel",
						hotelCRS.getNomeFantasia());
				this.request.getSession().setAttribute("USER_ADMIN", "FALSE");
				this.request.getSession().setAttribute("USER_CRS", "TRUE");
				this.request.getSession().setAttribute("CRS_SESSION_NAME",
						usuario.getCrsEJB());

				return "sucessoCRS";
			}
			if (usuario.getRedeHotelEJB() == null) {
				ControlaDataEJB controladata = UsuarioDelegate.instance()
						.obterControlaData(usuario.getHotelEJB().getIdHotel());
				if (controladata.getFrontOffice() == null) {
					controladata.setFrontOffice(MozartUtil.now());
				}
				this.request.getSession().setAttribute("HOTEL_SESSION",
						usuario.getHotelEJB());
				this.request.getSession().setAttribute("CONTROLA_DATA_SESSION",
						controladata);
				this.request.getSession().setAttribute("imagemHotel",
						usuario.getHotelEJB().getEnderecoLogotipo());
				this.request.getSession().setAttribute("nomeHotel",
						usuario.getHotelEJB().getNomeFantasia());
				this.request.getSession().setAttribute("USER_ADMIN", "FALSE");
			} else {
				this.request.getSession().setAttribute("USER_ADMIN", "TRUE");
				this.request.getSession().setAttribute("SHOW_LISTA", "TRUE");

				CentralReservaEJB crsPropria = CrsDelegate.instance()
						.obterCrsPropria(usuario.getRedeHotelEJB());
				usuario.getRedeHotelEJB().setCrsPropria(crsPropria);

				this.request.getSession().setAttribute("CRS_SESSION_NAME",
						crsPropria);
				this.request.getSession().setAttribute("CRS_PROPRIA", "TRUE");
				if (MozartUtil.isNull(usuario.getHotelEJB())) {
					HotelEJB hotel = (HotelEJB) usuario.getRedeHotelEJB()
							.getHoteis().get(0);
					this.request.getSession().setAttribute("HOTEL_SESSION",
							hotel);
					ControlaDataEJB controladata = UsuarioDelegate.instance()
							.obterControlaData(hotel.getIdHotel());
					if (controladata.getFrontOffice() == null) {
						controladata.setFrontOffice(MozartUtil.now());
					}
					this.request.getSession().setAttribute(
							"CONTROLA_DATA_SESSION", controladata);
					this.request.getSession().setAttribute("imagemHotel",
							hotel.getEnderecoLogotipo());
					this.request.getSession().setAttribute("nomeHotel",
							hotel.getNomeFantasia());
				} else {
					this.request.getSession().setAttribute("imagemHotel",
							usuario.getHotelEJB().getEnderecoLogotipo());
					this.request.getSession().setAttribute("nomeHotel",
							usuario.getHotelEJB().getNomeFantasia());
					ControlaDataEJB controladata = UsuarioDelegate.instance()
							.obterControlaData(
									usuario.getHotelEJB().getIdHotel());

					this.request.getSession().setAttribute("HOTEL_SESSION",
							usuario.getHotelEJB());
					this.request.getSession().setAttribute(
							"CONTROLA_DATA_SESSION", controladata);
					this.request.getSession().setAttribute("USER_ADMIN",
							"FALSE");
				}
			}
			HotelEJB hotelRestaurante = PdvDelegate.instance()
					.getHotelPorRestaurante(getHotelCorrente().getIdHotel());
			this.request.getSession().setAttribute(HOTEL_RESTAURANTE_SESSION, hotelRestaurante);
			
			Long idProgramaHotel = getHotelCorrente().getIdPrograma();
			Long idProgramaRede = getHotelCorrente().getIdPrograma() + 1;
			List<Long> listIdPrograma = new ArrayList<Long>();
			
			listIdPrograma.add(idProgramaHotel);
			listIdPrograma.add(idProgramaRede);
			if(usuario.getIdUsuario() == 2)
				listIdPrograma.add(3L);
			
			if(usuario.getNomeFotografia() != null){
				String fotoStr = new String(new AwsFileUtilities().getFileBase64(config.getBucket(), "fotosUsuarios/"+usuario.getNomeFotografia()));
				request.getSession().setAttribute( MozartConstantesWeb.IMG_FOTO_USUARIO, fotoStr);
			}
			
			this.request.getSession().setAttribute(ID_PROGRAMA_LIST, listIdPrograma);
			info("Usuário logado");

			return "sucesso";
		} catch (Exception ex) {
			addMensagemErro("Erro ao autenticar usuário.");
			error(ex.getMessage());
		}
		return "prepara";
	}

	public String preparar() {
		prepararLogin();
		this.request.getSession().invalidate();
		return "prepara";
	}

	public void setLogin(String login) {
		this.login = login;
	}

	public String getLogin() {
		return this.login;
	}

	public void setSenha(String senha) {
		this.senha = senha;
	}

	public String getSenha() {
		return this.senha;
	}

	public String getImgBase() {
		return imgBase;
	}

	public void setImgBase(String imgBase) {
		this.imgBase = imgBase;
	}

	public String getCssColor() {
		return cssColor;
	}

	public void setCssColor(String cssColor) {
		this.cssColor = cssColor;
	}
	
}